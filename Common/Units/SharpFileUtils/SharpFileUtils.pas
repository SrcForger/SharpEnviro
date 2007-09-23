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
  SysUtils,
  JclStrings;

function GetFileNameWithoutParams(pTarget : String) : String;

implementation

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
