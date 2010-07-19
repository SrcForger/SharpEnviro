{
Source Name: SharpFileUtils.pas
Description: File Name/Path/Exec/... related helper routines
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpFileUtils;

interface

uses
  Classes,
  Windows,
  ShlObj,
  ActiveX,
  SysUtils,
  uSystemFuncs,
  Registry,
  JclShell,
  JclFileUtils,
  JclStrings;

procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string); overload;
procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string; Recurse: Boolean; Directories: Boolean = false); overload;
function GetFileNameWithoutParams(pTarget : String) : String;
function FindFilePath(pTarget : String) : String;

function GetX64ValidPath(Path : WideString) : WideString;

Function PathFindOnPath(pszPath, ppszOtherDirs: PChar): BOOL; stdcall; external 'shlwapi.dll' Name 'PathFindOnPathA';

procedure GetExecuteableFilesFromDir(var FileList: TStringList; Dir : String);

function GetFileInfo(filePath, propertyName: string): string;
function GetFileDescription(filePath : string) : string;
function GetFileVersion(filePath : string) : string;
function GetFileProductName(filePath : string) : string;
function GetFileAuthor(filePath : string) : string;
function GetFileCompanyName(filePath : string) : string;
function GetFileInternalName(filePath : string) : string;

function GetFilePathFromLink(const sLink: String; out Dst : String): boolean;

const GFI_FileDescription = 'FileDescription';
const GFI_FileVersion = 'FileVersion';
const GFI_ProductName = 'ProductName';
const GFI_Author = 'Author';
const GFI_CompanyName = 'CompanyName';
const GFI_InternalName = 'InternalName';

implementation

var
  EnvReplList : TWideStringList;

const
  IID_IPersistFile: TGUID = (D1:$0000010B;D2:$0000;D3:$0000;D4:($C0,$00,$00,$00,$00,$00,$00,$46));

  
function GetFilePathFromLink(const sLink: String; out Dst : String): boolean;
var
  sWidePath: Array [0..260] of WideChar;
  sFoundPath: Array [0..MAX_PATH] of WideChar;
  AShellLink : IShellLinkW;
  wfd : _WIN32_FIND_DATAW;
  PersistFile : IPersistFile;
  TempPath : PWideChar;
begin
  Dst := sLink;
  Result := False;

  (* Create a shellLink object *)
  if CoCreateInstance(CLSID_ShellLink,
                      nil,
                      CLSCTX_INPROC_SERVER,
                      IID_IShellLinkW,
                      AShellLink) <> S_OK then
    exit;

  (* Give the shell link a path to resolve *)
  GetMem(TempPath, sizeof(WideChar) * Succ(Length(sLink)));
  StringToWideChar(sLink, TempPath, Succ(Length(sLink)));
  AShellLink.SetPath(TempPath);
  FreeMem(TempPath);
  if AShellLink.Resolve(HInstance,SLR_UPDATE) = S_OK then
  begin
    (* Use the shelllink object to gain access to its PersistFile interface *)
    if Failed(AShellLink.QueryInterface(IID_IPersistFile,PersistFile)) then
      exit;

    (* Load the file into the PersistFile object *)
    // we must convert the ansi string to be a widestring to pass to 'PersistFile.Load'
    MultiByteToWideChar(CP_ACP,
                        MB_PRECOMPOSED,
                        PChar(sLink),
                        -1,
                        @sWidePath,
                        MAX_PATH);
    if PersistFile.Load(sWidePath,STGM_READ) <> S_OK then
      exit;

    (* Now the file is loaded we can ask the OS to provide us with its
       original path *)
    if AShellLink.GetPath(sFoundPath,MAX_PATH,wfd,SLGP_RAWPATH) <> NOERROR  then
      exit;

    Dst := sFoundPath;
    result := True;
  end;
end;

function FindFilePath(pTarget : String) : String;
var
  buf: array [0..MAX_PATH] of Char;
begin
  result := pTarget;

  Move(pTarget[1], buf, Succ(Length(pTarget)));
  if PathFindOnPath(buf,nil) then
    result := buf;
end;

procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string);
begin
  FindFiles(FilesList, StartDir, FileMask, True, False);
end;

procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string; Recurse: Boolean; Directories: Boolean);
var
  SR: TSearchRec;
  DirList: TStringList;
  IsFound: Boolean;
  i: integer;
begin
  if StartDir[length(StartDir)] <> '\' then
    StartDir := StartDir + '\';

  { Build a list of the files in directory StartDir
     (not the directories!)                         }

  if Directories then
    IsFound := FindFirst(StartDir + FileMask, faAnyFile, SR) = 0
  else
    IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
    
  while IsFound do
  begin
    if not ((Directories) and ((SR.Name = '.') or (SR.Name = '..'))) then
      FilesList.Add(StartDir + SR.Name);
      
    IsFound := FindNext(SR) = 0;
  end;
  SysUtils.FindClose(SR);

  if Recurse then
  begin
    // Build a list of subdirectories
    DirList := TStringList.Create;
    try
      IsFound := FindFirst(StartDir + '*.*', faAnyFile, SR) = 0;
      while IsFound do
      begin
        if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
          DirList.Add(StartDir + SR.Name);
          
        IsFound := FindNext(SR) = 0;
      end;
      SysUtils.FindClose(SR);

      // Scan the list of subdirectories
      for i := 0 to DirList.Count - 1 do
        FindFiles(FilesList, DirList[i], FileMask);
    finally
      DirList.Free;
    end;
  end;
end;

function GetFileNameWithoutParams(pTarget : String) : String;
var
  tokens : TStringList;
  n : integer;
  LastValid,FileName : String;
begin
  if FileExists(pTarget) or DirectoryExists(pTarget) then
  begin
    result := pTarget;
    exit;
  end;

  tokens := TStringList.Create;

  StrTokenToStrings(pTarget, ' ', tokens);
  FileName := '';
  LastValid := pTarget;
  for n := 0 to tokens.Count - 1 do
  begin
    if n = 0 then
      FileName := FileName + tokens[n]
    else FileName := FileName + ' ' + tokens[n];

    if FileExists(FileName) then
      LastValid := FileName;
  end;
  result := LastValid;

  tokens.Free;
end;

procedure GetExecuteableFilesFromDir(var FileList: TStringList; Dir : String);
var
  sr : TSearchRec;
  link: TShellLink;
  lnkpath : string;
  filepath : string;
  longpath : string;
begin
  {$WARNINGS OFF} Dir := IncludeTrailingBackSlash(Dir); {$WARNINGS ON}
  FileList.Clear;
  if FindFirst(Dir + '*.lnk',FAAnyFile,sr) = 0 then
  repeat
    lnkpath := Dir + sr.Name;
    // CoInitialize(nil);
    if JclShell.ShellLinkResolve(lnkpath, link) = S_OK then
    begin
      filepath := link.Target;
      if (FileExists(filepath)) and (CompareText(ExtractFileExt(filepath),'.exe') = 0) then // Valid File
      begin
        longpath := JclFileUtils.PathGetLongName(filepath);
        if FileExists(longpath) then // only use long path if retrieving it worked
          filepath := longpath;
        FileList.Add(filepath);
      end;
    end;
    // CoUninitialize;
  until FindNext(sr) <> 0;
  FindClose(sr);
end;

{$REGION 'GetFileInfo'}

function GetFileInfo(filePath, propertyName: string): string;
var
  Info: Pointer;
  InfoData: Pointer;
  InfoSize: LongInt;
  InfoLen: {$IFDEF WIN32}DWORD;
{$ELSE}LongInt;
{$ENDIF}
  DataLen: {$IFDEF WIN32}UInt;
{$ELSE}word;
{$ENDIF}
  LangPtr: Pointer;
begin
  result := '';
  DataLen := 255;
  if Length(filePath) <= 0 then
    exit;
  filePath := filePath + #0;
  InfoSize := GetFileVersionInfoSize(@filePath[1], InfoLen);
  if (InfoSize > 0) then
  begin
    GetMem(Info, InfoSize);
    try
      if GetFileVersionInfo(@filePath[1], InfoLen, InfoSize, Info) then
      begin
        if VerQueryValue(Info, '\VarFileInfo\Translation', LangPtr, DataLen) then
          propertyName := Format('\StringFileInfo\%0.4x%0.4x\%s'#0,
            [LoWord(LongInt(LangPtr^)),
            HiWord(LongInt(LangPtr^)), propertyName]);
        if VerQueryValue(Info, @propertyName[1], InfoData, Datalen) then
          Result := strPas(InfoData);
      end;
    finally
      FreeMem(Info, InfoSize);
    end;
  end;
end;

function GetFileDescription(filePath : string) : string;
begin
  Result := GetFileInfo(filePath, GFI_FileDescription);
end;

function GetFileVersion(filePath : string) : string;
begin
  Result := GetFileInfo(filePath, GFI_FileVersion);
end;

function GetFileProductName(filePath : string) : string;
begin
  Result := GetFileInfo(filePath, GFI_ProductName);
end;

function GetFileAuthor(filePath : string) : string;
begin
  Result := GetFileInfo(filePath, GFI_Author);
end;

function GetFileCompanyName(filePath : string) : string;
begin
  Result := GetFileInfo(filePath, GFI_CompanyName);
end;

function GetFileInternalName(filePath : string) : string;
begin
  Result := GetFileInfo(filePath, GFI_InternalName);
end;

{$ENDREGION 'GetFileInfo'}

procedure BuildEnvRepList;
var
  Reg : TRegistry;
begin
  EnvReplList.Clear;

  if IsWoW64 then
  begin
    Reg := TRegistry.Create;
    try
      Reg.Access := KEY_READ or KEY_WOW64_64KEY;
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      if Reg.OpenKeyReadOnly('\SOFTWARE\Microsoft\Windows\CurrentVersion') then
       begin
        EnvReplList.Add(Reg.ReadString('ProgramFilesDir (x86)') + '=' + Reg.ReadString('ProgramFilesDir'));
        EnvReplList.Add(Reg.ReadString('CommonFilesDir (x86)') + '=' + Reg.ReadString('CommonFilesDir'));
        EnvReplList.Add(GetSpecialFolderLocation(CSIDL_SYSTEMX86) + '=' + GetSpecialFolderLocation(CSIDL_SYSTEM));
      end;
    finally
      Reg.Free;
    end;
  end;
end;


function GetX64ValidPath(Path : WideString) : WideString;
var
  n : integer;
  s : WideString;
begin
  result := Path;
  for n := 0 to EnvReplList.Count - 1 do
  begin
    s := StringReplace(Path,EnvReplList.Names[n],EnvReplList.ValueFromIndex[n],[rfIgnoreCase]);
    if (FileExists(s) and (CompareText(s,Path) <> 0)) then
    begin
      result := s;
      exit;
    end;
  end;
end;




initialization
  EnvReplList := TWideStringList.Create;
  BuildEnvRepList;

finalization
  EnvReplList.Free;

end.
