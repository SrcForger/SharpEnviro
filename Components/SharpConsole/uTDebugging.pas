{ ============================================================================
  ## Debugging Unit
  Summary:
  * Provides Callback function and Log file debugging
  * Overrides default Application Assertion handler, preventing exceptions being
    raised.
  ============================================================================ }
unit uTDebugging;

interface

{ ==============================================================================
  ## Types
  ============================================================================ }
type
  TDebuggingLevel = (dlSTATUS, dlERROR, dlWARN, dlINFO, dlTRACE);

  TDebugFileNaming = (dfnFixed, dfnDaily, dfnDailySeq);

  TOnDebugMessageEvent = procedure(Sender: TObject; DbgLvl: TDebuggingLevel; ResultCode: LongInt; Msg: string) of object;

  TOnStatusMessageEvent = procedure(Sender: TObject; ResultCode: LongInt; Msg: string) of object;

type
  { ============================================================================
    ## TDebugging
    * Debugging Level - Default full debugging (aids quick dev. debugging)
    * Allows log filename change every day.
    ========================================================================== }
  TDebugging = class(TObject)
  protected
    FEnabled: Boolean;
    FFile: Textfile;
    FFilename: string;
    FLogDirectory: string;
    FLevel: TDebuggingLevel;
    FFileDate: TDateTime;
    FUseLogFile: Boolean;
    FFileNaming: TDebugFileNaming;
    FPrintMillisec: Boolean;
    FPrintBanners: Boolean;
    FComment: string;
    FInitialising: Boolean;

    // User callbacks
    FOnDebugMessage: TOnDebugMessageEvent;
    FOnStatusMessage: TOnStatusMessageEvent;

    FDebugLvlStrs: array[TDebuggingLevel] of string;

    procedure SetLevel(const Value: TDebuggingLevel);
    procedure AssertErrorHandler(const Message: string; Filename: string;
      LineNumber: integer; ErrorAddr: Pointer);
    function WriteLogFile(S: string): Boolean;
    function UserName: string;
    function GetDebugLvlStrs(DbgLvl: TDebuggingLevel): string; virtual;
    procedure SetDebugLvlStrs(DbgLvl: TDebuggingLevel; const Value: string); virtual;

    function BuildTraceLog(Caller: integer; StopEntries: array of string): string; virtual;
    function InitialiseLogFile(): Boolean; virtual;
    procedure HookAssertionHandler; virtual;
    procedure WriteHeader(); virtual;

  public
    // Exposed for Plugin usage
    procedure DoWriteDebugMessage(DbgLvl: TDebuggingLevel;
      ResultCode: LongInt; Msg: string); virtual;

    // Public Debug handlers
    procedure STATUS(ResultCode: LongInt; Msg: string); overload;
    procedure STATUS(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
    procedure STATUS(Msg: string); overload;
    procedure STATUS(FormatString: string; Args: array of const); overload;

    procedure ERROR(ResultCode: LongInt; Msg: string); overload;
    procedure ERROR(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
    procedure ERROR(Msg: string); overload;
    procedure ERROR(FormatString: string; Args: array of const); overload;

    procedure WARN(ResultCode: LongInt; Msg: string); overload;
    procedure WARN(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
    procedure WARN(Msg: string); overload;
    procedure WARN(FormatString: string; Args: array of const); overload;

    procedure INFO(ResultCode: LongInt; Msg: string); overload;
    procedure INFO(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
    procedure INFO(Msg: string); overload;
    procedure INFO(FormatString: string; Args: array of const); overload;

    procedure TRACE(ResultCode: LongInt; Msg: string; ProcAddr: Pointer = nil); overload;
    procedure TRACE(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
    procedure TRACE(Msg: string = ''; ProcAddr: Pointer = nil); overload;
    procedure TRACE(FormatString: string; Args: array of const); overload;

    constructor Create; virtual;
    destructor Destroy; override;

    // Properties
    property Enabled: Boolean read FEnabled write FEnabled;
    property Level: TDebuggingLevel read FLevel write SetLevel;
    property UseLogFile: Boolean read FUseLogFile write FUseLogFile;
    property Filename: string read FFilename;
    property LogDirectory: string read FLogDirectory write FLogDirectory;
    property FileNaming: TDebugFileNaming read FFileNaming write FFileNaming;
    property PrintBanners: Boolean read FPrintBanners write FPrintBanners;
    property PrintMillisec: Boolean read FPrintMillisec write FPrintMillisec;
    property Comment: string read FComment write FComment;
    property DebugLvlStrs[DbgLvl: TDebuggingLevel]: string read GetDebugLvlStrs write SetDebugLvlStrs;

    // Events
    property OnDebugMessage: TOnDebugMessageEvent read FOnDebugMessage write FOnDebugMessage;
    property OnStatusMessage: TOnStatusMessageEvent read FOnStatusMessage write FOnStatusMessage;
  end;

implementation
{ ==============================================================================
  ## IMPLEMENTATION
  ============================================================================ }

uses
  SysUtils,
  StrUtils,
  DateUtils,
  JclDebug,
  Windows, // For GetUserName
  uVersInfo;

const
  // BuildProcList stuff
  PROCDELIMS = '[';
  PROCDELIMF = ']';

  // Component names to stop Build Trace Logs on.
  cBuildTraceLogStops: array[0..8] of string = (
    'TControl.Click',
    'TTimer.Timer',
    'TControl.WndProc',
    'TCustomForm.DoShow',
    'StdWndProc',
    'TWinControl.MainWndProc',
    'TWinControl.WndProc',
    'TCustomForm.DoClose',
    'TCustomForm.DoCreate');

resourcestring
  // Log File Header Strings
  rsExecProduct = ' Product         : %s (V%s)';
  rsExecFile = ' File            : %s (V%s)';
  rsExecDate = ' Date            : %s';
  rsExecUser = ' User            : %s';
  rsEXEPath = ' Application     : %s';
  rsCurPath = ' Current Path    : %s';
  rsExecComment = ' Comment         : %s';
  rsExecDateStr = 'dd/mmm/yyyy, hh:mm:ss';
  rsLine1 = '----------------------------------------------------------';
  rsLine2 = '==========================================================';
  rsDebugCodeMsg = '($%.8x) - %s';
  rsStatusCodeMsg = '($%.8x) - %s';

  // Log File Debug Strings
  rsAssertErrString = 'Error : %s (%s, line %d, address $%x)';
  rsDebugMsgDateMSecStr = 'dd/mm/yy hh:nn:ss.zzz';
  rsDebugMsgDateStr = 'dd/mm/yy hh:nn:ss';
  rsDebugMsgStr = '%s - %s: %s%s';
  rsErrorCodeStr = '$%.8x - ';
  rsDebugLevelSetting = 'Debugging Level Changed to "%s"';
  rsDestroying = 'Destroying Debugging';

  // Default Error level enumeration strings
  rsSTATUS = 'STATUS';
  rsERROR = 'ERROR';
  rsWARN = 'WARN';
  rsINFO = 'INFO';
  rsTRACE = 'TRACE';

var
  // Local reference, just for AssertErrorHandler_
  DebugRef : TDebugging;

{ ==============================================================================
  ## AssertErrorHandler_
  * Assertion Error Handler for current module / applciation
  * Assertion checks are actually raised exceptions, handled by Delphi ASSERT
    routine, calling AssertErrorHandler if assertion fails.
  * Note : DEBUGGING LEVELS
    0   : No Log file debugging (Setup for Status Messages only (must be displayed))
    1   : ERRORS
    2   : WARNINGS
    3   : INFO
    4   : TRACE
  * Debugging code can be disabled in following ways :
    1)  Set Version Info to Production version (RELEASESUFFIXVER)
    2)  Set Enabled to False
    3)  Set Debugging Level to NONE (Temporary)
  ============================================================================ }
procedure AssertErrorHandler_(const Message: string;
  Filename: string;
  LineNumber: integer;
  ErrorAddr: Pointer);
begin
  if Assigned(DebugRef) then
    DebugRef.AssertErrorHandler(Message, Filename, LineNumber, ErrorAddr);
end; {}

{ ==============================================================================
  ## Find In Array
  * Copied from uFunctions
  Passed:
    * ValueToFind - String to find
    * SearchArray - Dynamic array of string entries
  Returns:
    * TRUE - If ValueToFind = Any of the SearchArray strings
    * FALSE - Not found
  ============================================================================ }
function FindInArray(const ValueToFind: string;
  const SearchArray: array of string): Boolean; overload;
var
  Count: integer;
begin
  // Default Found
  Result := True;

  for Count := 0 to Length(SearchArray) - 1 do
    if ValueToFind = SearchArray[Count] then
      Exit;

  // Did nof find
  Result := False;
end; {FindInArray}

{ ==============================================================================
  ## DoWriteDebugMessage
  ============================================================================ }
procedure TDebugging.DoWriteDebugMessage(DbgLvl: TDebuggingLevel;
  ResultCode: LongInt; Msg: string);
var
  DateTimeStr: string;
  ErrorCodeStr: string;
begin
  // Check debug level
  if (FLevel < DbgLvl) or (not FEnabled) then Exit;

  // User callback
  if Assigned(OnDebugMessage) then
    OnDebugMessage(Self, DbgLvl, ResultCode, Msg);

  // Write Log File
  if FUseLogFile then begin

    // Create Debug code prefix
    if ResultCode = 0 then
      ErrorCodeStr := ''
    else
      ErrorCodeStr := Format(rsErrorCodeStr, [ResultCode]);

    // Create Date Time prefix
    if FPrintMillisec then
      DateTimeStr := FormatDateTime(rsDebugMsgDateMSecStr, Now())
    else
      DateTimeStr := FormatDateTime(rsDebugMsgDateStr, Now());

    // Only append to Debug String, if not empty string.
    if (Msg <> '') then
      Msg := Format(rsDebugMsgStr, [DateTimeStr, DebugLvlStrs[DbgLvl],
        ErrorCodeStr, Msg]);

    // Write
    WriteLogFile(Msg);
  end;
end; {DoWriteDebugMessage}

{ ==============================================================================
  ## UserName
  ============================================================================ }
function TDebugging.UserName: string;
var
  UserName: array[0..255] of char;
  BufferSize: Cardinal;
begin
  // Default
  BufferSize := SizeOf(UserName);

  if GetUserName(UserName, BufferSize) then
    Result := string(UserName)
  else
    Result := '';
end; {UserName}

{ ==============================================================================
  ## WriteHeader
  * Adds nice header to top of Debugging strings
  Changes:
  * Added EXEPath, CurrentDirectory
  ============================================================================ }
procedure TDebugging.WriteHeader();
var
  VersionInfo: TVersionInfo;
  DateStr: string;
  CurPath: string;
begin
  // Use Header
  if not FPrintBanners then Exit;

  // Retrieve Version Information
  VersionInfo := TVersionInfo.Create(ParamStr(0));
  try

    // Retrieve Date
    DateStr := FormatDateTime(rsExecDateStr, Now());

    // Retrieve Path information
    CurPath := GetCurrentDir;

    // Create nice Title Block ---------------------------------------
    with VersionInfo do begin
      WriteLogFile(rsLine2);
      WriteLogFile(Format(rsExecProduct, [ProductName, ProductVersion]));
      WriteLogFile(Format(rsExecFile, [FileDescription, FileVersion]));
      WriteLogFile(Format(rsExecDate, [DateStr]));
      WriteLogFile(Format(rsExecUser, [UserName]));
      WriteLogFile(Format(rsEXEPath, [ParamStr(0)]));
      WriteLogFile(Format(rsCurPath, [CurPath]));
      WriteLogFile(Format(rsExecComment, [FComment]));
      WriteLogFile(rsLine2);
      WriteLogFile('');
    end;
  finally
    VersionInfo.Free;
  end;
end; {WriteHeader}

{ ==============================================================================
  ## InitialiseLogFile
  * Sets up the default log file (used for quick app dev debugging)
  * Rewrites log file - to clear it.
  * Can be used to Change filename periodically (Eg. when date changes / write failure)
  * Can handle UNC file locations.
  ============================================================================ }
function TDebugging.InitialiseLogFile(): Boolean;
resourcestring
  rsLogFileDateStr = 'yyyy"-"mm"-"dd';
  rsLogFileFixedNameStr = '%s%s.%s';
  rsLogFileDailyNameStr = '%s%s-%s.%s';
  rsLogFileDailySeqStr = '%s%s-%s-%.3d.%s';
const
  NOEXT = '';
  LOGEXT = 'Log';
  LOGPATH = 'Logs\';
var
  DateStr: string;
  BaseFileName: string;
  FilePath: string;
  SeqNo: integer;
begin
  // Prevent recursion,
  // Check if log file already initialised
  // Zero file Date indicates not initialised
  if FInitialising or
    ((FFileDate <> 0) and
    (FFilename <> '') and
    ((FFileNaming = dfnFixed) or IsSameDay(FFileDate, Date))
    ) then begin
    Result := True;
    Exit;
  end;

  // Helps prevent recursion
  FInitialising := True;

  try

    // Store log file date, aids detecting date change.
    FFileDate := Date();

    // Set up default logfile --------------------------------------------------
    BaseFileName := ChangeFileExt(ExtractFileName(ParamStr(0)), NOEXT);
    FilePath := LeftStr(ParamStr(0), LastDelimiter(PathDelim, ParamStr(0))) + LOGPATH;
    if LogDirectory <> '' then
      FilePath := LogDirectory;
    DateStr := FormatDateTime(rsLogFileDateStr, FFileDate);

    case FFileNaming of
      dfnFixed:
        FFilename := Format(rsLogFileFixedNameStr, [FilePath, BaseFileName, LOGEXT]);
      dfnDaily:
        FFilename := Format(rsLogFileDailyNameStr, [FilePath, BaseFileName, DateStr, LOGEXT]);
      dfnDailySeq: begin
          SeqNo := 0;
          repeat
            Inc(SeqNo);
            FFilename := Format(rsLogFileDailySeqStr,
              [FilePath, BaseFileName, DateStr, SeqNo, LOGEXT]);
          until (not FileExists(FFilename)) or (SeqNo = 999);
        end;
    end;

    // Setup file assignment
    AssignFile(FFile, FFilename);

    // If path to log file not found, create it,
    Result := ForceDirectories(FilePath);

    // Write Header
    WriteHeader;

  finally
    // Recursion prevention flag
    FInitialising := False;
  end;
end; {InitialiseLogFile}

{ ==============================================================================
  ## WriteLogFile()
  * Write to Default debug output (for rapind app dev.)
  * Central point to send all debug messages to.
  * Removes any CR / LF's
  * Changes log file name, every day.
  * Retries and changes log file name on write Error.
  ============================================================================ }
function TDebugging.WriteLogFile(S: string): Boolean;
const
  NEWCRLF = '.';

  function DoWriteDefaultDebugMessage(): Boolean;
  begin
    Result := InitialiseLogFile();
    if not Result then Exit;

    // Remove CR / LF's
    S := StringReplace(S, // String
      #13, // Old Sub-string
      NEWCRLF, // New sub-string
      [rfReplaceAll]); // Flags

    S := StringReplace(S, // String
      #10, // Old Sub-string
      NEWCRLF, // New sub-string
      [rfReplaceAll]); // Flags

    // Add message to our debug log file
    if FFilename = '' then begin
      Result := False;
      Exit;
    end;

    try
      // Append file if exists, else create.
      if FileExists(Filename) then
        Append(FFile)
      else
        Rewrite(FFile);

      try
        // Write
        Writeln(FFile, S);

        // Close Log file to allow reading
        Flush(FFile); { ensures that the text was actually written to file }
      finally
        CloseFile(FFile);
      end;
    except
      // Cannot use Assertions here
      // Set FileDate to zero, will re-init debugging file on next call
      FFileDate := 0;
      Result := False;
    end;
  end; {Do}

var
  Attempts: integer;
begin
  // Retry on log file writes
  // Output to default debugging routine, with retry
  for Attempts := 1 to 3 do begin
    Result := DoWriteDefaultDebugMessage();
    if Result then Break;
  end;
end; {WriteLogFile}

procedure TDebugging.AssertErrorHandler(const Message: string;
  Filename: string;
  LineNumber: integer;
  ErrorAddr: Pointer);
var
  S: string;
begin
  // ASSERTION TRACE debugging
  TRACE('', ErrorAddr);

  // Get The ASSERT Message Location
  S := Format(rsAssertErrString,
    [Message,
    ExtractFileName(Filename),
      LineNumber,
      Pred(integer(ErrorAddr))]);

  // Output to Central debug message handler
  DoWriteDebugMessage(dlERROR, E_UNEXPECTED, S);
end;

{ ==============================================================================
  ## HookAssertionHandler
  * Hooks the Application Assertion handler
  * Sets up at top level whether assertions are handled, or ignored.
  ============================================================================ }
procedure TDebugging.HookAssertionHandler();
begin
  // Static Error handler
  System.AssertErrorProc := @AssertErrorHandler_;

  // Reference for AssertErrorHandler_
  DebugRef := Self;
end; {HookAssertionHandler}

{ ==============================================================================
  ## STATUS
  * High level routine.  Allows callback to MMI with status information.
  * This function is to allow low-level units to feedback Status information
    back to current form.  The callback function must be setup.
  Changes:
  * CR081 - Generic debugging, with Format String
  ============================================================================ }
procedure TDebugging.STATUS(ResultCode: LongInt; Msg: string);
begin
  TRACE();

  // Pass Information to Debugging system
  DoWriteDebugMessage(dlSTATUS, ResultCode, Msg);

  // Pass STATUS Information back to MMI
  if Assigned(FOnStatusMessage) then
    FOnStatusMessage(Self, ResultCode, Msg);
end; {STATUS}

procedure TDebugging.STATUS(ResultCode: LongInt; FormatString: string; Args: array of const);
begin
  // Format user message
  STATUS(ResultCode, Format(FormatString, Args));
end; {STATUS}

procedure TDebugging.STATUS(Msg: string);
begin
  STATUS(0, Msg);
end;

procedure TDebugging.STATUS(FormatString: string; Args: array of const);
begin
  STATUS(0, Format(FormatString, Args));
end;
{ ==============================================================================
  ## Error
  Changes:
  * CR081 - Generic ResultCode, with Format String - overloaded function
  ============================================================================ }
procedure TDebugging.ERROR(ResultCode: integer; Msg: string);
begin
  // TRACE debugging
  TRACE();

  // Output to central debug message handler
  DoWriteDebugMessage(dlERROR, ResultCode, Msg);
end;

procedure TDebugging.ERROR(ResultCode: integer; FormatString: string; Args: array of const);
begin
  ERROR(ResultCode, Format(FormatString, Args));
end;

procedure TDebugging.ERROR(Msg: string);
begin
  ERROR(0, Msg);
end; {Error}

procedure TDebugging.ERROR(FormatString: string; Args: array of const);
begin
  ERROR(0, Format(FormatString, Args));
end; {Error}

{ ==============================================================================
  ## WARNING
  Changes:
  * CR081 - Generic ResultCode, with Format String - overloaded function
  ============================================================================ }
procedure TDebugging.WARN(ResultCode: integer; Msg: string);
begin
  // ASSERTION TRACE debugging
  TRACE();

  // Output to central debug message handler
  DoWriteDebugMessage(dlWARN, ResultCode, Msg);
end;

procedure TDebugging.WARN(ResultCode: integer; FormatString: string;
  Args: array of const);
begin
  WARN(ResultCode, Format(FormatString, Args));
end;

procedure TDebugging.WARN(Msg: string);
begin
  WARN(0, Msg);
end; {WARN}

procedure TDebugging.WARN(FormatString: string; Args: array of const);
begin
  WARN(0, Format(FormatString, Args));
end; {WARN}

{ ==============================================================================
  ## INFO
  Changes:
  * CR081 - Generic ResultCode, with Format String - overloaded function
  ============================================================================ }
procedure TDebugging.INFO(ResultCode: LongInt; Msg: string);
begin
  // No TRACE on info

  // Output to central debug message handler
  DoWriteDebugMessage(dlINFO, ResultCode, Msg);
end;

procedure TDebugging.INFO(ResultCode: integer; FormatString: string;
  Args: array of const);
begin
  INFO(ResultCode, Format(FormatString, Args));
end;

procedure TDebugging.INFO(Msg: string); // Statistical / debuggin info.
begin
  INFO(0, Msg);
end; {Info}

procedure TDebugging.INFO(FormatString: string; Args: array of const);
begin
  INFO(0, Format(FormatString, Args));
end; {Info}

{ ==============================================================================
  ## TRACE
  * ProcAddr used by AssertionErrorHandler to find funtion where exception occured
  ============================================================================ }
procedure TDebugging.TRACE(ResultCode: LongInt; Msg: string; ProcAddr: Pointer);
resourcestring
  rsTRACEString = '%s [%s]';
const
  SEPERATIONLINE = '';
var
  S: string;
  ProcName: string;
begin
  // Exit if not at detailed debugging level
  if (FLevel < dlTRACE) or (not FEnabled) then
    Exit;

  // Get the call stack - xx = Do not include top xx procedures,
  //        'TControl.Click'= Stop stack TRACE at this procedure
  // Get ProcOfAddr required as Assert ProcByLevel does not know
  // about a routine that caused exception. (As exception jumps up 1 level)
  // If ProcAddr valid, then we need to go back a few more calls (Assert handler)
  try
    if Assigned(ProcAddr) then
      S := BuildTraceLog(3, cBuildTraceLogStops)
    else
      S := BuildTraceLog(1, cBuildTraceLogStops);
  except
    on E: Exception do S := E.message;
  end;

  // Get ProcName of passed Address
  if not Assigned(ProcAddr) then
    ProcName := ''
  else
    ProcName := ProcOfAddr(ProcAddr);

  // Output Trace Call Stack
  if (S<>'') or (ProcName<>'') then begin
    // Add StackTrace + ProcName
    S := Format(rsTRACEString, [S, ProcName]);

    // Output nice seperation line please
    DoWriteDebugMessage(dlTRACE, 0, SEPERATIONLINE);

    // Output to central debug message handler
    DoWriteDebugMessage(dlTRACE, 0, S);
  end;

  // Add message under TRACE proc hierachy (if any)
  if (Msg <> '') then
    DoWriteDebugMessage(dlTRACE, ResultCode, Msg);
end; {TRACE}

procedure TDebugging.TRACE(ResultCode: integer; FormatString: string;
  Args: array of const);
begin
  TRACE(ResultCode, Format(FormatString, Args));
end;

procedure TDebugging.TRACE(Msg: string; ProcAddr: Pointer);
begin
  TRACE(0, Msg, ProcAddr);
end;

procedure TDebugging.TRACE(FormatString: string; Args: array of const);
begin
  TRACE(0, Format(FormatString, Args), nil);
end; {TRACE}

{ ==============================================================================
  ## Build TRACE log
  * Replaces UpdateTraceLog
  * Uses Jedi Code Library, which must be installed, and Project/Insert
    JCL debug data ticked.
  * Stops TRACE back if Procedure name in StopEntires array of strings.
  * Usage of this function requires building the module with a detailed map file.
  * Use the Linker tab in the Project Options dialog to enable creation of a map file.
  Returns:
  * Function Stack procs as a string.
  ============================================================================ }
function TDebugging.BuildTraceLog(Caller: integer;
  StopEntries: array of string): string;
var
  CallerName: string;
  ProcsList: string;
begin
  // Get name of each subsequent caller
  ProcsList := '';
  Inc(Caller); // Don't include BuildTraceLog
  repeat
    CallerName := ProcByLevel(Caller);
    if (not FindInArray(CallerName, StopEntries)) and
      (CallerName <> '') then
      ProcsList := PROCDELIMS + CallerName + PROCDELIMF + ProcsList;
    Inc(Caller);
  until (CallerName = '') or (FindInArray(CallerName, StopEntries));

  // Return the string
  Result := ProcsList;
end;

procedure TDebugging.SetLevel(const Value: TDebuggingLevel);
begin
  if (FLevel <> Value) then begin
    FLevel := Value;
    INFO(rsDebugLevelSetting, [DebugLvlStrs[Value]]);
  end;
end;

constructor TDebugging.Create;
const
  DEBUGSWITCH = 'Debug';
  NODEBUGSWITCH = 'NoDebug';
begin
  // Setup debug level strings
  FDebugLvlStrs[dlSTATUS] := rsSTATUS;
  FDebugLvlStrs[dlERROR] := rsERROR;
  FDebugLvlStrs[dlWARN] := rsWARN;
  FDebugLvlStrs[dlINFO] := rsINFO;
  FDebugLvlStrs[dlTRACE] := rsTRACE;

  // Hook Assertion Error handler (we catch assertion exceptions)
  HookAssertionHandler;

  // CR064 - By default, On startup, to aid quick development :
  //         Debugging level is TRACE, to aid quick
  //         DefaultWriteMessageProc handler set
  FEnabled := True;
  FLevel := dlTRACE;
  FUseLogFile := True;
  FFileNaming := dfnDaily;
  FPrintMillisec := True;
  FPrintBanners := True;

  // CR064 - Command line can override debugging settings
  // CR064 - No debugging on production release / NoDebug Passed
  //         If File Version information is missing, debugging will be left on.
  if FindCmdLineSwitch(DEBUGSWITCH) then
    Enabled := True
  else if FindCmdLineSwitch(NODEBUGSWITCH) then
    Enabled := False;
end; {Create}

function TDebugging.GetDebugLvlStrs(DbgLvl: TDebuggingLevel): string;
begin
  Result := FDebugLvlStrs[DbgLvl];
end;

procedure TDebugging.SetDebugLvlStrs(DbgLvl: TDebuggingLevel;
  const Value: string);
begin
  FDebugLvlStrs[DbgLvl] := Value;
end;

destructor TDebugging.Destroy;
begin
  TRACE(rsDestroying);
  
  // Remove local ref
  DebugRef := nil;

  inherited;
end;

end.

