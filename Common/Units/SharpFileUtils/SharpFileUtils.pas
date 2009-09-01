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
  windows,
  SysUtils,
  JclStrings;

procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string); overload;
procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string; Recurse: Boolean); overload;
function GetFileNameWithoutParams(pTarget : String) : String;
function FindFilePath(pTarget : String) : String;

Function PathFindOnPath(pszPath, ppszOtherDirs: PChar): BOOL; stdcall; external 'shlwapi.dll' Name 'PathFindOnPathA';

implementation

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
  FindFiles(FilesList, StartDir, FileMask, True);
end;

procedure FindFiles(var FilesList: TStringList; StartDir, FileMask: string; Recurse: Boolean);
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

  IsFound := FindFirst(StartDir + FileMask, faAnyFile - faDirectory, SR) = 0;
  while IsFound do begin
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
      while IsFound do begin
        if ((SR.Attr and faDirectory) <> 0) and
          (SR.Name[1] <> '.') then
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

begin
end.
