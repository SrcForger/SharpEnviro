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
  Dialogs, StdCtrls, JclSimpleXML, JclFileUtils, Contnrs, jvSimpleXml,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, JclStrings, GR32_Image, Types, PngImageList;

type
  TMenuItem = class
    ID: Integer;
    Name: String;
    FileName: String;
  end;

  TfrmList = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    procedure lbItemsResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbItemsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbItemsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbItemsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
  private
    FItems: TObjectList;
    procedure AddItemsToList(AList: TObjectList);
    procedure RenderItems;
  public

  end;

var
  frmList: TfrmList;

const
  colName = 0;
  colEdit = 1;
  colCopy = 2;
  colDelete = 3;

  iidxCopy = 5;
  iidxDelete = 6;

implementation

uses SharpThemeApi, SharpCenterApi,
  SharpIconUtils;

{$R *.dfm}

procedure TfrmList.AddItemsToList(AList: TObjectList);
var
  xml: TJvSimpleXML;
  newItem: TMenuItem;
  dir: string;
  slMenus: TStringList;
  i, j, index: Integer;

  function ExtractBarID(ABarXmlFileName: string): Integer;
  var
    s: string;
    n: Integer;
  begin
    s := PathRemoveSeparator(ExtractFilePath(ABarXmlFileName));
    n := JclStrings.StrLastPos('\', s);
    s := Copy(s, n + 1, length(s));
    result := StrToInt(s);

  end;

begin
  AList.Clear;
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\';

  slMenus := TStringList.Create;
  xml := TJvSimpleXML.Create(nil);
  try

    // build list of bar.xml files
    AdvBuildFileList(dir + '*.xml', faAnyFile, slMenus, amAny, [flFullNames]);
    for i := 0 to Pred(slMenus.Count) do begin
      xml.LoadFromFile(slMenus[i]);
      if xml.Root.Name = 'SharpEMenuFile' then begin
        newItem := TMenuItem.Create;
        newItem.ID := i;
        newItem.Name := PathRemoveExtension(ExtractFileName(slMenus[i]));
        newItem.FileName := slMenus[i];
        AList.Add(newItem);
      end;
    end;

  finally
    slMenus.Free;
    xml.Free;
  end;
end;

procedure TfrmList.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;
  
  FItems := TObjectList.Create;
  RenderItems;
end;

procedure TfrmList.FormDestroy(Sender: TObject);
begin
  FItems.Free;
end;

procedure TfrmList.lbItemsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpMenu: TMenuItem;
  s: String;
begin

  tmpMenu := TMenuItem(AItem.Data);
  if tmpMenu = nil then
    exit;

  case ACol of
  colEdit: begin
        CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
            + '\_Components\MenuEdit.con'), pchar(tmpMenu.Name));
      end;
  end;
end;

procedure TfrmList.lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > 0 then
    ACursor := crHandPoint;
end;

procedure TfrmList.lbItemsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmpMenu: TMenuItem;
  s: String;
begin

  tmpMenu := TMenuItem(AItem.Data);
  if tmpMenu = nil then
    exit;

  case ACol of
    colCopy: AImageIndex := iidxCopy;
    colDelete : AImageIndex := iidxDelete;
  end;

end;

procedure TfrmList.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpMenu: TMenuItem;
  s: String;
begin

  tmpMenu := TMenuItem(AItem.Data);
  if tmpMenu = nil then
    exit;

  case ACol of
    colName: AColText := tmpMenu.Name;
    colEdit : AColText := '<font color="clNavy"><u>Edit</u>';
  end;
end;

procedure TfrmList.lbItemsResize(Sender: TObject);
begin
  Self.Height := lbItems.Height;
end;

procedure TfrmList.RenderItems;
var
  newItem: TSharpEListItem;
  XML: TJvSimpleXML;
  Dir: string;
  MenuItem: TMenuItem;
  SList: TStringList;
  sr: TSearchRec;
  fileloaded: boolean;

  selectedIndex, i, index: Integer;
  tmpMenu: TMenuItem;
begin

  // Get selected item
  LockWindowUpdate(Self.Handle);
  Try
  if lbItems.ItemIndex <> -1 then
    selectedIndex := TMenuItem(lbItems.Item[lbItems.ItemIndex].Data).ID
  else
    selectedIndex := -1;

  lbItems.Clear;
  AddItemsToList(FItems);

  for i := 0 to FItems.Count - 1 do begin

    tmpMenu := TMenuItem(FItems.Items[i]);

    newItem := lbItems.AddItem(tmpMenu.Name);
    newItem.Data := tmpMenu;
    newItem.AddSubItem('');
    newItem.AddSubItem('');
    newItem.AddSubItem('');

    if tmpMenu.ID = selectedIndex then
      lbItems.ItemIndex := i;

  end;
  Finally
    LockWindowUpdate(0);
  End;

end;

end.

