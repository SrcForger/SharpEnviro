{
Source Name: SharpECheckBox
Description: Skinned CheckBox for SharpE
Copyright (C) Malx (Malx@techie.com)

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
unit SharpECheckBox;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  gr32,
  SharpEBase,
  SharpESkinPart,
  SharpEBaseControls,
  SharpEDefault,
  SharpEScheme,
  SharpESkinManager,
  math;

type
  TSharpECheckBox = class(TCustomSharpEGraphicControl)
  private
    FChecked: Boolean;
    FCaption: TCaption;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message
      CM_FOCUSCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure SetChecked(Value: boolean);
    procedure SetCaption(const Value: TCaption);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;

  published
    //property Align;
    property Anchors;
    property Checked: Boolean read FChecked write SetChecked;
    property Caption: TCaption read FCaption write SetCaption;
    property Constraints;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
    //property TabOrder;
    //property TabStop default True;
    property AutoSize;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;
   { Published declarations }
  end;

implementation

uses
  GR32_POLYGONS;

constructor TSharpECheckBox.Create;
begin
  inherited Create(AOwner);
  Width := 75;
  Height := 25;
  FChecked := false;
end;

procedure TSharpECheckBox.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

procedure TSharpECheckBox.SetChecked(Value: boolean);
begin
  if Value <> FChecked then
  begin
    FChecked := Value;
    invalidate;
  end;
end;

procedure TSharpECheckBox.CMDialogKey(var Message: TCMDialogKey);
begin
 { with Message do
    if  (((CharCode = VK_RETURN) and FActive) or
      ((CharCode = VK_ESCAPE) and FCancel)) and
      (KeyDataToShiftState(Message.KeyData) = []) and CanFocus then
    begin
      Click;
      Result := 1;
    end else   }
  inherited;
end;

procedure TSharpECheckBox.CMDialogChar(var Message: TCMDialogChar);
begin
 { with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      Click;
      Result := 1;
    end else }

  inherited;
end;

procedure TSharpECheckBox.CMFocusChanged(var Message: TCMFocusChanged);
begin
  {with Message do
    if Sender is TButton then
      FActive := Sender = Self
    else
      FActive := FDefault;
  SetButtonStyle(FActive); }
  inherited;
end;

procedure TSharpECheckBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpECheckBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then
    FChecked := not FChecked;
  UpdateSkin;
end;

procedure TSharpECheckBox.SMouseEnter;
begin
  UpdateSkin;
end;

procedure TSharpECheckBox.SMouseLeave;
begin
  UpdateSkin;
end;

procedure TSharpECheckBox.DrawDefaultSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
var x, y: integer;
  r: TRect;
  p: TPolygon32;

begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    DefaultSharpESkinText.AssignFontTo(Bmp.Font,Scheme);
    DrawMode := dmBlend;
    r := Rect(1, 1, 12, 12);
    //bmp.FillRectS(r,clWhite32);

    y := floor((Height - r.bottom) / 2);
    FillRectS(r.Left, r.Top + y, r.Right, r.Bottom + y,
      color32(Scheme.GetColorByName('WorkArealight')));
    FrameRectS(r.Left, r.Top + y, r.Right, r.Bottom + y,
      color32(Scheme.GetColorByName('WorkAreadark')));

    if FChecked then
    begin
      p := TPolygon32.Create;
      try

        p.Add(FixedPoint(3, 6 + y));
        p.Add(FixedPoint(5, 4 + y));
        p.Add(FixedPoint(7, 6 + y));
        p.Add(FixedPoint(12, 1 + y));
        p.Add(FixedPoint(14, 3 + y));
        p.Add(FixedPoint(7, 10 + y));
        p.DrawFill(bmp, color32(Scheme.GetColorByName('Throbberback')));
      finally
        p.free;
      end;
    end;

    x := 16;
    if FAutoSize then
    begin
      if (bmp.TextWidth(caption) + 16) <> Width then
      begin
        Width := (bmp.TextWidth(caption) + 16);
        exit;
      end;
    end;
    y := floor((Height - TextHeight(Caption)) / 2);
    RenderText(x, y, caption, 1, color32(font.color));
  end;
end;

procedure TSharpECheckBox.DrawManagedSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
var
  r, TextRect, CompRect: TRect;
  p: TPoint;
  SkinText : TSkinText;
begin
  CompRect := Rect(0, 0, width, height);
  if FManager.Skin.CheckBoxSkin.Valid then
  begin
    if FAutoSize then
    begin
      r := FManager.Skin.CheckBoxSkin.GetAutoDim(CompRect);
      if (r.Right <> width) or (r.Bottom <> height) then
      begin
        width := r.Right;
        height := r.Bottom;
        Exit;
      end;
    end;

    if (csDesigning in componentstate) then
    begin
      FButtonDown := False;
      FButtonOver := False;
    end;

    FSkin.Clear(Color32(0, 0, 0, 0));
    if not (Enabled) and not (FManager.Skin.CheckBoxSkin.Disabled.Empty) then
    begin
      FManager.Skin.CheckBoxSkin.Disabled.Draw(bmp, Scheme);
      SkinText := CreateThemedSkinText(FManager.Skin.CheckBoxSkin.Disabled.SkinText);
      SkinText.AssignFontTo(bmp.Font,Scheme);
      TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
      p := SkinText.GetXY(TextRect, CompRect);
    end
    else
      if FButtonDown and not (FManager.Skin.CheckBoxSkin.Down.Empty) then
      begin
        FManager.Skin.CheckBoxSkin.Down.Draw(bmp, Scheme);
        SkinText := CreateThemedSkinText(FManager.Skin.CheckBoxSkin.Down.SkinText);
        SkinText.AssignFontTo(bmp.Font,Scheme);
        TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
        p := SkinText.GetXY(TextRect, CompRect);
      end
      else
        if FButtonOver and not (FManager.Skin.CheckBoxSkin.Hover.Empty) then
        begin
          FManager.Skin.CheckBoxSkin.Hover.Draw(bmp, Scheme);
          SkinText := CreateThemedSkinText(FManager.Skin.CheckBoxSkin.Hover.SkinText);
          SkinText.AssignFontTo(bmp.Font,Scheme);
          TextRect := Rect(0, 0, bmp.TextWidth(Caption),bmp.TextHeight(Caption));
          p := SkinText.GetXY(TextRect,CompRect);
        end
        else
        begin
          FManager.Skin.CheckBoxSkin.Normal.Draw(bmp, Scheme);
          SkinText := CreateThemedSkinText(FManager.Skin.CheckBoxSkin.Normal.SkinText);
          SkinText.AssignFontTo(bmp.Font,Scheme);
          TextRect := Rect(0, 0, bmp.TextWidth(Caption),bmp.TextHeight(Caption));
          p := SkinText.GetXY(TextRect, CompRect);
        end;
    SkinText.Free;
    if FChecked and not (FManager.Skin.CheckBoxSkin.Checked.Empty) then
    begin
      FManager.Skin.CheckBoxSkin.Checked.Draw(bmp, Scheme);
    end;
    if FAutoSize then
    begin
      if (bmp.TextWidth(caption) + p.X) <> Width then
      begin
        Width := (bmp.TextWidth(caption) + p.X);
        Exit;
      end;
    end;
    bmp.RenderText(p.X, p.Y, caption, 0, Color32(bmp.Font.color));
  end
  else          
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
end;

procedure TSharpECheckBox.Paint;
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpECheckBox.SetCaption(const Value: TCaption);
begin
  FCaption := Value;

  UpdateSkin;
  Invalidate;
end;

end.
