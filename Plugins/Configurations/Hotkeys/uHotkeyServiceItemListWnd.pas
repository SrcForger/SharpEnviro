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
  ActnMenus,
  ActnList,
  ActnMan,
  ActnCtrls,
  Menus,

  // JVCL
  JvGradient,

  // Project
  uHotkeyServiceList,
  XPStyleActnCtrls,
  uSEListboxPainter, PngImageList, SharpEListBox;

type
  TfrmConfig = class(TForm)
    dlgOpenFile: TOpenDialog;
    dlgSaveFile: TSaveDialog;
    ImageList1: TImageList;
    PopupMenu1: TPopupMenu;
    Load1: TMenuItem;
    Append1: TMenuItem;
    Append2: TMenuItem;
    am: TActionManager;
    actLoadHotkeys: TAction;
    actAdd: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actSaveHotkeys: TAction;
    actAppendHotkeys: TAction;
    picMain: TPngImageCollection;
    lbHotkeys: TSharpEListBox;
    procedure lbHotkeysDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmdAddHotkeyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure columnclick(Sender: TObject);

    procedure HotkeyItemMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure actAddUpdate(Sender: TObject);
    procedure actEditUpdate(Sender: TObject);
    procedure actDeleteUpdate(Sender: TObject);
    procedure actLoadHotkeysUpdate(Sender: TObject);
    procedure actSaveHotkeysUpdate(Sender: TObject);
    procedure actAppendHotkeysUpdate(Sender: TObject);
    procedure AddItemClick(Sender: TObject);
    procedure DeleteItemClick(Sender: TObject);
    procedure EditItemClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure RefreshHotkeys;
    procedure LoadHotkeyList;
  end;

var
  frmConfig: TfrmConfig;
  LastSORTedCOLUMN: integer;
  Ascending: boolean;
  ItemSelectedID: Integer = -1;
  FHotkeyList: THotkeyList;

implementation

uses
  SharpApi,
  SharpFX,
  uHotkeyServiceGeneral,
  uHotkeyServiceItemEditWnd;

{$R *.dfm}

procedure TfrmConfig.cmdAddHotkeyClick(Sender: TObject);
begin
  {  if not assigned(frmHk) then
      frmHk := tfrmhk.Create(nil);

    with FrmHk do
    begin
      //EditHotkey.Text := '';
      EditCommand.Text := '';
      CmdAddEdit.Caption := 'Add';
      frmHk.Caption := 'Create Hotkey Item';

      pagCommand.Show;
      //cboAction.Text := '';  }

  case FrmHotkeyEdit.showmodal of
    mrOk:
      begin
        //case plCommandTypes.ActivePageIndex of
        //  piFile: hk.Add(''{editHotkey.Text},editcommand.text, False);
       //   piAction: hk.Add(''{editHotkey.Text},''{cboAction.text}, True);
        //end;
      end;
  end;

  // RefreshHotkeys;
 //end;
end;

procedure TfrmConfig.FormShow(Sender: TObject);
begin
  // Populate Hotkey List
  LoadHotkeyList;

  // Refresh Hotkey List Interface
  RefreshHotkeys;

  // Initialise the Interface
  actAdd.Enabled := True;
  actEdit.Enabled := True;
  actDelete.Enabled := True;

end;

procedure TfrmConfig.columnclick(Sender: TObject);
begin
  Ascending := not Ascending;
end;

procedure TfrmConfig.RefreshHotkeys;
var
  i: Integer;
  idx: Integer;
begin
  if lbHotkeys.ItemIndex <> -1 then
    idx := lbHotkeys.ItemIndex;

  lbHotkeys.Clear;

  for i := 0 to Pred(FHotkeyList.Count) do
  begin
    lbHotkeys.AddItem(FHotkeyList.HotkeyItem[i].Command,
      FHotkeyList.HotkeyItem[i]);
  end;

  try
    lbHotkeys.ItemIndex := idx;
  except
  end;
end;

procedure TfrmConfig.HotkeyItemMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  i: integer;
  id: integer;
begin
  {id := THotkeyMgrItem(sender).Tag;
  ItemSelectedId := id;

  for i := 0 to FHotkeyList.Count - 1 do
    FHotkeyPnlItems[i].Selected := False;
  THotkeyMgrItem(Sender).Selected := True;   }

end;

procedure TfrmConfig.actAddUpdate(Sender: TObject);
begin
  actAdd.Enabled := True;
end;

procedure TfrmConfig.actEditUpdate(Sender: TObject);
begin
  if FHotkeyList.Count > 0 then
    actEdit.Enabled := True
  else
    actEdit.Enabled := False;
end;

procedure TfrmConfig.actDeleteUpdate(Sender: TObject);
begin
  if FHotkeyList.Count > 0 then
    actDelete.Enabled := True
  else
    actDelete.Enabled := False;
end;

procedure TfrmConfig.actLoadHotkeysUpdate(Sender: TObject);
begin
  actLoadHotkeys.Enabled := True;
end;

procedure TfrmConfig.actSaveHotkeysUpdate(Sender: TObject);
begin
  if FHotkeyList.Count > 0 then
    actSaveHotkeys.Enabled := True;
end;

procedure TfrmConfig.actAppendHotkeysUpdate(Sender: TObject);
begin
  if FHotkeyList.Count > 0 then
    actAppendHotkeys.Enabled := True;
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

procedure TfrmConfig.AddItemClick(Sender: TObject);
begin
  // Create the form
  if not assigned(FrmHotkeyEdit) then
    FrmHotkeyEdit := TFrmHotkeyEdit.Create(nil);

  with FrmHotkeyEdit do
  begin

    // Initialise the dialog
    SelectedText := '';
    hkeCommand.Text := '';
    hkeAction.Text := '';
    edtCommand.Text := '';
    tbHotkeyType.Tabs.Items[0].Selected := true;

    CmdAddEdit.Caption := 'Add';
    FrmHotkeyEdit.Caption := 'Create Hotkey Item';

    pagCommand.Show;

    case FrmHotkeyEdit.ShowModal of
      mrOk:
        begin
          case plCommandTypes.ActivePageIndex of
            0: FHotkeyList.Add(hkeCommand.Text, edtCommand.Text, False);
            1: FHotkeyList.Add(hkeAction.Text, lvActionItems.Selected.Caption, True);
          end;
          SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
        end;
    end;

    RefreshHotkeys;
  end;
end;

procedure TfrmConfig.DeleteItemClick(Sender: TObject);
var
  id: integer;
begin
  id := ItemSelectedID;
  FHotkeyList.Delete(id);

  SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  RefreshHotkeys;
end;

procedure TfrmConfig.EditItemClick(Sender: TObject);
var
  id: integer;
begin

  if not assigned(FrmHotkeyEdit) then
    FrmHotkeyEdit := TFrmHotkeyEdit.Create(nil);

  id := ItemSelectedID;

  with FrmHotkeyEdit do
  begin

    // Initialise the dialog
    SelectedText := '';
    hkeCommand.Text := '';
    hkeAction.Text := '';
    edtCommand.Text := '';

    if FHotkeyList.HotkeyItem[id].IsAction then
    begin
      if IsServiceStarted(pchar('actions')) = MR_STARTED then
      begin
        plCommandTypes.ActivePageIndex := piAction;
        hkeAction.Text := FHotkeyList.HotkeyItem[id].Hotkey;
        tbHotkeyType.Tabs.Items[1].Selected := true;
        FrmHotkeyEdit.SelectedText := FHotkeyList.HotkeyItem[id].Command;
      end
      else
      begin
        MessageDlg('Actions Service is not currently running', mtError, [mbOK], 0);
        exit;
      end;
    end
    else
    begin
      tbHotkeyType.Tabs.Items[0].Selected := true;
      plCommandTypes.ActivePageIndex := piFile;
      hkeAction.Text := FHotkeyList.HotkeyItem[id].Hotkey;
      edtCommand.Text := FHotkeyList.HotkeyItem[id].Command;
    end;

    CmdAddEdit.Caption := 'Update';
    FrmHotkeyEdit.Caption := 'Edit Hotkey Item';

    case FrmHotkeyEdit.showmodal of
      mrOk:
        begin

          FHotkeyList.HotkeyItem[id].IsAction := false;

          case plCommandTypes.ActivePageIndex of
            piAction:
              begin
                FHotkeyList.HotkeyItem[id].Command := lvActionItems.Selected.Caption;
                FHotkeyList.HotkeyItem[id].Hotkey := hkeAction.Text;
                FHotkeyList.HotkeyItem[id].IsAction := True;
              end;
            piFile:
              begin
                FHotkeyList.HotkeyItem[id].Hotkey := hkeCommand.Text;
                FHotkeyList.HotkeyItem[id].Command := edtCommand.Text;
              end;
          end;

        SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
        end;
    end;
  end;

  RefreshHotkeys;

end;

procedure TfrmConfig.lbHotkeysDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  iIconIndex: Integer;
  sText, sStatus: string;
  FontColor: TColor;
  obj: THotkeyItem;
begin
  // If nothing selected, exit
  if Index = -1 then
    exit;

  // Get Object, and if not assigned then exit
  obj := THotkeyItem(TListBox(Control).Items.Objects[Index]);
  if not (assigned(obj)) then
    exit;

  // Also do not continue if list style is standard
  if TListBox(Control).Style = lbStandard then
    exit;

  // Object specific extractions
  sText := obj.Command;
  sStatus := obj.Hotkey;
  FontColor := clBlack;

  if obj.IsAction then
    iIconIndex := 1 else
    iIconIndex := 0;

  // Draw Method
  PaintListbox(TListBox(Control), Rect, 0, State, sText, picMain, iIconIndex,
    sStatus, FontColor);
end;

end.

