// Content based on the TScreen class from Forms.pas
// Modified to make it more stable and fail save and to make it possible to
// manually refresh the monitor list

unit MonitorList;

interface

uses
  Windows, Classes, Types, MultiMon;

type
  TMonitorItem = class(TObject)
  private
    FHandle: HMONITOR;
    FMonitorNum: Integer;
    function GetLeft: Integer;
    function GetHeight: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    function GetBoundsRect: TRect;
    function GetWorkareaRect: TRect;
    function GetPrimary: Boolean;
  public
    property Handle: HMONITOR read FHandle;
    property MonitorNum: Integer read FMonitorNum;
    property Left: Integer read GetLeft;
    property Height: Integer read GetHeight;
    property Top: Integer read GetTop;
    property Width: Integer read GetWidth;
    property BoundsRect: TRect read GetBoundsRect;
    property WorkareaRect: TRect read GetWorkareaRect;
    property Primary: Boolean read GetPrimary;
  end;

  TMonitorDefaultTo = (mdNearest, mdNull, mdPrimary);

  TMonitorList = class
  private
    FPixelsPerInch: Integer;
    FMonitors: TList;
    procedure ClearMonitors;
    function GetDesktopTop: Integer;
    function GetDesktopLeft: Integer;
    function GetDesktopHeight: Integer;
    function GetDesktopWidth: Integer;
    function GetDesktopRect: TRect;
    function GetWorkAreaRect: TRect;
    function GetWorkAreaHeight: Integer;
    function GetWorkAreaLeft: Integer;
    function GetWorkAreaTop: Integer;
    function GetWorkAreaWidth: Integer;
    function GetHeight: Integer;
    function GetMonitor(Index: Integer): TMonitorItem;
    function GetMonitorCount: Integer;
    function GetWidth: Integer;
    function GetPrimaryMonitor: TMonitorItem;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;
    procedure GetMonitors;
    function GetMonitorIndex(pMon : TMonitorItem) : integer;
    function IsValidMonitorIndex(pIndex : integer) : boolean;
    function FindMonitor(Handle: HMONITOR): TMonitorItem;    
    function MonitorFromPoint(const Point: TPoint;
      MonitorDefault: TMonitorDefaultTo = mdNearest): TMonitorItem;
    function MonitorFromRect(const Rect: TRect;
      MonitorDefault: TMonitorDefaultTo = mdNearest): TMonitorItem;
    function MonitorFromWindow(const Handle: THandle;
      MonitorDefault: TMonitorDefaultTo = mdNearest): TMonitorItem;
    property MonitorCount: Integer read GetMonitorCount;
    property Monitors[Index: Integer]: TMonitorItem read GetMonitor;
    property DesktopRect: TRect read GetDesktopRect;
    property DesktopHeight: Integer read GetDesktopHeight;
    property DesktopLeft: Integer read GetDesktopLeft;
    property DesktopTop: Integer read GetDesktopTop;
    property DesktopWidth: Integer read GetDesktopWidth;
    property WorkAreaRect: TRect read GetWorkAreaRect;
    property WorkAreaHeight: Integer read GetWorkAreaHeight;
    property WorkAreaLeft: Integer read GetWorkAreaLeft;
    property WorkAreaTop: Integer read GetWorkAreaTop;
    property WorkAreaWidth: Integer read GetWorkAreaWidth;
    property Height: Integer read GetHeight;
    property Width: Integer read GetWidth;    
    property PrimaryMonitor: TMonitorItem read GetPrimaryMonitor;
  end;

var
  MonList : TMonitorList;

implementation

{ TMonitor }

function TMonitorItem.GetLeft: Integer;
begin
  Result := BoundsRect.Left;
end;

function TMonitorItem.GetHeight: Integer;
begin
  with BoundsRect do
    Result := Bottom - Top;
end;

function TMonitorItem.GetTop: Integer;
begin
  Result := BoundsRect.Top;
end;

function TMonitorItem.GetWidth: Integer;
begin
  with BoundsRect do
    Result := Right - Left;
end;

function TMonitorItem.GetBoundsRect: TRect;
var
  MonInfo: TMonitorInfo;
begin
  MonInfo.cbSize := SizeOf(MonInfo);
  GetMonitorInfo(FHandle, @MonInfo);
  Result := MonInfo.rcMonitor;
end;

function TMonitorItem.GetWorkareaRect: TRect;
var
  MonInfo: TMonitorInfo;
begin
  MonInfo.cbSize := SizeOf(MonInfo);
  GetMonitorInfo(FHandle, @MonInfo);
  Result := MonInfo.rcWork;
end;

function TMonitorItem.GetPrimary: Boolean;
var
  MonInfo: TMonitorInfo;
begin
  MonInfo.cbSize := SizeOf(MonInfo);
  GetMonitorInfo(FHandle, @MonInfo);
  Result := (MonInfo.dwFlags and MONITORINFOF_PRIMARY) <> 0;
end;

{ TMonitorList }

function EnumMonitorsProc(hm: HMONITOR; dc: HDC; r: PRect; Data: Pointer): Boolean; stdcall;
var
  L: TList;
  M: TMonitorItem;
begin
  L := TList(Data);
  M := TMonitorItem.Create;
  M.FHandle := hm;
  M.FMonitorNum := L.Count;
  L.Add(M);
  Result := True;
end;

procedure TMonitorList.ClearMonitors;
var
  I: Integer;
begin
  for I := 0 to FMonitors.Count - 1 do
    TMonitorItem(FMonitors[I]).Free;
  FMonitors.Clear;
end;

constructor TMonitorList.Create;
var
  DC: HDC;
begin
  inherited Create;
  FMonitors := TList.Create;
  DC := GetDC(0);
  FPixelsPerInch := GetDeviceCaps(DC, LOGPIXELSY);
  ReleaseDC(0, DC);
  EnumDisplayMonitors(0, nil, @EnumMonitorsProc, LongInt(FMonitors));
end;

destructor TMonitorList.Destroy;
var
  I: Integer;
begin
  if FMonitors <> nil then
    for I := 0 to FMonitors.Count - 1 do
      TMonitorItem(FMonitors[I]).Free;
  FMonitors.Free;
  inherited Destroy;
end;

function TMonitorList.FindMonitor(Handle: HMONITOR): TMonitorItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to MonitorCount - 1 do
    if Monitors[I].Handle = Handle then
    begin
      Result := Monitors[I];
      Exit;
    end;

 // Added code to update internal monitor-list if first try didn't give any result
  GetMonitors;
  for I := 0 to MonitorCount - 1 do
    if Monitors[I].Handle = Handle then
    begin
      Result := Monitors[I];
      exit;
    end;    
end;

function TMonitorList.GetDesktopHeight: Integer;
begin
  Result := GetSystemMetrics(SM_CYVIRTUALSCREEN);
end;

function TMonitorList.GetDesktopLeft: Integer;
begin
   Result := GetSystemMetrics(SM_XVIRTUALSCREEN);
end;

function TMonitorList.GetDesktopRect: TRect;
begin
  Result := Bounds(DesktopLeft, DesktopTop, DesktopWidth, DesktopHeight);
end;

function TMonitorList.GetDesktopTop: Integer;
begin
  Result := GetSystemMetrics(SM_YVIRTUALSCREEN);
end;

function TMonitorList.GetDesktopWidth: Integer;
begin
  Result := GetSystemMetrics(SM_CXVIRTUALSCREEN);
end;

function TMonitorList.GetHeight: Integer;
begin
  Result := GetSystemMetrics(SM_CYSCREEN);
end;

function TMonitorList.GetMonitor(Index: Integer): TMonitorItem;
begin
  if Index > FMonitors.Count - 1 then
    Result := nil
  else Result := FMonitors[Index];
end;

function TMonitorList.GetMonitorCount: Integer;
begin
  if FMonitors.Count = 0 then
    Result := GetSystemMetrics(SM_CMONITORS)
  else
    Result := FMonitors.Count;
end;

function TMonitorList.GetMonitorIndex(pMon: TMonitorItem): integer;
var
  n : integer;
begin
  for n := 0 to FMonitors.Count - 1 do
    if TMonitorItem(FMonitors[n]).Handle = pMon.Handle then
    begin
      result := n;
      exit;
    end;
  result := -1;
end;

procedure TMonitorList.GetMonitors;
begin
  ClearMonitors;
  EnumDisplayMonitors(0, nil, @EnumMonitorsProc, LongInt(FMonitors));
end;

function TMonitorList.GetPrimaryMonitor: TMonitorItem;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to MonitorCount - 1 do
  begin
    if Monitors[I].Primary then
    begin
      Result := FMonitors[I];
      Exit;
    end;
  end;
  
  { If we didn't find the primary monitor, reset the display and try
    again (it may have changeed) }
  GetMonitors;
  for I := 0 to MonitorCount - 1 do
  begin
    if Monitors[I].Primary then
    begin
      Result := FMonitors[I];
      Break;
    end;
  end;
end;

function TMonitorList.GetWidth: Integer;
begin
  Result := GetSystemMetrics(SM_CXSCREEN);
end;

function TMonitorList.GetWorkAreaHeight: Integer;
begin
    with WorkAreaRect do
    Result := Bottom - Top;
end;

function TMonitorList.GetWorkAreaLeft: Integer;
begin
  Result := WorkAreaRect.Left;
end;

function TMonitorList.GetWorkAreaRect: TRect;
begin
  SystemParametersInfo(SPI_GETWORKAREA, 0, @Result, 0);
end;

function TMonitorList.GetWorkAreaTop: Integer;
begin
  Result := WorkAreaRect.Top;
end;

function TMonitorList.GetWorkAreaWidth: Integer;
begin
    with WorkAreaRect do
    Result := Right - Left;
end;

function TMonitorList.IsValidMonitorIndex(pIndex: integer): boolean;
begin
  if (pIndex >= 0) and (pIndex <= FMonitors.Count - 1) then
    result := True
  else result := False;
end;

const
  MonitorDefaultFlags: array[TMonitorDefaultTo] of DWORD = (MONITOR_DEFAULTTONEAREST,
    MONITOR_DEFAULTTONULL, MONITOR_DEFAULTTOPRIMARY);

function TMonitorList.MonitorFromPoint(const Point: TPoint;
  MonitorDefault: TMonitorDefaultTo): TMonitorItem;
begin
  Result := FindMonitor(MultiMon.MonitorFromPoint(Point,
                        MonitorDefaultFlags[MonitorDefault]));
end;

function TMonitorList.MonitorFromRect(const Rect: TRect;
  MonitorDefault: TMonitorDefaultTo): TMonitorItem;
begin
  Result := FindMonitor(MultiMon.MonitorFromRect(@Rect,
                        MonitorDefaultFlags[MonitorDefault]));
end;

function TMonitorList.MonitorFromWindow(const Handle: THandle;
  MonitorDefault: TMonitorDefaultTo): TMonitorItem;
begin
  Result := FindMonitor(MultiMon.MonitorFromWindow(Handle,
                        MonitorDefaultFlags[MonitorDefault]));
end;

initialization
  MonList := TMonitorList.Create;

finalization
  MonList.Free;

end.
