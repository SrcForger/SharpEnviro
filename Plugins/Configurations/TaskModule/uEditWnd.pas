{
Source Name: uEditWnd.pas
Description: Options Window
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

unit uEditWnd;

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
  StdCtrls,
  ImgList,
  PngImageList,
  SharpTypes,
  SharpEListBoxEx, TaskFilterList, ExtCtrls, JclSimpleXml, JclStrings,
  ISharpCenterHostUnit, SharpThemeApi, SharpCenterApi, SharpESkin,
  SharpECenterHeader, JvExControls, JvXPCore, JvXPCheckCtrls;

type
  TItemData = class
  private
    FName: string;
    FId: Integer;
  public
    property Name: string read FName write FName;
    property Id: Integer read FId write FId;
    constructor Create(AName: string; AId: Integer);
  end;

  TfrmEdit = class(TForm)
    lbItems: TSharpEListBoxEx;
    pilListBox: TPngImageList;
    pnlOptions: TPanel;
    pnlStyleAndSort: TPanel;
    pnlButtons: TPanel;
    cbStyle: TComboBox;
    lblSort: TLabel;
    lblStyle: TLabel;
    cbSortMode: TComboBox;
    schTaskOptions: TSharpECenterHeader;
    schButtons: TSharpECenterHeader;
    schFilters: TSharpECenterHeader;
    chkMiddleClose: TJvXPCheckbox;
    chkMinimiseBtn: TJvXPCheckbox;
    chkRestoreBtn: TJvXPCheckbox;
    chkFilterTasks: TJvXPCheckbox;
    procedure lbItemsResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lbItemsGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbItemsClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbItemsGetCellColor(Sender: TObject; const AItem: TSharpEListItem;
      var AColor: TColor);
    procedure lbItemsClickCheck(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AChecked: Boolean);
    procedure chkFilterTasksClick(Sender: TObject);
    procedure SettingsChange(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    FTaskFilterList: TFilterItemList;
  public
    procedure RenderItems;
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;

implementation

{$R *.dfm}

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  if Visible then
    PluginHost.Save;
end;

procedure TfrmEdit.chkFilterTasksClick(Sender: TObject);
begin
  SettingsChange(Sender);

  lbItems.Visible := chkFilterTasks.Checked;
  PluginHost.Refresh(rtAll);
end;

procedure TfrmEdit.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbItems.DoubleBuffered := True;

  FTaskFilterList := TFilterItemList.Create;
  RenderItems;
end;

procedure TfrmEdit.FormDestroy(Sender: TObject);
begin
  FTaskFilterList.Free;
end;

procedure TfrmEdit.lbItemsClickCheck(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AChecked: Boolean);
begin
  if ACol = 1 then begin
    if AItem.SubItemChecked[2] then
      AItem.SubItemChecked[2] := False;
  end else begin
    if AItem.SubItemChecked[1] then
      AItem.SubItemChecked[1] := False;
  end;

  SettingsChange(Sender);
end;

procedure TfrmEdit.lbItemsClickItem(Sender: TObject; const ACol: Integer;
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

  SettingsChange(Sender);
end;

procedure TfrmEdit.lbItemsGetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.SubItemChecked[1] then AColor := $00E6FBE9;
  if AItem.SubItemChecked[2] then AColor := $00E8E1FF;
end;

procedure TfrmEdit.lbItemsGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > 0 then
    ACursor := crHandPoint;
end;

procedure TfrmEdit.lbItemsGetCellImageIndex(Sender: TObject;
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

procedure TfrmEdit.lbItemsResize(Sender: TObject);
begin
  if lbItems.Visible then
    Self.Height := lbItems.Height + pnlOptions.Height + 8 else
    Self.Height := pnlOptions.Height;
end;

procedure TfrmEdit.RenderItems;
var
  newItem: TSharpEListItem;
  i: Integer;
  tmpItemData: TFilterItem;
begin

  LockWindowUpdate(Self.Handle);
  try

    lbItems.Clear;
    FTaskFilterList.Load;

    for i := 0 to FTaskFilterList.Count - 1 do begin

      tmpItemData := TFilterItem(FTaskFilterList[i]);

      newItem := lbItems.AddItem(tmpItemData.Name);
      newItem.Data := tmpItemData;
      newItem.AddSubItem('Include', False);
      newItem.AddSubItem('Exclude', False);

    end;
  finally
    LockWindowUpdate(0);
  end;

  lbItems.ItemIndex := -1;
end;

{ TItemData }

constructor TItemData.Create(AName: string; AId: Integer);
begin
  FName := AName;
  FId := AId;
end;

end.

