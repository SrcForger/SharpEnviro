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

uses Classes,Controls,SysUtils,GR32,GR32_Image,GR32_Layers,
     uSharpEDesktopManager,
     uSharpEDesktopLinkRenderer;

type
  TSelectionLayer = class(TPositionedlayer)
                    private
                    public
                    protected
                      procedure Paint(Buffer: TBitmap32); override;
                    end;

  TSharpEDesktopRenderer =  class
  private
    FImage : TImage32;
    FSelectLayer : TBitmapLayer;
    FSelectionLayer : TSelectionLayer;
    FLinkRenderer : TSharpEDesktopLinkRenderer;
    FManager : TSharpEDesktopManager;
    FMouseDownPos : TPoint;
    FMouseDown : boolean;
  public
    procedure RenderBackground;
    procedure RefreshLayers;
    procedure PerformMouseMove(pX,pY : integer);
    procedure PerformMouseDown(pX,pY : integer; Button : TMouseButton);
    procedure PerformMouseUp(pX,pY : integer; Button : TMouseButton);

    constructor Create(pImage : TImage32; pManager : TSharpEDesktopManager); reintroduce;
    destructor Destroy; override;
  published
  end;

implementation

uses uSharpEDesktopItem,
     uSharpEDesktop;


     
procedure TSelectionLayer.Paint(Buffer: TBitmap32);
var
  L : TFloatRect;
begin
  L := GetAdjustedLocation;
  Buffer.SetStipple([clwhite32,clwhite32,clwhite32,clblack32,clblack32,clblack32]);
  Buffer.StippleStep := 1;
  Buffer.LineFSP(Round(L.Left),Round(L.Top),Round(L.Right),Round(L.Top));
  Buffer.LineFSP(Round(L.Right),Round(L.Top),Round(L.Right),Round(L.Bottom));
  Buffer.LineFSP(Round(L.Left),Round(L.Top),Round(L.Left),Round(L.Bottom));
  Buffer.LineFSP(Round(L.Left),Round(L.Bottom),Round(L.Right),Round(L.Bottom));
end;

// ####################

constructor TSharpEDesktopRenderer.Create(pImage : TImage32; pManager : TSharpEDesktopManager);
begin
  inherited Create;

  FLinkRenderer := TSharpEDesktopLinkRenderer.Create;

  FImage := pImage;
  FManager := pManager;

  FMouseDown := False;

  FSelectLayer := TBitmapLayer.Create(FImage.Layers);
  FSelectLayer.Visible := False;
  FSelectLayer.Bitmap.DrawMode := dmBlend;
  FSelectLayer.Bitmap.CombineMode := cmMerge;

  FSelectionLayer := TSelectionLayer.Create(FImage.Layers);
  FSelectionLayer.Visible := False;
  FSelectionLayer.Location := FloatRect(0,0,1,1);
end;

destructor TSharpEDesktopRenderer.Destroy;
begin
  FreeAndNil(FSelectLayer);
  FreeAndNil(FLinkRenderer);

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
                pLayer.Bitmap.DrawMode := dmBlend;
                pLayer.Bitmap.CombineMode := cmMerge;
                pLayer.Bitmap.SetSize(GridSize,GridSize);
                pLayer.Bitmap.Clear(color32(128,128,128,128));
                pLayer.AlphaHit := False;
                pLayer.Location := FloatRect(x*GridSize,
                                             y*GridSize,
                                             x*GridSize+pLayer.Bitmap.Width,
                                             y*GridSize+pLayer.Bitmap.Height);
                pLayer.BringToFront;
                item.Layer := pLayer;
                item.HasChanged := True;
              end;
              if item.HasChanged then
              begin
                // Update the layer
                FLinkRenderer.RenderTo(TBitmapLayer(item.Layer).Bitmap,item);
              end;
            end;
  end;
end;

procedure TSharpEDesktopRenderer.PerformMouseMove(pX,pY : integer);
var
  item : TSharpEDesktopItem;
  ditem : TSharpEDesktop;
  x,y : integer;
  R : TFloatRect;
  X1,X2,Y1,Y2 : integer;
begin
  if (FManager = nil) or (FImage = nil) then exit;
  if (FManager.CurrentDesktop = nil) then exit;

  ditem := FManager.CurrentDesktop;

  x := pX div ditem.GridSize;
  y := pY div ditem.GridSize;

  item := ditem.GetGridItem(x,y);

  if (item <> nil) and (not FMouseDown) then
  begin
    // view the selection Layer
    R := FSelectLayer.Location;
    if (x*ditem.GridSize <> round(R.Left)) or (y*ditem.GridSize <> round(R.Top))
       or (not FSelectLayer.Visible) then
    begin
      if (FSelectLayer.Bitmap.Width <> ditem.GridSize)
          or (FSelectLAyer.Bitmap.Height <> ditem.GridSize) then
      begin
        FSelectLayer.Bitmap.SetSize(ditem.GridSize,ditem.GridSize);
        FSelectLayer.Bitmap.Clear(color32(128,128,128,128));
      end;
      FSelectLayer.Location := FloatRect(x*ditem.GridSize,
                                         y*ditem.GridSize,
                                         x*ditem.GridSize+FSelectLayer.Bitmap.Width,
                                         y*ditem.GridSize+FSelectLayer.Bitmap.Height);
      FSelectLayer.SendToBack;
      if not FSelectLayer.Visible then FSelectLayer.Visible := True;
    end;
  end else
  begin
    // hide the selection Layer;
    if FSelectLayer.Visible then FSelectLayer.Visible := False;
  end;

  // Move and Size the selection Rect
  if (FMouseDown) and (FSelectionLayer.Visible) then
  begin
    if pX>FMouseDownPos.X then
    begin
      X1 := FMouseDownPos.X;
      X2 := pX;
    end else
    begin
      X1 := pX;
      X2 := FMouseDownPos.X;
    end;
    if pY>FMouseDownPos.Y then
    begin
      Y1 := FMouseDownPos.Y;
      Y2 := pY;
    end else
    begin
      Y1 := pY;
      Y2 := FMouseDownPos.Y
    end;
    FSelectionLayer.Location := FloatRect(X1,Y1,X2,Y2);
  end;
end;

procedure TSharpEDesktopRenderer.PerformMouseDown(pX,pY : integer; Button : TMouseButton);
var
  item : TSharpEDesktopItem;
  ditem : TSharpEDesktop;
  x,y : integer;
begin
  if (FManager = nil) or (FImage = nil) then exit;
  if (FManager.CurrentDesktop = nil) then exit;

  ditem := FManager.CurrentDesktop;

  x := pX div ditem.GridSize;
  y := pY div ditem.GridSize;

  item := ditem.GetGridItem(x,y);
  FMouseDown := True;
  FMouseDownPos := Point(pX,pY);

  // Selection Rect?
  if (item = nil) and (Button = mbLeft) then
  begin
    FSelectionLayer.Location := FloatRect(pX,pY,pX+1,pY+1);
    FSelectionLayer.BringToFront;
    FSelectionLayer.Visible := True;
  end;
end;

procedure TSharpEDesktopRenderer.PerformMouseUp(pX,pY : integer; Button : TMouseButton);
begin
  FMouseDown := False;

  if FSelectionLayer.Visible then
  begin
    FSelectionLayer.Visible := False;
  end;
end;

end.
