{
Source Name: ThemeList
Description: Theme List Config Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

unit uThemeSkinListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, SharpApi, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, graphicsfx, SharpThemeApi, SharpEListBoxEx, BarPreview, GR32, GR32_PNG, pngimage,
  ExtCtrls;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmSkinListWnd = class(TForm)
    ThemeImages: TPngImageList;
    lbSkinList: TSharpEListBoxEx;
    procedure lbSkinListDblClickItem(AText: string; AItem, ACol: Integer);
    procedure lbSkinListGetCellColor(const AItem: Integer; var AColor: TColor);
    procedure lbSkinListGetCellTextColor(const ACol: Integer;
      AItem: TSharpEListItem; var AColor: TColor);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function GetDefaultScheme(ATheme, ASkinName: string): string;

  private
    FTheme: String;
    FDefaultSkin: String;
    procedure BuildSkinList;
    function SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
      bgcolor: TColor;
      CompressionLevel: Integer = 9;
      InterlaceMethod: TInterlaceMethod = imNone): tPNGObject;
  public
    procedure EditTheme;
    property Theme: String read FTheme write FTheme;
    property DefaultSkin: String read FDefaultSkin write FDefaultSkin;
    function GetDefaultSkin(ATheme: String): String;

    procedure Save;
  end;

var
  frmSkinListWnd: TfrmSkinListWnd;

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

procedure TfrmSkinListWnd.FormShow(Sender: TObject);
begin
  BuildSkinList;
end;

procedure TfrmSkinListWnd.BuildSkinList;
var
  sr: TSearchRec;
  dir: string;
  Bmp: TBitmap;
  Bmp32: TBitmap32;
  png: TPngImageCollectionItem;
  li: tsharpelistitem;
  b: boolean;
  n: Integer;
  sScheme: String;
begin
  dir := SharpApi.GetSharpeDirectory + 'Skins\';
  lbSkinList.Clear;

  if FindFirst(dir + '*.*', faDirectory, sr) = 0 then
  begin
    repeat
      try
        if FileExists(dir + sr.Name + '\Skin.xml') then
        begin

          bmp32 := TBitmap32.Create;
          bmp32.SetSize(70, 30);

          sScheme := GetDefaultScheme(FTheme,sr.Name)+'.xml';
          CreateBarPreview(Bmp32, sr.Name, sScheme, 100);
          png := lbSkinList.Column[0].Images.PngImages.Add(false);
          png.PngImage := SaveBitmap32ToPNG(bmp32,False,True,ClWhite);

          li := lbSkinList.AddItem('',png.id);
          li.AddSubItem(sr.Name);

        end;
      except
      end;
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

  bmp32.free;
end;

procedure TfrmSkinListWnd.EditTheme;
var
  str: TStringObject;
begin
  if lbSkinList.ItemIndex < 0 then
    exit;

  // str := TStringObject(skinlist.Items.Objects[skinlist.ItemIndex]);
  SharpApi.CenterMsg(sccLoadSetting,PChar(SharpApi.GetCenterDirectory + '_Themes\Theme.con'), pchar(str.Str));
end;

procedure TfrmSkinListWnd.FormCreate(Sender: TObject);
begin
  lbSkinList.ItemHeight := 50;
  lbSkinList.Colors.BorderColorSelected := clBtnFace;

  with lbSkinList.AddColumn('Icon') do
  begin
    Width := 108;
    Images := ThemeImages;
    Images.Height := 30;
    HAlign := taleftJustify;
    VAlign := taVerticalCenter;
  end;
  with lbSkinList.AddColumn('Name') do
  begin
    Width := 800;
    HAlign := taleftJustify;
    VAlign := taVerticalCenter;
  end;
end;

function TfrmSkinListWnd.SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
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
  try
    png := TPngObject.Create;
    bm := TBitmap.Create;
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
    if transparent then
    begin
      if png.Header.ColorType in [COLOR_PALETTE] then
      begin
        if (png.Chunks.ItemFromClass(TChunktRNS) = nil) then
          png.CreateAlpha;
        TRNS := png.Chunks.ItemFromClass(TChunktRNS) as TChunktRNS;
        if Assigned(TRNS) then
          TRNS.TransparentColor := bgcolor;
      end;
      if png.Header.ColorType in [COLOR_RGB, COLOR_GRAYSCALE] then
        png.CreateAlpha;
      if png.Header.ColorType in [COLOR_RGBALPHA, COLOR_GRAYSCALEALPHA] then
      begin
        for y := 0 to png.Header.Height - 1 do
        begin
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

function TfrmSkinListWnd.GetDefaultScheme(ATheme, ASkinName: string): string;
var
  xml: TJvSimpleXML;
  s: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'Scheme.xml';

    if fileExists(s) then
    begin
      xml.LoadFromFile(s);
      Result := xml.Root.Items.Value('Scheme', 'Default');
    end;
  finally
    xml.Free;
  end;
end;

function TfrmSkinListWnd.GetDefaultSkin(ATheme: String): String;
var
  xml: TJvSimpleXML;
  s: string;
begin
  Result := '';
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + 'Themes\' + ATheme + '\' + 'skin.xml';

    if fileExists(s) then
    begin
      xml.LoadFromFile(s);
      Result := xml.Root.Items.Value('Skin', '');
    end;
  finally
    xml.Free;
  end;
end;

procedure TfrmSkinListWnd.lbSkinListGetCellTextColor(const ACol: Integer;
  AItem: TSharpEListItem; var AColor: TColor);
begin
  if ACol = 1 then
    AColor := clLtGray;

  if ((ACol = 1) and (lbSkinList.ItemIndex = AItem.ID)) then
    AColor := clWindowText;

  if ((ACol = 1) and (CompareText(lbSkinList.Item[AItem.ID].SubItemText[1], FDefaultSkin) = 0)) then
    AColor := clWindowText;
end;

procedure TfrmSkinListWnd.lbSkinListGetCellColor(const AItem: Integer;
  var AColor: TColor);
begin

  if (CompareText(lbSkinList.Item[AItem].SubItemText[1], FDefaultSkin) = 0) then
    AColor := lbskinList.colors.ItemColorSelected;
end;

procedure TfrmSkinListWnd.lbSkinListDblClickItem(AText: string; AItem,
  ACol: Integer);
begin
  FDefaultSkin := lbSkinList.Item[Aitem].SubItemText[1];

  SharpCenterBroadCast( SCM_SET_SETTINGS_CHANGED, 1);
  lbSkinList.Update;

end;

procedure TfrmSkinListWnd.Save;
var
  xml: TJvSimpleXML;
  s: string;
begin
  xml := TJvSimpleXML.Create(nil);
  try
    s := GetSharpeUserSettingsPath + 'Themes\' + FTheme + '\' + 'skin.xml';
    forcedirectories(ExtractFilePath(s));

    xml.Root.Clear;
    xml.Root.Name := 'SharpEThemeSkin';
    xml.Root.Items.Add('Skin', FDefaultSkin);
    xml.SaveToFile(s);
  finally
    xml.Free;
  end;
end;

end.

