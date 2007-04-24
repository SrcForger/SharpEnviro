unit SharpEFontSelectorFontList;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls;

type
  TFontType = (ftRaster, ftDevice, ftTrueType);
  (*----------------------------------------------------------------------------------*)
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
  (*----------------------------------------------------------------------------------*)
  TFontList = class
  private
    procedure ClearList;
    procedure AddFont(EnumLogFont: TEnumLogFont; TextMetric: TNewTextMetric; FontType: Integer);
  public
    List: TStringList;
    constructor Create;
    destructor Destroy; override;
    procedure RefreshFontInfo;
  end;

implementation

{ TFontList }
(*----------------------------------------------------------------------------------*)

constructor TFontList.Create;
begin
  inherited Create;
  List := TStringList.Create;
  List.Sorted := True;
  List.Duplicates := dupIgnore;
end;
(*----------------------------------------------------------------------------------*)

destructor TFontList.Destroy;
begin
  ClearList;
  inherited Destroy;
end;
(*----------------------------------------------------------------------------------*)

procedure TFontList.ClearList;
begin
  while List.Count > 0 do begin
    TFontInfo(List.Objects[0]).Free;
    List.Delete(0);
  end;
end;
(*----------------------------------------------------------------------------------*)

function EnumFONTSProc(var EnumLogFont: TEnumLogFont; var TextMetric: TNewTextMetric; FontType:
  Integer; Data: LPARAM): Integer; stdcall;
var
  FontList: TFontList;
begin
  FontList := TFontList(Data);
  FontList.AddFont(EnumLogFont, TextMetric, FontType);
  Result := 1;
end;
(*----------------------------------------------------------------------------------*)

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
(*----------------------------------------------------------------------------------*)

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

 