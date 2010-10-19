{
Source Name: uTray.pas
Description: Tray classes
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

unit uTray;

interface

uses Windows, Messages, Classes, contnrs, SysUtils, ShellAPI,
     MultiMon,
     SharpAPI,
     uTypes;

type
  TTrayIcon = class
  private
  public
    data : TNotifyIconDataV7;
    hidden : boolean;
    shared : boolean;
    valid  : boolean;
    orig_icon : hicon;
    display : TTrayIcon;
  end;

  TAppBarItem = class
    Data : TAppBarMsgDataV2;
    AutoHideBar : boolean;
    constructor Create(pData : TAppBarMsgDataV2);
  end;

  TTrayManager = class(TObject)
  private
    FDllHandle : THandle;
    SHLockShared : function (Handle: THandle; DWord: DWORD): pointer; stdcall;
    SHUnlockShared : function (Pnt: Pointer): BOOL; stdcall;
  public
    Icons : TObjectList;
    AppBarList : TObjectList;
    WndList : TStringList;
    constructor Create; reintroduce;
    destructor Destroy; override;

    function FindTrayIcon(pData : TNotifyIconDataV7) : TTrayIcon;
    procedure ResetIcon(pItem : TTrayIcon);
    procedure ResetSharing(pItem : TTrayIcon);
    procedure RemoveTrayIcon(pItem : TTrayIcon);
    procedure ModifyTrayIcon(pItem : TTrayIcon; pData : TNotifyIconDataV7; Hidden,Shared : boolean; Action : integer);
    procedure UpdateTrayVersion(pItem : TTrayIcon; pData : TNotifyIconDataV7);
    procedure CheckForDeadIcons;
    procedure BroadCastTrayMessage(pItem: TTrayIcon; action : integer);
    procedure BroadCastAllToOne(wnd : hwnd);
    function GetAppBarItem(pWnd : hwnd) : TAppBarItem;
    function GetAutoHideAppBar(pEdge : Cardinal) : TAppBarItem;
    function HandleAppBarMessage(msg : TAppBarMsgDataV2; lparam : dword) : integer;
    function LockAppBarMemory(abmd: TAppBarMsgDataV2): pAppBarDataV1;
    function UnLockAppBarMempory(Pnt: pAppBarDataV1): boolean;
  end;

var
  TrayManager : TTrayManager;

implementation

uses uDeskArea, uWindows;

{ TTrayManager }

procedure TTrayManager.BroadCastAllToOne(wnd: hwnd);
var
  n : integer;
  cds: TCopyDataStruct;
  pItem : TTrayIcon;
begin
  if not IsWindow(wnd) then exit;

  CheckForDeadIcons;

  if Icons.Count = 0 then exit;

  for n := 0 to Icons.Count -1 do
  begin
    pItem := TTrayIcon(Icons.Items[n]);
    if pItem.valid then
    begin
      with cds do
      begin
        dwData := 1;
        cbData := SizeOf(TNotifyIconDataV7);
        lpData := @pItem.data;
      end;
    end;

    // forward the tray message
    SendMessage(wnd,WM_COPYDATA,0,Cardinal(@cds));
  end;
end;

procedure TTrayManager.BroadCastTrayMessage(pItem: TTrayIcon;
  action: integer);
var
  n : integer;
  wnd : hwnd;
  cds: TCopyDataStruct;
begin
  // no tray registered -> exit
  if WndList.Count = 0 then exit;

  n := WndList.Count -1;
  while n>=0 do
  begin
    try
      wnd := StrToInt64(WndList[n]);
    except
      wnd := 0;
    end;

    // window doesn't exist anymore -> delete it
    if not IsWindow(wnd) then
    begin
      WndList.Delete(n);
      n := n - 1;
      Continue;
    end;

    with cds do
    begin
      // action:
      // 1 = add/modify
      // 2 = delete
      dwData := action;
      cbData := SizeOf(TNotifyIconDataV7);
      lpData := @pItem.data;
    end;

    // forward the tray message
    SendMessage(wnd,WM_COPYDATA,0,Cardinal(@cds));
    n := n -1;
  end;
end;

constructor TTrayManager.Create;
begin
  inherited Create;

  Icons := TObjectList.Create;
  Icons.OwnsObjects := True;
  Icons.Clear;
  AppBarList := TObjectList.Create;
  AppBarList.OwnsObjects := True;
  AppBarList.Clear;
  WndList := TStringList.Create;
  WndList.Duplicates := dupIgnore;
  WndList.Clear;

  FDllHandle := LoadLibrary('SHLWAPI.DLL');
  if FDllHandle <> 0 then
  begin
    @SHLockShared := GetProcAddress(FDllHandle, PChar(8));
    @SHUnLockShared := GetProcAddress(FDllHandle, PChar(9));
  end;
end;

procedure TTrayManager.CheckForDeadIcons;
var
  pItem : TTrayIcon;
  n : integer;
begin
  if Icons.Count = 0 then exit;

  for n := Icons.Count - 1 downto 0 do
  begin
    pItem := TTrayIcon(Icons.Items[n]);
    if not IsWindow(pItem.data.Wnd) then
    begin
      BroadCastTrayMessage(pItem,2);
      reseticon(pItem);
      Icons.Remove(pItem);
    end;
  end;
end;

destructor TTrayManager.Destroy;
begin
  WndList.Free;
  WndList := nil;
  Icons.Clear;
  Icons.Free;
  AppBarList.Clear;
  AppBarList.Free;

  if FDllHandle <> 0 then
  begin
    FreeLibrary(FDllHandle);
    FDllHandle := 0;
    SHLockShared := nil;
    SHUnlockShared := nil;
  end;

  inherited Destroy;
end;

function TTrayManager.FindTrayIcon(pData: TNotifyIconDataV7): TTrayIcon;
var
  n : integer;
  pItem : TTrayIcon;
begin
  for n := 0 to Icons.Count - 1 do
  begin
    pItem := TTrayIcon(Icons.Items[n]);
    if (pItem.data.Wnd = pData.Wnd) and
       (pItem.data.uID = pData.uID) then
    begin
      result := pItem;
      exit;
    end;
  end;
  result := nil;
end;

function TTrayManager.GetAppBarItem(pWnd: hwnd): TAppBarItem;
var
  n : integer;
begin
  result := nil;
  for n := 0 to AppBarList.Count - 1 do
    if TAppBarItem(AppBarList[n]).Data.abd.Wnd = pWnd then
    begin
      result := TAppBarItem(AppBarList[n]);
      exit;
    end;
end;

function TTrayManager.GetAutoHideAppBar(pEdge: Cardinal): TAppBarItem;
var
  n : integer;
begin
  result := nil;
  for n := 0 to AppBarList.Count - 1 do
    if ((TAppBarItem(AppBarList[n]).AutoHideBar) and (TAppBarItem(AppBarList[n]).Data.abd.uEdge = pEdge)) then
    begin
      result := TAppBarItem(AppBarList[n]);
      exit;
    end;
end;

function TTrayManager.HandleAppBarMessage(msg: TAppBarMsgDataV2; lparam : dword): integer;
var
  phandle : pAppBarDataV1;
  shellwndrect : TRect;
  shellwndmon : HMonitor;
  shellwndmoninfo : TMonitorInfo;
  ABItem : TAppBarItem;
  mon : HMonitor;
  moninfo : TMonitorInfo;
begin
  result := 0;
  case msg.dwMessage of
    // Retrieves the autohide and always-on-top states of the Windows taskbar.
    ABM_GETSTATE: result := 0; // Taskbar is neither in autohide nor always-on-top state

    // Registers a new appbar
    ABM_NEW: begin
      ABItem := TAppBarItem.Create(msg); // Create new app bar item;
      AppBarList.Add(ABItem);
      result := 1;
    end;

    // Registers or unregisters an autohide appbar for an edge of the screen.
    ABM_SETAUTOHIDEBAR: begin
      ABItem := GetAppBarItem(msg.abd.Wnd);
      if ABItem <> nil then
      begin
        if lparam = 0 then // unregister
        begin
          AppBarList.Remove(ABItem);
          result := 1;
        end else // register
        begin
          if GetAutoHideAppBar(msg.abd.uEdge) = nil then // register new
          begin
            ABItem.Data.abd.uEdge := msg.abd.uEdge;
            ABItem.AutoHideBar := True;
            result := 1;
          end else result := 0; // there is already an auto hide bar at this edge
        end;
      end;
    end;

    // Retrieves the handle to the autohide appbar associated with an edge of the screen.
    ABM_GETAUTOHIDEBAR: begin
      ABItem := GetAutoHideAppBar(msg.abd.uEdge);
      if ABItem <> nil then
        result := ABItem.Data.abd.Wnd
      else result := 0;
    end;

    // Notifies the system that an appbar has been activated.
    ABM_ACTIVATE: begin
      result := 1; // always return true
    end;

    // Unregisters an appbar by removing it from the system's internal list.
    ABM_REMOVE: begin
      ABItem := GetAppBarItem(msg.abd.Wnd);
      if ABItem <> nil then
      begin
        AppBarList.Remove(ABItem);
        if DeskAreaManager <> nil then
          DeskAreaManager.SetDeskArea;
      end;
      result := 1; // always return true
    end;

    // Sets the autohide and always-on-top states of the Microsoft Windows taskbar.
    ABM_SETSTATE: begin // we ignore this messages... 
      result := 1; // always return true
    end;

    // Notifies the system when an appbar's position has changed
    ABM_WINDOWPOSCHANGED: begin
      result := 1; // always return true
    end;

    // Requests a size and screen position for an appbar
    ABM_QUERYPOS,ABM_SETPOS: begin
      ABItem := GetAppBarItem(msg.abd.Wnd);
      if ABItem <> nil then
      begin
        ABItem.Data.abd.uEdge := msg.abd.uEdge;
        ABItem.Data.abd.rc := msg.abd.rc;        
        phandle := LockAppBarMemory(msg);
        if phandle <> nil then
        begin
          mon := MonitorFromWindow(phandle.Wnd, MONITOR_DEFAULTTONEAREST);
          moninfo.cbSize := SizeOf(moninfo);
          GetMonitorInfo(mon, @moninfo);
          if phandle.rc.Top < moninfo.rcWork.Top then
            phandle.rc.Top := moninfo.rcWork.Top;
          if phandle.rc.Bottom > moninfo.rcWork.Bottom then
            phandle.rc.Bottom := moninfo.rcWork.Bottom;
          ABItem.Data.abd.rc := phandle.rc;
          UnLockAppBarMempory(phandle);
        end;
      end;
      result := 1; // always return true
      if msg.dwMessage = ABM_SETPOS then
        if DeskAreaManager <> nil then
          DeskAreaManager.SetDeskArea;
    end;

    // Retrieves the bounding rectangle of the Windows taskbar
    ABM_GETTASKBARPOS: begin
      phandle := LockAppBarMemory(msg);
      if phandle <> nil then
      begin
        result := 1;
        if WindowsClass.TrayNotifyWnd <> 0 then
        begin
          GetWindowRect(WindowsClass.TrayNotifyWnd,phandle.rc);
          GetWindowRect(WindowsClass.ShellTrayWnd,shellwndrect);
          shellwndmon := MonitorFromWindow(WindowsClass.ShellTrayWnd, MONITOR_DEFAULTTONEAREST);
          shellwndmoninfo.cbSize := SizeOf(shellwndmoninfo);
          GetMonitorInfo(shellwndmon, @shellwndmoninfo);
          if shellwndrect.Top < shellwndmoninfo.rcMonitor.Top
             + (shellwndmoninfo.rcMonitor.Bottom - shellwndmoninfo.rcMonitor.Top) div 2 then
            phandle.uEdge := ABE_TOP
          else phandle.uEdge := ABE_BOTTOM;
          phandle.rc := shellwndrect;
        end;
        UnLockAppBarMempory(phandle);
      end;
    end;
  end;
end;

function TTrayManager.LockAppBarMemory(abmd: TAppBarMsgDataV2): pAppBarDataV1;
begin
  if (abmd.hSharedMemory <> 0) and (@SHLockShared <> nil) and (@SHUnLockShared <> nil) then
    result := pAppBarDataV1(SHLockShared(abmd.hSharedMemory,abmd.dwSourceProcessID))
  else result := nil;
end;

procedure TTrayManager.ModifyTrayIcon(pItem: TTrayIcon;
  pData: TNotifyIconDataV7; Hidden, Shared: boolean; Action: integer);
var
  n : integer;
  tempItem : TTrayIcon;
  foundshared : boolean;
begin
  if pItem = nil then
  begin
    pItem := TTrayIcon.Create;
    pItem.data.Wnd := pData.Wnd;
    pItem.data.uID := pdata.uID;
    pItem.data.Union.uVersion := 0;
    Icons.Add(pItem);
  end;
  pItem.data.uFlags := pData.uFlags;
  pItem.data.cbSize := pData.cbSize;

  if (pData.uFlags and NIF_MESSAGE) = NIF_MESSAGE then
     pItem.data.uCallbackMessage := pData.uCallbackMessage;

  if (pData.uFlags and NIF_TIP) = NIF_TIP then
  begin
    pItem.data.szTip := pData.szTip;
  end else
  if (pData.uFlags and NIF_INFO) = NIF_INFO then
  begin
    pItem.data.szInfo := pData.szInfo;
    pItem.data.szInfoTitle := pData.szInfoTitle;
    pItem.data.dwInfoFlags := pData.dwInfoFlags;
  end;

  foundshared := False;
  if (pData.uFlags and NIF_ICON) = NIF_ICON then
  begin
    ResetIcon(pItem);
    if pData.Icon <> 0 then
    begin
      if Shared then
      begin
        for n := Icons.Count - 1 downto 0  do
        begin
          tempItem := TTrayIcon(Icons.Items[n]);
          if (tempItem <> pItem) and
             (tempItem.hidden) and
             (not tempItem.shared) and
             (tempItem.data.Wnd = pData.Wnd) and
             (tempItem.orig_icon = pData.Icon) and
             (tempItem.data.Icon <> 0) then
          begin
            ResetSharing(tempItem);
            pItem.display := tempItem;
            pItem.data.Icon := tempItem.data.Icon;
            pItem.shared := True;
            foundshared := true;
            break;
          end;
        end;
      end;
      if not foundshared then
      begin
        pItem.data.Icon := CopyIcon(pData.Icon);
        pItem.shared := False;
      end;
      pItem.orig_icon := pData.Icon;
      pItem.hidden := hidden;
      if hidden = false then pItem.valid := true
         else pItem.valid := false;
    end;
  end;

  if pItem.valid then
     BroadCastTrayMessage(pItem,1)
     else BroadCastTrayMessage(pItem,2);
end;

procedure TTrayManager.RemoveTrayIcon(pItem: TTrayIcon);
begin
  if pItem.valid then
  begin
    BroadCastTrayMessage(pItem,2);
  end;

  if pItem.hidden then
     resetsharing(pItem);

  reseticon(pItem);
  Icons.Extract(pItem);
  pItem.Free;
end;

procedure TTrayManager.ResetIcon(pItem: TTrayIcon);
begin
  if ((not pItem.shared) and (pItem.Data.Icon <> 0)) then
     DestroyIcon(pItem.data.Icon);

  pItem.display := nil;
  pItem.orig_icon := 0;
  pItem.data.Icon := 0;
  pItem.valid := False;
end;

procedure TTrayManager.ResetSharing(pItem: TTrayIcon);
var
  n : integer;
  tempItem : TTrayIcon;
begin
  for n := 0 to Icons.Count - 1 do
  begin
    tempItem := TTrayIcon(Icons.Items[n]);
    if tempItem.display = pItem then
       resetIcon(tempItem);
  end;
end;

function TTrayManager.UnLockAppBarMempory(Pnt: pAppBarDataV1): boolean;
begin
 if (Pnt <> nil) and (@SHUnLockShared <> nil) then
    result := SHUnLockShared(Pnt)
    else result := False;
end;

procedure TTrayManager.UpdateTrayVersion(pItem: TTrayIcon;
  pData: TNotifyIconDataV7);
begin
  if pItem = nil then exit;
  
  pItem.data.Union.uVersion := pData.Union.uVersion;

  if pItem.valid then
     BroadCastTrayMessage(pItem,1)
     else BroadCastTrayMessage(pItem,2);
end;

{ TAppBarItem }

constructor TAppBarItem.Create(pData: TAppBarMsgDataV2);
begin
  inherited Create;
  AutoHideBar := False;
  Data.abd.cbSize := pData.abd.cbSize;
  Data.abd.Wnd := pData.abd.Wnd;
  Data.abd.uCallBackMessage := pData.abd.uCallBackMessage;
end;

end.
