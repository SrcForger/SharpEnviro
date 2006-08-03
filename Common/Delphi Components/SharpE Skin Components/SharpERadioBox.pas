{
Source Name: SharpERadioBox
Description: Skinned RadioBox for SharpE
Copyright (C) Pixol (pixol@sharpe-shell.org)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

This component are using the GR32 library
http://sourceforge.net/projects/graphics32

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}
unit SharpERadioBox;

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
  SharpEBaseControls,
  SharpEDefault,
  SharpEScheme,
  SharpESkinManager,
  math,
  Types,
  ExtCtrls;

type
  TSharpERadioBox = class(TCustomSharpEGraphicControl)
  private
    FChecked: Boolean;
    FGroupIndex: Integer;
    FCaption: TCaption;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message
      CM_FOCUSCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure SetChecked(Value: boolean);
    procedure SetGroupIndex(const Value: Integer);
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

    procedure Loaded; override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;

  published
    //property Align;
    property Anchors;
    property Checked: Boolean read FChecked write SetChecked;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex;
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

constructor TSharpERadioBox.Create;
begin
    ControlStyle := ControlStyle + [csParentBackground];

  inherited Create(AOwner);
  Width := 75;
  Height := 25;
  FChecked := false;
  FGroupIndex := 0;
end;

procedure TSharpERadioBox.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

procedure TSharpERadioBox.SetChecked(Value: boolean);
var
  i: integer;
begin
  //if Value <> FChecked then
  //begin
  FChecked := Value;
  if FChecked then
  begin
    if assigned(Parent) and Parent.HandleAllocated then
    begin
      for i := 0 to Parent.ControlCount - 1 do
      begin
        if (Parent.Controls[i] is TSharpERadioBox) and
          (TSharpERadioBox(Parent.Controls[i]) <> Self) and
          (TSharpERadioBox(Parent.Controls[i]).GroupIndex = FGroupIndex) then
          (Parent.Controls[i] as TSharpERadioBox).Checked := false;
      end;
    end;
  end;

  UpdateSkin;
  //end;
end;

procedure TSharpERadioBox.CMDialogKey(var Message: TCMDialogKey);
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

procedure TSharpERadioBox.CMDialogChar(var Message: TCMDialogChar);
begin
 { with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
    begin
      Click;
      Result := 1;
    end else }

  inherited;
end;

procedure TSharpERadioBox.CMFocusChanged(var Message: TCMFocusChanged);
begin
  {with Message do
    if Sender is TButton then
      FActive := Sender = Self
    else
      FActive := FDefault;
  SetButtonStyle(FActive); }
  inherited;
end;

procedure TSharpERadioBox.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpERadioBox.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then

    if not (Fchecked) then
      SetChecked(True);

  UpdateSkin;
end;

procedure TSharpERadioBox.SMouseEnter;
begin
  UpdateSkin;
end;

procedure TSharpERadioBox.SMouseLeave;
begin
  UpdateSkin;
end;

procedure TSharpERadioBox.DrawDefaultSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
var x, y: integer;
  r: TRect;

begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    DefaultSharpESkinText.AssignFontTo(bmp.Font,Scheme);
    DrawMode := dmBlend;
    r := Rect(1, 1, 12, 12);

    y := floor((Height - r.bottom) / 2);
    FillRectS(r.Left, r.Top + y, r.Right, r.Bottom + y,
      color32(Scheme.WorkArealight));
    FrameRectS(r.Left, r.Top + y, r.Right, r.Bottom + y,
      color32(Scheme.WorkAreadark));

    if FChecked then
    begin
      bmp.FillRectS(Types.Rect(r.Left+2,r.Top+2+y,R.Right-2,r.Bottom-2+y),color32(Scheme.Throbberback));
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

procedure TSharpERadioBox.DrawManagedSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
var r, TextRect, CompRect: TRect;
  p: TPoint;

begin
  CompRect := Rect(0, 0, width, height);
  if FManager.Skin.RadioBoxSkin.Valid then
  begin
    if FAutoSize then
    begin
      r := FManager.Skin.RadioBoxSkin.GetAutoDim(CompRect);
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
    if not (Enabled) and not (FManager.Skin.RadioBoxSkin.Disabled.Empty) then
    begin
      FManager.Skin.RadioBoxSkin.Disabled.Draw(bmp, Scheme);
      FManager.Skin.RadioBoxSkin.Disabled.SkinText.AssignFontTo(bmp.Font, Scheme);
      TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
      p := FManager.Skin.RadioBoxSkin.Disabled.SkinText.GetXY(TextRect, CompRect);
    end
    else
      if FButtonDown and not (FManager.Skin.RadioBoxSkin.Down.Empty) then
      begin
        FManager.Skin.RadioBoxSkin.Down.Draw(bmp, Scheme);
        FManager.Skin.RadioBoxSkin.Down.SkinText.AssignFontTo(bmp.Font, Scheme);
        TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
        p := FManager.Skin.RadioBoxSkin.Down.SkinText.GetXY(TextRect, CompRect);
      end
      else
        if FButtonOver and not (FManager.Skin.RadioBoxSkin.Hover.Empty) then
        begin
          FManager.Skin.RadioBoxSkin.Hover.Draw(bmp, Scheme);
          FManager.Skin.RadioBoxSkin.Hover.SkinText.AssignFontTo(bmp.Font, Scheme);
          TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
          p := FManager.Skin.RadioBoxSkin.Hover.SkinText.GetXY(TextRect, CompRect);
        end
        else
        begin
          FManager.Skin.RadioBoxSkin.Normal.Draw(bmp, Scheme);
          FManager.Skin.RadioBoxSkin.Normal.SkinText.AssignFontTo(bmp.Font, Scheme);
          TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
          p := FManager.Skin.RadioBoxSkin.Normal.SkinText.GetXY(TextRect, CompRect);
        end;
    if FChecked and not (FManager.Skin.RadioBoxSkin.Checked.Empty) then
    begin
      FManager.Skin.RadioBoxSkin.Checked.Draw(bmp, Scheme);
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
    DrawDefaultSkin(bmp, Scheme);
end;

procedure TSharpERadioBox.SetGroupIndex(const Value: Integer);
begin
  if Value <> FGroupIndex then
    FGroupIndex := Value;

  UpdateSkin;
end;

procedure TSharpERadioBox.Loaded;
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpERadioBox.SetCaption(const Value: TCaption);
begin
  FCaption := Value;
  UpdateSkin;

  Invalidate;
end;

procedure TSharpERadioBox.Paint;
begin
  inherited;
  UpdateSkin;
end;

end.
