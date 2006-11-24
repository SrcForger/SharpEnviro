unit uSharpeColorBox;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  Dialogs,
  menus,
  SharpApi,
  sharpfx,
  sharpthemeapi,
  graphics,
  Forms;

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
    FOnColorClick: TNotifyEvent;
    FColorDialog: TColorDialog;
    FColor: TColor;
    FColorCode: Integer;
    FLastColor: TColor;

    FSelectedID: Integer;

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; State:
      TOwnerDrawState);
    procedure MenuClick(Sender: TObject);

    procedure SetBackgroundColor(const Value: TColor);
    //procedure SetClickedColorID(const Value: TClickedColorID);
    procedure DrawColorSelector(Bmp: TBitmap; R: TRect);

    procedure UpdateSelCol(Sender: TObject);
    procedure ShowColorMenu(Point: TPoint);
    procedure SetColor(const Value: TColor);
    function GetColorCode: Integer;
    procedure SetColorCode(const Value: Integer);
    function GetColor: TColor;

  public
    { Public declarations }
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;

  published
    { Published declarations }
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    property Color: TColor read GetColor write SetColor;
    property ColorCode: Integer read GetColorCode write SetColorCode;
    //property ClickedColorID: TClickedColorID read FClickedColorID write SetClickedColorID;
    property OnColorClick: TNotifyEvent read FOnColorClick write FOnColorClick;

  end;

type
  TSharpEColorBox = class(TCustomSharpEColorBox)
  private
  published
    property BackgroundColor;
    property Color;
    //property ClickedColorID;
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
  id: integer;
  tmpbitmap: Tbitmap;
  n: integer;
begin
  id := TMenuItem(Sender).Tag;
  n := 20;

  with ACanvas do
  begin
    font.Name := 'arial';
    font.Size := 8;

    if not (odSelected in State) then
      font.Color := clMenuText
    else
      font.Color := clHighlightText;

    Caption := TMenuItem(Sender).Caption;
    dcolor := SchemeCodeToColor(id); //CodeToColor(id);

    if not (odSelected in State) then
      Brush.Color := clMenu
    else
    begin
      Brush.Color := clMenuHighlight;
    end;

    FillRect(ARect);

    if id < 0 then
      Brush.Color := dcolor
    else
      Brush.Color := id;

    if ((dColor = color) and (id < 0)) or ( (id >= 0) and (fcolor = id)) then
    begin

      pen.Color := clBtnShadow;
      //font.Style := [fsbold];
      Brush.Color := clMenuHighlight;
      RoundRect(Arect.Left, ARect.Top, ARect.Right, ARect.Bottom, 6, 6);

      if id < 0 then
        Brush.Color := dcolor
      else
        Brush.Color := color;

      pen.Color := clBlack;
      RoundRect(ARect.Left + 3, ARect.Top + 4, ARect.Left + 14, ARect.Bottom - 4, 4, 4);
      font.Color := clMenuText;
      tmpbitmap := TBitmap.Create;
      tmpbitmap.Handle := LoadBitmap(HInstance, 'ARROW_BMP');
      tmpbitmap.Transparent := True;
      acanvas.Draw(Arect.Left + 17, Arect.Top + 5, tmpbitmap);
      tmpbitmap.Free;
      n := 28;
    end
    else
    begin
      Pen.Color := clBlack;
      //Rectangle(ARect.Left + 3, ARect.Top + 4, ARect.Left + 14, ARect.Bottom - 4);
      RoundRect(ARect.Left + 3, ARect.Top + 4, ARect.Left + 14, ARect.Bottom - 4, 4, 4);

    end;

    SetBkMode(ACanvas.Handle, TRANSPARENT);
    TextOut(ARect.Left + n, ARect.Top + 3, Caption);
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

constructor TCustomSharpeColorBox.Create(AOwner: TComponent);
begin
  inherited;
  Height := 15;
  Width := 35;
  FBackgroundColor := clBtnFace;
  FColor := clwhite;
  FLastColor := 0;
  FColorCode := clWhite;
  //FClickedColorID := ccCustom;
  Align := alNone;

  // Create timer
  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := UpdateSelCol;
  FTimer.Interval := 50;
  FTimer.Enabled := False;

  LoadTheme;
end;

procedure TCustomSharpeColorBox.DrawColorSelector(Bmp: TBitmap; R: TRect);
begin
  // Draw border
  if FMouseOver then
  begin
    Bmp.Canvas.Pen.Color := darker(Color, 80);
    Bmp.Canvas.Brush.Color := SchemeCodeToColor(FColorCode); //CodeToColor(FColorCode);
    Bmp.Canvas.Rectangle(R);
  end
  else
  begin
    Bmp.Canvas.Pen.Color := darker(Color, 20);
    Bmp.Canvas.Brush.Color := SchemeCodeToColor(FColorCode); //CodeToColor(FColorCode);
    Bmp.Canvas.Rectangle(R);
  end;

end;

function TCustomSharpeColorBox.GetColor: TColor;
begin
  if FColorCode < 0 then
    Result := SchemeCodeToColor(FColorCode) else // CodeToColor(FColorCode) else
    Result := FColor;
end;

function TCustomSharpeColorBox.GetColorCode: Integer;
begin
  Result := ColorToSchemeCode(FColor); //ColorToCode(FColor);
end;

procedure TCustomSharpeColorBox.MenuClick(Sender: TObject);
var
  id: integer;
  s:String;
begin
  id := TMenuItem(Sender).Tag;
  if id >= 0 then
  begin
    if not (assigned(FcolorDialog)) then
      FColorDialog := TColorDialog.Create(nil);

    s := GetSharpeUserSettingsPath+'ColorBox.dat';
    if fileexists(s) then
      FColorDialog.CustomColors.LoadFromFile(s);

    FColorDialog.Color := Color;
    if FColorDialog.Execute then
    begin
      Color := FColorDialog.Color;
      TMenuItem(Sender).Tag := Color;
    end;

    if fileexists(s) then
      FColorDialog.CustomColors.SaveToFile(s);

  end
  else
  begin
    color := id;
  end;
end;

procedure TCustomSharpeColorBox.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  inherited;

  if (X > rColorBox.Left) and (X < rColorBox.Right) and
    (Y > rColorBox.Top) and (Y < rColorBox.Bottom) then
  begin
    pt.X := X;
    pt.Y := Y;
    ShowColorMenu(pt);
  end
  else
  begin
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

procedure TCustomSharpeColorBox.SetColor(const Value: TColor);
begin
  FColor := Value;
  SetColorCode(FColor);

  paint;

  if Assigned(FOnColorClick) then
    FOnColorClick(Self);
end;

procedure TCustomSharpeColorBox.SetColorCode(const Value: Integer);
begin
  FColorCode := Value;//ColorToCode(Value);
  FColor := SchemeCodeToColor(Value); // CodeToColor(Value);

  Invalidate;
end;

procedure TCustomSharpeColorBox.ShowColorMenu(Point: TPoint);
var
  pt1, pt2: TPoint;
  i: integer;
  tmpRec: TSharpESkinColor;
  mi: TMenuItem;
begin

  // Create the Popup Menu
  if not (Assigned(FColorMenu)) then
  begin
    FColorMenu := TPopupMenu.Create(self);
    FColorMenu.OwnerDraw := True;
    FColorMenu.AutoHotkeys := maManual;
  end;

  FSelectedID := 0;
  FColorMenu.Items.Clear;
  with FColorMenu.Items do
  begin
    if GetSkinColorCount = 0 then
    begin
      Add(NewItem('No Skin Colors Available', 0, False, False, MenuClick, 0, 'NoSkinCols'));
      Add(NewItem('-', 0, False, False, MenuClick, 0, 'sep'));

      Add(NewItem('Custom', 0, False, True, MenuClick, 0, 'Custom'));
      if Color >= 0 then
        FLastColor := Color;
      Items[Count - 1].Tag := FLastColor;
      Items[Count - 1].OnAdvancedDrawItem := AdvancedDrawItem;
      Items[Count - 1].Hint := 'Custom';
    end
    else
    begin

      for i := 0 to Pred(GetSkinColorCount) do
      begin
        tmpRec := GetSchemeColorByIndex(i);
        mi := TMenuItem.Create(nil);
        mi.Caption := tmpRec.Info + '           ';
        mi.Hint := tmpRec.Info;
        mi.Name := 'Color' + IntToStr(i);
        mi.OnClick := MenuClick;
        mi.Tag := -(i + 1);
        mi.OnAdvancedDrawItem := AdvancedDrawItem;
        Add(mi);
      end;

      Add(NewItem('-', 0, False, False, MenuClick, 0, 'sep'));
      Add(NewItem('Custom', 0, False, True, MenuClick, 0, 'Custom'));
      if Color >= 0 then
        FLastColor := Color;
      Items[Count - 1].Tag := FLastColor;
      Items[Count - 1].OnAdvancedDrawItem := AdvancedDrawItem;
      Items[Count - 1].Hint := 'Custom';
    end;

  end;

  // Popup the menu
  pt1 := ClientToScreen(ClientRect.BottomRight);
  pt2 := ClientToScreen(ClientRect.TopLeft);
  FColorMenu.Popup(pt2.X, pt1.Y);
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

