{
Source Name: uEditWnd.pas
Description: Options Window
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

unit uEditWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Contnrs,
  Graphics,
  Controls,
  Forms,
  StdCtrls,
  GR32,
  GR32_Resamplers,  
  ImgList,
  PngImage,
  PngImageList,
  SharpTypes,
  SharpEListBoxEx,
  ExtCtrls,
  JvExControls,
  JvXPCore,
  JvXPCheckCtrls,
  JclSimpleXml,
  JclStrings,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  MediaPlayerList,
  SharpECenterHeader;

type
  TfrmEdit = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilSelected: TPngImageList;
    pilUnselected: TPngImageList;
    SharpECenterHeader3: TSharpECenterHeader;
    procedure lbItemsResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbItemsGetCellColor(Sender: TObject; const AItem: TSharpEListItem;
      var AColor: TColor);
    procedure lbItemsClickCheck(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AChecked: Boolean);
    procedure SettingsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FUpdating: boolean;
    FPluginHost: ISharpCenterHost;
    FMediaPlayerList: TMediaPlayerList;
    procedure ResizeImage(Bmp : TBitmap32; size : integer);   
  public
    procedure LoadPlayers;
    procedure UpdateSize;
    procedure UpdateImages;

    property IsUpdating: boolean read FUpdating write FUpdating;
    property MediaPlayerList: TMediaPlayerList read FMediaPlayerList;
    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

  TARGB = record
    b: Byte;
    g: Byte;
    r: Byte;
    a: Byte;
  end;
  PARGB = ^TARGB;  

var
  frmEdit: TfrmEdit;

const
  colName = 0;

implementation

uses
  SharpThemeApiEx,
  SharpApi;

{$R *.dfm}

procedure TfrmEdit.ResizeImage(Bmp : TBitmap32; size : integer);
var
  BGBmp : TBitmap32;
begin
  BGBmp := TBitmap32.Create;
  BGBmp.Assign(Bmp);

  Bmp.SetSize(size,size);
  TLinearResampler.Create(BGBmp);
  BGBmp.DrawTo(Bmp,Bmp.BoundsRect);

  BGBmp.Free;
end;

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.SetSettingsChanged;
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  FMediaPlayerList := TMediaPlayerList.Create;
end;

procedure TfrmEdit.FormDestroy(Sender: TObject);
begin
  FMediaPlayerList.Free;
  pilSelected.Clear;
  pilUnselected.Clear;
end;

procedure TfrmEdit.FormResize(Sender: TObject);
begin
  UpdateSize;
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;
end;

procedure TfrmEdit.lbItemsClickCheck(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AChecked: Boolean);
begin
  if AItem.SubItemChecked[1] then
    AItem.SubItemChecked[1] := False;

  SettingsChange(nil);
end;

procedure TfrmEdit.lbItemsGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.SubItemChecked[1] then AColor := $00E6FBE9;
  if AItem.SubItemChecked[2] then AColor := $00E8E1FF;
end;

procedure TfrmEdit.lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > 0 then
    ACursor := crHandPoint;
end;

procedure TfrmEdit.lbItemsResize(Sender: TObject);
begin
  UpdateSize;
end;

procedure TfrmEdit.LoadPlayers;
var
  newItem: TSharpEListItem;
  n: Integer;
  item: TMediaPlayerItem;
begin
  LockWindowUpdate(Self.Handle);
  try
    lbItems.Clear;
    for n := 0 to FMediaPlayerList.Items.Count - 1 do
    begin
      item := TMediaPlayerItem(FMediaPlayerList.Items.Items[n]);

      newItem := lbItems.AddItem(item.Name);
      newItem.Data := item;
      newItem.AddSubItem('Show', True);
    end;
  finally
    LockWindowUpdate(0);
  end;

  lbItems.ItemIndex := -1;
  FPluginHost.Refresh;
  
  UpdateImages;
end;

function SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
  bgcolor: TColor;
  CompressionLevel: Integer = 9;
  InterlaceMethod: TInterlaceMethod = imNone): tPNGObject;
var
  bm: TBitmap;
  png: TPngObject;
  TRNS: TCHUNKtRNS;
  p: PByteArray;
  x, y: Integer;
begin
  png := TPngObject.Create;
  bm := TBitmap.Create;
  try
    try
      bm.Assign(bm32);
      if paletted then
        bm.PixelFormat := pf8bit; // force paletted on TBitmap, transparent for the web must be 8 bit
      png.InterlaceMethod := InterlaceMethod;
      png.CompressionLevel := CompressionLevel;
      png.Assign(bm); //Convert data into png
    finally
      FreeAndNil(bm);
    end;
    if transparent then begin
      if png.Header.ColorType in [COLOR_PALETTE] then begin
        if (png.Chunks.ItemFromClass(TChunktRNS) = nil) then
          png.CreateAlpha;
        TRNS := png.Chunks.ItemFromClass(TChunktRNS) as TChunktRNS;
        if Assigned(TRNS) then
          TRNS.TransparentColor := bgcolor;
      end;
      if png.Header.ColorType in [COLOR_RGB, COLOR_GRAYSCALE] then
        png.CreateAlpha;
      if png.Header.ColorType in [COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA] then begin
        for y := 0 to png.Header.Height - 1 do begin
          p := png.AlphaScanline[y];
          for x := 0 to png.Header.Width - 1 do
            p[x] := TARGB(bm32.Pixel[x, y]).a;
        end;
      end;
    end;

  finally
    Result := png;
  end;
end;


procedure TfrmEdit.UpdateImages;
var
  i: Integer;
  item : TMediaPlayerItem;
  png,png2 : TPngImageCollectionItem;
  tmp : TPngObject;
  Bmp : TBitmap32;
begin
  pilSelected.Clear;
  pilUnselected.Clear;

  Bmp := TBitmap32.Create;
  for i := 0 to lbItems.Count - 1 do
  begin
    item := TMediaPlayerItem(lbItems[i].Data);
    if item <> nil then
    begin
      pilUnselected.BkColor := FPluginHost.Theme.PluginItem;
      pilSelected.BkColor := FPluginHost.Theme.PluginSelectedItem;

      Bmp.Assign(item.Icon);
      ResizeImage(Bmp,pilUnselected.Width);

      png := pilUnselected.PngImages.Add(false);
      tmp := SaveBitmap32ToPNG(Bmp, False, true, FPluginHost.Theme.PluginItem);
      png.PngImage.Assign(tmp);
      tmp.Free;

      png2 := pilSelected.PngImages.Add(false);
      tmp := SaveBitmap32ToPNG(Bmp, False, true, FPluginHost.Theme.PluginSelectedItem);
      png2.PngImage.Assign(tmp);
      tmp.Free;

      lbItems[i].ImageIndex := i;      
    end;
  end;
  Bmp.Free;
end;

procedure TfrmEdit.UpdateSize;
begin
  Self.Height := lbItems.Height + lbItems.Top;
end;

end.

