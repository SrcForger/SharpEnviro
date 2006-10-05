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
  uHotkeyServiceList,
  uSEListboxPainter, PngImageList, SharpEListBox;

type
  TfrmConfig = class(TForm)
    dlgOpenFile: TOpenDialog;
    dlgSaveFile: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Load1: TMenuItem;
    Append1: TMenuItem;
    Append2: TMenuItem;
    picMain: TPngImageCollection;
    lbHotkeys: TSharpEListBox;
    procedure lbHotkeysDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cmdAddHotkeyClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure columnclick(Sender: TObject);

    procedure HotkeyItemMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DeleteItemClick(Sender: TObject);
    procedure EditItemClick(Sender: TObject);
    procedure AddItemClick(Sender: TObject);
  private
    { Private declarations }
    procedure CenterForm(var AForm: TForm; AOwner: TForm);
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

procedure TfrmConfig.CenterForm(var AForm: TForm; AOwner: TForm);
var
  p: TPoint;
begin
  p := ClientToScreen(AOwner.ScreenToClient(AOwner.ClientOrigin));
  AForm.Left := p.x + AOwner.Width div 2 - AForm.Width div 2;
  AForm.Top := p.y + AOwner.Height div 2 - AForm.Height div 2;
end;

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
  idx := 0;
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
begin
  {id := THotkeyMgrItem(sender).Tag;
  ItemSelectedId := id;

  for i := 0 to FHotkeyList.Count - 1 do
    FHotkeyPnlItems[i].Selected := False;
  THotkeyMgrItem(Sender).Selected := True;   }

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
  CenterForm(Tform(FrmHotkeyEdit),Self);

  with FrmHotkeyEdit do
  begin

    // Initialise the dialog
    SelectedText := '';
    hkeCommand.Text := '';
    mmoCommand.Lines.Text := '';

    CmdAddEdit.Caption := 'Add';
    FrmHotkeyEdit.Caption := 'Create Hotkey Item';

    case FrmHotkeyEdit.ShowModal of
      mrOk:
        begin
          FHotkeyList.Add(hkeCommand.Text, mmoCommand.Lines.Text, False);
        end;
    end;
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
    RefreshHotkeys;
  end;
end;

procedure TfrmConfig.DeleteItemClick(Sender: TObject);
var
  tmpItem: THotkeyItem;
begin
  if lbHotkeys.SelCount = 0 then
    Exit;

  tmpItem := THotkeyItem(lbHotkeys.Items.Objects[lbHotkeys.ItemIndex]);

  FHotkeyList.Delete(tmpItem);

  SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
  RefreshHotkeys;
end;

procedure TfrmConfig.EditItemClick(Sender: TObject);
var
  tmpItem: THotkeyItem;
begin
  if lbHotkeys.SelCount = 0 then
    Exit;

  tmpItem := THotkeyItem(lbHotkeys.Items.Objects[lbHotkeys.ItemIndex]);

  if not assigned(FrmHotkeyEdit) then
    FrmHotkeyEdit := TFrmHotkeyEdit.Create(nil);
  CenterForm(Tform(FrmHotkeyEdit),Self);

  with FrmHotkeyEdit do
  begin

    // Initialise the dialog
    SelectedText := '';
    hkeCommand.Text :=tmpItem.Hotkey;
    mmoCommand.Lines.Text := '';
    mmoCommand.Lines.Text := tmpItem.Command;

    CmdAddEdit.Caption := 'Update';
    FrmHotkeyEdit.Caption := 'Edit Hotkey Item';

    case FrmHotkeyEdit.showmodal of
      mrOk:
        begin
          tmpItem.Hotkey := hkeCommand.Text;
          tmpItem.Command := mmoCommand.Lines.Text;
        end;
    end;
    SharpEBroadCast(WM_SETTINGSCHANGED, 1, 1);
    RefreshHotkeys;
  end;
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
    iIconIndex := 1
  else
    iIconIndex := 0;

  // Draw Method
  PaintListbox(TListBox(Control), Rect, 0, State, sText, picMain, iIconIndex,
    sStatus, FontColor);
end;

end.

