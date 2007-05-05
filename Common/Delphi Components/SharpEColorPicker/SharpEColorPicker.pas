unit SharpEColorPicker;

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
  Forms,
  uSchemeList,
  uvistafuncs,
  SharpECenterScheme,
  JvSimpleXml;

type
  TCustomSharpeColorPicker = class(Tcustompanel)
  protected
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  private
    { Private declarations }
    FBackgroundColor: TColor;
    FTimer: TTimer;
    FColorMenu: TPopupMenu;
    rColorPicker: TRect;
    FMouseOver, FMouseDown: Boolean;
    FOnColorClick: TNotifyEvent;
    FColorDialog: TColorDialog;
    FColor: TColor;
    FColorCode: Integer;
    FLastColor: TColor;
    FCustom: Boolean;
    FSCS:TSharpECenterScheme;

    FSelectedID: Integer;
    FSchemeList: TSchemeList;
    FCustomColor: TSchemeColorItem;

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure AdvancedDrawItem(Sender: TObject; ACanvas: TCanvas; ARect: TRect; State:
      TOwnerDrawState);
    procedure MenuClick(Sender: TObject);

    procedure SetBackgroundColor(const Value: TColor);
    procedure DrawColorSelector(Bmp: TBitmap; R: TRect);

    procedure UpdateSelCol(Sender: TObject);
    procedure ShowColorMenu(Point: TPoint);
    procedure SetColor(const Value: TColor);
    function GetColorCode: Integer;
    procedure SetColorCode(const Value: Integer);
    function GetColor: TColor;

    procedure PopulateSkinColors;
  public
    { Public declarations }
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    property Color: TColor read GetColor write SetColor;
    property ColorCode: Integer read GetColorCode write SetColorCode;
    property OnColorClick: TNotifyEvent read FOnColorClick write FOnColorClick;

  end;

type
  TSharpEColorPicker = class(TCustomSharpEColorPicker)
  private
  published
    property BackgroundColor;
    property Color;
    property OnColorClick;
    property Hint;
    property Align;
  end;

procedure Register;

implementation

{$R Resources.res}

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpeColorPicker]);
end;

{ TCustomSharpeColorPicker }

procedure TCustomSharpeColorPicker.AdvancedDrawItem(Sender: TObject;
  ACanvas: TCanvas; ARect: TRect; State: TOwnerDrawState);
var
  tmpbitmap: Tbitmap;
  n: integer;

  tmpCol: TSchemeColorItem;
  skinCol: TSharpESkinColor;
begin
  tmpCol := TSchemeColorItem(TMenuItem(Sender).Tag);
  if tmpCol = nil then exit;

  if tmpCol.Tag = '' then begin
    skinCol.Name := 'Custom';
    skinCol.Color := tmpCol.Color;
  end else
    skinCol := FSchemeList.GetSkinColorByTag(tmpCol.Tag);

  n := 20;

  with ACanvas do
  begin
    font.Size := 8;

    font.Color := clMenuText;

    if not (odSelected in State) then
      Brush.Color := clMenu
    else
    begin
      Brush.Color := FSCS.EditCol;
    end;

    FillRect(ARect);

    if (odSelected in State) then begin
      pen.Color := darker(FSCS.EditBordCol,8);
      Brush.Color := FSCS.EditCol;

      RoundRect(Arect.Left, ARect.Top, ARect.Right, ARect.Bottom,6,6);
    end;
    

    if (FColorCode = Integer(tmpCol.Data)) then
    begin

      pen.Color := darker(FSCS.SidePanelBordCol,12);
      Brush.Color := FSCS.SidePanelCol;
      RoundRect(Arect.Left, ARect.Top, ARect.Right, ARect.Bottom,6,6);

      Brush.Color := skinCol.Color;

      pen.Color := darker(skinCol.Color,20);
      RoundRect(ARect.Left + 3, ARect.Top + 4, ARect.Left + 14, ARect.Bottom - 4,2,2);

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
      Brush.Color := skinCol.Color;
      pen.Color := darker(skinCol.Color,20);

      //Rectangle(ARect.Left + 3, ARect.Top + 4, ARect.Left + 14, ARect.Bottom - 4);
      RoundRect(ARect.Left + 3, ARect.Top + 4, ARect.Left + 14, ARect.Bottom - 4,2,2);

    end;

    SetBkMode(ACanvas.Handle, TRANSPARENT);
    TextOut(ARect.Left + n, ARect.Top + 3, skinCol.Name);
  end;
end;

procedure TCustomSharpeColorPicker.CMMouseEnter(var Message: TMessage);
begin
  if Not(csDesigning in ComponentState) then begin
    FMouseOver := True;
    Paint;
  end;
end;

procedure TCustomSharpeColorPicker.CMMouseLeave(var Message: TMessage);
begin
  if Not(csDesigning in ComponentState) then begin
    FMouseOver := False;
    Paint;
  end;
end;

constructor TCustomSharpeColorPicker.Create(AOwner: TComponent);
begin
  inherited;
  Height := 15;
  Width := 35;
  FBackgroundColor := clBtnFace;
  FColor := clwhite;
  FLastColor := 0;
  FColorCode := clWhite;
  FSchemeList := TSchemeList.Create;
  FCustomColor := TSchemeColorItem.Create;
  FSCS := TSharpECenterScheme.Create(nil);
  Align := alNone;

  FColor := clWhite;

  // Create timer
  FTimer := TTimer.Create(nil);
  FTimer.OnTimer := UpdateSelCol;
  FTimer.Interval := 50;
  FTimer.Enabled := False;
end;

destructor TCustomSharpeColorPicker.Destroy;
begin
  inherited;
  FSchemeList.Free;
  FCustomColor.Free;
  FSCS.Free;
end;

procedure TCustomSharpeColorPicker.DrawColorSelector(Bmp: TBitmap; R: TRect);
begin
  // Draw border
  if FMouseOver then
  begin
    Bmp.Canvas.Brush.Color := SchemeCodeToColor(FColorCode); //CodeToColor(FColorCode);
    Bmp.Canvas.Pen.Color := darker(Bmp.Canvas.Brush.Color, 20);
    Bmp.Canvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,0,0);
  end
  else
  begin
    Bmp.Canvas.Brush.Color := SchemeCodeToColor(FColorCode); //CodeToColor(FColorCode);
    Bmp.Canvas.Pen.Color := darker(Bmp.Canvas.Brush.Color, 10);
    Bmp.Canvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,0,0);
  end;

end;

function TCustomSharpeColorPicker.GetColor: TColor;
begin
  if FColorCode < 0 then
    Result := SchemeCodeToColor(FColorCode) else // CodeToColor(FColorCode) else
    Result := FColor;
end;

function TCustomSharpeColorPicker.GetColorCode: Integer;
begin

  if Not(FCustom) then
    Result := ColorToSchemeCode(FColor) else
    Result := FColor;
end;

procedure TCustomSharpeColorPicker.MenuClick(Sender: TObject);
var
  tmpCol: TSchemeColorItem;
  n: Integer;
  s:String;
begin
  tmpCol := nil;

  if Sender = nil then
    n := FColor else begin

      tmpCol := TSchemeColorItem(TMenuItem(Sender).Tag);
      n := Integer(tmpCol.Data);
    end;

  if ((tmpCol = nil) or (n >= 0)) then
  begin
    if not (assigned(FcolorDialog)) then
      FColorDialog := TColorDialog.Create(nil);

    s := GetSharpeUserSettingsPath+'ColorPicker.dat';
    if fileexists(s) then
      FColorDialog.CustomColors.LoadFromFile(s);

    FColorDialog.Color := Color;
    if FColorDialog.Execute then
    begin
      FCustom := True;

      Color := FColorDialog.Color;
      ColorCode := FColorDialog.Color;
      
      //TMenuItem(Sender).Tag := Color;
    end;

    if fileexists(s) then
      FColorDialog.CustomColors.SaveToFile(s);

  end
  else
  begin
    FCustom := False;
    color := n;
  end;
end;

procedure TCustomSharpeColorPicker.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  pt: TPoint;
begin
  inherited;

  if Not(csDesigning in ComponentState) then begin
    if (X > rColorPicker.Left) and (X < rColorPicker.Right) and
      (Y > rColorPicker.Top) and (Y < rColorPicker.Bottom) then
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
end;

procedure TCustomSharpeColorPicker.MouseUp(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  FTimer.Enabled := False;
  FMouseDown := False;
  Screen.cursor := crDefault;

  Paint;
end;

procedure TCustomSharpeColorPicker.Paint;
var
  osBmp: TBitmap;
  tmpBitmap: TBitmap;
begin

  osBmp := TBitmap.Create;

  try
    osBmp.Height := Self.Height;//.Bottom;
    osBmp.Width := Self.Width;//.Right;

    // Draw Color Box
    osBmp.Canvas.Brush.Color := FBackgroundColor;
    osBmp.Canvas.FillRect(ClientRect);
    rColorPicker := ClientRect;
    rColorPicker.Right := 16;
    rColorPicker.Bottom := 16;
    DrawColorSelector(osBmp, rColorPicker);

    // Draw Status
    tmpBitmap := TBitmap.Create;

    if FMouseDown then
      TmpBitmap.Handle := LoadBitmap(HInstance, 'PIPETTESEL_BMP')
    else if FMouseOver then
      TmpBitmap.Handle := LoadBitmap(HInstance, 'PIPETTE_BMP')
    else
      TmpBitmap.Handle := LoadBitmap(HInstance, 'PIPETTE_BMP');

    TmpBitmap.TransparentColor := clFuchsia;
    tmpBitmap.Transparent := True;
    osBmp.Canvas.Draw(rColorPicker.Right + 3, 0, tmpBitmap);
    tmpBitmap.Free;

    // Copy off screen bitmap to canvas
    canvas.CopyRect(ClientRect, osBmp.canvas, ClientRect);

  finally
    osBmp.Free;
  end;

end;

procedure TCustomSharpeColorPicker.PopulateSkinColors;
var
  s:String;
begin
  s := GetCurrentSharpEThemeName;
  FSchemeList.Load(s);
  FSchemeList.Theme := s;
end;

procedure TCustomSharpeColorPicker.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  //Paint;
end;

procedure TCustomSharpeColorPicker.SetColor(const Value: TColor);
begin
  FColor := Value;
  ColorCode := Value;

  FCustomColor.Color := Value;

  paint;

  if Assigned(FOnColorClick) then
    FOnColorClick(Self);
end;

procedure TCustomSharpeColorPicker.SetColorCode(const Value: Integer);
begin
  FColorCode := ColorToSchemeCode(Value);
  FColor := SchemeCodeToColor(Value);

  FCustomColor.Color := Value;

  Self.Paint;
end;

procedure TCustomSharpeColorPicker.ShowColorMenu(Point: TPoint);
var
  pt1, pt2: TPoint;
  i: integer;
  tmpColItem: TSchemeColorItem;
  mi: TMenuItem;
  n:Integer;
  bPopup: Boolean;

  skinCol: TSharpESkinColor;
begin

  if not (Assigned(FColorMenu)) then
  begin
    FColorMenu := TPopupMenu.Create(self);
    FColorMenu.OwnerDraw := True;
    FColorMenu.AutoHotkeys := maManual;
  end;

  PopulateSkinColors;


  FSelectedID := 0;
  FColorMenu.Items.Clear;
  with FColorMenu.Items do
  begin
    if FSchemeList.Count = 0 then
    begin
      bPopup := False;
      FCustomColor.Data := Pointer(FColor);
    end
    else
    begin

      bPopup := True;
      for i := 0 to Pred(FSchemeList.Item[0].colors.count) do
      begin
        tmpColItem := FSchemeList.Item[0].Color[i];

        n := -1  - i;
        tmpColItem.Data := Pointer(n);
        skinCol := FSchemeList.GetSkinColorByTag(tmpColItem.Tag);

        mi := TMenuItem.Create(nil);
        mi.Caption := skinCol.Name + 'XXX';
        mi.Hint := skinCol.Info;
        mi.Name := 'Color' + IntToStr(i);
        mi.OnClick := MenuClick;
        mi.Tag := Integer(tmpColItem);
        mi.OnAdvancedDrawItem := AdvancedDrawItem;
        Add(mi);
      end;

      Add(NewItem('-', 0, False, False, MenuClick, 0, 'sep'));
      Add(NewItem('Custom', 0, False, True, MenuClick, 0, 'Custom'));

      FCustomColor.Data := Pointer(FColor);
      Items[Count - 1].Tag := Integer(FCustomColor);
      Items[Count - 1].OnAdvancedDrawItem := AdvancedDrawItem;
      Items[Count - 1].Hint := 'Custom';
    end;

  end;

  // Popup the menu

  if bPopup then begin
    pt1 := ClientToScreen(ClientRect.BottomRight);
    pt2 := ClientToScreen(ClientRect.TopLeft);
    FColorMenu.Popup(pt2.X, pt1.Y);
  end else begin
    MenuClick(nil);
  end;
end;

procedure TCustomSharpeColorPicker.UpdateSelCol(Sender: TObject);
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

