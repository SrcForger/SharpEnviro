unit uSharpETabList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32, GR32_Image, GR32_Polygons, GR32_Layers, ExtCtrls, graphicsFX;

type
  TSharpETabListItem = Class(TPersistent)
  private
    FCaption: String;
    FID: Integer;
    FTabRect: Trect;
    FOnClick: TNotifyEvent;
    FStatus: String;
  public
    Property ID: Integer read FID write FID;
    Property Caption: String read FCaption write FCaption;
    Property Status: String read FStatus write FStatus;
    Property TabRect: Trect read FTabRect write FTabRect;
    
    Property Onclick: TNotifyEvent read FOnClick write FOnClick;
end;

type
  TSharpETabListItemClick = Procedure(var ATabItem: TSharpETabListItem) of Object;
  TSharpETabChange = procedure(ASender: TObject; const ATabIndex: Integer) of object;
type
  TSharpETabList = Class(TCustomPanel)
  private
    FTabList: TList;
    FTabIndex: Integer;
    FTabWidth: Integer;
    FColor: TColor;
    FtabColor: TColor;
    FBkgColor: TColor;
    FTabSelectedColor: TColor;
    FTextBounds: TRect;
    FOnTabChange: TSharpETabChange;
    FMouseOverID: Integer;
    FMouseOverID2: Integer;
    FTimer: TTimer;
    FImage32:Timage32;
    FAutoSizeTabs: Boolean;

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
    procedure MouseLeaveEvent(Sender: TObject);
    procedure TimeEvent(Sender: TObject);
    function WithinRect(AX,AY: Integer; ARect:TRect):Boolean;
    procedure SetAutoSizeTabs(const Value: Boolean);
    function CalculateMaxTabSize: Integer;
  protected
    procedure DrawTab(ATabRect:TRect; ATabItem: TSharpETabListItem);
  public
    Property TabList: TList read FTabList write FTabList;

    Function Add: TSharpETabListItem; overload;
    Function Add(ATabCaption: String;ATabStatus: String=''): TSharpETabListItem; overload;
    Function Index(ASharpETabListItem: TSharpETabListItem): Integer;

    procedure Delete(ASharpETabListItem: TSharpETabListItem);
    Procedure Paint; override;
    constructor Create(AOwner:TComponent); override;
  published
    property Align;
    property Anchors;

    property OnTabChange: TSharpETabChange read FOnTabChange write FOnTabChange;

    Property Count: Integer read GetCount;
    Property TabWidth: Integer read FTabWidth write SetTabWidth;
    Property TabIndex: Integer read FTabIndex write SetTabIndex;

    Property TabColor: TColor read FtabColor write SetTabColor;
    Property TabSelectedColor: TColor read FTabSelectedColor write SetTabSelectedColor;
    Property BkgColor: TColor read FBkgColor write SetBkgColor;
    Property TextBounds: TRect read FTextBounds write FTextBounds;
    Property AutoSizeTabs: Boolean read FAutoSizeTabs write SetAutoSizeTabs;

    
end;

  procedure Register;

  implementation

{ TSharpETabList }

procedure Register;
begin
  RegisterComponents('SharpE', [TSharpETabList]);
end;

function TSharpETabList.Add(ATabCaption: String; ATabStatus: String=''): TSharpETabListItem;
begin
  Result :=  TSharpETabListItem.Create;
  Result.Caption := ATabCaption;
  Result.Status := ATabStatus;
  Result.ID := Self.Count;

  FTabList.Add(Result);
end;

function TSharpETabList.Add: TSharpETabListItem;
begin
  Result :=  TSharpETabListItem.Create;
  Result.Caption := '';
  Result.Status := '';
  Result.ID := Self.Count;

  FTabList.Add(Result);
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
    tmpTab := TSharpETabListItem(FTabList[iCount]);
    iTextSize := FImage32.Bitmap.TextWidth(tmpTab.Caption);
    iStatusSize := FImage32.Bitmap.TextWidth(tmpTab.Status);
    iTabSize := iTextSize + iStatusSize + FTextBounds.Left+FTextBounds.Right+10;
    if iTabSize > iMaxTabSize then iMaxTabSize := iTabSize;
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

  FTabList := TList.Create;
  FMouseOverID := -1;
  FAutoSizeTabs := True;
  FTabIndex := 0;
  FTabWidth := 30;
  FBkgColor := clWindow;
  FtabColor := clWindow;
  FTabSelectedColor := clBtnFace;

  Fimage32 := Timage32.Create(self);
  FImage32.Parent := Self;
  Fimage32.Align := alClient;
  FImage32.OnMouseDown := MouseDownEvent;
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
    if TSharpETabListItem(FTabList[i]) = ASharpETabListItem then begin
      FTabList.Delete(Index(ASharpETabListItem));
      Invalidate;
      break;
    end;
  end;

end;


procedure TSharpETabList.DrawTab(ATabRect: TRect; ATabItem: TSharpETabListItem);
var
  tw:Integer;
begin

  // Tab Colour
  if ATabItem.ID = FTabIndex then
  FImage32.Bitmap.Canvas.Brush.Color := FTabSelectedColor else
  FImage32.Bitmap.Canvas.Brush.Color := FtabColor;

  // Tab Border
  FImage32.Bitmap.Canvas.Pen.Color := darker(FBkgColor,7);

  // Tab Shape
  RoundRect(FImage32.Bitmap.Canvas.Handle,ATabRect.Left,ATabRect.Top,ATabRect.Right,ATabRect.bottom+5,10,10);

  FImage32.Bitmap.Font.Style := [];
  if FMouseOverID <> -1 then
    if FMouseOverID = ATabItem.ID then
      FImage32.Bitmap.Font.Style := [fsUnderline];

  // Tab Caption Text
  FImage32.Bitmap.Font.Color := clWindowText;
  FImage32.Bitmap.Textout(ATabrect.Left+FTextBounds.Left,FTextBounds.Top,ATabItem.Caption);

  // Tab Status Text
  FImage32.Bitmap.Font.Color := clHighlight;
  tw := Canvas.TextWidth(ATabItem.Status);
  FImage32.Bitmap.Textout(ATabrect.Right-tw-FTextBounds.Right,FTextBounds.Top,
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
    if TSharpETabListItem(FTabList[i]) = ASharpETabListItem then begin
      Result := i;
      break;
    end;
  end;
end;

procedure TSharpETabList.MouseDownEvent(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  i:Integer;
begin
  For i := 0 to Pred(FTabList.Count) do begin
                                                                                 
    if WithinRect(X,Y,TSharpETabListItem(FTabList[i]).TabRect) then begin
      TabIndex := i;
      Invalidate;

      if assigned(FOnTabChange) then
        FOnTabChange(Self,i);

      break;
    end;
  end;
end;

procedure TSharpETabList.MouseLeaveEvent(Sender: TObject);
begin
  //FMouseOverID := -1;
  Invalidate;
end;

procedure TSharpETabList.MouseMoveEvent(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var
  i:Integer;
  r:TRect;
  tmpTab:TSharpETabListItem;
begin
  FMouseOverID := -1;
  For i := 0 to Pred(FTabList.Count) do begin

    tmpTab := TSharpETabListItem(FTabList[i]);
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
  poly: TPolygon32;
begin
  inherited;
  FImage32.Bitmap.Setsize(Self.Width,Self.Height);
  FImage32.Bitmap.Clear(Color32(FBkgColor));

  w := Self.Width;
  iMaxTabSize := CalculateMaxTabSize;
  
  iPosTabs := w div iMaxTabSize;
  x := 4;

  if Count < iPosTabs then
    iDrawCount := Count else
    iDrawCount := iPosTabs;

  // Draw bottom line
  FImage32.Bitmap.Line(0,Height-1,Width,Height-1,Color32(clBtnFace));
  iMaxTabSize := CalculateMaxTabSize;
  For i := 0 to Pred(iDrawCount) do begin

    tr := Rect(x,4,x+iMaxTabSize,Height);
    TSharpETabListItem(FTabList[i]).TabRect := tr;

    DrawTab(tr,TSharpETabListItem(FTabList[i]));

    x := x + iMaxTabSize;

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

end.
