{
Source Name: uSharpEDesktopRenderer.pas
Description: TSharpEDesktopRenderer class
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

unit uSharpEDesktopRenderer;

interface

uses Classes,Controls,Contnrs,SysUtils,GR32,GR32_Image,GR32_Layers,Math,
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
    FSelectionLayer : TSelectionLayer;
    FMovingLayer : TBitmapLayer;
    FLinkRenderer : TSharpEDesktopLinkRenderer;
    FManager : TSharpEDesktopManager;
    FMouseDownPos : TPoint;
    FMouseDown : boolean;
    FIconsMoving : boolean;

    FOldItem : TObject; // Just a temp pointer
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
  FIconsMoving := False;

  FMovingLayer := TBitmapLayer.Create(FImage.Layers);
  FMovingLayer.Visible := False;
  FMovingLayer.Bitmap.MasterAlpha := 128;
  FMovingLayer.Bitmap.DrawMode := dmBLend;
  FMovingLAyer.Bitmap.CombineMode := cmMerge;

  FSelectionLayer := TSelectionLayer.Create(FImage.Layers);
  FSelectionLayer.Visible := False;
  FSelectionLayer.Location := FloatRect(0,0,1,1);
end;

destructor TSharpEDesktopRenderer.Destroy;
begin
  FreeAndNil(FSelectionLayer);
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
                pLayer := TBitmapLayer(item.Layer);
                if FManager.SelectionList.IndexOf(item) >= 0 then FLinkRenderer.RenderTo(pLayer.Bitmap,item,True)
                   else FLinkRenderer.RenderTo(pLayer.Bitmap,item,False);
                pLayer.Location := FloatRect(x*GridSize,
                                             y*GridSize,
                                             x*GridSize+pLayer.Bitmap.Width,
                                             y*GridSize+pLayer.Bitmap.Height);
              end;
            end;
  end;
end;

procedure TSharpEDesktopRenderer.PerformMouseMove(pX,pY : integer);
var
  item : TSharpEDesktopItem;
  ditem : TSharpEDesktop;
  x,y : integer;
  n : integer;
  R : TFloatRect;
  X1,X2,Y1,Y2 : integer;
  alist,dlist : TObjectList;
begin
  if (FManager = nil) or (FImage = nil) then exit;
  if (FManager.CurrentDesktop = nil) then exit;

  ditem := FManager.CurrentDesktop;

  x := pX div ditem.GridSize;
  y := pY div ditem.GridSize;

  item := ditem.GetGridItem(x,y);

  alist := TObjectList.Create(False);
  alist.Clear;
  dlist := TObjectList.Create(False);
  dlist.Clear;

  // Move and Size the selection Rect
  if (not FIconsMoving) and (FMouseDown) and (FSelectionLayer.Visible) then
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
    FManager.UpdateSelection(alist,dlist,X1,Y1,X2,Y2);
  end
  else if (not FMouseDown) and (not FIconsMoving) and (FManager.SelectionList.Count <= 1) then
  begin
    FManager.UpdateSelection(alist,dlist,
                             x * ditem.GridSize,
                             y * ditem.GridSize,
                             x * ditem.GridSize + ditem.GridSize,
                             y * ditem.GridSize + ditem.GridSize);
  end
  else if FIconsMoving then
  begin
    FMovingLayer.Location := FloatRect(pX - FMouseDownPos.X,
                                       pY - FMouseDownPos.Y,
                                       pX - FMouseDownPos.X + FMovingLayer.Bitmap.Width,
                                       pY - FMouseDownPos.Y + FMovingLayer.Bitmap.Height);

    // icons are moving over another icon, what which isn't moved - what to do?
    if (item <> FOldItem) and (item <> nil) and (FManager.SelectionList.IndexOf(item) <0) then
    begin
      if (item.itemType = dtDirectory) then
      begin
        FImage.Cursor := crDrag;
        FLinkRenderer.RenderTo(TBitmapLayer(item.Layer).Bitmap,item,True);
        if FOldItem <> nil then
           FLinkRenderer.RenderTo(TBitmapLayer(TSharpEDesktopItem(FOldItem).Layer).Bitmap,TSharpEDesktopItem(FOldItem),True);
        FOldItem := item;
      end else FImage.Cursor := crDefault;
    end else FImage.Cursor := crDefault;

    if (item <> FOldItem) and (FOldItem <> nil) then
    begin
      item := TSharpEDesktopItem(FOldItem);
      FLinkRenderer.RenderTo(TBitmapLayer(item.Layer).Bitmap,item,False);
    end;
  end;


  for n := 0 to alist.Count -1 do
  begin
    item := TSharpEDesktopItem(alist[n]);
    FLinkRenderer.RenderTo(TBitmapLayer(item.Layer).Bitmap,item,True);
  end;

  for n := 0 to dlist.Count -1 do
  begin
    item := TSharpEDesktopItem(dlist[n]);
    FLinkRenderer.RenderTo(TBitmapLayer(item.Layer).Bitmap,item,False);
  end;

  alist.Free;
  dlist.Free;
end;

procedure TSharpEDesktopRenderer.PerformMouseDown(pX,pY : integer; Button : TMouseButton);
var
  item : TSharpEDesktopItem;
  ditem : TSharpEDesktop;
  x,y : integer;
  xmin,xmax,ymin,ymax : integer;
  w,h : integer;
  p : TPoint;
  n : integer;
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

  if FManager.SelectionList.IndexOf(item) < 0 then
  begin
    for n := 0 to FManager.SelectionList.Count - 1 do
    begin
      item := TSharpEDesktopItem(FManager.SelectionList.Items[n]);
      FLinkRenderer.RenderTo(TBitmapLayer(item.Layer).Bitmap,item,False);
    end;
    FManager.SelectionList.Clear;
  end else
  begin
    FIconsMoving := True;
    // render moving layer
    with FManager.SelectionList do
    begin
      xmin := 0;
      xmax := 0;
      ymin := 0;
      ymax := 0;
      for n := 0 to FManager.SelectionList.Count - 1 do
      begin
        item := TSharpEDesktopItem(FManager.SelectionList.Items[n]);
        p := ditem.GetGridPoint(item);
        xmin := min(xmin,p.X);
        xmax := max(xmax,p.X);
        ymin := min(ymin,p.Y);
        ymax := max(ymax,p.Y);
      end;
      w := (xmax - xmin + 1)*ditem.GridSize;
      h := (ymax - ymin + 1)*ditem.GridSize;
      FMovingLayer.Bitmap.SetSize(w,h);
      FMovingLayer.Bitmap.Clear(color32(0,0,0,0));
      for n := 0 to FManager.SelectionList.Count - 1 do
      begin
        item := TSharpEDesktopItem(FManager.SelectionList.Items[n]);
        p := ditem.GetGridPoint(item);
        FMovingLayer.Bitmap.Draw((p.X - xmin) * ditem.GridSize,
                                 (p.Y - ymin) * ditem.GridSize,
                                 TBitmapLayer(item.Layer).Bitmap);
      end;
      FMovingLayer.Location := FloatRect(pX - FMouseDownPos.X,
                                         pY - FMouseDownPos.Y,
                                         pX - FMouseDownPos.X + FMovingLayer.Bitmap.Width,
                                         pY - FMouseDownPos.Y + FMovingLayer.Bitmap.Height);
      FMovingLayer.Visible := True;
    end;
  end;
end;

procedure TSharpEDesktopRenderer.PerformMouseUp(pX,pY : integer; Button : TMouseButton);
type
  TTempItem = record
                item : TSharpEDesktopItem;
                p    : TPoint;
              end;  
var
  n : integer;
  item : TSharpEDesktopItem;
  ditem : TSharpEDesktop;
  sx,sy,mx,my,nx,ny,x,y : integer;
  p : TPoint;
  olist : array of TTempItem;
begin
  if (FManager = nil) or (FImage = nil) then exit;
  if (FManager.CurrentDesktop = nil) then exit;

  ditem := FManager.CurrentDesktop;

  x := pX div ditem.GridSize;
  y := pY div ditem.GridSize;

  FMouseDown := False;

  if FSelectionLayer.Visible then
  begin
    FSelectionLayer.Visible := False;
  end;

  if FIconsMoving then
  begin
    FIconsMoving := False;
    FMovingLayer.Visible := False;


    sx := High(ditem.Grid);
    sy := High(ditem.Grid);
    mx := FMouseDownPos.X div ditem.GridSize;
    my := FMouseDownPos.Y div ditem.GridSize;

    setlength(olist,0);

    for n := 0 to FManager.SelectionList.Count - 1 do
    begin
      setlength(olist,length(olist)+1);
      item := TSharpEDesktopItem(FManager.SelectionList.Items[n]);
      p := ditem.GetGridPoint(item);
      olist[High(olist)].item := item;
      olist[High(olist)].p := p;
      ditem.RemoveFromGrid(item);
      sx := min(sx,p.X);
      sy := min(sy,p.Y);
    end;

    for n := 0 to High(olist) do
    begin
      item := olist[n].item;
      p := olist[n].p;
      nx := x + sx - p.X - sx + mx;
      ny := y + sy - p.Y - sy + my;
      nx := p.X + x - mx;
      ny := p.Y + y - my;
      ditem.RemoveFromGrid(item);
      ditem.InserToNearestGrid(item,nx,ny);
    end;

    setlength(olist,0);
    
    RefreshLayers;
  end;
end;

end.
