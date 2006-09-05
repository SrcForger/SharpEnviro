{ ==============================================================================
  Unit Version Info
  * Unit used to extract version information
  * Templated from ?
  * Bug Fixes applied
  ============================================================================ }
unit uVersInfo;

interface

uses
  Windows,
  Classes,
  SysUtils;

type
  TVersionInfo = class(TObject)
  private
    FData: Pointer;
    FSize: cardinal;
    FCompanyName: string;
    FFileDescription: string;
    FFileVersion: string;
    FInternalName: string;
    FLegalCopyright: string;
    FLegalTrademarks: string;
    FOriginalFilename: string;
    FProductName: string;
    FProductVersion: string;
    FComments: string;
  public
    constructor Create(FileName: string);
    destructor Destroy; override;
    function InfoPresent : Boolean;
    property CompanyName: string read FCompanyName;
    property FileDescription: string read FFileDescription;
    property FileVersion: string read FFileVersion;
    property InternalName: string read FInternalName;
    property LegalCopyright: string read FLegalCopyright;
    property LegalTrademarks: string read FLegalTrademarks;
    property OriginalFilename: string read FOriginalFilename;
    property ProductName: string read FProductName;
    property ProductVersion: string read FProductVersion;
    property Comments: string read FComments;
  end;

{ ==============================================================================
  ## IMPLEMENTATION
  ============================================================================ }
implementation

{ TVersionInfo }

constructor TVersionInfo.Create(FileName: string);
var
  sz, lpHandle, TableLocale: cardinal;
  PNum    : PDWord;
  PBuffer : PChar;
  StrTbl  : string;
  hiW, loW: word;
begin
  inherited Create;
  FSize := GetFileVersionInfoSize(PChar(FileName), lpHandle);

  // No version information for this file?
  if FSize = 0 then
    Exit;

  FData := AllocMem(FSize);
  if not GetFileVersionInfo(PChar(FileName), lpHandle, FSize, FData) then
    Exit;

  // Get Translation
  VerQueryValue(FData, '\\VarFileInfo\Translation', Pointer(PNum), sz);

  // Exit if no Translation String
  if not Assigned(PNum) then
    Exit;
    
  // Todo : Support for no "Translation" Section
  // How do we get the default StringFileInfo block

  hiW := HiWord(PNum^);
  loW := LoWord(PNum^);
  TableLocale := (loW shl 16) or hiW;
  StrTbl := Format('%.8x\', [TableLocale]);

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'CompanyName'), Pointer(PBuffer), sz);
  FCompanyName := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'FileDescription'),
    Pointer(PBuffer), sz);
  FFileDescription := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'FileVersion'), Pointer(PBuffer), sz);
  FFileVersion := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'InternalName'), Pointer(PBuffer), sz);
  FInternalName := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'LegalCopyright'),
    Pointer(PBuffer), sz);
  FLegalCopyright := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'LegalTrademarks'),
    Pointer(PBuffer), sz);
  FLegalTrademarks := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'OriginalFilename'),
    Pointer(PBuffer), sz);
  FOriginalFilename := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'ProductName'), Pointer(PBuffer), sz);
  FProductName := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'ProductVersion'),
    Pointer(PBuffer), sz);
  FProductVersion := PBuffer;

  VerQueryValue(FData, PChar('\\StringFileInfo\' + StrTbl + 'Comments'), Pointer(PBuffer), sz);
  FComments := PBuffer;
end; {Create}

destructor TVersionInfo.Destroy;
begin
  if Assigned(FData) then
    FreeMem(FData);

  inherited;
end;

function TVersionInfo.InfoPresent: Boolean;
begin
  // Returns True if file contains version information
  Result := Assigned(FData);
end;

end.
