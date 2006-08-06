unit uCPUGeneral;

interface

uses Windows,
  Classes,
  Tlhelp32,
  SysUtils;

//-----------------------------------------------------------------------
//-------
// CPU LOAD MEASUREMENT CLASS (SINGLE-POINT SAMPLING)
//-----------------------------------------------------------------------
//-------

type
  TSystemBasicInformation = packed record
    dwUnknown1: DWORD; // SIC
    uKeMaximumIncrement: ULONG; // Windows.pas: ULONG = Cardinal
    uPageSize: ULONG; // idem for all DWORDs below
    uMmNumberOfPhysicalPages: ULONG;
    uMmLowestPhysicalPage: ULONG;
    uMmHighestPhysicalPage: ULONG;
    uAllocationGranularity: ULONG;
    pLowestUserAddress: pointer; // PVOID
    pMmHighestUserAddress: pointer; // PVOID
    uKeActiveProcessors: ULONG; // Number of Active processors
    bKeNumberProcessors: byte; // Total Number of processors
    bUnknown2: byte;
    wUnknown3: word;
  end; // TSystemBasicInformation
type
  pSystemBasicInformation = ^TSystemBasicInformation;

type
  TSystemPerformanceInformation = packed record
    liIdleTime: Int64;
    dwSpare: array[0..75] of dword;
  end; // TSystemPerformanceInformation
type
  pSystemPerformanceInformation = ^TSystemPerformanceInformation;

type
  TSystemTimeInformation = packed record
    liKeBootTime: Int64;
    liKeSystemTime: Int64;
    liExpTimeZoneBias: Int64;
    uCurrentTimeZoneId: ULONG;
    dwReserved: DWORD;
  end; // TSystemTimeInformation

type
  TCpuMonitor = class
  private
    Int64OSharpEdleTime, Int64OldSystemTime: Int64;
    iNumberOfProcessors: Integer;
    LastTickCount: cardinal;
    LastProcessorTime: int64;
    SysPerfInfo: TSystemPerformanceInformation;
    SysTimeInfo: TSystemTimeInformation;
    SysBaseInfo: TSystemBasicInformation;
  public
    constructor Create; virtual;
    function GetCpuLoadPercent: dword;
    property NumberOfProcessors: Integer read iNumberOfProcessors;
    function GetProcessorUsage: integer;
    function GetProcessorTime: int64;
  end;

implementation

const
  SYSTEM_BASIC_INFORMATION = 0;
  SYSTEM_PERFORMANCE_INFORMATION = 2;
  SYSTEM_TIME_INFORMATION = 3;

function NtQuerySystemInformation(
  SystemInformationClass: UINT;
  pSystemInfo: pointer;
  SystemInformationLength: ULONG;
  ReturnLength: PULONG) // Optional, OUT
: Integer; stdcall; external 'Ntdll.dll';

{ TCpuMonitor }

constructor TCpuMonitor.Create;
begin
  // Store new CPU's idle and system time
  // Get System time
  if NtQuerySystemInformation(SYSTEM_TIME_INFORMATION,
    @SysTimeInfo, SizeOf(SysTimeInfo), nil) <> NO_ERROR then
    Exit;
  Int64OldSystemTime := SysTimeInfo.liKeSystemTime - 100;
  // Get CPU's idle time
  if NtQuerySystemInformation(SYSTEM_PERFORMANCE_INFORMATION,
    @SysPerfInfo, SizeOf(SysPerfInfo), nil) <> NO_ERROR then
    Exit;
  Int64OSharpEdleTime := SysPerfInfo.liIdleTime - 100;
  // Get number of processors in the system
  if NtQuerySystemInformation(SYSTEM_BASIC_INFORMATION,
    @SysBaseInfo, SizeOf(SysBaseInfo), nil) <> NO_ERROR then
    Exit;
  iNumberOfProcessors := SysBaseInfo.bKeNumberProcessors;
end; // proc Create

function TCpuMonitor.GetCpuLoadPercent: dword;
var
  Int64IdleTime, Int64SystemTime: Int64;
begin
  // Get new system time
  NtQuerySystemInformation(SYSTEM_TIME_INFORMATION,
    @SysTimeInfo, SizeOf(SysTimeInfo), nil);
  // Get new CPU's idle time
  NtQuerySystemInformation(SYSTEM_PERFORMANCE_INFORMATION,
    @SysPerfInfo, SizeOf(SysPerfInfo), nil);
  // CurrentValue = NewValue - OldValue
  Int64IdleTime := SysPerfInfo.liIdleTime - Int64OSharpEdleTime;
  Int64SystemTime := (SysTimeInfo.liKeSystemTime - Int64OldSystemTime + 1);
  // +1 make sure this var can't be zero
    // CurrentCpuIdle = IdleTime / SystemTime
  Int64IdleTime := (Int64IdleTime * 100) div Int64SystemTime; // *100 for %
  Result := 100 - (Integer(Int64IdleTime) div iNumberOfProcessors);
  // Store new CPU's idle and system time
  Int64OSharpEdleTime := SysPerfInfo.liIdleTime;
  Int64OldSystemTime := SysTimeInfo.liKeSystemTime;
  if Result > 100 then
    Result := 100; // v01.01.00 corrective clipoff,
end; // func GetCpuLoadPercent

function TCpuMonitor.GetProcessorTime: int64;
type
  TPerfDataBlock = packed record
    signature: array[0..3] of wchar;
    littleEndian: cardinal;
    version: cardinal;
    revision: cardinal;
    totalByteLength: cardinal;
    headerLength: cardinal;
    numObjectTypes: integer;
    defaultObject: cardinal;
    systemTime: TSystemTime;
    perfTime: comp;
    perfFreq: comp;
    perfTime100nSec: comp;
    systemNameLength: cardinal;
    systemnameOffset: cardinal;
  end;
  TPerfObjectType = packed record
    totalByteLength: cardinal;
    definitionLength: cardinal;
    headerLength: cardinal;
    objectNameTitleIndex: cardinal;
    objectNameTitle: PWideChar;
    objectHelpTitleIndex: cardinal;
    objectHelpTitle: PWideChar;
    detailLevel: cardinal;
    numCounters: integer;
    defaultCounter: integer;
    numInstances: integer;
    codePage: cardinal;
    perfTime: comp;
    perfFreq: comp;
  end;
  TPerfCounterDefinition = packed record
    byteLength: cardinal;
    counterNameTitleIndex: cardinal;
    counterNameTitle: PWideChar;
    counterHelpTitleIndex: cardinal;
    counterHelpTitle: PWideChar;
    defaultScale: integer;
    defaultLevel: cardinal;
    counterType: cardinal;
    counterSize: cardinal;
    counterOffset: cardinal;
  end;
  TPerfInstanceDefinition = packed record
    byteLength: cardinal;
    parentObjectTitleIndex: cardinal;
    parentObjectInstance: cardinal;
    uniqueID: integer;
    nameOffset: cardinal;
    nameLength: cardinal;
  end;
var
  c1, c2, c3: cardinal;
  i1, i2: integer;
  perfDataBlock: ^TPerfDataBlock;
  perfObjectType: ^TPerfObjectType;
  perfCounterDef: ^TPerfCounterDefinition;
  perfInstanceDef: ^TPerfInstanceDefinition;
begin
  result := 0;
  perfDataBlock := nil;
  try
    c1 := $10000;
    while true do begin
      ReallocMem(perfDataBlock, c1);
      c2 := c1;
      case RegQueryValueEx(HKEY_PERFORMANCE_DATA, '238', nil, @c3,
        pointer(perfDataBlock), @c2) of
        ERROR_MORE_DATA: c1 := c1 * 2;
        ERROR_SUCCESS: break;
      else
        exit;
      end;
    end;
    perfObjectType := pointer(cardinal(perfDataBlock) +
      perfDataBlock^.headerLength);
    for i1 := 0 to perfDataBlock^.numObjectTypes - 1 do begin
      if perfObjectType^.objectNameTitleIndex = 238 then
        begin // 238 -> "Processor"
        perfCounterDef := pointer(cardinal(perfObjectType) +
          perfObjectType^.headerLength);
        for i2 := 0 to perfObjectType^.numCounters - 1 do begin
          if perfCounterDef^.counterNameTitleIndex = 6 then
            begin // 6 -> "% Processor Time"
            perfInstanceDef := pointer(cardinal(perfObjectType) +
              perfObjectType^.definitionLength);
            result := PInt64(cardinal(perfInstanceDef) +
              perfInstanceDef^.byteLength + perfCounterDef^.counterOffset)^;
            break;
          end;
          inc(perfCounterDef);
        end;
        break;
      end;
      perfObjectType := pointer(cardinal(perfObjectType) +
        perfObjectType^.totalByteLength);
    end;
  finally FreeMem(perfDataBlock)
  end;
end;

function TCpuMonitor.GetProcessorUsage: integer;
var
  tickCount: cardinal;
  processorTime: int64;
begin
  result := 0;
  tickCount := GetTickCount;
  processorTime := GetProcessorTime;
  if (LastTickCount <> 0) and (tickCount <> LastTickCount) then
    result := 100 - Round(((processorTime - LastProcessorTime) div 100) /
      (tickCount - LastTickCount));
  LastTickCount := tickCount;
  LastProcessorTime := processorTime;
end;

end.

