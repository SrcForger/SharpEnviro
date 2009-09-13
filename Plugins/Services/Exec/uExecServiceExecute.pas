{
Source Name: uExecServiceExecute
Description: A Exec service execution unit
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit uExecServiceExecute;

interface

{$WARN SYMBOL_DEPRECATED OFF}

uses
  // Standard
  Windows,
  SysUtils,
  shellAPI,
  fileutils,
  Classes,
  Registry,
  Contnrs,
  ShlObj,
  ActiveX,

  // Common
  SharpApi,
  uVistaFuncs,
  uSystemFuncs,

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
  TExecItem = class
    Text: string;
    SaveHistory: Boolean;
    Elevate: Boolean;
  end;

  TSharpExec = class(TThread)
  private
    FDebugText: string;
    FUseDebug: Boolean;
    FExecList: TObjectList;

  public
    PathIncludeList: TPathIncludeList;
    AliasList: TAliasList;
    RecentItemList: TRecentItemsList;
    UsedItemList: TUsedItemsList;
    ExecSettings: TExecSettings;
    slAliases: Tstringlist;
    calcanswer: string;
    FAppPathList: TStringList;
    constructor Create;

    destructor Destroy; override;
    procedure AddProcessString(Text: string; SaveHistory: Boolean = True; Elevate: Boolean = False);
    function ProcessString(Text: string; SaveHistory: Boolean = True; Elevate: Boolean = False): Boolean;
    property UseDebug: Boolean read FUseDebug write FUseDebug;
    property DebugText: string read FDebugText write FDebugText;

    property AppPathList: TStringList read FAppPathList write
      FAppPathList;
    procedure ReloadLists;
  protected
    procedure Execute; override;
  private
    function ForceForegroundWindow(hwnd: Thandle; var oldhwnd: THandle): Boolean;
    function ExecuteText(text: string; SaveHistory: Boolean; Elevate: Boolean): boolean;
    function GetAltExplorer(): string;

    function IsDirectory(const FileName: string): Boolean;
    function StrtoFileandCmd(str: string): TExecFileCommandl;
    procedure AddFilesToList(strl: tstrings; directory: string; extension:
      string; fullpath: boolean);
    function FileExistsIn(FileName: string; location: string; extension:
      string): string;
    function ShellOpenFile(hWnd: HWND; AFileName, AParams, ADefaultDir: string; Elevate: Boolean):
      integer;

    procedure SaveRecentItem(Str: string; SaveHistory: Boolean);
    procedure SaveMostUsedItem(Str: string; SaveHistory: Boolean);

    procedure PopulateAppPathsList;
    procedure ExpandCommonFiles(var AText: string);
    function ExpandAliases(var AText: string; var AElevate: Boolean): Boolean;
    function CreateProcessExecute(APath : String):Boolean;
  end;

const
  capppaths = 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths';

  IID_IPersistFile: TGUID = (
    D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  // ** ERROR CONSTANTS **
  cErrorFormula = 'Error in Formula';
var
  fullscreen: Boolean;
  Handle: THandle;
  showans: boolean;

  SharpExec: TSharpExec;

function AllowSetForegroundWindow(ProcessID : DWORD) : boolean; stdcall; external 'user32.dll' name 'AllowSetForegroundWindow';

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

          if CompareText(FileToExecute,tmp) <> 0 then break;
        end;

        rs := False;
        if (filetoexecute <> tmp) and (filetoexecute <> str) then
          rs := True;

        // if the string is now an actual file then return the remainder as a command
        if FileExists(filetoexecute) and (isDirectory(filetoexecute) = false) then begin
          if rs then begin
            StrReplace(str, tmp, '', [rfIgnoreCase]);
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

procedure TSharpExec.AddFilesToList(strl: tstrings; directory: string;
  extension: string; fullpath: boolean);
begin
  if fullpath then
    AdvBuildFileList(PathAddSeparator(directory) + extension, faAnyFile, strl, amAny, [flFullNames]) else
    AdvBuildFileList(PathAddSeparator(directory) + extension, faAnyFile, strl);
end;

{=============================================================================
  Procedure: Create
    Arguments: None
    Result:    None

  The Constructor of the Main TSharpExec Class, Creates the various classes
  and components used within TSharpExec
==============================================================================}

procedure TSharpExec.AddProcessString(Text: string; SaveHistory, Elevate: Boolean);
var
  item: TExecItem;
begin
  item := TExecItem.Create;
  item.Text := Text;
  item.SaveHistory := SaveHistory;
  item.Elevate := Elevate;
  FExecList.Add(item);
end;

constructor TSharpExec.Create;
var
  SrvSettingsPath: string;
  ExecSettingsFn, PiListFn, PiAliasFn, RiListFn, UiListFn: string;
begin
  inherited Create(True);
  FExecList := TObjectList.Create(True);
  FreeOnTerminate := False;

  // Create Calculator Component
  UseDebug := False;

  // Initialise XML Filenames
  SrvSettingsPath := GetSharpeUserSettingsPath + 'SharpCore\Services\Exec\';
  ExecSettingsFn := SrvSettingsPath + 'Exec.xml';
  PiListFn := SrvSettingsPath + 'PiList.xml';
  PiAliasFn := SrvSettingsPath + 'AliasList.xml';
  RiListFn := SrvSettingsPath + 'RiList.xml';
  UiListFn := SrvSettingsPath + 'UiList.xml';

  // Initiliase the Classes
  PathIncludeList := TPathIncludeList.Create(PiListFn);
  AliasList := TAliasList.Create;
  AliasList.FileName := PiAliasFn;
  RecentItemList := TRecentItemsList.Create(RiListFn);
  ExecSettings := TExecSettings.Create(ExecSettingsFn);
  UsedItemList := TUsedItemsList.Create(UiListFn);

  FAppPathList := TStringList.Create;
  PopulateAppPathsList;

  Resume;
end;

{=============================================================================
  Procedure: ExecuteText
    Arguments: text: String
    Result:    boolean

  Processes and executes the text passed to the function
==============================================================================}

procedure TSharpExec.Execute;
var
  item: TExecItem;
begin
  while not Terminated do
  begin
    while FExecList.Count > 0 do
    begin
      item := TExecItem(FExecList.Items[0]);
      ProcessString(item.Text, item.SaveHistory, item.Elevate);
      FExecList.Remove(item);
    end;
    Suspend;
  end;
end;

function TSharpExec.CreateProcessExecute(APath : String):Boolean;
var
  StartInfo : TStartupInfo;
  ProcInfo : TProcessInformation;
  CreateOK : Boolean;
  Dir : String;
begin
  { fill with known state }
  Debug('Attempting to execute with Create Process',DMT_INFO);
  
  Result := True;
  FillChar(StartInfo,SizeOf(TStartupInfo),#0);
  FillChar(ProcInfo,SizeOf(TProcessInformation),#0);
  StartInfo.cb := SizeOf(TStartupInfo);
  Dir := Trim(ExtractFilePath(APath));
  if not SysUtils.DirectoryExists(Dir) then
    Dir := '';
  CreateOK := CreateProcess(nil, PChar(APath), nil, nil,False,
              CREATE_DEFAULT_ERROR_MODE or CREATE_NEW_CONSOLE
              or NORMAL_PRIORITY_CLASS,
              nil, PChar(Dir), StartInfo, ProcInfo);

  if Not(CreateOK) then begin
    Result := False;
    Debug('Unable to execute using CreateProcess. Continue with execution.',DMT_INFO);
  end else
    Debug('Executed Successfully ',DMT_INFO);

  CloseHandle(ProcInfo.hProcess);
  CloseHandle(ProcInfo.hThread);
end;

function GetFilePathFromLink(const sLink: String):
    WideString;
var
  sWidePath: Array [0..260] of WideChar;
  sFoundPath: Array [0..MAX_PATH] of WideChar;
  AShellLink : IShellLinkW;
  wfd : _WIN32_FIND_DATAW;
  PersistFile : IPersistFile;
begin
  Result := '';
  (* Create a shellLink object *)
  if CoCreateInstance(CLSID_ShellLink,
                     nil,
                     CLSCTX_INPROC_SERVER,
                     IID_IShellLinkW,
                     AShellLink) <> S_OK then
    raise Exception.Create('unable to create a ShellLink');


  (* Give the shell link a path to resolve *)
  AShellLink.SetPath(PWideChar(sLink));
  if AShellLink.Resolve(HInstance,SLR_UPDATE) = S_OK then
  begin

    (* Use the shelllink object to gain access to its PersistFile interface *)
    if Failed(AShellLink.QueryInterface(IID_IPersistFile,PersistFile)) then
      raise Exception.Create('Unable to create an IPersistFile instance');

    (* Load the file into the PersistFile object *)
    // we must convert the ansi string to be a widestring to pass to 'PersistFile.Load'
    MultiByteToWideChar(CP_ACP,
                        MB_PRECOMPOSED,
                        PChar(sLink),
                        -1,
                        @sWidePath,
                        MAX_PATH);
    if PersistFile.Load(sWidePath,STGM_READ) <> S_OK then
      raise Exception.Create('unable to load file');

    (* Now the file is loaded we can ask the OS to provide us with its
       original path *)
    if AShellLink.GetPath(sFoundPath,MAX_PATH,wfd,SLGP_RAWPATH) <> NOERROR  then
      raise Exception.Create('unable to get path');

    result := sFoundPath;
  end;
end;

function NETLinkLaunch(textstripped : string; elevate : Boolean) : Boolean;
const
  linktimeout = 2000;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  s : String;
begin
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb := SizeOf(SUInfo);
  s := '"' + GetSharpeDirectory + 'SharpLinkLauncherNET.exe"' + ' -l:"' + textstripped +'" -t:' + inttostr(3000) + ' -e:' + BoolToStr(elevate, true);
  Debug('Execute: SharpLinkLauncherNET with param: ' + s, DMT_TRACE);
  Result := CreateProcess(PChar(GetSharpeDirectory + 'SharpLinkLauncherNET.exe'),
                          PChar(s), nil, nil, False,
                          CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,
                          nil, nil,
                          SUInfo, ProcInfo);
  // Wait for it to finish initialization
  if Result then
    WaitForInputIdle(ProcInfo.hProcess,linktimeout);
  AllowSetForegroundWindow(ProcInfo.dwProcessId);
  PostThreadMessage(ProcInfo.dwThreadId,WM_SHARPELINKLAUNCH,0,0);
end;

function TSharpExec.ExecuteText(text: string; SaveHistory: Boolean; Elevate: Boolean): boolean;
var
  url: string;
  FileCommandl: TExecFileCommandl;
  handle: THandle;
  oldhandle: THandle;
  iResult: Integer;

  failed,forceshelllinkopen : boolean;
  link: TShellLink;

  striparray : array[0..0] of char;
  textstripped : string;
begin
  // Initialise the local variables
  url := text;
  showans := False;
  calcanswer := '';
  handle := FindWindow('TSharpCoreMainWnd', nil);

  striparray[0] := '"';
  textstripped := StrRemoveChars(text,striparray);

  ForceForegroundWindow(handle, oldhandle);
  try

    Debug('Passed Execution Text: ' + text, DMT_TRACE);

    // *** PROCESS THE TEXT BASED ON THE FOLLOWING CONDITIONS ***

    // First try create process
    if not(Elevate) then
      if CreateProcessExecute(text) then begin

        SaveMostUsedItem(text, SaveHistory);
        SaveRecentItem(text, SaveHistory);

        Result := True;
        Exit;
      end;

    // New Vista control panel
    if (Pos('microsoft.', LowerCase(text)) = 1) then begin
      Debug('Execute CPL:', DMT_TRACE);

      if ShellOpenFile(Handle, GetWindowsSystemFolder + '/control.exe', '/name ' + text, '', Elevate) = 1 then begin

        // Save to recent item list
        SaveMostUsedItem(text, SaveHistory);
        SaveRecentItem(text, SaveHistory);

        Result := True;
        Exit;
      end;
    end
    else
      // LNK files
      if (ExtractFileExt(textstripped) = '.lnk') then
      begin
        failed := True;
        forceshelllinkopen := False;
        CoInitialize(nil);
        if JclShell.ShellLinkResolve(textstripped, link) = S_OK then
        begin
          if (length(trim(link.Target)) = 0) and (length(trim(link.IconLocation)) = 0) then
          begin
            link.Target := text;
            forceshelllinkopen := true;
          end;

          if (uSystemFuncs.NETFramework35)
            and (SysUtils.FileExists(GetSharpeDirectory + 'SharpLinkLauncherNET.exe'))
            and (not forceshelllinkopen) then
          begin
            result := NETLinkLaunch(textstripped, Elevate);
            SaveMostUsedItem(text, SaveHistory);
            SaveRecentItem(text, SaveHistory);            
            exit;
          end;

          if ShellOpenFile(Handle, link.Target, link.Arguments, link.WorkingDirectory, Elevate) = 1 then
          begin
            // Save to recent item list
            SaveMostUsedItem(text, SaveHistory);
            SaveRecentItem(text, SaveHistory);

            Result := True;
            Exit;
          end;
        end;
        CoUninitialize;
        if Failed then
          if (uSystemFuncs.NETFramework35) //and IsWow64()
            and (SysUtils.FileExists(GetSharpeDirectory + 'SharpLinkLauncherNET.exe')) then
          begin
            result := NETLinkLaunch(textstripped, Elevate);
            SaveMostUsedItem(text, SaveHistory);
            SaveRecentItem(text, SaveHistory);            
            exit;
          end
      end
      else
        if ((ExtractFileExt(textstripped) = '.sip') or (ExtractFileExt(textstripped) = '.sescript')) then begin
          if ShellOpenFile(Handle, GetSharpeDirectory + 'SharpScript.exe', '"' + textstripped + '"', GetSharpeDirectory, Elevate) = 1 then begin
            Result := True;
            Exit;
          end;

        end
        else

          // ** SHELL: PATHS **
          if (Pos('shell:', LowerCase(text)) = 1) then begin
            Debug('Execute: SHELL:', DMT_TRACE);
            if IsWindowsVista then
            begin
              if CompareText(text,'shell:drivefolder') = 0 then
                text := 'shell:MyComputerFolder';
            end else
              if CompareText(text,'shell:MyComputerFolder') = 0 then
                text := 'shell:drivefolder';

            if ShellOpenFile(Handle, GetAltExplorer, text, '', Elevate) = 1 then begin

              // Save to recent item list
              SaveMostUsedItem(text, SaveHistory);
              SaveRecentItem(text, SaveHistory);

              Result := True;
              Exit;
            end;
          end
          else if PathIsUNC(PathAddSeparator(textstripped)) or (isdirectory(textstripped)) then begin
            Debug('ExecuteType: Path', DMT_TRACE);
            iResult := ShellOpenFile(Handle, GetAltExplorer, text, '', Elevate);

            if (iResult = 1) or (iResult = SE_ERR_ACCESSDENIED) then begin

              // Save to recent item list
              SaveMostUsedItem(text, SaveHistory);
              SaveRecentItem(text, SaveHistory);

              Result := True;
              Exit;
            end;
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
            if ShellOpenFile(handle, text, '', '', Elevate) = 1 then begin

              // Save to recent/used item list
              SaveMostUsedItem(text, SaveHistory);
              SaveRecentItem(text, SaveHistory);

              Result := True;
              Exit;
            end;
          end
          else if ((ExtractFileExt(textstripped) = '.msc') and (Pos('mmc', lowercase(text)) <> 0)) then begin
            Debug('ExecuteType: MSC Console', DMT_TRACE);

            if ShellOpenFile(Handle, GetWindowsSystemFolder + '\mmc.exe',
              GetWindowsSystemFolder + '\' + ExtractFileName(text), '', Elevate) = 1 then begin

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
            ExtractFilePath(FileCommandl.Filename), Elevate) = 1 then begin

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
    Debug('Param: ' + text, DMT_TRACE);
    result := true;

    if ShellOpenFile(Handle, text, '', ExtractFilePath(text), Elevate) = 1 then begin
      SaveMostUsedItem(text, SaveHistory);
      SaveRecentItem(text, SaveHistory);

      Result := True;
    end;

  finally
    //ForceForegroundWindow(oldhandle, oldhandle);

  end;
end;

{=============================================================================
  Procedure: ProcessString
    Arguments: text: String
    Result:    boolean

  A Method that processes a string passed to it, and checks whether the text
  is part of an alias
==============================================================================}

function TSharpExec.ProcessString(Text: string; SaveHistory: Boolean = True; Elevate: Boolean = False): Boolean;
var
  s: string;
begin
  Result := False;
  s := Trim(Text);
  if s = '' then exit;
  Text := s;
  Debug('Original: ' + text, DMT_TRACE);

  // Expand Enviro Vars
  Text := FileUtils.ExpandEnvVars(text);
  s := Copy(text, 1, Length(text) - 2);
  Text := s;

  // Expand Common Files - Scans the text and expands the filename
  if (Pos('shell:', LowerCase(text)) <> 1) then begin

    if not (ExpandAliases(Text, Elevate)) then
      ExpandCommonFiles(Text);
  end;
  Result := ExecuteText(Text, SaveHistory, Elevate);
  BarMsg('scmd', '_execupdate');
end;

procedure TSharpExec.ReloadLists;
begin
  PathIncludeList.Items.Clear;
  PathIncludeList.Load;

  AliasList.Clear;
  AliasList.Load;

  ExecSettings.Load;

  RecentItemList.Items.Clear;
  RecentItemList.Load;

  UsedItemList.Items.Clear;
  UsedItemList.Load;
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
  AddFilesToList(templist, location, extension, false);

  try

    for i := 0 to templist.count - 1 do begin

      // Remove Extension
      withoute := templist.Strings[i];
      setlength(withoute,length(withoute) - length(ExtractFileExt(withoute)));

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
  FExecList.Free;
  PathIncludeList.Free;
  AliasList.Free;
  ExecSettings.Free;
  RecentItemList.Free;
  UsedItemList.Free;

  FAppPathList.Free;

  inherited Destroy;
end;

function PCharOrNil(const S: string): PChar;
begin
  Result := Pointer(S);
end;

function TSharpExec.ShellOpenFile(hWnd: HWND; AFileName, AParams, ADefaultDir:
  string; Elevate: Boolean): integer;
var
  sOperation: string;
begin
  // make sure no empty strings which are only containing spaces are passes
  // as params, this can kill SharpExecute
  AFileName := trim(AFileName);
  AParams := trim(AParams);
  ADefaultDir := trim(ADefaultDir);

  Debug('FileName: ' + AFileName, DMT_TRACE);
  Debug('Params: ' + AParams, DMT_TRACE);
  Debug('dir: ' + ADefaultDir, DMT_TRACE);

  if Elevate then sOperation := 'runas' else sOperation := '';

  // don't even try to execute if no target was resolved before
  if length(AFileName) = 0 then
  begin
    Debug('The specified file was not found.', DMT_ERROR);
    Result := 0;
    exit;
  end;

  if FUseDebug then begin
    FDebugText := Format('File: %s -- Param: %s -- Dir: %s', [AFileName, AParams, ADefaultDir]);
    Result := 1;
  end else
  begin
    result := shellapi.ShellExecute(0, PChar(sOperation), pChar(AFileName),
      pChar(AParams),
      pChar(ADefaultDir),
      SW_SHOWNORMAL);
  end;
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
    Debug('Add to most used items: ' + Str, DMT_INFO);

    UsedItemList.Save;
  end;
end;

procedure TSharpExec.SaveRecentItem(Str: string; SaveHistory: Boolean);
begin
  if SaveHistory then begin
    RecentItemList.Add(Str);
    Debug('Add to recent items: ' + Str, DMT_INFO);

    RecentItemList.Save;
  end;
end;

function TSharpExec.ForceForegroundWindow(hwnd: Thandle; var oldhwnd: THandle): Boolean;
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

  oldhwnd := GetForegroundWindow;

  if oldhwnd = hwnd then
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
      ForegroundThreadID := GetWindowThreadProcessID(oldhwnd, nil);
      ThisThreadID := GetCurrentThreadID;
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

procedure TSharpExec.PopulateAppPathsList;
var
  reg: TRegistry;
  iList, iFile: Integer;
  sName, sVal: string;
  tmpStrings: TStringList;
const
  cAppPath = 'SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths';
begin
  FAppPathList.Clear;

  reg := Tregistry.Create;
  try
    reg.rootkey := HKEY_LOCAL_MACHINE;
    reg.Access := KEY_READ;
    reg.OpenKeyReadOnly(cAppPath);
    reg.GetKeyNames(FAppPathList);
    reg.closeKey;

    for iList := 0 to Pred(FAppPathList.Count) do begin

      reg.OpenKeyReadOnly(cAppPath);
      sName := FAppPathList.Strings[iList];
      if reg.OpenKeyReadOnly(sName) then
        sVal := reg.ReadString('');

      //
      sVal := reg.ReadString('');
      FAppPathList[iList] := (Format('%s=%s', [sName, sVal]));

      reg.CloseKey;
    end;

    tmpStrings := TStringList.Create;
    try
      for iList := 0 to Pred(PathIncludeList.Items.Count) do begin
        tmpStrings.Clear;

        AddFilesToList(tmpStrings, PathIncludeList.Item[iList].Path,
          PathIncludeList.Item[iList].WildCard, True);

        for iFile := 0 to Pred(tmpStrings.Count) do begin
          sName := ExtractFileName(tmpStrings[iFile]);
          sVal := tmpStrings[iFile];
          FAppPathList.Add(Format('%s=%s', [sName, sVal]));
        end;

      end;
    finally
      tmpStrings.Free;
    end;
  finally
    reg.Free;

    //FAppPathList.AddStrings();
  end;
end;

procedure TSharpExec.ExpandCommonFiles(var AText: string);
var
  s: string;
  iList, iPos: Integer;
  withe, withoute: string;
begin
  s := AText;
  try

    for iList := 0 to Pred(FAppPathList.Count) do begin

      s := AText;
      withoute := FAppPathList.Names[iList];
      withoute := StrChopRight(withoute, 4);
      withe := FAppPathList.Names[iList];

      // ignore invalid items (drives) in the app list
      if length(withe) = 2 then
        if withe[2] = ':' then
          exit;

      // Try with extension
      iPos := StrFind(withe, s);
      if iPos = 1 then begin
        StrReplace(s, withe, FAppPathList.ValueFromIndex[iList], [rfIgnoreCase]);
        exit;
      end;

      // Try without extension
      iPos := StrFind(withoute, s);
      if iPos = 1 then begin
        StrReplace(s, withoute, FAppPathList.ValueFromIndex[iList], [rfIgnoreCase]);
        exit;
      end;
    end;

  finally
    AText := s;
  end;
end;

function TSharpExec.ExpandAliases(var AText: string; var AElevate: Boolean): Boolean;
var
  i, j: integer;
  strl: tstringlist;
  s1: string;

  AliasName: string;
  ParamPos: Integer;
  Params: string;
  ParamsStrl: TStringList;

  bMatch: Boolean;
begin
  // Initialise the String Lists
  ParamsStrl := TStringList.Create;
  Strl := TStringList.Create;
  bMatch := False;

  try

    // Extract Name
    StrTokenToStrings(AText, ' ', strl);
    if strl.Count > 0 then
      AliasName := Strl.Strings[0];

    // Extract Params
    ParamPos := Pos(' ', AText);

    if ParamPos <> 0 then begin
      Params := Copy(AText, ParamPos + 1, length(AText) - ParamPos + 1);
      StrTokenToStrings(Params, ',', ParamsStrl);
    end;

    for i := 0 to Pred(AliasList.Count) do begin
      // Check if there is a match in the Alias List
      if StrCompare(AliasName, AliasList[i].AliasName) = 0 then begin

        bMatch := True;
        Debug('Alias Property: ' + AliasList[i].AliasName + ' - ' +
          AliasList[i].AliasValue, DMT_TRACE);

        //Result := true;
        AText := AliasList[i].AliasValue;
        if ((AliasList[i].Elevate) and (Pos('_elevate', AliasList[i].AliasValue) = 0)) then
          AElevate := True;

        // Check for various defined application paths
        for j := 0 to Pred(PathIncludeList.Items.Count) do begin
          AText := fileexistsin(AText, PathIncludeList[j].Path,
            PathIncludeList[j].WildCard);

          if AText <> AliasList[i].AliasValue then
            break;
        end;

        // Expand the advanced alias
        if ParamsStrl.Count >= 1 then begin

          s1 := AText;
          for j := 0 to ParamsStrl.Count - 1 do begin
            StrReplace(s1, '%' + inttostr(j + 1), ParamsStrl.Strings[j], [rfIgnoreCase]);
          end;

          AText := s1;
        end;
        break;
      end;
    end;

  finally
    Result := bMatch;
    if ((bMatch) and (ParamsStrl.Count > 0)) then
      AText := AText + ' ' + Params;

    ParamsStrl.Free;
    strl.Free;
  end;
end;

end.

