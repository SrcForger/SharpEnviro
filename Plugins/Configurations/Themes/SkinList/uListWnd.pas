{
Source Name: ThemeList
Description: Theme List Config Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JclSimpleXml, SharpApi, JclFileUtils,
  ImgList, PngImageList, uISharpETheme, uThemeConsts,
  graphicsfx, SharpThemeApiEx, SharpEListBoxEx, BarPreview, GR32, GR32_PNG, pngimage,
  ExtCtrls, SharpCenterApi, JclStrings,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

  TSkinItem = class
  private
    FName: string;
    FAuthor: string;
    FInfo: string;
    FWebsite: string;
    FVersion: string;
  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Website: string read FWebsite write FWebsite;
    property Info: string read FInfo write FInfo;
    property Version: string read FVersion write FVersion;
    
    constructor Create(AName, AAuthor, AWebsite, AInfo, AVersion: string); overload;
    constructor Create(ASkin:String); overload;
  end;

type
  TfrmListWnd = class(TForm)
    lbSkinList: TSharpEListBoxEx;
    PngImageList1: TPngImageList;
    tmrRefreshItems: TTimer;
    pilSelected: TPngImageList;
    pilNormal: TPngImageList;
    tmrSetSkin: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbSkinListClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure lbSkinListGetCellText(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem;
      var AColText: string);
    procedure lbSkinListGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbSkinListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbSkinListResize(Sender: TObject);
    procedure tmrRefreshItemsTimer(Sender: TObject);
    procedure tmrSetSkinTimer(Sender: TObject);

  private
    FSkin: string;
    FTheme: ISharpETheme;
    FPluginHost: ISharpCenterHost;
    procedure BuildSkinList;
    procedure BuildPreviewList;

    function SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
      bgcolor: TColor;
      CompressionLevel: Integer = 9;
      InterlaceMethod: TInterlaceMethod = imNone): tPNGObject;
  public
    procedure RefreshSkinList;
    property Skin: string read FSkin write FSkin;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
    property Theme: ISharpETheme read FTheme write FTheme;    
  end;

var
  frmListWnd: TfrmListWnd;

const
  cItem = 0;
  cUrl = 1;
  cInfo = 2;

type
  TARGB = record
    b: Byte;
    g: Byte;
    r: Byte;
    a: Byte;
  end;
  PARGB = ^TARGB;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmListWnd.FormShow(Sender: TObject);
begin
  RefreshSkinList;
end;

procedure TfrmListWnd.BuildPreviewList;
var
  dir, skin, scheme: string;
  files, tokens: TStringList;
  i: integer;
  png, png2: TPngImageCollectionItem;
  bmp32: TBitmap32;
  path : string;
  tmp: TPNGObject;
begin
  pilNormal.Clear;
  pilSelected.Clear;
  dir := SharpApi.GetSharpeDirectory + 'Skins\';
  files := TStringList.Create;
  try

    FindFiles( files, dir, '*skin.xml');
    for i := 0 to Pred( files.Count ) do begin

      // Get skin name
      path := ExtractFilePath(files[i]);
      tokens := TStringList.Create;
      try
        StrTokenToStrings(path, '\', tokens);
        skin := tokens[tokens.Count - 1];
      finally
        tokens.Free;
      end;

      // get preview and add to pngimagelists
      bmp32 := TBitmap32.Create;
      try
        bmp32.SetSize(70, 30);
        bmp32.DrawMode := dmBlend;
        bmp32.Clear( color32( PluginHost.Theme.PluginSelectedItem ) );

        scheme := 'DEFAULT';
        if FileExists(path + 'preview.bmp') then
          bmp32.LoadFromFile(path + 'preview.bmp')
        else
        begin
          CreateBarPreview(Bmp32, PluginHost.PluginId, skin, scheme, 120, FTheme);
          bmp32.SaveToFile(path + 'preview.bmp');
        end;

        pilNormal.BkColor := FPluginHost.Theme.PluginItem;
        pilSelected.BkColor := FPluginHost.Theme.PluginSelectedItem;

        png := pilNormal.PngImages.Add(false);
        tmp := SaveBitmap32ToPNG(bmp32, False, true, FPluginHost.Theme.PluginItem);
        png.PngImage.Assign(tmp);
        tmp.Free;

        png2 := pilSelected.PngImages.Add(false);
        tmp := SaveBitmap32ToPNG(bmp32, False, true, FPluginHost.Theme.PluginSelectedItem);
        png2.PngImage.Assign(tmp);
        tmp.Free;
      finally
        bmp32.Free;
      end;

    end;
  finally
    files.free;
  end;
end;

procedure TfrmListWnd.BuildSkinList;
var
  dir: string;
  li: tsharpelistitem;

  i, iIndex: Integer;
  files, tokens: TStringList;
  sSkin, s: string;
begin
  dir := SharpApi.GetSharpeDirectory + 'Skins\';
  iIndex := -1;
  lbSkinList.Clear;

  files := TStringList.Create;
  try

    FindFiles( files,dir,'*skin.xml');
    for i := 0 to Pred(files.count) do begin

      // Get skin name
      sSkin := ExtractFilePath(files[i]);
      tokens := TStringList.Create;
      try
        StrTokenToStrings(sSkin, '\', tokens);
        sSkin := tokens[tokens.Count - 1];
      finally
        tokens.Free;
      end;

      li := lbSkinList.AddItem(sSkin, i);
      li.AddSubItem('');
      li.AddSubItem('');
      li.Data := Pointer(TSkinItem.Create(sSkin));

      s := FTheme.Skin.Name;
      if s = sSkin then
        iIndex := i;

    end;

  finally
    files.Free;

    lbSkinList.ItemIndex := iIndex;

    PluginHost.Refresh;
  end;
end;

procedure TfrmListWnd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  lbSkinList.DoubleBuffered := True;
end;

function TfrmListWnd.SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
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
            p[x] :=
              TARGB(bm32.Pixel[x, y]).a;
        end;
      end;
    end;

  finally
    Result := png;
  end;
end;

procedure TfrmListWnd.tmrRefreshItemsTimer(Sender: TObject);
begin
  tmrRefreshItems.Enabled := False;

  BuildPreviewList;
  lbSkinList.Refresh;
end;

procedure TfrmListWnd.tmrSetSkinTimer(Sender: TObject);
var
  tmp: TSkinItem;
begin
  tmrSetSkin.Enabled := false;

  tmp := TSkinItem(lbSkinList.SelectedItem.Data);
  FSkin := tmp.Name;
  FPluginHost.Save;

  SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(suSkin), 0);
end;

procedure TfrmListWnd.lbSkinListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TSkinItem;

begin
  tmp := TSkinItem(AItem.Data);

  if (tmp <> nil) then begin

    case ACol of
      cItem: begin
          tmrSetSkin.Enabled := true;
        end;
        cUrl: begin
          if tmp.Website <> '' then
            SharpExecute(tmp.Website);
        end;
        cInfo: begin
          if tmp.Info <> '' then
            ShowMessage(tmp.Info);

        end;
    end;

  end;

end;

procedure TfrmListWnd.lbSkinListGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmp: TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);

  if tmp <> nil then begin
    if (ACol = cUrl) then begin
      if (tmp.Website <> '') then
        ACursor := crHandPoint
      else
        ACursor := crDefault;
    end
    else if (ACol = cInfo) then begin
      if (tmp.Info <> '') then
        ACursor := crHandPoint
      else
        ACursor := crDefault;
    end;
  end;
end;

procedure TfrmListWnd.lbSkinListGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmp: TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);

  if tmp <> nil then begin
    if (ACol = cUrl) then begin

      if (tmp.Website <> '') then
        AImageIndex := 0
      else
        AImageIndex := -1;
    end
    else if (ACol = cInfo) then begin

      if (tmp.Info <> '') then
        AImageIndex := 1
      else
        AImageIndex := -1;
    end;
  end;
end;

procedure TfrmListWnd.lbSkinListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TSkinItem;
	colItemTxt, colDescTxt, colBtnTxt: TColor;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then exit;

  // Assign theme colours
  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  if (ACol = cItem) then begin
    if tmp.Author = '' then
      AColText := Format('<font color="%s" />%s', [colortostring(colItemTxt), tmp.Name]) else
      AColText := Format('<font color="%s" />%s<font color="%s" /> By %s', [colortostring(colItemTxt),
        tmp.Name, colortostring(colDescTxt), tmp.Author]);
  end;

end;

procedure TfrmListWnd.lbSkinListResize(Sender: TObject);
begin
  Self.Height := lbSkinList.Height;
end;

procedure TfrmListWnd.RefreshSkinList;
begin
  BuildSkinList;
  tmrRefreshItems.Enabled := True;
end;

{ TSkinItem }

constructor TSkinItem.Create(AName, AAuthor, AWebsite, AInfo, AVersion: string);
begin
  FName := AName;
  FAuthor := AAuthor;
  FWebsite := AWebsite;
  FInfo := AInfo;
end;

constructor TSkinItem.Create(ASkin: String);
var
  xml:TJclSimpleXML;
  s:String;
begin
  FName := ASkin;

  s := GetSharpeDirectory+'skins\' + ASkin + '\' + 'skin.xml';
  if Not(FileExists(s)) then
    exit;

  xml := TJclSimpleXML.Create;
  Try
    xml.LoadFromFile(s);
    if xml.Root.Items.ItemNamed['header'] <> nil then begin
      with xml.Root.Items.ItemNamed['header'] do begin
        FName := ASkin;
        FAuthor := Items.Value('author');
        FWebsite := Items.Value('url');
        FInfo := Items.Value('info');
        FVersion := Items.Value('version');
      end;
    end;

  Finally
    xml.Free;
  End;
end;

end.

