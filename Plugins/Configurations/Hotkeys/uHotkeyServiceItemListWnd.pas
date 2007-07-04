{
Source Name: uHotkeyServiceConfigWnd
Description: Hotkey Items Configuration Window
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uHotkeyServiceItemListWnd;

interface

uses
  // Standard
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
  ComCtrls,
  ToolWin,
  ExtCtrls,
  ImgList,
  Menus,

  // JVCL
  JvGradient,

  // Project
  uHotkeyServiceList, PngImageList, SharpEHotkeyEdit, JvExControls,
  JvComponent, JvLabel, SharpEListBoxEx, JvHint, SharpApi;

type
  TfrmConfig = class(TForm)
    dlgImport: TOpenDialog;
    dlgExport: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Load1: TMenuItem;
    Append1: TMenuItem;
    Append2: TMenuItem;
    imlList: TPngImageList;
    lbHotkeys: TSharpEListBoxEx;
    JvHint1: TJvHint;
    procedure lbHotkeysClickItem(AText: string; AItem, ACol: Integer);
    procedure FormResize(Sender: TObject);

    procedure lbHotkeysGetCellTextColor(const ACol: Integer;
      AItem: TSharpEListItem; var AColor: TColor);

    procedure FormShow(Sender: TObject);

    procedure columnclick(Sender: TObject);
    procedure ImportHotkeys;
    procedure ExportHotkeys;
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshHotkeys;
    procedure LoadHotkeyList;
    procedure UpdateEditTabs;

    

    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
  end;

var
  frmConfig: TfrmConfig;
  LastSORTedCOLUMN: integer;
  Ascending: boolean;
  ItemSelectedID: Integer = -1;
  FHotkeyList: THotkeyList;

implementation

uses
  SharpFX,
  uHotkeyServiceGeneral,
  uHotkeyServiceItemEditWnd;

{$R *.dfm}

procedure TfrmConfig.FormShow(Sender: TObject);
begin
  // Populate Hotkey List
  LoadHotkeyList;

  // Refresh Hotkey List Interface
  RefreshHotkeys;

end;

procedure TfrmConfig.columnclick(Sender: TObject);
begin
  Ascending := not Ascending;
end;

procedure TfrmConfig.RefreshHotkeys;
var
  i: Integer;
  idx: Integer;
  tmpItem: TSharpEListItem;
  s:String;
begin
  idx := 0;
  if lbHotkeys.ItemIndex <> -1 then
    idx := lbHotkeys.ItemIndex;

  lbHotkeys.Clear;
  FHotkeyList.Sort;

  for i := 0 to Pred(FHotkeyList.Count) do
  begin
    s := Format('%s (%s)',[FHotkeyList.HotkeyItem[i].Name,
      FHotkeyList.HotkeyItem[i].Command]);

    tmpItem := lbHotkeys.AddItem(s,0);
    tmpItem.AddSubItem(FHotkeyList.HotkeyItem[i].Hotkey,1);
    tmpItem.Data := FHotkeyList.HotkeyItem[i];
  end;

  try
    lbHotkeys.ItemIndex := idx;
  except
  end;
end;

procedure TfrmConfig.LoadHotkeyList;
var
  fn: string;
begin
  // Load Hotkey List
  fn := GetSharpeUserSettingsPath + cSettingsLocation;
  if (not (assigned(FHotkeyList))) then
    FHotkeyList := THotkeyList.Create(fn)
  else
  begin
    FHotkeyList.Items.Clear;
    FHotkeyList.Load;
  end;
end;

procedure TfrmConfig.ExportHotkeys;
begin
  dlgExport.FileName := 'hotkeys_backup.xml';
  if dlgExport.Execute then
  begin
    FHotkeyList.Save(dlgExport.FileName);

  end;
end;

procedure TfrmConfig.ImportHotkeys;
begin
  if dlgImport.Execute then
  begin
    FHotkeyList.Load(dlgImport.FileName);
    RefreshHotkeys;
    SharpCenterBroadCast( SCM_SET_SETTINGS_CHANGED, 1);
  end;
end;

procedure TfrmConfig.lbHotkeysGetCellTextColor(const ACol: Integer;
  AItem: TSharpEListItem; var AColor: TColor);
begin
  if ACol = 1 then
    AColor := clNavy;
end;

procedure TfrmConfig.FormResize(Sender: TObject);
var
  w: Integer;
begin
  if lbHotkeys.ColumnCount = 0 then exit;

  w := lbHotkeys.Width;
  lbHotkeys.Column[0].Width := w-180;
  lbHotkeys.Column[1].Width := 170;
end;

procedure TfrmConfig.lbHotkeysClickItem(AText: string; AItem, ACol: Integer);
begin
  if FrmHotkeyEdit <> nil then
    FrmHotkeyEdit.InitUi(FEditMode);
end;

procedure TfrmConfig.UpdateEditTabs;

  procedure BC(AEnabled:Boolean; AButton:Integer);
  begin
    if AEnabled then
    SharpCenterBroadCast( SCM_SET_BUTTON_ENABLED, AButton) else
    SharpCenterBroadCast( SCM_SET_BUTTON_DISABLED, AButton);
  end;

begin
  if ((lbHotkeys.Count = 0) or (lbHotkeys.ItemIndex = -1)) then
  begin
    BC(False, SCB_EDIT_TAB);

    if (lbHotkeys.Count = 0) then begin
      BC(False, SCB_DEL_TAB);
      SharpCenterBroadCast(SCM_SET_TAB_SELECTED,SCB_ADD_TAB);
    end;

    BC(True, SCB_ADD_TAB);

  end
  else
  begin
    BC(True, SCB_ADD_TAB);
    BC(True, SCB_EDIT_TAB);
    BC(True, SCB_DEL_TAB);
  end;
end;

end.

