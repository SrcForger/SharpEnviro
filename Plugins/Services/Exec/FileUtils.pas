unit FileUtils;

interface

{$WARN UNIT_PLATFORM OFF}

uses
  Classes;

function ListFiles(Dir, Mask: string): TStringList;
function ListDrives: TStringList;
function GetWindowsFolder: string;
procedure StrResetLength(var S: AnsiString);
function ExpandEnvVars(const Str: string): string;

implementation

uses
  FileCtrl,
  Windows,
  SysUtils,
  Dialogs;

function ListFiles(Dir, Mask: string): TStringList;
var
  i, v: integer;
  Files: TSearchRec;
  FileList: TStringList;
  tmpMask: string;
begin
  Dir := IncludeTrailingPathDelimiter(Dir);
  FileList := TStringList.Create;
  v := 0;
  tmpMask := '';
  while v <= Length(Mask) do
  begin
    Inc(v);
    if (Copy(Mask, v, 1) <> '|') and (v <= Length(Mask)) then
      tmpMask := tmpMask + Copy(Mask, v, 1)
    else
    begin
      i := FindFirst(Dir + tmpMask, 0, Files);
      while i = 0 do
      begin
        if (Files.Name <> '.') and (Files.Name <> '..') and not
          (DirectoryExists(Dir + Files.Name)) then
        begin
          FileList.Add(Dir + Files.Name);
        end;
        i := FindNext(Files);
      end;
      FindClose(Files);
      tmpMask := '';
    end;
  end;

  ListFiles := FileList;
end;

function ListDrives: TStringList;
var
  //ld : DWORD;
  //i : integer;
  DriveList: TStringList;

  Buffer: array[0..500] of char;
  hChar: PChar;
begin
  DriveList := TStringList.Create;
  {ld := GetLogicalDrives;
  for i := 0 to 25 do begin
    if (ld and (1 shl i)) <> 0 then
      DriveList.Add(Char(Ord('A') + i) + ':\');
  end;}

  GetLogicalDriveStrings(Sizeof(Buffer), Buffer);
  hChar := Buffer;
  while hChar[0] <> #0 do
  begin
    DriveList.Add(hChar);
    hChar := StrEnd(hChar) + 1;
  end;

  ListDrives := DriveList;
end;

function GetWindowsFolder: string;
var
  Required: Cardinal;
begin
  Result := '';
  Required := GetWindowsDirectory(nil, 0);
  if Required <> 0 then
  begin
    SetLength(Result, Required);
    GetWindowsDirectory(PChar(Result), Required);
    StrResetLength(Result);
  end;
end;

procedure StrResetLength(var S: AnsiString);
begin
  SetLength(S, StrLen(PChar(s)));
end;

function ExpandEnvVars(const Str: string): string;
var
  BufSize: Integer; // size of expanded string
begin
  // Get required buffer size
  BufSize := ExpandEnvironmentStrings(
    PChar(Str), nil, 0);
  // Read expanded string into result string
  SetLength(Result, BufSize);
  ExpandEnvironmentStrings(PChar(Str),
    PChar(Result), BufSize);
end;

end.
