{
Source Name: SharpEProgressBar
Description: Skinned ProgressBar component for SharpE
Copyright (C) Malx (Malx@techie.com)

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
unit SharpEProgressBar;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  StdCtrls,
  gr32,
  Graphics,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
  SharpEScheme,
  SharpESkinManager,
  math,
  SharpESkinPart;

type
  TSharpEProgressBar = class(TCustomSharpEGraphicControl)
  private
    FMin: Integer;
    FMax: Integer;
    FValue: Integer;

    procedure SetMin(Value: integer);
    procedure SetMax(Value: integer);
    procedure SetValue(Value: integer);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
  public
    constructor Create(AOwner: TComponent); override;

  published
    //property Align;
    property Anchors;
    property Min: integer read FMin write SetMin;
    property Max: integer read FMax write SetMax;
    property Value: integer read FValue write SetValue;

    property Constraints;
    property Enabled;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
    property AutoSize;
    property Visible;
     { Published declarations }
  end;

implementation

constructor TSharpEProgressBar.Create;
begin
  inherited Create(AOwner);
  Min := 0;
  Max := 100;
  Value := 0;
  Width := 75;
  Height := 25;
end;

procedure TSharpEProgressBar.SetMin(Value: integer);
begin
  if Value <> FMin then
  begin
    FMin := Value;
    Invalidate;
  end;
end;

procedure TSharpEProgressBar.SetMax(Value: integer);
begin
  if Value <> FMax then
  begin
    FMax := Value;
    Invalidate;
  end;
end;

procedure TSharpEProgressBar.SetValue(Value: integer);
begin
  if Value <> FValue then
  begin
    FValue := Value;
    Invalidate;
  end;
end;

procedure TSharpEProgressBar.DrawDefaultSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
var
  r: TRect;
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    DrawMode := dmBlend;
    r := Rect(0, 0, Width, Height);
    if true then
    begin
      FrameRectS(0, 0, Width, Height, color32(clblack));
      Inc(r.Left); Inc(r.Top); Dec(r.Bottom); Dec(r.Right);
    end;
    FrameRectS(r.Left, r.Top, r.Right, r.Bottom, color32(Scheme.GetColorByName('WorkArealight')));
    FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1, color32(Scheme.GetColorByName('WorkAreadark')));
    FillRectS(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1, color32(Scheme.GetColorByName('WorkAreaBack')));
    FillRectS(r.Left + 1, r.Top + 1, r.left + round((r.Right - r.Left - 2) *
              FValue / (FMax - FMin)), r.Bottom - 1, color32(Scheme.GetColorByName('ThrobberBack')));
  end;
end;

procedure TSharpEProgressBar.DrawManagedSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
var r, CompRect: TRect;
  skindim: TSkinDim;
  temp: TBitmap32;
begin

  skindim := TSkinDim.create;
  temp := TBitmap32.create;
  try
    CompRect := Rect(0, 0, width, height);
    if FManager.Skin.ProgressBarSkin.Valid then
    begin
      if FAutoSize then
      begin
        r := FManager.Skin.ProgressBarSkin.GetAutoDim(CompRect);
        if (r.Right <> width) or (r.Bottom <> height) then
        begin
          width := r.Right;
          height := r.Bottom;
          Exit;
        end;
      end;
      bmp.Clear(Color32(0, 0, 0, 0));
      if not (FManager.Skin.ProgressBarSkin.BackGround.Empty) then
      begin
        if (not FManager.Skin.ProgressBarSkin.SmallBackground.Empty) and
           (Bmp.Height <= FManager.Skin.ProgressBarSkin.SmallModeOffset.YAsInt) then
           FManager.Skin.ProgressBarSkin.SmallBackground.draw(bmp, Scheme)
        else
          FManager.Skin.ProgressBarSkin.BackGround.Draw(bmp, Scheme);
      end;
      if not (FManager.Skin.ProgressBarSkin.Progress.Empty) then
      begin
        if (not FManager.Skin.ProgressBarSkin.SmallProgress.Empty) and
           (Bmp.Height <= FManager.Skin.ProgressBarSkin.SmallModeOffset.YAsInt) then
           r := FManager.Skin.ProgressBarskin.SmallProgress.SkinDim.GetRect(rect(0, 0, bmp.Width, bmp.Height))
        else r := FManager.Skin.ProgressBarSkin.Progress.SkinDim.GetRect(rect(0, 0, bmp.width, bmp.height));
        if r.Right = 0 then
           r.right := bmp.Width - r.Left;
        if r.Bottom = 0 then
           r.Bottom := bmp.Height - r.Top;
        temp.Height := bmp.Height - r.Top;
        temp.Width := round((r.Right - r.Left) * FValue / (FMax - FMin));
        temp.Clear(Color32(0, 0, 0, 0));
        temp.DrawMode := dmBlend;
        temp.CombineMode := cmMerge;
        if (not FManager.Skin.ProgressBarSkin.SmallProgress.Empty) and
           (Bmp.Height <= FManager.Skin.ProgressBarSkin.SmallModeOffset.YAsInt) then
           FManager.Skin.ProgressBarSkin.SmallProgress.Draw(temp, Scheme)
        else FManager.Skin.ProgressBarSkin.Progress.Draw(temp, Scheme);
        bmp.Draw(r.Left, r.Top, rect(0, 0, temp.Width, temp.Height), temp);
      end;
    end
    else
      DrawDefaultSkin(bmp, DefaultSharpEScheme);
  finally
    skindim.free;
    temp.free;
  end;
end;

end.
