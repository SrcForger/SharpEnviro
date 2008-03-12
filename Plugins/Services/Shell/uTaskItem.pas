{
Source Name: uTaskItem.pas
Description: TaskItem class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit uTaskItem;

interface

uses
  Windows,
  Dialogs,
  Messages,
  SysUtils,
  DateUtils,
  JclSysUtils,
  JclSysInfo,
  SharpApi;

type
  TTaskItem = class
              protected
                FTimeAdded : Int64;
                FHandle : hwnd;
                FIcon : hIcon;
                FCaption : WideString;
                FWndClass : String;
                FFilePath : String;
                FFileName : String;
                FVisible  : boolean;
                FLastVWM  : integer;
                FPlacement: TWindowPlacement;
              private
              public
                constructor Create(phandle : hwnd); reintroduce;
                destructor Destroy; override;
                procedure UpdateFromHwnd;
                procedure UpdateCaption;
                procedure UpdateWndClass;
                procedure UpdateVisibleState;
                procedure UpdatePlacement;
                procedure UpdateIcon;
                procedure UpdateFileInfo;
                procedure Minimize;
                procedure Restore;

                property Icon     : hIcon   read FIcon;
                property Caption  : WideString  read FCaption;
                property Handle   : hwnd    read FHandle;
                property WndClass : String  read FWndClass;
                property Visible  : boolean read FVisible;
                property Placement : TWindowPlacement read FPlacement;
                property TimeAdded : Int64  read FTimeAdded write FTimeAdded;
                property FileName  : String read FFileName;
                property FilePath  : String read FFilePath;
                property LastVWM   : integer read FLastVWM write FLastVWM;
              end;

function SwitchToThisWindow(Wnd : hwnd; fAltTab : boolean) : boolean; stdcall; external 'user32.dll';

implementation


constructor TTaskItem.Create(phandle : hwnd);
begin
  inherited Create;
  FHandle := phandle;
  UpdateFromHwnd;
  FTimeAdded := DateTimeToUnix(Now);
  FLastVWM := SharpApi.GetCurrentVWM;
end;

destructor TTaskItem.Destroy;
begin
  inherited Destroy;
end;

procedure TTaskItem.UpdateFileInfo;
begin
  FFilePath := GetProcessNameFromWnd(FHandle);
  FFileName := LowerCase(ExtractFileName(FFilePath));
end;

procedure TTaskItem.UpdateIcon;
const
  ICON_SMALL2 = 2;
var
  newicon : hicon;
begin
  newicon := 0;
  if FIcon <> 0 then DestroyIcon(FIcon);
  try
    SendMessageTimeout(Handle, WM_GETICON, 0, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));

    if (newicon = 0) then newicon := HICON(GetClassLong(Handle, GCL_HICON));

    if (newicon = 0) then SendMessageTimeout(Handle, WM_GETICON, 1, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));
    if (newicon = 0) then newicon := HICON(GetClassLong(Handle, GCL_HICON));
    if (newicon = 0) then SendMessageTimeout(Handle, WM_QUERYDRAGICON, 0, 0, SMTO_ABORTIFHUNG, 1000, DWORD(newicon));

    if (newicon = 0) then newicon := LoadIcon(0, IDI_WINLOGO);
  except
  end;
  
  if newicon <> 0 then FIcon := newicon;
end;

procedure TTaskItem.UpdateCaption;
var
  buf:Array[0..1024] of wchar;
begin
  GetWindowTextW(FHandle,@buf,sizeof(buf));
  FCaption := buf;
end;

procedure TTaskItem.UpdateWndClass;
var
  buf: array [0..254] of Char;
begin
  GetClassName(FHandle, buf, SizeOf(buf));
  FWndClass := buf;
end;

procedure TTaskItem.UpdateVisibleState;
begin
  if IsIconic(FHandle) then FVisible := False
     else FVisible := True;
end;

procedure TTaskItem.UpdateFromHwnd;
begin
  UpdateCaption;
  UpdateWndClass;
  UpdateVisibleState;
  UpdatePlacement;
  UpdateIcon;
  UpdateFileInfo;
end;

procedure TTaskItem.Minimize;
begin
  FLastVWM := SharpApi.GetCurrentVWM;
  CloseWindow(FHandle);
  UpdateCaption;
  UpdateVisibleState;
end;

procedure TTaskItem.Restore;
begin
//  if IsIconic(FHandle) then ShowWindow(FHandle, SW_Restore)
//     else OpenIcon(FHandle);
  FLastVWM := SharpApi.GetCurrentVWM;
  if IsIconic(FHandle) then SendMessage(FHandle, WM_SYSCOMMAND, SC_RESTORE, 0)
     else SwitchToThisWindow(FHandle,True);
  UpdateCaption;
  UpdateVisibleState;
end;

procedure TTaskItem.UpdatePlacement;
begin
  if IsWindow(FHandle) then
  begin
    FPlacement.length := SizeOf(TWindowPlacement);
    GetWindowPlacement(FHandle, @FPlacement);
  end;
end;


end.
