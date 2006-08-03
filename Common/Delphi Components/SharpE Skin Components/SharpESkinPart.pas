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
  Dialogs;

type
  TSkinPart = class;
  TSkinPartList = class;
  TSkinDrawMode = (sdmTile, sdmStretch);

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
    procedure Clear;
    procedure SetLocation(x, y: string); overload;
    procedure SetLocation(str: string); overload;
    procedure SetDimension(w, h: string); overload;
    procedure SetDimension(str: string); overload;

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    function GetRect(ps: Trect): TRect;
    function ParseCoordinate(s: string; w, h: integer): integer;
    procedure Assign(Value: TSkinDim);
    property X: string read FX;
    property Y: string read FY;
    property XAsInt : integer read GetXInteger;
    property YAsInt : integer read GetYInteger;
    property Width: string read FWidth;
    property Height: string read FHeight;
    property WidthAsInt : integer read GetWidthInteger;
    property HeightAsInt : integer read GetHeightInteger;
  end;

  TSkinText = class
  private
    FX: string;
    FY: string;
    FName: string;
    FColor: string;
    FSize: integer;
    FStyleBold : boolean;
    FStyleItalic : boolean;
    FStyleUnderline : boolean;
    FMaxWidth : String;
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

    procedure LoadFromXML(xml: TJvSimpleXMLElem);
    function ParseCoordinate(s: string; tw, th, cw, ch: integer): integer;
    function GetXY(TextRect: TRect; CompRect: TRect): TPoint;
    function GetMaxWidth(CompRect: TRect): integer;
    function GetFont(cs: TSharpEScheme): TFont;
    procedure AssignFontTo(pFont : TFont; cs: TSharpEScheme);
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

  private
    FItems: TSkinPartList;
    FBmpList: TSkinBitmapList;
    FBitmapId: integer;
    FMasterAlpha: integer;
    FDrawMode: TSkinDrawMode;
    FBlend: boolean;
    FBlendColor: string;
    FBlendAlpha: integer;
    FSkinDim: TSkinDim;
    FSkinText: TSkinText;
    FGradientType : string;
    FGradientColor : TSkinPoint;
    FGradientAlpha : TSkinPoint;
  public
    constructor Create(BmpList: TSkinBitmapList); virtual;
    destructor Destroy; override;
    procedure Assign(Value: TSkinPart);
    procedure Clear; virtual;

    procedure SaveToStream(Stream: TStream);
    procedure LoadFromStream(Stream: TStream);

    function LoadFromXML(xml: TJvSimpleXMLElem; path: string; Text: TSkinText):
      boolean;
    procedure draw(bmp: TBitmap32; cs: TSharpEScheme);
    function Empty: Boolean;
    function GetBitmap: TBitmap32;
  published
    property Items: TSkinPartList read FItems;
    property Bitmap: TBitmap32 read GetBitmap;
    property BitmapID: integer read FBitmapID write FBitmapID;
    property SkinDim: TSkinDim read FSkinDim write FSkinDim;
    property SkinText: TSkinText read FSkinText write FSkinText;
    property Blend: boolean read FBlend write FBlend;
    property BlendColor: string read FBlendColor write FBlendColor;
    property BlendAlpha: integer read FBlendAlpha write FBlendAlpha;
    property GradientType: string read FGradientType write FGradientType;
    property GradientAlpha: TSkinPoint read FGradientAlpha write FGradientAlpha;
    property GradientColor: TSkinPoint read FGradientColor write FGradientColor;
  end;

procedure TileDraw(Src,Dest : TBitmap32; DestRect : TRect);
function get_location(str: string): TRect;
function SchemedStringToColor(str: string; cs: TSharpEScheme): TColor;
procedure doBlend(Dest: TBitmap32; source: TBitmap32; color: TColor);
procedure VGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);

implementation

uses Sysutils,
  SharpEDefault,gr32_png;

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
  try
    result := StrToInt(X);
  except
    result := -1
  end;
end;

function TSkinPoint.GetYInteger : integer;
begin
  try
    result := StrToInt(Y);
  except
    result := -1;
  end;
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
                      result := result - strtoint(tmp)
                    else
                      result := result + strtoint(tmp);
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
      result := result - strtoint(tmp)
    else
      result := result + strtoint(tmp);
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
              result := result - strtoint(tmp)
            else
              result := result + strtoint(tmp);
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
      result := result - strtoint(tmp)
    else
      result := result + strtoint(tmp);
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
  try
    result := StrToInt(FWidth);
  except
    result := -1;
  end;
end;

function TSkinDim.GetHeightInteger : integer;
begin
  try
    result := StrToInt(FHeight);
  except
    result := -1;
  end;
end;

function TSkinDim.GetXInteger : integer;
begin
  try
    result := StrToInt(FX);
  except
    result := -1
  end;
end;

function TSkinDim.GetYInteger : integer;
begin
  try
    result := StrToInt(FY);
  except
    result := -1;
  end;
end;

//***************************************
//* TSkinText
//***************************************

constructor TSkinText.Create;
begin
  Clear;
end;

destructor TSkinText.Destroy;
begin
  FX := '';
end;

procedure TSkinText.Clear;
begin
  FX := '';
  FY := '';
  FMaxWidth := 'w';
  FStyleBold := False;
  FStyleItalic := False;
  FStyleUnderline := False;
  Assign(DefaultSharpESkinTextRecord);
end;

procedure TSkinText.SaveToStream(Stream: TStream);
begin
  StringSaveToStream(FX, Stream);
  StringSaveToStream(FY, Stream);
  StringSaveToStream(FName, Stream);
  StringSaveToStream(FColor, Stream);
  StringSaveToStream(BoolToStr(FStyleBold),Stream);
  StringSaveToStream(BoolToStr(FStyleItalic),Stream);
  StringSaveToStream(BoolToStr(FStyleUnderline),Stream);
  StringSaveToStream(FMaxWidth, Stream);
  Stream.WriteBuffer(FSize, sizeof(FSize));
end;

procedure TSkinText.LoadFromStream(Stream: TStream);
begin
  FX := StringLoadFromStream(Stream);
  FY := StringLoadFromStream(Stream);
  FName := StringLoadFromStream(Stream);
  FColor := StringLoadFromStream(Stream);
  FStyleBold := StrToBool(StringLoadFromStream(Stream));
  FStyleItalic := StrToBool(StringLoadfromStream(Stream));
  FStyleUnderline := StrToBool(StringLoadFromStream(Stream));
  FMaxwidth := StringLoadFromStream(Stream);
  Stream.ReadBuffer(FSize, sizeof(FSize));
end;

procedure TSkinText.Assign(Value: TSkinText);
begin
  FX := Value.FX;
  FY := Value.FY;
  FName := Value.FName;
  FColor := Value.FColor;
  FSize := Value.FSize;
  FStyleBold := Value.FStyleBold;
  FStyleItalic := Value.FStyleItalic;
  FStyleUnderline := Value.FStyleUnderline;
  FMaxWidth := Value.FMaxWidth;
end;

procedure TSkinText.Assign(Value: TSkinTextRecord);
begin
  FName := Value.FName;
  FColor := Value.FColor;
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
  result.Color := SchemedStringToColor(FColor, cs);
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

procedure TSkinText.LoadFromXML(xml: TJvSimpleXMLElem);
begin
  with xml.Items do
  begin
    if ItemNamed['name'] <> nil then
      FName := Value('name', 'Arial');
    if ItemNamed['size'] <> nil then
      FSize := IntValue('size', 7);
    if ItemNamed['color'] <> nil then
      FColor := Value('color', '$000000');
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
  end;
end;

function TSkinText.ParseCoordinate(s: string; tw, th, cw, ch: integer): integer;
var i: integer;
  tmp: string;
  sub: boolean;
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
                      result := result - strtoint(tmp)
                    else
                      result := result + strtoint(tmp);
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
      result := result - strtoint(tmp)
    else
      result := result + strtoint(tmp);
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

procedure TSkinPart.SaveToStream(Stream: TStream);
var i, count: integer;
begin
  Stream.WriteBuffer(FBitmapId, sizeof(FBitmapId));
  Stream.WriteBuffer(FMasterAlpha, sizeof(FMasterAlpha));
  Stream.WriteBuffer(FDrawMode, sizeof(FDrawMode));
  Stream.WriteBuffer(FBlend, sizeof(FBlend));
  StringSaveToStream(FBlendColor, Stream);
  FGradientAlpha.SaveToStream(Stream);
  FGradientColor.SaveToStream(Stream);
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
    Stream.ReadBuffer(FMasterAlpha, sizeof(FMasterAlpha));
    Stream.ReadBuffer(FDrawMode, sizeof(FDrawMode));
    Stream.ReadBuffer(FBlend, sizeof(FBlend));
    FBlendColor := StringLoadFromStream(Stream);
    FGradientAlpha.LoadFromStream(Stream);
    FGradientColor.LoadFromStream(Stream);
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

procedure TSkinPart.draw(bmp: TBitmap32; cs: TSharpEScheme);
var temp: Tbitmap32;
  FBitmap: Tbitmap32;
  i: integer;
  r: Trect;
  isEmpty: boolean;
begin
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
      FBitmap.Clear(color32(SchemedStringToColor(BlendColor, cs)));
    end;
    TKernelResampler.Create(bmp).Kernel := TLanczosKernel.Create;
    if (Fblend) and not (IsEmpty) then
    begin
      temp := TBitmap32.Create;
      temp.DrawMode := dmBlend;
      temp.CombineMode := cmMerge;
      try
        doBlend(temp, FBitmap, SchemedStringToColor(BlendColor, cs));
        temp.MasterAlpha := FMasterAlpha;
        if FDrawMode = sdmStretch then bmp.draw(r, rect(0, 0, temp.width, temp.Height), temp)
           else TileDraw(temp,bmp,r);
      finally
        temp.free;
      end
    end
    else
    begin
      if FDrawMode = sdmStretch then bmp.draw(r, rect(0, 0, FBitmap.width, FBitmap.Height), FBitmap)
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
                 SchemedStringToColor(FGradientColor.X,cs),
                 SchemedStringToColor(FGradientColor.Y,cs),
                 FGradientAlpha.XAsInt,
                 FGradientAlpha.YAsInt,
                 r)
       else VGradient(Bmp,
                 SchemedStringToColor(FGradientColor.X,cs),
                 SchemedStringToColor(FGradientColor.Y,cs),
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
begin
  Clear;
  if Text <> nil then
    FSkinText.Assign(Text);
  sp := TSkinPart.create(FBmpList);
  try
    result := false;
    with xml.Items do
    begin
      if ItemNamed['gradienttype'] <> nil then
        FGradientType := Value('gradienttype','horizontal');
      if ItemNamed['gradientcolor'] <> nil then
        FGradientColor.SetPoint(Value('gradientcolor','0,0'));
      if ItemNamed['gradientalpha'] <> nil then
        FGradientAlpha.SetPoint(Value('gradientalpha','0,0'));
      if ItemNamed['text'] <> nil then
        FSkinText.LoadFromXml(ItemNamed['text']);
      if ItemNamed['location'] <> nil then
        FSkinDim.SetLocation(Value('location', '0,0'));
      if ItemNamed['dimension'] <> nil then
        FSkinDim.SetDimension(Value('dimension', '0,0'));
      if ItemNamed['alpha'] <> nil then
        FMasterAlpha := IntValue('alpha', 255);
      if ItemNamed['drawmode'] <> nil then
        if lowercase(Value('drawmode', 'stretch')) = 'tile' then
          FDrawMode := sdmTile;
      if ItemNamed['color'] <> nil then
      begin
        FBlendColor := Value('color', '');
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
  FBitmapId := Value.FBitmapId;
  FSkinDim.Assign(Value.SkinDim);
  FBlend := Value.Blend;
  FBlendColor := Value.BlendColor;
  FBlendAlpha := Value.BlendAlpha;
  FMasterAlpha := Value.FMasterAlpha;
  FDrawMode := Value.FDrawMode;
  FGradientType := Value.GradientType;
  FGradientColor.Assign(Value.GradientColor);
  FGradientAlpha.Assign(Value.GradientAlpha);
  for i := 0 to Value.Items.count - 1 do
  begin
    FItems.Add(Value.Items[i]);
  end;
end;

procedure TSkinPart.Clear;
begin
  if FItems <> nil then
    FItems.Clear;
  FBitmapID := -1;
  FBlend := false;
  FBlendColor := '$000000';
  FBlendAlpha := 255;
  FMasterAlpha := 255;
  FGradientColor.Clear;
  FGradientAlpha.Clear;
  FGradientType := 'horizontal';
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
  FGradientAlpha := TSkinPoint.Create;
  FGradientType := 'horizontal';
  FBlend := false;
  FBlendColor := '$000000';
  FBlendAlpha := 255;
  FBitmapId := -1;
  FBmpList := BmpList;
  FDrawMode := sdmStretch;
  FMasterAlpha := 255;
end;

destructor TSkinPart.Destroy;
begin
  if (parentlist <> nil) then
    parentlist.Remove(self);
  Clear;
  FMasterAlpha := 0;
  FBlendAlpha := 0;
  FBitmapId := -1;
  FDrawMode := sdmTile;
  FItems.Free;
  FSkinDim.Free;
  FSkinText.Free;
  FGradientColor.Free;
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
//* Other
//**********************************

procedure TileDraw(Src,Dest : TBitmap32; DestRect : TRect);
var
  w,h,nx,ny,x,y : integer;
  temp : TBitmap32;
begin
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
    temp.DrawMode := dmBlend;
    temp.CombineMode := cmMerge;
    temp.DrawTo(Dest,DestRect.Left,DestRect.Top);
  finally
    temp.free;
  end;
end;

function SchemedStringToColor(str: string; cs: TSharpEScheme): TColor;
begin
  if lowercase(str) = '$workareaback' then
    result := cs.WorkAreaback
  else
    if lowercase(str) = '$workareadark' then
      result := cs.WorkAreadark
    else
      if lowercase(str) = '$workarealight' then
        result := cs.WorkArealight
      else
        if lowercase(str) = '$workareatext' then
          result := cs.WorkAreatext
        else
          if lowercase(str) = '$throbberback' then
            result := cs.Throbberback
          else
            if lowercase(str) = '$throbberdark' then
              result := cs.Throbberdark
            else
              if lowercase(str) = '$throbberlight' then
                result := cs.Throbberlight
              else
                if lowercase(str) = '$throbbertext' then
                  result := cs.Throbbertext
                else
                begin
                  try
                    result := StringToColor(str);
                  except
                    result := clblack;
                  end;
                end;
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
  sR := GetRValue(color1);
  sG := GetGValue(color1);
  sB := GetBValue(color1);
  eR := GetRValue(color2);
  eG := GetGValue(color2);
  eB := GetBValue(color2);
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

end.
