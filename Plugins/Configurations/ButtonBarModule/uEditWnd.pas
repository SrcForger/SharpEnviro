{
Source Name: uEditWnd.pas
Description: <Type> Items Edit window
Copyright (C) <Author> (<Email>)

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
  Forms,
  Variants,
  Classes,
  ImgList,
  Controls,
  Graphics,

  // SharpE
  SharpApi,
  SharpCenterApi,

  // Jedi
  JvExControls,
  JvErrorIndicator,
  JvValidators,
  JvComponentBase,

  // PngImage
  PngImageList, Buttons, PngSpeedButton, StdCtrls, ExtCtrls, SharpEListBoxEx, ButtonBarList, SharpDialogs;

type
  TfrmEdit = class(TForm)
    vals: TJvValidators;
    pilError: TPngImageList;
    eiVals: TJvErrorIndicator;
    edName: TLabeledEdit;
    edCommand: TLabeledEdit;
    btnCommandBrowse: TPngSpeedButton;
    edIcon: TLabeledEdit;
    btnIconBrowse: TPngSpeedButton;
    JvRequiredFieldValidator1: TJvRequiredFieldValidator;
    JvRequiredFieldValidator2: TJvRequiredFieldValidator;
    JvRequiredFieldValidator3: TJvRequiredFieldValidator;

    procedure UpdateEditState(Sender: TObject);
    procedure btnCommandBrowseClick(Sender: TObject);
    procedure btnIconBrowseClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
    FUpdating: Boolean;
    FEditMode: TSCE_EDITMODE_ENUM;
    FItemEdit: TButtonBarItem;
    FModuleId: string;
    FBarId: string;
  public
    { Public declarations }

    procedure InitUi(AEditMode: TSCE_EDITMODE_ENUM; AChangePage: Boolean = False);
    function ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;
    function Save(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM): Boolean;

    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;

    property BarId: string read FBarId write FBarId;
    property ModuleId: string read FModuleId write FModuleId;
  end;

var
  frmEdit: TfrmEdit;

implementation

uses
  uListWnd;

{$R *.dfm}

procedure TfrmEdit.InitUi(AEditMode: TSCE_EDITMODE_ENUM;
  AChangePage: Boolean = False);
var
  tmpItem: TSharpEListItem;
  tmp: TButtonBarItem;
begin
  FUpdating := True;
  try

    case AEditMode of
      sceAdd: begin
          edName.Text := '';
          edCommand.Text := '';
          edIcon.Text := '';
        end;
      sceEdit: begin
          if frmList.lbItems.SelectedItem = nil then
            exit;

          tmpItem := frmList.lbItems.SelectedItem;
          tmp := TButtonBarItem(tmpItem.Data);
          FItemEdit := tmp;

          edName.Text := tmp.Name;
          edCommand.Text := tmp.Command;
          edIcon.Text := tmp.Icon;
          edName.SetFocus;
        end;
    end;

  finally
    FUpdating := False;
  end;
end;

procedure TfrmEdit.btnCommandBrowseClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,
                                 ClientToScreen(point(btnCommandBrowse.Left,btnCommandBrowse.Top)));
  if length(trim(s))>0 then
  begin
    edCommand.Text := s;
  end;
end;

procedure TfrmEdit.btnIconBrowseClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.IconDialog(edIcon.Text,
                               SMI_ALL_ICONS,
                               ClientToScreen(point(btnIconBrowse.Left,btnIconBrowse.Top)));
  if length(trim(s))>0 then
  begin
    edIcon.Text := s;
  end;
end;

procedure TfrmEdit.ClearValidation;
begin
  eiVals.BeginUpdate;
  try
    eiVals.ClearErrors;
  finally
    eiVals.EndUpdate;
  end;
end;

procedure TfrmEdit.FormShow(Sender: TObject);
begin
  Self.DoubleBuffered := True;
end;

function TfrmEdit.ValidateEdit(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := False;

  case AEditMode of
    sceAdd, sceEdit: begin

        eiVals.BeginUpdate;
        try
          eiVals.ClearErrors;
          vals.ValidationSummary := nil;

          Result := vals.Validate;
        finally
          eiVals.EndUpdate;
        end;
      end;
    sceDelete: Result := True;
  end;
end;

function TfrmEdit.Save(AApply: Boolean;
  AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  tmpItem: TSharpEListItem;
  tmp: TButtonBarItem;
begin
  Result := false;
  if not (AApply) then
    Exit;

  case AEditMode of
    sceAdd: begin
        frmList.Items.AddButtonItem( edName.Text, edCommand.Text, edIcon.Text);
        CenterDefineSettingsChanged;

        frmList.Items.Save;
        Result := True;
      end;
    sceEdit: begin
        tmpItem := frmList.lbItems.SelectedItem;
        tmp := TButtonBarItem(tmpItem.Data);
        tmp.Name := edName.Text;
        tmp.Command := edCommand.Text;
        tmp.Icon := edIcon.Text;

        CenterDefineSettingsChanged;
        frmList.Items.Save;
        Result := True;
      end;
  end;

  LockWindowUpdate(frmList.Handle);
  try
    frmList.RenderItems;
  finally
    LockWindowUpdate(0);
  end;
  CenterUpdateConfigFull;
end;

procedure TfrmEdit.UpdateEditState(Sender: TObject);
begin
  if Not(FUpdating) then
    CenterDefineEditState(True);
end;

end.

