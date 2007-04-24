unit SharpESwatchManager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpFX, SharpGraphicsUtils, gr32, SharpECenterScheme,
  Contnrs, JvSimpleXml, menus, pngimagelist, SharpThemeApi, StdCtrls,
    GR32_Polygons, SharpApi, GR32_Image, GR32_Layers, GR32_RangeBars,
      JclFileUtils;

const
  cXmlHeader='SharpESwatchCollection';
  cXmlColName='ColorName';
  cXmlCol='Color';
  cXmlOptionsFile='swatchopt.dat';
  cXmlDefaultSwatchFile='default.swatch';

Type
  TSharpESwatchCollectionSortType = (sortHue, sortSat, sortLum,
    sortName);
  TOnGetWidth = Procedure(ASender:TObject; var AWidth:Integer) of object;
  TOnUpdateSwatchBitmap = Procedure(ASender:TObject; const ABitmap32:TBitmap32) of object;

Type
  TSharpESwatchCollectionItem = Class(TCollectionItem)
  private
    FColorName: String;
    FColor: TColor;
    FData: Pointer;
    FOwner: TObject;
    FSwatchRect: TRect;
    FSelected: Boolean;
    procedure SetColor(const Value: TColor);
    procedure SetColorName(const Value: String);
    procedure SetSelected(const Value: Boolean);
  Public
    Property Data: Pointer read FData write FData;
    property SwatchRect: TRect read FSwatchRect write FSwatchRect;
    Property Selected: Boolean read FSelected write SetSelected;
  Published
    Property ColorName: String read FColorName write SetColorName;
    Property Color: TColor read FColor write SetColor;
  Protected
    function GetDisplayName: string; override;

end;

Type
  TSharpESwatchCollectionItems = Class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TSharpESwatchCollectionItem;
    procedure SetItem(Index: Integer; const Value: TSharpESwatchCollectionItem);
  protected
    procedure Update(Item: TCollectionItem); override;

    function Add(AOwner:TComponent):TSharpESwatchCollectionItem;

    property Item[Index: Integer]: TSharpESwatchCollectionItem read GetItem write SetItem;

  public
    constructor Create(AOwner: TPersistent);
    function IndexOf(const Name: string): Integer;
end;

Type
  TSharpESwatchManager = Class(TComponent)
  private
    FCachedBitmap: TBitmap32;
    FScheme: TSharpECenterScheme;
    FShowCaptions: Boolean;
    FSwatches: TSharpESwatchCollectionItems;
    FSwatchWidth: Integer;
    FSwatchFont: TFont;
    FSortMode: TSharpESwatchCollectionSortType;
    FSwatchSpacing: Integer;
    FSwatchTextBorderColor: TColor;
    FSwatchHeight: Integer;
    FWidth: Integer;
    FonGetWidth: TOnGetWidth;
    FOnUpdateSwatchBitmap: TOnUpdateSwatchBitmap;
    FUpdate: Boolean;

    procedure SetShowCaptions(const Value: Boolean);
    procedure SetSortMode(const Value: TSharpESwatchCollectionSortType);
    procedure SetSwatchFont(const Value: TFont);
    procedure SetSwatchHeight(const Value: Integer);
    procedure SetSwatchSpacing(const Value: Integer);
    procedure SetSwatchTextBorderColor(const Value: TColor);
    procedure SetSwatchWidth(const Value: Integer);

    procedure DrawSwatch(ABitmap: TBitmap32; ASwatch:TSharpESwatchCollectionItem);
    function GetCollectionList(AC: TCollection): TList;
    procedure SetWidth(const Value: Integer);
    function GetWidth: Integer;
  protected
    procedure Loaded; override;
  public
    procedure AddSwatch(AColor: TColor; AName: String);

    procedure Load(AFileName:String);
    Procedure Save(AFileName:String; ASelectedOnly:Boolean=False);
    procedure SaveOptions(AFileName:String);
    procedure LoadOptions(AFileName:String);

    procedure DeselectAll;
    procedure SelectAll;

    procedure Resize;
    constructor Create(AOwner: TComponent); override;


    procedure SetItemSelected(APoint: TPoint);
    function GetItemFromPoint(APoint: TPoint):TSharpESwatchCollectionItem;

    procedure BeginUpdate;
    procedure EndUpdate;
    procedure BeforeDestruction; override;

  published
    property Swatches: TSharpESwatchCollectionItems read FSwatches write
      FSwatches;

    procedure CreateSwatchBitmap;

    property Width: Integer read GetWidth write SetWidth;
    property ShowCaptions: Boolean read FShowCaptions write SetShowCaptions;
    property SwatchHeight: Integer read FSwatchHeight write SetSwatchHeight;
    property SwatchWidth: Integer read FSwatchWidth write SetSwatchWidth;
    property SwatchSpacing: Integer read FSwatchSpacing write SetSwatchSpacing;
    property SwatchFont: TFont read FSwatchFont write SetSwatchFont;
    property SwatchTextBorderColor: TColor read FSwatchTextBorderColor write
      SetSwatchTextBorderColor;

    property SortMode: TSharpESwatchCollectionSortType read FSortMode write
      SetSortMode;

    property OnGetWidth: TOnGetWidth read FonGetWidth write FOnGetWidth;
    property OnUpdateSwatchBitmap: TOnUpdateSwatchBitmap read
      FOnUpdateSwatchBitmap write FOnUpdateSwatchBitmap;

end;

procedure Register;
function Sort_ByHue (Item1, Item2: Pointer): Integer;
function Sort_ByBri (Item1, Item2: Pointer): Integer;
function Sort_BySat (Item1, Item2: Pointer): Integer;
function Sort_ByName (Item1, Item2: Pointer): Integer;

implementation

procedure Register;
begin
  RegisterComponents('SharpE_Common',[TSharpESwatchManager]);
end;

function Sort_ByName (Item1, Item2: Pointer): Integer;
begin
  result := CompareText(TSharpESwatchCollectionItem(Item1).ColorName,
    TSharpESwatchCollectionItem(Item2).ColorName);
end;

function Sort_ByHue (Item1, Item2: Pointer): Integer;
var
  tmp,tmp2: TSharpESwatchCollectionItem;
  val, val2: Integer;
  r1,b1,g1,r2,b2,g2: byte;
  rgb1, rgb2: integer;
  hsl1, hsl2: THSLColor;

begin
  tmp := TSharpESwatchCollectionItem(Item1);
  tmp2 := TSharpESwatchCollectionItem(Item2);

  // First Color
  rgb1 := tmp.Color;
  r1 := GetRValue(rgb1);
  b1 := GetBValue(rgb1);
  g1 := GetGValue(rgb1);
  hsl1 := SharpGraphicsUtils.RGBtoHSL(color32(r1,g1,b1,255));

  // Second Color
  rgb2 := tmp2.Color;
  r2 := GetRValue(rgb2);
  b2 := GetBValue(rgb2);
  g2 := GetGValue(rgb2);
  hsl2 := SharpGraphicsUtils.RGBtoHSL(color32(r2,g2,b2,255));

  Result := CompareText(inttostr(hsl2.Hue),inttostr(hsl1.Hue))
end;

function Sort_ByBri (Item1, Item2: Pointer): Integer;
var
  tmp,tmp2: TSharpESwatchCollectionItem;
  val, val2: Integer;
  r1,b1,g1,r2,b2,g2: byte;
  rgb1, rgb2: integer;
  hsl1, hsl2: THSLColor;

begin
  tmp := TSharpESwatchCollectionItem(Item1);
  tmp2 := TSharpESwatchCollectionItem(Item2);

  // First Color
  rgb1 := tmp.Color;
  r1 := GetRValue(rgb1);
  b1 := GetBValue(rgb1);
  g1 := GetGValue(rgb1);
  hsl1 := SharpGraphicsUtils.RGBtoHSL(color32(r1,g1,b1,255));

  // Second Color
  rgb2 := tmp2.Color;
  r2 := GetRValue(rgb2);
  b2 := GetBValue(rgb2);
  g2 := GetGValue(rgb2);
  hsl2 := SharpGraphicsUtils.RGBtoHSL(color32(r2,g2,b2,255));

  Result := CompareText(inttostr(hsl2.Lightness),inttostr(hsl1.Lightness))
end;

function Sort_BySat (Item1, Item2: Pointer): Integer;
var
  tmp,tmp2: TSharpESwatchCollectionItem;
  val, val2: Integer;
  r1,b1,g1,r2,b2,g2: byte;
  rgb1, rgb2: integer;
  hsl1, hsl2: THSLColor;

begin
  tmp := TSharpESwatchCollectionItem(Item1);
  tmp2 := TSharpESwatchCollectionItem(Item2);

  // First Color
  rgb1 := tmp.Color;
  r1 := GetRValue(rgb1);
  b1 := GetBValue(rgb1);
  g1 := GetGValue(rgb1);
  hsl1 := SharpGraphicsUtils.RGBtoHSL(color32(r1,g1,b1,255));

  // Second Color
  rgb2 := tmp2.Color;
  r2 := GetRValue(rgb2);
  b2 := GetBValue(rgb2);
  g2 := GetGValue(rgb2);
  hsl2 := SharpGraphicsUtils.RGBtoHSL(color32(r2,g2,b2,255));

  Result := CompareText(inttostr(hsl2.Saturation),inttostr(hsl1.Saturation))
end;


{ TSharpESwatchCollectionItem }

procedure TSharpESwatchCollectionItem.SetColor(const Value: TColor);
begin
  FColor := Value;
end;

procedure TSharpESwatchCollectionItem.SetColorName(const Value: String);
begin
  FColorName := Value;
end;

function TSharpESwatchCollectionItem.GetDisplayName: string;
begin
  Result := 'Swatch'+ IntToStr(id);
end;

procedure TSharpESwatchCollectionItem.SetSelected(const Value: Boolean);
begin
  FSelected := Value;
end;

{ TSharpESwatchCollectionItems }

function TSharpESwatchCollectionItems.IndexOf(const Name: string): Integer;
begin
  for Result := 0 to Count - 1 do
    if AnsiCompareText(Items[Result].DisplayName, Name) = 0 then
      Exit;
  Result := -1;
end;

constructor TSharpESwatchCollectionItems.Create(AOwner: TPersistent);
begin
  inherited Create(AOwner, TSharpESwatchCollectionItem);
end;

function TSharpESwatchCollectionItems.Add(
  AOwner: TComponent): TSharpESwatchCollectionItem;
begin
  result := inherited Add as TSharpESwatchCollectionItem;
end;

function TSharpESwatchCollectionItems.GetItem(
  Index: Integer): TSharpESwatchCollectionItem;
begin
  result := inherited Items[Index] as TSharpESwatchCollectionItem;
end;

procedure TSharpESwatchCollectionItems.SetItem(Index: Integer;
  const Value: TSharpESwatchCollectionItem);
begin
  inherited Items[Index] := Value;
end;

procedure TSharpESwatchCollectionItems.Update(Item: TCollectionItem);
begin
  inherited Update(Item);

  if ((Owner <> nil) and (csDesigning in TSharpESwatchManager(Owner).ComponentState)) then
     TSharpESwatchManager(Owner).CreateSwatchBitmap;
end;

{ TSharpESwatchManager }

procedure TSharpESwatchManager.SetShowCaptions(const Value: Boolean);
begin
  FShowCaptions := Value;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.SetSwatchWidth(const Value: Integer);
begin
  FSwatchWidth := Value;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.SetSwatchFont(const Value: TFont);
begin
  FSwatchFont := Value;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.SetSortMode(
  const Value: TSharpESwatchCollectionSortType);
begin
  FSortMode := Value;

  // Sort first
  Case FSortMode of
  sortHue : GetCollectionList(FSwatches).Sort(@Sort_ByHue);
  sortSat : GetCollectionList(FSwatches).Sort(@Sort_BySat);
  sortLum : GetCollectionList(FSwatches).Sort(@Sort_ByBri);
  sortName : GetCollectionList(FSwatches).Sort(@Sort_ByName);
  end;

  CreateSwatchBitmap;

end;

procedure TSharpESwatchManager.SetSwatchSpacing(const Value: Integer);
begin
  FSwatchSpacing := Value;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.SetSwatchTextBorderColor(const Value: TColor);
begin
  FSwatchTextBorderColor := Value;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.SetSwatchHeight(const Value: Integer);
begin
  FSwatchHeight := Value;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.Load(AFileName: String);
var
  xml: TJvSimpleXml;
  i: Integer;
  newItem: TSharpESwatchCollectionItem;
begin

  if Not(FileExists(AFileName)) then
    Exit;

  BeginUpdate;
  Try

  FSwatches.Clear;
  xml := TJvSimpleXML.Create(nil);
  try
    xml.LoadFromFile(AFileName);

    // check for valid header
    if xml.Root.Name <> cXmlHeader then
      exit;

      For i := 0 to Pred(xml.Root.Items.Count) do begin
        newItem := TSharpESwatchCollectionItem.Create(FSwatches);
        newItem.ColorName := xml.Root.Items.Item[i].Properties.Value(cXmlColName,'');
        newItem.Color := xml.Root.Items.Item[i].Properties.IntValue(cXmlCol,clWindow);
      end;

    finally
      xml.Free;
    end;

  Finally
    EndUpdate;
  End;
end;

procedure TSharpESwatchManager.SaveOptions(AFileName: String);
var
  xml:TJvSimpleXML;
begin
  xml := TJvSimpleXML.Create(nil);
  Try
    xml.Root.Name := 'SharpESwatchCollectionOptions';
    with xml.Root.Items.Add('Options') do begin
      items.Add('ShowSwatchText',FShowCaptions);
      items.Add('SortMode',Integer(FSortMode));
    end;
  Finally
    xml.SaveToFile(AFileName);
    xml.Free;
  End;
end;

procedure TSharpESwatchManager.AddSwatch(AColor: TColor; AName: String);
var
  tmp:TSharpESwatchCollectionItem;
begin
  tmp := FSwatches.Add(Self);
  tmp.ColorName := AName;
  tmp.Color := AColor;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.Save(AFileName: String; ASelectedOnly: Boolean);
var
  xml: TJvSimpleXml;
  i: Integer;
  newItem: TSharpESwatchCollectionItem;
  bAdd: Boolean;
begin

  xml := TJvSimpleXML.Create(nil);
  try
    xml.Root.Name := cXmlHeader;

    For i := 0 to Pred(FSwatches.Count) do begin
      bAdd := True;

      if ASelectedOnly then
        if Not(FSwatches.Item[i].Selected) then
          bAdd := False;

      if bAdd then begin
        with xml.Root.Items.Add('Swatch') do begin
          Properties.Add(cXmlColName,FSwatches.Item[i].ColorName);
          Properties.Add(cXmlCol,FSwatches.Item[i].Color);
        end;
      end;
    end;

  finally
    xml.SaveToFile(AFileName);
    xml.Free;
  end;
end;

procedure TSharpESwatchManager.CreateSwatchBitmap;
var
  i:Integer;
  x,w,y,tw,swatchWidth: Integer;
  r, rTextBorder,rText: TRect;

  tmpBitmap: TBitmap32;
begin
  if Not(FUpdate) then begin
    exit;
  end;

  Try
  tmpBitmap := TBitmap32.Create;
  tmpBitmap.BeginUpdate;

  // Initialise
  x := 0;

  if assigned(FOnGetWidth) then begin
    w := FWidth;
    FOnGetWidth(Self,w);
  end else
    w := FWidth;

  y := FSwatchSpacing;

  tmpBitmap.SetSize(w,1000);
  tmpBitmap.Clear(color32(FScheme.EditCol));
  tmpBitmap.Font.Assign(FSwatchFont);

  // Create swatches
  For i := 0 to Pred(FSwatches.Count) do begin

    r := Rect(x+FSwatchSpacing,y,x+FSwatchWidth+FSwatchSpacing,y+FSwatchHeight);
    //tmpBitmap.SetSize(FWidth,r.Bottom+4);

    // Calc Width
    if ((FSwatches.Item[i].ColorName <> '') and (FShowCaptions)) then begin
      tw := tmpBitmap.Canvas.TextWidth(FSwatches.Item[i].ColorName);
      r.Right := r.Left + tw+ FSwatchWidth+(FSwatchSpacing*2);
    end else
      r.Right := r.Left+FSwatchWidth;

    Swatches.Item[i].FSwatchRect := r;
    DrawSwatch(tmpBitmap,FSwatches.Item[i]);

    // check next
    if (i+1 <  FSwatches.Count) then begin
      tw := tmpBitmap.Canvas.TextWidth(FSwatches.Item[i+1].ColorName);
        swatchWidth := tw+FSwatchWidth+(FSwatchSpacing)+(R.Right-R.Left);
    end;

    // New line?
    if (x + (swatchWidth+FSwatchSpacing) >= (w-(FSwatchSpacing*2))) then begin
      x := 0;
      y := y + FSwatchHeight + FSwatchSpacing;
    end else
      x := (x + (r.Right-r.Left)) + FSwatchSpacing;

  end;

  Finally
    tmpBitmap.EndUpdate;

    FCachedBitmap.BeginUpdate;

    FCachedBitmap.SetSize(w,y+FSwatchHeight+FSwatchSpacing);
    tmpBitmap.DrawTo(FCachedBitmap,0,0,Rect(0,0,w,y+FSwatchHeight+FSwatchSpacing));

    If Assigned(FOnUpdateSwatchBitmap) then
      FOnUpdateSwatchBitmap(Self,FCachedBitmap);
  End;
end;

procedure TSharpESwatchManager.LoadOptions(AFileName: String);
var
  xml:TJvSimpleXML;
begin
  if FileExists(AFileName) then begin
    xml := TJvSimpleXML.Create(nil);
    xml.LoadFromFile(AFileName);
    Try
      if xml.Root.Name <> 'SharpESwatchCollectionOptions' then
        exit;

      FShowCaptions := xml.Root.Items.ItemNamed['Options'].
        Items.ItemNamed['ShowSwatchText'].BoolValue;

      FSortMode := TSharpESwatchCollectionSortType(xml.Root.Items.
        ItemNamed['Options'].Items.ItemNamed['SortMode'].IntValue);

    Finally
      xml.Free;
    End;
  End;
end;

procedure TSharpESwatchManager.DeselectAll;
var
  i:Integer;
begin
  For i := 0 to Pred(FSwatches.Count) do begin
    FSwatches.Item[i].Selected := False;
  end;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.SelectAll;
var
  i:Integer;
begin
  For i := 0 to Pred(FSwatches.Count) do begin
    FSwatches.Item[i].Selected := True;
  end;

  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.Resize;
begin
  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.DrawSwatch(ABitmap: TBitmap32;
  ASwatch: TSharpESwatchCollectionItem);
var
  p: TArrayOfFixedPoint;
  hp, wp : Integer;
  tmpOutline, tmpPoly: TPolygon32;
  poly: TPolygon32;

  x, y, w, h: Integer;
  rTextBorder, rText,r : TRect;
begin
  x := ASwatch.SwatchRect.Left;
  y := ASwatch.SwatchRect.Top;
  w := FSwatchWidth;
  h := FSwatchHeight;
  r := ASwatch.SwatchRect;

  poly := TPolygon32.Create;
  poly.Antialiased := True;
  poly.AntialiasMode := am32times;
  poly.Add(FixedPoint(x,y));
  poly.Add(FixedPoint(x+w,y));
  poly.Add(FixedPoint(x+w,y+h));

  if ASwatch.Selected then begin
    wp := w div 4;
    hp := h div 3;
    poly.Add(FixedPoint(x+w-wp,y+h));
    poly.Add(FixedPoint(x+w-wp*2,y+h-hp));
    poly.Add(FixedPoint(x+w-wp*3,y+h));
  end;

  poly.Add(FixedPoint(x,y+h));
  poly.Add(FixedPoint(x,y));

  tmpPoly := poly.Outline;
  tmpOutline := tmpPoly.Grow(Fixed(0.1/10),255);
  tmpOutline.FillMode := pfWinding;
  tmpPoly.Free;

  tmpOutline.Antialiased := true;
  tmpOutline.AntialiasMode := am32times;


  poly.drawFill(ABitmap,Color32(ASwatch.Color));

  tmpOutline.DrawEdge(ABitmap,SetAlpha(color32(darker(ASwatch.Color,30)), 255));

  // Draw text
  if ((ASwatch.ColorName <> '') and (FShowCaptions)) then begin

      rTextBorder := Rect(r.Left+FSwatchWidth-1,
      r.Top,r.Right,r.Bottom+1);
      ABitmap.FillRectS(rTextBorder,Color32(clWhite));
      ABitmap.FrameRectS(rTextBorder,Color32(Darker(ASwatch.Color,40)));

      rText := Rect(rTextBorder.Left+4,rTextBorder.Top,
      rTextBorder.Right,rTextBorder.Bottom);

    ABitmap.Font.Assign(SwatchFont);
    ABitmap.Textout(rText,DT_SINGLELINE+DT_VCENTER+DT_LEFT,ASwatch.ColorName);

    end;
end;

function TSharpESwatchManager.GetCollectionList(AC: TCollection): TList;
var
  M: TMethod;
  L: TList absolute M;
  P: Pointer;
begin
  // offset of FItemClass
  P := @AC.ItemClass;
  // add size of FItemClass
  inc(Integer(P), SizeOf(TCollectionItemClass));
  // now P point to FItems
  M := TMethod(P^);
  Result := L;
end;

procedure TSharpESwatchManager.SetWidth(const Value: Integer);
begin
  FWidth := Value;

  CreateSwatchBitmap;
end;

constructor TSharpESwatchManager.Create(AOwner: TComponent);
begin
  inherited;

  FSwatchHeight := 16;
  FSwatchWidth := 16;
  FSwatchSpacing := 4;
  FSortMode := sortName;
  FWidth := 100;
  FUpdate := True;
  FShowCaptions := True;

  FSwatchFont := TFont.Create;

  FSwatches := TSharpESwatchCollectionItems.Create(Self);
  FScheme := TSharpECenterScheme.Create(Self);
  FSwatchTextBorderColor := FScheme.EditBordCol;
  FCachedBitmap := TBitmap32.Create;

end;

function TSharpESwatchManager.GetWidth: Integer;
begin
  if Assigned(FOnGetWidth) then
    FOnGetWidth(Self,FWidth);

  if FWidth <= 0 then
    FWidth := 100;

  Result := FWidth;


end;

procedure TSharpESwatchManager.Loaded;
var
  s:String;
begin
  inherited;

  // Load options
  if Not(csDesigning in ComponentState) then begin
    s := GetSharpeUserSettingsPath+cXmlOptionsFile;
    LoadOptions(s);

    s := GetSharpeUserSettingsPath+cXmlDefaultSwatchFile;
    Load(s);
  end;
end;

procedure TSharpESwatchManager.SetItemSelected(APoint: TPoint);
var
  i:Integer;
  r:TRect;
begin
  For i := 0 to Pred(Swatches.Count) do begin
    r := Swatches.Item[i].SwatchRect;
    if ((APoint.X > r.Left) and (APoint.X < r.Right) and
      (APoint.Y > r.Top) and (APoint.Y < r.Bottom)) then begin
        Swatches.Item[i].Selected := Not(Swatches.Item[i].Selected);
        CreateSwatchBitmap;
      end;
  end;
end;

function TSharpESwatchManager.GetItemFromPoint(
  APoint: TPoint): TSharpESwatchCollectionItem;
var
  i:Integer;
  r:TRect;
begin
  Result := nil;
  For i := 0 to Pred(Swatches.Count) do begin
    r := Swatches.Item[i].SwatchRect;
    if ((APoint.X > r.Left) and (APoint.X < r.Right) and
      (APoint.Y > r.Top) and (APoint.Y < r.Bottom)) then begin
        Result := FSwatches.Item[i];
        break;
      end;
  end;
end;

procedure TSharpESwatchManager.EndUpdate;
begin
  FUpdate := True;
  CreateSwatchBitmap;
end;

procedure TSharpESwatchManager.BeginUpdate;
begin
  CreateSwatchBitmap;
  FUpdate := False;
end;

procedure TSharpESwatchManager.BeforeDestruction;
var
  s:String;
begin
  inherited;

  if Not(csDesigning in ComponentState) then begin
    s := GetSharpeUserSettingsPath+cXmlOptionsFile;
    SaveOptions(s);

    s := GetSharpeUserSettingsPath+cXmlDefaultSwatchFile;
    Save(s);
  end;
end;

end.
