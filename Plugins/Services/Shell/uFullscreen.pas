unit uFullscreen;

interface

uses  Windows, Classes, SysUtils,
      MonitorList,
      SharpApi,
      uSystemFuncs;

type
  TFullscreenWnd = record
    monitorID: integer;
    wnd: HWND;
    MonitorChanged: Boolean;
  end;

  TFullscreenThread = class(TThread)
  private
    FActiveWnd: HWND;         // The current active (foreground) window
    FActiveMonitor: Integer;  // The monitor which the window was at when the window was activated (used to check when you move a window to another monitor)

    FFullscreenWnds: array of TFullscreenWnd;

  protected
    procedure Execute; override;
    procedure CheckFullscreenWindow;

    function GetActiveWnd: HWND;
    procedure SetActiveWnd(wnd: HWND);

  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;

    procedure ResetMonitor(monitorID: integer; monitorChanged: Boolean = false);
    
    property ActiveWnd: HWND read GetActiveWnd write SetActiveWnd;

  end;

implementation

var
  critSect: TRTLCriticalSection;

constructor TFullscreenThread.Create(CreateSuspended: Boolean);
var
  i : integer;
begin
  inherited;

  FActiveWnd := 0;
  FActiveMonitor := -1;

  SetLength(FFullscreenWnds, MonList.MonitorCount);
  for i := Low(FFullscreenWnds) to High(FFullscreenWnds) do
  begin
    FFullscreenWnds[i].wnd := 0;
    FFullscreenWnds[i].monitorID := -1;
    FFullscreenWnds[i].MonitorChanged := False;
  end;
end;

destructor TFullscreenThread.Destroy;
begin
  SetLength(FFullscreenWnds, 0);

  inherited;
end;

function TFullscreenThread.GetActiveWnd: HWND;
begin
  EnterCriticalSection(critSect);
  Result := FActiveWnd;
  LeaveCriticalSection(critSect);
end;

procedure TFullscreenThread.SetActiveWnd(wnd: HWND);
begin
  EnterCriticalSection(critSect);
  FActiveWnd := wnd;

  FActiveMonitor := -1;
  if MonList.MonitorFromWindow(FActiveWnd) <> nil then
    FActiveMonitor := MonList.MonitorFromWindow(FActiveWnd).MonitorNum;
    
  LeaveCriticalSection(critSect);
end;

procedure TFullscreenThread.ResetMonitor(monitorID: integer; monitorChanged: Boolean);
var
  i : integer;
begin
  EnterCriticalSection(critSect);
  for i := Low(FFullscreenWnds) to High(FFullscreenWnds) do
  begin
    if FFullscreenWnds[i].monitorID = monitorID then
    begin
      FFullscreenWnds[i].monitorID := -1;
      FFullscreenWnds[i].wnd := 0;
      FFullscreenWnds[i].MonitorChanged := monitorChanged;
    end;
  end;
  LeaveCriticalSection(critSect);
end;

procedure TFullscreenThread.CheckFullscreenWindow;
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

procedure TFullscreenThread.Execute;
begin
  while not Terminated do
  begin
    EnterCriticalSection(critSect);
    CheckFullscreenWindow;
    LeaveCriticalSection(critSect);

    Sleep(100);
  end;
end;

initialization
  InitializeCriticalSection(critSect);

finalization
  DeleteCriticalSection(critSect);

end.
