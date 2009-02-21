{
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
  PngImageList,
  ISharpCenterHostUnit;

type
  TMenuDataObject = class
  public
    ID: Integer;
      Name: string;
    FileName: string;
    Items: integer;

    OverrideOptions: Boolean;
    EnableIcons: Boolean;
    EnableGeneric: Boolean;
    DisplayExtensions: Boolean;
  end;

  TfrmList = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilDefault: TPngImageList;
    procedure lbItemsResize(Sender: TObject);
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
    procedure FormShow(Sender: TObject);
    procedure lbItemsGetCellClickable(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AClickable: Boolean);
    procedure lbItemsDblClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
  private
    FItems: TObjectList;
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure AddItemsToList(AList: TObjectList);
    procedure SelectMenuItem(AName: string);
  public
    function Save(AName: string; ATemplate: string): string;
    procedure CopyMenu(AName: string; var ANew: string);
    procedure RenderItems;

    procedure SaveMenuOptions(fileName: string; menuItem: TMenuDataObject); overload;
    procedure SaveMenuOptions(fileName: string; OverrideOptions: Boolean;
      EnableIcons: Boolean; EnableGeneric: Boolean; DisplayExtensions: Boolean); overload;

    procedure EditMenu(name: string);
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost; end;

var
  frmList: TfrmList;

const
  colName = 0;
  colEdit = 1;
  colCopy = 2;
  colDelete = 3;

  iidxCopy = 0;
  iidxDelete = 1;

implementation

uses
  SharpFileUtils,
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
  xml: TJclSimpleXML;
  elemSettings: TJclSimpleXMLElem;
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
  xml := TJclSimpleXML.Create;
  try

    // build list of bar.xml files
    SharpFileUtils.FindFiles(slMenus, dir, '*.xml', False);
    for i := 0 to Pred(slMenus.Count) do begin
      xml.LoadFromFile(slMenus[i]);
      if xml.Root.Name = 'SharpEMenuFile' then begin
        newItem := TMenuDataObject.Create;
        newItem.ID := i;
        newItem.Name := PathRemoveExtension(ExtractFileName(slMenus[i]));
        newItem.FileName := slMenus[i];
        newItem.Items := xml.Root.Items.Count;

        // menu options
        if xml.Root.Items.ItemNamed['settings'] <> nil then begin

          elemSettings := xml.Root.Items.ItemNamed['settings'];
          newItem.OverrideOptions := true;
          newItem.EnableIcons := elemSettings.Items.BoolValue('UseIcons', false);
          newItem.EnableGeneric := elemSettings.Items.BoolValue('UseGenericIcons', false);
          newItem.DisplayExtensions := elemSettings.Items.BoolValue('ShowExtensions', false);
          newItem.Items := xml.root.Items.Count - 1;
        end;

        AList.Add(newItem);
      end;
    end;

  finally
    slMenus.Free;
    xml.Free;
  end;
end;

procedure TfrmList.CopyMenu(AName: string; var ANew: string);
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
  n := pos(')', sCopyName);
  if n <> 0 then begin

    n2 := n;
    repeat
      s := sCopyName[n2];
      n2 := n2 - 1;
    until ((n2 <= 1) or (s = '('));

    if n2 > 1 then
      sCopyName := System.Copy(sCopyName, 1, n2 - 1);
  end;

  n := 0;
  s := sCopyName;
  repeat
    s := format('%s (%d)', [sCopyName, n]);
    sFilename := sMenuDir + s + '.xml';
    inc(n);
  until not (fileExists(sFilename));
  sCopyName := s;

  ANew := s;
  sSrcFile := sMenuDir + AName + '.xml';
  sDestFile := sMenuDir + sCopyName + '.xml';
  FileCopy(sSrcFile, sDestFile, false);

end;

procedure TfrmList.EditMenu(name: string);
begin
  CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
    + '\_Components\MenuEdit.con'), pchar(name));
end;

procedure TfrmList.FormDestroy(Sender: TObject);
begin
  FItems.Free;
end;

procedure TfrmList.FormShow(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;

  FItems := TObjectList.Create;
  RenderItems;
end;

procedure TfrmList.lbItemsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpMenu: TMenuDataObject;
  bDelete: Boolean;
  sNew: string;

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
    frmEdit.InitUi;

  PluginHost.SetEditTabsVisibility(lbItems.ItemIndex, lbItems.Count);
  PluginHost.Refresh(rtAll);
end;

procedure TfrmList.lbItemsDblClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpMenu: TMenuDataObject;
begin

  tmpMenu := TMenuDataObject(AItem.Data);
  if tmpMenu = nil then
    exit;

  EditMenu(tmpMenu.Name);
end;

procedure TfrmList.lbItemsGetCellClickable(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AClickable: Boolean);
begin
  if (ACol > 0) then
    AClickable := true;
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
    0: AImageIndex := 2;
    colCopy: AImageIndex := iidxCopy;
    colDelete: AImageIndex := iidxDelete;
  end;

end;

procedure TfrmList.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpMenu: TMenuDataObject;
  s, s2: string;

  colItemTxt: TColor;
  colDescTxt: TColor;
  colBtnTxt: TColor;
begin

  tmpMenu := TMenuDataObject(AItem.Data);
  if tmpMenu = nil then exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  case ACol of
    colName: begin

        s := tmpMenu.Name;
        if s = '' then s := '*Untitled';

        if tmpMenu.Items = 0 then
          s2 := 'Empty' else
          if tmpMenu.Items = 1 then
            s2 := IntToStr(tmpMenu.Items) + ' Menu Item'
          else
            s2 := IntToStr(tmpMenu.Items) + ' Menu Items';

        AColText := format('<font color="%s">%s<font color="%s"> - %s', [ColorToString(colItemTxt), s,
          ColorToString(colDescTxt), s2]);
      end;

    colEdit: begin
        AColText := format('<font color="%s"><u>Edit</u>', [ColorToString(colBtnTxt), s]);
      end;
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

  if PluginHost <> nil then begin
    PluginHost.SetEditTabsVisibility(lbItems.ItemIndex, lbItems.Count);
    PluginHost.Refresh(rtAll);
  end;

end;

function TfrmList.Save(AName: string; ATemplate: string): string;
var
  xml: TJclSimpleXML;
  sFileName: string;
  sMenuDir: string;
  sSrc, sDest: string;
begin
  // Check template
  sMenuDir := GetSharpeUserSettingsPath + 'SharpMenu\';

  if not DirectoryExists(sMenuDir) then
    ForceDirectories(sMenuDir);

  if ATemplate <> '' then begin
    sSrc := sMenuDir + ATemplate + '.xml';
    sDest := sMenuDir + AName + '.xml';

    FileCopy(sSrc, sDest, False);
    result := sDest;
  end
  else begin

    xml := TJclSimpleXML.Create;
    try
      xml.Root.Name := 'SharpEMenuFile';
    finally
      sFileName := sMenuDir + trim(StrRemoveChars(AName,
        ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']) + '.xml');

      xml.SaveToFile(sFileName);
      xml.Free;

      result := sFileName;
    end;
  end;
end;

procedure TfrmList.SaveMenuOptions(fileName: string; OverrideOptions,
  EnableIcons, EnableGeneric, DisplayExtensions: Boolean);
var
  tmp: TMenuDataObject;
begin
  tmp := TMenuDataObject.Create;
  try
    tmp.OverrideOptions := OverrideOptions;
    tmp.EnableIcons := EnableIcons;
    tmp.EnableGeneric := EnableGeneric;
    tmp.DisplayExtensions := DisplayExtensions;

    SaveMenuOptions(fileName, tmp);
  finally
    tmp.Free;
  end;
end;

procedure TfrmList.SaveMenuOptions(fileName: string; menuItem: TMenuDataObject);
var
  xml: TJclSimpleXML;
  elemSettings: TJclSimpleXMLElem;
  bSave: boolean;
begin
  bSave := false;
  xml := TJclSimpleXML.Create;
  try
    xml.LoadFromFile(fileName);

    if xml.Root.Items.ItemNamed['settings'] <> nil then begin
      elemSettings := xml.Root.Items.ItemNamed['settings'];

      // Delete section if custom settings is false and exit
      if not (menuItem.OverrideOptions) then begin

        if (xml.Root.Items.IndexOf(elemSettings) <> -1) then
          xml.Root.Items.Delete(xml.Root.Items.IndexOf(elemSettings));
        bSave := true;
      end else begin

        if elemSettings.Items.ItemNamed['UseIcons'] <> nil then
          elemSettings.Items.ItemNamed['UseIcons'].BoolValue := menuItem.EnableIcons else
          elemSettings.Items.Add('UseIcons', menuItem.EnableIcons);

        if elemSettings.Items.ItemNamed['UseGenericIcons'] <> nil then
          elemSettings.Items.ItemNamed['UseGenericIcons'].BoolValue := menuItem.EnableGeneric else
          elemSettings.Items.Add('UseGenericIcons', menuItem.EnableGeneric);

        if elemSettings.Items.ItemNamed['ShowExtensions'] <> nil then
          elemSettings.Items.ItemNamed['ShowExtensions'].BoolValue := menuItem.DisplayExtensions else
          elemSettings.Items.Add('ShowExtensions', menuItem.DisplayExtensions);

        bSave := true;
      end;
    end else begin
      if (menuItem.OverrideOptions) then begin
        elemSettings := xml.Root.Items.Add('settings');
        elemSettings.Items.Add('UseIcons', menuItem.EnableIcons);
        elemSettings.Items.Add('UseGenericIcons', menuItem.EnableGeneric);
        elemSettings.Items.Add('ShowExtensions', menuItem.DisplayExtensions);

        bSave := true;
      end;

    end;
  finally
    if bSave then
      xml.SaveToFile(fileName);

    xml.Free;
  end;
end;

end.

