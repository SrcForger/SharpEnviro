unit SharpERoundPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics;

type
  TSharpERoundPanel = class(TPanel)
  private
    FRoundValue: Integer;
    FBorderColor: TColor;
    procedure SetBorderColor(const Value: TColor);
  protected
    procedure Resize; override;
    procedure Paint; override;
    procedure SetRoundValue(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property RoundValue: Integer read FRoundValue write SetRoundValue;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
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
  FRoundValue := 8;
end;

procedure TSharpERoundPanel.Paint;
begin
  Canvas.Pen.Color := FBorderColor;
  Canvas.Brush.Color := Color;
  Canvas.FillRect(ClientRect);
  Canvas.RoundRect(0, 0, Width, Height, RoundValue, RoundValue);
end;

procedure TSharpERoundPanel.Resize;
var
  H: HRgn;
begin
  Inherited;
  H := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, FRoundValue, FRoundValue);
  SetWindowRgn(Handle, H, True);
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

