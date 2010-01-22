unit SystemFontList;

interface

uses
  Windows,
  JclStrings,
  SysUtils,
  Classes,
  ExtCtrls;

type
  TFontType = (ftRaster, ftDevice, ftTrueType);

  TFontInfo = class
  private
    FShortName: string;
    FFullName: string;
    FStyle: string;
    FLF: TLogFont;
    FFontType: TFontType;
    FTM: TNewTextMetric;
  public
    property FullName: string read FFullName;
    property ShortName: string read FShortName;
    property Style: string read FStyle;
    property FontType: TFontType read FFontType;
    property TM: TNewTextMetric read FTM;
    property LF: TLogFont read FLF;
  end;

  TFontList = class
  private
    procedure ClearList;
    procedure AddFont(EnumLogFont: TEnumLogFont; TextMetric: TNewTextMetric; FontType: Integer);
  public
    List: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure RefreshFontInfo;
    function ParseFont(Src : String) : String;
  end;

implementation

constructor TFontList.Create;
begin
  inherited Create;
  List := TStringList.Create;
  List.Sorted := True;
  List.Duplicates := dupIgnore;
end;

destructor TFontList.Destroy;
begin
  ClearList;
  inherited Destroy;
end;

function TFontList.ParseFont(Src : String): String;
var
  iSrc,iFont : integer;
  SList : TStringList;
  font : String;
begin
  SList := TStringList.Create;
  StrTokenToStrings(Src, ',', SList);

  font := 'Arial';
  try
    for iSrc := 0 to SList.Count - 1 do
      for iFont := 0 to List.Count - 1 do
        if (CompareText(TFontInfo(List.Objects[iFont]).ShortName,SList[iSrc]) = 0)
          or (CompareText(TFontInfo(List.Objects[iFont]).FullName,SList[iSrc]) = 0) then
        begin
          font := SList[iSrc];
          exit;
        end;
  finally
    result := font;
    SList.Free;
  end;
end;

procedure TFontList.ClearList;
begin
  while List.Count > 0 do begin
    TFontInfo(List.Objects[0]).Free;
    List.Delete(0);
  end;
end;

function EnumFONTSProc(var EnumLogFont: TEnumLogFont; var TextMetric: TNewTextMetric; FontType:
  Integer; Data: LPARAM): Integer; stdcall;
var
  FontList: TFontList;
begin
  FontList := TFontList(Data);
  FontList.AddFont(EnumLogFont, TextMetric, FontType);
  Result := 1;
end;

procedure TFontList.AddFont(EnumLogFont: TEnumLogFont; TextMetric: TNewTextMetric; FontType:
  Integer);
var
  FI: TFontInfo;
begin
  FI := TFontInfo.Create;

  FI.FShortName := StrPas(EnumLogFont.elfLogFont.lfFaceName);
  FI.FFullName := StrPas(EnumLogFont.elfFullName);
  FI.FStyle := StrPas(EnumLogFont.elfStyle);
  FI.FLF := EnumLogFont.elfLogFont;

  FI.FFontType := ftRaster;
  case FontType of
    RASTER_FONTTYPE: FI.FFontType := ftRaster;
    DEVICE_FONTTYPE: FI.FFontType := ftDevice;
    TRUETYPE_FONTTYPE: FI.FFontType := ftTrueType;
  end;

  FI.FTM := TextMetric;

  List.AddObject(FI.FShortName, FI);
end;

procedure TFontList.RefreshFontInfo;
var
  DC: HDC;
begin
  ClearList;
  DC := GetDC(0);
  try
    EnumFontFamilies(DC, nil, @EnumFONTSProc, Longint(Self));
  finally
    ReleaseDC(0, DC);
  end;
end;

end.
