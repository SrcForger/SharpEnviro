{
Source Name: ThemeList
Description: Theme List Edit Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uThemeListEditWnd;

interface

uses
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
  JvExControls,
  JvComponent,
  JvLabel,
  ImgList,
  PngImageList,
  JvExStdCtrls,
  JvValidators,
  JvErrorIndicator,
  ExtCtrls,
  JvPageList,
  SharpApi,
  SharpCenterApi,
  uThemeListManager,
  SharpEListBoxEx,
  JclStrings,
  JvComponentBase,
  jpeg,
  JvHtControls,
  GR32_Image;

type
  TfrmEditItem = class(TForm)
    vals: TJvValidators;
    valThemeName: TJvRequiredFieldValidator;
    errorinc: TJvErrorIndicator;
    valThemeAuthor: TJvRequiredFieldValidator;
    pilError: TPngImageList;
    plEdit: TJvPageList;
    pagAdd: TJvStandardPage;
    edName: TLabeledEdit;
    edAuthor: TLabeledEdit;
    edWebsite: TLabeledEdit;
    Label3: TJvLabel;
    cbBasedOn: TComboBox;
    pagDelete: TJvStandardPage;
    Label2: TLabel;
    Label1: TJvLabel;
    valThemeDirNotExists: TJvCustomValidator;
    procedure valThemeDirNotExistsValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure cbBasedOnSelect(Sender: TObject);

    procedure edThemeNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnConfigureClick(Sender: TObject);
  private
    FEditMode: TSCE_EDITMODE_ENUM;
    { Private declarations }
  public
    { Public declarations }
    function ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;

    function InitUi(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    function SaveUi(AApply: Boolean; AEditMode: TSCE_EDITMODE_ENUM): Boolean;

    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;

  end;

var
  frmEditItem: TfrmEditItem;

implementation

uses
  uThemeListWnd;

{$R *.dfm}

procedure TfrmEditItem.edThemeNameKeyPress(Sender: TObject; var Key: Char);
begin
  CenterDefineEditState(True);

end;

function TfrmEditItem.InitUi(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  df: TSC_DEFAULT_FIELDS;
  tmpItem: TSharpEListItem;
  tmpThemeItem: TThemeListItem;
begin
  Result := False;
  case AEditMode of
    sceAdd: begin
        frmEditItem.pagAdd.Show;

        CenterReadDefaults(df);
        FrmEditItem.edAuthor.Text := df.Author;
        FrmEditItem.edName.Text := '';
        frmEditItem.edWebsite.Text := df.Website;

        frmEditItem.cbBasedOn.Items.Clear;
        frmEditItem.cbBasedOn.Items.AddObject('New Theme', nil);
        frmThemeList.ThemeManager.GetThemeList(frmEditItem.cbBasedOn.Items);
        frmEditItem.cbBasedOn.ItemIndex := 0;
        frmEditItem.cbBasedOn.Enabled := True;

        frmEditItem.edName.Enabled := True;

        if ((frmEditItem.Visible) and (frmEditItem.edName.Enabled)) then
          FrmEditItem.edName.SetFocus;

        Result := True;
      end;
  sceEdit: begin

      if frmThemeList.lbThemeList.ItemIndex <> -1 then begin
        tmpItem := frmThemeList.lbThemeList.Item[frmThemeList.lbThemeList.ItemIndex];
        tmpThemeItem := TThemeListItem(tmpItem.Data);

        FrmEditItem.edName.Text := tmpThemeItem.Name;
        FrmEditItem.edAuthor.Text := tmpThemeItem.Author;
        frmEditItem.edWebsite.Text := tmpThemeItem.Website;
        FrmEditItem.edName.SetFocus;

        frmEditItem.cbBasedOn.Items.Clear;
        frmEditItem.cbBasedOn.Items.AddObject('Not Applicable',nil);
        frmThemeList.ThemeManager.GetThemeList(frmEditItem.cbBasedOn.Items);

        if tmpThemeItem.Template <> nil then
          frmEditItem.cbBasedOn.ItemIndex := frmEditItem.cbBasedOn.Items.IndexOfObject(Pointer(tmpThemeItem.Template)) else
          frmEditItem.cbBasedOn.ItemIndex := 0;

        frmEditItem.cbBasedOn.Enabled := False;

        Result := True;
      end;
    end;
  end;
end;

function TfrmEditItem.SaveUi(AApply: Boolean;
  AEditMode: TSCE_EDITMODE_ENUM): Boolean;
var
  sAuthor: string;
  sWebsite: string;
  sTemplate: string;
  sName: string;
  df: TSC_DEFAULT_FIELDS;
  tmpThemeItem: TThemeListItem;
begin
  Result := True;

  if not (AApply) then
    exit;

  case AEditMode of
    sceAdd: begin
        sName := frmEditItem.edName.Text;
        sAuthor := frmEditItem.edAuthor.Text;
        sWebsite := frmEditItem.edWebsite.Text;

        sTemplate := '';
        if frmEditItem.cbBasedOn.ItemIndex <> 0 then
          sTemplate := frmEditItem.cbBasedOn.text;

        df.Author := sAuthor;
        df.Website := sWebsite;
        CenterWriteDefaults(df);
        frmThemeList.ThemeManager.Add(sName, sAuthor, sWebsite, sTemplate);
      end;
    sceEdit: begin
      tmpThemeItem := TThemeListItem(frmThemeList.lbThemeList.SelectedItem.Data);

      frmThemeList.ThemeManager.Edit(tmpThemeItem.Name,frmEditItem.edName.Text,
        frmEditItem.edAuthor.Text, frmEditItem.edWebsite.Text);

      frmThemeList.lbThemeList.Invalidate;
    end;

  end;

  frmThemeList.BuildThemeList;
end;

function TfrmEditItem.ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
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

procedure TfrmEditItem.btnConfigureClick(Sender: TObject);
begin
  frmThemeList.ConfigureItem;
end;

procedure TfrmEditItem.cbBasedOnSelect(Sender: TObject);
begin
  CenterDefineEditState(True);
  frmThemeList.lbThemeList.Enabled := False;
end;

procedure TfrmEditItem.ClearValidation;
begin

  errorinc.BeginUpdate;
  try
    errorinc.ClearErrors;
  finally
    errorinc.EndUpdate;
  end;
end;

procedure TfrmEditItem.valThemeDirNotExistsValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  sValidName, sThemeDir: string;
begin
  Valid := True;

  sValidName := trim(StrRemoveChars(string(ValueToValidate),
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));

  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';
  if DirectoryExists(sThemeDir + sValidName) then
    Valid := False;

end;

end.

