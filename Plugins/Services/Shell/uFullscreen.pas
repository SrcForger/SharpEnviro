unit uFullscreen;

interface

uses  Windows, Classes, SysUtils, ExtCtrls,
      MonitorList,
      SharpApi,
      uSystemFuncs;

type
  TFullscreenWnd = record
    monitorID: integer;
    wnd: HWND;
    MonitorChanged: Boolean;
  end;

  TFullscreenChecker = class
  private
    FCheckTimer: TTimer;
    
    FActiveWnd: HWND;         // The current active (foreground) window
    FActiveMonitor: Integer;  // The monitor which the window was at when the window was activated (used to check when you move a window to another monitor)

    FFullscreenWnds: array of TFullscreenWnd;

  protected
    procedure OnTimer(Sender: TObject);
    procedure CheckFullscreenWindow;

    function GetActiveWnd: HWND;
    procedure SetActiveWnd(wnd: HWND);

  public
    constructor Create;
    destructor Destroy; override;

    procedure ResetMonitor(monitorID: integer; monitorChanged: Boolean = false);
    
    property ActiveWnd: HWND read GetActiveWnd write SetActiveWnd;

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

  FActiveWnd := 0;
  FActiveMonitor := -1;

  SetLength(FFullscreenWnds, MonList.MonitorCount);
  for i := Low(FFullscreenWnds) to High(FFullscreenWnds) do
  begin
    FFullscreenWnds[i].wnd := 0;
    FFullscreenWnds[i].monitorID := -1;
    FFullscreenWnds[i].MonitorChanged := False;
  end;

  FCheckTimer.Enabled := True;
end;

destructor TFullscreenChecker.Destroy;
var
  i: integer;
begin
  FreeAndNil(FCheckTimer);
  SetLength(FFullscreenWnds, 0);

  // Show the bars again, or they won't be able to show
  for i := 0 to MonList.MonitorCount - 1 do
    SharpApi.SharpEBroadCast(WM_ENTERFULLSCREEN, 0, MonList.Monitors[i].MonitorNum, True, True);

  inherited;
end;

function TFullscreenChecker.GetActiveWnd: HWND;
begin
  Result := FActiveWnd;
end;

procedure TFullscreenChecker.SetActiveWnd(wnd: HWND);
begin
  FActiveWnd := wnd;

  FActiveMonitor := -1;
  if MonList.MonitorFromWindow(FActiveWnd) <> nil then
    FActiveMonitor := MonList.MonitorFromWindow(FActiveWnd).MonitorNum;
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
    end;
  end;
end;

procedure TFullscreenChecker.CheckFullscreenWindow;
var
  i: integer;
  wndItem: HWND;
  fullMon, activeMon: TMonitorItem;
begin
  // Check if monitor count has changed
  if Length(FFullscreenWnds) <> MonList.MonitorCount then
  begin
    // Reset all fullscreen windows
    // [TODO: Reset only the ones that are no longer part of any monitor]
    for i := Low(FFullscreenWnds) to High(FFullscreenWnds) do
    begin
      FFullscreenWnds[i].wnd := 0;
      FFullscreenWnds[i].monitorID := -1;
    end;

    SetLength(FFullscreenWnds, MonList.MonitorCount);
  end;

  // Check if window has moved to other monitor
  if FActiveWnd <> 0 then
  begin
    activeMon := MonList.MonitorFromWindow(FActiveWnd);
    if activeMon <> nil then
    begin
      if activeMon.MonitorNum <> FActiveMonitor then
      begin
        ResetMonitor(activeMon.MonitorNum, True);
        ResetMonitor(FActiveMonitor);
        FActiveMonitor := activeMon.MonitorNum;
      end;
    end;
  end;

  // Fullscreen check
  for i := 0 to MonList.MonitorCount - 1 do
  begin
    if  (FFullscreenWnds[i].wnd <> 0) then
    begin
      fullMon := MonList.MonitorFromWindow(FFullscreenWnds[i].wnd);
      activeMon := MonList.MonitorFromWindow(FActiveWnd);

      // Check if saved fullscreen window still is fullscreen
      if (fullMon <> nil) and (activeMon <> nil) then
      begin
        // Don't ask me about this calculation, can't remember :P
        if  (IsWindowFullscreen(FFullscreenWnds[i].wnd, nil, FFullscreenWnds[i].wnd)) and
            ((fullMon.MonitorNum <> activeMon.MonitorNum) or
            (GetWindowThreadProcessId(FFullscreenWnds[i].wnd) = GetWindowThreadProcessId(FActiveWnd)))
         then
          continue;
      end;
    end;
    
    wndItem := HasFullScreenWindow(MonList.Monitors[i]);
    if wndItem <> 0 then
    begin
      // We have fullscreen
      FFullscreenWnds[i].wnd := wndItem;
      FFullscreenWnds[i].monitorID := MonList.Monitors[i].MonitorNum;
      FFullscreenWnds[i].MonitorChanged := False;

      SharpApi.SharpEBroadCast(WM_ENTERFULLSCREEN, 1, MonList.Monitors[i].MonitorNum, True, True);
      SharpApi.SendDebugMessage('Shell', 'Has Fullscreen: ' + GetWndClass(wndItem), 0);
    end else if (FFullscreenWnds[i].wnd <> 0) or (FFullscreenWnds[i].MonitorChanged) then
    begin
      // Don't have fullscreen anymore
      SharpApi.SharpEBroadCast(WM_ENTERFULLSCREEN, 0, MonList.Monitors[i].MonitorNum, True, True);
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
