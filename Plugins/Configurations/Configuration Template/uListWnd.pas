{
Source Name: uListWnd.pas
Description: <Type> List Window
Copyright (C) <Author> (<Email>)

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
  Contnrs,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ImgList,
  PngImageList,

  SharpEListBoxEx;

type
  TItemData = class
  private
    FName: String;
    FId: Integer;
  public
    property Name: String read FName write FName;
    property Id: Integer read FId write FId;
    constructor Create(AName: String; AId: Integer);
  end;

  TfrmList = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilListBox: TPngImageList;
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
  public
    procedure RenderItems;
  end;

var
  frmList: TfrmList;

const
  colName = 0;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmList.AddItemsToList(AList: TObjectList);
begin
  // Add Items to list here
  AList.Clear;
  AList.Add(TItemData.Create('Item1',AList.Count));
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
  tmpItemData: TItemData;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin

  tmpItemData := TItemData(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colName: //Click Event;
  end;

  CenterUpdateConfigFull;
end;

procedure TfrmList.lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol = 0 then
    ACursor := crHandPoint;
end;

procedure TfrmList.lbItemsGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
var
  tmpItemData: TItemData;
begin

  tmpItemData := TItemData(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colName: ;
  end;

end;

procedure TfrmList.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmpItemData: TItemData;
begin

  tmpItemData := TItemData(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colName: AColText := tmpItemData.Name;
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
  tmpItemData: TItemData;
begin

  LockWindowUpdate(Self.Handle);
  try
    if lbItems.ItemIndex <> -1 then
      selectedIndex := TItemData(lbItems.Item[lbItems.ItemIndex].Data).Id
    else
      selectedIndex := -1;

    lbItems.Clear;
    AddItemsToList(FItems);

    for i := 0 to FItems.Count - 1 do begin

      tmpItemData := TItemData(FItems.Items[i]);

      newItem := lbItems.AddItem(tmpItemData.Name);
      newItem.Data := tmpItemData;

      if tmpItemData.Id = selectedIndex then
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

{ TItemData }

constructor TItemData.Create(AName: String; AId: Integer);
begin
  FName := AName;
  FId := AId;
end;

end.

