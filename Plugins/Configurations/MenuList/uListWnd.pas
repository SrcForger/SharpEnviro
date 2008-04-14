﻿{
Source Name: uListWnd.pas
Description: Menu List Window
Copyright (C) Lee Green (lee@sharpenviro.com)

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
  Contnrs,
  jvSimpleXml,
  ImgList,
  SharpEListBox,
  SharpEListBoxEx,
  GR32,
  GR32_PNG,
  SharpApi,
  ExtCtrls,
  JclStrings,
  GR32_Image,
  Types,
  PngImageList;

type
  TMenuDataObject = class
  public
    ID: Integer;
      Name: string;
    FileName: string;
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
    procedure SelectMenuItem(AName: string);
  public
    procedure Save(AName: string; ATemplate: string);
    procedure CopyMenu(AName: string; var ANew: String);
    procedure RenderItems;

    procedure EditMenu( name: string);
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

uses SharpThemeApi,
  SharpCenterApi,
  SharpIconUtils,
  uEditWnd;

{$R *.dfm}

procedure TfrmList.SelectMenuItem(AName: string);
var
  i: Integer;
  tmpScheme: TMenuDataObject;
begin
  for i := 0 to Pred(lbItems.Count) do begin
    tmpScheme := TMenuDataObject(lbItems.Item[i].Data);
    if CompareText(AName, tmpScheme.Name) = 0 then begin
      lbItems.ItemIndex := i;
      break;
    end;
  end;
end;

procedure TfrmList.AddItemsToList(AList: TObjectList);
var
  xml: TJvSimpleXML;
  newItem: TMenuDataObject;
  dir: string;
  slMenus: TStringList;
  i: Integer;

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
        newItem := TMenuDataObject.Create;
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

procedure TfrmList.CopyMenu(AName: string; var ANew: String);
var
  sCopyName, sDestFile, sSrcFile: string;
  n: integer;
  n2: Integer;
  s, sFileName: string;
  sMenuDir: string;
begin
  sCopyName := AName;
  sMenuDir := GetSharpeUserSettingsPath + 'SharpMenu\';

  // If already copy, remove copy symbol
  n := pos(')',sCopyName);
  if n <> 0 then begin

    n2 := n;
    repeat
      s := sCopyName[n2];
      n2 := n2 - 1;
    until ((n2 <= 1) or (s = '(')) ;

    if n2 > 1 then
      sCopyName := System.Copy(sCopyName,1,n2-1);
  end;

  n := 0;
  s := sCopyName;
  repeat
    s := format('%s (%d)',[sCopyName,n]);
    sFilename := sMenuDir + s + '.xml';
    inc(n);
  until not (fileExists(sFilename));
  sCopyName := s;

  ANew := s;
  sSrcFile := sMenuDir + AName + '.xml';
  sDestFile := sMenuDir + sCopyName + '.xml';
  FileCopy(sSrcFile,sDestFile,false);


end;

procedure TfrmList.EditMenu(name: string);
begin
  CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
          + '\_Components\MenuEdit.con'), pchar(name));
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
  tmpMenu: TMenuDataObject;
  bDelete: Boolean;
  sNew: String;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin

  tmpMenu := TMenuDataObject(AItem.Data);
  if tmpMenu = nil then
    exit;

  case ACol of
    colEdit: begin
        EditMenu(tmpMenu.Name);
      end;
    colDelete: begin

        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmpMenu.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin
          DeleteFile(tmpMenu.FileName);
          RenderItems;
        end;

      end;
    colCopy: begin
      CopyMenu(tmpMenu.Name, sNew);
      RenderItems;
      SelectMenuItem(sNew);
    end;
  end;

  if frmEdit <> nil then
    frmEdit.InitUi(frmEdit.EditMode);

  CenterUpdateEditTabs(lbItems.Count, lbItems.ItemIndex);
  CenterUpdateConfigFull;
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
  tmpMenu: TMenuDataObject;
begin

  tmpMenu := TMenuDataObject(AItem.Data);
  if tmpMenu = nil then
    exit;

  case ACol of
    colCopy: AImageIndex := iidxCopy;
    colDelete: AImageIndex := iidxDelete;
  end;

end;

procedure TfrmList.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpMenu: TMenuDataObject;
begin

  tmpMenu := TMenuDataObject(AItem.Data);
  if tmpMenu = nil then
    exit;

  case ACol of
    colName: AColText := tmpMenu.Name;
    colEdit: AColText := '<font color="clNavy"><u>Edit</u>';
  end;
end;

procedure TfrmList.lbItemsResize(Sender: TObject);
begin
  Self.Height := lbItems.Height;
end;

procedure TfrmList.RenderItems;
var
  newItem: TSharpEListItem;
  selectedIndex, i: Integer;
  tmpMenu: TMenuDataObject;
begin

  // Get selected item
  LockWindowUpdate(Self.Handle);
  try
    if lbItems.ItemIndex <> -1 then
      selectedIndex := TMenuDataObject(lbItems.Item[lbItems.ItemIndex].Data).ID
    else
      selectedIndex := -1;

    lbItems.Clear;
    AddItemsToList(FItems);

    for i := 0 to FItems.Count - 1 do begin

      tmpMenu := TMenuDataObject(FItems.Items[i]);

      newItem := lbItems.AddItem(tmpMenu.Name);
      newItem.Data := tmpMenu;
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');

      if tmpMenu.ID = selectedIndex then
        lbItems.ItemIndex := i;

    end;
  finally
    LockWindowUpdate(0);
  end;

  if lbItems.ItemIndex = -1 then
    lbItems.ItemIndex := 0;

  CenterUpdateEditTabs(lbItems.Count, lbItems.ItemIndex);
  CenterUpdateConfigFull;

end;

procedure TfrmList.Save(AName: string; ATemplate: string);
var
  xml: TJvSimpleXML;
  sFileName: string;
  sMenuDir: string;
  sSrc, sDest: string;
begin
  // Check template
  sMenuDir := GetSharpeUserSettingsPath + 'SharpMenu\';
  if ATemplate <> '' then begin
    sSrc := sMenuDir + ATemplate + '.xml';
    sDest := sMenuDir + AName + '.xml';

    FileCopy(sSrc, sDest, False);
  end
  else begin

    xml := TJvSimpleXML.Create(nil);
    try
      xml.Root.Name := 'SharpEMenuFile';
    finally

      sFileName := sMenuDir + trim(StrRemoveChars(AName,
        ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']) + '.xml');

      xml.SaveToFile(sFileName);
      xml.Free;
    end;
  end;
end;

end.

