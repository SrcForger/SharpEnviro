{
Source Name: uHotkeyServiceConfigWnd
Description: Hotkey Items Configuration Window
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

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

unit uItemsWnd;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ToolWin,
  ExtCtrls,
  Graphics,
  Menus,

  // Project
  uHotkeyServiceList, PngImageList, SharpEHotkeyEdit, 
  SharpEListBoxEx, SharpApi, SharpCenterApi, ImgList, ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TfrmItemsWnd = class(TForm)
    dlgImport: TOpenDialog;
    dlgExport: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Load1: TMenuItem;
    Append1: TMenuItem;
    Append2: TMenuItem;
    imlList: TPngImageList;
    lbHotkeys: TSharpEListBoxEx;

    procedure FormShow(Sender: TObject);

    procedure columnclick(Sender: TObject);
    procedure ImportHotkeys;
    procedure ExportHotkeys;
    procedure lbHotkeysResize(Sender: TObject);
    procedure lbHotkeysClickItem(Sender: TObject; const ACol: Integer; AItem: TSharpEListItem);
    procedure lbHotkeysGetCellImageIndex(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure lbHotkeysGetCellCursor(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var ACursor: TCursor);
    procedure FormCreate(Sender: TObject);
    procedure lbHotkeysGetCellText(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
  private
    FPluginHost: ISharpCenterHost;
    function CtrlDown: Boolean;
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshHotkeys;
    procedure LoadHotkeyList;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmItemsWnd: TfrmItemsWnd;
  LastSORTedCOLUMN: integer;
  Ascending: boolean;
  ItemSelectedID: Integer = -1;
  FHotkeyList: THotkeyList;

const
  colName = 0;
  colCopy = 1;
  colDelete = 2;
  iidxDelete = 0;
  iidxCopy = 1;

implementation

uses
  SharpFX,
  uHotkeyServiceGeneral,
  uEditWnd;

{$R *.dfm}

procedure TfrmItemsWnd.FormCreate(Sender: TObject);
begin
  lbHotkeys.DoubleBuffered := True;
end;

procedure TfrmItemsWnd.FormShow(Sender: TObject);
begin
  // Populate Hotkey List
  LoadHotkeyList;

  // Refresh Hotkey List Interface
  RefreshHotkeys;

end;

procedure TfrmItemsWnd.columnclick(Sender: TObject);
begin
  Ascending := not Ascending;
end;

procedure TfrmItemsWnd.RefreshHotkeys;
var
  i: Integer;
  tmpItem: TSharpEListItem;
  sName: string;
begin
  sName := '';
  if lbHotkeys.ItemIndex <> -1 then begin
    sName := THotkeyItem(lbHotkeys.SelectedItem.Data).Name;
  end;

  LockWindowUpdate(Self.Handle);
  Try
  lbHotkeys.Clear;
  FHotkeyList.Sort;

  for i := 0 to Pred(FHotkeyList.Count) do begin

    tmpItem := lbHotkeys.AddItem('');
    tmpItem.AddSubItem('');
    tmpItem.AddSubItem('');
    tmpItem.AddSubItem('');
    tmpItem.Data := FHotkeyList.HotkeyItem[i];
  end;

  if sName <> '' then begin
    for i := 0 to Pred(lbHotkeys.Count) do begin
      if sName = THotkeyItem(lbHotkeys.Item[i].Data).Name then begin
        lbHotkeys.ItemIndex := i;
        break;
      end;
    end;
  end
  else if lbHotkeys.Count <> 0 then
    lbHotkeys.ItemIndex := 0;
  Finally
    LockWindowUpdate(0);
  End;

  FPluginHost.SetEditTabsVisibility(lbHotkeys.ItemIndex,lbHotkeys.Count);
  FPluginHost.Refresh;
end;

procedure TfrmItemsWnd.LoadHotkeyList;
var
  fn: string;
begin
  // Load Hotkey List
  fn := GetSharpeUserSettingsPath + cSettingsLocation;
  if (not (assigned(FHotkeyList))) then begin
    FHotkeyList := THotkeyList.Create;
    FHotkeyList.Filename := fn;
    FHotkeyList.Load;
  end
  else begin
    FHotkeyList.Clear;
    FHotkeyList.Load;
  end;
end;

function TfrmItemsWnd.CtrlDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128) <> 0);
end;

procedure TfrmItemsWnd.ExportHotkeys;
begin
  dlgExport.FileName := 'hotkeys_backup.xml';
  if dlgExport.Execute then begin
    FHotkeyList.Save(dlgExport.FileName);

  end;
end;

procedure TfrmItemsWnd.ImportHotkeys;
begin
  if dlgImport.Execute then begin
    FHotkeyList.Load(dlgImport.FileName);
    RefreshHotkeys;
  end;
end;

procedure TfrmItemsWnd.lbHotkeysClickItem(Sender: TObject; const ACol: Integer;
  AItem: TSharpEListItem);
var
  tmp, tmp2: THotkeyItem;
  bDelete: Boolean;
  sCopy: string;
  i: Integer;
begin
  tmp := THotkeyItem(AItem.Data);
  if tmp = nil then
    exit;

  case ACol of
    colDelete: begin
        bDelete := True;
        if not (CtrlDown) then
          if (MessageDlg(Format('Are you sure you want to delete: %s?', [tmp.Name]), mtConfirmation, [mbOK, mbCancel], 0) = mrCancel) then
            bDelete := False;

        if bDelete then begin
          FHotkeyList.Delete(tmp);
          RefreshHotkeys;
          FHotkeyList.Save;
        end;

      end;
    colCopy: begin
        sCopy := 'Copy of ' + tmp.Name;
        tmp2 := FHotkeyList.AddItem('', tmp.Command, sCopy);
        RefreshHotkeys;
        FHotkeyList.Save;

        for i := 0 to Pred(lbHotkeys.Count) do begin
          if tmp2.Name = THotkeyItem(lbHotkeys.Item[i].Data).Name then begin
            lbHotkeys.ItemIndex := i;
            break;
          end;
        end;
      end;
  end;

  if frmEditWnd <> nil then
    frmEditWnd.Init;

  FPluginHost.SetEditTabsVisibility(lbHotkeys.ItemIndex,lbHotkeys.Count);
  FPluginHost.Refresh;
end;

procedure TfrmItemsWnd.lbHotkeysGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol >= colCopy then
    ACursor := crHandPoint;
end;

procedure TfrmItemsWnd.lbHotkeysGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
begin
  if ACol = colName then
    AImageIndex := 2
  else if ACol = colDelete then
    AImageIndex := iidxDelete
  else if ACol = colCopy then
    AImageIndex := iidxCopy;

end;

procedure TfrmItemsWnd.lbHotkeysGetCellText(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AColText: string);
var
  tmpItemData: THotkeyItem;
  s:String;
  colItemTxt, colDescTxt, colBtnTxt: TColor;
begin

  tmpItemData := THotkeyItem(AItem.Data);
  if tmpItemData = nil then
    exit;

  case ACol of
    colName: begin
      s := tmpItemData.Name;
      if s = '' then s := '*Untitled';

      AssignThemeToListBoxItemText(FPluginHost.Theme, AItem, colItemTxt, colDescTxt, colBtnTxt);

      AColText := format('<font color="%s">%s (<b>%s</b>) - <font color="%s">%s',[ColorToString(colItemTxt),s,tmpItemData.Hotkey, ColorToString(colDescTxt),tmpItemData.Command]);
    end;
  end;
end;

procedure TfrmItemsWnd.lbHotkeysResize(Sender: TObject);
begin
  Self.Height := lbHotkeys.Height;
end;

end.

