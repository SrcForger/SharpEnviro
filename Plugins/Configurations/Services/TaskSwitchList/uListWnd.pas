{
Source Name: uSettingsWnd
Description: Configuration window for Scheme Settings
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
  ExtCtrls,
  pngimage,
  SharpApi,
  SharpCenterApi,
  SharpThemeApiEx,
  SharpEListBoxEx,
  PngImageList,
  ImgList,
  Gr32,
  GR32_Image,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uTaskswitchUtility;

type
  TfrmList = class(TForm)
    Label3: TLabel;
    lbList: TSharpEListBoxEx;
    colImages: TPngImageList;
    bmlMain: TBitmap32List;
    procedure FormCreate(Sender: TObject);

    procedure lbListResize(Sender: TObject);
    procedure lbListClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure lbListGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure lbListGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure lbListGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    FPluginHost: ISharpCenterHost;
    FTaskSwitchList: TTaskSwitchItemList;
    procedure ConfigureItem;
  public
    { Public declarations }
    procedure AddItems;

    property TaskSwitchList: TTaskSwitchItemList read FTaskSwitchList write FTaskSwitchList;
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;

  end;

var
  frmList: TfrmList;

const
  iidxName = 0;
  iidxCopy = 1;
  iidxDelete = 2;

  colName = 0;
  colEdit = 1;
  colCopy = 2;
  colDelete = 3;

implementation

uses
  JclStrings,
  SharpFx,
  uEditWnd;

{$R *.dfm}

procedure TfrmList.AddItems;
var
  i, iSel: Integer;
  newItem: TSharpEListItem;
  tmp: TTaskSwitchItem;
begin
  iSel := lbList.ItemIndex;
  if iSel = -1 then
    iSel := 0;

  LockWindowUpdate(Self.Handle);
  lbList.Clear;

  try

    FTaskSwitchList.Load;

    for i := 0 to Pred(FTaskSwitchList.Count) do begin
      tmp := TTaskSwitchItem(FTaskSwitchList[i]);

      newItem := lbList.AddItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');
      newItem.AddSubItem('');

      newItem.Data := tmp;
    end;

  finally

    if iSel < lbList.Count then
      lbList.ItemIndex := iSel
    else begin
      lbList.ItemIndex := 0;
    end;

    LockWindowUpdate(0);

    FPluginHost.SetEditTabsVisibility(lbList.ItemIndex, lbList.Count);
    FPluginHost.Refresh;
  end;
end;

procedure TfrmList.ConfigureItem;
var
  tmpItem: TSharpEListItem;
  sName: string;
begin
  tmpItem := lbList.GetItemAtCursorPos(Mouse.CursorPos);
  if tmpItem <> nil then begin
    sName := TTaskSwitchItem(tmpItem.Data).Name;
    CenterCommand(sccLoadSetting, PChar(SharpApi.GetCenterDirectory
      + '_Services\TaskSwitchEdit.con'), pchar(sName))
  end;
end;

procedure TfrmList.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  lbList.DoubleBuffered := True;
end;

procedure TfrmList.FormDestroy(Sender: TObject);
begin
  if Assigned(FTaskSwitchList) then
    FreeAndNil(FTaskSwitchList);
end;

procedure TfrmList.FormShow(Sender: TObject);
begin
  FTaskSwitchList := TTaskSwitchItemList.Create;
  AddItems;
end;

procedure TfrmList.lbListClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp, new: TTaskSwitchItem;
  bDelete: Boolean;
  sCopy: string;
  i: Integer;

  function CtrlDown: Boolean;
  var
    State: TKeyboardState;
  begin
    GetKeyboardState(State);
    Result := ((State[VK_CONTROL] and 128) <> 0);
  end;

begin
  tmp := TTaskSwitchItem(AItem.Data);

  if ACol = colName then begin

  end
  else if ACol = colCopy then begin
    sCopy := 'Copy of ' + tmp.Name;
    new := FTaskSwitchList.AddItem;
    new.Name := sCopy;
    new.Action := '';
    new.CycleForward := tmp.CycleForward;
    new.Gui := tmp.Gui;
    new.Preview := tmp.Preview;
    new.IncludeFilters := tmp.IncludeFilters;
    new.ExcludeFilters := tmp.ExcludeFilters;

    PluginHost.Save;
    AddItems;

    for i := 0 to Pred(lbList.Count) do begin
      if new.Name = TTaskSwitchItem(lbList.Item[i].Data).Name then begin
        lbList.ItemIndex := i;
        break;
      end;
    end;
  end
  else if ACol = colDelete then begin

    bDelete := True;
    if not (CtrlDown) then
      if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmp.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
        bDelete := False;

    if bDelete then begin
      TaskSwitchList.Delete(TaskSwitchList.IndexOf(tmp));
      PluginHost.Save;
      AddItems;
    end;
  end
  else if ACol = colEdit then begin
    ConfigureItem;
  end;

  if frmEdit <> nil then
    frmEdit.Init;

  FPluginHost.SetEditTabsVisibility(lbList.ItemIndex, lbList.Count);
  FPluginHost.Refresh;
end;

procedure TfrmList.lbListGetCellCursor(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol > colName then
    ACursor := crHandPoint;
end;

procedure TfrmList.lbListGetCellImageIndex(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
var
  tmp: TTaskSwitchItem;
begin
  tmp := TTaskSwitchItem(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colName: AImageIndex := iidxName;
    colCopy: AImageIndex := iidxCopy;
    colDelete: AImageIndex := iidxDelete;
  end;

end;

procedure TfrmList.lbListGetCellText(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
var
  tmp: TTaskSwitchItem;
  colItemTxt, colDescTxt, colBtnTxt: TColor;
  sName, sAction, sInclude, sExclude: string;
begin

  // Assign theme colours
  AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

  tmp := TTaskSwitchItem(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colName:
    begin

    if tmp.Name = '' then sName := 'Untititled' else sName := tmp.Name;
    if tmp.Action = '' then sAction := 'Unspecified Action' else sAction := tmp.Action;
    if tmp.IncludeFilters = '' then sInclude := '' else sInclude := '<b>Include: </b>' + tmp.IncludeFilters + ' ';
    if tmp.ExcludeFilters = '' then sExclude := '' else sExclude := '<b>Exclude: </b>' + tmp.ExcludeFilters;

      AColText := Format('<font color="%s"/>%s - %s<br>' +
      '<font color="%s"/>%s%s', [ColorToString(colItemTxt),
          sName, sAction,ColorToString(colDescTxt), sInclude, sExclude]);
    end;
    colEdit: AColText := Format('<u><font color="%s"/>Edit</u>', [ColorToString(colBtnTxt),
        tmp.Name]);
  end;
end;

procedure TfrmList.lbListResize(Sender: TObject);
begin
  Self.Height := lbList.Height;
end;

end.

