{
Source Name: SharpESkinPart.pas
Description: Skin Part classes
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

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
  GR32_LowLevel,
  SharpTypes,
  Sharpapi,
  SharpGraphicsUtils,
  ISharpESkinComponents;

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

  // Never directly free a TSkinIcon class directly if OwnsInterface is set to true,
  // it's creating an interface to itself to fool the garbage collector.
  // In order to release it set the SelfInterface property to nil
  // Example:
  //   Text := TSkinIcon.Create;
  //   [...]
  //   Text.SelfInterface := nil;
  //   Text := nil;  
  TSkinIcon = class(TInterfacedObject, ISharpESkinIcon)
  private
    FInterface : ISharpESkinIcon;
    FDrawIcon : boolean;
    FSize : TSkinPoint;
    FPosition : TSkinPoint;
    FLighten : Boolean;
    FLightenAmount : Integer;
    FBlend : Boolean;
    FBlendColor : integer;
    FBlendColorStr : String;
    FBlendAlpha : Byte;
    procedure SetDrawIcon(Value : Boolean); stdcall;    
    function GetDrawIcon : Boolean; stdcall;
    function GetDimension : TPoint; stdcall;
  public
    constructor Create(OwnsInterface : Boolean); reintroduce;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Value: TSkinIcon);
    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromXML(xml: TJvSimpleXMLElem);
    procedure RenderTo(Dst,Src : TBitmap32; x,y : integer);
    function GetXY(TextRect: TRect; CompRect: TRect): TPoint; stdcall;
    procedure UpdateDynamicProperties(cs: ISharpEScheme);
    property Size : TSkinPoint read FSize;
    property Lighten : Boolean read FLighten write FLighten;
    property LightenAmount : integer read FLightenAmount write FLightenAmount;
    property Blend : Boolean read FBlend write FBlend;
    property BlendColor : integer read FBlendColor write FBlendColor;
    property BlendColorStr : String read FBlendColorStr write FBlendColorStr;
    property BlendAlpha : Byte read FBlendAlpha write FBlendAlpha;
    property SelfInterface : ISharpESkinIcon read FInterface write FInterface;

    procedure DrawTo(Dst,Src : TBitmap32; x,y : integer); stdcall;
    property DrawIcon : Boolean read GetDrawIcon write SetDrawIcon;
    property Dimension : TPoint read GetDimension;
  end;

  // Never directly free a TSkinText class directly if OwnsInterface is set to true,
  // it's creating an interface to itself to fool the garbage collector.
  // In order to release it set the SelfInterface property to nil
  // Example:
  //   Text := TSkinText.Create;
  //   [...]
  //   Text.SelfInterface := nil;
  //   Text := nil;
  TSkinText = class(TInterfacedObject, ISharpESkinText)
  private
    FInterface : ISharpESkinText;
    FX: string;
    FY: string;
    FWidth: string;
    FHeight: string;
    FName: string;
    FColor: integer;
    FColorString: String;
    FSize: integer;
    FAlpha: byte;
    FAlphaString: String;
    FStyleBold : boolean;
    FStyleItalic : boolean;
    FStyleUnderline : boolean;
    FShadow : boolean;
    FShadowColor : integer;
    FShadowColorString : String;
    FShadowType : TSharpESkinShadowType;
    FShadowAlpha : byte;
    FDrawText : boolean;
    FClearType : boolean;

    function GetX : String; stdcall;
    function GetY : String; stdcall;
    function GetWidth : String; stdcall;
    function GetHeight : String; stdcall;
    function GetName : String; stdcall;
    function GetColor : integer; stdcall;
    function GetColorString : String; stdcall;
    function GetAlpha : byte; stdcall;
    function GetAlphaString : String; stdcall;
    function GetShadow : boolean; stdcall;
    function GetSize : integer; stdcall;
    function GetShadowColor : integer; stdcall;
    function GetShadowColorString : String; stdcall;
    function GetShadowAlpha : byte; stdcall;
    function GetShadowType : TSharpESkinShadowType; stdcall;
    function GetDrawText : boolean; stdcall;
    function GetClearType : boolean; stdcall;
    function GetStyleBold : Boolean; stdcall;
    function GetStyleUnderline : Boolean; stdcall;
    function GetStyleItalic : Boolean; stdcall;    

    procedure SetX(Value : String); stdcall;
    procedure SetY(Value : String); stdcall;
    procedure SetWidth(Value : String); stdcall;
    procedure SetHeight(Value : String); stdcall;
    procedure SetName(Value : String); stdcall;
    procedure SetColor(Value : integer); stdcall;
    procedure SetColorString(Value : String); stdcall;
    procedure SetAlpha(Value : byte); stdcall;
    procedure SetAlphaString(Value : String); stdcall;
    procedure SetShadow(Value : boolean); stdcall;
    procedure SetSize(Value : integer); stdcall;
    procedure SetShadowColor(Value : integer); stdcall;
    procedure SetShadowColorString(Value : String); stdcall;
    procedure SetShadowAlpha(Value : byte); stdcall;
    procedure SetShadowType(Value : TSharpESkinShadowType); stdcall;
    procedure SetDrawText(Value : boolean); stdcall;
    procedure SetClearType(Value : boolean); stdcall;
    procedure SetStyleBold(Value : Boolean); stdcall;
    procedure SetStyleUnderline(Value : Boolean); stdcall;
    procedure SetStyleItalic(Value : Boolean); stdcall;       
  public
    constructor Create(OwnsInterface : boolean); reintroduce;
    destructor Destroy; override;
    procedure Clear;
    procedure Assign(Value: ISharpESkinText); overload; stdcall;
    procedure Assign(Value: TSkinTextRecord); overload;
    procedure SetLocation(x, y: string); overload;
    procedure SetLocation(str: string); overload;
    procedure SetDimension(width, height : String); overload;
    procedure SetDimension(str : string); overload;

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    function CreateThemedSkinText : ISharpESkinText; stdcall;

    procedure UpdateDynamicProperties(cs: ISharpEScheme); stdcall;

    procedure LoadFromXML(xml: TJvSimpleXMLElem);
    function GetXY(TextRect,CompRect,IconRect: TRect): TPoint; stdcall;
    function GetDim(CompRect: TRect): TPoint; stdcall;
    function GetFont(cs: ISharpEScheme): TFont;
    procedure AssignFontTo(pFont : TFont; cs: ISharpEScheme); stdcall;
    procedure RenderToW(Bmp : TBitmap32; X,Y : integer; Caption : WideString; cs : ISharpEScheme;
                        var pPrecacheText : ISharpESkinText; var pPrecacheBmp : TBitmap32; var pPrecacheCaption : WideString); overload; stdcall;
    procedure RenderToW(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : ISharpEScheme); overload; stdcall;
    procedure RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : ISharpEScheme;
                       var pPrecacheText : ISharpESkinText; var pPrecacheBmp : TBitmap32; var pPrecacheCaption : String); overload; stdcall;
    procedure RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : ISharpEScheme); overload; stdcall;

    property X : String read GetX write SetX;
    property Y : String read GetY write SetY;
    property Width : String read GetWidth write SetWidth;
    property Height : String read GetHeight write SetHeight;
    property Name : String read GetName write SetName;
    property Color : integer read GetColor write SetColor;
    property ColorString : String read GetColorString write SetColorString;
    property Alpha : byte read GetAlpha write SetAlpha;
    property AlphaString : string read GetAlphaString write SetAlphaString;
    property Shadow : boolean read GetShadow write SetShadow;
    property Size : integer read GetSize write SetSize;
    property ShadowColor : integer read GetShadowColor write SetShadowColor;
    property ShadowColorString : String read GetShadowColorString write SetShadowColorString;
    property ShadowAlpha : byte read GetShadowAlpha write SetShadowAlpha;
    property ShadowType : TSharpESkinShadowType read GetShadowType write SetShadowType;
    property DrawText : boolean read GetDrawText write SetDrawText;
    property ClearType : boolean read GetClearType write SetClearType;
    property StyleBold : boolean read GetStyleBold write SetStyleBold;
    property StyleUnderline : boolean read GetStyleUnderline write SetStyleUnderline;
    property StyleItalic : boolean read GetStyleItalic write SetStyleItalic;
    property SelfInterface : ISharpESkinText read FInterface write FInterface;
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

  TSkinPart = class(TInterfacedObject, ISharpESkinPart)
  private //for linked list
    next, prev: TSkinPart;
    parentlist: TSkinPartList;
    FLayerMode: TLayerMode;

  private
    FIsEmpty: Boolean;
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
    function GetDimRect(ps: TRect): TRect; stdcall;
    function GetEmpty : Boolean; stdcall;
    function GetDimension : TPoint; stdcall;
    function GetDrawText : Boolean; stdcall;
  public
    constructor Create(BmpList: TSkinBitmapList); virtual;
    destructor Destroy; override;
    procedure Assign(Value: TSkinPart); virtual;
    procedure Clear; virtual;

    procedure SaveToStream(Stream: TStream);  virtual;
    procedure LoadFromStream(Stream: TStream); virtual;

    function CreateThemedSkinText : ISharpESkinText; stdcall;    
    procedure UpdateDynamicProperties(cs: ISharpEScheme); virtual;

    function LoadFromXML(xml: TJvSimpleXMLElem; path: string; Text: TSkinText): boolean; virtual;
    procedure draw(bmp: TBitmap32; cs: ISharpEScheme);
    function GetBitmap: TBitmap32;

    property IsEmpty: Boolean read FIsEmpty write FIsEmpty;
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

    // ISharpESkinPart Interface
    procedure DrawTo(Bmp: TBitmap32; Scheme: ISharpEScheme); stdcall;
    procedure ExecuteScript(pComponent : TObject;
                           pScript : String;
                           pScheme : ISharpEScheme;
                           pAnimTimerCallback : ISharpESkinAnimTimerCallback); stdcall;
    property Empty : Boolean read GetEmpty;
    property Dimension : TPoint read GetDimension;
    property DrawText : Boolean read GetDrawText;
  end;

  // TSkinPart with Icon!
  TSkinPartEx = class(TSkinPart, ISharpESkinPartEx)
  private
    FSkinIcon : TSkinIcon;
    FWidthMod : integer;
    function GetIcon : ISharpESkinIcon; stdcall;
    function GetWidthMod : integer; stdcall;
  public
    constructor Create(BmpList: TSkinBitmapList); override;
    destructor Destroy; override;
    procedure Clear; override;
    procedure UpdateDynamicProperties(cs: ISharpEScheme); override;
    procedure Assign(Value: TSkinPartEx); reintroduce;
    procedure SaveToStream(Stream: TStream); override;
    procedure LoadFromStream(Stream: TStream); override;
    function LoadFromXML(xml: TJvSimpleXMLElem; path: string;
                         Text: TSkinText; Icon : TSkinIcon): boolean; reintroduce;

    property SkinIcon : TSkinIcon read FSkinIcon;

    property WidthMod : integer read GetWidthMod;
    property Icon : ISharpESkinIcon read GetIcon;
  end;

function get_location(str: string): TRect;
function ParseColor(src : String; cs : ISharpEScheme) : integer;
function EvaluateValue(str: string; cs: ISharpEScheme) : integer;
procedure EvaluateColor(src: string; out color : String; out modvalue : integer);
function SchemedStringToColor(str: string; cs: ISharpEScheme): TColor;
procedure doBlend(Dest: TBitmap32; source: TBitmap32; color: TColor);
procedure VGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
function ParseCoordinate(s: string; tw, th, cw, ch, iw, ih: integer): integer;
function LightenRGB(src : integer; amount : integer) : integer;

var
  SharpESkinTextBarBottom : boolean;

implementation

uses Sysutils,
     SharpEDefault,
     gr32_png,
     SharpEAnimationTimers,
     SharpThemeApiEx,
     uThemeConsts,
     uISharpETheme;

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

  result.X := ParseCoordinate(FX, tw, th, cw, ch, 0, 0);
  result.Y := ParseCoordinate(FY, tw, th, cw, ch, 0, 0);
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
    if (ord(s[i]) >= 48) and (ord(s[i]) <= 57) then
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

constructor TSkinText.Create(OwnsInterface : boolean);
begin
  inherited Create;

  if OwnsInterface then 
    FInterface := self
  else FInterface := nil;
  
  Clear;
end;

function TSkinText.CreateThemedSkinText : ISharpESkinText;
var
  Theme : ISharpETheme;
begin
  result := TSkinText.Create(False);
  result.Assign(self);

  Theme := GetCurrentTheme;
  with Theme.Skin.SkinFont do
  begin
    if ModSize then
      result.Size := result.Size + ValueSize;
    if ModName then
      result.Name := ValueName;
    if ModAlpha then
      result.Alpha := Max(0,Min(255,result.Alpha + ValueAlpha));
    if ModUseShadow then
      result.Shadow := ValueUseShadow;
    if ModShadowType then
      result.ShadowType := TSharpESkinShadowType(ValueShadowType);
    if ModShadowAlpha then
      result.ShadowAlpha := Max(0,Min(255,result.ShadowAlpha + ValueShadowAlpha));
    if ModBold then
      result.StyleBold := ValueBold;
    if ModItalic then
      result.StyleItalic := ValueItalic;
    if ModUnderline then
      result.StyleUnderline := ValueUnderline;
    if ModClearType then
      result.ClearType := ValueClearType;
  end;

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
  FWidth := 'w';
  FHeight := 'h';
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
  FName := 'Small Fonts';
  FSize := 7;
  FColorString := '0';
  FColor := 0;
end;

procedure TSkinText.SaveToStream(Stream: TStream);
begin
  StringSaveToStream(FX, Stream);
  StringSaveToStream(FY, Stream);
  StringSaveToStream(FWidth,Stream);
  StringSaveToStream(FHeight,Stream);
  StringSaveToStream(FName, Stream);
  StringSaveToStream(FColorString, Stream);
  StringSaveToStream(BoolToStr(FStyleBold),Stream);
  StringSaveToStream(BoolToStr(FStyleItalic),Stream);
  StringSaveToStream(BoolToStr(FStyleUnderline),Stream);
  StringSaveToStream(BoolToStr(FDrawText),Stream);
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
  StringSaveToStream(BoolToStr(FClearType),Stream);
end;

procedure TSkinText.LoadFromStream(Stream: TStream);
var
  s : string;
begin
  FX := StringLoadFromStream(Stream);
  FY := StringLoadFromStream(Stream);
  FWidth := StringLoadFromStream(Stream);
  FHeight := StringLoadFromStream(Stream);
  FName := StringLoadFromStream(Stream);
  FColorString := StringLoadFromStream(Stream);
  FStyleBold := StrToBool(StringLoadFromStream(Stream));
  FStyleItalic := StrToBool(StringLoadfromStream(Stream));
  FStyleUnderline := StrToBool(StringLoadFromStream(Stream));
  FDrawText := StrToBool(StringLoadFromStream(Stream));
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
  FClearType := StrToBool(StringLoadFromStream(Stream));
end;

procedure TSkinText.Assign(Value: ISharpESkinText);
begin
  X := Value.X;
  Y := Value.Y;
  Width := Value.Width;
  Height := Value.Height;
  Name := Value.Name;
  Color := Value.Color;
  ColorString := Value.ColorString;
  Size := Value.Size;
  StyleBold := Value.StyleBold;
  StyleItalic := Value.StyleItalic;
  StyleUnderline := Value.StyleUnderline;
  Shadow := Value.Shadow;
  ShadowColor := Value.ShadowColor;
  ShadowColorString := Value.ShadowColorString;
  ShadowAlpha := Value.ShadowAlpha;
  ShadowType := Value.ShadowType;
  Alpha := Value.Alpha;
  AlphaString := Value.AlphaString;
  DrawText := Value.DrawText;
  ClearType := Value.ClearType;
end;

procedure TSkinText.Assign(Value: TSkinTextRecord);
begin
  FName := Value.FName;
  FColorString := Value.FColor;
  FSize := Value.FSize;
end;

procedure TSkinText.SetDimension(width, height: String);
begin
  FWidth := width;
  FHeight := height;
end;

procedure TSkinText.SetAlpha(Value: byte);
begin
  FAlpha := Value;
end;

procedure TSkinText.SetAlphaString(Value: String);
begin
  FAlphaString := Value;
end;

procedure TSkinText.SetClearType(Value: boolean);
begin
  FClearType := Value;
end;

procedure TSkinText.SetColor(Value: integer);
begin
  FColor := Value;
end;

procedure TSkinText.SetColorString(Value: String);
begin
  FColorString := Value;
end;

procedure TSkinText.SetDimension(str: string);
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

procedure TSkinText.SetDrawText(Value: boolean);
begin
  FDrawText := Value;
end;

procedure TSkinText.SetHeight(Value: String);
begin
  FHeight := Value;
end;

procedure TSkinText.SetLocation(x, y: string);
begin
  FX := x;
  FY := y;
end;

procedure TSkinText.AssignFontTo(pFont : TFont; cs: ISharpEScheme);
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

function TSkinText.GetFont(cs: ISharpEScheme): TFont;
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

function TSkinText.GetHeight: String;
begin
  result := FHeight;
end;

function TSkinText.GetName: String;
begin
  result := FName;
end;

function TSkinText.GetShadow: boolean;
begin
  result := FShadow;
end;

function TSkinText.GetShadowAlpha: byte;
begin
  result := FShadowAlpha;
end;

function TSkinText.GetShadowColor: integer;
begin
  result := FShadowColor;
end;

function TSkinText.GetShadowColorString: String;
begin
  result := FShadowColorString;
end;

function TSkinText.GetShadowType: TSharpESkinShadowType;
begin
  result := FShadowType;
end;

function TSkinText.GetSize: integer;
begin
  result := FSize;
end;

function TSkinText.GetStyleBold: Boolean;
begin
  result := FStyleBold;
end;

function TSkinText.GetStyleItalic: Boolean;
begin
  result := FStyleItalic;
end;

function TSkinText.GetStyleUnderline: Boolean;
begin
  result := FStyleUnderline;
end;

function TSkinText.GetWidth: String;
begin
  result := FWidth;
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

procedure TSkinText.SetName(Value: String);
begin
  FName := Value;
end;

procedure TSkinText.SetShadow(Value: boolean);
begin
  FShadow := Value;
end;

procedure TSkinText.SetShadowAlpha(Value: byte);
begin
  FShadowAlpha := Value;
end;

procedure TSkinText.SetShadowColor(Value: integer);
begin
  FShadowColor := Value;
end;

procedure TSkinText.SetShadowColorString(Value: String);
begin
  FShadowColorString := Value;
end;

procedure TSkinText.SetShadowType(Value: TSharpESkinShadowType);
begin
  FShadowType := Value;
end;

procedure TSkinText.SetSize(Value: integer);
begin
  FSize := Value;
end;

procedure TSkinText.SetStyleBold(Value: Boolean);
begin
  FStyleBold := Value;
end;

procedure TSkinText.SetStyleItalic(Value: Boolean);
begin
  FStyleItalic := Value;
end;

procedure TSkinText.SetStyleUnderline(Value: Boolean);
begin
  FStyleUnderline := Value;
end;

procedure TSkinText.SetWidth(Value: String);
begin
  FWidth := Value;
end;

procedure TSkinText.SetX(Value: String);
begin
  FX := Value;
end;

procedure TSkinText.SetY(Value: String);
begin
  FY := Value;
end;

procedure TSkinText.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FAlpha := Min(255,Max(0,EvaluateValue(FAlphaString,cs)));
  FShadowColor := ParseColor(FShadowColorString,cs);
  FColor       := ParseColor(FColorString,cs);
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
    if ItemNamed['dimension'] <> nil then
      SetDimension(Value('dimension'),'w,h');
    
    if ItemNamed['width'] <> nil then
      FWidth := Value('width','w');
    if ItemNamed['height'] <> nil then
      FHeight := Value('height','h');
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
    if ItemNamed['draw'] <> nil then
      FDrawText := BoolValue('draw',true);
    if ItemNamed['cleartype'] <> nil then
      FClearType := BoolValue('cleartype',false);
  end;
end;

function TSkinText.GetAlpha: byte;
begin
  result := FAlpha;
end;

function TSkinText.GetAlphaString: String;
begin
  result := FAlphaString;
end;

function TSkinText.GetClearType: boolean;
begin
  result := FClearType;
end;

function TSkinText.GetColor: integer;
begin
  result := FColor;
end;

function TSkinText.GetColorString: String;
begin
  result := FColorString;
end;

function TSkinText.GetDim(CompRect: TRect) : TPoint;
var
  cw, ch : integer;
begin
  cw := CompRect.Right - CompRect.Left;
  ch := CompRect.Bottom - CompRect.Top;
  result.x := ParseCoordinate(FWidth,cw,ch,cw,ch,0,0);
  result.y := ParseCoordinate(FHeight,cw,ch,cw,ch,0,0);
end;

function TSkinText.GetDrawText: boolean;
begin
  result := FDrawText;
end;

function TSkinText.GetX: String;
begin
  result := FX;
end;

function TSkinText.GetXY(TextRect,CompRect,IconRect: Trect): TPoint;
var
  cw, ch: integer;
  tw, th: integer;
  iw, ih: integer;
begin
  cw := CompRect.Right - CompRect.Left;
  ch := CompRect.Bottom - CompRect.Top;
  tw := TextRect.Right - TextRect.Left;
  th := TextRect.Bottom - TextRect.Top;
  iw := IconRect.Right - IconRect.Left;
  ih := IconRect.Bottom - IconRect.Top;

  result.X := ParseCoordinate(FX, tw, th, cw, ch, iw, ih);
  result.Y := ParseCoordinate(FY, tw, th, cw, ch, iw, ih);
end;


function TSkinText.GetY: String;
begin
  result := FY;
end;

procedure TSkinText.RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String;  cs : ISharpEScheme);
var
  c : TColor;
  R,G,B : byte;
  c2 : TColor32;
  ShadowBmp : TBitmap32;
  TempBmp : TBitmap32;
  w,h : integer;
  aalevel : integer;
begin
  TempBmp := TBitmap32.Create;
  w := Bmp.TextWidth(Caption);
  h := Bmp.TextHeight(Caption);
  TempBmp.SetSize(w+20,h+20);
  TempBmp.Clear(color32(0,0,0,0));
  TempBmp.Font.Assign(bmp.Font);
  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

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
          fastblur(ShadowBmp,1,1);
          ShadowBmp.RenderText(TempBmp.Width div 2 - w div 2,
                               TempBmp.Height div 2 - h div 2,Caption,0,c2);
        end;
      end;
      fastblur(ShadowBmp,1,1);
      ShadowBmp.DrawTo(TempBmp,0,0);
      ShadowBmp.DrawTo(TempBmp,0,0);
      fastblur(ShadowBmp,1,1);
      ShadowBmp.DrawTo(TempBmp,0,0);
      ShadowBmp.DrawTo(TempBmp,0,0);
      BlendImageA(TempBmp,FShadowColor,255);
    finally
      ShadowBmp.Free;
    end;
  end;
  c := FColor;
  R := GetRValue(c);
  G := GetGValue(c);
  B := GetBValue(c);
  c2 := color32(R,G,B,255);
  if FClearType then
    aalevel := -2
  else aalevel := 0;
  TempBmp.RenderText(TempBmp.Width div 2 - w div 2,TempBmp.Height div 2 - h div 2,Caption,aalevel,c2);
  TempBmp.MasterAlpha := FAlpha;
  TempBmp.DrawTo(Bmp,X-10,Y-10);

  FreeAndNil(TempBmp);
end;

procedure TSkinText.RenderToW(Bmp: TBitmap32; X, Y: integer; Caption: String;
  cs: ISharpEScheme);
var
  c : TColor;
  R,G,B : byte;
  c2 : TColor32;
  ShadowBmp : TBitmap32;
  TempBmp : TBitmap32;
  w,h : integer;
  aalevel : integer;
begin
  TempBmp := TBitmap32.Create;
  w := Bmp.TextWidthW(Caption);
  h := Bmp.TextHeightW(Caption);
  TempBmp.SetSize(w+20,h+20);
  TempBmp.Clear(color32(0,0,0,0));
  TempBmp.Font.Assign(bmp.Font);
  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

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
        stLeft    : ShadowBmp.RenderTextW(TempBmp.Width div 2 - w div 2 - 1,
                                         TempBmp.Height div 2 - h div 2 + 1,Caption,0,c2);
        stRight   : ShadowBmp.RenderTextW(TempBmp.Width div 2 - w div 2 + 1,
                                         TempBmp.Height div 2 - h div 2 + 1,Caption,0,c2);
        stOutline :
        begin
          ShadowBmp.RenderTextW(TempBmp.Width div 2 - w div 2,
                               TempBmp.Height div 2 - h div 2,Caption,0,c2);
          fastblur(ShadowBmp,1,1);
          ShadowBmp.RenderTextW(TempBmp.Width div 2 - w div 2,
                               TempBmp.Height div 2 - h div 2,Caption,0,c2);
        end;
      end;
      fastblur(ShadowBmp,1,1);
      ShadowBmp.DrawTo(TempBmp,0,0);
      ShadowBmp.DrawTo(TempBmp,0,0);
      fastblur(ShadowBmp,1,1);
      ShadowBmp.DrawTo(TempBmp,0,0);
      ShadowBmp.DrawTo(TempBmp,0,0);
      BlendImageA(TempBmp,FShadowColor,255);
    finally
      ShadowBmp.Free;
    end;
  end;
  c := FColor;
  R := GetRValue(c);
  G := GetGValue(c);
  B := GetBValue(c);
  c2 := color32(R,G,B,255);
  if FClearType then
    aalevel := -2
  else aalevel := 0;
  TempBmp.RenderTextW(TempBmp.Width div 2 - w div 2,TempBmp.Height div 2 - h div 2,Caption,aalevel,c2);
  TempBmp.MasterAlpha := FAlpha;
  TempBmp.DrawTo(Bmp,X-10,Y-10);

  FreeAndNil(TempBmp);

end;

procedure TSkinText.RenderToW(Bmp: TBitmap32; X, Y: integer;
  Caption: WideString; cs: ISharpEScheme; var pPrecacheText: ISharpESkinText;
  var pPrecacheBmp: TBitmap32; var pPrecacheCaption: WideString);
var
  R,G,B : byte;
  c2 : TColor32;
  new : boolean;
  ShadowBmp : TBitmap32;
  w,h : integer;
  aalevel : integer;
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
      pPrecacheText := TSkinText.Create(False);
      pPrecacheText.ColorString := '-1';
      pPrecacheText.UpdateDynamicProperties(cs);
    end;
  end else new := False;


  // Check if something changed since cache bmp has been created.
  if ((CompareText(pPrecacheText.Name,FName) <> 0) or
//     (CompareText(pPrecacheText.FColor,FColor) <> 0) or
     (pPrecacheText.Color <> FColor) or
     (CompareText(pPrecacheText.Width,FWidth) <> 0) or
     (CompareText(pPrecacheText.Height,FHeight) <> 0) or
     (pPrecacheText.ShadowColor <> FShadowColor) or
     (pPrecacheText.Size <> FSize) or
     (pPrecacheText.StyleBold <> FStyleBold) or
     (pPrecacheText.StyleItalic <> FStyleItalic) or
     (pPrecacheText.StyleUnderline <> FStyleUnderline) or
     (pPrecacheText.Shadow <> FShadow) or
     (pPrecacheText.ShadowType <> FShadowType) or
     (pPrecacheText.ShadowAlpha <> FShadowAlpha) or
     (pPrecacheText.ClearType <> FClearType) or
     (CompareText(pPrecacheCaption,Caption) <> 0)) or (new) then
  begin
    // text settings or caption changed! redraw caption
    pPrecacheText.Assign(self);
    pPrecacheCaption := Caption;
    w := Bmp.TextWidthW(Caption);
    h := Bmp.TextHeightW(Caption);
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
          stLeft    : ShadowBmp.RenderTextW(pPrecacheBmp.Width div 2 - w div 2 - 1,
                                           pPrecacheBmp.Height div 2 - h div 2 + 1,Caption,0,c2);
          stRight   : ShadowBmp.RenderTextW(pPrecacheBmp.Width div 2 - w div 2 + 1,
                                           pPrecacheBmp.Height div 2 - h div 2 + 1,Caption,0,c2);
          stOutline :
          begin
            ShadowBmp.RenderTextW(pPrecacheBmp.Width div 2 - w div 2,
                                 pPrecacheBmp.Height div 2 - h div 2,Caption,0,c2);
            fastblur(ShadowBmp,1,1);
            ShadowBmp.RenderTextW(pPrecacheBmp.Width div 2 - w div 2,
                                 pPrecacheBmp.Height div 2 - h div 2,Caption,0,c2);
          end;
        end;
        fastblur(ShadowBmp,1,1);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        fastblur(ShadowBmp,1,1);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        BlendImageA(pPrecacheBmp,FShadowColor,255);
      finally
        ShadowBmp.Free;
      end;
    end;
    R := GetRValue(FColor);
    G := GetGValue(FColor);
    B := GetBValue(FColor);
    c2 := color32(R,G,B,255);
    if FClearType then
      aalevel := -2
    else aalevel := 0;
    pPrecacheBmp.RenderTextW(pPrecacheBmp.Width div 2 - w div 2,pPrecacheBmp.Height div 2 - h div 2,Caption,aalevel,c2);
  end;
  pPrecacheBmp.MasterAlpha := FAlpha;
  pPrecacheBmp.DrawTo(Bmp,X-10,Y-10);
end;


procedure TSkinText.RenderTo(Bmp : TBitmap32; X,Y : integer; Caption : String; cs : ISharpEScheme;
                             var pPrecacheText : ISharpESkinText; var pPrecacheBmp : TBitmap32; var pPrecacheCaption : String);
var
  R,G,B : byte;
  c2 : TColor32;
  new : boolean;
  ShadowBmp : TBitmap32;
  w,h : integer;
  aalevel : integer;
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
      pPrecacheText := TSkinText.Create(False);
      pPrecacheText.ColorString := '-1';
      pPrecacheText.UpdateDynamicProperties(cs);
    end;
  end else new := False;


  // Check if something changed since cache bmp has been created.
  if ((CompareText(pPrecacheText.Name,FName) <> 0) or
//     (CompareText(pPrecacheText.FColor,FColor) <> 0) or
     (pPrecacheText.Color <> FColor) or
     (CompareText(pPrecacheText.Width,FWidth) <> 0) or
     (CompareText(pPrecacheText.Height,FHeight) <> 0) or
     (pPrecacheText.ShadowColor <> FShadowColor) or
     (pPrecacheText.Size <> FSize) or
     (pPrecacheText.StyleBold <> FStyleBold) or
     (pPrecacheText.StyleItalic <> FStyleItalic) or
     (pPrecacheText.StyleUnderline <> FStyleUnderline) or
     (pPrecacheText.Shadow <> FShadow) or
     (pPrecacheText.ShadowType <> FShadowType) or
     (pPrecacheText.ShadowAlpha <> FShadowAlpha) or
     (pPrecacheText.ClearType <> FClearType) or
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
            fastblur(ShadowBmp,1,1);
            ShadowBmp.RenderText(pPrecacheBmp.Width div 2 - w div 2,
                                 pPrecacheBmp.Height div 2 - h div 2,Caption,0,c2);
          end;
        end;
        fastblur(ShadowBmp,1,1);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        fastblur(ShadowBmp,1,1);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        ShadowBmp.DrawTo(pPrecacheBmp,0,0);
        BlendImageA(pPrecacheBmp,FShadowColor,255);
      finally
        ShadowBmp.Free;
      end;
    end;
    R := GetRValue(FColor);
    G := GetGValue(FColor);
    B := GetBValue(FColor);
    c2 := color32(R,G,B,255);
    if FClearType then
      aalevel := -2
    else aalevel := 0;
    pPrecacheBmp.RenderText(pPrecacheBmp.Width div 2 - w div 2,pPrecacheBmp.Height div 2 - h div 2,Caption,aalevel,c2);
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

function TSkinPart.GetEmpty: boolean;
var test: boolean;
begin
  if (Bitmap <> nil) then
    test := Bitmap.Empty
  else
    test := true;
  result := (test and (FItems.Count = 0)) and (not IsEmpty);
end;

function TSkinPart.CreateThemedSkinText : ISharpESkinText;
begin
  result := FSkinText.CreateThemedSkinText;
end;

procedure TSkinPart.UpdateDynamicProperties(cs: ISharpEScheme);
var
  n : integer;
begin
  FBlendColor := ParseColor(FBlendColorString,cs);
  FGradientColor.FX := inttostr(ParseColor(FGradientColorS.X,cs));
  FGradientColor.FY := inttostr(ParseColor(FGradientColorS.Y,cs));
  FMasterAlpha := Min(255,Max(0,EvaluateValue(FMasterAlphaString,cs)));
  n := 1;
  if length(FEnabledString) > 0 then
    if CompareText('$IsBarBottom',FEnabledString) = 0 then
    begin
      if not SharpESkinTextBarBottom then
        n := 0
    end else if CompareText('$IsBarTop',FEnabledString) = 0 then
    begin
      if SharpESkinTextBarBottom then
        n := 0;
    end
    else n := EvaluateValue(FEnabledString,cs);
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
  StringSaveToStream(BoolToStr(FIsEmpty),Stream);  
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
    FIsEmpty := StrToBool(StringLoadFromStream(Stream));
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
var
  Temp : TBitmap32;
begin
  Src.DrawMode := dmCustom;
  Src.OnPixelCombine := DoCombine;
 
  Case FLayerMode of 
    lmBlend,lmAdd: begin
              Src.OnPixelCombine := nil;
              Src.DrawMode := dmBlend;
             end;
  end;

  if FLayerMode = lmAdd then
  begin
    Temp := TBitmap32.Create;
    try
      Temp.SetSize(Dst.Width,Dst.Height);
      Temp.Clear(color32(0,0,0,0));
      Temp.Draw(DstRect,SrcRect,Src);
      LightenBitmap(Dst,Temp,0,0);
    finally
      Temp.Free;
    end;
  end else Dst.Draw(DstRect,SrcRect,Src);
end;

procedure TSkinPart.draw(bmp: TBitmap32; cs: ISharpEScheme);
var temp: Tbitmap32;
  FBitmap: Tbitmap32;
  i: integer;
  r: Trect;
  isEmpty: boolean;
begin
  if not FEnabled then exit;
  if FIsEmpty then exit;

  if (FBitmapId >= 0) and not ((FGradientAlpha.XAsInt <> 0) or (FGradientAlpha.YAsInt <> 0)) then
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

  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
  // Draw Gradient
  if (FGradientAlpha.XAsInt <> 0) or (FGradientAlpha.YAsInt <> 0) then
  begin
    r := FSkinDim.GetRect(rect(0, 0, bmp.Width, bmp.Height));
    temp := TBitmap32.Create;
//    temp.assign(TBitmap32(Bmp));
    temp.SetSize(Bmp.Width, Bmp.Height);
    if not Bmp.Empty then
      MoveLongword(Bmp.Bits[0], temp.Bits[0], Bmp.Width * Bmp.Height);

    temp.Clear(color32(0,0,0,0));
    temp.DrawMode := dmBlend;
    temp.CombineMode := cmMerge;
    try
      if GradientType = 'horizontal' then
         HGradient(temp,
                 FGradientColor.XAsInt,
                 FGradientColor.YAsInt,
                 FGradientAlpha.XAsInt,
                 FGradientAlpha.YAsInt,
                 r)
       else VGradient(temp,
                 FGradientColor.XAsInt,
                 FGradientColor.YAsInt,
                 FGradientAlpha.XAsInt,
                 FGradientAlpha.YAsInt,
                 r);
       temp.MasterAlpha := FMasterAlpha;
       temp.DrawTo(Bmp);
    finally
      temp.Free;
    end;
  end;

  for i := 0 to Items.Count - 1 do
  begin
    Items[i].draw(bmp, cs);
  end;
end;

procedure TSkinPart.DrawTo(Bmp: TBitmap32; Scheme : ISharpEScheme);
begin
  Draw(Bmp, Scheme);
end;

procedure TSkinPart.ExecuteScript(pComponent: TObject; pScript: String;
  pScheme: ISharpEScheme; pAnimTimerCallback : ISharpESkinAnimTimerCallback);
begin
  SharpEAnimManager.ExecuteScript(pComponent,pScript,self,pScheme,pAnimTimerCallback);
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
      if ItemNamed['Empty'] <> nil then
        FIsEmpty := BoolValue('Empty',False);
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
  FIsEmpty := Value.IsEmpty;
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
  FIsEmpty := False;
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
  FIsEmpty := False;
  FItems := TSkinPartList.create(BmpList);
  FSkinDim := TSkinDim.create;
  FSkinText := TSkinText.create(True);
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
  FSkinText.SelfInterface := nil;
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

function TSkinPart.GetDimension: TPoint;
begin
  result := Point(FSkinDim.WidthAsInt,FSkinDim.HeightAsInt);
end;

function TSkinPart.GetDimRect(ps: TRect): TRect;
begin
  result := FSkinDim.GetRect(ps);
end;

function TSkinPart.GetDrawText: Boolean;
begin
  result := FSkinText.DrawText;
end;

//**********************************
//* TSkinIcon
//**********************************

procedure TSkinIcon.Clear;
begin
  FDrawIcon := True;
  FSize.SetPoint('16','16');
  FPosition.SetPoint('0','0');
  FBlend := False;
  FBlendColorStr := '0';
  FBlendColor := 0;
  FBlendAlpha := 255;
  FLighten := False;
  FLightenAmount := 48;
end;

constructor TSkinIcon.Create(OwnsInterface : Boolean);
begin
  Inherited Create;

  if OwnsInterface then
    FInterface := self
  else FInterface := nil;

  FSize := TSkinPoint.Create;
  FPosition := TSkinPoint.Create;
  Clear;
end;

destructor TSkinIcon.Destroy;
begin
  FSize.Free;
  FPosition.Free;

  inherited Destroy;
end;

procedure TSkinIcon.DrawTo(Dst, Src: TBitmap32; x, y: integer);
begin
  RenderTo(Dst,Src,x,y);
end;

function TSkinIcon.GetDrawIcon: Boolean;
begin
  result := FDrawIcon;
end;

function TSkinIcon.GetDimension: TPoint;
begin
 result := Point(Size.XAsInt,Size.YAsInt);
end;

function TSkinIcon.GetXY(TextRect, CompRect: TRect): TPoint;
var
  cw, ch: integer;
  tw, th: integer;
begin
  cw := CompRect.Right - CompRect.Left;
  ch := CompRect.Bottom - CompRect.Top;
  tw := TextRect.Right - TextRect.Left;
  th := TextRect.Bottom - TextRect.Top;

  result.X := ParseCoordinate(FPosition.FX, tw, th, cw, ch, FSize.XAsInt, FSize.YAsInt);
  result.Y := ParseCoordinate(FPosition.FY, tw, th, cw, ch, FSize.XAsInt, FSize.YAsInt);
end;

procedure TSkinIcon.Assign(Value: TSkinIcon);
begin
  FDrawIcon := Value.DrawIcon;
  FSize.Assign(Value.FSize);
  FPosition.Assign(Value.FPosition);
  FLighten := Value.Lighten;
  FLightenAmount := Value.LightenAmount;
  FBlend := Value.Blend;
  FBlendColorStr := Value.BlendColorStr;
  FBlendColor := Value.BlendColor;
  FBlendAlpha := Value.BlendAlpha;
end;

procedure TSkinIcon.SaveToStream(Stream: TStream);
begin
  StringSaveToStream(BoolToStr(FDrawIcon),Stream);
  FSize.SaveToStream(Stream);
  FPosition.SaveToStream(Stream);
  StringSaveToStream(BoolToStr(FLighten),Stream);
  Stream.WriteBuffer(FLightenAmount, SizeOf(FLightenAmount));
  StringSaveToStream(BoolToStr(FBlend),Stream);
  StringSaveToStream(FBlendColorStr,Stream);
  Stream.WriteBuffer(FBlendAlpha, SizeOf(FBlendAlpha));
end;

procedure TSkinIcon.SetDrawIcon(Value: Boolean);
begin
  FDrawIcon := Value;
end;

procedure TSkinIcon.LoadFromStream(Stream: TStream);
begin
  FDrawIcon := StrToBool(StringLoadFromStream(Stream));
  FSize.LoadFromStream(Stream);
  FPosition.LoadFromStream(Stream);
  FLighten := StrToBool(StringLoadFromStream(Stream));
  Stream.ReadBuffer(FLightenAmount, SizeOf(FLightenAmount));
  FBlend := StrToBool(StringLoadFromStream(Stream));
  FBlendColorStr := StringLoadFromStream(Stream);
  Stream.ReadBuffer(FBlendAlpha, SizeOf(FBlendAlpha));
end;

procedure TSkinIcon.LoadFromXML(xml: TJvSimpleXMLElem);
begin
  with xml.Items do
  begin
    if ItemNamed['size'] <> nil then
      FSize.SetPoint(Value('size', 'w,h'));
    if ItemNamed['location'] <> nil then
      FPosition.SetPoint(Value('location','0,0'));
    if ItemNamed['draw'] <> nil then
      FDrawIcon := BoolValue('draw',true);
    if ItemNamed['blend'] <> nil then
      FBlend := BoolValue('blend',false);
    if ItemNamed['lighten'] <> nil then
      FLighten := BoolValue('lighten',false);
    if ItemNamed['lightenamount'] <> nil then
      FLightenAmount := IntValue('lightenamount',0);
    if ItemNamed['blendcolor'] <> nil then
      FBlendColorStr := Value('blendcolor','0');
    if ItemNamed['blendalpha'] <> nil then
      FBlendAlpha := IntValue('blendalpha',255);
  end;
end;

procedure TSkinIcon.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  FBlendColor := ParseColor(FBlendColorStr,cs);
end;

procedure TSkinIcon.RenderTo(Dst, Src: TBitmap32; x,y : integer);
var
  IWidth,IHeight : integer;
  icon : TBitmap32;
  temp : TBitmap32;
begin
  if (src = nil) or (not DrawIcon) then
   exit;

  icon := TBitmap32.Create;
  icon.DrawMode := dmBlend;
  icon.CombineMode := cmMerge;
  icon.Clear(color32(0,0,0,0));
  IWidth := FSize.XAsInt;
  IHeight := FSize.YAsInt;

  TLinearResampler.Create(Src);
  if (IWidth <> Icon.Width) or (IHeight <> Icon.Height) then
  begin
    icon.setsize(IWidth,IHeight);
    icon.Clear(color32(0,0,0,0));
    src.DrawTo(icon,Rect(0,0,icon.width,icon.height));
  end else icon.assign(src);

  if FBlend then
  begin
    temp := TBitmap32.Create;
    temp.DrawMode := dmBlend;
    temp.CombineMode := cmMerge;
    temp.SetSize(Icon.Width,Icon.Height);
    temp.Clear(color32(0,0,0,0));
    try
      doBlend(temp, icon, FBlendColor);
      temp.MasterAlpha := FBlendAlpha;
      icon.Clear(color32(0,0,0,0));
      temp.DrawTo(icon);
    finally
      temp.free;
    end;
  end;

  if FLighten then
    LightenBitmap(icon,FLightenAmount);

  icon.DrawTo(dst,x,y);
  icon.free;
end;

//**********************************
//* TSkinPartEX
//**********************************

constructor TSkinPartEx.Create(BmpList: TSkinBitmapList);
begin
  inherited Create(BmpList);
  FSkinIcon := TSkinIcon.Create(True);
  FWidthMod := 0;
end;

destructor TSkinPartEx.Destroy;
begin
  FSkinIcon.SelfInterface := nil;
  inherited Destroy;
end;

function TSkinPartEx.GetIcon: ISharpESkinIcon;
begin
  result := FSkinIcon.SelfInterface;
end;

function TSkinPartEx.GetWidthMod: integer;
begin
  result := FWidthMod;
end;

procedure TSkinPartEx.Assign(Value : TSkinPartEx);
begin
  inherited Assign(Value as TSkinPart);
  FSkinIcon.Assign(Value.SkinIcon);
  FWidthMod := Value.WidthMod;
end;

procedure TSkinPartEx.UpdateDynamicProperties(cs: ISharpEScheme);
begin
  Inherited UpdateDynamicProperties(cs);
  
  FSkinIcon.UpdateDynamicProperties(cs);
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


function EvaluateValue(str: string; cs: ISharpEScheme) : integer;
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

  if cs <> nil then
    for n := 0 to High(cs.Colors) do
        str := StringReplace(str,cs.Colors[n].Tag,inttostr(cs.Colors[n].Color),[rfReplaceAll,rfIgnoreCase]);

  result := 0;
  tmp := '';
  sub := false;
  n := 0;
  while n < length(str) do
  begin
    inc(n);
    if (str[n] <> #0) then
      if (ord(str[n]) >= 48) and (ord(str[n]) <= 57) then
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

procedure EvaluateColor(src: string; out color : String; out modvalue : integer);
var
  s : string;
  i : integer;
  p1,p2,p : integer;
begin
  if trystrtoint(src,i) then
  begin
    modvalue := 0;
    color := src;
    exit;
  end;

  src := StringReplace(src,' ','',[rfReplaceAll]);
  p1 := Pos('+',src);
  p2 := Pos('-',src);
  if (p1 = 0) and (p2 = 0) then
  begin
    color := src;
    modvalue := 0;
    exit;
  end;

  if p1 = 0 then
    p1 := length(src);
  if p2 = 0 then
    p2 := length(src);
    
  p := min(p1,p2);
  color := copy(src,0,p-1);
  
  s := copy(src,p,length(src)-p+1);
  modvalue := EvaluateValue(s,nil);
end;

function ParseColor(src : String; cs : ISharpEScheme) : integer;
var
  Color : String;
  ModValue : integer;
begin
  EvaluateColor(src,Color,ModValue);

  result := SchemedStringToColor(Color,cs);
  result := abs(result);
  result := LightenRGB(result,ModValue);
end;

function SchemedStringToColor(str: string; cs: ISharpEScheme): TColor;
var
  n : integer;
begin
  n := cs.GetColorIndexByTag(str);
  if n <> -1 then
    result := cs.GetColorByTag(str)
  else result := GetCurrentTheme.Scheme.ParseColor(str);
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

function LightenRGB(src : integer; amount : integer) : integer;
var
  r,g,b : Byte;
  r2,g2,b2 : Integer;
  ro,go,bo : Integer;
  overhead : Integer;
begin
  R := GetRValue(src);
  G := GetGValue(src);
  B := GetBValue(src);
  R2 := R + amount;
  G2 := G + amount;
  B2 := B + amount;

  ro := 0;
  go := 0;
  bo := 0;
  if R2 > 255 then
    ro := (R2 - 255)
  else if R2 < 0 then
    ro := R2;
  if G2 > 255 then
    go := (G2 - 255)
  else if G2 < 0 then
    go := G2;
  if B2 > 255 then
    bo := (B2 - 255)
  else if B2 < 0 then
    bo := B2;
  if (ro < 0) or (go < 0) or (bo < 0) then
    overhead := min(ro,min(go,bo))
  else overhead := max(ro,max(go,bo));
  R2 := R2 - overhead;
  G2 := G2 - overhead;
  B2 := B2 - overhead;

  result := RGB(R2,G2,B2);
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
   DX1,DX2 : integer;
begin
  if (Rect.Right - Rect.Left = 0) or (Rect.Bottom - Rect.Top = 0) then
    exit;

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

  DX1 := Max(0,Min(Bmp.Width,Rect.Left));
  DX2 := Max(0,Min(Bmp.Width,Rect.Right));
  for y:=0 to Rect.Bottom-Rect.Top do
  begin
    if (y +Rect.Top >= 0) and (y +Rect.Top <= Bmp.Height - 1) then
      Bmp.HorzLineTS(DX1,y+Rect.Top,DX2,
                    color32(sr+round(nr*y),sg+round(ng*y),sb+round(nb*y),st+round(nt*y)));
  end;
end;


// ######################################


procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
var
  nR,nG,nB,nt : real;
  sR,sG,sB : integer;
  eR,eG,eB : integer;
  x : integer;
  DY1,DY2 : integer;
begin
  if (Rect.Right - Rect.Left = 0) or (Rect.Bottom - Rect.Top = 0) then
    exit;

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

  DY1 := Max(0,Min(Bmp.Height,Rect.Top));
  DY2 := Max(0,Min(Bmp.Height,Rect.Bottom));
  for x:= 0 to Rect.Right-Rect.Left do
  begin
    if (x + Rect.Left >= 0) and (x + Rect.Left <= Bmp.Width - 1) then
      Bmp.VertLineTS(x+Rect.Left,DY1,DY2,
                    color32(sr+round(nr*x),sg+round(ng*x),sb+round(nb*x),st+round(nt*x)));
  end;
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

function ParseCoordinate(s: string; tw, th, cw, ch, iw, ih: integer): integer;
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
  while i < length(s) do
  begin
    inc(i);
    if (s[i] <> #0) then
    begin
      if (ord(s[i]) >= 48) and (ord(s[i]) <= 57) then
        tmp := tmp + s[i]
      else if (length(s) > i+1) and (lowercase(s[i] + s[i + 1] + s[i + 2]) = 'iwh') then
      begin
        tmp := inttostr(iw div 2);
        inc(i,2);
      end
      else if (length(s) > i+1) and (lowercase(s[i] + s[i + 1] + s[i + 2]) = 'ihh') then
      begin
        tmp := inttostr(ih div 2);
        inc(i,2);
      end        
      else if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'iw') then
      begin
        tmp := inttostr(iw);
        inc(i);
      end
      else if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'ih') then
      begin
        tmp := inttostr(ih);
        inc(i);
      end
      else if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'cw') then
      begin
        tmp := inttostr(floor((cw - tw) / 2));
        inc(i);
      end
      else if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'ch') then
      begin
        tmp := inttostr(floor((ch - th) / 2));
        inc(i);
      end else if (length(s) > i+1) and (lowercase(s[i] + s[i + 1] + s[i + 2]) = 'twh') then
      begin
        tmp := inttostr(tw div 2);
        inc(i,2);
      end else if (length(s) > i+1) and (lowercase(s[i] + s[i + 1] + s[i + 2]) = 'thh') then
      begin
        tmp := inttostr(th div 2);
        inc(i,2);
      end
      else if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'tw') then
      begin
        tmp := inttostr(tw);
        inc(i);
      end
      else if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'th') then
      begin
        tmp := inttostr(tw);
        inc(i);
      end
      else if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'wh') then
      begin
        tmp := inttostr(cw div 2);
        inc(i);
      end
      else if (length(s) > i) and (lowercase(s[i] + s[i + 1]) = 'hh') then
      begin
        tmp := inttostr(ch div 2);
        inc(i);
      end else if (lowercase(s[i]) = 'w') then
        tmp := inttostr(cw)
      else if (lowercase(s[i]) = 'h') then
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
        else if (s[i] = '-') then
          sub := true;
        tmp := '';
      end;
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

end.
