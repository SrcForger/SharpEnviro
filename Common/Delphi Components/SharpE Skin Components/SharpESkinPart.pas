{
Source Name: SharpESkinPart.pas
Description: Skin Part classes
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit SharpESkinPart;

interface

uses
  Windows,
  gr32,
  graphics,
  jvsimplexml,
  types,
  SharpEBase,
  SharpEBitmapList,
  SharpEScheme,
  Classes,
  Math,
  GR32_Resamplers,
  GR32_Blend,
  Sharpapi,
  SharpGraphicsUtils;

type
  TSkinPart = class;
  TSkinPartList = class;
  TSkinDrawMode = (sdmTile, sdmStretch);
  TLayerMode = (lmBlend, lmAdd, lmSubtract, lmModule, lmMin, lmMax,
    lmDifference, lmExclusion);

  TSkinPoint = class
  private
    FX: string;
    FY: string;
    function GetXInteger : integer;
    function GetYInteger : integer;
    function ParseCoordinate(s: string; tw, th, cw, ch: integer): integer;
  public
    constructor Create;
    procedure Clear;

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    procedure Assign(Value: TSkinPoint);
    procedure SetPoint(x, y: string); overload;
    procedure SetPoint(str: string); overload;
    function GetXY(TextRect: TRect; CompRect: TRect): TPoint;
    property X: string read FX;
    property Y: string read FY;
    property XAsInt : integer read GetXInteger;
    property YAsInt : integer read GetYInteger;
  end;

  TSkinDim = class
  private
    FX: string;
    FY: string;
    FWidth: string;
    FHeight: string;
    function GetXInteger : integer;
    function GetYInteger : integer;
    function GetWidthInteger : integer;
    function GetHeightInteger : integer;
  public
    constructor Create;
    procedure Clear; virtual;
    procedure SetLocation(x, y: string); overload;
    procedure SetLocation(str: string); overload;
    procedure SetDimension(w, h: string); overload;
    procedure SetDimension(str: string); overload;

    procedure SaveToStream(Stream: TStream); virtual;
    procedure LoadFromStream(Stream: TStream); virtual;

    function GetRect(ps: Trect): TRect;
    function ParseCoordinate(s: string; w, h: integer): integer;
    procedure Assign(Value: TSkinDim); virtual;
    property X: string read FX;
    property Y: string read FY;
    property XAsInt : integer read GetXInteger;
    property YAsInt : integer read GetYInteger;
    property Width: string read FWidth;
    property Height: string read FHeight;
    property WidthAsInt : integer read GetWidthInteger;
    property HeightAsInt : integer read GetHeightInteger;
  end;

  TSkinIcon = class(TSkinDim)
  private
    FDrawIcon : boolean;
  public
    procedure Clear; override;
    procedure Assign(Value: TSkinIcon); reintroduce;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    procedure LoadFromXML(xml: TJvSimpleXMLElem);
    property DrawIcon : boolean read FDrawIcon write FDrawIcon;
  end;

  TShadowType = (stLeft,stRight,stOutline);

  TSkinText = class
  private
    FX: string;
    FY: string;
    FName: string;
    FColor: integer;
    FColorString: String;
    FSize: integer;
    FAlpha: byte;
    FAlphaString: String;
    FStyleBold : boolean;
    FStyleItalic : boolean;
    FStyleUnderline : boolean;
    FMaxWidth : String;
    FShadow : boolean;
    FShadowColor : integer;
    FShadowColorString : String;
    FShadowType : TShadowType;
    FShadowAlpha : byte;
    FDrawText : boolean;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Value: TSkinText); overload;
    procedure Assign(Value: TSkinTextRecord); overload;
    procedure SetLocation(x, y: string); overload;
    procedure SetLocation(str: string); overload;
    procedure SetMaxWidth(width : String);

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    procedure LoadFromXML(xml: TJvSimpleXMLElem);
    function ParseCoordinate(s: string; tw, th, cw, ch: integer): integer;
    function GetXY(TextRect: TRect; CompRect: TRect): TPoint;
    function GetMaxWidth(CompRect: TRect): integer;
    function GetFont(cs: TSharpEScheme): TFont;
    procedure AssignFontTo(pFont : TFont; cs: TSharpEScheme);
    procedure RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : TSharpEScheme;
                       var pPrecacheText : TSkinText; var pPrecacheBmp : TBitmap32; var pPrecacheCaption : String); overload;
    procedure RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : TSharpEScheme); overload;
  published
    property Color : integer read FColor write FColor;
    property ColorString : String read FColorString write FColorString;
    property Alpha : byte read FAlpha write FAlpha;
    property AlphaString : string read FAlphaString write FAlphaString;
    property ShadowColor : integer read FShadowColor write FShadowColor;
    property ShadowColorString : String read FShadowColorString write FShadowColorString;
    property ShadowAlpha : byte read FShadowAlpha write FShadowAlpha;
    property DrawText : boolean read FDrawText write FDrawText;
  end;

  TSkinPartList = class(TObject)
  private
    fhead, ftail: TSkinPart;
    fsize: integer;
    FBmpList: TSkinBitmapList;

    function getsize: integer;
    procedure remove(p: TSkinPart);
    procedure delete(p: TSkinPart); overload;
    procedure append(p: TSkinPart);
    procedure insertbefore(p, before: TSkinPart);
    function GetItem(const index: integer): TSkinPart;
  public
    constructor Create(BmpList: TSkinBitmapList);
    destructor Destroy; override;
    property Item[const Index: integer]: TSkinPart read GetItem; default;
    procedure Clear;
    procedure Add(p: TSkinPart);
    procedure Insert(index: integer; p: TSkinPart);
    procedure Delete(index: Integer); overload;
    property Count: integer read getsize;
  end;

  TSkinPart = class(TObject)
  private //for linked list
    next, prev: TSkinPart;
    parentlist: TSkinPartList;
    FLayerMode: TLayerMode;

  private
    FItems: TSkinPartList;
    FID: String;
    FBmpList: TSkinBitmapList;
    FBitmapId: integer;
    FMasterAlpha: byte;
    FMasterAlphaString : String;
    FDrawMode: TSkinDrawMode;
    FEnabled : boolean;
    FEnabledString : String;
    FBlend: boolean;
    FBlendColor: integer;
    FBlendColorString : String;
    FBlendAlpha: byte;
    FSkinDim: TSkinDim;
    FSkinText: TSkinText;
    FGradientType : string;
    FGradientColor : TSkinPoint;
    FGradientColorS : TSkinPoint;
    FGradientAlpha : TSkinPoint;
    Procedure DoCombine(F: TColor32; var B: TColor32; M: TColor32);
    procedure TileDraw(Src,Dest : TBitmap32; DestRect : TRect);
    procedure CustomDraw(Src, Dst : TBitmap32; SrcRect, DstRect : TRect);
  public
    constructor Create(BmpList: TSkinBitmapList); virtual;
    destructor Destroy; override;
    procedure Assign(Value: TSkinPart); virtual;
    procedure Clear; virtual;

    procedure SaveToStream(Stream: TStream);  virtual;
    procedure LoadFromStream(Stream: TStream); virtual;

    procedure UpdateDynamicProperties(cs: TSharpEScheme);

    function LoadFromXML(xml: TJvSimpleXMLElem; path: string; Text: TSkinText): boolean; virtual;
    procedure draw(bmp: TBitmap32; cs: TSharpEScheme);
    function Empty: Boolean;
    function GetBitmap: TBitmap32;
  published
    property ID: String read FID;
    property Items: TSkinPartList read FItems;
    property Bitmap: TBitmap32 read GetBitmap;
    property BitmapID: integer read FBitmapID write FBitmapID;
    property SkinDim: TSkinDim read FSkinDim write FSkinDim;
    property SkinText: TSkinText read FSkinText write FSkinText;
    property LayerMode: TLayerMode read FLayerMode write FLayerMode;
    property Blend: boolean read FBlend write FBlend;
    property BlendColor: integer read FBlendColor write FBlendColor;
    property BlendColorString : string read FBlendColorString write FBlendColorString;
    property BlendAlpha: byte read FBlendAlpha write FBlendAlpha;
    property GradientType: string read FGradientType write FGradientType;
    property GradientAlpha: TSkinPoint read FGradientAlpha write FGradientAlpha;
    property GradientColor: TSkinPoint read FGradientColor write FGradientColor;
    property GradientColorS : TSkinPoint read FGradientColorS write FGradientColorS;
    property MasterAlpha : byte read FMasterAlpha write FMasterAlpha;
    property MasterAlphaString : String read FMasterAlphaString write FMasterAlphaString;
    property Enabled : boolean read FEnabled write FEnabled;
    property EnabledString : String read FEnabledString write FEnabledString;
  end;

  // TSkinPart with Icon!
  TSkinPartEx = class(TSkinPart)
  private
    FSkinIcon : TSkinIcon;
    FWidthMod : integer;
  public
    constructor Create(BmpList: TSkinBitmapList); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure Assign(Value: TSkinPartEx); reintroduce;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    function LoadFromXML(xml: TJvSimpleXMLElem; path: string;
                         Text: TSkinText; Icon : TSkinIcon): boolean; reintroduce;
  published
    property SkinIcon : TSkinIcon read FSkinIcon;
    property WidthMod : integer read FWidthMod;
  end;    

function get_location(str: string): TRect;
function EvaluateValue(str: string; cs: TSharpEScheme) : integer;
function SchemedStringToColor(str: string; cs: TSharpEScheme): TColor;
procedure doBlend(Dest: TBitmap32; source: TBitmap32; color: TColor);
procedure VGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);

implementation

uses Sysutils,
     SharpEDefault,
     gr32_png,
     SharpThemeApi;

type ESkinPartList = class(Exception);

//***************************************
//* TSkinPoint
//***************************************

constructor TSkinPoint.create;
begin
  Clear;
end;

procedure TSkinPoint.Clear;
begin
  FX := '0';
  FY := '0';
end;

procedure TSkinPoint.SaveToStream(Stream: TStream);
begin
  StringSaveToStream(FX, Stream);
  StringSaveToStream(FY, Stream);
end;

procedure TSkinPoint.LoadFromStream(Stream: TStream);
begin
  FX := StringLoadFromStream(Stream);
  FY := StringLoadFromStream(Stream);
end;

procedure TSkinPoint.Assign(Value: TSkinPoint);
begin
  FX := Value.FX;
  FY := Value.FY;
end;

procedure TSkinPoint.SetPoint(str: string);
var
  position: integer;
begin
  position := Pos(',', str);
  if (position > 0) and (position < length(str)) then
  begin
    SetPoint(Copy(str, 1, position - 1), Copy(str, position + 1, length(str)));
  end
  else
    SetPoint('0', '0');
end;

procedure TSkinPoint.SetPoint(x, y: string);
begin
  FX := x;
  FY := y;
end;

function TSkinPoint.GetXInteger : integer;
begin
  if not TryStrToInt(X,result) then
     result := 0;
end;

function TSkinPoint.GetYInteger : integer;
begin
  if not TryStrToInt(Y,result) then
     result := 0;
end;

function TSkinPoint.GetXY(TextRect: Trect; CompRect: TRect): TPoint;
var
  cw, ch: integer;
  tw, th: integer;
begin
  cw := CompRect.Right - CompRect.Left;
  ch := CompRect.Bottom - CompRect.Top;
  tw := TextRect.Right - TextRect.Left;
  th := TextRect.Bottom - TextRect.Top;

  result.X := ParseCoordinate(FX, tw, th, cw, ch);
  result.Y := ParseCoordinate(FY, tw, th, cw, ch);
end;


function TSkinPoint.ParseCoordinate(s: string; tw, th, cw, ch: integer): integer;
var i: integer;
  tmp: string;
  sub: boolean;
  k : integer;
begin
  if length(s) = 0 then
  begin
    result := 0;
    exit;
  end;

  result := 0;
  tmp := '';
  sub := false;
  i := 0;
  while i <= length(s) do
  begin
    inc(i);
    if (s[i] >= '0') and (s[i] <= '9') then
      tmp := tmp + s[i]
    else
      if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'cw') then
      begin
        tmp := inttostr(floor((cw - tw) / 2));
        inc(i);
      end
      else
        if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'ch') then
        begin
          tmp := inttostr(floor((ch - th) / 2));
          inc(i);
        end
        else
          if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'tw') then
          begin
            tmp := inttostr(tw);
            inc(i);
          end
          else
            if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'th') then
            begin
              tmp := inttostr(th);
              inc(i);
            end
            else
              if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'twh') then
              begin
                tmp := inttostr(tw div 2);
                inc(i);
              end
              else
                if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'thh') then
                begin
                  tmp := inttostr(th div 2);
                 inc(i);
                end
                else
                if (lowercase(s[i]) = 'w') then
                   tmp := inttostr(cw)
                else
                if (lowercase(s[i]) = 'h') then
                    tmp := inttostr(ch)
                else
                begin
                  if (tmp <> '') then
                  begin
                    if (sub) then
                    begin
                      if trystrtoint(tmp,k) then result := result - k;
                    end
                    else
                    begin
                      if trystrtoint(tmp,k) then result := result + k;
                    end;
                  end;
                  if (s[i] = '+') then
                    sub := false
                  else
                    if (s[i] = '-') then
                      sub := true;
                  tmp := '';
                end;
  end;
  if (tmp <> '') then
  begin
    if (sub) then
    begin
      if trystrtoint(tmp,k) then result := result - k
    end
    else
    begin
      if trystrtoint(tmp,k) then result := result + k;
    end;
  end;
end;


//***************************************
//* TSkinDim
//***************************************

constructor TSkinDim.create;
begin
  Clear;
end;

procedure TSkinDim.Clear;
begin
  FX := '';
  FY := '';
  FWidth := '';
  FHeight := '';
end;

procedure TSkinDim.SaveToStream(Stream: TStream);
begin
  StringSaveToStream(FX, Stream);
  StringSaveToStream(FY, Stream);
  StringSaveToStream(FWidth, Stream);
  StringSaveToStream(FHeight, Stream);
end;

procedure TSkinDim.LoadFromStream(Stream: TStream);
begin
  FX := StringLoadFromStream(Stream);
  FY := StringLoadFromStream(Stream);
  FWidth := StringLoadFromStream(Stream);
  FHeight := StringLoadFromStream(Stream);
end;

procedure TSkinDim.Assign(Value: TSkinDim);
begin
  FX := Value.FX;
  FY := Value.FY;
  FWidth := Value.FWidth;
  FHeight := Value.FHeight;
end;

procedure TSkinDim.SetLocation(x, y: string);
begin
  FX := x;
  FY := y;
end;

procedure TSkinDim.SetLocation(str: string);
var position: integer;
begin
  position := Pos(',', str);
  if (position > 0) and (position < length(str)) then
  begin
    SetLocation(Copy(str, 1, position - 1), Copy(str, position + 1,
      length(str)));
  end
  else
    SetLocation('', '');
end;

procedure TSkinDim.SetDimension(w, h: string);
begin
  FWidth := w;
  FHeight := h;
end;

procedure TSkinDim.SetDimension(str: string);
var position: integer;
begin
  position := Pos(',', str);
  if (position > 0) and (position < length(str)) then
  begin
    SetDimension(Copy(str, 1, position - 1), Copy(str, position + 1,
      length(str)));
  end
  else
    SetDimension('', '');
end;

function TSkinDim.ParseCoordinate(s: string; w, h: integer): integer;
var i: integer;
  tmp: string;
  sub: boolean;
  k : integer;
begin
  result := 0;
  tmp := '';
  sub := false;
  for i := 1 to length(s) do
  begin
    if (s[i] >= '0') and (s[i] <= '9') then
      tmp := tmp + s[i]
    else
      if (lowercase(s[i]) = 'w') then
        tmp := inttostr(w)
      else
        if (lowercase(s[i]) = 'h') then
          tmp := inttostr(h)
        else
        begin
          if (tmp <> '') then
          begin
            if (sub) then
            begin
              if trystrtoint(tmp,k) then result := result - k;
            end
            else
            begin
              if trystrtoint(tmp,k) then result := result + k;
            end;
          end;
          if (s[i] = '+') then
            sub := false
          else
            if (s[i] = '-') then
              sub := true;
          tmp := '';
        end;
  end;
  if (tmp <> '') then
  begin
    if (sub) then
    begin
      if trystrtoint(tmp,k) then result := result - k;
    end
    else
    begin
      if trystrtoint(tmp,k) then result := result + k;
    end;
  end;
end;

function TSkinDim.GetRect(ps: Trect): TRect;
var w, h: integer;
begin
  w := ps.Right - ps.Left;
  h := ps.Bottom - ps.Top;
  result.Left := ParseCoordinate(FX, w, h);
  result.Right := ParseCoordinate(FWidth, w, h) + result.Left;
  result.Top := ParseCoordinate(FY, w, h);
  result.Bottom := ParseCoordinate(FHeight, w, h) + result.Top;
end;

function TSkinDim.GetWidthInteger : integer;
begin
  if not TryStrToInt(FWidth,result) then
     result := 0;
end;

function TSkinDim.GetHeightInteger : integer;
begin
  if not TryStrToInt(FHeight,result) then
     result := 0;
end;

function TSkinDim.GetXInteger : integer;
begin
  if not TryStrToInt(FX,result) then
     result := 0;
end;

function TSkinDim.GetYInteger : integer;
begin
  if not TryStrToInt(FY,result) then
     result := 0;
end;

//***************************************
//* TSkinText
//***************************************

constructor TSkinText.Create;
begin
  inherited Create;

  Clear;
end;

destructor TSkinText.Destroy;
begin
  FX := '';

  inherited Destroy;
end;

procedure TSkinText.Clear;
begin
  FX := '';
  FY := '';
  FMaxWidth := 'w';
  FStyleBold := False;
  FStyleItalic := False;
  FStyleUnderline := False;
  FShadow := False;
  FShadowType := stRight;
  FShadowColor := 0;
  FShadowColorString := '0';
  FShadowAlpha := 255;
  FAlpha := 255;
  FAlphaString := '255';
  Assign(DefaultSharpESkinTextRecord);
end;

procedure TSkinText.SaveToStream(Stream: TStream);
begin
  StringSaveToStream(FX, Stream);
  StringSaveToStream(FY, Stream);
  StringSaveToStream(FName, Stream);
  StringSaveToStream(FColorString, Stream);
  StringSaveToStream(BoolToStr(FStyleBold),Stream);
  StringSaveToStream(BoolToStr(FStyleItalic),Stream);
  StringSaveToStream(BoolToStr(FStyleUnderline),Stream);
  StringSaveToStream(BoolToStr(FDrawText),Stream);
  StringSaveToStream(FMaxWidth, Stream);
  Stream.WriteBuffer(FSize, sizeof(FSize));
  StringSaveToStream(BoolToStr(FShadow),Stream);
  StringSaveToStream(FShadowColorString,Stream);
  case FShadowType of
    stLeft    : StringSaveToStream('0',Stream);
    stOutline : StringSaveToStream('2',Stream);
    else StringSaveToStream('1',Stream);
  end;
  Stream.WriteBuffer(FShadowAlpha,SizeOf(FShadowAlpha));
  Stream.WriteBuffer(FAlpha,SizeOf(FAlpha));
  StringSaveToStream(FAlphaString,Stream);
end;

procedure TSkinText.LoadFromStream(Stream: TStream);
var
  s : string;
begin
  FX := StringLoadFromStream(Stream);
  FY := StringLoadFromStream(Stream);
  FName := StringLoadFromStream(Stream);
  FColorString := StringLoadFromStream(Stream);
  FStyleBold := StrToBool(StringLoadFromStream(Stream));
  FStyleItalic := StrToBool(StringLoadfromStream(Stream));
  FStyleUnderline := StrToBool(StringLoadFromStream(Stream));
  FDrawText := StrToBool(StringLoadFromStream(Stream));
  FMaxwidth := StringLoadFromStream(Stream);
  Stream.ReadBuffer(FSize, sizeof(FSize));
  FShadow := StrToBool(StringLoadFromStream(Stream));
  FShadowColorString := StringLoadFromStream(Stream);
  s := StringLoadFromStream(Stream);
  if CompareText(s,'0') = 0 then FShadowType := stLeft
     else if CompareText(s,'2') = 0 then FShadowType := stOutline
     else FShadowType := stRight;
  Stream.ReadBuffer(FShadowAlpha,SizeOf(FShadowAlpha));
  Stream.ReadBuffer(FAlpha,SizeOf(FAlpha));
  FAlphaString := StringLoadFromStream(Stream);
end;

procedure TSkinText.Assign(Value: TSkinText);
begin
  FX := Value.FX;
  FY := Value.FY;
  FName := Value.FName;
  FColor := Value.FColor;
  FColorString := Value.FColorString;
  FSize := Value.FSize;
  FStyleBold := Value.FStyleBold;
  FStyleItalic := Value.FStyleItalic;
  FStyleUnderline := Value.FStyleUnderline;
  FMaxWidth := Value.FMaxWidth;
  FShadow := Value.FShadow;
  FShadowColor := Value.FShadowColor;
  FShadowColorString := Value.FShadowColorString;
  FShadowAlpha := Value.FShadowAlpha;
  FShadowType := Value.FShadowType;
  FAlpha := Value.FAlpha;
  FAlphaString := Value.FAlphaString;
  FDrawText := Value.DrawText;
end;

procedure TSkinText.Assign(Value: TSkinTextRecord);
begin
  FName := Value.FName;
  FColorString := Value.FColor;
  FSize := Value.FSize;
end;

procedure TSkinText.SetMaxWidth(width : String);
begin
  FMaxWidth := width;
end;

procedure TSkinText.SetLocation(x, y: string);
begin
  FX := x;
  FY := y;
end;

procedure TSkinText.AssignFontTo(pFont : TFont; cs: TSharpEScheme);
var
 f : TFont;
begin
  f := GetFont(cs);
  try
    pFont.Assign(f);
  except
  end;
  f.free;
end;

function TSkinText.GetFont(cs: TSharpEScheme): TFont;
begin
  result := TFont.Create;
  result.Name := FName;
  result.Size := FSize;
  result.Style := [];
  if FStyleBold then result.Style := result.Style + [fsBold];
  if FStyleItalic then result.Style := result.Style + [fsItalic];
  if FStyleUnderline then result.Style := result.Style + [fsUnderline];
  result.Color := FColor;
end;

procedure TSkinText.SetLocation(str: string);
var position: integer;
begin
  position := Pos(',', str);
  if (position > 0) and (position < length(str)) then
  begin
    SetLocation(Copy(str, 1, position - 1), Copy(str, position + 1,
      length(str)));
  end
  else
    SetLocation('', '');
end;

procedure TSkinText.UpdateDynamicProperties(cs: TSharpEScheme);
begin
  FAlpha := Min(255,Max(0,EvaluateValue(FAlphaString,cs)));
  FShadowColor := SchemedStringToColor(FShadowColorString,cs);
  FColor       := SchemedStringToColor(FColorString,cs);
end;

procedure TSkinText.LoadFromXML(xml: TJvSimpleXMLElem);
var
  s : string;
begin
  with xml.Items do
  begin
    if ItemNamed['name'] <> nil then
      FName := Value('name', 'Arial');
    if ItemNamed['size'] <> nil then
      FSize := IntValue('size', 7);
    if ItemNamed['color'] <> nil then
      FColorString := Value('color', '$000000');
    if ItemNamed['location'] <> nil then
      SetLocation(Value('location', '0,0'));
    if ItemNamed['bold'] <> nil then
      FStyleBold := BoolValue('bold',false);
    if ItemNamed['italic'] <> nil then
      FStyleItalic := BoolValue('italic',false);
    if ItemNamed['underline'] <> nil then
      FStyleUnderline := BoolValue('underline',false);
    if ItemNamed['maxwidth'] <> nil then
      FMaxWidth := Value('maxwidth','w');
    if ItemNamed['alpha'] <> nil then
      FAlphaString := Value('alpha','255');
    if ItemNamed['shadow'] <> nil then
      FShadow := BoolValue('shadow',false);
    if ItemNamed['shadowcolor'] <> nil then
      FShadowColorString := Value('shadowcolor','0');
    if ItemNamed['shadowalpha'] <> nil then
      FShadowAlpha := Max(0,Min(255,IntValue('shadowalpha',255)));
    if ItemNamed['shadowtype'] <> nil then
    begin
      s := Value('shadowtype','Right');
      if s = 'Left' then FShadowType := stLeft
         else if s = 'Outline' then FShadowType := stOutline
         else FShadowType := stRight;
    end;
    if ItemNamed['drawtext'] <> nil then
      FDrawText := BoolValue('drawtext',true);
  end;
end;

function TSkinText.ParseCoordinate(s: string; tw, th, cw, ch: integer): integer;
var i: integer;
  tmp: string;
  sub: boolean;
  k : integer;
begin
  if length(s) = 0 then
  begin
    result := 0;
    exit;
  end;

  result := 0;
  tmp := '';
  sub := false;
  i := 0;
  while i <= length(s) do
  begin
    inc(i);
    if (s[i] >= '0') and (s[i] <= '9') and (s[i] <> #0) then
      tmp := tmp + s[i]
    else
      if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'cw') then
      begin
        tmp := inttostr(floor((cw - tw) / 2));
        inc(i);
      end
      else
        if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'ch') then
        begin
          tmp := inttostr(floor((ch - th) / 2));
          inc(i);
        end
        else
          if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'tw') then
          begin
            tmp := inttostr(tw);
            inc(i);
          end
          else
            if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'th') then
            begin
              tmp := inttostr(th);
              inc(i);
            end
            else
              if (lowercase(s[i]) = 'w') then
                tmp := inttostr(cw)
              else
                if (lowercase(s[i]) = 'h') then
                  tmp := inttostr(ch)
                else
                begin
                  if (tmp <> '') then
                  begin
                    if (sub) then
                    begin
                      if trystrtoint(tmp,k) then result := result - k;
                    end
                    else
                    begin
                      if trystrtoint(tmp,k) then result := result + k;
                    end;
                  end;
                  if (s[i] = '+') then
                    sub := false
                  else
                    if (s[i] = '-') then
                      sub := true;
                  tmp := '';
                end;
  end;
  if (tmp <> '') then
  begin
    if (sub) then
    begin
      if trystrtoint(tmp,k) then result := result - k;
    end
    else
    begin
      if trystrtoint(tmp,k) then result := result + k;
    end;
  end;
end;

function TSkinText.GetMaxWidth(CompRect: TRect) : integer;
var
  cw, ch : integer;
begin
  cw := CompRect.Right - CompRect.Left;
  ch := CompRect.Bottom - CompRect.Top;
  result := ParseCoordinate(FMaxwidth,cw,ch,cw,ch);
end;

function TSkinText.GetXY(TextRect: Trect; CompRect: TRect): TPoint;
var
  cw, ch: integer;
  tw, th: integer;
begin
  cw := CompRect.Right - CompRect.Left;
  ch := CompRect.Bottom - CompRect.Top;
  tw := TextRect.Right - TextRect.Left;
  th := TextRect.Bottom - TextRect.Top;

  result.X := ParseCoordinate(FX, tw, th, cw, ch);
  result.Y := ParseCoordinate(FY, tw, th, cw, ch);
end;


procedure TSkinText.RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : TSharpEScheme);
var
  c : TColor;
  R,G,B : byte;
  c2 : TColor32;
  ShadowBmp : TBitmap32;
  TempBmp : TBitmap32;
  w,h : integer;
begin
  TempBmp := TBitmap32.Create;
  w := Bmp.TextWidth(Caption);
  h := Bmp.TextHeight(Caption);
  TempBmp.SetSize(w+20,h+20);
  TempBmp.Clear(color32(0,0,0,0));
  TempBmp.Font.Assign(bmp.Font);

  if FShadow then
  begin
    ShadowBmp := TBitmap32.Create;
    try
      ShadowBmp.DrawMode := dmBlend;
      ShadowBmp.CombineMode := cmMerge;
      ShadowBmp.SetSize(TempBmp.Width,TempBmp.Height);
      ShadowBmp.Clear(color32(0,0,0,0));
      ShadowBmp.Font.Assign(Bmp.Font);
      c := FShadowColor;
      R := GetRValue(c);
      G := GetGValue(c);
      B := GetBValue(c);
      c2 := color32(R,G,B,FShadowAlpha);
      case FShadowType of
        stLeft    : ShadowBmp.RenderText(TempBmp.Width div 2 - w div 2 - 1,
                                         TempBmp.Height div 2 - h div 2 + 1,Caption,0,c2);
        stRight   : ShadowBmp.RenderText(TempBmp.Width div 2 - w div 2 + 1,
                                         TempBmp.Height div 2 - h div 2 + 1,Caption,0,c2);
        stOutline :
        begin
          ShadowBmp.RenderText(TempBmp.Width div 2 - w div 2,
                               TempBmp.Height div 2 - h div 2,Caption,0,c2);
          boxblur(ShadowBmp,1,1);
          ShadowBmp.RenderText(TempBmp.Width div 2 - w div 2,
                               TempBmp.Height div 2 - h div 2,Caption,0,c2);
        end;
      end;
      boxblur(ShadowBmp,1,1);
      ShadowBmp.DrawTo(TempBmp,0,0);
      ShadowBmp.DrawTo(TempBmp,0,0);
      boxblur(ShadowBmp,1,1);
      ShadowBmp.DrawTo(TempBmp,0,0);
      ShadowBmp.DrawTo(TempBmp,0,0);
    finally
      ShadowBmp.Free;
    end;
  end;
  c := FColor;
  R := GetRValue(c);
  G := GetGValue(c);
  B := GetBValue(c);
  c2 := color32(R,G,B,255);
  TempBmp.RenderText(TempBmp.Width div 2 - w div 2,TempBmp.Height div 2 - h div 2,Caption,0,c2);
  TempBmp.MasterAlpha := FAlpha;
  TempBmp.DrawTo(Bmp,X-10,Y-10);

  FreeAndNil(TempBmp);
end;

procedure TSkinText.RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String; cs : TSharpEScheme;
                             var pPrecacheText : TSkinText; var pPrecacheBmp : TBitmap32; var pPrecacheCaption : String);
var
  R,G,B : byte;
  c2 : TColor32;
  new : boolean;
  ShadowBmp : TBitmap32;
  w,h : integer;
begin
  if (pPrecacheBmp = nil) or (pPrecacheText = nil) then
  begin
    new := True;
    if pPrecacheBmp = nil then
    begin
      pPrecacheBmp := TBitmap32.Create;
      pPrecacheBmp.DrawMode := dmBlend;
      pPrecacheBmp.CombineMode := cmMerge;
    end;
    if pPrecacheText = nil then
    begin
      pPrecacheText := TSkinText.Create;
      pPrecacheText.Clear;
      pPrecacheText.FColorString := '-1';
      pPrecacheText.UpdateDynamicProperties(cs);
    end;
  end else new := False;


  // Check if something changed since cache bmp has been created.
  if ((CompareText(pPrecacheText.FName,FName) <> 0) or
//     (CompareText(pPrecacheText.FColor,FColor) <> 0) or
     (pPrecacheText.FColor <> FColor) or
     (CompareText(pPrecacheText.FMaxWidth,FMaxWidth) <> 0) or
     (pPrecacheText.FShadowColor <> FShadowColor) or
     (pPrecacheText.FSize <> FSize) or
     (pPrecacheText.FStyleBold <> FStyleBold) or
     (pPrecacheText.FStyleItalic <> FStyleItalic) or
     (pPrecacheText.FStyleUnderline <> FStyleUnderline) or
     (pPrecacheText.FShadow <> FShadow) or
     (pPrecacheText.FShadowType <> FShadowType) or
     (pPrecacheText.FShadowAlpha <> FShadowAlpha) or
     (CompareText(pPrecacheCaption,Caption) <> 0)) or (new) then
  begin
    // text settings or caption changed! redraw caption
    pPrecacheText.Assign(self);
    pPrecacheCaption := Caption;
    w := Bmp.TextWidth(Caption);
    h := Bmp.TextHeight(Caption);
    pPrecacheBmp.SetSize(w+20,h+20);
    pPrecacheBmp.Clear(color32(0,0,0,0));
    pPrecacheBmp.Font.Assign(bmp.Font);

    if FShadow then
    begin
      ShadowBmp := TBitmap32.Create;
      try
        ShadowBmp.DrawMode := dmBlend;
        ShadowBmp.CombineMode := cmMerge;
        ShadowBmp.SetSize(pPrecacheBmp.Width,pPrecacheBmp.Height);
        ShadowBmp.Clear(color32(0,0,0,0));
        ShadowBmp.Font.Assign(Bmp.Font);
        R := GetRValue(FShadowColor);
        G := GetGValue(FShadowColor);
        B := GetBValue(FShadowColor);
        c2 := color32(R,G,B,FShadowAlpha);
        case FShadowType of
          stLeft    : ShadowBmp.RenderText(pPrecacheBmp.Width div 2 - w div 2 - 1,
                                           pPrecacheBmp.Height div 2 - h div 2 + 1,Caption,0,c2);
          stRight   : ShadowBmp.RenderText(pPrecacheBmp.Width div 2 - w div 2 + 1,
                                           pPrecacheBmp.Height div 2 - h div 2 + 1,Caption,0,c2);
          stOutline :
          begin
            ShadowBmp.RenderText(pPrecacheBmp.Width div 2 - w div 2,
                                 pPrecacheBmp.Height div 2 - h div 2,Caption,0,c2);
            boxblur(ShadowBmp,1,1);
            ShadowBmp.RenderText(pPrecacheBmp.Width div 2 - w div 2,
                                 pPrecacheBmp.Height div 2 - h div 2,Caption,0,c2);
          end;
        end;
        boxblur(ShadowBmp,1,1);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        boxblur(ShadowBmp,1,1);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
      finally
        ShadowBmp.Free;
      end;
    end;
    R := GetRValue(FColor);
    G := GetGValue(FColor);
    B := GetBValue(FColor);
    c2 := color32(R,G,B,255);
    pPrecacheBmp.RenderText(pPrecacheBmp.Width div 2 - w div 2,pPrecacheBmp.Height div 2 - h div 2,Caption,0,c2);
  end;
  pPrecacheBmp.MasterAlpha := FAlpha;
  pPrecacheBmp.DrawTo(Bmp,X-10,Y-10);
end;

//***************************************
//*  TSkinPartList
//***************************************

function TSkinPartList.getItem(const index: integer): TSkinPart;
var q: TSkinPart;
  i: integer;
begin
  result := nil;
  if (index > (fsize - 1)) then
    raise ESkinPartList.create('Index out of range.');
  q := fhead;
  i := 0;
  while q <> nil do
  begin
    if (index = i) then
    begin
      result := q;
    end;
    q := q.next;
    inc(i);
  end;
  if result = nil then
    raise ESkinPartList.create('Item not found.');
end;

procedure TSkinPartList.Delete(index: Integer);
begin
  delete(Item[index]);
end;

procedure TSkinPartList.Add(p: TSkinPart);
var
  q: TSkinPart;
begin
  q := TSkinPart.create(FBmpList);
  q.assign(p);
  append(q);
end;

procedure TSkinPartList.Insert(index: integer; p: TSkinPart);
var
  q: TSkinPart;
begin
  q := TSkinPart.create(FBmpList);
  q.assign(p);
  insertbefore(q, Item[index]);
end;

function TSkinPartList.getsize: integer;
begin
  result := fsize;
end;

constructor TSkinPartList.create(BmpList: TSkinBitmapList);
begin
  inherited create;
  fhead := nil; ftail := nil; fsize := 0;
  FBmpList := BmpList;
end;

procedure TSkinPartList.Clear;
var q: TSkinPart;
begin
  while fhead <> nil do
  begin
    q := fhead;
    fhead := fhead.next;
    q.parentlist := nil;
    q.free;
  end;
  ftail := nil;
  fsize := 0;
end;

destructor TSkinPartList.destroy;
var q: TSkinPart;
begin
  while fhead <> nil do
  begin
    q := fhead;
    fhead := fhead.next;
    q.parentlist := nil;
    q.free;
  end;
end;

procedure TSkinPartList.append(p: TSkinPart);
begin
  p.parentlist := self;
  if fhead = nil then
  begin
    fhead := p;
    ftail := p;
  end
  else
  begin
    p.prev := ftail;
    ftail.next := p;
    ftail := p;
  end;
  inc(fsize);
end;

procedure TSkinPartList.insertbefore(p, before: TSkinPart);
begin
  p.parentlist := self;
  if fhead = nil then
  begin
    fhead := p;
    ftail := p;
  end
  else
  begin
    if before = fhead then
    begin
      p.next := fhead;
      fhead.prev := p;
      fhead := p;
    end
    else
    begin
      p.next := before;
      p.prev := before.prev;
      p.prev.next := p;
      before.prev := p;
    end;
  end;
  inc(fsize);
end;

procedure TSkinPartList.remove(p: TSkinPart);
begin
  if p = fhead then
  begin
    fhead := fhead.next;
    if fhead = nil then
      ftail := nil
    else
      fhead.prev := nil;
  end
  else
  begin
    if p = ftail then
    begin
      ftail := ftail.prev;
      if ftail = nil then
        fhead := nil
      else
        ftail.next := nil;
    end
    else
    begin
      p.prev.next := p.next;
      p.next.prev := p.prev;
    end;
  end;
  dec(fsize);
  p.next := nil;
  p.prev := nil;
end;

procedure TSkinPartList.delete(p: TSkinPart);
begin
  remove(p);
  p.free;
end;

//***************************************
//*  TSkinPart
//***************************************

function TSkinPart.Empty: boolean;
var test: boolean;
begin
  if (Bitmap <> nil) then
    test := Bitmap.Empty
  else
    test := true;
  result := test and (FItems.Count = 0);
end;

procedure TSkinPart.UpdateDynamicProperties(cs: TSharpEScheme);
var
  n : integer;
begin
  FBlendColor := SchemedStringToColor(FBlendColorString,cs);
  FGradientColor.FX := inttostr(SchemedStringToColor(FGradientColorS.X,cs));
  FGradientColor.FY := inttostr(SchemedStringToColor(FGradientColorS.Y,cs));
  FMasterAlpha := Min(255,Max(0,EvaluateValue(FMasterAlphaString,cs)));
  n := EvaluateValue(FEnabledString,cs);
  FEnabled := (n <> 0);
  FSkinText.UpdateDynamicProperties(cs);
  for n := 0 to FItems.Count - 1 do
      Items[n].UpdateDynamicProperties(cs);
end;

procedure TSkinPart.SaveToStream(Stream: TStream);
var i, count: integer;
begin
  Stream.WriteBuffer(FBitmapId, sizeof(FBitmapId));
  StringSaveToStream(FMasterAlphaString,Stream);
  Stream.WriteBuffer(FMasterAlpha, sizeof(FMasterAlpha));
  Stream.WriteBuffer(FDrawMode, sizeof(FDrawMode));
  Stream.WriteBuffer(FLayerMode, sizeof(FLayerMode));
  Stream.WriteBuffer(FBlend, sizeof(FBlend));
  StringSaveToStream(FBlendColorString, Stream);
  StringSaveToStream(FID, Stream);
  Stream.WriteBuffer(FEnabled,SizeOf(FEnabled));
  StringSaveToStream(FEnabledString,Stream);
  FGradientAlpha.SaveToStream(Stream);
  FGradientColorS.SaveToStream(Stream);
  StringSavetoStream(FGradientType, Stream);
  FSkinDim.SaveToStream(Stream);
  FSkinText.SaveToStream(Stream);
  count := FItems.Count;
  Stream.WriteBuffer(count, sizeof(count));
  for i := 0 to count - 1 do
    Items[i].SaveToStream(Stream);
end;

procedure TSkinPart.LoadFromStream(Stream: TStream);
var i, count: integer;
  sp: TSkinPart;
begin
  Clear;
  sp := TSkinPart.create(FBmpList);
  try
    Stream.ReadBuffer(FBitmapId, sizeof(FBitmapId));
    FMasterAlphaString := StringLoadFromStream(Stream);
    Stream.ReadBuffer(FMasterAlpha, sizeof(FMasterAlpha));
    Stream.ReadBuffer(FDrawMode, sizeof(FDrawMode));
    Stream.ReadBuffer(FLayerMode, sizeof(FLayerMode));
    Stream.ReadBuffer(FBlend, sizeof(FBlend));
    FBlendColorString := StringLoadFromStream(Stream);
    FID := StringLoadFromStream(Stream);
    Stream.ReadBuffer(FEnabled, sizeof(FEnabled));
    FEnabledString := StringLoadFromStream(Stream);
    FGradientAlpha.LoadFromStream(Stream);
    FGradientColorS.LoadFromStream(Stream);
    FGradientType := StringLoadFromStream(Stream);
    FSkinDim.LoadFromStream(Stream);
    FSkinText.LoadFromStream(Stream);
    Stream.ReadBuffer(count, sizeof(count));
    for i := 0 to count - 1 do
    begin
      sp.LoadFromStream(Stream);
      FItems.Add(sp);
    end;
    sp.Free;
  except
    sp.Free;
    raise;
  end;
end;

procedure TSkinPart.CustomDraw(Src, Dst : TBitmap32; SrcRect, DstRect : TRect);
begin
  Src.DrawMode := dmCustom;
  Src.OnPixelCombine := DoCombine;
 
  Case FLayerMode of 
    lmBlend: begin 
              Src.OnPixelCombine := nil; 
              Src.DrawMode := dmBlend;
             end; 
    lmAdd: Src.OnPixelCombine := nil;
  end;

  Dst.Draw(DstRect,SrcRect,Src);
end;

procedure TSkinPart.draw(bmp: TBitmap32; cs: TSharpEScheme);
var temp: Tbitmap32;
  FBitmap: Tbitmap32;
  i: integer;
  r: Trect;
  isEmpty: boolean;

begin
  if not FEnabled then exit;

  if (FBitmapId >= 0) then
  begin
    FBitmap := TSkinBitmap(FBmpList.Items[FBitmapId]).Bitmap;
    if TSkinBitmap(FBmpList.Items[FBitmapID]).FileName = 'empty' then
      isEmpty := True
    else
      isEmpty := False;
    FBitmap.MasterAlpha := FMasterAlpha;
    FBitmap.DrawMode := dmBlend;
    FBitmap.CombineMode := cmMerge;

    r := FSkinDim.GetRect(rect(0, 0, bmp.Width, bmp.Height));
    if IsEmpty then
    begin
      FBitmap.SetSize(r.Right - r.Left, R.Bottom - R.Top);
      FBitmap.Clear(color32(BlendColor));
    end;
    TKernelResampler.Create(bmp).Kernel := TLanczosKernel.Create;
    if (Fblend) and not (IsEmpty) then
    begin
      temp := TBitmap32.Create;
      temp.DrawMode := dmBlend;
      temp.CombineMode := cmMerge;
      try
        doBlend(temp, FBitmap, BlendColor);
        temp.MasterAlpha := FMasterAlpha;
        if FDrawMode = sdmStretch then CustomDraw(temp, bmp, rect(0,0, temp.width, temp.height), r)
           else TileDraw(temp,bmp,r);
      finally
        temp.free;
      end
    end
    else
    begin
      if FDrawMode = sdmStretch then CustomDraw(FBitmap, bmp, rect(0, 0, FBitmap.width, FBitmap.Height), r)
         else TileDraw(FBitmap,bmp,r);
    end;

    // if Bitmap is an empty blend dummy image set the size back to 16,16
    // saves memory...
    if IsEmpty then
    begin
      FBitmap.SetSize(16, 16);
      FBitmap.Clear(color32(0, 0, 0, 0));
    end;
  end;

  // Draw Gradient
  if (FGradientAlpha.XAsInt <> 0) or (FGradientAlpha.YAsInt <> 0) then
  begin
    r := FSkinDim.GetRect(rect(0, 0, bmp.Width, bmp.Height));
    if GradientType = 'horizontal' then
       HGradient(Bmp,
                 FGradientColor.XAsInt,
                 FGradientColor.YAsInt,
                 FGradientAlpha.XAsInt,
                 FGradientAlpha.YAsInt,
                 r)
       else VGradient(Bmp,
                 FGradientColor.XAsInt,
                 FGradientColor.YAsInt,
                 FGradientAlpha.XAsInt,
                 FGradientAlpha.YAsInt,
                 r);
  end;

  for i := 0 to Items.Count - 1 do
  begin
    Items[i].draw(bmp, cs);
  end;
end;

function TSkinPart.LoadFromXML(xml: TJvSimpleXMLElem; path: string; Text: TSkinText): boolean;
var sp: TSkinPart;
  i: integer;
  fil: string;
  s : string;
begin
  Clear;
  if Text <> nil then
    FSkinText.Assign(Text);
  sp := TSkinPart.create(FBmpList);
  try
    result := false;
    with xml.Items do
    begin
      if ItemNamed['ID'] <> nil then
        FID := Value('ID','');
      if ItemNamed['enabled'] <> nil then
        FEnabledString := Value('enabled','1');
      if ItemNamed['gradienttype'] <> nil then
        FGradientType := Value('gradienttype','horizontal');
      if ItemNamed['gradientcolor'] <> nil then
        FGradientColorS.SetPoint(Value('gradientcolor','0,0'));
      if ItemNamed['gradientalpha'] <> nil then
        FGradientAlpha.SetPoint(Value('gradientalpha','0,0'));
      if ItemNamed['text'] <> nil then
        FSkinText.LoadFromXml(ItemNamed['text']);
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location', '0,0'));
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', '0,0'));
      if ItemNamed['alpha'] <> nil then
        FMasterAlphaString := Value('alpha', '255');
      if ItemNamed['drawmode'] <> nil then
        if lowercase(Value('drawmode', 'stretch')) = 'tile' then
          FDrawMode := sdmTile;
      if ItemNamed['layermode'] <> nil then
      begin
        s := Value('layermode','blend');
        if         CompareText('Blend',s) = 0 then FLayerMode := lmBlend
           else if CompareText('Add',s) = 0 then FLayerMode := lmAdd
           else if CompareText('Subtract',s) = 0 then FLayerMode := lmSubtract
           else if CompareText('Module',s) = 0 then FLayerMode := lmModule
           else if CompareText('Min',s) = 0 then FLayerMode := lmMin
           else if CompareText('Max',s) = 0 then FLayerMode := lmMax
           else if CompareText('Difference',s) = 0 then FLayerMode := lmDifference
           else if CompareText('Exclusion',s) = 0 then FLayerMode := lmExclusion
           else  FLayerMode := lmBlend;
      end;

      if ItemNamed['color'] <> nil then
      begin
        FBlendColorString := Value('color', '');
        FBlend := true;
      end;
      if ItemNamed['blendalpha'] <> nil then
      begin
        FBlendAlpha := IntValue('blendalpha', 255);
      end;
      if ItemNamed['image'] <> nil then
      begin
        if lowercase(Value('image', '')) = 'empty' then
        begin
          FBitmapId := FBmpList.Find('empty');
          if (FBitmapId < 0) then
            FBitmapId := FBmpList.AddEmptyBitmap(0, 0);
          result := (FBitmapId >= 0);
        end
        else
        begin
          fil := path + Value('image', '');
          FBitmapId := FBmpList.Find(fil);
          if (FBitmapId < 0) then
            FBitmapId := FBmpList.AddFromFile(fil);
          result := (FBitmapId >= 0);
        end;
      end;
      for i := 0 to Count - 1 do
      begin
        if lowercase(Item[i].Name) = 'skinpart' then
        begin
          if (sp.LoadFromXML(Item[i], path, nil)) then
          begin
            FItems.Add(sp);
            result := true;
          end;
        end;
      end;
    end;
  except
    result := false;
  end;
  sp.free;
end;

procedure TSkinPart.Assign(Value: TSkinPart);
var i: integer;
begin
  Clear;
  if Value = nil then
    Exit;
  FID := Value.ID;
  FBitmapId := Value.FBitmapId;
  FSkinDim.Assign(Value.SkinDim);
  FBlend := Value.Blend;
  FBlendColorString := Value.BlendColorString;
  FBlendColor := Value.BlendColor;
  FBlendAlpha := Value.BlendAlpha;
  FMasterAlphaString := Value.MasterAlphaString;
  FMasterAlpha := Value.FMasterAlpha;
  FDrawMode := Value.FDrawMode;
  FGradientType := Value.GradientType;
  FGradientColor.Assign(Value.GradientColor);
  FGradientAlpha.Assign(Value.GradientAlpha);
  FGradientColorS.Assign(Value.GradientColorS);
  FLayerMode := Value.LayerMode;
  FEnabled := Value.Enabled;
  FEnabledString := Value.FEnabledString;
  for i := 0 to Value.Items.count - 1 do
  begin
    FItems.Add(Value.Items[i]);
  end;
end;

procedure TSkinPart.Clear;
begin
  if FItems <> nil then
    FItems.Clear;
  FID := '';
  FBitmapID := -1;
  FBlend := false;
  FBlendColor := 0;
  FBlendColorString := '$000000';
  FBlendAlpha := 255;
  FMasterAlphaString := '255';
  FMasterAlpha := 255;
  FGradientColor.Clear;
  FGradientColorS.Clear;
  FGradientAlpha.Clear;
  FGradientType := 'horizontal';
  FEnabled := True;
  FEnabledString := '1';
  FSkinDim.Clear;
  FSkinText.Clear;
end;

constructor TSkinPart.Create(BmpList: TSkinBitmapList);
begin
  inherited Create;
  next := nil; prev := nil;
  FItems := TSkinPartList.create(BmpList);
  FSkinDim := TSkinDim.create;
  FSkinText := TSkinText.create;
  FGradientColor := TSkinPoint.Create;
  FGradientColorS := TSkinPoint.Create;
  FGradientAlpha := TSkinPoint.Create;
  FGradientType := 'horizontal';
  FBlend := false;
  FBlendColor := 0;
  FBlendColorString := '$000000';
  FBlendAlpha := 255;
  FBitmapId := -1;
  FBmpList := BmpList;
  FDrawMode := sdmStretch;
  FMasterAlphaString := '255';
  FMasterAlpha := 255;
  FLayerMode := TLayerMode(0);
  FEnabled := True;
  FEnabledString := '1';
  FID := '';
end;

destructor TSkinPart.Destroy;
begin
  if (parentlist <> nil) then
    parentlist.Remove(self);
  FMasterAlpha := 0;
  FBlendAlpha := 0;
  FBitmapId := -1;
  FDrawMode := sdmTile;
  FItems.Free;
  FSkinDim.Free;
  FSkinText.Free;
  FGradientColor.Free;
  FGradientColorS.Free;
  FGradientAlpha.Free;
  inherited Destroy;
end;

function TSkinPart.GetBitmap: TBitmap32;
begin
  if (FBitmapId >= 0) then
  begin
    result := TSkinBitmap(FBmpList.Items[FBitmapId]).Bitmap;
  end
  else
    result := nil;
end;

//**********************************
//* TSkinIcon
//**********************************

procedure TSkinIcon.Clear;
begin
  Inherited Clear;
  FDrawIcon := True;
end;

procedure TSkinIcon.Assign(Value: TSkinIcon);
begin
  inherited Assign(Value as TSkinDim);
  FDrawIcon := Value.DrawIcon;
end;

procedure TSkinIcon.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  StringSaveToStream(BoolToStr(FDrawIcon),Stream);
end;

procedure TSkinIcon.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  FDrawIcon := StrToBool(StringLoadFromStream(Stream));
end;

procedure TSkinIcon.LoadFromXML(xml: TJvSimpleXMLElem);
begin
  with xml.Items do
  begin
    if ItemNamed['dimension'] <> nil then
       SetDimension(Value('dimension', 'w,h'));
    if ItemNamed['location'] <> nil then
       SetLocation(Value('location','0,0'));
    if ItemNamed['drawicon'] <> nil then
       FDrawIcon := BoolValue('drawicon',true);
  end;
end;

//**********************************
//* TSkinPartEX
//**********************************

constructor TSkinPartEx.Create(BmpList: TSkinBitmapList);
begin
  inherited Create(BmpList);
  FSkinIcon := TSkinIcon.Create;
  FWidthMod := 0;
end;

destructor TSkinPartEx.Destroy;
begin
  FSkinIcon.Free;
  inherited Destroy;
end;

procedure TSkinPartEx.Assign(Value : TSkinPartEx);
begin
  inherited Assign(Value as TSkinPart);
  FSkinIcon.Assign(Value.SkinIcon);
  FWidthMod := Value.WidthMod;
end;

procedure TSkinPartEx.Clear;
begin
  inherited Clear;
  FSkinIcon.Clear;
  FWidthMod := 0;
end;

procedure TSkinPartEx.SaveToStream(Stream: TStream);
begin
  inherited SaveToStream(Stream);
  FSkinIcon.SaveToStream(Stream);
  Stream.WriteBuffer(FWidthMod, sizeof(FWidthMod));
end;

procedure TSkinPartEx.LoadFromStream(Stream: TStream);
begin
  inherited LoadFromStream(Stream);
  FSkinIcon.LoadFromStream(Stream);
  Stream.ReadBuffer(FWidthMod, sizeof(FWidthMod));
end;

function TSkinPartEx.LoadFromXML(xml: TJvSimpleXMLElem; path: string;
                                 Text: TSkinText; Icon : TSkinIcon): boolean;
begin
  result := inherited LoadFromXML(xml,path,Text);

  if Icon <> nil then
     FSkinIcon.Assign(Icon);
  with xml.items do
  begin
    if ItemNamed['WidthMod'] <> nil then
       FWidthMod := IntValue('WidthMod',0);
    if ItemNamed['icon'] <> nil then
       FSkinIcon.LoadFromXML(ItemNamed['icon']);
  end;
end;

//**********************************
//* Other
//**********************************

procedure TSkinPart.TileDraw(Src,Dest : TBitmap32; DestRect : TRect);
var
  w,h,nx,ny,x,y : integer;
  temp : TBitmap32;
begin
  Src.DrawMode := dmBlend;
  Src.CombineMode := cmMerge;

  temp := TBitmap32.Create;
  try
    w := abs(DestRect.Right-DestRect.Left);
    h := abs(DestRect.Bottom-DestRect.Top);
    temp.SetSize(w,h);
    temp.Clear(color32(0,0,0,0));
    nx := round(Int(w / Src.Width));
    ny := round(Int(h / Src.Height));

    for y := 0 to ny do  
       for x := 0 to nx do  
           Src.DrawTo(temp,x*Src.Width,y*Src.Height);  
 
   temp.DrawMode := dmCustom;  
   temp.OnPixelCombine := DoCombine;  
 
   Case FLayerMode of  
     lmBlend: begin  
       temp.OnPixelCombine := nil;  
       temp.DrawMode := dmBlend;  
     end;  
     lmAdd: temp.OnPixelCombine := nil;  
   end;  
 
   temp.CombineMode := cmMerge;  
   temp.DrawTo(Dest,DestRect.Left,DestRect.Top);

  finally
    temp.free;
  end;
end;

function EvaluateValue(str: string; cs: TSharpEScheme) : integer;
var
  n : integer;
  tmp: string;
  sub: boolean;
  k : integer;
begin
  if length(str) = 0 then
  begin
    result := 0;
    exit;
  end;

  for n := 0 to High(cs.Colors) do
      str := StringReplace(str,cs.Colors[n].Tag,inttostr(cs.Colors[n].Color),[rfReplaceAll,rfIgnoreCase]);

  result := 0;
  tmp := '';
  sub := false;
  n := 0;
  while n <= length(str) do
  begin
    inc(n);
    if (str[n] >= '0') and (str[n] <= '9') then
      tmp := tmp + str[n]
    else
    begin
      if (tmp <> '') then
      begin
        if (sub) then
        begin
          if trystrtoint(tmp,k) then result := result - k
        end else
        begin
          if trystrtoint(tmp,k) then result := result + k;
        end;
      end;
      if (str[n] = '+') then
          sub := false
          else if (str[n] = '-') then
                  sub := true;
      tmp := '';
    end;
  end;
  if (tmp <> '') then
  begin
    if (sub) then
    begin
      if trystrtoint(tmp,k) then result := result - k
    end else
    begin
      if trystrtoint(tmp,k) then result := result + k;
    end;
  end;
end;

function SchemedStringToColor(str: string; cs: TSharpEScheme): TColor;
var
  n : integer;
begin
  n := cs.GetColorIndexByTag(str);
  if n <> -1 then result := cs.GetColorByTag(str)
  else result := SharpThemeApi.ParseColor(PChar(str));
end;

function get_location(str: string): TRect;
var i, j: integer;
  temp: string;
  a: array[0..3] of integer;
begin
  temp := '';
  j := 0;
  for i := 1 to length(str) do
  begin
    if str[i] = ',' then
    begin
      a[j] := strtoint(temp);
      inc(j);
      temp := '';
    end
    else
      if str[i] = '+' then
      begin
      end
      else
        temp := temp + str[i];
  end;
  a[j] := strtoint(temp);
  result := rect(a[0], a[1], a[2], a[3]);
end;

function Lighter(Color: TColor; Percent: Byte): TColor;
var
  r, g, b: Byte;
  r2, g2, b2: Byte;

begin
  Color := ColorToRGB(Color);
  r := GetRValue(Color);
  g := GetGValue(Color);
  b := GetBValue(Color);
  r2 := r + muldiv(255 - r, Percent, 100);
  if r2 < r then
    r2 := 255;
  g2 := g + muldiv(255 - g, Percent, 100);
  if g2 < g then
    g2 := 255;
  b2 := b + muldiv(255 - b, Percent, 100);
  if b2 < b then
    b2 := 255;
  result := RGB(r2, g2, b2);
end;

function Darker(Color: TColor; Percent: Byte): TColor;
var
  r, g, b: Byte;
  r2, g2, b2: Byte;
begin
  Color := ColorToRGB(Color);
  r := GetRValue(Color);
  g := GetGValue(Color);
  b := GetBValue(Color);
  r2 := r - muldiv(r, Percent, 128);
  if r2 > r then
    r2 := 0;
  g2 := g - muldiv(g, Percent, 128);
  if g2 > g then
    g2 := 0;
  b2 := b - muldiv(b, Percent, 128);
  if b2 > b then
    b2 := 0;
  result := RGB(r2, g2, b2);
end;

procedure doBlend(Dest: TBitmap32; source: TBitmap32; color: TColor);
var
  P: PColor32;
  X, Y, res: integer;
  red, alpha: byte;
  c: TColor;
begin
  //Dest.assign(source);
  Dest.SetSize(source.Width, source.Height);
  Source.DrawTo(Dest);
  Dest.Font.Name := Source.Font.Name;
  Dest.Font.Size := Source.Font.Size;
  Dest.Font.Style := Source.Font.Style;
  Dest.Font.Color := Source.Font.Color;
  Dest.DrawMode := Source.DrawMode;
  Dest.CombineMode := Source.CombineMode;
  with Dest do
  begin
    P := PixelPtr[0, 0];
    for Y := 0 to Height - 1 do
    begin
      for X := 0 to Width - 1 do
      begin
        alpha := (P^ shr 24);
        red := (P^ and $00FF0000) shr 16;
        res := red - 128;
        if (res < 0) then
          c := Darker(color, -res)
        else
          if (res > 0) then
            c := Lighter(color, res)
          else
            c := color;
        P^ := color32(GetRValue(c), GetGValue(c), GetBValue(c), alpha);
        inc(P); // proceed to the next pixel
      end;
    end;
  end;
end;

procedure VGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
var
   nR,nG,nB,nt : real;
   sR,sG,sB : integer;
   eR,eG,eB : integer;
   y : integer;
begin
  if color1 <> -1 then
  begin
    sR := GetRValue(color1);
    sG := GetGValue(color1);
    sB := GetBValue(color1);
  end else
  begin
    sR := 0;
    sG := 0;
    sB := 0;
  end;

  if color2 <> -1 then
  begin
    eR := GetRValue(color2);
    eG := GetGValue(color2);
    eB := GetBValue(color2);
  end else
  begin
    eR := 0;
    eG := 0;
    eB := 0;
  end;
  
  nR:=(eR-sR)/(Rect.Bottom-Rect.Top);
  nG:=(eG-sG)/(Rect.Bottom-Rect.Top);
  nB:=(eB-sB)/(Rect.Bottom-Rect.Top);
  nt:=(et-st)/(Rect.Bottom-Rect.Top);
  for y:=0 to Rect.Bottom-Rect.Top do
      Bmp.HorzLineT(Rect.Left,y+Rect.Top,Rect.Right,
                    color32(sr+round(nr*y),sg+round(ng*y),sb+round(nb*y),st+round(nt*y)));
end;


// ######################################


procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
var
  nR,nG,nB,nt : real;
  sR,sG,sB : integer;
  eR,eG,eB : integer;
  x : integer;
begin
  sR := GetRValue(color1);
  sG := GetGValue(color1);
  sB := GetBValue(color1);
  eR := GetRValue(color2);
  eG := GetGValue(color2);
  eB := GetBValue(color2);
  nR:=(eR-sR)/(Rect.Right-Rect.Left);
  nG:=(eG-sG)/(Rect.Right-Rect.Left);
  nB:=(eB-sB)/(Rect.Right-Rect.Left);
  nt:=(et-st)/(Rect.Right-Rect.Left);
  for x:=0 to Rect.Right-Rect.Left do
      Bmp.VertLineT(x+Rect.Left,Rect.Top,Rect.Bottom,
                    color32(sr+round(nr*x),sg+round(ng*x),sb+round(nb*x),st+round(nt*x)));
end;

procedure TSkinPart.DoCombine(F: TColor32; var B: TColor32; M: TColor32);
begin
  Case FLayerMode of
    lmSubtract: B := ColorSub (F, B);
    lmModule: B := ColorModulate(F, B);
    lmMin: B := ColorMin(F, B);
    lmMax: B := ColorMax(F, B);
    lmDifference: B := ColorDifference(F, B);
    lmExclusion:  B := ColorExclusion(F, B);
  End;
end;

end.
