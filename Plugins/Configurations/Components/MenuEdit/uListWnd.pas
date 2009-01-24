{
Source Name: uListWnd.pas
Description: List Window
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
  ShellApi,
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
  PngImageList,
  uSharpEMenu,
  uSharpEMenuIcons,
  uSharpEMenuLoader,
  uSharpEMenuSaver,
  uSharpEMenuItem,
  SharpESkinManager,

  ISharpCenterHostUnit;

type

  // Class to hold the list item data
  TItemData = class
    MenuItem: TSharpEMenuItem;
    IsParent: Boolean;
    IconIndex: Integer;
    function GetCaption: string;
  private

  end;

  TfrmList = class(TForm)
    lbItems: TSharpEListBoxEx;
    smMain: TSharpESkinManager;
    pilIcons: TPngImageList;
    pilDefault: TPngImageList;
    tmrUpdatePosition: TTimer;

    procedure lbItemsResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lbItemsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbItemsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbItemsDblClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbItemsDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lbItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure lbItemsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbItemsGetCellClickable(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AClickable: Boolean);
    procedure OnUpdatePosition(Sender: TObject);
  private
    FMenuFile: string;
    FMenu: TSharpEMenu;
    FPluginHost: TInterfacedSharpCenterHostBase;

    procedure RenderItemsBuffered(AMenu: TSharpEMenu; AClear: Boolean = True;
      AParent: Boolean = False);
    procedure LoadMenu;
    procedure EditSubFolder(tmp: TItemData; const ACol: Integer);

  public
    property MenuFile: string read FMenuFile write FMenuFile;
    property Menu: TSharpEMenu read FMenu write FMenu;

    function IsParentMenu: Boolean;
    procedure RenderItems(AMenu: TSharpEMenu; AClear: Boolean = True;
      AParent: Boolean = False);

    procedure Save;
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
  end;

var
  frmList: TfrmList;

const
  colName = 0;
  colEdit = 1;
  colDelete = 2;

  iidxCopy = 0;
  iidxDelete = 1;
  iidxFolder = 2;
  iidxParentFolder = 3;
  iidxDrives = 4;
  iidxText = 5;
  iidxMoveUp = 6;
  iidxMoveDown = 7;
  iidxObjects = 8;
  iidxCplList = 9;
  iidxMruList = 10;
  iidxDynamicFolder = 11;
  iidxLink = 12;

implementation

uses 
  SharpCenterApi,
  SharpIconUtils,
  uEditWnd;

{$R *.dfm}

function CtrlDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128) <> 0);
end;

procedure TfrmList.FormCreate(Sender: TObject);
begin
  nMenuItemIndex := 0;
  nInsertIndex := 0;

  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;
end;

procedure TfrmList.FormShow(Sender: TObject);
begin
  LoadMenu;
end;

function TfrmList.IsParentMenu: Boolean;
begin
  Result := False;
  if lbItems.Count > 0 then
    if TItemData(lbItems.Item[0].Data).IsParent then
      Result := True;
end;

procedure TfrmList.lbItemsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TItemData;
  tmpMenu: TSharpEMenu;
  bDelete: Boolean;
begin
  tmp := TItemData(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    0: begin
        if tmp.IsParent then
          EditSubFolder(tmp, colName);
      end;
    colEdit: begin
        EditSubFolder(tmp, colName);
      end;
    colDelete: begin

        if lbItems.SelectedItem <> AItem then exit;

        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s item?', [tmp.GetCaption]),
            mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin

          tmpMenu := TSharpEMenu(tmp.MenuItem.OwnerMenu);
          tmpMenu.Items.Extract(tmp.MenuItem);

          if IsParentMenu then
            RenderItemsBuffered(TSharpEMenu(tmp.MenuItem.OwnerMenu), True, True)
          else
            RenderItemsBuffered(TSharpEMenu(tmp.MenuItem.OwnerMenu));

          Save;
        end;
        Abort;
      end;
  end;

  if (frmEdit <> nil) then
    frmEdit.InitUi;

  PluginHost.SetEditTabsVisibility(lbItems.ItemIndex, lbItems.Count);
  PluginHost.Refresh(rtAll);

end;

procedure TfrmList.lbItemsDblClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp: TItemData;
begin

  tmp := TItemData(AItem.Data);
  if tmp = nil then
    exit;

  EditSubFolder(tmp, ACol);
end;

procedure TfrmList.lbItemsDragDrop(Sender, Source: TObject; X, Y: Integer);
begin

  // if Ctrl down then move item into sub menu
  if CtrlDown then
    OnUpdatePosition(nil);

  tmrUpdatePosition.Enabled := False;

  PluginHost.SetEditTabsVisibility(lbItems.ItemIndex, lbItems.Count);
  PluginHost.Refresh(rtAll);
  Save;
end;

procedure TfrmList.lbItemsDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  n: Integer;
begin
  n := lbItems.ItemAtPos(point(x, y), True);
  if ((n <> -1) and (lbItems.ItemIndex <> -1) and (n <> lbItems.ItemIndex)) then begin
    Accept := True;

    // If Ctrl is not pressed, we are simply repositioning
    if not (CtrlDown) then
      tmrUpdatePosition.Enabled := True;
  end;
end;

procedure TfrmList.lbItemsGetCellClickable(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AClickable: Boolean);
var
  tmp: TItemData;
begin

  tmp := TItemData(AItem.Data);
  if tmp = nil then
    exit;

  if (ACol > 0) then
    AClickable := true;

  if tmp.IsParent then
    AClickable := False;
end;

procedure TfrmList.lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
var
  tmp: TItemData;
begin

  tmp := TItemData(AItem.Data);
  if tmp = nil then
    exit;

  if (tmp.IsParent) and (ACol <> 1) then
    ACursor := crHandPoint;

  if (ACol = 1) and (tmp.MenuItem.ItemType = mtSubMenu) then
    ACursor := crHandPoint;

  if (ACol = 2) then
    ACursor := crHandPoint;
end;

procedure TfrmList.lbItemsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmp: TItemData;
begin

  tmp := TItemData(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colName: AImageIndex := tmp.IconIndex;
    colDelete: begin
        if not (tmp.IsParent) and (AItem = lbItems.SelectedItem) then
          AImageIndex := iidxDelete;
      end;
  end;
end;

procedure TfrmList.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TItemData;
  n: integer;
  s: string;
  colItemTxt: TColor;
  colDescTxt: TColor;
  colBtnTxt: TColor;
begin

  tmp := TItemData(AItem.Data);
  if tmp = nil then exit;

  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  case ACol of
    colEdit: begin

        if tmp.MenuItem.ItemType = mtSubMenu then
          AColText := Format('<u><font color="%s">Edit', [colortostring(colBtnTxt)]);

        if tmp.IsParent then
          AColText := Format('<u><font color="%s">Back', [colortostring(colBtnTxt)]);
      end;
    colName: begin

        if tmp.IsParent then
          AColText := 'Previous Menu'
        else begin
          case tmp.MenuItem.ItemType of

            mtSeparator: AColText := Format('<font color="%s">--------------------------------------------------------------------------------------------------------------------------',
                [colortostring(colItemTxt), colortostring(colDescTxt)]);

            mtDynamicDir: AColText := Format('<font color="%s">%s',
                [colortostring(colItemTxt), tmp.MenuItem.PropList.GetString('Action')]);

            mtDriveList: AColText := Format('<font color="%s">Drive List',
                [colortostring(colItemTxt)]);

            mtSubMenu: begin

                n := TSharpEMenu(tmp.MenuItem.SubMenu).Items.Count;
                if n = 0 then
                  s := 'Empty' else
                  if n = 1 then
                    s := IntToStr(n) + ' Menu Item'
                  else
                    s := IntToStr(n) + ' Menu Items';

                AColText := format('<font color="%s">%s<font color="%s"> - %s</font>',
                  [colortostring(colItemTxt), tmp.MenuItem.Caption, colortostring(colDescTxt), s]);
              end;
            mtLink: AColText := format('<font color="%s">%s.link',
                [colortostring(colItemTxt), tmp.MenuItem.Caption]);

            mtLabel: AColText := format('<font color="%s">%s',
                [colortostring(colItemTxt), tmp.MenuItem.Caption]);

            mtDesktopObjectList: AColText := format('<font color="%s">Desktop Objects',
                [colortostring(colItemTxt)]);

            mtCPLList: AColText := format('<font color="%s">Control Panel Items',
                [colortostring(colItemTxt)]);

            mtulist: begin

                n := tmp.MenuItem.PropList.GetInt('ItemType');
                if n = 0 then s := 'Mru - Recent Items' else
                  s := 'Mru - Most Used Items';

                AColText := Format('<font color="%s">%s',
                  [colortostring(colItemTxt), s]);
              end;

          end;
        end;
      end;
  end;
end;

procedure TfrmList.lbItemsResize(Sender: TObject);
begin
  Self.Height := lbItems.Height;
end;

procedure TfrmList.LoadMenu;
begin
  SharpEMenuIcons := TSharpEMenuIcons.Create;
  FMenu := uSharpEMenuLoader.LoadMenu(FMenuFile, smMain, True);

  RenderItemsBuffered(FMenu);
end;

procedure TfrmList.RenderItems(AMenu: TSharpEMenu; AClear: Boolean = True;
  AParent: Boolean = False);
var
  i, n: Integer;
  tmpData: TItemData;
  tmpMenu: TSharpEMenu;
  newItem: TSharpEListItem;
  png: TPngImageCollectionItem;
  bmp, bmpResized: TBitmap32;
  pt: TPoint;
begin

  if AClear then begin
    lbItems.Clear;
    pilIcons.PngImages.Clear;
  end;

  tmpMenu := AMenu;

  // Add the parent folder
  if ((FMenu <> tmpMenu) and (AParent)) then begin
    tmpData := TItemData.Create;
    tmpData.IsParent := True;
    tmpData.MenuItem := tmpMenu.ParentMenuItem;

    newItem := lbItems.AddItem('Parent');
    newItem.Data := tmpData;
    newItem.AddSubItem('');
    newItem.AddSubItem('');

    png := pilIcons.PngImages.Add(false);
    png.PngImage := pilDefault.PngImages[iidxParentFolder].PngImage;
    tmpData.IconIndex := png.Index;
  end;

  for i := 0 to Pred(tmpMenu.Items.Count) do begin

    tmpData := TItemData.Create;
    tmpData.IconIndex := -1;
    tmpData.MenuItem := TSharpEMenuItem(tmpMenu.Items[i]);

    if Assigned(tmpData.MenuItem.Icon) then begin
      png := pilIcons.PngImages.Add(false);
      bmp := tmpData.MenuItem.Icon.Icon;

      if ((bmp.width <> 16) or (bmp.height <> 16)) then begin
        bmpResized := TBitmap32.Create;
        bmpResized.assign(bmp);
        bmp.setsize(16, 16);
        bmp.clear(color32(0, 0, 0, 0));
        bmpResized.DrawTo(bmp, Rect(0, 0, 16, 16));
        bmpResized.free;
      end;

      png.PngImage := SaveBitmap32ToPNG(bmp, False, True, ClWhite);
      tmpData.IconIndex := png.Index;
    end;

    case tmpData.MenuItem.ItemType of
      mtDynamicDir: begin
          png := pilIcons.PngImages.Add(false);
          png.PngImage := pilDefault.PngImages[iidxDynamicFolder].PngImage;
          tmpData.IconIndex := png.Index;
        end;
      mtDriveList: begin
          png := pilIcons.PngImages.Add(false);
          png.PngImage := pilDefault.PngImages[iidxDrives].PngImage;
          tmpData.IconIndex := png.Index;
        end;
      mtLabel: begin
          png := pilIcons.PngImages.Add(false);
          png.PngImage := pilDefault.PngImages[iidxText].PngImage;
          tmpData.IconIndex := png.Index;
        end;
      mtDesktopObjectList: begin
          png := pilIcons.PngImages.Add(false);
          png.PngImage := pilDefault.PngImages[iidxObjects].PngImage;
          tmpData.IconIndex := png.Index;
        end;
      mtCPLList: begin
          png := pilIcons.PngImages.Add(false);
          png.PngImage := pilDefault.PngImages[iidxCplList].PngImage;
          tmpData.IconIndex := png.Index;
        end;
      mtLink: begin
          png := pilIcons.PngImages.Add(false);
          png.PngImage := pilDefault.PngImages[iidxlink].PngImage;
          tmpData.IconIndex := png.Index;
        end;
      mtSubMenu: begin
          if ((tmpData.MenuItem.Icon = nil) or (tmpData.MenuItem.Icon.IconSource = '')) then begin
            png := pilIcons.PngImages.Add(false);
            png.PngImage := pilDefault.PngImages[iidxFolder].PngImage;
            tmpData.IconIndex := png.Index;
          end;
        end;
      mtulist: begin
          png := pilIcons.PngImages.Add(false);
          png.PngImage := pilDefault.PngImages[iidxMruList].PngImage;
          tmpData.IconIndex := png.Index;
        end;
    end;

    newItem := lbItems.AddItem(tmpData.MenuItem.Caption);
    newItem.Data := tmpData;
    newItem.AddSubItem('');
    newItem.AddSubItem('');
  end;

  if lbItems.ItemIndex = -1 then
    if lbItems.Items.Count > 0 then begin
      if IsParentMenu then
        lbItems.ItemIndex := -1
      else begin

        pt := lbItems.ScreenToClient(Mouse.CursorPos);
        n := lbItems.ItemAtPos(point(pt.x, pt.y), True);
        if n <> -1 then

          lbItems.ItemIndex := n else
          lbItems.ItemIndex := 0;
      end;
    end;

  //PluginHost.SetEditTabsVisibility(lbItems.ItemIndex, lbItems.Count);
  PluginHost.Refresh;
end;

procedure TfrmList.RenderItemsBuffered(AMenu: TSharpEMenu; AClear,
  AParent: Boolean);
begin
  LockWindowUpdate(Self.Handle);
  try
    RenderItems(AMenu, AClear, AParent);
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmList.Save;
begin
  SaveMenu(Menu, MenuFile);
end;

procedure TfrmList.OnUpdatePosition(Sender: TObject);
var
  pt: TPoint;
  n, nTo: Integer;
  tmp: TSharpEListItem;
  tmpDest, tmpSrc: TItemData;
  tmpSrcMenu: TSharpEMenu;
  i: Integer;
begin
  pt := lbItems.ScreenToClient(Mouse.CursorPos);
  tmrUpdatePosition.Enabled := False;

  n := lbItems.ItemAtPos(point(pt.x, pt.y), True);
  if ((n <> -1) and (lbItems.ItemIndex <> -1) and (n <> lbItems.ItemIndex)) then begin

    tmp := TSharpEListItem(lbItems.Items.Objects[n]);
    tmpDest := TItemData(tmp.Data);

    tmp := TSharpEListItem(lbItems.Items.Objects[lbItems.ItemIndex]);
    tmpSrc := TItemData(tmp.Data);
    tmpSrcMenu := TSharpEMenu(tmpSrc.MenuItem.OwnerMenu);

    // Not possible to move the parent item
    if (tmpSrc.IsParent) then
      exit;

    if (tmpDest.IsParent) and not (CtrlDown) then
      exit;

    if ((tmpDest.MenuItem.ItemType = mtSubMenu) and (CtrlDown)) then begin

      if tmpDest.IsParent then
        tmpSrc.MenuItem.MoveToMenu(tmpDest.MenuItem.OwnerMenu)
      else
        tmpSrc.MenuItem.MoveToMenu(tmpDest.MenuItem.SubMenu);

      lbItems.DeleteItem(lbItems.ItemIndex);

      for i := 0 to Pred(lbItems.Count) do begin
        if TItemData(lbItems.Item[i].Data).MenuItem = tmpDest.MenuItem then begin
          if not (tmpDest.IsParent) then
            lbItems.ItemIndex := i;

          break;
        end;
      end;

    end
    else begin

      nTo := TSharpEMenu(tmpDest.MenuItem.OwnerMenu).Items.IndexOf(tmpDest.MenuItem);
      tmpSrc.MenuItem.MoveToMenu(TSharpEMenu(tmpDest.MenuItem.OwnerMenu), nTo);

      if IsParentMenu then
        RenderItemsBuffered(tmpSrcMenu, True, True)
      else
        lbItems.Items.Exchange(nTo, n);

      for i := 0 to Pred(lbItems.Count) do begin
        if TItemData(lbItems.Item[i].Data).MenuItem = tmpSrc.MenuItem then begin
          lbItems.ItemIndex := i;
          break;
        end;
      end;

    end;
  end;
end;

function TItemData.GetCaption: string;
begin
  case MenuItem.ItemType of
    mtLink: Result := Self.MenuItem.Caption;
    mtSubMenu: Result := Self.MenuItem.Caption;
    mtSeparator: Result := 'seperator';
    mtDynamicDir: Result := Self.MenuItem.PropList.GetString('action');
    mtDriveList: Result := 'drive list';
    mtLabel: Result := Self.MenuItem.Caption;
    mtCPLList: Result := 'control panel list';
    mtDesktopObjectList: Result := 'desktop object list';
    mtulist: Result := 'mru list';
  end;
end;

procedure TfrmList.EditSubFolder(tmp: TItemData; const ACol: Integer);
begin
  case ACol of
    colName:
      begin
        if tmp.IsParent then
        begin
          if tmp.MenuItem.OwnerMenu <> nil then
            RenderItemsBuffered(TSharpEMenu(tmp.MenuItem.OwnerMenu), True, True);
          PluginHost.SetEditTab(scbAddTab);
        end
        else
        begin
          case tmp.MenuItem.ItemType of
            mtSubMenu:
              begin
                RenderItemsBuffered(TSharpEMenu(tmp.MenuItem.SubMenu), True, True);
                PluginHost.SetEditTab(scbAddTab);
              end;
          end;
        end;
      end;
  end;
end;

end.

