unit SharpETabList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32, GR32_Image, GR32_Polygons, GR32_Layers, ExtCtrls, graphicsFX,
    pngimagelist, JclFileUtils;

type
  TSharpETabListItem = Class(TCollectionItem)
  private
    FCaption: String;
    FID: Integer;
    FTabRect: Trect;
    FOnClick: TNotifyEvent;
    FStatus: String;
    FImageIndex: Integer;
    FVisible: Boolean;
    procedure SetImageIndex(const Value: Integer);
    procedure SetID(const Value: Integer);
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create; reintroduce;
  published
    Property Caption: String read FCaption write FCaption;
    Property Status: String read FStatus write FStatus;
    Property TabRect: Trect read FTabRect write FTabRect;
    Property ImageIndex: Integer read FImageIndex write SetImageIndex;
    Property ID: Integer read FID write SetID;
    Property Visible: Boolean read FVisible write SetVisible;

    Property Onclick: TNotifyEvent read FOnClick write FOnClick;
end;

type
  TSharpETabListItems = Class(TCollection)
  private
   function GetItem(Index: Integer): TSharpETabListItem;
 public
  function Add: TSharpETabListItem;
  property Item[Index: Integer]: TSharpETabListItem read GetItem;
 end;

type
  TSharpETabListItemClick = Procedure(var ATabItem: TSharpETabListItem) of Object;

  TSharpETabClick = procedure(ASender: TObject; const ATabIndex:Integer) of object;
  TSharpETabChange = procedure(ASender: TObject; const ATabIndex: Integer; var AChange:Boolean) of object;
type
  TSharpETabList = Class(TCustomPanel)
  private
    FTabList: TSharpETabListItems;
    FTabIndex: Integer;
    FTabWidth: Integer;
    FtabColor: TColor;
    FBkgColor: TColor;
    FTabSelectedColor: TColor;
    FTextBounds: TRect;
    FOnTabChange: TSharpETabChange;
    FMouseOverID: Integer;
    FTimer: TTimer;
    FImage32:Timage32;
    FAutoSizeTabs: Boolean;
    FCaptionSelectedColor: TColor;
    FCaptionUnSelectedColor: TColor;
    FStatusSelectedColor: TColor;
    FStatusUnSelectedColor: TColor;
    FPngImageList: TPngImageList;
    FIconBounds: TRect;
    FBorderColor: TColor;
    FBorder: Boolean;
    FBottomBorder : Boolean;
    FBorderSelectedColor: TColor;
    FOnTabClick: TSharpETabClick;
    FTabAlign: TLeftRight;

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
    procedure TimeEvent(Sender: TObject);
    function WithinRect(AX,AY: Integer; ARect:TRect):Boolean;
    procedure SetAutoSizeTabs(const Value: Boolean);
    function CalculateMaxTabSize: Integer;
    procedure SetBorder(const Value: Boolean);
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorderSelectedColor(const Value: TColor);
    procedure SetTabAlign(const Value: TLeftRight);
    procedure SetBottomBorder(const Value: boolean);
  protected
    procedure DrawTab(ATabRect:TRect; ATabItem: TSharpETabListItem);
  public

    function ClickTab(ATab: TSharpETabListItem):Boolean; overload;
    function ClickTab(ATabID: Integer):Boolean; overload;

    Function Add: TSharpETabListItem; overload;
    Function Add(ATabCaption: String; ATabImageIndex:Integer=-1;
      ATabStatus: String=''): TSharpETabListItem; overload;
    Function Index(ASharpETabListItem: TSharpETabListItem): Integer;

    procedure Delete(ASharpETabListItem: TSharpETabListItem);
    Procedure Paint; override;
    constructor Create(AOwner:TComponent); override;

    procedure Clear;
    destructor Destroy; override;
  published
    property Align;
    property Anchors;
    Property Visible;
    Property Font;
    Property ParentFont;

    property OnTabChange: TSharpETabChange read FOnTabChange write FOnTabChange;
    property OnTabClick: TSharpETabClick read FOnTabClick write FOnTabClick;

    Property Count: Integer read GetCount;
    Property TabWidth: Integer read FTabWidth write SetTabWidth;
    Property TabIndex: Integer read FTabIndex write SetTabIndex;

    Property TabColor: TColor read FtabColor write SetTabColor;
    Property TabSelectedColor: TColor read FTabSelectedColor write SetTabSelectedColor;
    Property BkgColor: TColor read FBkgColor write SetBkgColor;
    Property CaptionSelectedColor: TColor read FCaptionSelectedColor write FCaptionSelectedColor;
    Property StatusSelectedColor: TColor read FStatusSelectedColor write FStatusSelectedColor;
    Property CaptionUnSelectedColor: TColor read FCaptionUnSelectedColor write FCaptionUnSelectedColor;
    Property StatusUnSelectedColor: TColor read FStatusUnSelectedColor write FStatusUnSelectedColor;

    property TabAlign: TLeftRight read FTabAlign write SetTabAlign;
    Property TextBounds: TRect read FTextBounds write FTextBounds;
    Property IconBounds: TRect read FIconBounds write FIconBounds;
    Property AutoSizeTabs: Boolean read FAutoSizeTabs write SetAutoSizeTabs;

    property BottomBorder: Boolean read FBottomBorder write SetBottomBorder;
    Property Border: Boolean read FBorder write SetBorder;
    Property BorderColor: TColor read FBorderColor write SetBorderColor;
    Property BorderSelectedColor: TColor read FBorderSelectedColor write SetBorderSelectedColor;

    property PngImageList: TPngImageList read
      FPngImageList write FPngImageList;

    Property TabList: TSharpETabListItems read FTabList write FTabList;
    
end;

  procedure Register;

  implementation

uses Types;

{ TSharpETabListItems }

function TSharpETabListItems.Add: TSharpETabListItem;
begin
  result := inherited Add as TSharpETabListItem;
  result.ID := Count-1;
end;

function TSharpETabListItems.GetItem(Index: Integer): TSharpETabListItem;
begin
  result := inherited Items[Index] as TSharpETabListItem;
end;

{ TSharpETabList }

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpETabList]);
end;

function TSharpETabList.Add(ATabCaption: String; ATabImageIndex:Integer=-1;
  ATabStatus: String=''): TSharpETabListItem;
var
  tmp:TSharpETabListItem;
begin
  tmp := FTabList.Add;
  tmp.Caption := ATabCaption;
  tmp.Status := ATabStatus;
  tmp.ImageIndex := ATabImageIndex;
  tmp.Visible := True;
  Result := tmp;

  //FTabList.Add  Add(Result);
end;

function TSharpETabList.Add: TSharpETabListItem;
var
  tmp:TSharpETabListItem;
begin
  tmp := FTabList.Add;
  tmp.Caption := '';
  tmp.Status := '';
  tmp.Visible := True;
  Result := tmp;
end;

function TSharpETabList.CalculateMaxTabSize: Integer;
var
  iMaxTabSize, iCount, iTextSize, iStatusSize, iTabSize: Integer;
  tmpTab:TSharpETabListItem;
begin
  if Not(FAutoSizeTabs) then
    Result := FTabWidth  else begin

  iMaxTabSize := 10;
  Try
  For iCount := 0 to Pred(Count) do begin
    tmpTab := FTabList.Item[iCount];

    if tmpTab.Visible then begin
      iTextSize := FImage32.Bitmap.TextWidth(tmpTab.Caption);
      iStatusSize := FImage32.Bitmap.TextWidth(tmpTab.Status);
      iTabSize := iTextSize + iStatusSize + FTextBounds.Left+FTextBounds.Right+10;
      if iTabSize > iMaxTabSize then iMaxTabSize := iTabSize;
    end;
  end;
  Finally
    Result := iMaxTabSize;
  End;
  end;
end;

constructor TSharpETabList.Create(AOwner: TComponent);
begin
  inherited;

  Self.BevelInner := bvNone;
  Self.BevelOuter := bvNone;

  FTabList := TSharpETabListItems.Create(TSharpETabListItem);

  FMouseOverID := -1;

  FBottomBorder := True;

  FTabWidth := 62;
  FTabColor := $00EFEFEF;
  FTabSelectedColor := $00C0F1E6;
  FCaptionUnSelectedColor := clBlack;
  FStatusUnSelectedColor := clGreen;
  FStatusSelectedColor := clGreen;
  FBkgColor := clWindow;
  Height := 25;
  FTextBounds := Rect(8,8,8,4);
  FIconBounds := Rect(4,4,8,4);
  FAutoSizeTabs := False;
  FTabAlign := taLeftJustify;

  Fimage32 := Timage32.Create(self);
  FImage32.Parent := Self;
  Fimage32.Align := alClient;
  FImage32.OnMouseUp := MouseDownEvent;
  FImage32.OnMouseMove := MouseMoveEvent;

  FTimer := TTimer.Create(Self);
  Ftimer.Interval := 500;
  Ftimer.OnTimer := TimeEvent;
  Ftimer.Enabled := True;

  
end;

procedure TSharpETabList.Delete(ASharpETabListItem: TSharpETabListItem);
var
  i:Integer;
begin
  For i := 0 to Pred(Count) do begin
    if FTabList.Item[i] = ASharpETabListItem then begin
      FTabList.Delete(Index(ASharpETabListItem));
      Invalidate;
      break;
    end;
  end;

end;


procedure TSharpETabList.DrawTab(ATabRect: TRect; ATabItem: TSharpETabListItem);
var
  iTabWidth, iIconWidth, {iIconHeight, }iStatusWidth, iCaptionWidth:Integer;
  s: String;
begin
  iTabWidth := ATabRect.Right-ATabRect.Left;
  // Get icon width
  if ((Assigned(FPngImageList)) and (ATabItem.ImageIndex >= 0) and
    (ATabItem.ImageIndex <= FPngImageList.Count-1)) then
      iIconWidth := PngImageList.PngImages[ATabItem.ImageIndex].PngImage.Width 
   else
      iiconWidth := 0;

  // Get status text width
  iStatusWidth := Canvas.TextWidth(ATabItem.Status);

  // Get caption width
  iCaptionWidth := iTabWidth - iIconWidth - iStatusWidth;

  // Tab Colour
  if ATabItem.ID = FTabIndex then begin
    FImage32.Bitmap.Canvas.Brush.Color := FTabSelectedColor;

    if FBorder then
      FImage32.Bitmap.Canvas.Pen.Color := FBorderSelectedColor else
      FImage32.Bitmap.Canvas.Pen.Color := FTabSelectedColor;
  end
  else begin
    FImage32.Bitmap.Canvas.Brush.Color := FtabColor;

    if FBorder then
      FImage32.Bitmap.Canvas.Pen.Color := FBorderColor else
      FImage32.Bitmap.Canvas.Pen.Color := FtabColor;
  end;

  RoundRect(FImage32.Bitmap.Canvas.Handle,ATabRect.Left,ATabRect.Top,ATabRect.Right,ATabRect.bottom+5,10,10);

  // Draw Tab Bottom Border
  if FBorder and FBottomBorder then
  if FTabIndex = ATabItem.ID then
    FImage32.Bitmap.Line(ATabRect.Left+1,ATabRect.Bottom-1,ATabRect.Right-1,ATabRect.Bottom-1,Color32(FTabSelectedColor)) else
    FImage32.Bitmap.Line(ATabRect.Left,ATabRect.Bottom-1,ATabRect.Right,ATabRect.Bottom-1,Color32(FBorderColor));

  // Draw image
  if iIconWidth <> 0 then begin
    FPngImageList.PngImages[ATabItem.ImageIndex].PngImage.Draw(FImage32.Bitmap.Canvas,
      Rect(FIconBounds.Left+ATabRect.Left,FIconBounds.Top+ATabRect.Top,
        FIconBounds.Left+iIconWidth+ATabRect.Left,
          FIconBounds.Top+iIconWidth+ATabRect.Top));
  end;

  
  FImage32.Bitmap.Font.Assign(Self.Font);

    // Text Underline?
  FImage32.Bitmap.Font.Style := [];
  if FMouseOverID <> -1 then
    if FMouseOverID = ATabItem.ID then
      FImage32.Bitmap.Font.Style := [fsUnderline];

  if FTabIndex = ATabItem.ID then
    FImage32.Bitmap.Font.Style := [fsUnderline]; 

  // Caption Color
  if FTabIndex = ATabItem.ID then
  FImage32.Bitmap.Font.Color := FCaptionSelectedColor else
  FImage32.Bitmap.Font.Color := FCaptionUnSelectedColor;

  // Draw Caption Text
  s := PathCompactPath(FImage32.Bitmap.Canvas.Handle, ATabItem.Caption,
    iCaptionWidth+12, cpEnd);
  FImage32.Bitmap.Textout(ATabrect.Left+FTextBounds.Left+iIconWidth,
    FTextBounds.Top,s);

  // Status Text Color
  if FTabIndex = ATabItem.ID then
  FImage32.Bitmap.Font.Color := FStatusSelectedColor else
  FImage32.Bitmap.Font.Color := FStatusUnSelectedColor;

  // Draw Status Text
  FImage32.Bitmap.Textout(ATabrect.Right-iStatusWidth-FTextBounds.Right,FTextBounds.Top,
    ATabItem.Status);

end;

function TSharpETabList.GetCount: Integer;
begin
  Result := FTabList.Count;
end;

function TSharpETabList.Index(ASharpETabListItem: TSharpETabListItem): Integer;
var
  i:Integer;
begin
  Result := -1;
  For i := 0 to Pred(Count) do begin
    if FTabList.Item[i] = ASharpETabListItem then begin
      Result := i;
      break;
    end;
  end;
end;

procedure TSharpETabList.MouseDownEvent(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  i:Integer;
  bChange: Boolean;
begin
  if Count = 0 then exit;

  For i := 0 to Pred(FTabList.Count) do begin

    if WithinRect(X,Y,FTabList.Item[i].TabRect) then begin
      Invalidate;

      bChange := True;
      if Assigned(FOnTabChange) then
        FOnTabChange(Self,i,bChange);

      if bChange then begin

        if assigned(FOnTabClick) then
          FOnTabClick(Self,i);

        TabIndex := i;
      end;
      break;
    end;
  end;
end;

procedure TSharpETabList.MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var
  i:Integer;
  r:TRect;
  tmpTab:TSharpETabListItem;
begin
  If Count = 0 then exit;

  FMouseOverID := -1;
  For i := 0 to Pred(FTabList.Count) do begin

    tmpTab := FTabList.Item[i];
    r := tmpTab.TabRect;
    //r := Rect(r.Left+FTextBounds.Left,r.Top+FTextBounds.Top,
    //  r.Right-FTextBounds.Right, r.Bottom-FTextBounds.Bottom);

    if WithinRect(X,Y,r) then begin
      FMouseOverID := i;
      Invalidate;
      break;
    end;
  end;
end;

procedure TSharpETabList.Paint;
var
  w, iPosTabs:Integer;
  x: Integer;
  iDrawCount, i, iMaxTabSize: Integer;
  tr: TRect;
begin
  inherited;
  if Height = 0 then exit;

  FImage32.Bitmap.Setsize(Self.Width,Self.Height);
  FImage32.Bitmap.Clear(Color32(FBkgColor));

  // Draw bottom line
  If FBorder and FBottomBorder then begin
    if FTabAlign = taLeftJustify then
      FImage32.Bitmap.Line(0,Self.Height-1,Self.Width-4,Self.Height-1,Color32(FBorderColor)) else
      FImage32.Bitmap.Line(4,Self.Height-1,Self.Width,Self.Height-1,Color32(FBorderColor))
  end;

  if Count = 0 then exit;
  w := Self.Width;
  iMaxTabSize := CalculateMaxTabSize;

  iPosTabs := w div (iMaxTabSize+3);
  iMaxTabSize := CalculateMaxTabSize;

  // What allignment?
  if FTabAlign = taLeftJustify then
    x := 0 else
    x := Self.Width;

  // How many are visible
  if Count < iPosTabs then
    iDrawCount := Count else
    iDrawCount := iPosTabs;

  For i := 0 to Pred(iDrawCount) do begin

    if FTabAlign = taLeftJustify then begin
      if FTabList.Item[i].Visible then begin
        tr := Rect(x,4,x+iMaxTabSize,Height);
        FTabList.Item[i].TabRect := tr;
        DrawTab(tr,TSharpETabListItem(FTabList.Item[i]));
        x := x + iMaxTabSize+2;
      end;

    end else begin
      if FTabList.Item[i].Visible then begin
        tr := Rect(x-iMaxTabSize,4,x,Height);
        FTabList.Item[i].TabRect := tr;
        DrawTab(tr,TSharpETabListItem(FTabList.Item[i]));
        x := x - iMaxTabSize-2;
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
begin
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

procedure TSharpETabList.TimeEvent(Sender: TObject);
begin
  if Count = 0 then exit;

  if (Self.ScreenToClient(Mouse.CursorPos).Y > Height) or
    (Self.ScreenToClient(Mouse.CursorPos).Y < Top) or
      (Self.ScreenToClient(Mouse.CursorPos).X > Width) or
        (Self.ScreenToClient(Mouse.CursorPos).X < Left)
   then begin
    FMouseOverID := -1;
    Invalidate;
  end;
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
    for i := 0 to OrgList.Count-1 do
      AList.Add(OrgList[i]);

    OrgList.Clear;

  finally
    AList.Free;
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
  if ((ATabID = -1) or (ATabID > Self.Count-1)) then exit;

  MouseDownEvent(Self,mbLeft,[],TabList.Item[ATabID].TabRect.Left+1,
    TabList.Item[ATabID].TabRect.Top+1,nil);
  Result := True;
end;

function TSharpETabList.ClickTab(ATab: TSharpETabListItem): Boolean;
begin
  Result := False;
  if ATab = nil then exit;

  MouseDownEvent(Self,mbLeft,[],ATab.TabRect.Left+1, ATab.TabRect.Top+1,nil);
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

constructor TSharpETabListItem.Create;
begin
   FImageIndex := -1;
   FCaption := '';
   FStatus := '';
   FVisible := True;
end;

procedure TSharpETabListItem.SetID(const Value: Integer);
begin
  FID := Value;
end;

procedure TSharpETabListItem.SetImageIndex(const Value: Integer);
begin
  FImageIndex := Value;
end;

procedure TSharpETabListItem.SetVisible(const Value: Boolean);
begin
  FVisible := Value;
  FTabRect := Rect(0,0,0,0);
end;

end.
