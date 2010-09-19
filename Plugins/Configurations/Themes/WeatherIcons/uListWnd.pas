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
  SharpThemeApiEx, SharpEListBoxEx, BarPreview, GR32, pngimage,
  ExtCtrls, SharpCenterApi, SharpFileUtils, SharpCenterThemeApi, JclStrings,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

  TIconsItem = class
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
    lbIconsList: TSharpEListBoxEx;
    PngImageList1: TPngImageList;
    tmrRefreshItems: TTimer;
    pilSelected: TPngImageList;
    pilNormal: TPngImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbIconsListClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure lbIconsListGetCellText(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem;
      var AColText: string);
    procedure lbIconsListGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbIconsListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbIconsListResize(Sender: TObject);
    procedure tmrRefreshItemsTimer(Sender: TObject);

  private
    FIconSet: string;
    FPluginHost: ISharpCenterHost;

    procedure BuildIconsList;
    procedure BuildPreviewList;

  public
    procedure RefreshIconsList;
    property IconSet: string read FIconSet write FIconSet;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
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

uses
  uSharpXMLUtils;

{$R *.dfm}

{ TfrmConfigListWnd }

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
            p[x] :=
              TARGB(bm32.Pixel[x, y]).a;
        end;
      end;
    end;

  finally
    Result := png;
  end;
end;

procedure TfrmListWnd.FormShow(Sender: TObject);
begin
  RefreshIconsList;
end;

procedure TfrmListWnd.BuildIconsList;
var
  dir: string;
  li: tsharpelistitem;

  i, iIndex: Integer;
  dirs, files, tokens: TStringList;
  sSkin: string;
  Xml : TJclSimpleXml;
begin
  lbIconsList.Clear;

  iIndex := 0;

  dir := SharpApi.GetSharpeDirectory + 'Icons\Weather';

  files := TStringList.Create;
  dirs := TStringList.Create;
  try
    SharpFileUtils.FindFiles(dirs, dir, '*.*', False, True);
    for i := 0 to dirs.Count - 1 do
    begin
      if FileExists(dirs[i] + '\IconSet.xml') then
        files.Add(dirs[i] + '\IconSet.xml');
    end;
      
    for i := 0 to Pred(files.count) do
    begin
      // Get Icon set name
      Xml := TJclSimpleXml.Create;
      if LoadXmlFromSharedFile(Xml, files[i]) then
      begin
		if XML.Root.Items.ItemNamed['Info'] <> nil
		then
			with XML.Root.Items.ItemNamed['Info'].Items do
			begin
			if Value('name') <> '' then
				sSkin := Value('name');
			end;
      end;
      Xml.Free;

      tokens := TStringList.Create;
      try
        StrTokenToStrings(sSkin, '\', tokens);
        sSkin := tokens[tokens.Count - 1];
      finally
        tokens.Free;
      end;

      li := lbIconsList.AddItem(sSkin, i);
      li.AddSubItem('');
      li.AddSubItem('');
      li.Data := Pointer(TIconsItem.Create(sSkin));

      if sSkin = FIconSet then
        iIndex := i;
    end;
  finally
    dirs.Free;
    files.Free;

    lbIconsList.ItemIndex := iIndex;

    PluginHost.Refresh;
  end;
end;

procedure TfrmListWnd.BuildPreviewList;
var
  dir, skin: string;
  dirs, files, tokens: TStringList;
  i: integer;
  png, png2: TPngImageCollectionItem;
  bmp32: TBitmap32;
  path : string;
  tmp: TPNGObject;
begin
  pilNormal.Clear;        
  pilSelected.Clear;
  dir := SharpApi.GetSharpeDirectory + 'Icons\Weather';

  files := TStringList.Create;
  dirs := TStringList.Create;
  try
    SharpFileUtils.FindFiles(dirs, dir, '*.*', False, True);
    for i := 0 to dirs.Count - 1 do
    begin
      if FileExists(dirs[i] + '\IconSet.xml') then
        files.Add(dirs[i] + '\IconSet.xml');
    end;
    for i := 0 to Pred( files.Count ) do
    begin
      // Get skin name
      path := ExtractFilePath(files[i]);
      tokens := TStringList.Create;
      try
        StrTokenToStrings(path, '\', tokens);
        skin := tokens[tokens.Count - 1];
      finally
        tokens.Free;
      end;

      {$WARNINGS OFF} path := IncludeTrailingBackSlash(path); {$WARNINGS ON}
      // get preview and add to pngimagelists
      bmp32 := TBitmap32.Create;
      try
        bmp32.SetSize(70, 30);
        bmp32.DrawMode := dmBlend;
        bmp32.Clear( color32( PluginHost.Theme.PluginSelectedItem ) );

        Bmp32.LoadFromFile(dir + '\' + skin + '\32\icon.weather.cleard.png');

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
    dirs.Free;
    files.free;
  end;
end;

procedure TfrmListWnd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  lbIconsList.DoubleBuffered := True;
end;

procedure TfrmListWnd.tmrRefreshItemsTimer(Sender: TObject);
begin
  tmrRefreshItems.Enabled := False;
  BuildPreviewList;
  lbIconsList.Refresh;
end;

procedure TfrmListWnd.lbIconsListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TIconsItem;

begin
  tmp := TIconsItem(AItem.Data);

  if (tmp <> nil) then begin

    case ACol of
      cItem:
        begin
          tmp := TIconsItem(lbIconsList.SelectedItem.Data);
          FIconSet := tmp.Name;
          FPluginHost.Save;
        end;
      cUrl:
        begin
          if tmp.Website <> '' then
            SharpExecute(tmp.Website);
        end;
      cInfo:
        begin
          if tmp.Info <> '' then
            ShowMessage(tmp.Info);
        end;
    end;

  end;

end;

procedure TfrmListWnd.lbIconsListGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmp: TIconsItem;
begin
  tmp := TIconsItem(AItem.Data);

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

procedure TfrmListWnd.lbIconsListGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmp: TIconsItem;
begin
  tmp := TIconsItem(AItem.Data);

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

procedure TfrmListWnd.lbIconsListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TIconsItem;
	colItemTxt, colDescTxt, colBtnTxt: TColor;
begin
  tmp := TIconsItem(AItem.Data);
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

procedure TfrmListWnd.lbIconsListResize(Sender: TObject);
begin
  Self.Height := lbIconsList.Height;
end;

procedure TfrmListWnd.RefreshIconsList;
begin
  BuildIconsList;
  tmrRefreshItems.Enabled := True;
end;

{ TSkinItem }

constructor TIconsItem.Create(AName, AAuthor, AWebsite, AInfo, AVersion: string);
begin
  FName := AName;
  FAuthor := AAuthor;
  FWebsite := AWebsite;
  FInfo := AInfo;
end;

constructor TIconsItem.Create(ASkin: String);
var
  xml:TJclSimpleXML;
  s:String;
begin
  FName := ASkin;

  s := GetSharpeDirectory + 'Icons\Weather\' + ASkin + '\' + 'IconSet.xml';
  if Not(FileExists(s)) then
    exit;

  xml := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(xml,s) then
  begin
	if XML.Root.Items.ItemNamed['Info'] <> nil then
		with XML.Root.Items.ItemNamed['Info'].Items do
		begin
			FName := ASkin;
			FAuthor := Value('author');
			FWebsite := Value('Website');
			FInfo := Value('info');
			FVersion := Value('version');
		end;
  end;
  xml.Free;
end;

end.

