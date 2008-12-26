{
Source Name: ShellServiceObjects
Description: Shell services objects methods
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

program SharpShellServices;

{$R *.res}
{$R SharpShellServicesCR.RES}
{$R metadata.res}

uses
  Registry,
  ActiveX,
  Messages,
  Windows,
  SysUtils,
  Classes,
  SharpApi,
  uVistaFuncs in '..\..\Common\Units\VistaFuncs\uVistaFuncs.pas';

type
  POleCmd = ^TOleCmd; //???
{$EXTERNALSYM _tagOLECMD}
  _tagOLECMD = record
    cmdID: Cardinal;
    cmdf: Longint;
  end;
  OLECMD = _tagOLECMD;
  TOleCmd = _tagOLECMD;
  POleCmdText = ^TOleCmdText; //???
  _tagOLECMDTEXT = record
    cmdtextf: Longint;
    cwActual: Cardinal;
    cwBuf: Cardinal; // size in wide chars of the buffer for text
    rgwz: array[0..0] of WideChar; // Array into which callee writes the text
  end;
  OLECMDTEXT = _tagOLECMDTEXT;
  TOleCmdText = _tagOLECMDTEXT;

  TIMOleCommandTarget = interface(IUnknown)
    ['{b722bccb-4e68-101b-a2bc-00aa00404770}']
    function QueryStatus(CmdGroup: PGUID; cCmds: Cardinal; prgCmds: POleCmd; CmdText: POleCmdText): HResult; stdcall;
    function Exec(CmdGroup: PGUID; nCmdID, nCmdexecopt: DWORD; const vaIn: OleVariant; var vaOut: OleVariant): HResult; stdcall;
  end;

  TServiceList = ^TServList;
  TServList = record
    data: TIMOLeCommandTarget;
    next: TServiceList;
  end;


const
  CGID_ShellServiceObject: TGUID = '{000214D2-0000-0000-C000-000000000046}';
  HR_UNKNOWNERROR = 1;
  HR_OK = 0;

var
  msg: TMsg;
  ListOfServices: TserviceList;
  MutexHandle: THandle;

procedure LoadShellServiceObjectsVista;
var
  //reg: Treginifile;
  list: TstringList;
  str: string;
  i: integer;
  CLSID: TCLSID;
  hr: hresult;
  dd: olevariant;
  pCmdTarget: TIMOLeCommandTarget;
  Wchar: pWideChar;
  tempList: TserviceList;
begin
  ListOfServices := new(TServiceList);
  ListOfServices.next := nil;
  list := tstringlist.create;
  //reg := TRegIniFile.Create;
  try
    wChar := Allocmem(100);
    list.add('{730F6CDC-2C86-11D2-8773-92E220524153}');
{    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\explorer\ShellServiceObjects');
    reg.GetKeyNames(list);}
    tempList := ListOfServices;
    for i := 0 to list.count - 1 do
    begin
      str := list.Strings[i];
      if str <> '' then
      begin
        hr := CLSIDFromString(StringTowidechar(str, Wchar, 100), CLSID);
        if (SUCCEEDED(hr)) then
        begin
          hr := CoCreateInstance(clsid, nil, CLSCTX_INPROC_SERVER or CLSCTX_INPROC_HANDLER, TIMOLeCommandTarget, pCmdTarget);
          dd := 0;
          if (SUCCEEDED(hr)) then
          begin
            pCmdTarget.Exec(@CGID_ShellServiceObject, 2, 0, dd, dd);
            tempList.next := new(TServiceList);
            tempList := TempList.next;
            tempList.data := pCmdTarget;
            templist.next := nil;
          end;
        end;
      end;
    end;
    freemem(WChar, 100);
    //reg.CloseKey;
  finally
    list.Free;
    //reg.Free;
  end;
end;

procedure LoadShellServiceObjects;
var
  reg: Treginifile;
  list: TstringList;
  str: string;
  i: integer;
  CLSID: TCLSID;
  hr: hresult;
  dd: olevariant;
  pCmdTarget: TIMOLeCommandTarget;
  Wchar: pWideChar;
  tempList: TserviceList;
begin
  ListOfServices := new(TServiceList);
  ListOfServices.next := nil;
  list := tstringlist.create;
  reg := TRegIniFile.Create;
  try
    wChar := Allocmem(100);
    reg.RootKey := HKEY_LOCAL_MACHINE;
    reg.OpenKeyReadOnly('\Software\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad');
    reg.GetValueNames(list);
    tempList := ListOfServices;
    for i := 0 to list.count - 1 do
    begin
      str := Reg.ReadString('', list.Strings[i], '');
      if str <> '' then
      begin
        hr := CLSIDFromString(StringTowidechar(str, Wchar, 100), CLSID);
        if (SUCCEEDED(hr)) then
        begin
          hr := CoCreateInstance(clsid, nil, CLSCTX_INPROC_SERVER,
            TIMOLeCommandTarget, pCmdTarget);
          dd := 0;
          if (SUCCEEDED(hr)) then
          begin
            pCmdTarget.Exec(@CGID_ShellServiceObject, 2, 0, dd, dd);
            tempList.next := new(TServiceList);
            tempList := TempList.next;
            tempList.data := pCmdTarget;
            templist.next := nil;
          end;
        end;
      end;
    end;
    freemem(WChar, 100);
    reg.CloseKey;
  finally
    list.Free;
    reg.Free;
  end;
end;

procedure UnloadShellServiceObjects;
var
  dd: olevariant;
  tempList, templist2: TserviceList;
begin
  try
    dd := 0;
    tempList := ListOfServices.next;
    while tempList <> nil do
    begin
      tempList2 := tempList.next;
      tempList.data.Exec(@CGID_ShellServiceObject, 3, 0, dd, dd);
      tempList.data._Release;
      tempList := tempList2;
    end;
  except
  end;
  Dispose(ListOfServices);
  ListOfServices := nil;
end;

begin
  MutexHandle := CreateMutex(nil, TRUE, 'SharpShellServicesMutex');
  if MutexHandle <> 0 then
  begin
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(MutexHandle);
      Halt;
    end
  end;

  CoInitializeEx(nil, COINIT_APARTMENTTHREADED or COINIT_DISABLE_OLE1DDE or COINIT_SPEED_OVER_MEMORY);
  LoadShellServiceObjects;
  if uVistaFuncs.IsWindowsVista then LoadShellServiceObjectsVista;

  SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));

  while GetMessage(msg, 0, 0, 0) do
  begin
    case msg.message of
         WM_ENDSESSION,WM_CLOSE,WM_QUIT: Break;
    end;
  end;

  UnLoadShellServiceObjects;
  CoUnInitialize();

  ReleaseMutex(MutexHandle);
  CloseHandle(MutexHandle);
end.
