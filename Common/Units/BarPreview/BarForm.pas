{
Source Name: BarForm.pas
Description: SharpSkin Bar Form
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

unit BarForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEBaseControls, SharpEBar, SharpESkinManager, SharpEScheme, SharpESkin,
  SharpEButton, GR32, SharpGraphicsUtils;

type
  TBarWnd = class(TForm)
    SharpEScheme1: TSharpEScheme;
    Button: TSharpEButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
    procedure OnBackgroundPaint(Sender : TObject; Target : TBitmap32; x : integer);
  public
    SharpEBar1: TSharpEBar;
    SkinManager : TSharpESkinManager;
    SkinComp : TSharpESkin;
    Background : TBitmap32;
    procedure ApplyGlassEffect(GEBlurRadius,GEBlurIterations : integer; GEBlend : boolean;
                               GEBlendColor,GEBlendAlpha : integer; GELighten : boolean;
                               GELightenAmount : integer);
  end;

var
  BarWndUseMenu : boolean;

implementation

{$R *.dfm}

procedure TBarWnd.FormCreate(Sender: TObject);
begin
  Background := TBitmap32.Create;
  Background.SetSize(1,1);
  Background.Clear(color32(0,0,0,0));

  if BarWndUseMenu then
     SkinComp := TSharpESkin.Create(self,[scBar,scButton,scMenu,scMenuItem])
     else SkinComp := TSharpESkin.Create(self,[scBar,scButton]);

  SkinManager := TSharpESkinManager.CreateRuntime(self,SkinComp,SharpEScheme1,True,[scBar,scButton]);
  SkinManager.SkinSource := ssComponent;
  SkinManager.SchemeSource := ssComponent;

  SharpEBar1 := TSharpEBar.CreateRuntime(self,SkinManager);
  Button.SkinManager := SkinManager;
  SharpEBar1.OnBackgroundPaint := OnBackgroundPaint;
end;

procedure TBarWnd.FormDestroy(Sender: TObject);
begin
  FreeAndNil(SharpEbar1);
  FreeAndNil(SkinManager);
  FreeAndNil(SkinComp);
  FreeAndNil(Background);
end;

procedure TBarWnd.OnBackgroundPaint(Sender : TObject; Target : TBitmap32; x : integer);
begin
  if Background <> nil then
     Background.DrawTo(Target);
end;

procedure TBarWnd.ApplyGlassEffect(GEBlurRadius,GEBlurIterations : integer; GEBlend : boolean;
                                   GEBlendColor,GEBlendAlpha : integer; GELighten : boolean;
                                   GELightenAmount : integer);
begin
  if SkinManager.Skin.BarSkin.GlassEffect then
  begin
    if GEBlend then
       BlendImageC(Background,GEBlendColor,GEBlendAlpha);
    boxblur(Background,GEBlurRadius,GEBlurIterations);
    if GELighten then
       lightenBitmap(Background,GELightenAmount);
  end;
end;

end.
