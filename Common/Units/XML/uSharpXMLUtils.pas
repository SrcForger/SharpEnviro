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
    result := LoadXMLFromSharedFile(XML,filename + '~');
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
