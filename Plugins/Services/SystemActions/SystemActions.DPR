{
Source Name: SystemActions.dpr
Description: System Actions Service library file
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

library SystemActions;

uses
  windows,
  SysUtils,
  Messages,
  Classes,
  SharpApi,
  uShutdown,
  SharpTypes,
  uSystemFuncs,
  dialogs,
  JCLLocales;

type
  TActionEvent = class(Tobject)
    procedure MessageHandler(var msg: TMessage);
  end;

type
  PParam = ^TParam;
  TParam = record
    wndlist: array of hwnd;
  end;

var
  AE: TActionEvent;
  h: THandle;
  LocalsList: TJclKeyboardLayoutList;
  WindowToggle: Boolean = false;
  Param: TParam;

const
  cRestartIdx = 0;
  cShutdownIdx = 1;
  cLogoutIdx = 2;
  cHibernateIdx = 3;
  cSwitchUserLock = 4;

  cRestart_QuietIdx = 10;
  cShutdown_QuietIdx = 11;
  cLogout_QuietIdx = 12;
  cHibernate_QuietIdx = 13;
  cSwitchUser_QuietLock = 14;

  cShutdownStart = 0;
  cShutdownEnd = 14;
  cShutdownNonVerbose = 10;

  cMinimiseAllIdx = 20;
  cRestoreAllIdx = 21;
  cToggleAllBarsIdx = 22;
  cToggleAllWindowsIdx = 23;

  cKeyboardLayoutIdx = 99;

  {$R *.RES}

function SwitchToThisWindow(Wnd: hwnd; fAltTab: boolean): boolean; stdcall; external 'user32.dll';

procedure MinimiseAll(var EnumParam: TParam);
var
  i: Integer;
begin
  for i := 0 to High(EnumParam.Wndlist) do
    CloseWindow(EnumParam.WndList[i]);
end;

procedure RestoreAll(var EnumParam: TParam);
var
  i: Integer;
begin
  for i := 0 to High(EnumParam.WndList) do
    if IsIconic(EnumParam.WndList[i]) then ShowWindow(EnumParam.WndList[i], SW_Restore)
    else SwitchToThisWindow(EnumParam.WndList[i], True);
end;

procedure RegisterKeyBoardLocals;
var
  n: integer;
begin
  if LocalsList.Count <= 1 then
    exit;

  RegisterActionEx(PChar('!KLCycle'), 'Keyboard Layouts', h, 99);
  for n := 0 to LocalsList.Count - 1 do
    RegisterActionEx(PChar('!KL' + LocalsList[n].DisplayName), 'Keyboard Layouts', h, 100 + n);
end;

procedure UnRegisterKeyBoardLocals;
var
  n: integer;
begin
  if LocalsList.Count <= 1 then
    exit;

  UnRegisterAction(PChar('!KLCycle'));
  for n := 0 to LocalsList.Count - 1 do
    UnRegisterAction(PChar('!KL' + LocalsList[n].DisplayName));
end;

procedure RegisterActions;
begin
  RegisterActionEx('!Restart', 'Shutdown', h, cRestartIdx);
  RegisterActionEx('!Shutdown', 'Shutdown', h, cShutdownIdx);
  RegisterActionEx('!Logout', 'Shutdown', h, cLogoutIdx);
  RegisterActionEx('!Hibernate', 'Shutdown', h, cHibernateIdx);
  RegisterActionEx('!SwitchUser/LockStation', 'Shutdown', h, cSwitchUserLock);

  RegisterActionEx('!Restart_Quiet', 'Shutdown', h, cRestart_QuietIdx);
  RegisterActionEx('!Shutdown_Quiet', 'Shutdown', h, cShutdown_QuietIdx);
  RegisterActionEx('!Logout_Quiet', 'Shutdown', h, cLogout_QuietIdx);
  RegisterActionEx('!Hibernate_Quiet', 'Shutdown', h, cHibernate_QuietIdx);

  RegisterActionEx('!MinimizeAll', 'Window Management', h, cMinimiseAllIdx);
  RegisterActionEx('!RestoreAll', 'Window Management', h, cRestoreAllIdx);
  RegisterActionEx('!ToggleAllWindows', 'Window Management', h, cToggleAllWindowsIdx);

  RegisterActionEx('!ToggleAllBars', 'SharpBar', h, cToggleAllBarsIdx);

  RegisterKeyBoardLocals;
end;

// Service is started

function Start(owner: hwnd): hwnd;
begin
  Result := owner;

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);

  LocalsList := TJclKeyboardLayoutList.Create;
  LocalsList.Refresh;

  RegisterActions;
  ServiceDone('System Actions');
end;

// Service is stopped

procedure Stop;
begin
  DeallocateHWnd(h);
  AE.Free;

  UnRegisterKeyBoardLocals;
  UnRegisterAction('!Restart');
  UnRegisterAction('!Shutdown');
  UnRegisterAction('!Logout');
  UnRegisterAction('!Hibernate');
  UnRegisterAction('!SwitchUser/LockStation');

  UnRegisterAction('!Restart_Quiet');
  UnRegisterAction('!Shutdown_Quiet');
  UnRegisterAction('!Logout_Quiet');
  UnRegisterAction('!Hibernate_Quiet');

  UnRegisterAction('!MinimizeAll');
  UnRegisterAction('!RestoreAll');
  UnRegisterAction('!ToggleAllBars');
  UnRegisterAction('!ToggleAllWindows');

  LocalsList.Free;
end;

{ TActionEvent }

procedure TActionEvent.MessageHandler(var msg: TMessage);

var
  EnumParam: TParam;

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  begin
    if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
      ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
      ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
      (GetWindowLong(Wnd, GWL_HWNDPARENT) = Integer(GetDesktopWindow))) and
      (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0)) then
      with PParam(LParam)^ do
      begin
        setlength(wndlist, length(wndlist) + 1);
        wndlist[high(wndlist)] := wnd;
      end;
    result := True;
  end;

var
  ShutDown: TSEShutdown;
  n, k, j, lParam: integer;
  BarList: THandleArray;
  BarHidden: boolean;
  AL: TJclKeyboardLayout;
begin
  if msg.Msg = WM_INPUTLANGCHANGE then
  begin
    UnRegisterKeyBoardLocals;
    LocalsList.Refresh;
    RegisterKeyBoardLocals;
  end
  else if msg.Msg = WM_SHARPEUPDATEACTIONS then
    RegisterActions
  else if msg.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    lParam := Msg.LParam;

    // Keyboard layout
    if (Msg.LParam = cKeyboardLayoutIdx) then
    begin
      k := 0;
      AL := LocalsList.ActiveLayout;
      for n := 0 to LocalsList.Count - 1 do
        if AL = LocalsList.Items[n] then
        begin
          j := n + 1;
          if j > LocalsList.Count - 1 then
            j := 0;
          SystemParametersInfo(SPI_SETDEFAULTINPUTLANG, k, @LocalsList.Items[j].Layout, SPIF_SENDCHANGE or SPIF_UPDATEINIFILE);
          PostMessage(HWND_BROADCAST, WM_INPUTLANGCHANGEREQUEST, 0, LocalsList.Items[j].Layout);
          break;
        end;
      exit;
    end else
      if (Msg.LParam > cKeyboardLayoutIdx + 1) then
      begin
        n := Msg.LParam - cKeyboardLayoutIdx + 1;
        k := 0;
        if n <= LocalsList.Count - 1 then
        begin
          SystemParametersInfo(SPI_SETDEFAULTINPUTLANG, k, @LocalsList.Items[n].Layout, SPIF_SENDCHANGE or SPIF_UPDATEINIFILE);
          PostMessage(HWND_BROADCAST, WM_INPUTLANGCHANGEREQUEST, 0, LocalsList.Items[n].Layout);
        end;
        exit;
      end;

    // The others
    case lParam of
      cShutdownStart..cShutdownEnd: begin

          ShutDown := TSEShutDown.Create(FindWindow('TSharpCoreMainWnd', nil));
          try
            case lParam of
              cRestartIdx, cRestart_QuietIdx: begin
                  ShutDown.ActionType := sdReboot;
                end;
              cShutdownIdx, cShutdown_QuietIdx: begin
                  ShutDown.ActionType := sdPowerOff;
                end;
              cLogoutIdx, cLogout_QuietIdx: begin
                  ShutDown.ActionType := sdLogOff;
                end;
              cHibernateIdx, cHibernate_QuietIdx: begin
                  ShutDown.ActionType := sdHibernate;
                end;
              cSwitchUserLock, cSwitchUser_QuietLock: begin
                  ShutDown.ActionType := sdLock;
                end;
            end;
            ShutDown.Force := True;

            // Set verbosity
            if (lParam >= cShutdownNonVerbose) then
              ShutDown.Verbose := false else
              ShutDown.Verbose := true;

            ShutDown.Execute;
          finally
            ShutDown.Free;
          end;
        end;
      cMinimiseAllIdx, cRestoreAllIdx: begin
          setlength(EnumParam.wndlist, 0);
          EnumWindows(@EnumWindowsProc, Integer(@EnumParam));

          if lParam = cMinimiseAllIdx then
            MinimiseAll(EnumParam) else
            RestoreAll(EnumParam);

          setlength(EnumParam.wndlist, 0);
        end;
      cToggleAllBarsIdx: begin
          // Toggle (Show/Hide) all bars
          BarList := FindAllWindows('TSharpBarMainForm');
          BarHidden := False;
          for n := 0 to High(BarList) do
            if not IsWindowVisible(BarList[n]) then
            begin
              BarHidden := True;
              break;
            end;
          setlength(BarList, 0);
          if BarHidden then
            SharpApi.SharpEBroadCast(WM_SHOWBAR, 0, 0)
          else SharpApi.SharpEBroadCast(WM_HIDEBAR, 0, 0);
          SharpApi.ServiceMsg('DeskArea', 'Update');
        end;
      cToggleAllWindowsIdx: begin

          setlength(EnumParam.wndlist, 0);
          EnumWindows(@EnumWindowsProc, Integer(@EnumParam));

          if WindowToggle then
            RestoreAll(EnumParam) else
            MinimiseAll(EnumParam);

          setlength(EnumParam.wndlist, 0);

          // Toggle (Show/Hide) all windows
          WindowToggle := not (WindowToggle);
        end;
    end;

  end
  else msg.Result := DefWindowProc(h, msg.Msg, Msg.WParam, msg.LParam);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'System Actions';
    Description := 'Adds a set of actions for system use (shutdown, reboot, etc.)';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteService;
    ExtraData := 'priority: 40| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  GetMetaData;

begin
end.

