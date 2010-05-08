unit uSharpXMLUtils;

interface

uses
  Classes,
  SysUtils,
  JclSimpleXML,
  SharpSharedFileAccess;

function LoadXMLFromSharedFile(var XML : TJclSimpleXML; filename : string) : boolean;
function SaveXMLToSharedFile(var XML : TJclSimpleXML; filename : string) : boolean;

implementation

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
