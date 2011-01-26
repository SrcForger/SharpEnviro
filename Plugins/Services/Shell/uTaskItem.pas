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
  Classes,
  Dialogs,
  Messages,
  ShellApi,
  SysUtils,
  DateUtils,
  JclSysUtils,
  JclSysInfo,
  SharpApi,
  uSystemFuncs;

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
    FUsed     : boolean;
    FDontFreeIcon : boolean;
  public
    constructor Create(pHandle : hwnd; pListMode : Boolean = False); reintroduce; overload;
    constructor Create(pItem : TTaskItem); overload;
    destructor Destroy; override;
    procedure UpdateFromHwnd;
    procedure UpdateNonCriticalFromHwnd;
    procedure UpdateCaption;
    procedure UpdateWndClass;
    procedure UpdateVisibleState;
    procedure UpdatePlacement;
    procedure UpdateIcon;
    procedure UpdateFileInfo;
    procedure Minimize;
    procedure Restore;
    procedure Assign(pItem : TTaskItem);

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
    property Used      : boolean read FUsed write FUsed;
    property DontFreeIcon : boolean read FDontFreeIcon write FDontFreeIcon;
  end;

function SwitchToThisWindow(Wnd : hwnd; fAltTab : boolean) : boolean; stdcall; external 'user32.dll';

implementation


constructor TTaskItem.Create(pHandle : hwnd; pListMode : Boolean = False);
begin
  inherited Create;
  FHandle := pHandle;
  FIcon := 0;  
  FUsed := True;
  FDontFreeIcon := False;
  if not pListMode then
    UpdateFromHwnd
  else UpdateNonCriticalFromHwnd;
  FTimeAdded := DateTimeToUnix(Now);
  FLastVWM := SharpApi.GetCurrentVWM;
end;

procedure TTaskItem.Assign(pItem: TTaskItem);
begin
  FTimeAdded := pItem.TimeAdded;
  FHandle := pItem.Handle;
  if (FIcon <> 0) then
    DestroyIcon(FIcon);
  FIcon := pItem.Icon;
  FCaption := PWideChar(pItem.Caption);
  FWndClass := PChar(pItem.WndClass);
  FFilePath := PChar(pItem.FilePath);
  FFileName := PChar(pItem.FileName);
  FVisible := pItem.Visible;
  FLastVWM := pItem.LastVWM;
  FPlacement := pItem.Placement;
  FUsed := pItem.Used;
end;

constructor TTaskItem.Create(pItem: TTaskItem);
begin
  Assign(pItem);
end;

destructor TTaskItem.Destroy;
begin
  if (FIcon <> 0) and (not FDontFreeIcon) then
    DestroyIcon(FIcon);
    
  inherited Destroy;
end;

procedure TTaskItem.UpdateFileInfo;
begin
  FFilePath := GetProcessNameFromWnd(FHandle);
  FFileName := LowerCase(ExtractFileName(FFilePath));
end;

function GetWndIcon(wnd : hwnd) : hicon;
const
  ICON_SMALL2 = 2;
var
  icon : hicon;
begin
  icon := 0;
  try
    SendMessageTimeout(wnd, WM_GETICON, ICON_BIG, 0, SMTO_ABORTIFHUNG, 1000, DWORD(icon));

    if (icon = 0) then icon := HICON(GetClassLong(wnd, GCL_HICON));

    if (icon = 0) then SendMessageTimeout(wnd, WM_GETICON, 1, 0, SMTO_ABORTIFHUNG, 1000, DWORD(icon));
    if (icon = 0) then icon := HICON(GetClassLong(wnd, GCL_HICON));
    if (icon = 0) then SendMessageTimeout(wnd, WM_QUERYDRAGICON, 0, 0, SMTO_ABORTIFHUNG, 1000, DWORD(icon));

    // Load the icon from the executable
    if (icon = 0) then icon := ExtractIcon(SysInit.HInstance, PAnsiChar(GetProcessNameFromWnd(wnd)), 0);

    if (icon = 0) then icon := LoadIcon(0, IDI_WINLOGO);
  except
  end;
  result := icon;
end;

procedure TTaskItem.UpdateIcon;
var
  newicon : hicon;
begin
  newicon := GetWndIcon(Handle);
  if newicon <> 0 then
  begin
    if FIcon <> 0 then DestroyIcon(FIcon);  
    FIcon := newicon;
  end;
end;

procedure TTaskItem.UpdateNonCriticalFromHwnd;
begin
  UpdateVisibleState;
  UpdatePlacement;
end;

procedure TTaskItem.UpdateCaption;
var
  buf: array[0..2048] of wchar;
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

  {if  (IsWindow(FHandle)) and
      (not IsIconic(FHandle)) and
      (IsWindowEnabled(FHandle)) and
      ((GetWindowLong(FHandle, GWL_STYLE) and (WS_CAPTION or WS_SYSMENU)) = (WS_CAPTION or WS_SYSMENU))
  then
  begin }
    ShowWindow(FHandle, SW_MINIMIZE);
    UpdateCaption;
    UpdateVisibleState;
    UpdatePlacement;
  //end;
end;

procedure TTaskItem.Restore;
begin
//  if IsIconic(FHandle) then ShowWindow(FHandle, SW_Restore)
//     else OpenIcon(FHandle);
  FLastVWM := SharpApi.GetCurrentVWM;
//  if IsIconic(FHandle) then SendMessage(FHandle, WM_SYSCOMMAND, SC_RESTORE, 0)
  //   else

  if IsWindow(FHandle) then
  begin
    if (IsIconic(FHandle)) and (not IsWindowEnabled(FHandle)) then
      ShowWindowAsync(FHandle, SW_RESTORE)
    else
      SwitchToThisWindow(FHandle, True);

    UpdateCaption;
    UpdateVisibleState;
  end;
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
