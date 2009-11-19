{
Source Name: uStartup.pas
Description: Startup Apps Class
Copyright (C) Pixol (pixol@sharpe-shell.org)

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

unit uStartup;

interface

uses

  classes,
  activex,
  messages,
  controls,
  comobj,
  shlobj,
  registry,
  dialogs,

  sysutils,
  StrUtils,
  tlhelp32,
  fileutils,
  shellapi,
  PsAPI,

  jclstrings,
  jclshell,
  jclfileutils,
  sharpapi,
  uSystemFuncs,

  windows;

type
  TStartupItem = class
  end;

  TRegistryStartupItem = class(TStartupItem)
  private
    FRunOnce: Boolean;
    FSubkey: String;
    FHkey: HKEY;
    FHkeyStr: string;
    FValueKey: string;
    FProcess64: boolean;
  public
    constructor Create( hk: cardinal; hks: string; subKey: string; x64: boolean; runOnce: boolean); overload;
    constructor Create( hk: cardinal; hks: string; subKey: string; valueKey:string; x64: boolean; runOnce: boolean); overload;
    property SubKey: String read FSubkey write FSubKey;
    property ValueKey: string read FValueKey write FValueKey;
    property RunOnce: Boolean read FRunOnce write FRunOnce;
    property HKey: HKEY read FHKey write FHKey;
    property HKeyStr: String read FHKeyStr write FHKeyStr;
    property Process64: boolean read FProcess64 write FProcess64;
  end;

  TPathStartupItem = class(TStartupItem)
  private
    FDir: string;
  public
    constructor Create( dir: string );
    property Dir: string read FDir write FDir;
  end;

type
  TAddRegEvent = procedure(key: string; value: string) of object;
  TAddDirEvent = procedure(filename : string) of object;

  TExecFileCommandl = record
    Filename: string;
    Commandline: string;
  end;
type
  TStartup = class(TList)
  private
    FOnAddDirEvent: TAddDirEvent;
    FOnAddRegEvent: TAddRegEvent;
    FDebug: boolean;
    FDeleteList: TList;

    procedure InitialiseKeys;
    procedure InitialisePaths;
    function AddRegistryStartupItem( hk: cardinal; hks: string; subKey: string; x64: boolean; runOnce: boolean): TRegistryStartupItem;
    function AddPath( path: string ): TPathStartupItem;
    function RegEnum(const rootKey: HKEY; const name: String;
         var resultList: TStringList; const process64: boolean; const DoKeys: Boolean): Boolean;
    function RegReadValue(const rootKey: HKEY; const name: String; const value: String;
      const process64: boolean): string;
    //procedure Debug(Str: string; MessageType: Integer);
  public
    constructor Create;
    destructor Destroy; override;

    function RunEntriesIn(reg: TRegistryStartupItem; process64: boolean): integer;
    procedure RunDir(dir: string);
    function FindTask(ExeFileName: string): Boolean;
    class procedure DebugMsg(Str: string; MessageType: Integer); static;

    function AppRunning(AFile:String):Boolean;

    property Debug: boolean read FDebug write FDebug;
    property OnAddRegEvent: TAddRegEvent read FOnAddRegEvent write FOnAddRegEvent;
    property OnAddDirEvent: TAddDirEvent read FOnAddDirEvent write FOnAddDirEvent;
  public
    procedure LoadStartupApps;
  end;

implementation

{ TStartup }

{$REGION 'Registry methods'}

function TStartup.RegEnum(const rootKey: HKEY; const name: String;
           var resultList: TStringList; const process64: boolean; const DoKeys: Boolean): Boolean;

var Buf     : Array[0..2047] of Char;
    BufSize : Cardinal;
    i       : Integer;
    Res     : Integer;
    S       : String;
    Handle  : HKEY;
    regMask: DWord;

    procedure MoveMem(const Source; var Dest; const Count: Integer);
begin
  if Count <= 0 then
    exit;
  if Count > 4 then
    System.Move(Source, Dest, Count)
  else
    Case Count of // optimization for small moves
      1 : PByte(@Dest)^ := PByte(@Source)^;
      2 : PWord(@Dest)^ := PWord(@Source)^;
      4 : PLongWord(@Dest)^ := PLongWord(@Source)^;
    else
      System.Move(Source, Dest, Count);
    end;
end;
begin
  // we require a list to be created
  Result := false;

  if ResultList = nil then exit;

  // 64 bit gubbins
  regMask := 0;
  if process64 then regMask := KEY_WOW64_64KEY;

  // Most important open in read only mode, and 64 bit access if needed
  Result := RegOpenKeyEx(RootKey, PChar(Name), 0, KEY_READ or regMask, Handle) = ERROR_SUCCESS;
  if not Result then exit;

  i := 0;
  Repeat
    BufSize := Sizeof(Buf);
    if DoKeys then
      Res := RegEnumKeyEx(Handle, I, @Buf[0], BufSize, nil, nil, nil, nil)
    else
      Res := RegEnumValue(Handle, I, @Buf[0], BufSize, nil, nil, nil, nil);
    if Res = ERROR_SUCCESS then
      begin
        SetLength(S, BufSize);
        if BufSize > 0 then
          MoveMem(Buf[0], Pointer(S)^, BufSize);

        resultList.Add(s);
        Inc(i);
      end;
  Until Res <> ERROR_SUCCESS;
  RegCloseKey(Handle);
end;

function TStartup.RegReadValue(const rootKey: HKEY; const name: String; const value: String;
  const process64: boolean): string;

var
    BufSize : Cardinal;
    Handle  : HKEY;
    regMask: DWord;
    keyname: PAnsiChar;
    regValType: DWord;
    Buffer: array[0..256] of Char;

begin
  Result := '';
  regValType := REG_SZ;

  // 64 bit gubbins
  regMask := 0;
  if process64 then regMask := KEY_WOW64_64KEY;

  // Most important open in read only mode, and 64 bit access if needed
  if RegOpenKeyEx(RootKey, PChar(name), 0, KEY_READ or regMask, Handle) <> ERROR_SUCCESS then
    exit;

  keyName := pchar(value);
  BufSize := SizeOf(Buffer);
  if RegQueryValueEx(Handle, keyName, nil, @regValType, @Buffer, @Bufsize) = ERROR_SUCCESS then
    Result := Buffer;

  //FreeMem(regVal);
  RegCloseKey(Handle);
end;

{$ENDREGION}

{$REGION 'List manipulation'}
function TStartup.AddPath(path: string): TPathStartupItem;
  var
    tmp: TPathStartupItem;
  begin
    tmp := TPathStartupItem.Create(path);
    Self.Add(tmp);
    result := tmp;
  end;

function TStartup.AddRegistryStartupItem( hk: cardinal; hks: string; subKey: string; x64: boolean; runOnce: boolean): TRegistryStartupItem;
var
  tmp: TRegistryStartupItem;
begin
  tmp := TRegistryStartupItem.Create(hk,hks,subKey,x64,runOnce);
  Self.Add(tmp);
  result := tmp;
end;

procedure TStartup.InitialiseKeys;
var
  i:integer;
  hk: Array[0..2] of cardinal;
  hks: Array[0..2] of string;
  x64: Array[0..2] of boolean;

begin
  hk[0] := HKEY_CURRENT_USER;
  hk[1] := HKEY_LOCAL_MACHINE;
  hk[2] := HKEY_LOCAL_MACHINE;
  hks[0] := 'HKCU';
  hks[1] := 'HKLM';
  hks[2] := 'HKLM';
  x64[0] := false;
  x64[1] := false;
  x64[2] := true;

  for i := 0 to 2 do begin

    if ( (i = 2) and (not(IsWow64))) then exit;

    AddRegistryStartupItem(hk[i],hks[i],'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run',x64[i], false);
    AddRegistryStartupItem(hk[i],hks[i],'SOFTWARE\Microsoft\Windows\CurrentVersion\RunServicesOnce',x64[i], true);
    AddRegistryStartupItem(hk[i],hks[i],'SOFTWARE\Microsoft\Windows\CurrentVersion\RunServices',x64[i], false);
    AddRegistryStartupItem(hk[i],hks[i],'SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnceEx',x64[i], true);
    AddRegistryStartupItem(hk[i],hks[i],'SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce\Setup',x64[i], true);
    AddRegistryStartupItem(hk[i],hks[i],'SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce',x64[i], true);
    AddRegistryStartupItem(hk[i],hks[i],'SOFTWARE\Microsoft\Windows\CurrentVersion\RunEx',x64[i], false);
    AddRegistryStartupItem(hk[i],hks[i],'SOFTWARE\Microsoft\Windows\CurrentVersion\Run',x64[i], false);
  end;
end;

procedure TStartup.InitialisePaths;
begin
  AddPath(GetSpecialFolderLocation(CSIDL_COMMON_STARTUP));
  AddPath(GetSpecialFolderLocation(CSIDL_STARTUP));
end;
{$ENDREGION}

{$REGION 'Process utilities'}
function StrtoFileandCmd(str: string): TExecFileCommandl;
var
  filetoexecute, commandline: string;
  i: Integer;
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
        filetoexecute := filetoexecute + ' ';
      end;
    finally
      tokens.Free;
    end;
  end;
end;

function GetLongPathAndFilename(const S : String) : String;
var
  srSRec : TSearchRec;
  iP, iRes : Integer;
  sTemp, sRest : String;
  Bo : Boolean;
Begin
  Result := S;
  // Check if file exists
  Bo := FileExists(S);
  // Check if directory exists
  iRes := FindFirst(S + '\*.*', faAnyFile, srSRec);
  // If both not found then exit
  if ((not Bo) and (iRes <> 0)) then
    Exit;

  sRest := S;
  iP := Pos('\', sRest);
  if iP > 0 then
  begin
    sTemp := Copy(sRest, 1, iP - 1); // Drive
    sRest := Copy(sRest, iP + 1,255); // Path and filename
  end else
   exit;

  // Get long path name
  while Pos('\', sRest) > 0 do
  begin
    iP := Pos('\', sRest);
    if iP > 0 then
    begin
      iRes := FindFirst(sTemp + '\' + Copy(sRest, 1, iP - 1), faAnyFile, srSRec);
      sRest := Copy(sRest, iP + 1, 255);

      If iRes = 0 then
        sTemp := sTemp + '\' + srSRec.FindData.cFileName;
    end;
  end;

  // Get long filename
  if FindFirst(sTemp + '\' + sRest, faAnyFile, srSRec) = 0 then
    Result := sTemp + '\' + srSRec.FindData.cFilename;

  SysUtils.FindClose(srSRec);
end;

function FixFileName(s : string): string;
var
  FileCmd : TExecFileCommandl;
begin
  FileCmd := StrtoFileandCmd(s);
  FileCmd.Filename := GetLongPathAndFilename(FileCmd.Filename);

  if FileCmd.Commandline <> '' then
    Result := ''
  else
    Result := FileCmd.Filename;
end;


function ProcessFileName(PID: DWORD): string;
var
  Handle: THandle;
begin
  Result := '';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if Handle <> 0 then
    try
      SetLength(Result, MAX_PATH);
      if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
        SetLength(Result, StrLen(PChar(Result)))
      else
        Result := '';
    finally
      CloseHandle(Handle);
    end;
end;

{$ENDREGION}

{$REGION 'Process discovery'}
  function TStartup.AppRunning(AFile:String): Boolean;
  var
    s : String;
  begin
    s := ExpandEnvVars(AFile);
    s := Copy(s, 1, Length(s) - 2);

    Result := FindTask(s);
  end;

  function TStartup.FindTask(ExeFilename: string): Boolean;
  const
    PROCESS_TERMINATE = $0001;
  var
    ContinueLoop: BOOL;
    FSnapshotHandle: THandle;
    FProcessEntry32: TProcessEntry32;
    CurrentScan, CurrentTask: string;
  begin
    Result := False;
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    try
      FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
      ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);

      // Extract the filename
      CurrentTask := FixFileName(ExeFilename);
      if CurrentTask <> '' then
      begin
        DebugMsg('Searching For: ' + CurrentTask, DMT_INFO);
        while integer(ContinueLoop) <> 0 do
        begin
          CurrentScan := ProcessFileName(FProcessEntry32.th32ProcessID);

          //DebugMsg('Current Scan: ' + CurrentScan, DMT_INFO);
          if CompareText(CurrentTask, CurrentScan) = 0 then
          begin
            DebugMsg('Found: ' + CurrentTask, DMT_INFO);
            Result := True;
            break;
          end;
          ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
        end;
      end;
    finally
      CloseHandle(FSnapshotHandle);
    end;
  end;

{$ENDREGION}

procedure TStartup.RunDir(dir: string);
var
  a: integer;
  Data: TWin32FindData;
  lpShortcut: TShellLink;
begin
  a := FindFirstFile(PChar(dir + '\*.*'), Data);
  repeat
    if not (((Data.cFileName[0] = '.') and (Data.cFileName[1] = '')) or
            ((Data.cFileName[0] = '.') and (Data.cFileName[1] = '.') and
            (Data.cFileName[2] = ''))) or
            ((Data.cFileName[0] = 'd')) then
    begin
      if (PChar(string(lowercase(Data.cFileName)))) = 'desktop.ini' then
        outputdebugstring('not loading')
      else
      begin
        JclShell.ShellLinkResolve(dir + '\' + Data.cFileName,lpShortcut);

        if assigned(FOnAddDirEvent) then
          FOnAddDirEvent(dir + '\' + Data.cFileName);

        if (not FindTask(lpShortcut.Target)) and (not Debug) then
          ServiceMsg('exec',pchar('_nohist,' + dir + '\' + Data.cFileName));
      end;
    end;
  until not FindNextFile(a, Data);
end;

function TStartup.RunEntriesIn(reg: TRegistryStartupItem; process64: boolean): integer;
var
  list: TStringList;
  i: integer;
  s: string;
begin
  list := TStringList.Create;
  try
    RegEnum( reg.HKey, reg.subKey, list, process64, false );
    result := list.Count;

    for i := 0 to Pred(list.Count) do
    begin
      reg.ValueKey := list[i];

      s := RegReadValue(reg.FHkey,reg.subKey,list[i], process64);
      if s <> '' then
      begin
        if Assigned(FOnAddRegEvent) then
            FOnAddRegEvent( reg.HKeyStr + '\' + reg.subKey, list[i] + ' - ' + s);

        if reg.runOnce then
          FDeleteList.Add(  TRegistryStartupItem.Create(reg.HKey,reg.HKeyStr,
                            reg.SubKey, reg.ValueKey, reg.Process64, reg.RunOnce) );

        if (not AppRunning(s)) and (not Debug) then
          ServiceMsg('exec', pchar('_nohist,' + s));
      end;
    end;
  finally
    list.Free;
  end;
end;

constructor TStartup.Create;
begin
  FDeleteList := TList.Create;
  InitialiseKeys;
  InitialisePaths;
end;

class procedure TStartup.DebugMsg(Str: string; MessageType: Integer);
begin
  SendDebugMessageEx('Startup Service', Pchar(Str), 0, MessageType);
end;

destructor TStartup.Destroy;
begin
  FDeleteList.Free;
end;

procedure TStartup.LoadStartupApps;
var
  i: Integer;
  tmpReg: TRegistryStartupItem;
  tmpPath: TPathStartupItem;
  s,s2,s64,admin: string;
  hasHklm, has64bitKey, continue: boolean;
begin
  FDeleteList.Clear;
  for i := 0 to Pred(Count) do begin

    if TObject(Items[i]) is TRegistryStartupItem then begin

      tmpReg := TRegistryStartupItem(Items[i]);
      RunEntriesIn( tmpReg,tmpReg.Process64 );

    end else if TObject(Items[i]) is TPathStartupItem then begin

      tmpPath := TPathStartupItem(Items[i]);
      RunDir(tmpPath.Dir);
    end;
  end;

  // Check for runonce items
  if FDeleteList.Count > 0 then begin
    s2 := '';
    hasHklm := false;
    has64bitKey := false;
    for i := 0 to Pred(FDeleteList.Count) do begin

      s := '';
      tmpReg := TRegistryStartupItem(FDeleteList[i]);

      if tmpReg.Process64 then begin
        s64 := '1';
        has64bitKey := true;
      end else s64 := '0';

      if tmpReg.FHkey = HKEY_LOCAL_MACHINE then
        hasHklm := true;

      s := format('%s,%s,%s,%s^',[tmpReg.HKeyStr, tmpReg.SubKey,tmpReg.ValueKey,s64]);
      s2 := s2 + s;
    end;

    admin := GetSharpeDirectory+ 'SharpAdmin.exe -DeleteKeyValue ' + s2;

    continue := true;
    if ( (IsWow64) and ( (hasHklm) or (has64bitKey) ) ) then begin
      if (MessageDlg('There are RunOnce specific keys that should be deleted. '
        +#13+#10+''+#13+#10+
          'As these keys are within a protected registry area, they must be deleted using elevation.'
            +#13+#10+''+#13+#10+
              'To gain access rights, please launch SharpAdmin elevated. Click OK to launch... ', mtInformation, [mbOK, mbIgnore], 0) in [mrIgnore, mrNone]) then
                continue := false;
    end;       

    if continue then
      SharpExecute(admin);
  end;

end;

{ TPathStartupItem }

constructor TPathStartupItem.Create(dir: string);
begin
  FDir := dir;
end;

{ TRegistryStartupItem }

constructor TRegistryStartupItem.Create( hk: cardinal; hks: string; subKey: string; x64: boolean; runOnce: boolean);
begin
  FHkey := hk;
  FHkeyStr := hks;
  FProcess64 := x64;
  FSubkey := subKey;
  FRunOnce := runOnce;
end;

constructor TRegistryStartupItem.Create(hk: cardinal; hks, subKey,
  valueKey: string; x64, runOnce: boolean);
begin
  FHkey := hk;
  FHkeyStr := hks;
  FValueKey := valueKey;
  FProcess64 := x64;
  FSubkey := subKey;
  FRunOnce := runOnce;
end;

end.

