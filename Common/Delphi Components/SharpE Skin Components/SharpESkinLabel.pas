{
Source Name: SharpESkinLabel
Description: Label component for SharpE
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
unit SharpESkinLabel;
                                                                                           
interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  StdCtrls,
  gr32,
  gr32_resamplers,
  ISharpESkinComponents,
  SharpEBase,
  SharpEBaseControls,
  SharpEDefault,
  SharpTypes,
  math,
  Types,
  Buttons;

type
  TSharpELabelStyle = (lsSmall,lsMedium,lsBig);
  TSharpESkinLabel = class(TCustomSharpEGraphicControl)
  private
    FCaption: string;
    FAutoPos: TSharpEBarAutoPos;
    FLabelStyle: TSharpELabelStyle;
    FPrecacheText : ISharpESkinText;
    FPrecacheBmp  : TBitmap32;
    FPrecacheCaption : String;
    FTHeight : integer;  // Text Height without shadows!
    FTWidth  : integer;  // Text Width without shadows!
    procedure SetAutoPos(Value: TSharpEBarAutoPos);
    procedure SetCaption(Value: string);
    procedure SetLabelStyle(const Value : TSharpELabelStyle);
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
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
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseEnter;
    property OnMouseLeave;    
    property Caption: string read FCaption write SetCaption;
    property AutoPos: TSharpEBarAutoPos read FAutoPos write SetAutoPos;
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

procedure TSharpESkinLabel.DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  TextSize : TPoint;
  TextPos: TPoint;
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    AssignDefaultFontTo(bmp.Font);
    DrawMode := dmBlend;
    TextSize.X := bmp.TextWidth(caption);
    TextSize.Y := bmp.TextHeight(caption);
    TextPos.X := Width div 2 - TextSize.X div 2;
    TextPos.Y := Height div  2 - TextSize.Y div 2;
    bmp.RenderText(TextPos.X,TextPos.Y,Caption,0, Color32(bmp.Font.color));
  end;
end;


procedure TSharpESkinLabel.DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  TextRect, CompRect: TRect;
  TextPos: TPoint;
  SkinText : ISharpESkinText;
begin
  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
    exit;
  end;

  case FLabelStyle of
    lsSmall: SkinText := FManager.Skin.SmallText.CreateThemedSkinText;
    lsBig: SkinText := FManager.Skin.LargeText.CreateThemedSkinText;
    else SkinText := FManager.Skin.MediumText.CreateThemedSkinText;
  end;

  CompRect := Rect(0, 0, width, height);
  SkinText.AssignFontTo(Bmp.Font,Scheme);
  TextRect := Rect(0, 0, bmp.TextWidth(Caption), bmp.TextHeight(Caption));
  TextPos := SkinText.GetXY(TextRect, CompRect, Rect(0,0,0,0));

  FTWidth := Bmp.TextWidth(Caption);
  FTHeight := Bmp.TextHeight(Caption);

  case FAutoPos of
    apTop: if Top <> FManager.Skin.TextPosTL.Y then
             Top := FManager.Skin.TextPosTL.Y;
    apCenter: if Top <> parent.Height div 2 - (FTHeight + 10) div 2 + TextPos.Y div 2 then
                Top := parent.Height div 2 - (FTHeight + 10) div 2 + TextPos.Y div 2;
    apBottom: if Top <> FManager.Skin.TextPosBL.Y then
             Top := FManager.Skin.TextPosBL.Y;
  end;

  if (FAutoSize) then
  begin
    Width := FTWidth + 10;
    Height := FTHeight + 10;
  end;

  FSkin.Clear(Color32(0, 0, 0, 0));
  bmp.Clear(Color32(0, 0, 0, 0));
  if length(trim(Caption))>0 then
     SkinText.RenderTo(bmp,5,5,Caption,Scheme,
                       FPrecacheText,FPrecacheBmp,FPrecacheCaption);
  SkinText := nil;                       
end;

procedure TSharpESkinLabel.SetCaption(Value: string);
begin
  if CompareStr(FCaption,Value) <> 0 then
  begin
    FCaption := Value;
    UpdateSkin;
    Invalidate;
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


procedure TSharpESkinLabel.SetAutoPos(Value: TSharpEBarAutoPos);
begin
  if (Value <> FAutoPos) then
  begin
    FAutoPos := Value;
    UpdateAutoPosition;
  end;
end;

procedure TSharpESkinLabel.UpdateAutoPosition;
begin
  if (FAutoPos <> apNone) then
  begin
    UpdateSkin;
  end;
end;

destructor TSharpESkinLabel.Destroy;
begin
  if FPrecacheBmp <> nil then FreeAndNil(FPrecacheBmp);
  if FPrecacheText <> nil then
    FPrecacheText := nil;

  inherited;
end;


end.
