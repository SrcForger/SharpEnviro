unit uComponentMan;

interface
uses
  Windows,
  Messages,
  ShellAPI,
  SharpAPI,
  Classes,
  SysUtils;

implementation

procedure ScanComponents(strExtension: String);
var
  intFound: Integer;
  srFile: TSearchRec;
begin
  intFound := FindFirst(GetSharpeDirectory + 'Services\*' + strExtension, faAnyFile, srFile);
  while intFound = 0 do
  begin
    //add to list of items
    intFound := FindNext(srFile);
  end;
  FindClose(srFile);
end;

function GetInfo(strFile: String): TServiceMetaData;
type
  TMetaDataFunc = function(): TServiceMetaData;
const
  MetaDataFunc: TMetaDataFunc = nil;
var
  hndFile: THandle;
begin
  if FileExists(strFile) then
  begin
    hndFile := LoadLibrary(PChar(strFile));
    try
      @MetaDataFunc := GetProcAddress(hndFile, 'GetMetaData');
      if Assigned(MetaDataFunc) then
        result := MetaDataFunc();
    finally
      FreeLibrary(hndFile);
    end;
  end;
end;

end.
