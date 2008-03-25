unit SharpETabList;

interface

uses
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  GR32,
  GR32_Image,
  GR32_Layers,
  ExtCtrls,
  PngImageList,
  JclFileUtils;

type
  TTabItem = class(TCollectionItem)
  private
    FCaption: string;
    FTabRect: Trect;
    FStatus: string;
    FImageIndex: Integer;
    FVisible: Boolean;
    procedure SetImageIndex(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetStatus(const Value: string);
  public
    constructor Create(Collection: TCollection); override;
    procedure SetCollection(Value: TCollection); override;

  published
    property Caption: string read FCaption write SetCaption;
    property Status: string read FStatus write SetStatus;
    property TabRect: Trect read FTabRect write FTabRect;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Visible: Boolean read FVisible write SetVisible;

  end;

  TButtonItem = class(TCollectionItem)
  private
    FCaption: string;
    FButtonRect: Trect;
    FImageIndex: Integer;
    FVisible: Boolean;
    procedure SetImageIndex(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetCaption(const Value: string);
    property Caption: string read FCaption write SetCaption;
  public
    constructor Create(Collection: TCollection); override;
    procedure SetCollection(Value: TCollection); override;

  published

    property ButtonRect: Trect read FButtonRect write FButtonRect;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property Visible: Boolean read FVisible write SetVisible;

  end;

type
  TTabItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TTabItem;
  public
    function Add: TTabItem;
    property Item[Index: Integer]: TTabItem read GetItem;
  end;

  TButtonItems = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TButtonItem;
  public
    function Add: TButtonItem;
    property Item[Index: Integer]: TButtonItem read GetItem;
  end;

type
  TSharpETabClick = procedure(ASender: TObject; const ATabIndex: Integer) of object;
  TSharpEBtnClick = procedure(ASender: TObject; const ABtnIndex: Integer) of object;

  TSharpETabChange = procedure(ASender: TObject; const ATabIndex: Integer; var AChange: Boolean) of object;
type
  TSharpETabList = class(TCustomPanel)
  private
    FTabList: TTabItems;
    FTabIndex: Integer;
    FTabWidth: Integer;
    FtabColor: TColor;
    FBkgColor: TColor;
    FTabSelectedColor: TColor;
    FTextSpacing: Integer;
    FOnTabChange: TSharpETabChange;
    FMouseOverID: Integer;
    FTimer: TTimer;
    FImage32: Timage32;
    FAutoSizeTabs: Boolean;
    FCaptionSelectedColor: TColor;
    FCaptionUnSelectedColor: TColor;
    FStatusSelectedColor: TColor;
    FStatusUnSelectedColor: TColor;
    FPngImageList: TPngImageList;
    FBorderColor: TColor;
    FBorder: Boolean;
    FBottomBorder: Boolean;
    FBorderSelectedColor: TColor;
    FOnTabClick: TSharpETabClick;
    FTabAlign: TLeftRight;
    FMinimized: Boolean;
    FButtons: TButtonItems;
    FButtonWidth: Integer;
    FOnBtnClick: TSharpEBtnClick;
    FIconSpacingX: Integer;
    FIconSpacingY: Integer;

    function GetCount: Integer;
    procedure SetTabIndex(const Value: Integer);
    procedure SetTabWidth(const Value: Integer);
    procedure SetBkgColor(const Value: TColor);
    procedure SetTabColor(const Value: TColor);
    procedure SetTabSelectedColor(const Value: TColor);

    procedure MouseDownEvent(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);

    procedure MouseMoveEvent(Sender: TObject; Shift: TShiftState;
      X, Y: Integer; Layer: TCustomLayer);

    function WithinRect(AX, AY: Integer; ARect: TRect): Boolean;
    procedure SetAutoSizeTabs(const Value: Boolean);

    procedure SetBorder(const Value: Boolean);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderSelectedColor(const Value: TColor);
    procedure SetTabAlign(const Value: TLeftRight);
    procedure SetBottomBorder(const Value: boolean);
    procedure SetMinimized(const Value: Boolean);

    procedure DrawButtons();
    function GetButtonsWidth: Integer;
    procedure SetButtonWidth(const Value: Integer);
    function GetTabWidth(ATab: TTabItem): Integer;
    function GetMaxVisibleTabs: Integer;
  protected
    procedure DrawTab(ATabRect: TRect; ATabItem: TTabItem);
    procedure DrawButton(AButtonRect: TRect; AButton: TButtonItem);
    procedure Loaded; override;

  public

    function ClickTab(ATabItem: TTabItem): Boolean; overload;
    function ClickTab(ATabID: Integer): Boolean; overload;

    function Add: TTabItem; overload;
    function Add(ATabCaption: string; ATabImageIndex: Integer = -1;
      ATabStatus: string = ''): TTabItem; overload;
    function Index(ATabItem: TTabItem): Integer;

    procedure Delete(ATabItem: TTabItem);
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;

    procedure Clear;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    property Visible;
    property Font;
    property ParentFont;

    property OnTabChange: TSharpETabChange read FOnTabChange write FOnTabChange;
    property OnTabClick: TSharpETabClick read FOnTabClick write FOnTabClick;
    property OnBtnClick: TSharpEBtnClick read FOnBtnClick write FOnBtnClick;

    property Count: Integer read GetCount;
    property TabWidth: Integer read FTabWidth write SetTabWidth;
    property ButtonWidth: Integer read FButtonWidth write SetButtonWidth;
    property TabIndex: Integer read FTabIndex write SetTabIndex;

    property TabColor: TColor read FtabColor write SetTabColor;
    property TabSelectedColor: TColor read FTabSelectedColor write SetTabSelectedColor;
    property BkgColor: TColor read FBkgColor write SetBkgColor;
    property CaptionSelectedColor: TColor read FCaptionSelectedColor write FCaptionSelectedColor;
    property StatusSelectedColor: TColor read FStatusSelectedColor write FStatusSelectedColor;
    property CaptionUnSelectedColor: TColor read FCaptionUnSelectedColor write FCaptionUnSelectedColor;
    property StatusUnSelectedColor: TColor read FStatusUnSelectedColor write FStatusUnSelectedColor;

    property TabAlign: TLeftRight read FTabAlign write SetTabAlign;
    property TextSpacing: Integer read FTextSpacing write FTextSpacing;
    property IconSpacingX: Integer read FIconSpacingX write FIconSpacingX;
    property IconSpacingY: Integer read FIconSpacingY write FIconSpacingY;

    property AutoSizeTabs: Boolean read FAutoSizeTabs write SetAutoSizeTabs;

    property BottomBorder: Boolean read FBottomBorder write SetBottomBorder;
    property Border: Boolean read FBorder write SetBorder;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property BorderSelectedColor: TColor read FBorderSelectedColor write SetBorderSelectedColor;

    property PngImageList: TPngImageList read
      FPngImageList write FPngImageList;

    property TabList: TTabItems read FTabList write FTabList;
    property Buttons: TButtonItems read FButtons write FButtons;
    property Minimized: Boolean read FMinimized write SetMinimized;

  end;

procedure Register;

implementation

uses Types;

{ TSharpETabListItems }

function TTabItems.Add: TTabItem;
begin
  result := inherited Add as TTabItem;
end;

function TTabItems.GetItem(Index: Integer): TTabItem;
begin
  result := inherited Items[Index] as TTabItem;
end;

{ TSharpETabList }

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpETabList]);
end;

function TSharpETabList.Add(ATabCaption: string; ATabImageIndex: Integer = -1;
  ATabStatus: string = ''): TTabItem;
var
  tmp: TTabItem;
begin
  tmp := FTabList.Add;
  tmp.Caption := ATabCaption;
  tmp.Status := ATabStatus;
  tmp.ImageIndex := ATabImageIndex;
  tmp.Visible := True;
  Result := tmp;

  //FTabList.Add  Add(Result);
end;

function TSharpETabList.Add: TTabItem;
var
  tmp: TTabItem;
begin
  tmp := FTabList.Add;
  tmp.Caption := '';
  tmp.Status := '';
  tmp.Visible := True;
  Result := tmp;
end;

constructor TSharpETabList.Create(AOwner: TComponent);
begin
  inherited;

  Self.BevelInner := bvNone;
  Self.BevelOuter := bvNone;

  FTabList := TTabItems.Create(Self, TTabItem);
  FButtons := TButtonItems.Create(Self, TButtonItem);

  FMouseOverID := -1;

  FBottomBorder := True;

  FTabWidth := 62;
  FButtonWidth := 24;
  FTabColor := $00EFEFEF;
  FTabSelectedColor := $00C0F1E6;
  FCaptionUnSelectedColor := clBlack;
  FStatusUnSelectedColor := clGreen;
  FStatusSelectedColor := clGreen;
  FBkgColor := clWindow;
  Height := 25;
  FTextSpacing := 8;
  FIconSpacingX := 4;
  FIconSpacingY := 4;
  FAutoSizeTabs := True;
  FTabAlign := taLeftJustify;

  Fimage32 := Timage32.Create(self);
  FImage32.Parent := Self;
  Fimage32.Align := alClient;
  FImage32.OnMouseUp := MouseDownEvent;
  FImage32.OnMouseMove := MouseMoveEvent;

end;

procedure TSharpETabList.Delete(ATabItem: TTabItem);
var
  i: Integer;
begin
  for i := 0 to Pred(Count) do
  begin
    if FTabList.Item[i] = ATabItem then
    begin
      FTabList.Delete(Index(ATabItem));
      Invalidate;
      break;
    end;
  end;

end;

procedure TSharpETabList.DrawButton(AButtonRect: TRect;
  AButton: TButtonItem);
var
  iButtonWidth, iIconWidth, iCaptionWidth: Integer;
  s: string;
begin
  iButtonWidth := AButtonRect.Right - AButtonRect.Left;

  // Get icon width
  if ((Assigned(FPngImageList)) and (AButton.ImageIndex >= 0) and
    (AButton.ImageIndex <= FPngImageList.Count - 1)) then
    iIconWidth := PngImageList.PngImages[AButton.ImageIndex].PngImage.Width
  else
    iiconWidth := 0;

  // Get caption width
  iCaptionWidth := iButtonWidth - iIconWidth;

  // Draw image
  if iIconWidth <> 0 then
  begin
    FPngImageList.PngImages[AButton.ImageIndex].PngImage.Draw(FImage32.Bitmap.Canvas,
      Rect(FIconSpacingX + AButtonRect.Left, FIconSpacingY + AButtonRect.Top,
      FIconSpacingX + iIconWidth + AButtonRect.Left,
      FIconSpacingY + iIconWidth + AButtonRect.Top));
  end;

  FImage32.Bitmap.Font.Assign(Self.Font);
  FImage32.Bitmap.Font.Style := [];

  // Caption Color
  if FTabIndex = AButton.Index then
    FImage32.Bitmap.Font.Color := FCaptionSelectedColor
  else
    FImage32.Bitmap.Font.Color := FCaptionUnSelectedColor;

  // Draw Caption Text
  s := PathCompactPath(FImage32.Bitmap.Canvas.Handle, AButton.Caption,
    iCaptionWidth + 12, cpEnd);

  FImage32.Bitmap.Textout(AButtonRect.Left + FTextSpacing + iIconWidth,
    FTextSpacing, s);

end;

procedure TSharpETabList.DrawButtons;
var
  i, x: Integer;
  br: TRect;
begin
  if FTabAlign = taLeftJustify then
    x := 0
  else
    x := (Self.Width - GetButtonsWidth);

  for i := 0 to Pred(FButtons.Count) do
  begin

    if FTabAlign = taLeftJustify then
    begin
      if FButtons.Item[i].Visible then
      begin
        br := Rect(x, 4, x + FButtonWidth, Height);
        FButtons.Item[i].ButtonRect := br;
        DrawButton(br, FButtons.Item[i]);
        x := x + FButtonWidth + 2;
      end;

    end
    else
    begin
      if FButtons.Item[i].Visible then
      begin
        br := Rect(x - FButtonWidth, 4, x, Height);
        FButtons.Item[i].ButtonRect := br;
        DrawButton(br, FButtons.Item[i]);
        x := x - FButtonWidth - 2;
      end;
    end;

  end;
end;

procedure TSharpETabList.DrawTab(ATabRect: TRect; ATabItem: TTabItem);
var
  iTabWidth, iIconWidth, {iIconHeight, } iStatusWidth, iCaptionWidth: Integer;
  s: string;
begin
  iTabWidth := ATabRect.Right - ATabRect.Left;
  // Get icon width
  if ((Assigned(FPngImageList)) and (ATabItem.ImageIndex >= 0) and
    (ATabItem.ImageIndex <= FPngImageList.Count - 1)) then
    iIconWidth := PngImageList.PngImages[ATabItem.ImageIndex].PngImage.Width
  else
    iiconWidth := 0;

  // Get status text width
  iStatusWidth := FImage32.Bitmap.TextWidth(ATabItem.Status);

  // Get caption width
  iCaptionWidth := iTabWidth - iIconWidth - iStatusWidth;

  // Tab Colour
  if ATabItem.Index = FTabIndex then
  begin
    FImage32.Bitmap.Canvas.Brush.Color := FTabSelectedColor;

    if FBorder then
      FImage32.Bitmap.Canvas.Pen.Color := FBorderSelectedColor
    else
      FImage32.Bitmap.Canvas.Pen.Color := FTabSelectedColor;
  end
  else
  begin
    FImage32.Bitmap.Canvas.Brush.Color := FtabColor;

    if FBorder then
      FImage32.Bitmap.Canvas.Pen.Color := FBorderColor
    else
      FImage32.Bitmap.Canvas.Pen.Color := FtabColor;
  end;

  if FMinimized then
    RoundRect(FImage32.Bitmap.Canvas.Handle, ATabRect.Left, ATabRect.Top, ATabRect.Right, ATabRect.bottom - 1, 10, 10)
  else
    RoundRect(FImage32.Bitmap.Canvas.Handle, ATabRect.Left, ATabRect.Top, ATabRect.Right, ATabRect.bottom + 5, 10, 10);

  // Draw Tab Bottom Border
  if FBorder and FBottomBorder then
    if FTabIndex = ATabItem.Index then
      FImage32.Bitmap.Line(ATabRect.Left + 1, ATabRect.Bottom - 1, ATabRect.Right - 1, ATabRect.Bottom - 1, Color32(FTabSelectedColor))
    else
      FImage32.Bitmap.Line(ATabRect.Left, ATabRect.Bottom - 1, ATabRect.Right, ATabRect.Bottom - 1, Color32(FBorderColor));

  // Draw image
  if iIconWidth > 0 then
  begin
    FPngImageList.PngImages[ATabItem.ImageIndex].PngImage.Draw(FImage32.Bitmap.Canvas,
      Rect(FIconSpacingX + ATabRect.Left, FIconSpacingY + ATabRect.Top,
      (FIconSpacingX*2) + iIconWidth + ATabRect.Left,
      FIconSpacingY + iIconWidth + ATabRect.Top));
  end;

  FImage32.Bitmap.Font.Assign(Self.Font);

  FImage32.Bitmap.Font.Style := [];

  // Caption Color
  if FTabIndex = ATabItem.Index then
    FImage32.Bitmap.Font.Color := FCaptionSelectedColor
  else
    FImage32.Bitmap.Font.Color := FCaptionUnSelectedColor;

  // Draw Caption Text
  s := PathCompactPath(FImage32.Bitmap.Canvas.Handle, ATabItem.Caption,
    iCaptionWidth + FTextSpacing * 2, cpEnd);

  if iIconWidth = 0 then
    FImage32.Bitmap.Textout(ATabrect.Left + FTextSpacing + iIconWidth,
      FTextSpacing, s)
  else
    FImage32.Bitmap.Textout(ATabrect.Left + iIconWidth + (FIconSpacingX * 2),
      FTextSpacing, s);

  // Status Text Color
  if FTabIndex = ATabItem.Index then
    FImage32.Bitmap.Font.Color := FStatusSelectedColor
  else
    FImage32.Bitmap.Font.Color := FStatusUnSelectedColor;

  // Draw Status Text
  FImage32.Bitmap.Textout(ATabrect.Right - iStatusWidth - FTextSpacing, FTextSpacing,
    ATabItem.Status);

end;

function TSharpETabList.GetButtonsWidth: Integer;
var
  i, nVisible: Integer;
begin
  Result := 0;
  nVisible := 0;
  for i := 0 to Pred(FButtons.Count) do
  begin
    if FButtons.Item[i].Visible then
    begin
      Result := Result + FButtonWidth + FIconSpacingX;
      inc(nVisible);
    end;
  end;
  if nVisible > 0 then
    Result := Result + FIconSpacingX;
end;

function TSharpETabList.GetCount: Integer;
begin
  Result := FTabList.Count;
end;

function TSharpETabList.GetMaxVisibleTabs: Integer;
var
  iTab, iTabsWidth, iTabWidth, iMaxTabs, iMaxWidth: Integer;
begin
  iMaxWidth := Self.Width - GetButtonsWidth;
  iTabsWidth := 0;
  iMaxTabs := 0;

  for iTab := 0 to Pred(Count) do
  begin
    iTabWidth := GetTabWidth(TabList.Item[iTab]);
    iTabsWidth := iTabsWidth + iTabWidth;

    if iTabsWidth > iMaxWidth then
    begin
      Result := iMaxTabs;
      exit;
    end
    else
      Inc(iMaxTabs, 1);
  end;

  Result := iMaxTabs;
end;

function TSharpETabList.GetTabWidth(ATab: TTabItem): Integer;
var
  iIconWidth, iStatusWidth: Integer;
  iCaptionWidth: integer;
begin
  iStatusWidth := 0;
  iIconWidth := 0;
  iCaptionWidth := 0;

  // Does tab have image?
  if ((Assigned(FPngImageList)) and (ATab.ImageIndex >= 0) and
    (ATab.ImageIndex <= FPngImageList.Count - 1)) then
  begin
    iIconWidth := PngImageList.PngImages[ATab.ImageIndex].PngImage.Width;
    iIconWidth := iIconWidth + (FIconSpacingX * 2);
  end;

  // Does tab have status?
  if ATab.Status <> '' then
  begin
    iStatusWidth := FImage32.Bitmap.TextWidth(ATab.Status);
    iStatusWidth := iStatusWidth + (FTextSpacing);
  end;

  // Does tab have text?
  if ATab.Caption <> '' then
  begin
    iCaptionWidth := FImage32.Bitmap.TextWidth(ATab.Caption);

    if iIconWidth = 0 then
      iCaptionWidth := iCaptionWidth + (FTextSpacing*2) else
      iCaptionWidth := iCaptionWidth + (FTextSpacing)
  end;

  Result := iIconWidth + iStatusWidth + iCaptionWidth;
end;

function TSharpETabList.Index(ATabItem: TTabItem): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to Pred(Count) do
  begin
    if FTabList.Item[i] = ATabItem then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure TSharpETabList.Loaded;
begin
  inherited;
  Invalidate;
end;

procedure TSharpETabList.MouseDownEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  i: Integer;
  bChange: Boolean;
begin
  for i := 0 to Pred(FButtons.Count) do
  begin

    if WithinRect(X, Y, FButtons.Item[i].ButtonRect) then
    begin
      Invalidate;

      if assigned(FOnBtnClick) then
        FOnBtnClick(Self, i);

      break;
    end;
  end;

  if Count = 0 then
    exit;
  for i := 0 to Pred(FTabList.Count) do
  begin

    if WithinRect(X, Y, FTabList.Item[i].TabRect) then
    begin
      Invalidate;

      bChange := True;
      if Assigned(FOnTabChange) then
        FOnTabChange(Self, i, bChange);

      if bChange then
      begin

        TabIndex := i;
        if assigned(FOnTabClick) then
          FOnTabClick(Self, i);

      end;
      break;
    end;
  end;
end;

procedure TSharpETabList.MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var
  i: Integer;
  r: TRect;
  tmpTab: TTabItem;
begin
  FImage32.Cursor := crDefault;

  FMouseOverID := -1;
  for i := 0 to Pred(FTabList.Count) do
  begin

    tmpTab := FTabList.Item[i];
    r := tmpTab.TabRect;

    if WithinRect(X, Y, r) then
    begin
      FMouseOverID := i;
      Invalidate;

      FImage32.Cursor := crHandPoint;
      break;
    end;
  end;

  for i := 0 to Pred(FButtons.Count) do
  begin

    if WithinRect(X, Y, FButtons.Item[i].ButtonRect) then
    begin
      Invalidate;

      FImage32.Cursor := crHandPoint;

      break;
    end;
  end;
end;

procedure TSharpETabList.Paint;
var
  x: Integer;
  iDrawCount, i, iTabWidth: Integer;
  tr: TRect;
begin
  inherited;
  if ((Height <= 0) or (Width <= 0)) then
    exit;

  FImage32.Bitmap.Setsize(Self.ClientWidth, Self.Height);
  FImage32.Bitmap.Clear(Color32(FBkgColor));

  // Draw bottom line
  if FBorder and FBottomBorder then
  begin
    if FTabAlign = taLeftJustify then
      FImage32.Bitmap.Line(0, Self.Height - 1, Self.ClientWidth - 4, Self.Height - 1, Color32(FBorderColor))
    else
      FImage32.Bitmap.Line(4, Self.Height - 1, Self.ClientWidth, Self.Height - 1, Color32(FBorderColor))
  end;

  // Draw buttons
  DrawButtons;

  // If number of tabs is 0 then exit;
  if Count = 0 then
    exit;

  // What allignment?
  if FTabAlign = taLeftJustify then
    x := GetButtonsWidth
  else
    x := Self.ClientWidth - GetButtonsWidth;

  // How many are visible
  iDrawCount := GetMaxVisibleTabs;

  for i := 0 to Pred(iDrawCount) do
  begin

    iTabWidth := GetTabWidth(FTabList.Item[i]);

    if FTabAlign = taLeftJustify then
    begin
      if FTabList.Item[i].Visible then
      begin
        tr := Rect(x, 4, x + iTabWidth, Height);
        FTabList.Item[i].TabRect := tr;
        DrawTab(tr, FTabList.Item[i]);
        x := x + iTabWidth + 2;
      end;

    end
    else
    begin
      if FTabList.Item[i].Visible then
      begin
        tr := Rect(x - iTabWidth, 4, x, Height);
        FTabList.Item[i].TabRect := tr;
        DrawTab(tr, FTabList.Item[i]);
        x := x - iTabWidth - 2;
      end;
    end;
  end;
end;

procedure TSharpETabList.SetAutoSizeTabs(const Value: Boolean);
begin
  FAutoSizeTabs := Value;
  Invalidate;
end;

procedure TSharpETabList.SetBkgColor(const Value: TColor);
begin
  FBkgColor := Value;
  Invalidate;
end;

procedure TSharpETabList.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TSharpETabList.SetBottomBorder(const Value: Boolean);
begin
  FBottomBorder := Value;
  Invalidate;
end;

procedure TSharpETabList.SetButtonWidth(const Value: Integer);
begin
  FButtonWidth := Value;
  Invalidate;
end;

procedure TSharpETabList.SetMinimized(const Value: Boolean);
begin
  FMinimized := Value;
  Invalidate;
end;

procedure TSharpETabList.SetBorder(const Value: Boolean);
begin
  FBorder := Value;
  Invalidate;
end;

procedure TSharpETabList.SetTabColor(const Value: TColor);
begin
  FtabColor := Value;
  Invalidate;
end;

procedure TSharpETabList.SetTabIndex(const Value: Integer);
var
  bChange: Boolean;
begin
  bChange := True;

  if Assigned(FOnTabChange) then
    FOnTabChange(Self, Value, bChange);

  if bChange then
    FTabIndex := Value;

  Invalidate;
end;

procedure TSharpETabList.SetTabSelectedColor(const Value: TColor);
begin
  FTabSelectedColor := Value;
  Invalidate;
end;

procedure TSharpETabList.SetTabWidth(const Value: Integer);
begin
  FTabWidth := Value;
  Invalidate;
end;

function TSharpETabList.WithinRect(AX, AY: Integer; ARect: TRect): Boolean;
begin
  Result := False;

  if (AX > ARect.Left) and (AX < ARect.Right) and
    (AY > ARect.Top) and (AY < ARect.Bottom) then
    Result := True;
end;

procedure TSharpETabList.Clear;
var
  i: integer;
  AList, OrgList: TList;
begin
  AList := TList.Create;
  try
    OrgList := TList(PDWORD(DWORD(FTabList) + $4 +
      SizeOf(TPersistent))^);

    { Save original pointers to collection items }
    for i := 0 to OrgList.Count - 1 do
      AList.Add(OrgList[i]);

    OrgList.Clear;

  finally
    AList.Free;
    Self.Invalidate;
  end;
end;

procedure TSharpETabList.SetBorderSelectedColor(const Value: TColor);
begin
  FBorderSelectedColor := Value;
  Invalidate;
end;

function TSharpETabList.ClickTab(ATabID: Integer): Boolean;
begin
  Result := False;
  if ((ATabID = -1) or (ATabID > Self.Count - 1)) then
    exit;

  MouseDownEvent(Self, mbLeft, [], TabList.Item[ATabID].TabRect.Left + 1,
    TabList.Item[ATabID].TabRect.Top + 1, nil);
  Result := True;
end;

function TSharpETabList.ClickTab(ATabItem: TTabItem): Boolean;
begin
  Result := False;
  if ATabItem = nil then
    exit;

  MouseDownEvent(Self, mbLeft, [], ATabItem.TabRect.Left + 1, ATabItem.TabRect.Top + 1, nil);
  Result := True;
end;

procedure TSharpETabList.SetTabAlign(const Value: TLeftRight);
begin
  FTabAlign := Value;
  Invalidate;
end;

destructor TSharpETabList.Destroy;
begin
  FImage32.Free;
  FTimer.Free;

  inherited;

end;

{ TSharpETabListItem }

constructor TTabItem.Create(Collection: TCollection);
begin
  inherited;
  FImageIndex := -1;
  FCaption := '';
  FStatus := '';
  FVisible := True;

  TSharpETabList(Collection.Owner).Invalidate;

end;

procedure TTabItem.SetCaption(const Value: string);
begin
  FCaption := Value;
  TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TTabItem.SetCollection(Value: TCollection);
begin
  inherited;
end;

procedure TTabItem.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TTabItem.SetStatus(const Value: string);
begin
  FStatus := Value;
  TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TTabItem.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  FTabRect := Rect(0, 0, 0, 0);
end;

{ TButtonItem }

constructor TButtonItem.Create(Collection: TCollection);
begin
  inherited;
  FImageIndex := -1;
  FCaption := '';
  FVisible := True;

  TSharpETabList(Collection.Owner).Invalidate;

end;

procedure TButtonItem.SetCaption(const Value: string);
begin
  FCaption := Value;
  TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TButtonItem.SetCollection(Value: TCollection);
begin
  inherited;

end;

procedure TButtonItem.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
  TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TButtonItem.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  FButtonRect := Rect(0, 0, 0, 0);
end;

{ TButtonItems }

function TButtonItems.Add: TButtonItem;
begin
  result := inherited Add as TButtonItem;
end;

function TButtonItems.GetItem(Index: Integer): TButtonItem;
begin
  result := inherited Items[Index] as TButtonItem;
end;

end.

