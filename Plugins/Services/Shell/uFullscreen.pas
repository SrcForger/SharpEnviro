unit uFullscreen;

interface

uses  Windows, Classes, SysUtils, ExtCtrls,
      MonitorList,
      SharpApi,
      uSystemFuncs;

type
  TActiveWnd = record
    monitorID: integer;
    wnd: HWND;
  end;

  TFullscreenWnd = record
    monitorID: integer;
    wnd: HWND;
    MonitorChanged: Boolean;
    ForceFull: Boolean;
  end;

  TFullscreenChecker = class
  private
    FCheckTimer: TTimer;
    
    FActiveWnds: array of TActiveWnd;
    FFullscreenWnds: array of TFullscreenWnd;

  protected
    procedure OnTimer(Sender: TObject);
    procedure CheckFullscreenWindow;

    procedure SetActiveWnd(wnd: HWND);

  public
    constructor Create;
    destructor Destroy; override;

    procedure ResetMonitor(monitorID: integer; monitorChanged: Boolean = false);
    procedure CheckMonitor(monitorID: integer);
    
    property ActiveWnd: HWND write SetActiveWnd;

  end;

implementation        
constructor TFullscreenChecker.Create;
var
  i : integer;
begin
  FCheckTimer := TTimer.Create(nil);
  FCheckTimer.Enabled := False;
  FCheckTimer.Interval := 100;
  FCheckTimer.OnTimer := OnTimer;

  SetLength(FActiveWnds, MonList.MonitorCount);
  for i := 0 to High(FActiveWnds) do
  begin
    FActiveWnds[i].wnd := 0;
    FActiveWnds[i].monitorID := MonList.Monitors[i].MonitorNum;
  end;

  SetLength(FFullscreenWnds, MonList.MonitorCount);
  for i := 0 to High(FFullscreenWnds) do
  begin
    FFullscreenWnds[i].wnd := 0;
    FFullscreenWnds[i].monitorID := -1;
    FFullscreenWnds[i].MonitorChanged := False;
    FFullscreenWnds[i].ForceFull := False;
  end;

  FCheckTimer.Enabled := True;
end;

destructor TFullscreenChecker.Destroy;
var
  i: integer;
begin
  FreeAndNil(FCheckTimer);

  SetLength(FActiveWnds, 0);
  SetLength(FFullscreenWnds, 0);

  // Show the bars again, or they won't be able to show
  for i := 0 to MonList.MonitorCount - 1 do
    SharpApi.SharpEBroadCast(WM_ENTERFULLSCREEN, 0, MonList.Monitors[i].MonitorNum, True, True);

  inherited;
end;

procedure TFullscreenChecker.SetActiveWnd(wnd: HWND);
var
  i: integer;
  wndMon: TMonitorItem;
begin
  if Length(FActiveWnds) <> MonList.MonitorCount then
  begin
    SetLength(FActiveWnds, MonList.MonitorCount);
    for i := 0 to High(FActiveWnds) do
    begin
      FActiveWnds[i].wnd := 0;
      FActiveWnds[i].monitorID := MonList.Monitors[i].MonitorNum;
    end;
  end;

  wndMon := MonList.MonitorFromWindow(wnd);
  if wndMon <> nil then
  begin
    for i := 0 to High(FActiveWnds) do
    begin
      if wndMon.MonitorNum = FActiveWnds[i].monitorID then
      begin
        FActiveWnds[i].wnd := wnd;
        break;
      end;
    end;
  end;
end;

procedure TFullscreenChecker.ResetMonitor(monitorID: integer; monitorChanged: Boolean);
var
  i : integer;
begin
  for i := Low(FFullscreenWnds) to High(FFullscreenWnds) do
  begin
    if FFullscreenWnds[i].monitorID = monitorID then
    begin
      FFullscreenWnds[i].monitorID := -1;
      FFullscreenWnds[i].wnd := 0;
      FFullscreenWnds[i].MonitorChanged := monitorChanged;
      FFullscreenWnds[i].ForceFull := False;
    end;
  end;
end;

procedure TFullscreenChecker.CheckMonitor(monitorID: integer);
var
  i : integer;
begin
  for i := 0 to High(FActiveWnds) do
    if FActiveWnds[i].monitorID = monitorID then
      FFullscreenWnds[i].ForceFull := HasFullscreenWindow(MonList.Monitors[i], false) <> 0;
end;

procedure TFullscreenChecker.CheckFullscreenWindow;
var
  i, j: integer;
  wndItem: HWND;
  fullMon, activeMon: TMonitorItem;
begin
  // Check if monitor count has changed
  if Length(FFullscreenWnds) <> MonList.MonitorCount then
  begin
    // Reset all fullscreen windows
    // [TODO: Reset only the ones that are no longer part of any monitor]
    SetLength(FFullscreenWnds, MonList.MonitorCount);
    for i := 0 to High(FFullscreenWnds) do
    begin
      FFullscreenWnds[i].wnd := 0;
      FFullscreenWnds[i].monitorID := -1;
    end;

    SetLength(FActiveWnds, MonList.MonitorCount);
    for i := 0 to High(FActiveWnds) do
    begin
      FActiveWnds[i].wnd := 0;
      FActiveWnds[i].monitorID := MonList.Monitors[i].MonitorNum;
    end;
  end;

  // Check if the active windows have moved to another monitor
  for i := 0 to High(FActiveWnds) do
  begin
    activeMon := MonList.MonitorFromWindow(FActiveWnds[i].wnd);

    if (IsWindow(FActiveWnds[i].wnd)) and (activeMon <> nil) and (FActiveWnds[i].monitorID <> activeMon.MonitorNum) then
    begin
      ResetMonitor(activeMon.MonitorNum, True);
      ResetMonitor(FActiveWnds[i].monitorID);

      for j := 0 to High(FActiveWnds) do
      begin
        if FActiveWnds[j].monitorID = activeMon.MonitorNum then
        begin
          FActiveWnds[j].wnd := FActiveWnds[i].wnd;
          FFullscreenWnds[i].ForceFull := HasFullscreenWindow(MonList.Monitors[i], false) <> 0;
        end;
      end;

      FActiveWnds[i].wnd := 0;
    end;
  end;

  // Fullscreen check
  for i := 0 to MonList.MonitorCount - 1 do
  begin
    if  (FFullscreenWnds[i].wnd <> 0) then
    begin
      fullMon := MonList.MonitorFromWindow(FFullscreenWnds[i].wnd);

      // Check if saved fullscreen window still is fullscreen
      if (fullMon <> nil) then
      begin
        if  (IsWindowFullscreen(FFullscreenWnds[i].wnd, nil, FFullscreenWnds[i].wnd)) and
            ((fullMon.MonitorNum <> FActiveWnds[i].monitorID) or
            (GetWindowThreadProcessId(FFullscreenWnds[i].wnd) = GetWindowThreadProcessId(FActiveWnds[i].wnd)))
         then
          continue;
      end;
    end;
    
    wndItem := HasFullScreenWindow(MonList.Monitors[i]);
    if (wndItem <> 0) or (FFullscreenWnds[i].ForceFull) then
    begin
      // We have fullscreen
      FFullscreenWnds[i].wnd := wndItem;
      FFullscreenWnds[i].monitorID := MonList.Monitors[i].MonitorNum;
      FFullscreenWnds[i].MonitorChanged := False;
      FFullscreenWnds[i].ForceFull := False;

      SharpApi.SharpEBroadCast(WM_ENTERFULLSCREEN, 1, MonList.Monitors[i].MonitorNum);
      SharpApi.SendDebugMessage('Shell', 'Has Fullscreen: ' + GetWndClass(wndItem), 0);
    end else if (FFullscreenWnds[i].wnd <> 0) or (FFullscreenWnds[i].MonitorChanged) then
    begin
      // Don't have fullscreen anymore
      SharpApi.SharpEBroadCast(WM_ENTERFULLSCREEN, 0, MonList.Monitors[i].MonitorNum);
      SharpApi.SendDebugMessage('Shell', 'No Fullscreen', 0);
      
      FFullscreenWnds[i].wnd := 0;
      FFullscreenWnds[i].monitorID := -1;
      FFullscreenWnds[i].MonitorChanged := False;
    end;
  end;
end;

procedure TFullscreenChecker.OnTimer(Sender: TObject);
begin
  CheckFullscreenWindow;
end;

end.
