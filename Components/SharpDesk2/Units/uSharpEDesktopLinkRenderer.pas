{
Source Name: uSharpEDesktopLinkRenderer.pas
Description: TSharpDeskLinkRenderer class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows 2000 or higher

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

unit uSharpEDesktopLinkRenderer;

interface

uses
  Classes,SysUtils,Graphics,GR32,GR32_Resamplers,uSharpEDesktopItem;

type
  TSharpEDesktopLinkRenderer = class
  private
    FIconSize        : integer;
    FIconAlpha       : integer;
    FIconBlending    : boolean;
    FIconBlendColor  : integer;
    FIconBlendAlpha  : integer;
    FFontName        : String;
    FTextSize        : integer;
    FTextBold        : boolean;
    FTextItalic      : boolean;
    FTextUnderline   : boolean;
    FTextColor       : integer;
    FTextAlpha       : integer;
    FTextShadow      : boolean;
    FTextShadowAlpha : integer;
    FTextShadowColor : integer;
    FTextShadowType  : integer;
    FTextShadowSize  : integer;
  public
    procedure LoadSettings;
    procedure RenderTo(Dst : TBitmap32; ditem : TSharpEDesktopItem); overload;
    procedure RenderTo(Dst : TBitmap32; ditem : TSharpEDesktopItem; pSelected : boolean); overload;
    
    constructor Create; reintroduce;
    destructor Destroy; override;
  published
  end;

implementation

uses
  JvSimpleXML, SharpThemeApi;

constructor TSharpEDesktopLinkRenderer.Create;
begin
  inherited Create;

  LoadSettings;
end;

destructor TSharpEDesktopLinkRenderer.Destroy;
begin
  inherited Destroy;
end;

procedure TSharpEDesktopLinkRenderer.LoadSettings;
begin
  if not SharpThemeApi.Initialized then
  begin
    SharpThemeApi.InitializeTheme;
    SharpThemeApi.LoadTheme(False,[tpDesktopIcon])
  end;

  FIconSize        := GetDesktopIconSize;
  FIconAlpha       := GetDesktopIconAlpha;
  FIconBlending    := GetDesktopIconBlending;
  FIconBlendColor  := GetDesktopIconBlendColor;
  FIconBlendAlpha  := GetDesktopIconBlendAlpha;
  FFontName        := GetDesktopFontName;
  FTextSize        := GetDesktopTextSize;
  FTextBold        := GetDesktopTextBold;
  FTextItalic      := GetDesktopTextItalic;
  FTextUnderline   := GetDesktopTextUnderline;
  FTextColor       := GetDesktopTextColor;
  FTextAlpha       := GetDesktopTextAlpha;
  FTextShadow      := GetDesktopTextShadow;
  FTextShadowAlpha := GetDesktopTextShadowAlpha;
  FTextShadowColor := GetDesktopTextShadowColor;
  FTextShadowType  := GetDesktopTextShadowType;
  FTextShadowSize  := GetDesktopTextShadowSize;
end;

procedure TSharpEDesktopLinkRenderer.RenderTo(Dst : TBitmap32; ditem : TSharpEDesktopItem);
begin
  RenderTo(Dst,ditem,False);
end;

procedure TSharpEDesktopLinkRenderer.RenderTo(Dst : TBitmap32; ditem : TSharpEDesktopItem; pSelected : boolean);
var
  Icon,Caption : TBitmap32;
begin
  if (Dst = nil) or (ditem = nil) then exit;

  if pSelected then Dst.Clear(color32(128,128,128,128))
     else Dst.Clear(color32(0,0,0,0));

  Icon := TBitmap32.Create;
  Caption := TBitmap32.Create;
  try
    // Intialize tempory drawing bitmaps
    Icon.DrawMode := dmBlend;
    Icon.CombineMode := cmMerge;
    Icon.SetSize(FIconSize,FIconSize);
    Caption.DrawMode := dmBlend;
    Caption.CombineMode := cmMerge;
    Caption.Font.Name := FFontName;
    Caption.Font.Style := [];
    Caption.Font.Color := FTextColor;
    Caption.Font.Size := FTextSize;
    if FTextBold then Caption.Font.Style := Caption.Font.Style + [fsBold];
    if FTextItalic then Caption.Font.Style := Caption.Font.Style + [fsItalic];
    if FTextUnderline then Caption.Font.Style := Caption.Font.Style + [fsUnderline];

    ditem.Icon.DrawMode := dmBlend;
    ditem.Icon.CombineMode := cmMerge;
    TLinearResampler.Create(ditem.Icon);
    ditem.Icon.DrawTo(Icon,Rect(0,0,FIconSize,FIconSize));

    // Final Drawing
    Icon.DrawTo(Dst,
                Dst.Width div 2 - Icon.Width div 2,
                Dst.Height div 2 - Icon.Height div 2);
  finally
    FreeAndNil(Icon);
    FreeAndNil(Caption);
  end;
end;



end.
