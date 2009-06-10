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
  ISharpCenterHostUnit,
  JvExControls,
  JclStrings,
  JvLabel,
  SharpApi,
  SharpEListBoxEx,
  JvXPCore,
  JvXPCheckCtrls;

type
  TfrmEdit = class(TForm)
    edName: TLabeledEdit;
    cbBasedOn: TComboBox;
    JvLabel1: TJvLabel;
    chkOverride: TJvXPCheckbox;
    chkEnableIcons: TJvXPCheckbox;
    chkEnableGeneric: TJvXPCheckbox;
    chkDisplayExtensions: TJvXPCheckbox;

    procedure edHotkeyKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure UpdateEditState(Sender: TObject);
    procedure editStateEvent(Sender: TObject);
    procedure chkOverrideClick(Sender: TObject);

  private
    { Private declarations }
    FUpdating: Boolean;
    FPluginHost: ISharpCenterHost;
    procedure UpdateOverrideState;
  public
    { Public declarations }
    SelectedText: string;
    procedure InitUi;
    procedure Save;

    property PluginHost: ISharpCenterHost read FPluginHost write
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

procedure TfrmEdit.InitUi;
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

          chkOverride.Checked := False;
          chkEnableIcons.Checked := False;
          chkEnableGeneric.Checked := False;
          chkDisplayExtensions.Checked := False;
        end;
      sceEdit: begin

          if frmList.lbItems.SelectedItem = nil then
            exit;

          tmpItem := frmList.lbItems.SelectedItem;
          tmpMenuItem := TMenuDataObject(tmpItem.Data);

          edName.Text := tmpMenuItem.Name;
          cbBasedOn.Enabled := False;

          chkOverride.Checked := tmpMenuItem.OverrideOptions;
          if tmpMenuItem.OverrideOptions then begin
            chkEnableIcons.Checked := tmpMenuItem.EnableIcons;
            chkEnableGeneric.Checked := tmpMenuItem.EnableGeneric;
            chkDisplayExtensions.Checked := tmpMenuItem.DisplayExtensions;
          end;

          UpdateOverrideState;

        end;
    end;

  finally
    FUpdating := False;
  end;
end;

procedure TfrmEdit.UpdateOverrideState;
begin
  chkEnableGeneric.Visible := chkOverride.Checked;
  chkEnableIcons.Visible := chkOverride.Checked;
  chkDisplayExtensions.Visible := chkOverride.Checked;
end;

procedure TfrmEdit.Save;
var
  tmpItem: TSharpEListItem;
  tmpMenuItem: TMenuDataObject;
  sNewFile, sOldFile, sMenuDir, sFilename: string;
begin
  case PluginHost.EditMode of
    sceAdd: begin
        sFilename := frmList.Save(edName.Text, cbBasedOn.Text);
        
        frmList.SaveMenuOptions(sFileName, chkOverride.Checked, chkEnableIcons.Checked,
          chkEnableGeneric.Checked, chkDisplayExtensions.Checked);
          
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

        if CompareText(sOldFile, sNewFile) <> 0 then
          RenameFile(sOldFile, sNewFile);

        tmpMenuItem.OverrideOptions := chkOverride.Checked;
        tmpMenuItem.EnableIcons := chkEnableIcons.Checked;
        tmpMenuItem.EnableGeneric := chkEnableGeneric.Checked;
        tmpMenuItem.DisplayExtensions := chkDisplayExtensions.Checked;

        frmList.SaveMenuOptions(sNewFile,tmpMenuItem);
      end;
  end;

  frmList.RenderItems;
  PluginHost.Refresh(rtAll);
end;

procedure TfrmEdit.UpdateEditState(Sender: TObject);
begin
  if not (FUpdating) then
    PluginHost.SetEditing(True);
end;

procedure TfrmEdit.chkOverrideClick(Sender: TObject);
begin
  UpdateEditState(nil);
  UpdateOverrideState;
end;

procedure TfrmEdit.edHotkeyKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateEditState(nil);
end;

procedure TfrmEdit.editStateEvent(Sender: TObject);
begin
  UpdateEditState(nil);
end;

end.

