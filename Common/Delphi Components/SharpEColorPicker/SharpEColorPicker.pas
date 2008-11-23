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
  uvistafuncs,
  pngImage,
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
    rColorPicker: TRect;
    FMouseOver, FMouseDown: Boolean;
    FOnColorClick: TNotifyEvent;
    FColor: TColor;
    FLastColor: TColor;

    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;

    procedure SetBackgroundColor(const Value: TColor);
    procedure DrawColorSelector(Bmp: TBitmap; R: TRect);

    procedure UpdateSelCol(Sender: TObject);

    procedure SetColor(const Value: TColor);
    function GetColor: TColor;

  public
    { Public declarations }
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    { Published declarations }
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    property Color: TColor read GetColor write SetColor;
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
end;

procedure TCustomSharpeColorPicker.DrawColorSelector(Bmp: TBitmap; R: TRect);
begin
  if csDesigning in componentState then exit;

  // Draw border
  if FMouseOver then
  begin
    Bmp.Canvas.Brush.Color := XmlSchemeCodeToColor(FColor); //CodeToColor(FColorCode);
    Bmp.Canvas.Pen.Color := darker(Bmp.Canvas.Brush.Color, 20);
    Bmp.Canvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,0,0);
  end
  else
  begin
    Bmp.Canvas.Brush.Color := XmlSchemeCodeToColor(FColor); //CodeToColor(FColorCode);
    Bmp.Canvas.Pen.Color := darker(Bmp.Canvas.Brush.Color, 10);
    Bmp.Canvas.RoundRect(R.Left,R.Top,R.Right,R.Bottom,0,0);
  end;

end;

function TCustomSharpeColorPicker.GetColor: TColor;
begin
  Result := FColor;
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
  //tmpBitmap: TBitmap;
  png: TPNGObject;
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
    png := TPNGObject.Create;

    if FMouseDown then
      png.LoadFromResourceName(HInstance, 'PIPETTESEL_PNG')
    else if FMouseOver then
      png.LoadFromResourceName(HInstance, 'PIPETTE_PNG')
    else
      png.LoadFromResourceName(HInstance, 'PIPETTE_PNG');

    //TmpBitmap.TransparentColor := clFuchsia;
    //tmpBitmap.Transparent := True;
    png.Draw(osBmp.Canvas, rect(rColorPicker.Right + 3, 0, rColorPicker.Right + 3 + 16,16));
    //osBmp.Canvas.Draw(rColorPicker.Right + 3, 0, tmpBitmap);
    //tmpBitmap.Free;

    // Copy off screen bitmap to canvas
    canvas.CopyRect(ClientRect, osBmp.canvas, ClientRect);

  finally
    osBmp.Free;
  end;

end;

procedure TCustomSharpeColorPicker.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
end;

procedure TCustomSharpeColorPicker.SetColor(const Value: TColor);
begin
  FColor := Value;
  paint;
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

  if Assigned(FOnColorClick) then
    FOnColorClick(Self);
end;

end.

