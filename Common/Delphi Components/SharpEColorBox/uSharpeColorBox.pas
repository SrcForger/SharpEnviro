unit uSharpeColorBox;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  SharpFX,
  Dialogs,
  menus,
  SharpApi,
  graphics,
  Forms;

type
  TClickedColorID = (ccThrobberBack, ccThrobberDark, ccThrobberLight,
    ccWorkAreaBack, ccWorkAreaDark, ccWorkAreaLight, ccCustom);

var
  ColorName: array[0..6] of string = ('Throbber Back', 'Throbber Dark', 'Throbber Light',
    'WorkArea Back', 'WorkArea Dark', 'WorkArea Light', 'Custom Color');

type
  TColorClickEvent = procedure(Sender: TObject; Color: TColor; ColType: TClickedColorID) of
    object;

type
  TCustomSharpeColorBox = class(Tcustompanel)
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  private
    { Private declarations }
    FBackgroundColor: TColor;
    FTimer: TTimer;
    FColorMenu: TPopupMenu;
    rColorBox: TRect;
    FMouseOver, FMouseDown: Boolean;
    FClickedColorID: TClickedColorID;
    FOnColorClick: TColorClickEvent;
    FColorDialog: TColorDialog;
    FColor: TColor;
    FColorCode: Integer;
    FColorScheme : TColorScheme;
    FCustomScheme : boolean;

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; State:
      TOwnerDrawState);
    procedure MenuClick(Sender: TObject);
    procedure AdvancedDrawSep(Sender: TObject; ACanvas: TCanvas; ARect: TRect; State:
      TOwnerDrawState);

    procedure SetBackgroundColor(const Value: TColor);
    procedure SetClickedColorID(const Value: TClickedColorID);
    procedure DrawColorSelector(Bmp: TBitmap; R: TRect);

    procedure UpdateSelCol(Sender: TObject);
    procedure ShowColorMenu(Point: TPoint);
    procedure SetColor(const Value: TColor);
    function GetColorCode: Integer;
    procedure SetColorCode(const Value: Integer);

  public
    { Public declarations }
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;

    property ColorScheme : TColorScheme read FColorScheme write FColorScheme;
  published
    { Published declarations }
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    property Color: TColor read FColor write SetColor;
    property ColorCode: Integer read GetColorCode write SetColorCode;
    property CustomScheme : boolean read FCustomScheme write FCustomScheme;
    property ClickedColorID: TClickedColorID read FClickedColorID write SetClickedColorID;
    property OnColorClick: TColorClickEvent read FOnColorClick write FOnColorClick;

  end;

  function CodeToColor(ColorCode: integer; ColorScheme: TColorScheme): integer;
  function ColorToCode(Color: integer; ColorScheme: TColorScheme): integer;

Type
  TSharpEColorBox = class(TCustomSharpEColorBox)
  private
  published
    property BackgroundColor;
    property Color;
    property ClickedColorID;
    property OnColorClick;
    property Hint;
    property Align;

end;

procedure Register;

implementation

{$R Resources.res}

procedure Register;
begin
  RegisterComponents('SharpE', [TSharpeColorBox]);
end;

{ TCustomSharpeColorBox }

procedure TCustomSharpeColorBox.AdvancedDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
var
  Caption: string;
  dColor: TColor;
  cs: TcolorScheme;
  id: integer;
  tmpbitmap: Tbitmap;
  n: integer;
begin
  if FCustomScheme then cs := FColorScheme
     else cs := LoadColorScheme;
  id := FColorMenu.Items.IndexOf(TMenuItem(Sender));
  n := 20;

  with ACanvas do begin
    font.Name := 'arial';
    font.Size := 8;

    if not (odSelected in State) then
      font.Color := clMenuText
    else
      font.Color := clHighlightText;

    Caption := TMenuItem(Sender).Hint;
    case id of
      0: dcolor := cs.Throbberback;
      1: dcolor := cs.Throbberdark;
      2: dcolor := cs.Throbberlight;
      3: dcolor := cs.WorkAreaback;
      4: dcolor := cs.WorkAreadark;
      5: dcolor := cs.WorkArealight;
      7: dcolor := color;
    else
      dcolor := clgray;
    end;
    if not (odSelected in State) then
      Brush.Color := clBtnFace
    else
      Brush.Color := clHighlight;
    FillRect(ARect);
    Brush.Color := dcolor;

    if (dcolor = color) and not (id = 7) then begin

      pen.Color := clBlack;
      //font.Style := [fsbold];
      Brush.Color := clBtnHighlight;
      RoundRect(Arect.Left, ARect.Top, ARect.Right, ARect.Bottom, 6, 6);
      Brush.Color := dColor;
      RoundRect(ARect.Left + 3, ARect.Top + 4, ARect.Left + 14, ARect.Bottom - 4, 4, 4);
      font.Color := clBtnText;
      tmpbitmap := TBitmap.Create;
      tmpbitmap.Handle := LoadBitmap(HInstance, 'ARROW_BMP');
      tmpbitmap.Transparent := True;
      acanvas.Draw(Arect.Left + 17, Arect.Top + 5, tmpbitmap);
      tmpbitmap.Free;
      n := 28;
    end
    else begin
      Pen.Color := Darker(dColor, 10);
      Rectangle(ARect.Left + 3, ARect.Top + 4, ARect.Left + 14, ARect.Bottom - 4);
    end;

    if not (odSelected in State) then
      Brush.Color := clBtnFace
    else
      Brush.Color := clHighlight;

    SetBkMode(ACanvas.Handle, TRANSPARENT);
    TextOut(ARect.Left + n, ARect.Top + 3, Caption);
  end;
end;

procedure TCustomSharpeColorBox.AdvancedDrawSep(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
begin
  with ACanvas do begin
    Pen.Color := clBtnShadow;
    MoveTo(ARect.Left, ARect.Top + 2);
    LineTo(ARect.Right, ARect.Top + 2);
    Pen.Color := clBtnHighlight;
    MoveTo(ARect.Left, ARect.Top + 3);
    LineTo(ARect.Right, ARect.Top + 3);
  end;
end;

procedure TCustomSharpeColorBox.CMMouseEnter(var Message: TMessage);
begin
  FMouseOver := True;
  Paint;
end;

procedure TCustomSharpeColorBox.CMMouseLeave(var Message: TMessage);
begin
  FMouseOver := False;
  Paint;
end;

function CodeToColor(ColorCode: integer;
  ColorScheme: TColorScheme): integer;
begin
  case ColorCode of
    -1: result := ColorScheme.Throbberback;
    -2: result := ColorScheme.Throbberdark;
    -3: result := ColorScheme.Throbberlight;
    -4: result := ColorScheme.WorkAreaback;
    -5: result := ColorScheme.WorkAreadark;
    -6: result := ColorScheme.WorkArealight;
  else
    result := ColorCode;
  end;
end;

function ColorToCode(Color: integer;
  ColorScheme: TColorScheme): integer;
begin
  if Color = ColorScheme.Throbberback then
    result := -1
  else if Color = ColorScheme.Throbberdark then
    result := -2
  else if Color = ColorScheme.Throbberlight then
    result := -3
  else if Color = ColorScheme.WorkAreaback then
    result := -4
  else if Color = ColorScheme.WorkAreadark then
    result := -5
  else if Color = ColorScheme.WorkArealight then
    result := -6
  else
    result := Color;
end;

constructor TCustomSharpeColorBox.Create(AOwner: TComponent);
begin
  inherited;
  Height := 15;
  Width := 35;
  FBackgroundColor := clBtnFace;
  FColor := clwhite;
  FClickedColorID := ccCustom;
  Align := alNone;

  // Create timer
  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := UpdateSelCol;
  FTimer.Interval := 50;
  FTimer.Enabled := False;
end;

procedure TCustomSharpeColorBox.DrawColorSelector(Bmp: TBitmap; R: TRect);
begin
  // Draw border
  if FMouseOver then begin
    Bmp.Canvas.Pen.Color := darker(Color, 80);
    Bmp.Canvas.Brush.Color := Color;
    Bmp.Canvas.Rectangle(R);
  end
  else begin
    Bmp.Canvas.Pen.Color := darker(Color, 20);
    Bmp.Canvas.Brush.Color := Color;
    Bmp.Canvas.Rectangle(R);
  end;

end;

function TCustomSharpeColorBox.GetColorCode: Integer;
var
  cs: TColorScheme;
begin
  if FCustomScheme then cs := FColorScheme
     else cs := LoadColorScheme;
  Result := ColorToCode(Self.Color,cs);
end;

procedure TCustomSharpeColorBox.MenuClick(Sender: TObject);
var
  cs: TColorScheme;
  id: integer;
begin
  id := FColorMenu.Items.IndexOf(TMenuItem(Sender));
  if FCustomScheme then cs := FColorScheme
     else cs := LoadColorScheme;
  case id of

    0: color := cs.Throbberback;
    1: color := cs.Throbberdark;
    2: color := cs.Throbberlight;
    3: color := cs.WorkAreaback;
    4: color := cs.WorkAreadark;
    5: color := cs.WorkArealight;
    7: begin
        id := 6;

        if not (assigned(FcolorDialog)) then
          FColorDialog := TColorDialog.Create(nil);

        FColorDialog.Color := Color;
        if FColorDialog.Execute then
          Color := FColorDialog.Color;
      end;
  else
    Color := cs.Throbberlight;
  end;

  if Assigned(FOnColorClick) then
    FOnColorClick(Sender, color, TClickedColorID(id));
end;

procedure TCustomSharpeColorBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  inherited;

  if (X > rColorBox.Left) and (X < rColorBox.Right) and
    (Y > rColorBox.Top) and (Y < rColorBox.Bottom) then begin
    pt.X := X;
    pt.Y := Y;
    ShowColorMenu(pt);
  end
  else begin
    FTimer.Enabled := True;
    FMouseDown := True;
    Screen.cursor := crCross;
  end;

end;

procedure TCustomSharpeColorBox.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FTimer.Enabled := False;
  FMouseDown := False;
  Screen.cursor := crDefault;

  if Assigned(FOnColorClick) then
    FOnColorClick(Self, color, ccCustom);

  Paint;
end;

procedure TCustomSharpeColorBox.Paint;
var
  osBmp: TBitmap;
  tmpBitmap: TBitmap;
begin
  osBmp := TBitmap.Create;

  try
    osBmp.Height := ClientRect.Bottom;
    osBmp.Width := ClientRect.Right;

    // Draw Color Box
    osBmp.Canvas.Brush.Color := FBackgroundColor;
    osBmp.Canvas.FillRect(ClientRect);
    rColorBox := ClientRect;
    rColorBox.Right := rColorBox.Right - 20;
    DrawColorSelector(osBmp, rColorBox);

    // Draw Status
    tmpBitmap := TBitmap.Create;

    if FMouseDown then
      TmpBitmap.Handle := LoadBitmap(HInstance, 'PIPETTESEL_BMP')
    else if FMouseOver then
      TmpBitmap.Handle := LoadBitmap(HInstance, 'PIPETTE_BMP')
    else
      TmpBitmap.Handle := LoadBitmap(HInstance, 'PIPETTEDIS_BMP');

    TmpBitmap.TransparentColor := clFuchsia;
    tmpBitmap.Transparent := True;
    osBmp.Canvas.Draw(rColorBox.Right + 4, 1, tmpBitmap);
    tmpBitmap.Free;

    // Copy off screen bitmap to canvas
    canvas.CopyRect(ClientRect, osBmp.canvas, ClientRect);
  finally
    osBmp.Free;
  end;

end;

procedure TCustomSharpeColorBox.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  Paint;
end;

procedure TCustomSharpeColorBox.SetClickedColorID(
  const Value: TClickedColorID);
var
  cs: TColorScheme;
begin
  if FCustomScheme then cs := FColorScheme
     else cs := LoadColorScheme;
  FClickedColorID := Value;

  case Integer(FClickedColorID) of
    0: color := cs.Throbberback;
    1: color := cs.Throbberdark;
    2: color := cs.Throbberlight;
    3: color := cs.WorkAreaback;
    4: color := cs.WorkAreadark;
    5: color := cs.WorkArealight;
    7: color := color;
  end;
  paint;
end;

procedure TCustomSharpeColorBox.SetColor(const Value: TColor);
var
  cs: tcolorscheme;
begin
  if FCustomScheme then cs := FColorScheme
     else cs := LoadColorScheme;

  FColor := Value;
  SetColorCode(FColor);


  if (Color <> cs.Throbberback) and (Color <> cs.Throbberdark) and
    (Color <> cs.Throbberlight) and (Color <> cs.WorkAreadark) and
    (Color <> cs.WorkAreaLight) and (Color <> cs.WorkAreaBack) then
    FClickedColorID := ccCustom;

  paint;
end;

procedure TCustomSharpeColorBox.SetColorCode(const Value: Integer);
Var
  cs:TColorScheme;
begin
  FColorCode := Value;
  if FCustomScheme then cs := FColorScheme
     else cs := LoadColorScheme;
  FColor := CodeToColor(Value,cs);

  Invalidate;
end;

procedure TCustomSharpeColorBox.ShowColorMenu(Point: TPoint);
var
  pt1, pt2: TPoint;
  i: integer;
  Space: string;
begin
  if FClickedColorID = ccCustom then
    Space := 'XXXXXXXXXXXXXXXXX'
  else
    Space := 'XXXXXXXXXXXXXXXXXXXXXXXXXX';

  // Create the Popup Menu
  if not (Assigned(FColorMenu)) then begin
    FColorMenu := TPopupMenu.Create(self);
    FColorMenu.OwnerDraw := True;
  end;

  // Create the menu
  with FColorMenu.Items do begin
    Clear;
    Add(NewItem(Space, 0, False, True, MenuClick, 0, 'ThrobberBack'));
    Add(NewItem(Space, 0, False, True, MenuClick, 0, 'ThrobberBottom'));
    Add(NewItem(Space, 0, False, True, MenuClick, 0, 'ThrobberTop'));
    Add(NewItem(Space, 0, False, True, MenuClick, 0, 'WorkAreaBack'));
    Add(NewItem(Space, 0, False, True, MenuClick, 0, 'WorkAreaBottom'));
    Add(NewItem(Space, 0, False, True, MenuClick, 0, 'WorkAreaTop'));
    Add(NewLine);
    Add(NewItem(Space, 0, False, True, MenuClick, 0, 'Custom'));

    // Assign hints
    for i := 0 to 6 do begin
      Items[i].Hint := ColorName[i];

      if i = 6 then
        items[7].Hint := ColorName[i];
    end;

    // Assign default drawitem Proc
    for i := 0 to Pred(Count) do
      FColorMenu.Items[i].OnAdvancedDrawItem := AdvancedDrawItem;

    // Seperator
    FColorMenu.Items[6].OnAdvancedDrawItem := AdvancedDrawSep;

    // Popup the menu
    pt1 := ClientToScreen(ClientRect.BottomRight);
    pt2 := ClientToScreen(ClientRect.TopLeft);
    FColorMenu.Popup(pt2.X, pt1.Y);
  end;
end;

procedure TCustomSharpeColorBox.UpdateSelCol(Sender: TObject);
var
  HDC: THandle;
  P: TPoint;
  C: TColor;
begin
  GetCursorPos(P);
  HDC := GetDC(0);
  C := GetPixel(HDC, P.x, P.y);
  ReleaseDC(HDC, 0);
  Color := c;
end;

end.

