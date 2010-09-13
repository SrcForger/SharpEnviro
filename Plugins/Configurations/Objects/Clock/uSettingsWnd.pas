{
Source Name: uSettingsWnd.pas
Description: Clock Object Settings Window
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

unit uSettingsWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  JclSimpleXML,
  JclFileUtils,
  ImgList,
  PngImageList,
  SharpEListBox,
  SharpEListBoxEx,
  GR32,
  GR32_PNG,
  SharpApi,
  ExtCtrls,
  Menus,
  JclStrings,
  GR32_Image,
  SharpEGaugeBoxEdit,
  SharpEUIC,
  SharpEFontSelectorFontList,
  JvPageList,
  JvExControls,
  SharpEPageControl,
  ComCtrls,
  Mask,
  JvExMask,
  JvToolEdit,
  SharpEColorEditorEx,
  SharpDialogs,
  SharpERoundPanel,
  SharpIconUtils,
  JvExStdCtrls,
  JvCheckBox,
  SharpESwatchManager,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  JvXPCore,
  JvXPCheckCtrls,
  Buttons,
  PngSpeedButton,
  pngimage,
  SharpECenterHeader,
  SharpCenterThemeApi;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

  TSkinItem = class
  private
    FAuthor: string;
    FName: string;
    FWebsite: string;
    FComment: string;
    FSkinName: string;
  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Website: string read FWebsite write FWebsite;
    property Comment: string read FComment write FComment;
    property SkinName: string read FSkinName write FSkinName;
  end;

type
  TfrmSettings = class(TForm)
    plMain: TJvPageList;
    pagClock: TJvStandardPage;
    Panel69: TPanel;
    SharpESwatchManager1: TSharpESwatchManager;
    imlFontIcons: TPngImageList;
    pnlOverride: TPanel;
    Image1: TImage;
    Label6: TLabel;
    btnRevert: TPngSpeedButton;
    pnlClock: TPanel;
    SharpECenterHeader2: TSharpECenterHeader;
    pnlSkin: TPanel;
    lbSkins: TSharpEListBoxEx;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure btnRevertClick(Sender: TObject);
    procedure lbSkinsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbSkinsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbSkinsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbSkinsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
  private
    FClockSkin : string;
    FFontList: TFontList;
    FPluginHost: ISharpCenterHost;

    procedure SendUpdate;

    procedure ClearList;
  public
    sObjectID: string;

    procedure UpdatePageUI;
    procedure UpdateClockPage;

    procedure BuildSkinList;

    property ClockSkin : string read FClockSkin write FClockSkin;
    property FontList: TFontList read FFontList;

    property PluginHost: ISharpCenterHost read FPluginHost
      write FPluginHost;
  end;

var
  frmSettings: TfrmSettings;

const
  cIconSize32 = 32;
  cIconSize48 = 48;
  cIconSize64 = 64;

implementation

{$R *.dfm}

procedure LoadBmpFromRessource(Bmp: TBitmap32; ResName: string);
var
  ResStream: TResourceStream;
  TempBmp: TBitmap32;
  b: boolean;
begin
  if Bmp = nil then exit;

  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(22, 22);
  TempBmp.Clear(color32(0, 0, 0, 0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp, ResStream, b);
      Bmp.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;
end;

procedure TfrmSettings.btnRevertClick(Sender: TObject);
var
  i: Integer;
  n: Integer;
begin
  n := plMain.ActivePageIndex;

  LockWindowUpdate(Self.Handle);
  try
    for i := 0 to Pred(Self.ComponentCount) do begin
      if Self.Components[i].ClassNameIs('TSharpEUIC') then begin
        TSharpEUIC(Self.Components[i]).Reset;
      end;
    end;
    plMain.ActivePageIndex := n;
  finally
    LockWindowUpdate(0);
  end;

  SendUpdate;
  UpdatePageUI;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;

  FClockSkin := '';
  lbSkins.DoubleBuffered := True;
end;

procedure TfrmSettings.FormDestroy(Sender: TObject);
begin
  ClearList;
end;

procedure TfrmSettings.lbSkinsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then
    exit;

  if (ACol = 0) then
  begin
    PluginHost.Refresh;
    PluginHost.Save;
  end else if (ACol = 1) then
  begin
    if (Pos('http', tmp.Website) <> 0) then
      SharpExecute(TSkinItem(AItem.Data).Website)
    else begin
      PluginHost.Refresh(rtPreview);
      PluginHost.Save;
    end;
  end;
end;

procedure TfrmSettings.lbSkinsGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmp : TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then
    exit;

  if (ACol = 0) or (Pos('http', tmp.Website) = 0) then
    ACursor := crDefault
  else if ACol = 1 then
    ACursor := crHandPoint;
end;

procedure TfrmSettings.lbSkinsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmp : TSkinItem;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = 0 then
    AImageIndex := 2;

  if ACol = 1 then begin

    if (Pos('http', tmp.Website) = 0) then
      AImageIndex := -1
    else
      AImageIndex := 1;

  end;
end;

procedure TfrmSettings.lbSkinsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TSkinItem;
  s: string;
  colItemTxt, colDescTxt, colBtnTxt: TColor;
begin
  tmp := TSkinItem(AItem.Data);
  if tmp = nil then
    exit;

  // Assign theme colours
  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  if ACol = 0 then
  begin
    if tmp.Author <> '' then
      s := ' By ' + tmp.Author
    else
      s := '';

    AColText := Format('<font color="%s" />%s<font color="%s" />%s',
      [ColorToString(colItemTxt), tmp.Name, ColorToString(colDescTxt), s]);
  end;
end;
procedure TfrmSettings.ClearList;
var
  n : integer;
begin
  for n := lbSkins.Count - 1 downto 0 do
  begin
    TSkinItem(lbSkins.Item[n].Data).Free;
    lbSkins.DeleteItem(n);
  end;
end;

procedure TfrmSettings.BuildSkinList;
var
  newItem: TSharpEListItem;
  sr: TSearchRec;
  Dir: string;
  XML: TJclSimpleXML;
  tmp: TSkinItem;
  n : integer;
begin
  ClearList;

  XML := TJclSimpleXML.Create;
  try
    Dir := SharpApi.GetSharpeDirectory + 'Skins\Objects\Clock\';
  
    if FindFirst(Dir + '*', FADirectory, sr) = 0 then
    begin
      repeat
        if (CompareText(sr.Name, '.') <> 0) and (CompareText(sr.Name, '..') <> 0) then
        begin
          if FileExists(Dir + sr.Name + '\Clock.xml') then
          begin
            try
              XML.LoadFromFile(Dir + sr.Name + '\Clock.xml');

              for n := 0 to XML.Root.Items.Count - 1 do
              begin
                if XML.Root.Items.Item[n].Name = 'Info' then
                begin
                  with XML.Root.Items.Item[n].Items do
                  begin
                    tmp := TSkinItem.Create;
                    tmp.Name := Value('name', '...');
                    tmp.Author := Value('author', '...');
                    tmp.Website := Value('website', '');
                    tmp.SkinName := sr.Name;

                    newItem := lbSkins.AddItem('', 0);
                    newItem.Data := tmp;
                    if length(trim(tmp.Website)) > 0 then
                      newItem.AddSubItem('', 1)
                    else
                      newItem.AddSubItem('', -1);

                    if CompareText(sr.Name, FClockSkin) = 0 then
                    begin
                      lbSkins.ItemIndex := lbSkins.Items.Count - 1;
                    end;
                  end;
                end;
              end;
            except
            end;
          end;
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
    end;
  finally
    XML.Free;
  end;

  if (lbSkins.ItemIndex < 0) and (lbSkins.Count > 0) then begin
    lbSkins.ItemIndex := 0;
    //BuildIconPreview;
  end;

  //PluginHost.Refresh;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Visible then
    FPluginHost.SetSettingsChanged;
end;

procedure TfrmSettings.UpdateClockPage;
begin
  if not pagClock.Visible then
    exit;

  frmSettings.Height := pnlClock.Height + 50;
  FPluginHost.Refresh(rtSize);
end;

procedure TfrmSettings.UpdatePageUI;
begin
  pnlOverride.Visible := not (pagClock.Visible);

  UpdateClockPage;

end;

end.

