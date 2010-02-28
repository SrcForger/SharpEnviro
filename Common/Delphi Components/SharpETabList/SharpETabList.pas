unit SharpETabList;

interface

uses
  Windows,
  Messages,
  Classes,
  Graphics,
  Controls,
  Forms,
  Menus,
  GR32,
  GR32_Image,
  GR32_Layers,
  ExtCtrls,
  PngImageList,
  JclFileUtils;

type
  TTabExtents = record
    TabRect: TRect;
    IconRect: TRect;
    CaptionRect: TRect;
    StatusRect: TRect;
    TabWidth: Integer;
    IconWidth: Integer;
    CaptionWidth: Integer;
    StatusWidth: Integer;
  end;

type
  TTabItem = class(TCollectionItem)
  private
    FCaption: string;
    FTabExtent: TTabExtents;
    FStatus: string;
    FImageIndex: Integer;
    FVisible: Boolean;
    FData: TObject;
    procedure SetImageIndex(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetStatus(const Value: string);
  public
    constructor Create(Collection: TCollection); override;
    procedure SetCollection(Value: TCollection); override;
    property Data: TObject read FData write FData;
  published
    property Caption: string read FCaption write SetCaption;
    property Status: string read FStatus write SetStatus;
    property TabExtent: TTabExtents read FTabExtent write FTabExtent;
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
    FOnTabChange: TSharpETabChange;
    FMouseOverID: Integer;
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
    FTextSpacingX: Integer;
    FTextSpacingY: Integer;
    FLeftIndex: Integer;
    FRightIndex : Integer;
    FLastTabRight: Integer;
    FDisplayedTabs: Integer;
    FScrollLeft: TButtonItem;
    FScrollRight: TButtonItem;
    FDownArrow : TButtonItem;
    FTabsMenu : TPopupMenu;
    FScrollButtonImageList: TPngImageList;

    function GetCount: Integer;
    procedure SetTabIndex(const Value: Integer);
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
    procedure DrawScrollButtons(AScrollButtonRect: TRect);
    function GetScrollButtonsWidth: integer;

    function GetButtonsWidth: Integer;
    function GetTabsWidth: Integer;
    procedure SetButtonWidth(const Value: Integer);
    function GetTabWidth(ATab: TTabItem): Integer;
    procedure GetTabExtent(ATab: TTabItem; X, Y: Integer; var ATabExtents: TTabExtents);
    function GetMaxVisibleTabs: Integer;
    function GetVisibleTabCount: Integer;
    procedure SetIconSpacingX(const Value: Integer);
    procedure SetIconSpacingY(const Value: Integer);
    procedure SetTextSpacingX(const Value: Integer);
    procedure SetTextSpacingY(const Value: Integer);
    procedure CreateScrollButtonComponents;
    procedure DrawTabs;
    function GetTabItem(Index: Integer): TTabItem;
    procedure SetTabItem(Index: Integer; const Value: TTabItem);
    procedure miClick(Sender: TObject);

  protected
    procedure DrawTab(ATabItem: TTabItem);
    procedure DrawButton(AButtonRect: TRect;
      var APngImageList: TPngImageList; AButton: TButtonItem);
    procedure Loaded; override;
    procedure Resize; override;
  public

    function ClickTab(ATabItem: TTabItem): Boolean; overload;
    function ClickTab(ATabID: Integer): Boolean; overload;
    procedure ScrollLeft;
    procedure ScrollRight;
    procedure BringTabIntoView(ATabID : Integer);

    function Add: TTabItem; overload;
    function Add(ATabCaption: string; ATabImageIndex: Integer = -1;
      ATabStatus: string = ''): TTabItem; overload;
    function Index(ATabItem: TTabItem): Integer;

    procedure Delete(ATabItem: TTabItem);
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;

    procedure Clear;
    destructor Destroy; override;

    property TabsWidth: Integer read GetTabsWidth;
    property ButtonsWidth: Integer read GetButtonsWidth;

    property TabItem[Index: Integer] : TTabItem
             read GetTabItem write SetTabItem; Default;

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
    property TextSpacingX: Integer read FTextSpacingX write SetTextSpacingX;
    property TextSpacingY: Integer read FTextSpacingY write SetTextSpacingY;
    property IconSpacingX: Integer read FIconSpacingX write SetIconSpacingX;
    property IconSpacingY: Integer read FIconSpacingY write SetIconSpacingY;

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

const
  cLeftArrowIdx = 0;
  cRightArrowIdx = 1;
  cLeftArrowDisabledIdx = 2;
  cRightArrowDisabledIdx = 3;
  cDownArrowIdx = 4;

procedure Register;

implementation

{$R SharpETabList.res}

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
  FTextSpacingX := 8;
  FTextSpacingY := 6;
  FIconSpacingX := 4;
  FIconSpacingY := 4;
  FAutoSizeTabs := True;
  FTabAlign := taLeftJustify;

  Fimage32 := Timage32.Create(self);
  FImage32.Parent := Self;
  Fimage32.Align := alClient;
  FImage32.OnMouseUp := MouseDownEvent;
  FImage32.OnMouseMove := MouseMoveEvent;

  FTabsMenu := TPopupMenu.Create(Self);
  FTabsMenu.Alignment := paRight;
  
  CreateScrollButtonComponents;
  Screen.Cursors[crHandPoint] := LoadCursor(0, IDC_HAND);
end;

destructor TSharpETabList.Destroy;
var
  i : integer;
begin
  for i := FTabsMenu.Items.Count - 1 downto 0 do
    FTabsMenu.Items[i].Free;

  FTabList.Free;
  FButtons.Free;
  FImage32.Free;
  FTabsMenu.Free;
  FScrollButtonImageList.Free;
  FScrollLeft.Free;
  FScrollRight.Free;
  FDownArrow.Free;
  
  inherited;
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
  var APngImageList: TPngImageList; AButton: TButtonItem);
var
  iButtonWidth, iIconWidth, iCaptionWidth: Integer;
  s: string;
begin
  iButtonWidth := AButtonRect.Right - AButtonRect.Left;

  // Get icon width
  if ((Assigned(APngImageList)) and (AButton.ImageIndex >= 0) and
    (AButton.ImageIndex <= APngImageList.PngImages.Count - 1)) then
    iIconWidth := APngImageList.PngImages[AButton.ImageIndex].PngImage.Width
  else
    iiconWidth := 0;

  // Get caption width
  iCaptionWidth := iButtonWidth - iIconWidth;

  // Draw image
  if iIconWidth <> 0 then
  begin
    APngImageList.PngImages[AButton.ImageIndex].PngImage.Draw(FImage32.Bitmap.Canvas,
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

  FImage32.Bitmap.Textout(AButtonRect.Left + FTextSpacingX + iIconWidth,
    FTextSpacingY, s);

end;

procedure TSharpETabList.DrawButtons;
var
  i, x: Integer;
  br: TRect;
begin
  if FTabAlign = taLeftJustify then
    x := 0
  else
    x := (Self.Width);

  for i := 0 to Pred(FButtons.Count) do
  begin
    if FTabAlign = taLeftJustify then
    begin
      if FButtons.Item[i].Visible then
      begin
        br := Rect(x, 4, x + FButtonWidth, Height);
        FButtons.Item[i].ButtonRect := br;
        DrawButton(br, FPngImageList, FButtons.Item[i]);
        x := x + FButtonWidth + 2;
      end;
    end
    else
    begin
      if FButtons.Item[i].Visible then
      begin
        br := Rect(x - FButtonWidth, 4, x, Height);
        FButtons.Item[i].ButtonRect := br;
        DrawButton(br, FPngImageList, FButtons.Item[i]);
        x := x - FButtonWidth - 2;
      end;
    end;
  end;
end;

procedure TSharpETabList.DrawScrollButtons(AScrollButtonRect: TRect);
var
  r: TRect;
  i: Integer;
begin

  r := Rect(AScrollButtonRect.Left, Height div 2 - 6,
    AScrollButtonRect.Left + 16, Self.ClientHeight);

  if (FLeftIndex = 0) then
    // The current left index is zero so disable the scroll button arrow.
    FScrollLeft.ImageIndex := cLeftArrowDisabledIdx
  else
    begin
      FScrollLeft.ImageIndex := cLeftArrowDisabledIdx;
      for i := Pred(FLeftIndex) downto 0 do
        if FTabList.Item[i].Visible then
        begin
          // If there is a visible tab before the left index
          // then enable the scroll button arrow.
          FScrollLeft.ImageIndex := cLeftArrowIdx;
          Break;
        end;
    end;

  FScrollLeft.ButtonRect := r;

  if GetScrollButtonsWidth <> 0 then
    DrawButton(r, FScrollButtonImageList, FScrollLeft);

  r := Rect(FScrollLeft.ButtonRect.Right, Height div 2 - 6,
    FScrollLeft.ButtonRect.Right + 16, ClientHeight);

  // If the maximum number of visible tabs that we can display
  // is greather than or equal to the number of visible tabs
  // that exist then disable the scroll button arrow.
  if ((FLastTabRight >= GetVisibleTabCount)) then
    FScrollRight.ImageIndex := cRightArrowDisabledIdx else
    FScrollRight.ImageIndex := cRightArrowIdx;

  FScrollRight.ButtonRect := r;

  if GetScrollButtonsWidth <> 0 then
    DrawButton(r, FScrollButtonImageList, FScrollRight);

  r := Rect(FScrollRight.ButtonRect.Right, Height div 2 - 6,
    FScrollRight.ButtonRect.Right + 16, ClientHeight);

  FDownArrow.ButtonRect := r;
  FDownArrow.ImageIndex := cDownArrowIdx;
  
  if GetScrollButtonsWidth <> 0 then
    DrawButton(r, FScrollButtonImageList, FDownArrow);
end;

procedure TSharpETabList.DrawTab(ATabItem: TTabItem);
var
  iIconWidth: Integer;
  tabExtents: TTabExtents;
  rTab, rIcon, rCaption, rStatus, r: TRect;
  s: string;
begin
  tabExtents := ATabItem.TabExtent;
  r := tabExtents.TabRect;
  if (R.Left >= 0) then begin

    iiconWidth := tabExtents.IconWidth;
    rtab := tabExtents.TabRect;
    rIcon := tabExtents.IconRect;
    rCaption := tabExtents.CaptionRect;
    rStatus := tabExtents.StatusRect;

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
      RoundRect(FImage32.Bitmap.Canvas.Handle, rtab.Left, rtab.Top, rtab.Right, rtab.bottom - 1, 10, 10)
    else
      RoundRect(FImage32.Bitmap.Canvas.Handle, rtab.Left, rtab.Top, rtab.Right, rtab.bottom + 5, 10, 10);

    // Draw Tab Bottom Border
    if FBorder and FBottomBorder then
      if FTabIndex = ATabItem.Index then
        FImage32.Bitmap.Line(rtab.Left + 1, rtab.Bottom - 1, rtab.Right - 1, rtab.Bottom - 1, Color32(FTabSelectedColor))
      else
        FImage32.Bitmap.Line(rtab.Left, rtab.Bottom - 1, rtab.Right, rtab.Bottom - 1, Color32(FBorderColor));

    // Draw image
    if iIconWidth > 0 then
    begin
      FPngImageList.PngImages[ATabItem.ImageIndex].PngImage.Draw(FImage32.Bitmap.Canvas, rIcon);
    end;

    FImage32.Bitmap.Font.Assign(Self.Font);
    FImage32.Bitmap.Font.Style := [];

    // Caption Color
    if FTabIndex = ATabItem.Index then
      FImage32.Bitmap.Font.Color := FCaptionSelectedColor
    else
      FImage32.Bitmap.Font.Color := FCaptionUnSelectedColor;

    // Draw Caption Text
    s := ATabItem.Caption;
    FImage32.Bitmap.Textout(rCaption.Left, rCaption.Top, s);

    // Status Text Color
    if FTabIndex = ATabItem.Index then
      FImage32.Bitmap.Font.Color := FStatusSelectedColor
    else
      FImage32.Bitmap.Font.Color := FStatusUnSelectedColor;

    // Draw Status Text
    FImage32.Bitmap.Textout(rStatus.Left, rStatus.Top, ATabItem.Status);

  end;
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

  if FTabAlign = taLeftJustify then
    iMaxWidth := Self.Width - GetButtonsWidth - GetScrollButtonsWidth else
    iMaxWidth := Self.Width - GetButtonsWidth - 10;

  iTabsWidth := 0;
  iMaxTabs := 0;

  for iTab := FLeftIndex to Pred(Count) do
  begin
    // Only count tabs that are supposed to be visible.
    if Tablist.Item[iTab].Visible then
    begin
      iTabWidth := GetTabWidth(TabList.Item[iTab]);
      iTabsWidth := iTabsWidth + iTabWidth;

      if iTabsWidth > iMaxWidth then
      begin
        // Once we are passed our limit then exit.
        Result := iMaxTabs;
        exit;
      end
      else
        Inc(iMaxTabs, 1);
    end;
  end;

  Result := iMaxTabs;
end;

function TSharpETabList.GetScrollButtonsWidth: integer;
var
  i: Integer;
  bScroll: Boolean;
begin
  Result := 0;
  bScroll := False;

  // Only display the scroll buttons for left aligned tabs.
  if (FTabAlign = taLeftJustify) then
  begin
    // If there is a visible tab before the current left index
    // then we need to display the scroll buttons.
    if (FLeftIndex > 0) then
      for i := Pred(FLeftIndex) downto 0 do
        if TabItem[i].Visible then
          bScroll := True;
          
    // If the buttons width + the tabs with is greater than the
    // tab list width then we need to display the scroll buttons.
    if (GetButtonsWidth + GetTabsWidth > Self.Width) then
      bScroll := True;

    if bScroll then
      // Left arrow = 16, Right arrown = 16, Down arrow = 16
      Result := 48;
  end;
end;

procedure TSharpETabList.GetTabExtent(ATab: TTabItem; X, Y: Integer; var ATabExtents: TTabExtents);
var
  iIconWidth, iStatusWidth, w: Integer;
  iCaptionWidth: integer;
begin
  iStatusWidth := 0;
  iIconWidth := 0;
  iCaptionWidth := 0;

  ATabExtents.IconRect := Rect(0, 0, 0, 0);
  ATabExtents.StatusRect := Rect(0, 0, 0, 0);
  ATabExtents.CaptionRect := Rect(0, 0, 0, 0);
  ATabExtents.TabRect := Rect(0, 0, 0, 0);
  ATabExtents.TabWidth := 0;
  ATabExtents.IconWidth := 0;
  ATabExtents.CaptionWidth := 0;
  ATabExtents.StatusWidth := 0;

  // Does tab have image?
  if ((Assigned(FPngImageList)) and (ATab.ImageIndex >= 0) and
    (ATab.ImageIndex <= FPngImageList.Count - 1)) then
  begin
    iIconWidth := PngImageList.PngImages[ATab.ImageIndex].PngImage.Width;
    iIconWidth := iIconWidth + (FIconSpacingX * 2);
    ATabExtents.IconWidth := iIconWidth;
    ATabExtents.IconRect := Rect(X + FIconSpacingX, Y + FIconSpacingY, X + iIconWidth, Height);

  end;

  // Does tab have text?
  if ATab.Caption <> '' then
  begin
    iCaptionWidth := Self.Canvas.TextWidth(ATab.Caption);

    if iIconWidth = 0 then begin

      ATabExtents.CaptionRect := Rect(X + FTextSpacingX, Y + FTextSpacingY,
        X + iCaptionWidth + FTextSpacingX * 2, Height);
      iCaptionWidth := iCaptionWidth + (FTextSpacingX * 2);
    end else begin

      ATabExtents.CaptionRect := Rect(ATabExtents.IconRect.Right, Y + FTextSpacingY,
        ATabExtents.IconRect.Right + iCaptionWidth + FTextSpacingX, Height);
      iCaptionWidth := iCaptionWidth + (FTextSpacingX * 2);

    end;

    ATabExtents.CaptionWidth := iCaptionWidth;
  end;

  // Does tab have status? Only visible if caption
  if ((ATab.Status <> '') and (ATab.Caption <> '')) then
  begin
    iStatusWidth := FImage32.Bitmap.TextWidth(ATab.Status);
    iStatusWidth := iStatusWidth + (FTextSpacingX);
    ATabExtents.StatusWidth := iStatusWidth;
    ATabExtents.StatusRect := Rect(ATabExtents.CaptionRect.Right, Y + FTextSpacingY,
      ATabExtents.CaptionRect.Right + iStatusWidth - FTextSpacingX, Height);
  end;

  // Tab rect
  w := iIconWidth + iStatusWidth + iCaptionWidth;
  ATabExtents.TabWidth := w;

  ATabExtents.TabRect := Rect(X, Y, X + W, Height);
end;

function TSharpETabList.GetTabItem(Index: Integer): TTabItem;
begin
  result := nil;
  if (Index >= 0) and (Index < FTabList.Count) then
    result := FTabList.Item[Index];
end;

function TSharpETabList.GetTabsWidth: Integer;
var
  iTab, iTabsWidth, iTabWidth: Integer;
begin
  Result := 0;

  iTabsWidth := 0;
  for iTab := FLeftIndex to Pred(Count) do
  begin
    if TabList.Item[iTab].Visible then begin
      iTabWidth := GetTabWidth(TabList.Item[iTab]);
      iTabsWidth := iTabsWidth + iTabWidth + 2;
    end;
  end;

  if TabList.Count > 0 then
    Result := iTabsWidth - 2;
end;

function TSharpETabList.GetTabWidth(ATab: TTabItem): Integer;
var
  tabExtents: TTabExtents;
begin

  GetTabExtent(ATab, 0, 0, tabExtents);

  result := tabExtents.TabRect.Right - tabExtents.TabRect.Left;
end;

function TSharpETabList.GetVisibleTabCount: Integer;
var
  iTab: Integer;
begin
  Result := 0;

  for iTab := FLeftIndex to Pred(Count) do
  begin
    if TabList.Item[iTab].Visible then begin
      Inc(Result);
    end;
  end;
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

procedure TSharpETabList.miClick(Sender: TObject);
begin
  SetTabIndex(TMenuItem(Sender).Tag);
  BringTabIntoView(TMenuItem(Sender).Tag);
end;

procedure TSharpETabList.MouseDownEvent(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  i: Integer;
  bChange: Boolean;
  tabsMenuItem : TMenuItem;
  downArrowPoint : TPoint;
begin
  // Check scrollbuttons first
  if (WithinRect(X, Y, FScrollLeft.ButtonRect)) then begin
    ScrollLeft;
    exit;
  end;

  if (WithinRect(X, Y, FScrollRight.ButtonRect)) then begin
    ScrollRight;
    exit;
  end;

  if (WithinRect(X, Y, FDownArrow.ButtonRect)) then
  begin
    FTabsMenu.Items.Clear;
    for i := 0 to Pred(Count) do
      if (FTabList.Item[i].Visible) then
      begin
        tabsMenuItem := TMenuItem.Create(FTabsMenu);
        tabsMenuItem.Caption := FTabList.Item[i].Caption;
        tabsMenuItem.ImageIndex := FTabList.Item[i].ImageIndex;
        tabsMenuItem.Tag := i;
        tabsMenuItem.OnClick := miClick;
        FTabsMenu.Items.Add(tabsMenuItem);
      end;
    if Assigned(FPngImageList) then
      FTabsMenu.Images := FPngImageList;
      
    downArrowPoint := ClientToScreen(FDownArrow.ButtonRect.BottomRight);
    FTabsMenu.Popup(downArrowPoint.X, downArrowPoint.Y);
    Invalidate;
    Exit;
  end;

  for i := 0 to Pred(FButtons.Count) do
  begin

    if ((WithinRect(X, Y, FButtons.Item[i].ButtonRect)) and (FButtons.Item[i].Visible)) then
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

    if ((WithinRect(X, Y, FTabList.Item[i].TabExtent.TabRect)) and (FTabList.Item[i].Visible)) then
    begin
      Invalidate;

      bChange := True;
      if Assigned(FOnTabChange) then
        FOnTabChange(Self, i, bChange);

      if bChange then
      begin
        FTabIndex := FTabList.Item[i].Index;
        if assigned(FOnTabClick) then
          FOnTabClick(Self, FTabList.Item[i].Index);

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

  if (WithinRect(X, Y, FScrollLeft.ButtonRect)) then begin

    if FScrollLeft.ImageIndex <> cLeftArrowDisabledIdx then
      FImage32.Cursor := crHandPoint;
    exit;
  end;

  if (WithinRect(X, Y, FScrollRight.ButtonRect)) then begin

    if FScrollRight.ImageIndex <> cRightArrowDisabledIdx then
      FImage32.Cursor := crHandPoint;
    exit;
  end;

  if (WithinRect(X, Y, FDownArrow.ButtonRect)) then
  begin
    FImage32.Cursor := crHandPoint;
    Exit;
  end;

  FMouseOverID := -1;
  for i := 0 to Pred(FTabList.Count) do
  begin

    tmpTab := FTabList.Item[i];
    r := tmpTab.TabExtent.TabRect;

    if (WithinRect(X, Y, r) and (tmpTab.Visible)) then
    begin
      FMouseOverID := i;
      Invalidate;

      FImage32.Cursor := crHandPoint;
      break;
    end;
  end;

  for i := 0 to Pred(FButtons.Count) do
  begin

    if ((WithinRect(X, Y, FButtons.Item[i].ButtonRect)) and (FButtons.Item[i].Visible)) then
    begin
      Invalidate;

      FImage32.Cursor := crHandPoint;

      break;
    end;
  end;
end;

procedure TSharpETabList.ScrollLeft;
var
  i : Integer;
begin
    if FScrollLeft.ImageIndex <> cLeftArrowDisabledIdx then
    begin
      // If the current left index is 0 then we don't need to
      // find a new left index.
      if FLeftIndex > 0 then
        // Loop until we find a visible tab before the current left index.
        for i := FLeftIndex downto 1 do
        begin
          Dec(FLeftIndex);
          if FTabList.Item[FLeftIndex].Visible then
            Break;
        end;

      Invalidate;
    end;
end;

procedure TSharpETabList.ScrollRight;
var
  i : Integer;
begin
    if FScrollRight.ImageIndex <> cRightArrowDisabledIdx then
    begin
      // Loop until we find a visible tab after the current left index.
      for i := FLeftIndex to Pred(Count) do
      begin
        Inc(FLeftIndex);
        if FTabList.Item[FLeftIndex].Visible then
          Break;
      end;

      Invalidate;
    end;
end;

procedure TSharpETabList.BringTabIntoView(ATabID: Integer);
begin
  // If the tab we are told to bring into view is out of
  // our range then do nothing.
  if (ATabID < 0) or (ATabID >= Count) then
    Exit;

  if (FLeftIndex = 0) and (ATabID < GetMaxVisibleTabs) then
    Exit;
  
  while (FLeftIndex > ATabID) or (FRightIndex < ATabID) do
  begin
    if (FLeftIndex > ATabID) then
      ScrollLeft
    else
      ScrollRight;
    // We need to repaint to have FLeftIndex and FRightIndex reset.
    Paint;
  end;
end;

procedure TSharpETabList.Paint;
var
  rScrollButtons: TRect;
begin
  inherited;
  if ((Height <= 0) or (Width <= 0)) then
    exit;

  FImage32.Bitmap.Setsize(Self.ClientWidth, Self.Height);
  FImage32.Bitmap.Clear(Color32(FBkgColor));

{$REGION 'Draw bottom border'}
  if FBorder and FBottomBorder then
  begin
    if FTabAlign = taLeftJustify then
      FImage32.Bitmap.Line(0, Self.Height - 1, Self.ClientWidth - 4, Self.Height - 1, Color32(FBorderColor))
    else
      FImage32.Bitmap.Line(4, Self.Height - 1, Self.ClientWidth, Self.Height - 1, Color32(FBorderColor))
  end;
{$ENDREGION}

  DrawButtons;

  DrawTabs;

{$REGION 'Draw Scroll buttons'}
  if FTabAlign = taLeftJustify then begin
    rScrollButtons.Left := Self.ClientWidth - (GetScrollButtonsWidth + 4);
    rScrollButtons.Right := Self.ClientWidth;
    rScrollButtons.Top := 0;
    rScrollButtons.Bottom := Self.ClientHeight;
    DrawScrollButtons(rScrollButtons);
  end;
{$ENDREGION}

end;

procedure TSharpETabList.Resize;
var
  i: Integer;
  leftIndex: Integer;
begin
  inherited;

  // store the current left index and set the left index
  // to 0 before we calculate the widths as we want all
  // the widths of the tabs summed.
  leftIndex := FLeftIndex;
  FLeftIndex := 0;

  for i := 0 to leftIndex do
  begin
    if ( (TabItem[i] <> nil) and (TabItem[i].Visible) ) then
      FLeftIndex := i;

    // if the buttons width and the width of all visible tabs
    // is less than the tab list width then leave the left
    // index where it is as and break out of the loop.
    if (GetButtonsWidth + GetTabsWidth + GetScrollButtonsWidth < Self.Width) then
      Break;
  end;

  // if the last left index had its visibility changed
  // find a new left index.
  if ( (TabItem[i] <> nil) and (not TabItem[FLeftIndex].Visible)) then
    for i := 0 to Pred(Count) do
      if TabItem[i].Visible then
      begin
        FLeftIndex := i;
        Break;
      end;
      
  Invalidate;
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

procedure TSharpETabList.SetIconSpacingX(const Value: Integer);
begin
  FIconSpacingX := Value;
  Invalidate;
end;

procedure TSharpETabList.SetIconSpacingY(const Value: Integer);
begin
  FIconSpacingY := Value;
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

procedure TSharpETabList.SetTabItem(Index: Integer; const Value: TTabItem);
begin
  if (Index >= 0) and (Index < FTabList.Count) then
    FTabList.SetItem(Index, Value);
end;

procedure TSharpETabList.SetTabSelectedColor(const Value: TColor);
begin
  FTabSelectedColor := Value;
  Invalidate;
end;

procedure TSharpETabList.SetTextSpacingX(const Value: Integer);
begin
  FTextSpacingX := Value;
  Invalidate;
end;

procedure TSharpETabList.SetTextSpacingY(const Value: Integer);
begin
  FTextSpacingY := Value;
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
  FTabIndex := -1;
  FLeftIndex := 0;
  FRightIndex := 0;
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

  MouseDownEvent(Self, mbLeft, [], TabList.Item[ATabID].TabExtent.TabRect.Left + 1,
    TabList.Item[ATabID].TabExtent.TabRect.Top + 1, nil);
  Result := True;
end;

function TSharpETabList.ClickTab(ATabItem: TTabItem): Boolean;
begin
  Result := False;
  if ATabItem = nil then
    exit;

  MouseDownEvent(Self, mbLeft, [], ATabItem.TabExtent.TabRect.Left + 1, ATabItem.TabExtent.TabRect.Top + 1, nil);
  Result := True;
end;

procedure TSharpETabList.SetTabAlign(const Value: TLeftRight);
begin
  FTabAlign := Value;
  Invalidate;
end;

procedure TSharpETabList.DrawTabs;
var
  x: Integer;
  i: Integer;
  iTabWidth: Integer;
  tabExtents: TTabExtents;
begin
  // Init tabs
  for i := 0 to Pred(Count) do
    with FTabList.Item[i].TabExtent do
    begin
      TabRect := Rect(0, 0, 0, 0);
    end;

  if FTabList.Count <> 0 then begin

    // Get x position of tabs
    if FTabAlign = taLeftJustify then
      x := GetButtonsWidth
    else
      x := Self.ClientWidth - GetButtonsWidth - GetTabsWidth;

    // How many are visible
    FLastTabRight := GetMaxVisibleTabs;
    // Keep track of how many tabs we have actually drawn.
    FDisplayedTabs := 0;

    if FTabAlign = taLeftJustify then
    begin
{$REGION 'Draw left aligned tabs'}
      for i := FLeftIndex to Pred(Count) do
      begin
        // Draw tabs until we hit our max limit.
        if (FDisplayedTabs < FLastTabRight) then
        begin
          iTabWidth := GetTabWidth(FTabList.Item[i]);
          GetTabExtent(FTabList.Item[i], x, 4, tabExtents);
          FTabList.Item[i].TabExtent := tabExtents;
          // Only draw tabs that are supposed to be visible.
          if FTabList.Item[i].Visible then
          begin
            DrawTab(FTabList.Item[i]);
            x := x + iTabWidth + 2;
            Inc(FDisplayedTabs, 1);
            FRightIndex := i;
          end;
        end
        else
        begin
          with FTabList.Item[i].TabExtent do
          begin
            TabRect := Rect(0, 0, 0, 0);
          end;
        end;
      end;
{$ENDREGION}
    end
    else
    begin
{$REGION 'Draw right aligned tabs'}
      for i := Pred(FTabList.Count) downto 0 do
      begin
        if i = i then
        begin
          iTabWidth := GetTabWidth(FTabList.Item[i]);
          GetTabExtent(FTabList.Item[i], x, 4, tabExtents);
          FTabList.Item[i].TabExtent := tabExtents;
          if FTabList.Item[i].Visible then
          begin
            DrawTab(FTabList.Item[i]);
            x := x + iTabWidth + 2;
          end;
        end
        else
        begin
          with FTabList.Item[i].TabExtent do
          begin
            TabRect := Rect(0, 0, 0, 0);
          end;
        end;
      end;
{$ENDREGION}
    end;
  end;
end;

procedure TSharpETabList.CreateScrollButtonComponents;
var
  png: TPngImageCollectionItem;
begin
  FScrollButtonImageList := TPngImageList.Create(self);
  FScrollLeft := TButtonItem.Create(nil);
  FScrollRight := TButtonItem.Create(nil);
  FDownArrow := TButtonItem.Create(nil);

  png := FScrollButtonImageList.PngImages.Add;
  png.PngImage.LoadFromResourceName(HInstance, 'SHARPE_TABLIST_ARR_LEFT_PNG');
  png := FScrollButtonImageList.PngImages.Add;
  png.PngImage.LoadFromResourceName(HInstance, 'SHARPE_TABLIST_ARR_RIGHT_PNG');
  png := FScrollButtonImageList.PngImages.Add;
  png.PngImage.LoadFromResourceName(HInstance, 'SHARPE_TABLIST_ARR_LEFT_D_PNG');
  png := FScrollButtonImageList.PngImages.Add;
  png.PngImage.LoadFromResourceName(HInstance, 'SHARPE_TABLIST_ARR_RIGHT_D_PNG');
  png := FScrollButtonImageList.PngImages.Add;
  png.PngImage.LoadFromResourceName(HInstance, 'SHARPE_TABLIST_ARR_DOWN_PNG');
end;

{$REGION 'TSharpETabListItem'}

constructor TTabItem.Create(Collection: TCollection);
begin
  inherited;
  FImageIndex := -1;
  FCaption := '';
  FStatus := '';
  FVisible := True;

  if Collection <> nil then
    TSharpETabList(Collection.Owner).Invalidate;

end;

procedure TTabItem.SetCaption(const Value: string);
begin
  FCaption := Value;

  if Collection <> nil then
    TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TTabItem.SetCollection(Value: TCollection);
begin
  inherited;
end;

procedure TTabItem.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;

  if Collection <> nil then
    TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TTabItem.SetStatus(const Value: string);
begin
  FStatus := Value;

  if Collection <> nil then
    TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TTabItem.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  FTabExtent.TabRect := Rect(0, 0, 0, 0);

  if Collection <> nil then
    TSharpETabList(Collection.Owner).Invalidate;
end;

{$ENDREGION 'TSharpETabListItem'}

{$REGION 'TButtonItem'}

constructor TButtonItem.Create(Collection: TCollection);
begin
  inherited;
  FImageIndex := -1;
  FCaption := '';
  FVisible := True;

  if Collection <> nil then
    TSharpETabList(Collection.Owner).Invalidate;

end;

procedure TButtonItem.SetCaption(const Value: string);
begin
  FCaption := Value;

  if Collection <> nil then
    TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TButtonItem.SetCollection(Value: TCollection);
begin
  inherited;

end;

procedure TButtonItem.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;

  if Collection <> nil then
    TSharpETabList(Collection.Owner).Invalidate;
end;

procedure TButtonItem.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  FButtonRect := Rect(0, 0, 0, 0);
end;

{$ENDREGION 'TButtonItem'}

{$REGION 'TButtonItems'}

function TButtonItems.Add: TButtonItem;
begin
  result := inherited Add as TButtonItem;
end;

function TButtonItems.GetItem(Index: Integer): TButtonItem;
begin
  result := inherited Items[Index] as TButtonItem;
end;

{$ENDREGION 'TButtonItems'}

end.

