{
Source Name: SharpESkinLabel
Description: Label component for SharpE
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
unit SharpESkinLabel;
                                                                                           
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
  gr32_resamplers,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
  SharpEScheme,
  SharpESkinManager,
  SharpESkin,
  SharpEAnimationTimers,
  SharpESkinPart,
  math,
  Types,
  Buttons;

type
  TSharpELabelStyle = (lsSmall,lsMedium,lsBig);
  TSharpESkinLabel = class(TCustomSharpEGraphicControl)
  private
    FCaption: string;
    FAutoPosition: Boolean;
    FLabelStyle: TSharpELabelStyle;
    FPrecacheText : TSkinText;
    FPrecacheBmp  : TBitmap32;
    FPrecacheCaption : String;
    FTHeight : integer;  // Text Height without shadows!
    FTWidth  : integer;  // Text Width without shadows!
    procedure SetAutoPosition(Value: boolean);
    procedure SetCaption(Value: string);
    procedure SetLabelStyle(const Value : TSharpELabelStyle);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Resize; override;
    destructor Destroy; override;
    procedure UpdateAutoPosition;
  published
    //property Align;
    property Anchors;
    property Constraints;
    property ParentShowHint;
    property ShowHint;
    property SkinManager;
    property AutoSize;
    property Visible;
    property OnClick;
    property OnDblClick;
    property Caption: string read FCaption write SetCaption;
    property AutoPosition: Boolean read FAutoPosition write SetAutoPosition;
    property LabelStyle: TSharpELabelStyle read FLabelStyle write SetLabelStyle;
    property TextHeight : integer read FTHeight;
    property TextWidth : integer read FTWidth;
   { Published declarations }
  end;

implementation

uses
   gr32_png;

constructor TSharpESkinLabel.Create;
begin
  inherited Create(AOwner);
  Width := 75;
  Height := 25;
end;

procedure TSharpESkinLabel.DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  TextSize : TPoint;
  TextPos: TPoint;
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    DefaultSharpESkinText.AssignFontTo(bmp.Font,Scheme);
    DrawMode := dmBlend;
    TextSize.X := bmp.TextWidth(caption);
    TextSize.Y := bmp.TextHeight(caption);
    TextPos.X := Width div 2 - TextSize.X div 2;
    TextPos.Y := Height div  2 - TextSize.Y div 2;
    bmp.RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp.Font.color));
  end;
end;


procedure TSharpESkinLabel.DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme);
var
  TextRect, CompRect: TRect;
  TextPos: TPoint;
  SkinText : TSkinText;
begin
  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
    exit;
  end;

  case FLabelStyle of
    lsSmall: SkinText := FManager.Skin.SmallText;
    lsBig: SkinText := FManager.Skin.BigText;
    else SkinText := FManager.Skin.MediumText;
  end;

  CompRect := Rect(0, 0, width, height);
  SkinText.AssignFontTo(Bmp.Font,Scheme);
  TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
  TextPos := SkinText.GetXY(TextRect, CompRect);

  if (FAutoPosition) then
     Top := TextPos.Y;

  FTWidth := Bmp.TextWidth(Caption);
  FTHeight := Bmp.TextHeight(Caption);

  if (FAutoSize) then
  begin
    Width := FTWidth + 10;
    Height := FTHeight + 10;
  end;

  FSkin.Clear(Color32(0, 0, 0, 0));
  if length(trim(Caption))>0 then
     SkinText.RenderTo(bmp,5,5,Caption,Scheme,
                       FPrecacheText,FPrecacheBmp,FPrecacheCaption);
end;

procedure TSharpESkinLabel.SetCaption(Value: string);
begin
  if CompareText(FCaption,Value) <> 0 then
  begin
    FCaption := Value;
    UpdateSkin;
  end;
end;

procedure TSharpESkinLabel.SetLabelStyle(const Value : TSharpELabelStyle);
begin
  if FLabelStyle <> Value then
  begin
    FLabelStyle := Value;
    UpdateSkin;
    Invalidate;
  end;
end;

procedure TSharpESkinLabel.Resize;
begin
  inherited;
  UpdateSkin;
end;


procedure TSharpESkinLabel.SetAutoPosition(Value: boolean);
begin
  if (Value <> FAutoPosition) then
  begin
    FAutoPosition := Value;
    UpdateAutoPosition;
  end;
end;

procedure TSharpESkinLabel.UpdateAutoPosition;
begin
  if (FAutoPosition) then
  begin
    UpdateSkin;
  end;
end;

destructor TSharpESkinLabel.Destroy;
begin
  if FPrecacheBmp <> nil then FreeAndNil(FPrecacheBmp);
  if FPrecacheText <> nil then FreeAndNil(FPrecacheText);

  inherited;
end;


end.
