{
Source Name: uExecServiceExecute
Description: A Exec service execution unit
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uExecServiceExecute;

interface

{$WARN SYMBOL_DEPRECATED OFF}

uses
  // Standard
  Windows,
  SysUtils,
  Controls,
  Forms,
  Messages,
  shellAPI,
  fileutils,
  Classes,
  Graphics,
  Registry,

  // Calc Express
  CalcExpress,


  // Common
  SharpApi,

  // JCL
  JclFileUtils,
  JclSysInfo,
  Jclstrings,
  JclShell,

  // Project
  uExecServicePathIncludeList,
  uExecServiceAliasList,
  uExecServiceRecentItemList,
  uExecServiceUsedItemList,
  uExecServiceSettings;

type
  TExecFileCommandl = record
    Filename: string;
    Commandline: string;
  end;

type
  TSharpExec = class
  private

    Calc: TCalcExpress;

    FAliasValue: string;
    FDebugText: String;
    FUseDebug: Boolean;
    procedure SetAliasValue(const Value: string);

  public
    PathIncludeList: TPathIncludeList;
    AliasList: TAliasList;
    RecentItemList: TRecentItemsList;
    UsedItemList: TUsedItemsList;
    ExecSettings: TExecSettings;
    slAliases: Tstringlist;
    calcanswer: string;

    constructor Create;
    destructor Destroy; override;
    function ProcessString(Text: string; SaveHistory: Boolean = True): Boolean;
    property UseDebug: Boolean read FUseDebug write FUseDebug;
    property DebugText: String read FDebugText write FDebugText;
  protected

  private
    function ForceForegroundWindow(hwnd: THandle): Boolean;
    function ProcessAliases(text: string): boolean;
    function ProcessAppPaths(text: string): boolean;
    property AliasValue: string read FAliasValue write SetAliasValue;
    function ExecuteText(text: string; SaveHistory: Boolean): boolean;
    function GetAltExplorer(): string;

    function IsDirectory(const FileName: string): Boolean;
    function StrtoFileandCmd(str: string): TExecFileCommandl;
    procedure AddFilesToList(var strl: tstrings; directory: string; extension:
      string);
    function FileExistsIn(FileName: string; location: string; extension:
      string): string;
    function IsCalcStrValid(Str: string): Boolean;
    function ShellOpenFile(hWnd: HWND; AFileName, AParams, ADefaultDir: string):
      integer;
    procedure SaveRecentItem(Str: string; SaveHistory: Boolean);
    procedure SaveMostUsedItem(Str: string; SaveHistory: Boolean);
  end;

const
  capppaths = 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths';

  // ** ERROR CONSTANTS **
  cErrorFormula = 'Error in Formula';
var
  fullscreen: Boolean;
  Handle: THandle;
  showans: boolean;

  SharpExec: TSharpExec;

implementation

uses Math;

{=============================================================================
  Procedure: StrtoFileandCmd
    Arguments: strl: tstringlist; str: String
    Result:    None

  Splits the file and command in a string
==============================================================================}

function TSharpExec.StrtoFileandCmd(str: string): TExecFileCommandl;
var
  filetoexecute, commandline: string;
  i, j: Integer;
  tmp, s: string;
  tokens: Tstringlist;
  rs: boolean;

begin
  // Iniitialise
  if str <> '' then begin
    filetoexecute := '';
    commandline := '';
    Result.Filename := '';
    Result.Commandline := '';

  // First check if the first char is a quote
    if str[1] = '"' then begin
      s := Copy(str, 2, length(str));
      i := Pos('"', s);

      Result.Filename := Copy(str, 2, i - 1);
      Result.Commandline := Copy(str, i + 2, length(str));
      Exit;
    end;

  // Remove quotes from quoted string
    str := StrRemoveChars(str, ['"']);

  // Get number of spaces in str
    tokens := TStringList.Create;
    try
      StrTokenToStrings(str, ' ', tokens);

      tmp := '';
      for i := 0 to tokens.count - 1 do begin
        filetoexecute := filetoexecute + tokens.Strings[i];
        tmp := filetoexecute;

        for j := 0 to Pred(PathIncludeList.Items.Count) do begin
          FileToExecute := fileexistsin(tmp, PathIncludeList[j].Path,
            PathIncludeList[j].WildCard);
        end;

        rs := False;
        if (filetoexecute <> tmp) and (filetoexecute <> str) then
          rs := True;

    // if the string is now an actual file then return the remainder as a command
        if FileExists(filetoexecute) and (isDirectory(filetoexecute) = false) then begin
          if rs then begin
            StrReplace(str, tmp, '');
            str := filetoexecute + str;
          end;

          commandline := copy(str, length(filetoexecute) + 1, length(str) - length(filetoexecute));
          if StrCompare(filetoexecute, commandline) = 0 then
            commandline := '';
          Result.Filename := Filetoexecute;
          Result.Commandline := commandline;
          Exit;
        end;
        AppendStr(filetoexecute, ' ');
      end;
    finally
      tokens.Free;
    end;
  end;
end;

{=============================================================================
  Procedure: AddFilesToList
    Arguments: strl: tstrings; directory: String; extension: String
    Result:    None

    Adds files to a StringList
==============================================================================}

procedure TSharpExec.AddFilesToList(var strl: tstrings; directory: string;
  extension: string);
begin
  BuildFileList(PathAddSeparator(directory) + extension, faAnyFile, strl);
end;

{=============================================================================
  Procedure: Create
    Arguments: None
    Result:    None

  The Constructor of the Main TSharpExec Class, Creates the various classes
  and components used within TSharpExec
==============================================================================}

constructor TSharpExec.Create;
var
  SrvSettingsPath: string;
  ExecSettingsFn, PiListFn, PiAliasFn, RiListFn, UiListFn: string;
begin
  // Create Calculator Component
  Calc := TCalcExpress.Create(nil);
  UseDebug := False;
  // Initialise XML Filenames
  SrvSettingsPath := GetSharpeUserSettingsPath +
    'SharpCore\Services\Exec\';
  ExecSettingsFn := SrvSettingsPath + 'Exec.xml';
  PiListFn := SrvSettingsPath + 'PiList.xml';
  PiAliasFn := SrvSettingsPath + 'AliasList.xml';
  RiListFn := SrvSettingsPath + 'RiList.xml';
  UiListFn := SrvSettingsPath + 'UiList.xml';

  // Initiliase the Classes
  PathIncludeList := TPathIncludeList.Create(PiListFn);
  AliasList := TAliasList.Create(PiAliasFn);
  RecentItemList := TRecentItemsList.Create(RiListFn);
  ExecSettings := TExecSettings.Create(ExecSettingsFn);
  UsedItemList := TUsedItemsList.Create(UiListFn);

  inherited;
end;

{=============================================================================
  Procedure: ExecuteText
    Arguments: text: String
    Result:    boolean

  Processes and executes the text passed to the function
==============================================================================}

function TSharpExec.ExecuteText(text: string; SaveHistory: Boolean): boolean;
var
  search, url, s: string;
  FileCommandl: TExecFileCommandl;
  handle: hwnd;
  oldhandle: hwnd;
  args: array[0..100] of extended; // array of arguments - variable values
  Valid: Boolean;
  iResult: Integer;

  link: TShellLink;
begin
  // Initialise the local variables
  url := text;
  showans := False;
  calcanswer := '';
  oldhandle := GetActiveWindow;
  handle := Application.MainFormHandle;

  ForceForegroundWindow(handle);
  try

    // Expand the Environment Variable in the string
    Debug('Passed Execution Text: ' + text, DMT_TRACE);
    text := FileUtils.ExpandEnvVars(text);
    s := Copy(text, 1, Length(text) - 2);

    if s <> text then
      Debug('Expanded Env Execution Text: ' + text, DMT_TRACE);
    text := s;
    
    // *** PROCESS THE TEXT BASED ON THE FOLLOWING CONDITIONS ***

    // New Vista control panel
    if (Pos('microsoft.', LowerCase(text)) = 1) then begin
        Debug('Execute CPL:', DMT_TRACE);

        if ShellOpenFile(Handle, GetWindowsSystemFolder+'/control.exe', '/name ' + text, '') = 1 then begin

        // Save to recent item list
          SaveMostUsedItem(text, SaveHistory);
          SaveRecentItem(text, SaveHistory);

          Result := True;
          Exit;
        end;
      end
    else

    // LNK files
    if (ExtractFileExt(text) = '.lnk') then begin
      if JclShell.ShellLinkResolve(text, link) = S_OK then begin
        if ShellOpenFile(Handle, link.Target, link.Arguments, link.WorkingDirectory) = 1 then begin

        // Save to recent item list
          SaveMostUsedItem(text, SaveHistory);
          SaveRecentItem(text, SaveHistory);

          Result := True;
          Exit;
        end;
      end;
    end
    else
    if ((ExtractFileExt(text) = '.sip') or (ExtractFileExt(text) = '.sescript')) then begin
      if ShellOpenFile(Handle,GetSharpeDirectory+'SharpScript.exe','"' + text + '"',GetSharpeDirectory) = 1 then begin
        Result := True;
        Exit;
      end;

    end
    else

    // ** SHELL: PATHS **
      if (Pos('shell:', LowerCase(text)) = 1) then begin
        Debug('Execute: SHELL:', DMT_TRACE);

        if ShellOpenFile(Handle, GetAltExplorer, text, '') = 1 then begin

        // Save to recent item list
          SaveMostUsedItem(text, SaveHistory);
          SaveRecentItem(text, SaveHistory);

          Result := True;
          Exit;
        end;
      end
      else if PathIsUNC(PathAddSeparator(text)) or (isdirectory(text)) then begin
        Debug('ExecuteType: Path', DMT_TRACE);
        iResult := ShellOpenFile(Handle, GetAltExplorer, text, '');

        if (iResult = 1) or (iResult = SE_ERR_ACCESSDENIED) then begin

        // Save to recent item list
          SaveMostUsedItem(text, SaveHistory);
          SaveRecentItem(text, SaveHistory);

          Result := True;
          Exit;
        end;
      end
      else if (Pos('#',
        LowerCase(text)) = 1) then begin
        Debug('ExecuteType: Calculation', DMT_TRACE);

      // Extract the calculation formulae
        search := StrAfter('#', text);

      // Check the calculation formula is valid
        Valid := IsCalcStrValid(search);
        if Valid then begin
          Calc.Formula := search;
          calcanswer := search + '=' + FloatToStr(Calc.calc(args));
        end
        else
          CalcAnswer := cErrorFormula;

        ShowAns := True;
        BarMsg('scmd', Pchar(CalcAnswer));

        Result := True;
        Exit;
      end
      else if (Pos('http',
        LowerCase(text)) = 1) or (Pos('www', LowerCase(text)) =
        1)
        or (Pos('irc', LowerCase(text)) = 1) or (Pos('ftp', LowerCase(text)) =
        1)
        or
        (Pos('news', LowerCase(text)) = 1) or (Pos('telnet', LowerCase(text))
        =
        1) then begin
        Debug('ExecuteType: Internet Protocol', DMT_TRACE);

      //if ShellExecute(Handle, 'open', pchar(text), nil, nil, SW_SHOWNORMAL);
        if ShellOpenFile(handle, text, '', '') = 1 then begin

        // Save to recent/used item list
          SaveMostUsedItem(text, SaveHistory);
          SaveRecentItem(text, SaveHistory);

          Result := True;
          Exit;
        end;
      end
      else if ((ExtractFileExt(text) = '.msc') and (Pos('mmc',lowercase(text)) <> 0)) then  begin
        Debug('ExecuteType: MSC Console', DMT_TRACE);

        if ShellOpenFile(Handle, GetWindowsSystemFolder + '\mmc.exe',
          GetWindowsSystemFolder + '\' + ExtractFileName(text), '') = 1 then begin

          SaveMostUsedItem(text, SaveHistory);
          SaveRecentItem(text, SaveHistory);

          Result := True;
          Exit;
        end;
      end;

    // Create a temp string to try and split the text into a file
    // and a command if applicable. Also searches paths for some
    // equivalent values}

    FileCommandl := StrtoFileandCmd(text);
    try
      if (FileCommandl.Filename <> '') then begin
        if fileexists(FileCommandl.FileName) then begin
          Debug('ExecuteType: ShellOpenFile:', DMT_TRACE);

          if ShellOpenFile(Handle, FileCommandl.Filename, FileCommandl.Commandline,
            ExtractFilePath(FileCommandl.Filename)) = 1 then begin

            // Save to recent item list
            SaveMostUsedItem(text, SaveHistory);
            SaveRecentItem(text, SaveHistory);

            Result := True;
            exit;
          end;
        end;
      end;
    except
      on E: Exception do begin
        Debug(Format('Error Executing: %s - %s', [FileCommandl.Filename,
          FileCommandl.Commandline]), DMT_WARN);
        Debug(E.Message, DMT_TRACE);
      end;
    end;

    // If all else fails try to execute the text, if this does not work discard it
    Debug('ExecuteType: Last ShellOpenFile:', DMT_TRACE);
    result := true;

    if ShellOpenFile(Handle, text, '', ExtractFilePath(text)) = 1 then begin
      SaveMostUsedItem(text, SaveHistory);
      SaveRecentItem(text, SaveHistory);

      Result := True;
    end;

  finally
    ForceForegroundWindow(oldhandle);

  end;
end;

{=============================================================================
  Procedure: ProcessString
    Arguments: text: String
    Result:    boolean

  A Method that processes a string passed to it, and checks whether the text
  is part of an alias
==============================================================================}

function TSharpExec.ProcessString(Text: string; SaveHistory: Boolean = True): Boolean;
var
  UseAlias: Boolean;
begin

  // Check if text is an Alias
  Debug('Original: ' + text, DMT_TRACE);
  UseAlias := ProcessAliases(Text);

  // Execute alias or if no other commands can be found process the
  // actual text passed to this function}

  if UseAlias = True then begin
    Debug(Format('Alias/ApplicationPath Exists: %s', [Text]), DMT_STATUS);
    Result := ExecuteText(AliasValue, SaveHistory);
    BarMsg('scmd', '_execupdate');
    Exit;
  end
  else begin
    Result := ExecuteText(Text, SaveHistory);
    BarMsg('scmd', '_execupdate');
    Exit;
  end;
end;

{=============================================================================
  Procedure: ProcessAliases
    Arguments: text: String
    Result:    boolean

  Process the Alias, and if necessary expand advanced aliases
==============================================================================}

function TSharpExec.ProcessAliases(text: string): boolean;
var
  i, j: integer;
  strl: tstringlist;
  s1: string;

  AliasName: string;
  ParamPos: Integer;
  Params: string;
  ParamsStrl: TStringList;
begin
  Result := False;

  // Initialise the String Lists
  ParamsStrl := TStringList.Create;
  Strl := TStringList.Create;
  try

  // Extract Name
    StrTokenToStrings(text, ' ', strl);
    if strl.Count > 0 then
      AliasName := Strl.Strings[0];

  // Extract Params
    ParamPos := Pos(' ', text);
    Params := Copy(text, ParamPos + 1, length(text) - ParamPos + 1);
    StrTokenToStrings(Params, ',', ParamsStrl);

    for i := 0 to Pred(AliasList.Items.Count) do begin

    // Check if there is a match in the Alias List
      if StrCompare(AliasName, AliasList[i].AliasName) = 0 then begin

        Debug('Alias Property: ' + AliasList[i].AliasName + ' - ' +
          AliasList[i].AliasValue, DMT_TRACE);

        Result := true;
        AliasValue := AliasList[i].AliasValue;

      // Check for various defined application paths
        for j := 0 to Pred(PathIncludeList.Items.Count) do begin
          AliasValue := fileexistsin(AliasValue, PathIncludeList[j].Path,
            PathIncludeList[j].WildCard);
        end;

      // Expand the Environment Vars
        aliasvalue := FileUtils.ExpandEnvVars(aliasvalue);
        aliasvalue := Copy(aliasvalue, 1, Length(aliasvalue) - 2);

      // Expand the advanced alias
        if ParamsStrl.Count >= 1 then begin

          s1 := AliasValue;
          for j := 0 to ParamsStrl.Count - 1 do begin
            StrReplace(s1, '%' + inttostr(j + 1), ParamsStrl.Strings[j]);
          end;

          AliasValue := s1;

          if ParamsStrl.count = 0 then
            SetAliasValue(AliasValue + ' ' + Params)
          else
            SetAliasValue(AliasValue);

        end;
      end;
    end;

  // if the text is not an alias then check to see if it is actually an
  // application path, and if it does exist then return this as the result.
  // If not then return nothing and result will equal to false

    if result <> true then
      result := ProcessAppPaths(text)
    else
      exit;

  finally
    ParamsStrl.Free;
    strl.Free;
  end;
end;

{=============================================================================
  Procedure: ProcessAppPaths
    Arguments: text: String
    Result:    boolean

  Check the passed string with Windows Application Paths
==============================================================================}

function TSharpExec.ProcessAppPaths(text: string): boolean;
var
  reg: tregistry;
  strlist, windowsfolderlist, systemfolderlist: tstringlist;
  str: string;
  i, j: integer;
  alval: string;
  tokens: tstringlist;
begin


  // StringList Intialisation
  windowsfolderlist := TStringList.Create;
  systemfolderlist := TStringList.Create;
  tokens := tstringlist.Create;
  reg := Tregistry.Create;
  strlist := TStringlist.create;
  Try

    // Store Common Paths into a StringList
    reg.rootkey := HKEY_LOCAL_MACHINE;
    Reg.OpenKey(capppaths, true);
    Reg.GetKeyNames(strlist);

    for i := 0 to (Strlist.count - 1) do begin

      // Remove Extension
      str := strlist.Strings[i];
      str := StrChopRight(str, 4);

      // If there is match return the Application path
      if StrCompare(str, pathremoveextension(text)) = 0 then begin
        reg.OpenKey(strlist.Strings[i], false);
        AliasValue := reg.ReadString('');
        result := true;
        exit;
      end
    end;

    alval := text;

    // If there is no match check against the pathinclusions
    for j := 0 to Pred(PathIncludeList.Items.Count) do begin
      AliasValue := fileexistsin(text, PathIncludeList[j].Path,
        PathIncludeList[j].WildCard);

      if ((StrCompare(AliasValue, alval) <> 0) and (AliasValue <> '')) then begin
        Result := True;
        Exit;
      end;
    end;

    // If there are no matches then the result is false}
    Result := False;

  finally
    windowsfolderlist.Free;
    systemfolderlist.Free;
    reg.Free;
    strlist.Free;
    tokens.Free;
  end;
end;

{=============================================================================
  Procedure: SetAliasValue
    Arguments: Const Value: String
    Result:    None
==============================================================================}

procedure TSharpExec.SetAliasValue(const Value: string);
begin
  FAliasValue := Value;
end;

{=============================================================================
  Procedure: IsDirectory
    Arguments: Const FileName: String
    Result:    Boolean
==============================================================================}

function TsharpExec.IsDirectory(const FileName: string): Boolean;
var
  R: DWORD;
begin
  R := GetFileAttributes(PChar(FileName));
  Result := (R <> DWORD(-1)) and ((R and FILE_ATTRIBUTE_DIRECTORY) <> 0);
end;

{=============================================================================
  Procedure: GetAltExplorer
    Arguments:
    Result:    String
==============================================================================}

function TSharpExec.GetAltExplorer(): string;
begin
  if (ExecSettings.AltExplorer = '') or (not
    (FileExists(ExecSettings.AltExplorer))) then
    Result := PathAddSeparator(GetWindowsFolder) + 'Explorer.exe'
  else
    Result := ExecSettings.AltExplorer;
end;

{=============================================================================
  Procedure: FileExistsIn
    Arguments: FileName: String; location: String; extension: String
    Result:    String
==============================================================================}

function TSharpExec.FileExistsIn(FileName: string; location: string; extension:
  string):
  string;
var
  templist: TStrings;
  i: Integer;
  withoute, withe: string;

begin

  location := PathAddSeparator(location);

  // Populate the StringList
  templist := TStringList.Create;
  AddFilesToList(templist, location, extension);

  try

    for i := 0 to templist.count - 1 do begin

      // Remove Extension
      withoute := templist.Strings[i];
      withoute := StrChopRight(withoute, 4);

      // Leave Extension Intact
      withe := templist.Strings[i];

      // If there is a match then return the location}
      if (StrCompare(withoute, filename) = 0) or (StrCompare(withe, filename) = 0) then begin
        result := location + templist.Strings[i];
        Exit;
      end
      else
        Result := lowercase(FileName);
    end;

  finally
    templist.clear;
    templist.Free;
  end;

end;

{=============================================================================
  Procedure: Destroy
    Arguments: None
    Result:    None
==============================================================================}

destructor TSharpExec.Destroy;
begin
  PathIncludeList.Free;
  AliasList.Free;
  ExecSettings.Free;
  Calc.Free;
  RecentItemList.Free;
  UsedItemList.Free;

  inherited Destroy;
end;

{=============================================================================
  Procedure: IsCalcStrValid
    Arguments: Str: String
    Result:    Boolean
==============================================================================}

function TSharpExec.IsCalcStrValid(Str: string): Boolean;
var
  i: integer;
  Valid: Boolean;
begin
  Valid := False;

  for i := 0 to Pred(length(Str)) do begin
    Valid := False;
    case Str[i + 1] of
      '(': Valid := True;
      ')': Valid := True;
      '+': Valid := True;
      '-': Valid := True;
      '*': Valid := True;
      '/': Valid := True;
      '^': Valid := True;
      '.': Valid := True;
      'a'..'z', 'A'..'Z', '_': Valid := True;
      '1'..'9', '0': Valid := True;
    end;

    if Valid = False then
      Break;
  end;

  if Valid then
    Result := True
  else
    Result := False;
end;

function TSharpExec.ShellOpenFile(hWnd: HWND; AFileName, AParams, ADefaultDir:
  string): integer;
begin
  Debug('FileName: ' + AFileName, DMT_TRACE);
  Debug('dir: ' + ADefaultDir, DMT_TRACE);

  if FUseDebug then begin
    FDebugText := AFileName + ' ' + ADefaultDir + ' ' + AParams;
    Result := 1;
  end else
  result := shellapi.ShellExecute(hWnd, nil, pChar(AFileName),
    pChar(AParams),
    pChar(ADefaultDir),
    SW_SHOWNORMAL);

  case result of
    0: Debug('The operating system is out of memory or resources.', DMT_ERROR);
    ERROR_FILE_NOT_FOUND: Debug('The specified file was not found.', DMT_ERROR);
    ERROR_PATH_NOT_FOUND: Debug('The specified path was not found.', DMT_ERROR);
    ERROR_BAD_FORMAT:
      Debug('The .EXE file is invalid (non-Win32 .EXE or error in .EXE image).',
        DMT_ERROR);
    SE_ERR_ACCESSDENIED:
      Debug('The operating system denied access to the specified file.',
        DMT_ERROR);
    SE_ERR_ASSOCINCOMPLETE:
      Debug('The filename association is incomplete or invalid.', DMT_ERROR);
    SE_ERR_DDEBUSY:
      Debug('The DDE transaction could not be completed because other DDE transactions were being processed.', DMT_ERROR);
    SE_ERR_DDEFAIL: Debug('The DDE transaction failed.', DMT_ERROR);
    SE_ERR_DDETIMEOUT:
      Debug('The DDE transaction could not be completed because the request timed out.',
        DMT_ERROR);
    SE_ERR_DLLNOTFOUND:
      Debug('The specified dynamic-link library was not found.', DMT_ERROR);
    SE_ERR_NOASSOC:
      Debug('There is no application associated with the given filename extension.', DMT_ERROR);
    SE_ERR_OOM: Debug('There was not enough memory to complete the operation.',
        DMT_ERROR);
    SE_ERR_SHARE: Debug('A sharing violation occurred.', DMT_ERROR);
  else begin
      Debug('Executed successfully', DMT_TRACE);
      Result := 1;
    end;
  end;
end;

procedure TSharpExec.SaveMostUsedItem(Str: string; SaveHistory: Boolean);
begin
  if SaveHistory then begin
    UsedItemList.Add(Str);
    UsedItemList.Save;
  end;
end;

procedure TSharpExec.SaveRecentItem(Str: string; SaveHistory: Boolean);
begin
  if SaveHistory then begin
    RecentItemList.Add(Str);
    RecentItemList.Save;
  end;
end;

function TSharpExec.ForceForegroundWindow(hwnd: THandle): Boolean;
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

end.

