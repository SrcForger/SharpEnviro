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
  Forms,
  SysUtils,
  Messages,
  Classes,
  SharpApi,
  uShutdown,
  SharpTypes,
  uSystemFuncs,
  dialogs,
  JCLLocales,
  VWMFunctions;

type
  TActionEvent = class(Tobject)
    procedure MessageHandler(var msg: TMessage);
  end;

type
  PParam = ^TParam;
  TParam = record
    wndlist: array of hwnd;
  end;

  TWndItem = record
    wnd : THandle;
    wasMinimized : boolean;
  end;
  TWndItems = array of TWndItem;

  TRunFileDlgA = procedure(hWndOwner : HWND; Icon : HICON; Directory,Title,Description : PChar; Flags : UInt); stdcall;
  TRunFileDlgW = procedure(hWndOwner : HWND; Icon : HICON; Directory,Title,Description : PWideChar; Flags : UInt); stdcall;

var
  FWndList : TWndItems;
  OwnerWnd : HWND;
  AE: TActionEvent;
  h: THandle;
  LocalsList: TJclKeyboardLayoutList;
  WindowToggle: Boolean = false;
  Param: TParam;

  hRunFileDll : THandle;
  RunFileDlgA : TRunFileDlgA;
  RunFileDlgW : TRunFileDlgW;

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

  cMinimizeAllIdx = 20;
  cRestoreAllIdx = 21;
  cToggleAllBarsIdx = 22;
  cToggleAllIdx = 23;

  cRunDlgIdx = 24;

  cMinimizeAllMonitorsIdx = 25;
  cToggleAllMonitorsIdx = 26;

  cKeyboardLayoutIdx = 99;

  RFF_NOBROWSE = 1; //Removes the browse button.
  RFF_NODEFAULT = 2; // No default item selected.
  RFF_CALCDIRECTORY = 4; // Calculates the working directory from the file name.
  RFF_NOLABEL = 8; // Removes the edit box label.
  RFF_NOSEPARATEMEM = 14; // Removes the Separate Memory Space check box (Windows NT only)

  {$R *.RES}

function SwitchToThisWindow(Wnd: hwnd; fAltTab: boolean): boolean; stdcall; external 'user32.dll';

procedure BuildWndList(var list : TWndItems; AllMonitors : Boolean = false);

  procedure AddMonitor(var list : TWndArray; Mon : TMonitor);
  var
    i : integer;
    tmp : TWndArray;
  begin
    tmp := VWMGetWindowList(Mon.BoundsRect);
    for i := 0 to High(tmp) do
    begin
      setlength(list,length(list)+1);
      list[high(list)] := tmp[i];
    end;      
  end;
var
  n : integer;
  tmpList : TWndArray;

begin
  SetLength(tmpList, 0);
  if AllMonitors then
  begin
    for n := 0 to Screen.MonitorCount - 1 do
      AddMonitor(tmpList,Screen.Monitors[n]);
  end else
    AddMonitor(tmpList,Screen.MonitorFromWindow(GetForegroundWindow));

  setlength(list, length(tmpList));
  for n := 0 to High(tmpList) do
  begin
    list[n].wnd := tmpList[n];
    list[n].wasMinimized := ((GetWindowLong(tmpList[n], GWL_STYLE) and WS_MINIMIZE) = WS_MINIMIZE);
  end;
  SetLength(tmpList, 0);
end;

procedure MinimizeAll(var WndArray: TWndItems);
var
  i: Integer;
begin
  for i := 0 to High(WndArray) do
  begin
    if not WndArray[i].wasMinimized then
      PostMessage(WndArray[i].wnd, WM_SYSCOMMAND, SC_MINIMIZE, 0);
  end;
end;

procedure RestoreAll(var WndArray: TWndItems);
var
  i: Integer;
begin
  for i := High(WndArray) downto 0 do
  begin
    if (not WndArray[i].wasMinimized) and ((GetWindowLong(WndArray[i].wnd, GWL_STYLE) and WS_MINIMIZE) = WS_MINIMIZE) then
      SendMessage(WndArray[i].wnd, WM_SYSCOMMAND, SC_RESTORE, 0);
  end;
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

  RegisterActionEx('!MinimizeAll', 'Window Management', h, cMinimizeAllIdx);
  RegisterActionEx('!RestoreAll', 'Window Management', h, cRestoreAllIdx);
  RegisterActionEx('!ToggleAll', 'Window Management', h, cToggleAllIdx);

  RegisterActionEx('!MinimizeAllMonitors', 'Window Management', h, cMinimizeAllMonitorsIdx);
  RegisterActionEx('!ToggleAllMonitors', 'Window Management', h, cToggleAllMonitorsIdx);

  RegisterActionEx('!ToggleAllBars', 'SharpBar', h, cToggleAllBarsIdx);

  RegisterActionEx('!RunDlg', 'Misc', h, cRunDlgIdx);

  RegisterKeyBoardLocals;
end;

// Service is started

function Start(owner: hwnd): hwnd;
begin
  Result := owner;
  OwnerWnd := Result;

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);

  LocalsList := TJclKeyboardLayoutList.Create;
  LocalsList.Refresh;

  RegisterActions;

  hRunFileDll := LoadLibrary('shell32.dll');
  @RunFileDlgA := GetProcAddress(hRunFileDll, PAnsiChar(MAKELPARAM(61, 0)));
  @RunFileDlgW := GetProcAddress(hRunFileDll, PAnsiChar(MAKELPARAM(61, 0)));

  ServiceDone('System Actions');
end;

// Service is stopped

procedure Stop;
begin
  SetLength(FWndList, 0);

  DeallocateHWnd(h);
  AE.Free;

  FreeLibrary(hRunFileDll);

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

  UnRegisterAction('!RunDlg');

  LocalsList.Free;
end;

procedure RunFileDlg(hOwner : HWND; Directory,Title,Description : PChar; Flags : UInt);
var
  DirectoryW,TitleW,DescriptionW: PWideChar;
begin
  if Assigned(RunFileDlgW) then
  begin
    DirectoryW := nil;
    TitleW := nil;
    DescriptionW := nil;

    try
      if Directory <> nil then
      begin
        GetMem(DirectoryW, sizeof(WideChar) * Succ(Length(Directory)));
        StringToWideChar(Directory, DirectoryW, Succ(Length(Directory)));
      end;
      if Title <> nil then
      begin
        GetMem(TitleW, sizeof(WideChar) * Succ(Length(Title)));
        StringToWideChar(Title, TitleW, Succ(Length(Title)));
      end;
      if Description <> nil then
      begin
        GetMem(DescriptionW, sizeof(WideChar) * Succ(Length(Description)));
        StringToWideChar(Description, DescriptionW, Succ(Length(Description)));
      end;

      RunFileDlgW(hOwner, 0, DirectoryW, TitleW, DescriptionW, Flags);
    finally
      if DirectoryW <> nil then
        FreeMem(DirectoryW);
      if TitleW <> nil then
        FreeMem(TitleW);
      if DescriptionW <> nil then
        FreeMem(DescriptionW);
    end;
  end else if Assigned(RunFileDlgA) then
    RunFileDlgA(hOwner, 0, Directory, Title, Description, Flags);
end;

{ TActionEvent }

procedure TActionEvent.MessageHandler(var msg: TMessage);

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
      cMinimizeAllIdx, cRestoreAllIdx, cMinimizeAllMonitorsIdx: begin
          if (lParam = cMinimizeAllIdx) or (lParam = cMinimizeAllMonitorsIdx) then
          begin
            SetLength(FWndList, 0);
            
            BuildWndList(FWndList, (lParam = cMinimizeAllMonitorsIdx));
            MinimizeAll(FWndList);
          end else
            RestoreAll(FWndList);
        end;
      cToggleAllIdx, cToggleAllMonitorsIdx: begin
          if WindowToggle then
          begin
            SetLength(FWndList, 0);

            BuildWndList(FWndList, (lParam = cToggleAllMonitorsIdx));
            MinimizeAll(FWndList);
          end else
            RestoreAll(FWndList);

          // Toggle (Show/Hide) all windows
          WindowToggle := not (WindowToggle);
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
          SetLength(BarList, 0);
          if BarHidden then
            SharpApi.SharpEBroadCast(WM_SHOWBAR, 0, 0)
          else SharpApi.SharpEBroadCast(WM_HIDEBAR, 0, 0);
          SharpApi.ServiceMsg('DeskArea', 'Update');
        end;
      cRunDlgIdx: begin
        RunFileDlg(0, nil, nil, nil, 0);
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
    Version := '0.7.6.5';
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

