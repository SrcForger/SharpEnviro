{
Source Name: uHotkeyServiceEditWnd
Description: Hotkey Item Edit Window
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

unit uHotkeyServiceItemEditWnd;

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
  ExtCtrls,
  StdCtrls,
  Buttons,
  ComCtrls,
  jpeg,
  ImgList,

  // JVCL
  JvTabBar,
  JvPageList,
  JvExControls,
  JvComponent,

  // Project
  SharpEHotkeyEdit,

  // JCL
  jclStrings,
  SharpDialogs,
  SharpApi,
  SharpCenterApi,

  // PNG Image
  pngimage, JvExExtCtrls, JvShape, JvComponentBase,
  SharpEBaseControls, SharpEEdit, TranComp, JvLabel, PngImageList, PngBitBtn,
  JvExStdCtrls, JvMemo, PngSpeedButton, JvErrorIndicator,
  JvValidators, JvBalloonHint, uHotkeyServiceList;

type
  TFrmHotkeyEdit = class(TForm)
    pnl1: TPanel;
    Panel1: TPanel;
    pMain: TJvPageList;
    spDelete: TJvStandardPage;
    spEdit: TJvStandardPage;
    cmdBrowse: TPngBitBtn;
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    edHotkey: TSharpEHotkeyEdit;
    Button1: TPngSpeedButton;
    Label3: TLabel;
    vals: TJvValidators;
    valHotkey: TJvRequiredFieldValidator;
    valName: TJvRequiredFieldValidator;
    pilError: TPngImageList;
    errorinc: TJvErrorIndicator;
    valCommand: TJvRequiredFieldValidator;
    Label1: TJvLabel;
    Label2: TLabel;
    valNameExists: TJvCustomValidator;
    valHotkeyExists: TJvCustomValidator;
    procedure valHotkeyExistsValidate(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
    procedure valNameExistsValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure edHotkeyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpdateEditState(Sender: TObject);
    procedure cmdbrowseclick(Sender: TObject);

  private
    { Private declarations }
    FItemEdit: ThotkeyItem;

  public
    { Public declarations }
    SelectedText: string;
    procedure InitUi(AEditMode: TSCE_EDITMODE_ENUM; AChangePage: Boolean = False);
    function ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;
    function Save(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM): Boolean;
  end;

var
  FrmHotkeyEdit: TFrmHotkeyEdit;
  DelimitedList: WideString;
  SelectedItem, SelectedGroup: Integer;

const
  piFile = 0;
  piAction = 1;

implementation

uses
  uHotkeyServiceItemListWnd, SharpEListBoxEx;

{$R *.dfm}

procedure TFrmHotkeyEdit.cmdbrowseclick(Sender: TObject);
begin
  edCommand.Text := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);
end;

procedure TFrmHotkeyEdit.InitUi(AEditMode: TSCE_EDITMODE_ENUM;
  AChangePage: Boolean = False);
var
  tmpItem: TSharpEListItem;
  tmpHotkey: THotkeyItem;
begin
  edName.OnChange := nil;
  edCommand.OnChange := nil;
  try

    case AEditMode of
      sceAdd: begin
          edName.Text := '';
          edCommand.Text := '';
          edHotkey.Text := '';

          if AChangePage then
            spEdit.Show;

          if spEdit.Visible then
            edName.SetFocus;

          FItemEdit := nil;
        end;
      sceEdit: begin

          if frmConfig.lbHotkeys.SelectedItem = nil then
            exit;

          tmpItem := frmConfig.lbHotkeys.SelectedItem;
          tmpHotkey := THotkeyItem(tmpItem.Data);
          FItemEdit := tmpHotkey;

          edName.Text := tmpHotkey.Name;
          edCommand.Text := tmpHotkey.Command;
          edHotkey.Text := tmpHotkey.Hotkey;

          if AChangePage then
            spEdit.Show;

          if spEdit.Visible then
            edName.SetFocus;
        end;
    end;

  finally
    edName.OnChange := UpdateEditState;
    edCommand.OnChange := UpdateEditState;

    if frmConfig.lbHotkeys.SelectedItem <> nil then begin
      CenterDefineButtonState(scbEditTab, True);
    end
    else begin
      CenterDefineButtonState(scbEditTab, False);
      CenterSelectEditTab(scbAddTab);

      edName.Text := '';
      edCommand.Text := '';
      edHotkey.Text := '';
    end;
  end;
end;

function TFrmHotkeyEdit.ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := False;

  case AEditMode of
    sceAdd, sceEdit: begin

        errorinc.BeginUpdate;
        try
          errorinc.ClearErrors;
          vals.ValidationSummary := nil;

          Result := vals.Validate;
        finally
          errorinc.EndUpdate;
        end;
      end;
    sceDelete: Result := True;
  end;
end;

function TFrmHotkeyEdit.Save(AApply: Boolean;
  AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  tmpItem: TSharpEListItem;
  tmpHotkey: THotkeyItem;
begin
  Result := false;
  if not (AApply) then
    Exit;

  case AEditMode of
    sceAdd: begin
        FHotkeyList.Add(edHotkey.Text, edCommand.Text, edName.Text);
        CenterDefineSettingsChanged;

        frmConfig.RefreshHotkeys;
        FHotkeyList.Save;

        Result := True;
      end;
    sceEdit: begin
        tmpItem := frmConfig.lbHotkeys.Item[frmConfig.lbHotkeys.ItemIndex];
        tmpHotkey := THotkeyItem(tmpItem.Data);
        tmpHotkey.Name := edName.Text;
        tmpHotkey.Hotkey := edHotkey.Text;
        tmpHotkey.Command := edCommand.Text;

        CenterDefineSettingsChanged;
        frmConfig.RefreshHotkeys;
        FHotkeyList.Save;

        Result := True;
      end;
  end;
end;

procedure TFrmHotkeyEdit.UpdateEditState(Sender: TObject);
begin
  CenterDefineEditState(True);
end;

procedure TFrmHotkeyEdit.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TFrmHotkeyEdit.edHotkeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateEditState(nil);
end;

procedure TFrmHotkeyEdit.valNameExistsValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  idx: Integer;
  s: string;
begin
  Valid := True;

  s := '';
  if ValueToValidate <> null then
    s := VarToStr(ValueToValidate);

  if s = '' then begin
    Valid := False;
    Exit;
  end;

  idx := FHotkeyList.IndexOfName(s);

  if (idx <> -1) then begin

    if FItemEdit <> nil then
      if FItemEdit.Name = s then
        exit;

    Valid := False;
  end;
end;

procedure TFrmHotkeyEdit.valHotkeyExistsValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  idx: Integer;
  s: string;
begin
  Valid := True;

  s := '';
  if ValueToValidate <> null then
    s := VarToStr(ValueToValidate);

  if s = '' then begin
    Valid := False;
    Exit;
  end;

  idx := FHotkeyList.IndexOfHotkey(s);

  if (idx <> -1) then begin

    if FItemEdit <> nil then
      if FItemEdit.Hotkey = s then
        exit;

    Valid := False;
  end;
end;

end.

