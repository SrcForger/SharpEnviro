{
Source Name: SharpEMiniThrobber
Description: SharpE component for SharpE
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit SharpEMiniThrobber;

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
  math;

type
  TSharpEMiniThrobber = class(TCustomSharpEGraphicControl)
  private
    FCancel: Boolean;
    procedure CMDialogKey(var Message: TCMDialogKey); message CM_DIALOGKEY;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMFocusChanged(var Message: TCMFocusChanged); message CM_FOCUSCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;

  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
  published
    property Anchors;
    property Cancel: Boolean read FCancel write FCancel default False;
    property Constraints;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
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

constructor TSharpEMiniThrobber.Create;
begin
  inherited Create(AOwner);
  Width := 7;
  Height := 9;
  FAutoSize := True;
end;

procedure TSharpEMiniThrobber.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

procedure TSharpEMiniThrobber.CMDialogKey(var Message: TCMDialogKey);
begin
  inherited;
end;

procedure TSharpEMiniThrobber.CMDialogChar(var Message: TCMDialogChar);
begin
  inherited;
end;

procedure TSharpEMiniThrobber.CMFocusChanged(var Message: TCMFocusChanged);
begin
  inherited;
end;

procedure TSharpEMiniThrobber.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEMiniThrobber.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  UpdateSkin;
end;

procedure TSharpEMiniThrobber.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
end;

procedure TSharpEMiniThrobber.SMouseEnter;
begin
  UpdateSkin;
end;

procedure TSharpEMiniThrobber.SMouseLeave;
begin
  UpdateSkin;
end;

procedure TSharpEMiniThrobber.DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  r: TRect;
begin
  if FAutoSize then
  begin
    if (Width<>7) or (height<>9) then
    begin
      width := 7;
      height := 9;
      exit;
    end;
  end;
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    DefaultSharpESkinText.AssignFontTo(Font,Scheme);
    DrawMode := dmBlend;
    r := Rect(0, 0, Width, Height);
    if true then
    begin
      FrameRectS(0, 0, Width, Height, color32(clblack));
      Inc(r.Left); Inc(r.Top); Dec(r.Bottom); Dec(r.Right);
    end;
    if FButtonDown then
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('ThrobberLight')), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('ThrobberDark')), 255));
    end
    else
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('Throbberdark')), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('ThrobberLight')), 255));
    end;
    FillRect(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1,
      setalpha(color32(Scheme.GetColorByName('ThrobberBack')), 255));
  end;
end;

procedure TSharpEMiniThrobber.DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  r, CompRect: TRect;
begin
  CompRect := Rect(0, 0, width, height);
  if FAutoSize then
  begin
    r := FManager.Skin.MiniThrobberSkin.GetAutoDim(CompRect);
    if (r.Right <> width) or (r.Bottom <> height) then
    begin
      width := r.Right;
      height := r.Bottom;
      Exit;
    end;
  end;
  if FManager.Skin.MiniThrobberSkin.Valid then
  begin
    FSkin.Clear(Color32(0, 0, 0, 0));
    if FButtonDown and not (FManager.Skin.MiniThrobberSkin.Down.Empty) then
    begin
      FManager.Skin.MiniThrobberSkin.Down.Draw(bmp, Scheme);
      FManager.Skin.MiniThrobberSkin.Down.SkinText.AssignFontTo(bmp.Font, Scheme);
    end
    else
      if FButtonOver and not (FManager.Skin.MiniThrobberSkin.Hover.Empty) then
      begin
        FManager.Skin.MiniThrobberSkin.Hover.Draw(bmp, Scheme);
        FManager.Skin.MiniThrobberSkin.Hover.SkinText.AssignFontTo(bmp.Font, Scheme);
      end
      else
      begin
        FManager.Skin.MiniThrobberSkin.Normal.Draw(bmp, Scheme);
        FManager.Skin.MiniThrobberSkin.Normal.SkinText.AssignFontTo(bmp.Font, Scheme);
      end;
  end
  else
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
end;

end.
