unit SharpERoundPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, ExtCtrls, Graphics;

type
  TSharpERoundPanelDrawMode = (srpNormal, srpNoTopLeft, srpNoTopRight,
    srpNoBottomLeft, srpNoBottomRight);

type
  TSharpERoundPanel = class(TPanel)
  private
    FRoundValue: Integer;
    FBorderColor: TColor;
    FBorder: Boolean;
    FBackgroundColor: TColor;
    FDrawMode: TSharpERoundPanelDrawMode;
    FNoTopBorder: Boolean;
    procedure SetBorderColor(const Value: TColor);
    procedure SetBorder(const Value: Boolean);
    procedure SetBackgroundColor(const Value: TColor);
    procedure SetDrawMode(const Value: TSharpERoundPanelDrawMode);
  protected
    procedure Resize; override;
    procedure Paint; override;
    procedure SetRoundValue(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property DrawMode: TSharpERoundPanelDrawMode read FDrawMode write SetDrawMode;

    property NoTopBorder: Boolean read FNoTopBorder write FNoTopBorder;
    property RoundValue: Integer read FRoundValue write SetRoundValue;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property Border: Boolean read FBorder write SetBorder;
    property BackgroundColor : TColor read FBackgroundColor write SetBackgroundColor;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpERoundPanel]);
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

  case FDrawMode of
    srpNoTopLeft: Canvas.Rectangle(0,0,RoundValue,RoundValue);
    srpNoTopRight: Canvas.Rectangle(Width-RoundValue,0,Width,RoundValue);
    srpNoBottomLeft: Canvas.Rectangle(0,Height-RoundValue,RoundValue,Height);
    srpNoBottomRight: Canvas.Rectangle(Width-RoundValue,Height-RoundValue,Width,Height);
  end;

  If FBorder then begin
    Canvas.Pen.Color := FBorderColor;

    if FDrawMode = srpNoTopLeft then begin
      Canvas.MoveTo(0,0);
      Canvas.LineTo(0,RoundValue);
      Canvas.MoveTo(0,0);
      Canvas.LineTo(RoundValue,0);
    end
    else if FDrawMode = srpNoTopRight then begin
      Canvas.MoveTo(Width-RoundValue,0);
      Canvas.LineTo(Width,0);
      Canvas.MoveTo(Width-1,0);
      Canvas.LineTo(Width-1,0+RoundValue);
    end
    else if FDrawMode = srpNoBottomLeft then begin
      Canvas.MoveTo(0,Height);
      Canvas.LineTo(0,Height-RoundValue-1);
      Canvas.MoveTo(0,Height-1);
      Canvas.LineTo(0+RoundValue,Height-1);
    end
    else if FDrawMode = srpNoBottomRight then begin
      Canvas.MoveTo(Width-1,Height);
      Canvas.LineTo(Width-1,Height-RoundValue-1);
      Canvas.MoveTo(Width-1,Height-1);
      Canvas.LineTo(Width-RoundValue,Height-1);
    end;
  end;
end;

procedure TSharpERoundPanel.Resize;
var
  H, H2, H3: HRgn;
begin
  Inherited;
  H := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, FRoundValue, FRoundValue);

  case FDrawMode of
    srpNoTopLeft: H2 := CreateRectRgn(0,0,FRoundValue,FRoundValue);
    srpNoTopRight: H2 := CreateRectRgn(Width-RoundValue,0,Width,RoundValue);
    srpNoBottomLeft: H2 := CreateRectRgn(0,Height-RoundValue,RoundValue,Height);
    srpNoBottomRight: H2 := CreateRectRgn(Width-RoundValue,Height-RoundValue,Width,Height);
    else
      H2 := H;
  end;

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

procedure TSharpERoundPanel.SetDrawMode(const Value: TSharpERoundPanelDrawMode);
begin
  FDrawMode := Value;
  Invalidate;
end;

procedure TSharpERoundPanel.SetRoundValue(Value: Integer);
begin
  FRoundValue := Value;
  if Parent <> nil then
    Resize;
end;



end.

