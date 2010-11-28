unit uSystemFuncs;

interface

uses
  Types, Registry, Windows, Classes, SysUtils, ShellApi, SharpTypes;
const
  // new shell hook param
  HSHELL_SYSMENU = 9;

procedure SetForegroundWindowEx(Wnd: HWND);
function HasWriteAccess(pFile : String) : boolean;  
function IsWow64(): boolean;
function NETFramework35: Boolean;
function FindAllWindows(const WindowClass: string): THandleArray;
function ForceForegroundWindow(hwnd: THandle): Boolean;
function GetMouseDown(vKey: Integer): Boolean;

implementation

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

  function GetWndClass(pHandle: hwnd): string;
  var
    buf: array[0..254] of Char;
  begin
    GetClassName(pHandle, buf, SizeOf(buf));
    result := buf;
  end;

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
