{
Source Name: uSharpXMLUtils.dpr
Description: XML Loading and Saving functions including backup
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

unit uSharpXMLUtils;

interface

uses
  Windows,
  Classes,
  SysUtils,
  JclSimpleXML,
  SharpSharedFileAccess;

function LoadXMLFromSharedFile(var XML : TJclSimpleXML; filename : string) : boolean; overload;
function LoadXMLFromSharedFile(var XML : TJclSimpleXML; filename : string; BackupIfFailed : boolean) : boolean; overload;
function SaveXMLToSharedFile(var XML : TJclSimpleXML; filename : string) : boolean; overload;
function SaveXMLToSharedFile(var XML : TJclSimpleXML; filename : string; Backup : boolean) : boolean; overload;

implementation

function LoadXMLFromSharedFile(var XML : TJclSimpleXML; filename : string; BackupIfFailed : boolean) : boolean; overload;
begin
  result := LoadXMLFromSharedFile(XML,filename);
  if (BackupIfFailed) and (not result) then
  begin
    result := LoadXMLFromSharedFile(XML,filename + '~');
    if result then // failed to original file, but backup worked
    begin          // copy backup over to normal file                                                    
      try
        CopyFile(PChar(filename + '~'),PChar(filename),false);
      except
      end;
    end;
  end;
end;

function LoadXMLFromSharedFile(var XML : TJclSimpleXML; filename : string) : boolean;
var
  Stream : TMemoryStream;
begin
  result := False;
  if not FileExists(filename) then
    exit;
  if XML = nil then
    exit;

  Stream := TMemoryStream.Create;
  if OpenMemoryStreamShared(Stream,filename,True) = sfeSuccess then
  begin
    try
      XML.LoadFromStream(Stream);
      result := True;
    except
    end;
  end;
  Stream.Free;
end;

function SaveXMLToSharedFile(var XML : TJclSimpleXML; filename : string; Backup : boolean) : boolean;
begin
  result := False;
  if Backup then
  begin
    if SaveXMLToSharedFile(XMl,filename + '~') then
    begin
      if CopyFile(PChar(filename + '~'), PChar(filename), false) then
        result := True;
    end else result := SaveXMLToSharedFile(XMl,filename);
  end else result := SaveXMLToSharedFile(XML,filename);
end;

function SaveXMLToSharedFile(var XML : TJclSimpleXML; filename : string) : boolean;
var
  Stream : TSharedFileStream;
begin
  result := False;
  if XML = nil then
    exit;

  if OpenFileStreamShared(Stream,sfaCreate,filename,True) = sfeSuccess then
  begin
    Stream.Size := 0;
    XML.SaveToStream(Stream);
    Stream.Free;
    result := True;
  end;
end;



end.
