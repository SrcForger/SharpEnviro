{
Source Name: uIconeListWnd.pas
Description: Icon List Window
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
  Dialogs, StdCtrls, JclSimpleXML, JclFileUtils,
  ImgList, PngImageList, uISharpETheme, uThemeConsts,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, Types,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

  TIconItem = class
  private
    FAuthor: string;
    FName: string;
    FWebsite: string;
    FComment: string;
  public
    property Name: string read FName write FName;
    property Author: string read FAuthor write FAuthor;
    property Website: string read FWebsite write FWebsite;
    property Comment: string read FComment write FComment;
  end;

type
  TfrmListWnd = class(TForm)
    lbIcons: TSharpEListBoxEx;
    Images: TPngImageList;
    tmr: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure lbIconsResize(Sender: TObject);
    procedure lbIconsClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure lbIconsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbIconsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbIconsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure tmrTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FTheme : ISharpETheme;
    FPluginHost: ISharpCenterHost;
    FIconSet: string;

  public
    procedure ClearList;
    procedure BuildIconList;
    procedure BuildIconPreview(var ABmp: TBitmap32);

    property IconSet: string read FIconSet write FIconSet;
    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
    property Theme: ISharpETheme read FTheme write FTheme;
  end;

var
  frmListWnd: TfrmListWnd;

implementation

uses
  SharpThemeApiEx,
  SharpCenterApi,
  SharpCenterThemeApi,
  SharpIconUtils;

{$R *.dfm}

procedure TfrmListWnd.tmrTimer(Sender: TObject);
begin
  tmr.Enabled := false;
  BuildIconList;
end;

procedure TfrmListWnd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
  lbIcons.DoubleBuffered := True;
end;

procedure TfrmListWnd.FormDestroy(Sender: TObject);
begin
  ClearList;
  FTheme := nil;
end;

procedure TfrmListWnd.FormShow(Sender: TObject);
begin
  frmListWnd.tmr.Enabled := true;
end;

procedure TfrmListWnd.BuildIconPreview(var ABmp: TBitmap32);
const
  IconSize = 32;
var
  x, y: integer;
  s,DefaultDir,Dir: string;
  icon: TBitmap32;
  n,i: integer;
  h: integer;
  tmp: TIconItem;
  Icons : TSharpEIcons;
  SEIcon : TSharpEIcon;
  nearestsize : integer;
begin
  tmp := TIconItem(lbIcons.Item[lbIcons.ItemIndex].Data);
  DefaultDir := SharpApi.GetSharpeDirectory + 'Icons\Default\';
  Dir := SharpApi.GetSharpeDirectory + 'Icons\' + tmp.Name + '\';

  Icon := TBitmap32.Create;
  Icon.DrawMode := dmBlend;
  Icon.CombineMode := cmMerge;


  FTheme.Icons.GetIconsFromDir(Icons,Dir);

  h := (length(Icons) div (ABmp.Width div (IconSize + 2)) + 1) * IconSize;
  ABmp.Height := h;

  x := 0;
  y := 0;
  for n := 0 to High(Icons) do
  begin
    Application.ProcessMessages;
    SEIcon := Icons[n];
    nearestsize := 0;
    for i := 0 to High(SEIcon.sizes) do
    begin
      if (SEIcon.sizes[i] > nearestsize) and (nearestsize < 32) then
        nearestsize := SEIcon.sizes[i];
      if nearestsize >= 32 then
        break;
    end;
    s := Dir + inttostr(nearestsize) + '\' + SEIcon.Tag + '.png';
    if not FileExists(s) then
      s := DefaultDir + inttostr(nearestsize) + '\' + SEIcon.Tag + '.png';
    SharpIconUtils.LoadPng(Icon,s);
    Icon.DrawTo(ABmp, x * (Icon.Width + 2), y * Icon.Height);
    x := x + 1;
    if x * (Icon.Width + 2) >= (ABmp.Width - Icon.Width) then
    begin
      x := 0;
      y := y + 1;
    end;
  end;

  Icon.Free;
end;

procedure TfrmListWnd.ClearList;
var
  n : integer;
begin
  for n := lbIcons.Count - 1 downto 0 do
  begin
    TIconItem(lbIcons.Item[n].Data).Free;
    lbIcons.DeleteItem(n);
  end;
end;

procedure TfrmListWnd.BuildIconList;
var
  newItem: TSharpEListItem;
  sr: TSearchRec;
  Dir: string;
  XML: TJclSimpleXML;
  tmp: TIconItem;
begin
  ClearList;

  XML := TJclSimpleXML.Create;
  try
    Dir := SharpApi.GetSharpeDirectory + 'Icons\';
  
    if FindFirst(Dir + '*', FADirectory, sr) = 0 then
    begin
      repeat
        if (CompareText(sr.Name, '.') <> 0) and (CompareText(sr.Name, '..') <> 0) then
        begin
          if FileExists(Dir + sr.Name + '\IconSet.xml') then
          begin
            try
              XML.LoadFromFile(Dir + sr.Name + '\IconSet.xml');

              if XML.Root.Items.ItemNamed['IconSizes'] <> nil then
              begin
                tmp := TIconItem.Create;
                tmp.Name := XML.Root.Items.Value('name', '...');
                tmp.Author := XML.Root.Items.Value('author', '...');
                tmp.Website := XML.Root.Items.Value('website', '');

                newItem := lbIcons.AddItem('', 0);
                newItem.Data := tmp;
                if length(trim(tmp.Website)) > 0 then
                  newItem.AddSubItem('', 1)
                else
                  newItem.AddSubItem('', -1);

                if CompareText(sr.Name,FIconSet) = 0 then
                begin
                  lbIcons.ItemIndex := lbIcons.Items.Count - 1;
                  //BuildIconPreview;
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

  if (lbIcons.ItemIndex < 0) and (lbIcons.Count > 0) then begin
    lbIcons.ItemIndex := 0;
    //BuildIconPreview;
  end;

  PluginHost.Refresh;
end;

procedure TfrmListWnd.lbIconsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TIconItem;
begin
  tmp := TIconItem(AItem.Data);
  if tmp = nil then
    exit;

  if (ACol = 0) then begin
    PluginHost.Refresh;
    PluginHost.Save;
  end
  else if (ACol = 1) then begin
    if (Pos('http', tmp.Website) <> 0) then
      SharpExecute(TIconItem(AItem.Data).Website) else begin
        PluginHost.Refresh(rtPreview);
        PluginHost.Save;
      end;
  end;
end;

procedure TfrmListWnd.lbIconsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmp: TIconItem;
begin
  tmp := TIconItem(AItem.Data);
  if tmp = nil then
    exit;

  if ACol = 1 then begin

    if (Pos('http', tmp.Website) = 0) then
      ACursor := crDefault
    else
      ACursor := crHandPoint;

  end;

end;

procedure TfrmListWnd.lbIconsGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmp: TIconItem;
begin
  tmp := TIconItem(AItem.Data);
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

procedure TfrmListWnd.lbIconsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TIconItem;
  s: string;
  colItemTxt, colDescTxt, colBtnTxt: TColor;
begin
  tmp := TIconItem(AItem.Data);
  if tmp = nil then exit;

  // Assign theme colours
  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  if ACol = 0 then begin

    if tmp.Author <> '' then
      s := ' By ' + tmp.Author
    else
      s := '';

    AColText := Format('<font color="%s" />%s<font color="%s" />%s',
      [ColorToString(colItemTxt), tmp.Name,ColorToString(colDescTxt), s]);
  end;
end;

procedure TfrmListWnd.lbIconsResize(Sender: TObject);
begin
  Self.Height := lbIcons.Height;
end;

end.

