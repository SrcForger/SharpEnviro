﻿{
Source Name: uListWnd.pas
Description: Filter List Window
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
  PngImageList,
  SWCmdList, TaskFilterList;

type
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
    FFilterItemList: TFilterItemList;
    procedure SelectFilterItem(AName: string);
  public
    property FilterItemList: TFilterItemList read FFilterItemList write
      FFilterItemList;
    procedure RenderItems;
    procedure Save;
  end;

var
  frmList: TfrmList;

const
  colName = 0;
  colCopy = 1;
  colDelete = 2;

  iidxCopy = 5;
  iidxDelete = 6;

implementation

uses SharpThemeApi,
  SharpCenterApi,
  SharpIconUtils,
  uEditWnd;

{$R *.dfm}

procedure TfrmList.Save;
begin
  FFilterItemList.Save;
end;

procedure TfrmList.SelectFilterItem(AName: string);
var
  i: Integer;
  tmpFilter: TFilterItem;
begin
  for i := 0 to Pred(lbItems.Count) do begin
    tmpFilter := TFilterItem(lbItems.Item[i].Data);
    if CompareText(AName, tmpFilter.Name) = 0 then begin
      lbItems.ItemIndex := i;
      break;
    end;
  end;
end;

procedure TfrmList.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;

  FFilterItemList := TFilterItemList.Create;
  RenderItems;
end;

procedure TfrmList.FormDestroy(Sender: TObject);
begin
  FFilterItemList.Free;
end;

procedure TfrmList.lbItemsClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmpFilter, tmpCopyFilter: TFilterItem;
  bDelete: Boolean;
  sNew: String;
  sCopy: String;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin

  tmpFilter := TFilterItem(AItem.Data);
  if tmpFilter = nil then
    exit;

  case ACol of
    colDelete: begin

        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmpFilter.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin
          FFilterItemList.Delete(tmpFilter);

          FilterItemList.Save;
          RenderItems;
          CenterDefineSettingsChanged;
        end;

      end;
    colCopy: begin
        sCopy := 'Copy of ' + tmpFilter.Name;
        tmpCopyFilter := TFilterItem.Create;
        tmpCopyFilter.Assign(tmpFilter);
        tmpCopyFilter.Name := sCopy;
        FilterItemList.AddItem(tmpCopyFilter);

        FilterItemList.Save;
        RenderItems;
        CenterDefineSettingsChanged;
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
  tmpMenu: TFilterItem;
begin

  tmpMenu := TFilterItem(AItem.Data);
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
  tmpMenu: TFilterItem;
begin

  tmpMenu := TFilterItem(AItem.Data);
  if tmpMenu = nil then
    exit;

  case ACol of
    colName: AColText := tmpMenu.Name;
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
  tmpFilter: TFilterItem;
begin
  if lbItems.ItemIndex <> -1 then
      selectedIndex := TFilterItem(lbItems.Item[lbItems.ItemIndex].Data).Id
    else
      selectedIndex := -1;

  FFilterItemList.Load;

  // Get selected item
  LockWindowUpdate(Self.Handle);
  try
    lbItems.Clear;

    for i := 0 to FFilterItemList.Count - 1 do begin

      tmpFilter := TFilterItem(FFilterItemList[i]);

      newItem := lbItems.AddItem(tmpFilter.Name);
      newItem.Data := tmpFilter;
      newItem.AddSubItem('');
      newItem.AddSubItem('');

      if tmpFilter.Id = selectedIndex then
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

end.

