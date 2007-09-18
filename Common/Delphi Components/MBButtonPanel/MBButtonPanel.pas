{
Source Name: MBButtonPanel
Description: Custom panel component
Copyright (C) Lee Green (lee@sharpenviro.com)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit MBButtonPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TButtonState = (BsDown, BsUp);

type
  TGradientDirection = (gdVertical, gdHorizontal);

type
  TMBButtonPanel = class(TCustomPanel)
  private
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    IsMouseOver, IsMouseDown, IsMouseUp: Boolean;
    FFocusedBorderColor: TColor;
    FBorderColor: TColor;
    FFocusedColor: Tcolor;
    FGlyph: TImage;
    FDetail: string;
    FTitle: string;
    FFocusedGradientFrom: Tcolor;
    FFocusedGradientTo: Tcolor;
    FGradientFrom: Tcolor;
    FGradientTo: Tcolor;
    FState: TButtonState;
    FTitleOffset: TPoint;
    FDetailoffset: TPoint;
    FDetailoffsetY: Integer;
    FTitleOffsetX: Integer;
    FTitleOffsetY: Integer;
    FDetailoffsetX: Integer;
    FTitleFont: TFont;
    FDetailFont: TFont;
    FImageOffsetY: Integer;
    FImageOffsetX: Integer;
    FTempColor1: Tcolor;
    FTempColor2: Tcolor;
    FDisabledTextColor: TColor;
    FDisabledColor: TColor;
    FDisabledBorderColor: TColor;
    FGlyphEnabled: Boolean;
    FBoldTitle: Boolean;
    FBoldDetail: Boolean;
    FGradientDirection: TGradientDirection;
    FEnabled: Boolean;
    FCenterTitle: Boolean;
    FDownGradientTo: Tcolor;
    FDownGradientFrom: Tcolor;
    { Private declarations }
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure SetBorderColor(const Value: TColor);
    procedure SetFocusedBorderColor(const Value: TColor);
    procedure SetFocusedColor(const Value: Tcolor);
    procedure SetGlyph(const Value: Timage);
    procedure SetDetail(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetFocusedGradientFrom(const Value: Tcolor);
    procedure SetFocusedGradientTo(const Value: Tcolor);
    procedure SetGradientFrom(const Value: Tcolor);
    procedure SetGradientTo(const Value: Tcolor);
    procedure SetState(const Value: TButtonState);

    procedure SetDetailoffsetX(const Value: Integer);
    procedure SetDetailoffsetY(const Value: Integer);
    procedure SetTitleOffsetX(const Value: Integer);
    procedure SetTitleOffsetY(const Value: Integer);
    procedure SetDetailFont(const Value: TFont);
    procedure SetTitleFont(const Value: TFont);
    procedure SetImageOffsetX(const Value: Integer);
    procedure SetImageOffsetY(const Value: Integer);
    procedure SetDisabledColor(const Value: TColor);
    procedure SetDisabledTextColor(const Value: TColor);
    procedure SetDisabledBorderColor(const Value: TColor);
    procedure SetGlyphEnabled(const Value: Boolean);
    procedure SetBoldTitle(const Value: Boolean);
    procedure SetBoldDetail(const Value: Boolean);
    procedure SetGradientDirection(const Value: TGradientDirection);
    procedure SetEnabled(const Value: Boolean);
    procedure SetCenterTitle(const Value: Boolean);
    procedure SetDownGradientFrom(const Value: Tcolor);
    procedure SetDownGradientTo(const Value: Tcolor);
    function FillGradient(DC: HDC; ARect: TRect; ColorCount: Integer;
  StartColor, EndColor: TColor; ADirection: TGradientDirection): Boolean; overload;
  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
  published
    { Published declarations }

    {Misc Properties}
    property State: TButtonState read FState write SetState default bsUp;
    property GlyphEnabled: Boolean read FGlyphEnabled Write SetGlyphEnabled;
    property BoldTitle: Boolean read FBoldTitle write SetBoldTitle;
    property BoldDetail: Boolean read FBoldDetail write SetBoldDetail;
    property GradentDirection: TGradientDirection read FGradientDirection write SetGradientDirection;
    property Enabled: Boolean read FEnabled Write SetEnabled;

    {Text Properties}
    property Title: string read FTitle write SetTitle;
    property Detail: string read FDetail write SetDetail;

    {Color properties}
    property BorderColor: TColor read FBorderColor write SetBorderColor;
    property FocusedBordercolor: TColor read FFocusedBorderColor write SetFocusedBorderColor;
    property FocusedColor: Tcolor read FFocusedColor write SetFocusedColor;
    property DisabledTextColor: TColor read FDisabledTextColor write SetDisabledTextColor;
    property DisabledBorderColor: TColor read FDisabledBorderColor write SetDisabledBorderColor;
    property DisabledColor: TColor read FDisabledColor write SetDisabledColor;

    {gradient specific properties}
    property GradientFrom: Tcolor read FGradientFrom write SetGradientFrom;
    property GradientTo: Tcolor read FGradientTo write SetGradientTo;
    property FocusedGradientFrom: Tcolor read FFocusedGradientFrom write SetFocusedGradientFrom;
    property FocusedGradientTo: Tcolor read FFocusedGradientTo write SetFocusedGradientTo;
    property DownGradientFrom: Tcolor read FDownGradientFrom write SetDownGradientFrom;
    property DownGradientTo: Tcolor read FDownGradientTo write SetDownGradientTo;

    {Used to define the button image}
    property Glyph: TImage read FGlyph write SetGlyph;

    {Offsets for the image and titie}
    property CenterTitle: Boolean read FCenterTitle write SetCenterTitle default false;
    property TitleoffsetX: Integer read FTitleOffsetX write SetTitleOffsetX default 0;
    property DetailoffsetX: Integer read FDetailoffsetX write SetDetailoffsetX default 0;
    property TitleoffsetY: Integer read FTitleOffsetY write SetTitleOffsetY default 0;
    property DetailoffsetY: Integer read FDetailoffsetY write SetDetailoffsetY default 0;
    property ImageOffsetX: Integer read FImageOffsetX write SetImageOffsetX;
    property ImageOffsetY: Integer read FImageOffsetY write SetImageOffsetY;

    {Used to store temporary colours}
    property TempColor1: Tcolor read FTempColor1 write FTempColor1;
    property TempColor2: Tcolor read FTempColor2 write FTempColor2;

    procedure MouseDown (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp (Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;

    {inherited}
    property Font;
    property Color;
    property ParentColor;
    property Visible;
    property Align;
    property Alignment;
    property Cursor;
    property Hint;
    property ParentShowHint;
    property ShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseDown;
    property OnResize;
    property OnStartDrag;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    procedure Paint; override;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('SharpE', [TMBButtonPanel]);
end;

{ TMBButtonPanel }

procedure TMBButtonPanel.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  IsMouseOver := true;
  Paint;

  {trigger onmouseenter event}
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);

end;

procedure TMBButtonPanel.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  isMouseOver := false;
  Paint;

  {trigger onmouseleave event}
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
end;

constructor TMBButtonPanel.Create(AOwner: TComponent);
begin
  inherited;

  {default property settings}
  FState := BSUp;
  FBorderColor := clBtnShadow;
  FFocusedColor := clBtnFace;
  FFocusedGradientFrom := clBtnFace;
  FFocusedGradientTo := clBtnHighlight;
  FGradientFrom := clBtnHighlight;
  FGradientTo := clBtnShadow;
  FEnabled := True;
end;

procedure TMBButtonPanel.MouseDown(Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  IsMouseUp := False;
  IsMouseDown := True;
  Invalidate;
end;

procedure TMBButtonPanel.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  IsMouseUp := True;
  IsMouseDown := False;
  Invalidate;
end;

procedure TMBButtonPanel.Paint;
var
  memoryBitmap, aMemoryBitmap: TBitmap;
  CaptionRect: Trect;
  GradientRect: Trect;
  TitleX,X: Integer;
  bEnabled: Boolean;
begin
  memoryBitmap := TBitmap.Create;
  AmemoryBitmap := TBitmap.Create;
  try
    {Initialise memory bitmap}
    memoryBitmap.Height := ClientRect.Bottom;
    memoryBitmap.Width := ClientRect.Right;
    AmemoryBitmap.Height := ClientRect.Bottom;
    AmemoryBitmap.Width := ClientRect.Right;

    {Initialise Rect dimensions}
    GradientRect := ClientRect;
    InFlateRect(GradientRect, -1, -1);

    if Parent.Enabled = false then
    bEnabled := false else
    bEnabled := FEnabled;

    {Draw Border and panel col depending on state}
    if (IsMouseDown) and (bEnabled = True) then
    Begin
      memoryBitmap.Canvas.Brush.Color := FDownGradientFrom;
      memoryBitmap.Canvas.pen.Color := FFocusedBorderColor;
      memoryBitmap.Canvas.FillRect(ClientRect);
      memoryBitmap.Canvas.Rectangle(ClientRect);
      FillGradient(memoryBitmap.Canvas.Handle, GradientRect, 255, FDownGradientFrom, FDownGradientTo, FgradientDirection);
    end
    else if (IsMouseOver or (FState = bsDown)) and (bEnabled = True) then
    begin
      memoryBitmap.Canvas.Brush.Color := FFocusedColor;
      memoryBitmap.Canvas.pen.Color := FFocusedBorderColor;
      memoryBitmap.Canvas.FillRect(ClientRect);
      memoryBitmap.Canvas.Rectangle(ClientRect);
      FillGradient(memoryBitmap.Canvas.Handle, GradientRect, 255, FFocusedGradientFrom, FFocusedGradientTo, FgradientDirection);
    end
    else if ((FState = bsUp) or (IsMouseUp) ) and (bEnabled = True) then
    begin
      memoryBitmap.Canvas.Brush.Color := Color;
      memoryBitmap.Canvas.pen.Color := FBorderColor;
      memoryBitmap.Canvas.FillRect(ClientRect);
      memoryBitmap.Canvas.Rectangle(ClientRect);
      FillGradient(memoryBitmap.Canvas.Handle, GradientRect, 255, FGradientFrom, FGradientTo, FgradientDirection);
    end
    else if (bEnabled = False) then
    Begin
      memoryBitmap.Canvas.Brush.Color := FDisabledColor;
      memoryBitmap.Canvas.pen.Color := FDisabledBorderColor;
      memoryBitmap.Canvas.FillRect(ClientRect);
      memoryBitmap.Canvas.Rectangle(ClientRect);
      FillGradient(memoryBitmap.Canvas.Handle, GradientRect, 255, FDisabledColor, FDisabledColor, FgradientDirection);
    end;

    {Draw panel glyph}
    if GlyphEnabled then
    Begin
      if Assigned(FGlyph) and (FGlyph.Picture <> nil) then
        memoryBitmap.Canvas.Draw(fimageoffsetx, fimageoffsety, FGlyph.Picture.Graphic);

      TitleX := 50;

    end
    else
      TitleX := 4;

    {Draw Caption}
    SetBkMode(MemoryBitmap.Canvas.Handle, windows.TRANSPARENT);
    memoryBitmap.Canvas.Font := self.Font;

    {Check if disabled, if so assign the disabled text color}
    if bEnabled = False then
    begin
      MemoryBitmap.Canvas.Font.Color := FDisabledTextColor;
    end
    else
      MemoryBitmap.Canvas.Font.Color := Font.Color;

    {Draw the title text}
    if FBoldTitle then
    memoryBitmap.Canvas.Font.Style := [fsBold];

    if FCenterTitle then
    Begin
      x := (self.Width div 2) - (Self.Canvas.TextWidth(FTitle) div 2 );
      memoryBitmap.Canvas.TextOut(x, 8 + ftitleoffsety, FTitle)
    End
    else
    memoryBitmap.Canvas.TextOut(TitleX + ftitleoffsetX, 8 + ftitleoffsety, FTitle);

    {Draw the detail text}
    if FBoldDetail then
    memoryBitmap.Canvas.Font.Style := [fsbold] else
    memoryBitmap.Canvas.Font.Style := [];
    memoryBitmap.Canvas.TextOut(TitleX + fdetailoffsetx, 20 + fdetailoffsety, FDetail);

    // Copy memoryBitmap to screen
    canvas.CopyRect(ClientRect, memoryBitmap.canvas, ClientRect);

  finally
    memoryBitmap.Free;
    AmemoryBitmap.Free;
  end;
end;

procedure TMBButtonPanel.SetBoldDetail(const Value: Boolean);
begin
  FBoldDetail := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetBoldTitle(const Value: Boolean);
begin
  FBoldTitle := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetBorderColor(const Value: TColor);
begin
  FBorderColor := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetCenterTitle(const Value: Boolean);
begin
  FCenterTitle := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetDetail(const Value: string);
begin
  FDetail := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetDetailFont(const Value: TFont);
begin
  FDetailFont.Assign(Value);
  Invalidate;
end;

procedure TMBButtonPanel.SetDetailoffsetX(const Value: Integer);
begin
  FDetailoffsetX := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetDetailoffsetY(const Value: Integer);
begin
  FDetailoffsetY := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetDisabledBorderColor(const Value: TColor);
begin
  FDisabledBorderColor := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetDisabledColor(const Value: TColor);
begin
  FDisabledColor := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetDisabledTextColor(const Value: TColor);
begin
  FDisabledTextColor := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetDownGradientFrom(const Value: Tcolor);
begin
  FDownGradientFrom := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetDownGradientTo(const Value: Tcolor);
begin
  FDownGradientTo := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetEnabled(const Value: Boolean);
begin
  FEnabled := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetFocusedBorderColor(const Value: TColor);
begin
  FFocusedBorderColor := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetFocusedColor(const Value: Tcolor);
begin
  FFocusedColor := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetFocusedGradientFrom(const Value: Tcolor);
begin
  FFocusedGradientFrom := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetFocusedGradientTo(const Value: Tcolor);
begin
  FFocusedGradientTo := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetGlyph(const Value: TImage);
begin
  FGlyph := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetGlyphEnabled(const Value: Boolean);
begin
  FGlyphEnabled := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetGradientDirection(
  const Value: TGradientDirection);
begin
  FGradientDirection := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetGradientFrom(const Value: Tcolor);
begin
  FGradientFrom := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetGradientTo(const Value: Tcolor);
begin
  FGradientTo := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetImageOffsetX(const Value: Integer);
begin
  FImageOffsetX := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetImageOffsetY(const Value: Integer);
begin
  FImageOffsetY := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetState(const Value: TButtonState);
begin
  FState := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetTitle(const Value: string);
begin
  FTitle := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetTitleFont(const Value: TFont);
begin
  FTitleFont.Assign(Value);
  Invalidate;
end;

procedure TMBButtonPanel.SetTitleOffsetX(const Value: Integer);
begin
  FTitleOffsetX := Value;
  Invalidate;
end;

procedure TMBButtonPanel.SetTitleOffsetY(const Value: Integer);
begin
  FTitleOffsetY := Value;
  Invalidate;
end;

function TMBButtonPanel.FillGradient(DC: HDC; ARect: TRect; ColorCount: Integer;
  StartColor, EndColor: TColor; ADirection: TGradientDirection): Boolean;
var
  StartRGB: array [0..2] of Byte;
  RGBKoef: array [0..2] of Double;
  Brush: HBRUSH;
  AreaWidth, AreaHeight, I: Integer;
  ColorRect: TRect;
  RectOffset: Double;
begin
  RectOffset := 0;
  Result := False;
  if ColorCount < 1 then
    Exit;
  StartColor := ColorToRGB(StartColor);
  EndColor := ColorToRGB(EndColor);
  StartRGB[0] := GetRValue(StartColor);
  StartRGB[1] := GetGValue(StartColor);
  StartRGB[2] := GetBValue(StartColor);
  RGBKoef[0] := (GetRValue(EndColor) - StartRGB[0]) / ColorCount;
  RGBKoef[1] := (GetGValue(EndColor) - StartRGB[1]) / ColorCount;
  RGBKoef[2] := (GetBValue(EndColor) - StartRGB[2]) / ColorCount;
  AreaWidth := ARect.Right - ARect.Left;
  AreaHeight :=  ARect.Bottom - ARect.Top;
  case ADirection of
    gdHorizontal:
      RectOffset := AreaWidth / ColorCount;
    gdVertical:
      RectOffset := AreaHeight / ColorCount;
  end;
  for I := 0 to ColorCount - 1 do
  begin
    Brush := CreateSolidBrush(RGB(
      StartRGB[0] + Round((I + 1) * RGBKoef[0]),
      StartRGB[1] + Round((I + 1) * RGBKoef[1]),
      StartRGB[2] + Round((I + 1) * RGBKoef[2])));
    case ADirection of
      gdHorizontal:
        SetRect(ColorRect, Round(RectOffset * I), 0, Round(RectOffset * (I + 1)), AreaHeight);
      gdVertical:
        SetRect(ColorRect, 0, Round(RectOffset * I), AreaWidth, Round(RectOffset * (I + 1)));
    end;
    OffsetRect(ColorRect, ARect.Left, ARect.Top);
    FillRect(DC, ColorRect, Brush);
    DeleteObject(Brush);
  end;
  Result := True;
end;

end.

