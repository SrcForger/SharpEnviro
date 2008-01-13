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

unit uThemeSkinListWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, SharpApi, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, graphicsfx, SharpThemeApi, SharpEListBoxEx, BarPreview, GR32, GR32_PNG, pngimage,
  ExtCtrls, SharpCenterApi, JclStrings;

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
  TfrmSkinListWnd = class(TForm)
    ThemeImages: TPngImageList;
    lbSkinList: TSharpEListBoxEx;
    PngImageList1: TPngImageList;
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

  private
    FTheme: string;
    FDefaultSkin: string;
    procedure BuildSkinList;
    function SaveBitmap32ToPNG(bm32: TBitmap32; paletted, transparent: Boolean;
      bgcolor: TColor;
      CompressionLevel: Integer = 9;
      InterlaceMethod: TInterlaceMethod = imNone): tPNGObject;
  public

    property Theme: string read FTheme write FTheme;
    property DefaultSkin: string read FDefaultSkin write FDefaultSkin;

    procedure Save;
  end;

var
  frmSkinListWnd: TfrmSkinListWnd;

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

procedure TfrmSkinListWnd.FormShow(Sender: TObject);
begin
  BuildSkinList;
end;

procedure TfrmSkinListWnd.BuildSkinList;
var
  dir: string;
  Bmp32: TBitmap32;
  png: TPngImageCollectionItem;
  li: tsharpelistitem;
  sScheme: string;

  i, iIndex: Integer;
  files, tokens: TStringList;
  sSkin, s: string;
begin
  dir := SharpApi.GetSharpeDirectory + 'Skins\';
  iIndex := -1;
  lbSkinList.Clear;

  files := TStringList.Create;
  try

    AdvBuildFileList(dir + '*skin.xml', faAnyFile, files, amAny, [flFullNames, flRecursive]);
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

      bmp32 := TBitmap32.Create;
      try
        bmp32.SetSize(70, 30);

        sScheme := XmlGetScheme(FTheme) + '.xml';
        CreateBarPreview(Bmp32, FTheme, sSkin, sScheme, 100);
        png := lbSkinList.Column[cItem].Images.PngImages.Add(false);
        png.PngImage := SaveBitmap32ToPNG(bmp32, False, True, ClWhite);

        li := lbSkinList.AddItem(sSkin, png.id);
        li.AddSubItem('');
        li.AddSubItem('');
        li.Data := Pointer(TSkinItem.Create(sSkin));
      finally
        bmp32.free;
      end;

      s := XmlGetSkin(FTheme);
      if s = sSkin then
        iIndex := i;

    end;

  finally
    files.Free;

    lbSkinList.ItemIndex := iIndex;
  end;
end;

procedure TfrmSkinListWnd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  lbSkinList.DoubleBuffered := True;
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

procedure TfrmSkinListWnd.lbSkinListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TSkinItem;

  procedure SetSkin;
  begin
    FDefaultSkin := tmp.Name;
    Save;

    SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(suSkin), 0);
  end;
begin
  tmp := TSkinItem(AItem.Data);

  if (tmp <> nil) then begin

    case ACol of
      cItem: begin
          SetSkin;
        end;
        cUrl: begin
          if tmp.Website <> '' then
            SharpExecute(tmp.Website) else
            SetSkin;
        end;
        cInfo: begin
          if tmp.Info <> '' then
            ShowMessage(tmp.Info) else
            SetSkin;

        end;
    end;

  end;

end;

procedure TfrmSkinListWnd.lbSkinListGetCellCursor(Sender: TObject; const ACol: Integer;
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

procedure TfrmSkinListWnd.lbSkinListGetCellImageIndex(Sender: TObject; const ACol: Integer;
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

procedure TfrmSkinListWnd.lbSkinListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);

  if ((tmp <> nil) and (ACol = cItem)) then begin
    if tmp.Author = '' then
      AColText := Format('%s', [tmp.Name]) else
      AColText := Format('%s by %s', [tmp.Name, tmp.Author]);
  end;

end;

procedure TfrmSkinListWnd.lbSkinListResize(Sender: TObject);
begin
  Self.Height := lbSkinList.Height;
end;

procedure TfrmSkinListWnd.Save;
var
  xml: TJvSimpleXML;
  s: string;
begin
  xml := TJvSimpleXML.Create(nil);
  try
    s := XmlGetSkinFile(FTheme);
    forcedirectories(ExtractFilePath(s));

    xml.Root.Clear;
    xml.Root.Name := 'SharpEThemeSkin';
    xml.Root.Items.Add('Skin', FDefaultSkin);
    xml.SaveToFile(s);
  finally
    xml.Free;
  end;
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
  xml:TJvSimpleXML;
  s:String;
begin
  FName := ASkin;

  s := GetSharpeDirectory+'skins\' + ASkin + '\' + 'skin.xml';
  if Not(FileExists(s)) then
    exit;

  xml := TJvSimpleXML.Create(nil);
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

