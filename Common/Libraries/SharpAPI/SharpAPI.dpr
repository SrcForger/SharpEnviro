{
Source Name: SharpApi.dpr
Description: API commands for SharpE
Copyright (C) Lee Green (Pixol) <pixol@sharpe-shell.org>
              Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

library SharpAPI;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  windows,
  messages,
  SysUtils,
  shellAPI,
  jclsysinfo,
  SimpleForms in '..\..\Units\SimpleUnits\SimpleForms.pas';

{$R *.RES}

const
  WM_SHARPTRAYMESSAGE = WM_APP + 500;
  WM_SHARPCONSOLEMESSAGE = WM_APP + 502;
  WM_SHARPBARMESSAGE = WM_APP + 505;
  WM_SHARPEACTIONMESSAGE = WM_APP + 520;
  WM_SHARPEUPDATEACTIONS = WM_APP + 521;

  WM_WEATHERUPDATE = WM_APP + 540;

  WM_DISABLESHARPDESK = WM_APP + 523;
  WM_ENABLESHARPDESK = WM_APP + 524;
  WM_EDITCURRENTTHEME = WM_APP + 525;
  WM_ADDDESKTOPOBJECT = WM_APP + 526;
  WM_SHOWDESKTOPSETTINGS = WM_APP + 528;
  WM_CLOSEDESK = WM_APP + 531;
  WM_DESKEXPORTBACKGROUND = WM_APP + 532;
  WM_FORCEOBJECTRELOAD = WM_APP + 533;

  WM_SHARPTERMINATE = WM_APP + 550;

  // SharpBar (new Skin Stuff)
  WM_UPDATEBARWIDTH = WM_APP + 601;
  WM_SHARPEPLUGINMESSAGE = WM_APP + 602;
  WM_SKINCHANGED = WM_APP + 603;

  // System Tray Service
  WM_REGISTERWITHTRAY = WM_APP + 650;
  WM_UNREGISTERWITHTRAY = WM_APP + 651;

  // SharpCenter
  WM_SHARPCENTERMESSAGE = WM_APP + 660;

  HR_NORECIEVERWINDOW = 2;
  HR_UNKNOWNERROR = 1;
  HR_OK = 0;
  ARG_MODULEUPDATE = 16;

  // Service Results
  MR_STARTED = 1;
  MR_STOPPED = 0;
  MR_ERRORSTARTING = 2;
  MR_OK = 3;
  MR_INCOMPATIBLE = 4;
  MR_ERRORSTOPPING = 5;

  // Action Results
  MR_ACTIONSERVICE_NOT_AVAIL = 6;

  // message types to use with SendDebugMessageEx
  DMT_INFO = 0;
  DMT_STATUS = 1;
  DMT_WARN = 2;
  DMT_ERROR = 3;
  DMT_TRACE = 4;
  DMT_NONE = -1;

  OLD_REGPATH = 'Software\ldi\sharpe\';
  REGPATH = 'Software\SharpE-Shell\';
  SKINPATH = 'Skin';
  THEMEPATH = 'Theme';
  SCHEMEPATH = 'Scheme';
  SKINDIR = 'Skins';
  CENTERDIR = 'Center\Root';
  ICONSDIR = 'Icons';
  DEFAULTSETTINGSDIR = '#Default#';

type
  THandleArray = array of HWND;

  TColor = -$7FFFFFFF - 1..$7FFFFFFF;

  TColorSchemeEx = record
    Throbberback: Tcolor;
    Throbberdark: Tcolor;
    Throbberlight: Tcolor;
    ThrobberText: Tcolor;
    WorkAreaback: Tcolor;
    WorkAreadark: Tcolor;
    WorkArealight: Tcolor;
    WorkAreaText: Tcolor;
  end;

  TColorScheme = record
    Throbberback: Tcolor;
    Throbberdark: Tcolor;
    Throbberlight: Tcolor;
    WorkAreaback: Tcolor;
    WorkAreadark: Tcolor;
    WorkArealight: Tcolor;
  end;

  PConsoleMsg = ^TConsoleMsg;
  TConsoleMsg = record
    module: string[255];
    msg: string[255];
  end;

  PManagerCmd = ^TManagerCmd;
  TManagerCmd = record
    Command: string[255];
    Parameters: string[255];
  end;

  PHelpMsg = ^THelpMsg;
  THelpMsg = record
    Parameter: string[255]
  end;

  PActionCmd = ^TActionCmd;
  TActionCmd = record
    Command: string[255];
    hwndid: Integer;
    lparam: Integer;
  end;

  PSharpE_DataStruct = ^TSharpE_DataStruct;
  TSharpE_DataStruct = record
    Command: string[255];
    Parameter: string[255];
    Handle: Integer;
    LParam: Integer;
    RParam: Integer;

    // Optionals
    PluginID: string[255];
    Module: string[255];
    Msg: string[255];
  end;

  Const
    SCC_LOAD_SETTING = '_loadsetting';
    SCC_CHANGE_FOLDER = '_changedir';
    SCC_UNLOAD_DLL = '_unloaddll';
    SCC_LOAD_DLL = '_loaddll';

  Type
    TSCC_COMMAND_ENUM = (sccLoadSetting, sccChangeFolder, sccUnloadDll, sccLoadDll);


  TBarRect = record
              R : TRect;
              wnd : hwnd;
             end;

var
  i: integer;
  wpara: wparam;
  mess: integer;
  lpara: lparam;
  stemp: string;

function GetSharpeDirectory: PChar; forward;
function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam): integer;
  forward;

{ HELPER FUNCTIONS }

function ReadRegString(const RootKey: HKEY; const Key, Name: string): string;
var
  Size: DWORD;
  RK: DWORD;
  S: string;
  R: Longint;
  H: HKEY;
begin
  Result := '';
  RK := 0;
  Size := 0;

  R := RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_READ, H);
  if R = ERROR_SUCCESS then
  begin
    R := RegQueryValueEx(H, PChar(Name), nil, @RK, nil, @Size);
    if R = ERROR_SUCCESS then
       if RK in [REG_SZ, REG_EXPAND_SZ] then
       begin
         SetLength(S, Size);
         RegQueryValueEx(H, PChar(Name), nil, @RK, PByte(S), @Size);
         SetLength(S, StrLen(PChar(S)));
         Result := S;
       end;
    RegCloseKey(H);
  end;
end;

function CopyDir(const fromDir, toDir : String) : Boolean;
var
  fos : TSHFileOPStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir);
  end;
  result := (0 = SHFileOperation(fos));
end;

procedure RenameDir(DirFrom, DirTo : string);
var
  shellinfo : TShFileOpStruct;
begin
  with shellinfo do
  begin
    wnd    := 0;
    wFunc  := FO_RENAME;
    pFrom  := PChar(DirFrom);
    pTo    := PChar(DirTo);
    fFlags := FOF_FILESONLY or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOCONFIRMATION;
  end;
  SHFileOperation(shellinfo);
end;

{EXPORTED FUNTIONS}

function GetCenterDirectory: PChar;
var
  SharpEDir: string;
begin
  SharpEDir := GetSharpEDirectory;
  stemp := IncludeTrailingBackslash(SharpEDir) +
    IncludeTrailingBackslash(CenterDir);
  result := PChar(stemp);
end;

function ServiceStart(ServiceName: pChar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName;
    msg.Command := '_servicestart';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow(nil, 'SharpCore');
    if wnd <> 0 then
    begin
      sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function ServiceStop(ServiceName: pChar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName;
    msg.Command := '_servicestop';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow(nil, 'SharpCore');
    if wnd <> 0 then
    begin
      sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function ServiceMsg(ServiceName, Command: pChar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName + '.' + Command;
    msg.Command := '_servicemsg';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow('TSharpCoreMainWnd', nil);
    if wnd <> 0 then
    begin
      result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

{function CenterMsg(Command, Param, PluginID :PChar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TSharpE_DataStruct;
begin
  try
    //Prepare TCopyDataStruct
    msg.PluginID := Pluginid;
    msg.Command := Command;
    msg.Parameter := Param;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TSharpE_DataStruct);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow('TSharpCenterWnd', nil);
    if wnd <> 0 then
    begin
      result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;   }

function BarMsg(PluginName, Command: pChar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := Command;
    msg.Command := PluginName;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow(nil, 'SharpBar');
    if wnd <> 0 then
    begin
      result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function IsServiceStarted(ServiceName: pchar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
  tmp: Byte;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName;
    msg.Command := '_isstarted';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow('TSharpCoreMainWnd', nil);
    if wnd <> 0 then
    begin
      tmp := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      if tmp = MR_STARTED then
        result := MR_STARTED
      else
        result := MR_STOPPED;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

//////////////////////////////////////////////////
// Sends a message to SharpConsole
//////////////////////////////////////////////////

function SendConsoleMessage(msg: pChar): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  cmsg: TConsoleMsg;
begin
  try
    cmsg.msg := msg;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConsoleMsg);
      lpData := @cmsg;
    end;

    wnd := FindWindow('TSharpConsoleWnd', nil);
    if wnd <> 0 then
    begin
      SendMessage(wnd, WM_SHARPCONSOLEMESSAGE, 0, cardinal(@cds));
      Result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

//////////////////////////////////////////////////
// Sends a message to SharpConsole  (With colors)
//////////////////////////////////////////////////

function SendDebugMessage(module: pChar; msg: pChar; color: integer): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  cmsg: TConsoleMsg;
begin
  try
    if module <> '' then
      module := pchar(module + ': ')
    else
      module := ':';

    msg := pChar('<B><FONT COLOR=$B06C48>' + string(module) + '</FONT></B>' +
      string(msg));

    cmsg.module := module;
    cmsg.msg := msg;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConsoleMsg);
      lpData := @cmsg;
    end;

    wnd := FindWindow('TSharpConsoleWnd', nil);
    if wnd <> 0 then
    begin
      SendMessage(wnd, WM_COPYDATA, 0, cardinal(@cds));
      Result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
    ;
  end;
end;

function SendDebugMessageEx(module: pChar; msg: pChar; Color: TColor;
  MessageType: integer): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  cmsg: TConsoleMsg;
begin
  try
    if module <> '' then
      module := pchar(module + ': ')
    else
      module := ':';

    msg := pChar('' + string(module) + '</FONT></B>' +
      string(msg));

    cmsg.module := module;
    cmsg.msg := msg;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConsoleMsg);
      lpData := @cmsg;
    end;

    wnd := FindWindow('TSharpConsoleWnd', nil);
    if wnd <> 0 then
    begin
      SendMessage(wnd, WM_COPYDATA, MessageType, cardinal(@cds));
      Result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
    ;
  end;
end;

function SharpExecute(data: pChar): hresult;
var
  wnd: hWnd;
  n: hresult;
  bShellExecute: Boolean;
begin
  Result := HR_OK;
  try

    bShellExecute := True;
    wnd := FindWindow('TSharpCoreMainWnd', nil);
    if wnd <> 0 then
    begin
      if IsServiceStarted('exec') = MR_STARTED then
      begin
        result := ServiceMsg('exec', pchar(data));
        bShellExecute := False;
      end
      else
      begin
        n := ServiceStart('exec');
        if (n <> HR_NORECIEVERWINDOW) or (n <> HR_UNKNOWNERROR) then
        begin
          result := ServiceMsg('exec', pchar(data));
          bShellExecute := False;
        end;
      end;
    end;

    // Only try shell execute if service could not be started.
    if bShellExecute then
      result := shellexecute(0, nil, pChar(data), '',
        pchar(ExtractFilePath(data)), SW_SHOW);

  except
    result := HR_UNKNOWNERROR;
  end;
end;

function RegisterAction(ActionName: Pchar; WindowHandle: hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('actions') = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to register the Action
    Result := ServiceMsg('actions',
      pchar(Format('_registeraction,%s,Undefined,%d,%d',
      [ActionName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function RegisterActionEx(ActionName: Pchar; GroupName: Pchar; WindowHandle:
  hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('actions') = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to register the Action
    Result := ServiceMsg('actions', pchar(Format('_registeraction,%s,%s,%d,%d',
      [ActionName, GroupName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UnRegisterAction(ActionName: Pchar): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('actions') = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to unregister the Action
    Result := ServiceMsg('actions', pchar(Format('_unregisteraction,%s',
      [ActionName])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UpdateAction(ActionName: Pchar; WindowHandle: hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('Actions') = MR_STOPPED then
    begin
      Result := MR_ACTIONSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to update the Action
    Result := ServiceMsg('actions',
      pchar(Format('_updateaction,%s,Undefined,%d,%d',
      [ActionName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UpdateActionEx(ActionName, GroupName: Pchar; WindowHandle: hwnd;
  LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('Actions') = MR_STOPPED then
    begin
      Result := MR_ACTIONSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to update the Action
    Result := ServiceMsg('actions', pchar(Format('_updateaction,%s,%s,%d,%d',
      [ActionName, GroupName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam): integer;
  function EnumWindowsProc(Wnd: hwnd; param: lParam): boolean; export; stdcall;
  begin
    PostMessage(wnd, mess, wpara, lpara);
    inc(i);
    result := true;
  end;
begin
  i := 0;
  mess := msg;
  wpara := wpar;
  lpara := lpar;
  EnumWindows(@EnumWindowsProc, msg);
  result := i;
end;

function SharpCenterBroadCast(wpar: wparam; lpar: lparam): boolean;
var
  wnd: hWnd;
  MutexHandle: THandle;
begin
  Result := False;
  wpara := wpar;
  lpara := lpar;

  MuteXHandle := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpCenterMutexX');
    if MuteXHandle <> 0 then
    begin

      //Find the window
      wnd := FindWindow('TSharpCenterWnd', nil);
      if wnd <> 0 then
      begin
        Result := True;
        PostMessage(wnd, WM_SHARPCENTERMESSAGE, wpara, lpara);
      end else
        Result := False;
      CloseHandle(MuteXHandle);
    end
end;

function CenterMsg(ACommand: TSCC_COMMAND_ENUM; AParam, APluginID :PChar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TSharpE_DataStruct;
  path: string;
  MutexHandle: THandle;

  sCommand: String;
begin
  Result := 0;
  wnd := 0;

  Case ACommand of
    sccLoadSetting: sCommand := SCC_LOAD_SETTING;
    sccChangeFolder: sCommand := SCC_CHANGE_FOLDER;
    sccUnloadDll: sCommand := SCC_UNLOAD_DLL;
    sccLoadDll: sCommand := SCC_LOAD_DLL;
    else
      sCommand := '';
  end;

  // Check valid command
  if sCommand = '' then begin
    SendDebugMessageEx('SharpApi', pchar(format('Config Msg Invalid: %s',
      [sCommand])), 0, DMT_INFO);
    exit;
  end;

  try

    SendDebugMessageEx('SharpApi', pchar(format('Config Msg Received: %s - %s',
      [sCommand, AParam])), 0, DMT_INFO);
    msg.Parameter := AParam;
    msg.Command := sCommand;
    msg.PluginID := APluginID;

    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TSharpE_DataStruct);
      lpData := @msg;
    end;

    MuteXHandle := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpCenterMutexX');
    if MuteXHandle <> 0 then
    begin

      //Find the window
      wnd := FindWindow('TSharpCenterWnd', nil);
      if wnd <> 0 then
      begin
        SendDebugMessageEx('SharpApi',
          pchar(format('SharpCenter Mutex Exists, Sending Msg: %s - %s',
            [sCommand, AParam])),
          0,
          DMT_STATUS);
        result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      end;
      CloseHandle(MuteXHandle);
    end
    else
    begin
      // Start the SharpCenter application
      Path := GetSharpeDirectory;

      if fileexists(Path + 'SharpCenter.exe') then
      begin
        SendDebugMessageEx('SharpApi',
          pchar(format('SharpCenter Mutex not found, Launching file: %s', [Path
            +
          'SharpCenter.exe'])), 0, DMT_STATUS);
        ShellExecute(wnd, 'open', pchar(Path + 'SharpCenter.exe'), Pchar('-api '
          +
          sCommand + ' ' + AParam), pchar(path), WM_SHOWWINDOW);
      end
      else
        SendDebugMessageEx('SharpApi',
          pchar(format('There was an error launching: %s', [Path +
          'SharpCenter.exe'])), 0, DMT_ERROR);
    end;

  except
    result := HR_UNKNOWNERROR;
  end;
end;

function SendMessageTo(WndName: string; msg: integer; wpar: wparam; lpar:
  lparam): boolean;
var
  Handle: hwnd;
begin
  Handle := FindWindow(nil, PCHar(WndName));
  if Handle <> 0 then
  begin
    SendMessage(handle, msg, wpar, lpar);
    result := True;
  end
  else
    result := False;
end;

function DirCheck(APath: string; var AResult: string): Boolean;
var
  DirCheck: array[0..6] of string;
  i: Integer;
begin
  Result := False;
  DirCheck[0] := 'SharpCore.exe';
  DirCheck[1] := 'SharpBar.exe';
  DirCheck[2] := 'SharpDesk.exe';
  DirCheck[3] := 'SharpApi.dll';
  DirCheck[4] := 'SharpDeskApi.dll';
  DirCheck[5] := 'SharpThemeApi.dll';
  DirCheck[6] := 'SharpMenu.exe';

  for i := Low(DirCheck) to High(DirCheck) do
    if FileExists(APath + DirCheck[i]) then
    begin
      AResult := APath + DirCheck[i];
      Result := True;
      Break;
    end;

end;

function GetSharpeDirectory: PChar;

var
  Path: string;
  tmp: string;
  sCheckResult: string;
begin
  Result := '';

  // Check current dir
  Path := ExtractFilePath(Application_GetExeName);
  if DirCheck(Path, sCheckResult) then
  begin
    tmp := ExtractFilePath(sCheckResult);
    stemp := tmp;
    Result := pchar(stemp);
    exit;
  end;

  // check Registry Key
  Path := ReadRegString(HKEY_CURRENT_USER,'Software\SharpE','InstallPath');
  if DirCheck(Path, sCheckResult) then
  begin
    tmp := ExtractFilePath(sCheckResult);
    stemp := tmp;
    Result := pchar(stemp);
    exit;
  end;
end;

function GetSharpeUserSettingsPath: PChar;
var
  Path: string;
  Fn: pchar;
  user: string;
  sRes: String;
begin

  // Check current directory
  User := GetLocalUserName;
  Fn := GetSharpeDirectory;
  Path := IncludeTrailingBackslash(Fn + 'Settings\User') + User;

  if not (DirectoryExists(Path)) then
  begin
    // check if the default settings dir exists
    if DirectoryExists(Fn + 'Settings\'+DEFAULTSETTINGSDIR) then
    begin
      CopyDir(Fn + 'Settings\'+DEFAULTSETTINGSDIR,Fn + 'Settings\User\');
      RenameDir(Fn + 'Settings\User\'+DEFAULTSETTINGSDIR,Fn + 'Settings\User\'+User);
    end else
    begin
      DirCheck(Fn,sRes);

      if sRes <> '' then
         Sysutils.ForceDirectories(Path);
    end;
  end;

  stemp := IncludeTrailingBackslash(Path);
  Result := pchar(stemp);
  //SendDebugMessage('SharpApi', Result, clblack);
end;

function GetSharpeGlobalSettingsPath: PChar;
var
  Path: string;
  Fn: pchar;
  sRes: String;
begin
  // Check current directory
  Fn := GetSharpeDirectory;
  //SendDebugMessage('SharpApi Fn',Fn,clblack);

  Path := IncludeTrailingBackslash(Fn + 'Settings\Global');
  //SendDebugMessage('SharpApi Path',pchar(Path),clblack);

  if not (DirectoryExists(Path)) then begin
    DirCheck(Fn,sRes);

    if sRes <> '' then
      Sysutils.ForceDirectories(Path);
  end;

  stemp := IncludeTrailingBackslash(Path);
  //SendDebugMessage('SharpApi stemp',pchar(stemp),clblack);

  Result := pchar(stemp);
  //SendDebugMessage('SharpApi Result',Result,clblack);
end;

// function based on http://www.delphipraxis.net/post452421.html

function FindAllWindows(const WindowClass: string): THandleArray;
type
  PParam = ^TParam;
  TParam = record
    ClassName: string;
    Res: THandleArray;
  end;
var
  Rec: TParam;

  function GetWndClass(pHandle: hwnd): string;
  var
    buf: array[0..254] of Char;
  begin
    GetClassName(pHandle, buf, SizeOf(buf));
    result := buf;
  end;

  function _EnumProc(_hWnd: HWND; _LParam: LPARAM): LongBool; stdcall;
  begin
    with PParam(_LParam)^ do
    begin
      if (CompareText(GetWndClass(_hWnd), ClassName) = 0) then
      begin
        SetLength(Res, Length(Res) + 1);
        Res[Length(Res) - 1] := _hWnd;
      end;
      Result := True;
    end;
  end;

begin
  try
    Rec.ClassName := WindowClass;
    SetLength(Rec.Res, 0);
    EnumWindows(@_EnumProc, Integer(@Rec));
  except
    SetLength(Rec.Res, 0);
  end;
  Result := Rec.Res;
end;

function FindAllComponents(Component: PChar): THandleArray;
var
  sname: string;
begin
  sname := Component;
  if CompareText(sname, 'sharpdesk') = 0 then
    result := FindAllWindows('TSharpDeskMainForm')
  else if CompareText(sname, 'sharpcore') = 0 then
    result := FindAllWindows('TSharpCoreMainWnd')
  else if CompareText(sname, 'sharpbar') = 0 then
    result := FindAllWindows('TSharpBarMainForm')
  else if CompareText(sname, 'sharpconsole') = 0 then
    result := FindAllWindows('TSharpConsoleWnd')
  else if CompareText(sname, 'sharpmenu') = 0 then
    result := FindAllWindows('TSharpEMenuWnd')
  else
    result := FindAllWindows(PChar(sname));
end;

function FindComponent(Component: PChar): hwnd;
var
  sname: string;
begin
  sname := Component;
  if CompareText(sname, 'sharpdesk') = 0 then
    result := FindWindow('TSharpDeskMainForm', nil)
  else if CompareText(sname, 'sharpcore') = 0 then
    result := FindWindow('TSharpCoreMainWnd', nil)
  else if CompareText(sname, 'sharpbar') = 0 then
    result := FindWindow('TSharpBarMainForm', nil)
  else if CompareText(sname, 'sharpconsole') = 0 then
    result := FindWindow('TSharpConsoleWnd', nil)
  else if CompareText(sname, 'sharpmenu') = 0 then
    result := FindWindow('TSharpEMenuWnd', nil)
  else
    result := FindWindow(PChar(sname), nil);
end;

function IsComponentRunning(Component: PChar): boolean;
begin
  if FindComponent(Component) <> 0 then
    result := true
  else
    result := false;
end;

function CloseComponent(Component: PChar): boolean;
var
  wndlist: THandleArray;
  n: integer;
begin
  wndlist := FindAllComponents(Component);

  for n := 0 to High(wndlist) do
  begin
    SendMessage(wndlist[n], WM_SHARPTERMINATE, 0, 0);
    PostMessage(wndlist[n], WM_CLOSE, 0, 0);
    PostThreadMessage(GetWindowThreadProcessID(wndlist[n], nil), WM_QUIT, 0, 0);
  end;

  setlength(wndlist, 0);

  result := not IsComponentRunning(Component);
end;

procedure TerminateComponent(Component: PChar);
var
  PID: DWord;
begin
  PID := GetPidFromProcessName(Component + '.exe');
  TerminateApp(PID, 250);
end;

procedure StartComponent(Component: PChar);
begin
  if ExtractFileExt(Component) = '.exe' then
    SharpExecute(Component)
  else
    SharpExecute(PChar(Component + '.exe'));
end;

function GetSharpBarCount : integer;
var
  ha : THandleArray;
  i : integer;
begin
  ha := FindAllWindows('TSharpBarMainForm');
  i := length(ha);
  setlength(ha,0);
  result := i;
end;

function GetSharpBarArea(Index : integer) : TBarRect;
var
  ha : THandleArray;
begin
  Index := abs(Index);
  ha := FindAllWindows('TSharpBarMainForm');
  if Index <= High(ha) then
  begin
    GetWindowRect(ha[Index],result.R);
    result.wnd := ha[Index];
  end;
  setlength(ha,0);
end;

exports
  SharpEBroadCast,
  SendDebugMessage, //Sends Message to SharpConsole
  SendDebugMessageEx,
  SendConsoleMessage, //Sends Message to SharpConsole

  // Service Exports
  ServiceMsg,
  ServiceStop,
  ServiceStart,
  IsServiceStarted,

  BarMsg,

  // Action Exports
  RegisterAction,
  RegisterActionEx,
  UnRegisterAction,
  UpdateAction,
  UpdateActionEx,

  // Bar Tool Functions
  GetSharpBarCount,
  GetSharpBarArea,

  // SharpCenter
  SharpCenterBroadCast,
  CenterMsg,
  GetCenterDirectory,

  GetSharpeDirectory,
  GetSharpeUserSettingsPath,
  GetSharpeGlobalSettingsPath,

  SendMessageTo,

  SharpExecute,

  FindComponent,
  IsComponentRunning,
  CloseComponent,
  TerminateComponent,
  StartComponent;
begin

end.

