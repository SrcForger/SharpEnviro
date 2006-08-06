unit uPrismController;

interface
uses
  Classes,
  messages,
  SysUtils,
  dialogs,
  graphics,
  Forms,
  ExtCtrls,
  SharpApi,
  Windows,
  Tlhelp32,
  Math,
  JvGradient,
  JvSimScope,
  GraphicsFx;

type
  TPriorityType = (ptHigh, ptNormal, ptIdle, ptRealTime);

type
  TPrismController = class
  private
    FTmpID: Int64;
    FCpuStat: integer;
    FAvgCpuStat, FAvgCpuBl: Double;

    FMemEventTimer: TTimer;
    FMemEventInterval: Integer;
    FOnChangeMemVals: TNotifyEvent;

    procedure SetMemEventInterval(const Value: Integer);
    procedure MemTimer(Sender: TObject);
    procedure FreeMemory;
  public
    constructor Create;
    destructor Free;

    procedure Start;
    procedure ApplySettings;

    property MemEventInterval: Integer read FMemEventInterval write
      SetMemEventInterval;

    property OnChangeMemVals: TNotifyEvent read FOnChangeMemVals write
      FOnChangeMemVals;
  end;

var
  PrismController: TPrismController;

implementation

uses
  uPrismSettings;

{ TPrismController }

constructor TPrismController.Create;
begin
  inherited;
  FMemEventTimer := TTimer.Create(nil);
  FMemEventTimer.Enabled := False;
  FMemEventTimer.OnTimer := MemTimer;

  FTmpID := 0;
  
  // Free the memory
  FreeMemory;

end;

destructor TPrismController.Free;
begin
  If Assigned(FMemEventTimer) then FMemEventTimer.Free;
end;

procedure TPrismController.FreeMemory;
var
  aSnapshotHandle: THandle;
  aProcessEntry32: TProcessEntry32;
  ProcessHandle: THandle;
  bContinue: BOOL;
begin
  aSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  aProcessEntry32.dwSize := SizeOf(aProcessEntry32);
  bContinue := Process32First(aSnapshotHandle, aProcessEntry32);
  while Integer(bContinue) <> 0 do begin
    ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False,
      aProcessEntry32.th32ProcessID);

    if (pos('Sharp', aProcessEntry32.szExeFile) <> 0) or
      (pos('sharp', aProcessEntry32.szExeFile) <> 0) then
      SetProcessWorkingSetSize(ProcessHandle, dword(-1), dword(-1));

    CloseHandle(ProcessHandle);
    bContinue := Process32Next(aSnapshotHandle, aProcessEntry32);
  end;
  CloseHandle(aSnapshotHandle);

end;

procedure TPrismController.MemTimer(Sender: TObject);
begin
  FreeMemory;
end;

procedure TPrismController.SetMemEventInterval(const Value: Integer);
begin
  FMemEventInterval := Value;
  FMemEventTimer.Interval := Value;
end;

procedure TPrismController.Start;
begin
  FMemEventTimer.Enabled := True;
end;

procedure TPrismController.ApplySettings;
begin
  PrismController.MemEventInterval := PrismSettings.MemEventInterval;
  PrismController.Start;
end;

end.

