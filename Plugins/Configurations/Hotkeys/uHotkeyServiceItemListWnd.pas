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
  JvComponent, JvLabel, SharpEListBoxEx, JvHint, SharpApi, SharpCenterApi;

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
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    function CtrlDown: Boolean;
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

const
  colName = 0;
  colHotkey = 1;
  colCopy = 2;
  colDelete = 3;
  iidxDelete = 0;
  iidxCopy = 1;

implementation

uses
  SharpFX,
  uHotkeyServiceGeneral,
  uHotkeyServiceItemEditWnd;

{$R *.dfm}

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  lbHotkeys.DoubleBuffered := True;
end;

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
  tmpItem: TSharpEListItem;
  s, sName: string;
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
    s := Format('%s (%s)', [FHotkeyList.HotkeyItem[i].Name,
      FHotkeyList.HotkeyItem[i].Command]);

    tmpItem := lbHotkeys.AddItem(s, 0);
    tmpItem.AddSubItem(FHotkeyList.HotkeyItem[i].Hotkey, 1);
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
end;

procedure TfrmConfig.LoadHotkeyList;
var
  fn: string;
begin
  // Load Hotkey List
  fn := GetSharpeUserSettingsPath + cSettingsLocation;
  if (not (assigned(FHotkeyList))) then
    FHotkeyList := THotkeyList.Create(fn)
  else begin
    FHotkeyList.Items.Clear;
    FHotkeyList.Load;
  end;
end;

function TfrmConfig.CtrlDown: Boolean;
var
  State: TKeyboardState;
begin
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128) <> 0);
end;

procedure TfrmConfig.ExportHotkeys;
begin
  dlgExport.FileName := 'hotkeys_backup.xml';
  if dlgExport.Execute then begin
    FHotkeyList.Save(dlgExport.FileName);

  end;
end;

procedure TfrmConfig.ImportHotkeys;
begin
  if dlgImport.Execute then begin
    FHotkeyList.Load(dlgImport.FileName);
    RefreshHotkeys;

    CenterDefineSettingsChanged;
  end;
end;

procedure TfrmConfig.lbHotkeysClickItem(Sender: TObject; const ACol: Integer;
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

          CenterDefineSettingsChanged;
        end;

      end;
    colCopy: begin
        sCopy := 'Copy of ' + tmp.Name;
        tmp2 := FHotkeyList.Add('', tmp.Command, sCopy);
        RefreshHotkeys;
        FHotkeyList.Save;

        for i := 0 to Pred(lbHotkeys.Count) do begin
          if tmp2.Name = THotkeyItem(lbHotkeys.Item[i].Data).Name then begin
            lbHotkeys.ItemIndex := i;
            break;
          end;
        end;

        CenterDefineSettingsChanged;
      end;
  end;

  if lbHotkeys.SelectedItem <> nil then begin
    CenterDefineButtonState(scbEditTab, True);
  end
  else begin
    CenterDefineButtonState(scbEditTab, False);
  end;

  if FrmHotkeyEdit <> nil then
    FrmHotkeyEdit.InitUi(FEditMode);

  CenterUpdateConfigFull;

end;

procedure TfrmConfig.lbHotkeysGetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  if ACol >= colCopy then
    ACursor := crHandPoint;
end;

procedure TfrmConfig.lbHotkeysGetCellImageIndex(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var AImageIndex: Integer;
  const ASelected: Boolean);
begin
  if ACol = colName then
    AImageIndex := -1
  else if ACol = colDelete then
    AImageIndex := iidxDelete
  else if ACol = colCopy then
    AImageIndex := iidxCopy;

end;

procedure TfrmConfig.lbHotkeysResize(Sender: TObject);
begin
  Self.Height := lbHotkeys.Height;
end;

procedure TfrmConfig.UpdateEditTabs;

  procedure BC(AEnabled: Boolean; AButton: TSCB_BUTTON_ENUM);
  begin
    if AEnabled then
      CenterDefineButtonState(AButton, True)
    else
      CenterDefineButtonState(AButton, False);
  end;

begin
  if ((lbHotkeys.Count = 0) or (lbHotkeys.ItemIndex = -1)) then begin
    BC(False, scbEditTab);

    if (lbHotkeys.Count = 0) then begin
      BC(False, scbDeleteTab);
      CenterSelectEditTab(scbAddTab);
    end;

    BC(True, scbAddTab);

  end
  else begin
    BC(True, scbAddTab);
    BC(True, scbEditTab);
  end;
end;

end.

