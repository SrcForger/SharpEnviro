{
Source Name: uStartup.pas
Description: Startup Apps Class
Copyright (C) Pixol (pixol@sharpe-shell.org)

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

unit uStartup;

interface

uses
  windows,
  activex,
  messages,
  comobj,
  shlobj,
  registry,
  classes,
  sysutils,
  tlhelp32,
  fileutils,
  shellapi,

  jclstrings,
  jclfileutils,
  sharpapi,
  uExecServiceExtractShortcut;


type
  TExecFileCommand = Record
  Filename: String;
  Commandline: String;
end;

type
  TStartup = class
  private

    procedure DeleteEntriesIn(AKey: string; AHKEY: HKEY);
    procedure RunEntriesIn(AKey: string; AHKEY: HKEY);
    procedure RunDir(Idl: Integer);
    function FindTask(ExeFileName: string): Integer;
    function GetShortcutTarget(ShortcutFilename: string): string;
    procedure Debug(Str: string; MessageType: Integer);
    function StrtoFileandCmd(str: string):TExecFileCommand;

    function AppRunning(AFile:String):Boolean;
  public
    procedure LoadStartupApps;
  end;

const
  RunPath = 'Software\Microsoft\Windows\CurrentVersion\Run';
  RunOncePAth = 'Software\Microsoft\Windows\CurrentVersion\RunOnce';
  WinlogonKey = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon';
  RunHKLMPolicies = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run';

implementation

{ TStartup }

function TStartup.AppRunning(AFile:String):Boolean;
var
  s:String;
  fileCmd: TExecFileCommand;
begin
  Result := False;
  s := AFile;
  s := ExpandEnvVars(s);
  s := Copy(s, 1, Length(s) - 2);
  fileCmd := StrtoFileandCmd(s);

  if (findtask(fileCmd.Filename) = -1) and (fileCmd.Filename <> '') then
    Result := True;
end;

procedure TStartup.DeleteEntriesIn(AKey: string; AHKEY: HKEY);
begin
  try
    DeleteRegKey(AKey, AHKEY);
    CreateRegKey(AKey, '', '', AHKEY);
  except
    Debug('Unable to Delete Key: ' + AKey, DMT_INFO);
  end;
end;

function TStartup.FindTask(ExeFileName: string): Integer;
const
  PROCESS_TERMINATE = $0001;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  currentscan, currenttask: string;
begin
  try
    Result := -1;

    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
    ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

    while integer(ContinueLoop) <> 0 do begin

      currentscan := lowercase(string(FProcessEntry32.szExeFile));
      currenttask := lowercase(extractfilename(exefilename));
      StrReplace(currentscan, ' ', '', [rfreplaceall]);
      StrReplace(currenttask, ' ', '', [rfreplaceall]);

      outputdebugstring(pchar('Searching For: ' + currenttask));
      outputdebugstring(pchar('Current Scan: ' + currentscan));

      if currenttask = currentscan then begin
        outputdebugstring(pchar('Found: ' + currenttask));
        Result := 1;
        exit;
      end;
      ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
    end;
    outputdebugstring(pchar('Could not find: ' + currenttask +
      ' LAUNCHING!! '));
    CloseHandle(FSnapshotHandle);
  except
  end;
end;

function TStartup.GetShortcutTarget(ShortcutFilename: string): string;
var
  Psl: IShellLink;
  Ppf: IPersistFile;
  WideName: array[0..MAX_PATH] of widechar;
  pResult: array[0..MAX_PATH - 1] of char;
  Data: TWin32FindData;
const
  IID_IPersistFile: TGUID = (D1: $0000010B; D2: $0000; D3: $0000;
    D4: ($C0, $00, $00, $00, $00, $00, $00, $46));
begin
  try
    CoCreateInstance(CLSID_ShellLink, nil, CLSCTX_INPROC_SERVER,
      IID_IShellLinkA, psl);
    psl.QueryInterface(IID_IPersistFile, ppf);
    MultiByteToWideChar(CP_ACP, 0, PChar(SHORTCUTFilename), -1, WideName,
      Max_Path);
    ppf.Load(WideName, STGM_READ);
    //psl.Resolve(0, SLR_NO_UI + SLR_NOUPDATE);
    psl.GetPath(@pResult, MAX_PATH, Data, SLGP_UNCPRIORITY);
    Result := StrPas(@pResult);
  except
  end;
end;

procedure TStartup.RunDir(Idl: Integer);
var
  sdir: PChar;
  pp: PItemIDList;
  a: integer;
  Data: TWin32FindData;
  hwin: THandle;
  lpShortcut: TLinkParams;
begin
  try
    GetMem(sdir, MAX_PATH + 1);
    if SHGetSpecialFolderLocation(hWin, IDL, pp) = NOERROR then
      if SHGetPathFromIDList(pp, sdir) then begin
        a := FindFirstFile(PChar(sdir + '\*.*'), Data);
        repeat
          if not (((Data.cFileName[0] = '.') and (Data.cFileName[1] = '')) or
            ((Data.cFileName[0] = '.') and (Data.cFileName[1] = '.') and
            (Data.cFileName[2] = ''))) or
            ((Data.cFileName[0] = 'd')) then begin
            if (PChar(string(lowercase(Data.cFileName)))) = 'desktop.ini' then
              outputdebugstring('not loading')
            else begin

              ResolveLink(sdir + '\' + Data.cFileName,lpShortcut);

              if findtask(lpShortcut.Target) = -1
                then begin
                  ServiceMsg('exec',pchar('_nohist,' + sdir + '\' + Data.cFileName));
              end;
            end;
          end;
        until not FindNextFile(a, Data);
      end;
    FreeMem(sdir);
  except
  end;
end;

procedure TStartup.RunEntriesIn(AKey: string; AHKEY: HKEY);
var
  Reg: Tregistry;
  sList: TStringList;
  i, j: integer;
  sTheFile: string;
  res: integer;
  sFile, sCmd, sDir: string;
  cont: boolean;



begin
  sList := TStringList.Create;
  Reg := Tregistry.Create;
  with Reg do
  begin
    Access := KEY_READ;
    rootkey := AHKEY;
    OpenKey(AKey, False);
    GetValueNames(sList);
  end;

  try
    sFile := '';
    sCmd := '';


    for i := 0 to Pred(sList.Count) do
    begin
      sFile := Reg.ReadString(sList[i]);
      if Not(AppRunning(ExtractFileName(sFile))) then
        ServiceMsg('exec',pchar('_nohist,' + sFile));
    end;

  finally
    reg.Free;
    sList.Free;
  end;
end;

procedure TStartup.Debug(Str: string; MessageType: Integer);
begin
  SendDebugMessageEx('Startup Service', Pchar(Str), 0, MessageType);
end;

procedure TStartup.LoadStartupApps;
var
  sVal:String;
begin
  //Debug('Execute UserInit', DMT_INFO);
  //ServiceMsg('exec',pchar('_nohist,' + GetWindowsSystemFolder+'\userinit.exe'));

  Debug('Execute HKLM Policies', DMT_INFO);
  RunEntriesIn(RunHKLMPolicies, HKEY_LOCAL_MACHINE);

  Debug('Execute RunOnce', DMT_INFO);
  RunEntriesIn(RunOncePath, HKEY_LOCAL_MACHINE);
  RunEntriesIn(RunOncePath, HKEY_CURRENT_USER);

  Debug('Delete RunOnce', DMT_INFO);
  DeleteEntriesIn(runOncePath, HKEY_LOCAL_MACHINE);
  DeleteEntriesIn(runOncePath, HKEY_CURRENT_USER);


  Debug('Execute Run', DMT_INFO);
  RunEntriesIn(runPath, HKEY_LOCAL_MACHINE);
  RunEntriesIn(runPath, HKEY_CURRENT_USER);

  Debug('Execute Start Menu', DMT_INFO);
  RunDir(CSIDL_COMMON_STARTUP);
  RunDir(CSIDL_STARTUP);
end;

function TStartup.StrtoFileandCmd(str: string):TExecFileCommand;
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
    s := Copy(str,2,length(str));
    i := Pos('"',s);

    Result.Filename := Copy(str,2,i-1);
    Result.Commandline := Copy(str,i+2,length(str));
    Exit;
  end;

  // Remove quotes from quoted string
  str := StrRemoveChars(str, ['"']);

  // Get number of spaces in str
  tokens := TStringList.Create;
  Try
  StrTokenToStrings(str, ' ', tokens);

  tmp := '';
  for i := 0 to tokens.count - 1 do begin
    filetoexecute := filetoexecute + tokens.Strings[i];
    tmp := filetoexecute;

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
      if StrCompare(filetoexecute,commandline) = 0 then
        commandline := '';
      Result.Filename := Filetoexecute;
      Result.Commandline := commandline;
      Exit;
    end;
    AppendStr(filetoexecute, ' ');
  end;
  Finally
    tokens.Free;
  End;
  end;
end;

end.

