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

unit uEditWnd;

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
  ImgList,

  // JVCL
  JvPageList,
  JvExControls,

  // Project
  SharpEHotkeyEdit,

  // JCL
  jclStrings,
  SharpDialogs,
  SharpApi,
  SharpCenterApi,

  // PNG Image
  pngimage,
  JvComponentBase,
  JvLabel,
  PngImageList,
  PngBitBtn,
  JvExStdCtrls,
  PngSpeedButton,
  JvErrorIndicator,
  JvValidators,
  uHotkeyServiceList,

  ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TfrmEditWnd = class(TForm)
    vals: TJvValidators;
    valHotkey: TJvRequiredFieldValidator;
    valName: TJvRequiredFieldValidator;
    pilError: TPngImageList;
    errorinc: TJvErrorIndicator;
    valCommand: TJvRequiredFieldValidator;
    valNameExists: TJvCustomValidator;
    valHotkeyExists: TJvCustomValidator;
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    edHotkey: TSharpEHotkeyEdit;
    Button1: TPngSpeedButton;
    Label1: TLabel;
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
    FUpdating: Boolean;
    FPluginHost: TInterfacedSharpCenterHostBase;
  public
    { Public declarations }
    SelectedText: string;
    procedure InitUi;
    function ValidateEdit: Boolean;
    procedure ClearValidation;
    function Save(AApply: Boolean): Boolean;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmEditWnd: TfrmEditWnd;
  DelimitedList: WideString;
  SelectedItem, SelectedGroup: Integer;

const
  piFile = 0;
  piAction = 1;

implementation

uses
  uItemsWnd,
  SharpEListBoxEx;

{$R *.dfm}

procedure TfrmEditWnd.cmdbrowseclick(Sender: TObject);
begin
  edCommand.Text := SharpDialogs.TargetDialog(STI_ALL_TARGETS, Mouse.CursorPos);
end;

procedure TfrmEditWnd.InitUi;
var
  tmpItem: TSharpEListItem;
  tmpHotkey: THotkeyItem;
begin
  FUpdating := True;
  try

    case FPluginHost.EditMode of
      sceAdd: begin
          edName.Text := '';
          edCommand.Text := '';
          edHotkey.Text := '';

          FItemEdit := nil;
        end;
      sceEdit: begin

          if frmItemsWnd.lbHotkeys.SelectedItem = nil then
            exit;

          tmpItem := frmItemsWnd.lbHotkeys.SelectedItem;
          tmpHotkey := THotkeyItem(tmpItem.Data);
          FItemEdit := tmpHotkey;

          edName.Text := tmpHotkey.Name;
          edCommand.Text := tmpHotkey.Command;
          edHotkey.Text := tmpHotkey.Hotkey;
        end;
    end;

  finally
    FUpdating := False;
  end;
end;

function TfrmEditWnd.ValidateEdit: Boolean;
begin
  Result := False;

  case FPluginHost.EditMode of
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

function TfrmEditWnd.Save(AApply: Boolean): Boolean;
var
  tmpItem: TSharpEListItem;
  tmpHotkey: THotkeyItem;
begin
  Result := false;
  if not (AApply) then
    Exit;

  case FPluginHost.EditMode of
    sceAdd: begin
        FHotkeyList.AddItem(edHotkey.Text, edCommand.Text, edName.Text);


        frmItemsWnd.RefreshHotkeys;
        FHotkeyList.Save;

        Result := True;
      end;
    sceEdit: begin
        tmpItem := frmItemsWnd.lbHotkeys.Item[frmItemsWnd.lbHotkeys.ItemIndex];
        tmpHotkey := THotkeyItem(tmpItem.Data);
        tmpHotkey.Name := edName.Text;
        tmpHotkey.Hotkey := edHotkey.Text;
        tmpHotkey.Command := edCommand.Text;

        frmItemsWnd.RefreshHotkeys;
        FHotkeyList.Save;

        Result := True;
      end;
  end;

  FPluginHost.Refresh;
end;

procedure TfrmEditWnd.UpdateEditState(Sender: TObject);
begin
  if not (FUpdating) then
    FPluginHost.Editing := true;
end;

procedure TfrmEditWnd.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEditWnd.edHotkeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateEditState(nil);
end;

procedure TfrmEditWnd.valNameExistsValidate(Sender: TObject;
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

procedure TfrmEditWnd.valHotkeyExistsValidate(Sender: TObject;
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

