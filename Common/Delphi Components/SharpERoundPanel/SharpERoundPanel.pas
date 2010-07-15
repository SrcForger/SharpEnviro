unit SharpERoundPanel;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  ExtCtrls,
  Graphics;

type
  TSharpERoundPanelDrawMode = (srpNormal, srpNoTopLeft, srpNoTopRight,
    srpNoBottomLeft, srpNoBottomRight, srpNoTop, srpNoBottom);

type
  TSharpERoundPanel = class(TPanel)
  private
    FRoundValue: Integer;
    FBorderColor: TColor;
    FBorder: Boolean;
    FBackgroundColor: TColor;
    FDrawMode: TSharpERoundPanelDrawMode;
    FNoTopBorder: Boolean;
    FNoBottomBorder: Boolean;
    FBottomSideBorder : Boolean;
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
    property NoBottomBorder: Boolean read FNoBottomBorder write FNoBottomBorder;
    property RoundValue: Integer read FRoundValue write SetRoundValue;
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property Border: Boolean read FBorder write SetBorder;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    property BottomSideBorder : Boolean read FBottomSideBorder write FBottomSideBorder;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpERoundPanel]);
end;

constructor TSharpERoundPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
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
    Canvas.Pen.Color := FBorderColor
  else
    Canvas.Pen.Color := Color;

  Canvas.Brush.Color := Color;
  if (FBorder and (FNoTopBorder or FNoBottomBorder)) then
  begin
    if (FNoTopBorder and FNoBottomBorder) then
      Canvas.RoundRect(0, 0 - 1, Width, Height + 1, RoundValue, RoundValue)
    else if FNoTopBorder then
      Canvas.RoundRect(0, 0 - 1, Width, Height, RoundValue, RoundValue)
    else if FNoBottomBorder then
      Canvas.RoundRect(0, 0, Width, Height + 1, RoundValue, RoundValue);
  end else Canvas.RoundRect(0, 0, Width, Height, RoundValue, RoundValue);

  Canvas.Pen.Color := Color;

  case FDrawMode of
    srpNoTopLeft: Canvas.Rectangle(0, 0, RoundValue, RoundValue);
    srpNoTopRight: Canvas.Rectangle(Width - RoundValue, 0, Width, RoundValue);
    srpNoBottomLeft: Canvas.Rectangle(0, Height - RoundValue, RoundValue, Height);
    srpNoBottomRight: Canvas.Rectangle(Width - RoundValue, Height - RoundValue, Width, Height);
    srpNoTop: begin
        Canvas.Rectangle(0, 0, RoundValue, RoundValue);
        Canvas.Rectangle(Width - RoundValue, 0, Width, RoundValue);
      end;
    srpNoBottom: begin
        Canvas.Rectangle(0, Height - RoundValue, RoundValue, Height);
        Canvas.Rectangle(Width - RoundValue, Height - RoundValue, Width, Height);
      end;
  end;

  if FBorder then begin
    Canvas.Pen.Color := FBorderColor;

    if (FDrawMode = srpNoTopLeft) or (FDrawMode = srpNoTop) then
    begin
      Canvas.MoveTo(0, 0);
      Canvas.LineTo(0, RoundValue);
      if not FNoTopBorder then
      begin
        Canvas.MoveTo(0, 0);
        Canvas.LineTo(RoundValue, 0);
      end;
    end; // No "else if" because of the "or" clause

    if (FDrawMode = srpNoTopRight) or (FDrawMode = srpNoTop) then
    begin
      Canvas.MoveTo(Width - 1, 0);
      Canvas.LineTo(Width - 1, 0 + RoundValue);
      if not FNoTopBorder then
      begin
        Canvas.MoveTo(Width - RoundValue, 0);
        Canvas.LineTo(Width, 0);
      end;
    end;

    if (FDrawMode = srpNoBottomLeft) or (FDrawMode = srpNoBottom) then
    begin
      Canvas.MoveTo(0, Height);
      Canvas.LineTo(0, Height - RoundValue - 1);
      if not FNoBottomBorder then
      begin
        Canvas.MoveTo(0, Height - 1);
        Canvas.LineTo(0 + RoundValue, Height - 1);
      end;
    end;

    if (FDrawMode = srpNoBottomRight) or (FDrawMode = srpNoBottom) then
    begin
      Canvas.MoveTo(Width - 1, Height);
      Canvas.LineTo(Width - 1, Height - RoundValue - 1);
      if not FNoBottomBorder then
      begin
        Canvas.MoveTo(Width - 1, Height - 1);
        Canvas.LineTo(Width - RoundValue, Height - 1);
      end;
    end;

    if FBottomSideBorder then
    begin
      Canvas.MoveTo(0,Height);
      Canvas.LineTo(0, Height - RoundValue - 1);
      Canvas.MoveTo(Width - 1, Height);
      Canvas.LineTo(Width - 1, Height - RoundValue - 1);      
    end;
  end;
end;

procedure TSharpERoundPanel.Resize;
var
  H, H2, H3: HRgn;
begin
  inherited;
  H := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, FRoundValue, FRoundValue);

  case FDrawMode of
    srpNoTopLeft: H2 := CreateRectRgn(0, 0, FRoundValue, FRoundValue);
    srpNoTopRight: H2 := CreateRectRgn(Width - RoundValue, 0, Width, RoundValue);
    srpNoBottomLeft: H2 := CreateRectRgn(0, Height - RoundValue, RoundValue, Height);
    srpNoBottomRight: H2 := CreateRectRgn(Width - RoundValue, Height - RoundValue, Width, Height);
  else
    H2 := H;
  end;

  H3 := CombineRgn(H2, H2, H, RGN_AND);
  if (H2 <> H) then
    DeleteObject(H2);
  DeleteObject(H);

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

