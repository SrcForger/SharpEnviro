unit uSystemFuncs;

interface

uses
  Types, Registry, Windows, Classes, SysUtils, ShellApi, SharpTypes, MonitorList;
const
  // new shell hook param
  HSHELL_SYSMENU = 9;
  HSHELL_WINDOWREPLACED = 13;
  HSHELL_WINDOWREPLACING = 14;
  HSHELL_APPCOMMAND = 12;
  HSHELL_HIGHBIT = $8000;
  HSHELL_FLASH = (HSHELL_REDRAW or HSHELL_HIGHBIT);
  HSHELL_RUDEAPPACTIVATED = (HSHELL_WINDOWACTIVATED or HSHELL_HIGHBIT);
  HSHELL_ENDTASK = 10;

procedure SetForegroundWindowEx(Wnd: HWND);
function HasWriteAccess(pFile : String) : boolean;  
function IsWow64(): boolean;
function NETFramework35: Boolean;
function FindAllWindows(const WindowClass: string): THandleArray;
function ForceForegroundWindow(hwnd: THandle): Boolean;
function GetMouseDown(vKey: Integer): Boolean;
function IsHungAppWindow(wnd : hwnd) : Boolean;
function IsWindowFullScreen(wnd : hwnd; targetmonitor : TMonitorItem) : Boolean;
function HasFullScreenWindow(rootwnd : hwnd; targetmonitor : TMonitorItem) : Boolean;
function GetWndClass(pHandle: hwnd): string;

implementation

function GetWndClass(pHandle: hwnd): string;
var
  buf: array[0..254] of Char;
begin
  GetClassName(pHandle, buf, SizeOf(buf));
  result := buf;
end;

// check if a window is full screen
// if target monitor is set then the wnd must exist on that monitor
function IsWindowFullScreen(wnd: hwnd; targetmonitor : TMonitorItem) : Boolean;
var
  Mon, R, RDest : TRect;
  wndmon : TMonitorItem;
  style : cardinal;
begin
  result := False;

  // on multi monitor systems:
  // check if the window size is significantly larger than the monitor size.
  if (targetmonitor <> nil) and (MonList.MonitorCount > 1) then
  begin
    if Windows.GetClientRect(wnd,R) then
    begin
      if ((R.Right - R.Left) + 32 > targetmonitor.Width) or
        ((R.Bottom - R.Top) + 32 > targetmonitor.Height) then
        targetmonitor := nil;
    end;
  end;

  // get monitor of the window
  wndmon := MonList.MonitorFromWindow(wnd);
  if (wndmon = nil) then
    exit;

  // If the window is on the same monitor as the bar then check if it is fullscreen.
  if (targetmonitor = nil) or (wndmon.MonitorNum = targetmonitor.MonitorNum) then
  begin
    Mon := Rect(wndmon.Left, wndmon.Top, wndmon.Left + wndmon.Width, wndmon.Top + wndmon.Height);

    style := GetWindowLong(wnd, GWL_STYLE);
    if (style and (WS_CAPTION or WS_THICKFRAME)) = (WS_CAPTION or WS_THICKFRAME) then
    begin
      Windows.GetClientRect(wnd, R);
      MapWindowPoints(wnd, 0, R, 2);
    end else
      Windows.GetWindowRect(wnd, R);

    UnionRect(RDest, R, Mon);
    if EqualRect(RDest, R) then
    begin
      if GetWindowThreadProcessId(wnd) = GetWindowThreadProcessId(GetForegroundWindow) then
      begin
        result := True;
        exit;
      end;
    end;
  end;
end;

// check if the thread of the given window has any full screen window
// method will be checking all non child windows of the thread that owns the
// given window handle.
// if target monitor is set then the wnd must exist on that monitor
function HasFullScreenWindow(rootwnd : hwnd; targetmonitor : TMonitorItem) : Boolean;
type
  THwndArray = array of hwnd;
  PParam = ^TParam;
  TParam = record
    wndlist: THwndArray;
  end;
var
  EnumParam : TParam;
  n : integer;
  wnditem : hwnd;

  function EnumWindowsProc(wnd: hwnd; param: lParam): boolean; export; stdcall;
  begin
    with PParam(Param)^ do
    begin
      setlength(wndlist,length(wndlist)+1);
      wndlist[High(wndlist)] := wnd;
    end;
    result := true;
  end; 
begin
  result := False;

  if (not IsWindow(rootwnd)) then
    exit;

  // get all windows of the specific thread and check each window
  setlength(EnumParam.wndlist,0);
  EnumWindows(@EnumWindowsProc,Integer(@EnumParam));
  for n := 0 to High(EnumParam.wndlist) do
  begin
    wnditem := EnumParam.wndlist[n];
    if (IsWindowVisible(wnditem)) and (GetProp(wnditem, 'NonRudeHWND') = 0) then // we will ignore invisible fullscreen windows
    begin
      if IsWindowFullScreen(wnditem, targetmonitor) then
      begin
        result := True;
        exit;
      end;
    end;
  end;
  setlength(EnumParam.wndlist,0);
end;

// returns true if a window is not responding for messages longer than 5 seconds
function IsHungAppWindow(wnd : hwnd) : Boolean;
type
  TIsHungAppWindow = function(wnd : hwnd): boolean; stdcall;
var
  dllhandle : THandle;
  IsHungAppWindowFunction : TIsHungAppWindow;
begin
  dllhandle := LoadLibrary('user32.dll');

  result := False;
  try
    if dllhandle <> 0 then
    begin
      @IsHungAppWindowFunction := GetProcAddress(dllhandle, 'IsHungAppWindow');
      if Assigned(IsHungAppWindowFunction) then
        result := IsHungAppWindowFunction(wnd);
    end;
  finally
    FreeLibrary(dllhandle);
  end;
end;

procedure SetForegroundWindowEx(Wnd: HWND);
var
  Attached: Boolean;
  ThreadId: DWORD;
  FgWindow: HWND;
  AttachTo: DWORD;
begin                   
  Attached := False;
  ThreadId := GetCurrentThreadId;
  FgWindow := GetForegroundWindow();
  AttachTo := GetWindowThreadProcessId(FgWindow, nil);
  if (AttachTo <> 0) and (AttachTo <> ThreadId) then
     if AttachThreadInput(ThreadId, AttachTo, True) then
     begin
       Attached := Windows.SetFocus(Wnd) <> 0;
       AttachThreadInput(ThreadId, AttachTo, False);
     end;
  if not Attached then
  begin
    SetForegroundWindow(Wnd);
    SetFocus(Wnd);
  end;
end;

function HasWriteAccess(pFile : String) : boolean;
var
  handle : hfile;
  EMode : DWord;
begin
  EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  result := False;
  try
    handle := CreateFile(PChar(pFile), GENERIC_WRITE, 0, nil, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if not (handle = INVALID_HANDLE_VALUE) then
    begin
      CloseHandle(handle);
      DeleteFile(pFile);
      result := True;
    end;
  except
  end;
  SetErrorMode(EMode);
end;

function IsWow64(): boolean;
type
  TIsWow64Process = function(Handle: THandle; var Res: boolean): boolean; stdcall;
var
  lib : THandle;
  IsWow64Result: boolean;
  IsWow64Process: TIsWow64Process;
begin
  result := False;

  lib := LoadLibrary('kernel32.dll');
  try
    @IsWow64Process := GetProcAddress(lib, 'IsWow64Process');
    if Assigned(IsWow64Process) then
      if IsWow64Process(GetCurrentProcess, IsWow64Result) then
        result := IsWow64Result;
  finally
    FreeLibrary(lib);
  end;
end;                                             

function NETFramework35: Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5', False) then
      if Reg.ReadBool('Install') then
        result := True;
  finally
    Reg.Free
  end;
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

function ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;

begin
  if IsIconic(hwnd) then
    ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then
    Result := True
  else begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end; { ForceForegroundWindow }

function GetMouseDown(vKey: Integer): Boolean;
begin
  if (vKey = VK_RIGHT) and (GetSystemMetrics(SM_SWAPBUTTON) <> 0) then
    vKey := VK_LEFT
  else if (vKey = VK_LEFT) and (GetSystemMetrics(SM_SWAPBUTTON) <> 0) then
    vKey := VK_RIGHT;

  Result := GetAsyncKeyState(vKey) <> 0;
end;

end.
