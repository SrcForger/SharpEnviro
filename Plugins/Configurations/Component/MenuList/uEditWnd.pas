{
Source Name: uEditWnd.pas
Description: Menu list edit window
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
  JvExControls,

  // JCL
  jclStrings,
  SharpApi,
  SharpCenterApi,

  SharpEListBox,
  SharpEListBoxEx,

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

  ISharpCenterHostUnit;

type
  TfrmEdit = class(TForm)
    vals: TJvValidators;
    valName: TJvRequiredFieldValidator;
    pilError: TPngImageList;
    errorinc: TJvErrorIndicator;
    valNameExists: TJvCustomValidator;
    edName: TLabeledEdit;
    cbBasedOn: TComboBox;
    JvLabel1: TJvLabel;

    procedure valNameExistsValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure edHotkeyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpdateEditState(Sender: TObject);
    procedure editStateEvent(Sender: TObject);

  private
    { Private declarations }
    FUpdating: Boolean;
    FPluginHost: TInterfacedSharpCenterHostBase;
  public
    { Public declarations }
    SelectedText: string;
    procedure InitUi(AChangePage: Boolean = False);
    function ValidateEdit: Boolean;
    procedure ClearValidation;
    function Save(AApply: Boolean): Boolean;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;

  end;

var
  frmEdit: TfrmEdit;
  DelimitedList: WideString;
  SelectedItem, SelectedGroup: Integer;

const
  piFile = 0;
  piAction = 1;

implementation

uses
  uListWnd;

{$R *.dfm}

procedure TfrmEdit.InitUi(AChangePage: Boolean = False);
var
  tmpItem: TSharpEListItem;
  tmpMenuItem: TMenuDataObject;
  i: Integer;
begin
  FUpdating := True;
  try

    case PluginHost.EditMode of
      sceAdd: begin
          edName.Text := '';

          //
          cbBasedOn.Clear;
          for i := 0 to Pred(frmList.lbItems.Count) do begin
            tmpMenuItem := TMenuDataObject(frmList.lbItems.Item[i].Data);
            cbBasedOn.Items.AddObject(tmpMenuItem.Name, tmpMenuItem);
          end;

          cbBasedOn.Enabled := True;
          edName.SetFocus;
        end;
      sceEdit: begin

          if frmList.lbItems.SelectedItem = nil then
            exit;

          tmpItem := frmList.lbItems.SelectedItem;
          tmpMenuItem := TMenuDataObject(tmpItem.Data);

          edName.Text := tmpMenuItem.Name;
          cbBasedOn.Enabled := False;
        end;
    end;

  finally
    FUpdating := False;
  end;
end;

function TfrmEdit.ValidateEdit: Boolean;
begin
  Result := False;

  case PluginHost.EditMode of
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

function TfrmEdit.Save(AApply: Boolean ): Boolean;
var
  tmpItem: TSharpEListItem;
  tmpMenuItem: TMenuDataObject;
  sNewFile, sOldFile, sMenuDir: string;
begin
  Result := false;
  if not (AApply) then
    Exit;

  case PluginHost.EditMode of
    sceAdd: begin
        frmList.Save(edName.Text, cbBasedOn.Text);
        Result := True;
        frmList.EditMenu(edName.Text);
        
        Exit;
      end;
    sceEdit: begin

        if frmList.lbItems.SelectedItem = nil then
          exit;

        tmpItem := frmList.lbItems.SelectedItem;
        tmpMenuItem := TMenuDataObject(tmpItem.Data);

        sMenuDir := GetSharpeUserSettingsPath + 'SharpMenu\';

        sOldFile := tmpMenuItem.FileName;
        sNewFile := sMenuDir + trim(StrRemoveChars(edName.Text,
          ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']) + '.xml');

        if CompareText(sOldFile,sNewFile) <> 0 then
          RenameFile(sOldFile,sNewFile);

        Result := True;
      end;
  end;

  frmList.RenderItems;
  PluginHost.Refresh(rtAll);
end;

procedure TfrmEdit.UpdateEditState(Sender: TObject);
begin
  PluginHost.SetEditing(True);
end;

procedure TfrmEdit.ClearValidation;
begin
  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEdit.edHotkeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateEditState(nil);
end;

procedure TfrmEdit.editStateEvent(Sender: TObject);
begin
  if not (FUpdating) then
    PluginHost.SetEditing(True);
end;

procedure TfrmEdit.valNameExistsValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  bExistsName: Boolean;
  sName, sMenuDir: string;

  tmpItem: TSharpEListItem;
  tmpMenuItem: TMenuDataObject;
begin
  sName := trim(StrRemoveChars(ValueToValidate,
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
  sMenuDir := GetSharpeUserSettingsPath + 'SharpMenu\';

  bExistsName := FileExists(sMenuDir + sName + '.xml');
  if (PluginHost.EditMode = sceEdit) then begin
    tmpItem := frmList.lbItems.SelectedItem;
    tmpMenuItem := TMenuDataObject(tmpItem.Data);

    if (CompareText(edName.Text, tmpMenuItem.Name) = 0) then
      bExistsName := False;
  end;

  Valid := not (bExistsName);
end;

end.

