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
  comobj,
  shlobj,
  registry,

  sysutils,
  tlhelp32,
  fileutils,
  shellapi,

  jclstrings,
  jclshell,
  jclfileutils,
  sharpapi,

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
    constructor Create( hk: cardinal; hks: string; subKey: string; x64: boolean; runOnce: boolean);
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
    function IsWow64(): boolean;
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
    function FindTask(ExeFileName: string): Integer;
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
  function TStartup.IsWow64(): boolean;
  type
    TIsWow64Process = function(Handle: THandle; var Res: boolean): boolean; stdcall;
  var
    IsWow64Result: boolean;
    IsWow64Process: TIsWow64Process;
  begin
    result := False;
    IsWow64Process := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');
    if Assigned(IsWow64Process) then
      if IsWow64Process(GetCurrentProcess, IsWow64Result) then
        result := IsWow64Result;
  end;

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

{$REGION 'Process discovery'}
  function TStartup.AppRunning(AFile:String):Boolean;
  var
    s:String;
  begin
    Result := False;
    s := AFile;
    s := ExpandEnvVars(s);
    s := Copy(s, 1, Length(s) - 2);
  
    if findtask(s) = 1 then
       Result := True;
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
    Result := -1;
    FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    try
      FProcessEntry32.dwSize := Sizeof(FProcessEntry32);
      ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  
      currenttask := extractfilename(exefilename);
      DebugMsg('Searching For: ' + currenttask,DMT_INFO);
      while integer(ContinueLoop) <> 0 do
      begin
        currentscan := string(FProcessEntry32.szExeFile);
  
        //Debug('Current Scan: ' + currentscan,DMT_INFO);
        if CompareText(currenttask,currentscan) = 0 then
        begin
          DebugMsg('Found: ' + currenttask,DMT_INFO);
          Result := 1;
          exit;
        end;
        ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
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
            ((Data.cFileName[0] = 'd')) then begin
            if (PChar(string(lowercase(Data.cFileName)))) = 'desktop.ini' then
              outputdebugstring('not loading')
            else begin

              JclShell.ShellLinkResolve(dir + '\' + Data.cFileName,lpShortcut);

              if assigned(FOnAddDirEvent) then
                FOnAddDirEvent(dir + '\' + Data.cFileName);

              if findtask(lpShortcut.Target) = -1
                then begin

                  if not Debug then
                    ServiceMsg('exec',pchar('_nohist,' + dir + '\' + Data.cFileName));
              end;
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
      if s <> '' then begin

        if Assigned(FOnAddRegEvent) then
            FOnAddRegEvent( reg.HKeyStr + '\' + reg.subKey, list[i] + ' - ' + s);

        if reg.runOnce then
              FDeleteList.Add(reg);

        if Not(AppRunning(ExtractFileName(s))) then begin

          if Not(Debug) then begin
            ServiceMsg('exec',pchar('_nohist,' + s));


            end;
          end;
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
  s,s64: string;
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
    s := '';
    for i := 0 to Pred(FDeleteList.Count) do begin
      tmpReg := TRegistryStartupItem(FDeleteList[i]);

      if tmpReg.Process64 then
        s64 := '1' else s64 := '0';

      s := s + format('%s,%s,%s,%s',[tmpReg.HKeyStr, tmpReg.SubKey,tmpReg.ValueKey,s64]);
      s := s + '^';
    end;
    ShellExecute(0,'open','SharpAdmin.exe',pchar('-DeleteKeyValue ' + s),'',SW_SHOWNORMAL);
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

end.

