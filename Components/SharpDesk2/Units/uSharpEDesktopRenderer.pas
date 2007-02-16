{
Source Name: uSharpEDesktopRenderer.pas
Description: TSharpEDesktopRenderer class
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

unit uSharpEDesktopRenderer;

interface

uses classes,GR32,GR32_Image,GR32_Layers,uSharpEDesktopManager;

type
  TSharpEDesktopRenderer =  class
  private
    FImage : TImage32;
    FManager : TSharpEDesktopManager;
  public
    procedure RenderBackground;
    procedure RefreshLayers;

    constructor Create(pImage : TImage32; pManager : TSharpEDesktopManager); reintroduce;
    destructor Destroy; override;
  published
  end;

implementation

uses uSharpEDesktopItem;

constructor TSharpEDesktopRenderer.Create(pImage : TImage32; pManager : TSharpEDesktopManager);
begin
  inherited Create;
  
  FImage := pImage;
  FManager := pManager;
end;

destructor TSharpEDesktopRenderer.Destroy;
begin

  inherited Destroy;
end;

procedure TSharpEDesktopRenderer.RenderBackground;
begin
  if FImage = nil then exit;

  with FImage do
  begin
    Bitmap.SetSize(Width,Height);
    Bitmap.Clear(clBlack32);
  end;
end;

procedure TSharpEDesktopRenderer.RefreshLayers;
var
  n : integer;
  y,x : integer;
  pLayer : TBitmapLayer;
  item : TSharpEDesktopItem;
begin
  if (FManager = nil) or (FImage = nil) then exit;
  if (FManager.CurrentDesktop = nil) then exit;

  with FManager.CurrentDesktop do
  begin
    for y := 0 to High(Grid) do
        for x := 0 to High(Grid[y]) do
            if Grid[y][x] <> nil then
            begin
              item := TSharpEDesktopItem(Grid[y][x]);
              if not item.HasLayer then
              begin
                // Create a new layer
	          	  pLayer := TBitmapLayer.Create(FImage.Layers);
                pLayer.Bitmap.Width := 32;
                pLayer.Bitmap.Height := 32;
                pLayer.Bitmap.Clear(color32(128,128,128,128));
                pLayer.AlphaHit := False;
                pLayer.Location := FloatRect(x*GridSize,
                                             y*GridSize,
                                             x*GridSize+pLayer.Bitmap.Width,
                                             y*GridSize+pLayer.Bitmap.Height);
                pLayer.BringToFront;
              end;
              if item.HasChanged then
              begin
                // Update the layer
              end;
            end;
  end;
end;

end.
