{ ============================================================================
  ## Debugging Unit
  * LEGACY SUPPORT FOR APPLICATIONS WITH STATIC DEBUGGING UNIT
  * Provides Callback function and Log file debugging
  * Overrides default Application Assertion handler, preventing exceptions being
    raised.
  Changes:
  * Legacy support for applications with static debugging unit
  ============================================================================ }
unit uDebugging;

interface

uses
  uTDebugging;

{ ==============================================================================
  ## Types
  ============================================================================ }
type
  TDebuggingLevel = (dlSTATUS, dlERROR, dlWARN, dlINFO, dlTRACE);

  TDebugFileNaming = (dfnFixed, dfnDaily, dfnDailySeq);

{ ==============================================================================
  ## Static Debug Tracing Methods
  ( Legacy support)
  ============================================================================ }
  // High-level application status message feedback
procedure STATUS(ResultCode: LongInt; Msg: string); overload;
procedure STATUS(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
procedure STATUS(Msg: string); overload;

// Error message
procedure ERROR(ResultCode: LongInt; Msg: string); overload;
procedure ERROR(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
procedure ERROR(Msg: string); overload;
procedure ERROR(FormatString: string; Args: array of const); overload;

// Warning message
procedure WARN(ResultCode: LongInt; Msg: string); overload;
procedure WARN(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
procedure WARN(Msg: string); overload;
procedure WARN(FormatString: string; Args: array of const); overload;

// Statistical / debuggin info
procedure INFO(ResultCode: LongInt; Msg: string); overload;
procedure INFO(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
procedure INFO(Msg: string); overload;
procedure INFO(FormatString: string; Args: array of const); overload;

// Procedure tracing messages
procedure TRACE(ResultCode: LongInt; Msg: string); overload;
procedure TRACE(ResultCode: LongInt; FormatString: string; Args: array of const); overload;
procedure TRACE(Msg: string = ''; ProcAddr: Pointer = nil); overload;
procedure TRACE(FormatString: string; Args: array of const); overload;

{ ==============================================================================
  ## Global Reference
  ============================================================================ }
var
  Debugging: TDebugging;

implementation
{ ==============================================================================
  ## IMPLEMENTATION
  ============================================================================ }

uses
  SysUtils;
  
{ ==============================================================================
  ## Static helper functions
  * Deprecated
  ============================================================================ }
// High-level application status message feedback
procedure STATUS(ResultCode: LongInt; Msg: string);
begin
  if Assigned(Debugging) then
    Debugging.STATUS(ResultCode, Msg);
end;

procedure STATUS(Msg: string); overload;
begin
  if Assigned(Debugging) then
    Debugging.STATUS(Msg);
end;

procedure STATUS(ResultCode: LongInt; FormatString: string; Args: array of const);
begin
  if Assigned(Debugging) then
    Debugging.STATUS(ResultCode, FormatString, Args);
end;

// Error message
procedure ERROR(ResultCode: LongInt; Msg: string);
begin
  if Assigned(Debugging) then
    Debugging.ERROR(ResultCode, Msg);
end; {}

procedure ERROR(Msg: string);
begin
  if Assigned(Debugging) then
    Debugging.ERROR(Msg);
end;

procedure ERROR(FormatString: string; Args: array of const);
begin
  if Assigned(Debugging) then
    Debugging.ERROR(FormatString, Args);
end;

procedure ERROR(ResultCode: LongInt; FormatString: string; Args: array of const);
begin
  // Format user message
  if Assigned(Debugging) then
    Debugging.ERROR(ResultCode, FormatString, Args);
end; {}

// Warning message
procedure WARN(Msg: string);
begin
  if Assigned(Debugging) then
    Debugging.WARN(Msg);
end;

procedure WARN(FormatString: string; Args: array of const);
begin
  if Assigned(Debugging) then
    Debugging.WARN(FormatString, Args);
end;

// Statistical / debuggin info
procedure INFO(Msg: string);
begin
  if Assigned(Debugging) then
    Debugging.INFO(Msg);
end;

procedure INFO(FormatString: string; Args: array of const);
begin
  if Assigned(Debugging) then
    Debugging.INFO(FormatString, Args);
end;

// Procedure tracing messages
procedure TRACE(Msg: string = ''; ProcAddr: Pointer = nil);
begin
  if Assigned(Debugging) then
    Debugging.TRACE(Msg, ProcAddr);
end;

procedure TRACE(FormatString: string; Args: array of const);
begin
  if Assigned(Debugging) then
    Debugging.TRACE(FormatString, Args);
end;

procedure TRACE(ResultCode: LongInt; Msg: string);
begin
  if Assigned(Debugging) then
    Debugging.TRACE(ResultCode, Msg);
end; {}

procedure TRACE(ResultCode: LongInt; FormatString: string; Args: array of const);
begin
  // Format user message
  if Assigned(Debugging) then
    Debugging.TRACE(ResultCode, FormatString, Args);
end; {}

procedure WARN(ResultCode: LongInt; Msg: string);
begin
  if Assigned(Debugging) then
    Debugging.WARN(ResultCode, Msg);
end; {}

procedure WARN(ResultCode: LongInt; FormatString: string; Args: array of const);
begin
  // Format user message
  if Assigned(Debugging) then
    Debugging.WARN(ResultCode, FormatString, Args);
end; {}

procedure INFO(ResultCode: LongInt; Msg: string);
begin
  if Assigned(Debugging) then
    Debugging.INFO(ResultCode, Msg);
end; {}

procedure INFO(ResultCode: LongInt; FormatString: string; Args: array of const);
begin
  if Assigned(Debugging) then
    Debugging.INFO(ResultCode, FormatString, Args);
end; {}

initialization
  // Default Debug handler
  Debugging := TDebugging.Create;

finalization
  if Assigned(Debugging) then
    FreeAndNil(Debugging);
end.

