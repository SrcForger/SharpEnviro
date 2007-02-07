unit SharpERoundPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics;

type
  TSharpERoundPanel = class(TPanel)
  private
    FRoundValue: Integer;
    FBorderColor: TColor;
    FBorder: Boolean;
    FBackgroundColor: TColor;
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorder(const Value: Boolean);
    procedure SetBackgroundColor(const Value: TColor);
  protected
    procedure Resize; override;
    procedure Paint; override;
    procedure SetRoundValue(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property RoundValue: Integer read FRoundValue write SetRoundValue;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property Border: Boolean read FBorder write SetBorder;
    property BackgroundColor : TColor read FBackgroundColor write SetBackgroundColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SharpE', [TSharpERoundPanel]);
end;


constructor TSharpERoundPanel.Create(AOwner: TComponent);
begin
  Inherited;
  FRoundValue := 10;
  ParentBackground := false;
  FBackgroundColor := clBtnFace;
  Color := clWhite;
  FBorderColor := clBtnFace;

  BevelInner := bvNone;
  BevelOuter := bvNone;
end;

procedure TSharpERoundPanel.Paint;
begin
  Canvas.Brush.Color := FBackgroundColor;
  Canvas.FillRect(ClientRect);

  if FBorder then
  Canvas.Pen.Color := FBorderColor else
  Canvas.Pen.Color := Color;

  Canvas.Brush.Color := Color;
  Canvas.RoundRect(0, 0, Width, Height, RoundValue, RoundValue);

  Canvas.Pen.Color := Color;
  Canvas.Rectangle(0,0,RoundValue,RoundValue);

  If FBorder then begin
    Canvas.Pen.Color := FBorderColor;
    Canvas.MoveTo(0,0);
    Canvas.LineTo(0,RoundValue);
    Canvas.MoveTo(0,0);
    Canvas.LineTo(RoundValue,0);
  end;
end;

procedure TSharpERoundPanel.Resize;
var
  H, H2, H3: HRgn;
begin
  Inherited;
  H := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, FRoundValue, FRoundValue);
  H2 := CreateRectRgn(0,0,FRoundValue,FRoundValue);
  H3 := CombineRgn(H2,H2,H,RGN_AND);

  SetWindowRgn(Handle, H3, True);
  Invalidate; 
end;

procedure TSharpERoundPanel.SetBackgroundColor(const Value: TColor);
begin
  FBackgroundColor := Value;
  Invalidate;
end;

procedure TSharpERoundPanel.SetBorder(const Value: Boolean);
begin
  FBorder := Value;
  Invalidate;
end;

procedure TSharpERoundPanel.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TSharpERoundPanel.SetRoundValue(Value: Integer);
begin
  FRoundValue := Value;
  if Parent <> nil then
    Resize;
end;



end.

