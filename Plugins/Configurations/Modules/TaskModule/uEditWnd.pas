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
  DwmApi,
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
  ISharpCenterHostUnit, SharpCenterApi, SharpESkin,
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
    SharpECenterHeader1: TSharpECenterHeader;
    Panel1: TPanel;
    chkAppBar: TJvXPCheckbox;
    chkTaskPreviews: TJvXPCheckbox;
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
    procedure lbItemsClickCheck(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AChecked: Boolean);
    procedure chkFilterTasksClick(Sender: TObject);
    procedure SettingsChange(Sender: TObject);
    procedure lbItemsGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure FormShow(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    FTaskFilterList: TFilterItemList;
  public
    procedure RenderItems;
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmEdit: TfrmEdit;

const
  colName = 0;

  iidxDefault = 0;
  iidxCommand = 1;
  iidxWindows = 2;
  iidxSystem = 3;

implementation

{$R *.dfm}

procedure TfrmEdit.SettingsChange(Sender: TObject);
begin
  if Visible then
    FPluginHost.SetSettingsChanged;
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

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  if not DwmApi.DwmCompositionEnabled then
    chkTaskPreviews.Checked := False;

  chkTaskPreviews.Enabled := DwmApi.DwmCompositionEnabled;
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
  tmpItemData: TFilterItem;
begin

  tmpItemData := TFilterItem(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colName:
    begin
      case tmpItemData.FilterType of
        fteSWCmd: AImageIndex := iidxCommand;
        fteWindow,fteProcess : AImageIndex := iidxWindows;
        else
          AImageIndex := iidxSystem;
      end;
    end;
  end;

end;

procedure TfrmEdit.lbItemsGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
	colItemTxt, colDescTxt, colBtnTxt: TColor;
  tmpItemData: TFilterItem;
begin
  tmpItemData := TFilterItem(AItem.Data);
  if tmpItemData = nil then
    exit;

  // Assign theme colours
  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  case ACol of
    colName: AColText := Format('<font color="%s" />%s',[ColorToString(colItemTxt),
      tmpItemData.Name]);
    1: AColText := Format('<font color="%s" />%s',[ColorToString(colBtnTxt),
      'Include']);
    2: AColText := Format('<font color="%s" />%s',[ColorToString(colBtnTxt),
      'Exclude']);

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

