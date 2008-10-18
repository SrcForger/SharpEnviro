{
Source Name: ThemeList
Description: Theme List Edit Window
Copyright (C) Martin Kr�mer (MartinKraemer@gmx.net)

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
  SharpThemeApi,
  uThemeListManager,
  SharpEListBoxEx,
  JclStrings,
  JvComponentBase,
  jpeg,
  JvHtControls,
  GR32_Image,

  ISharpCenterHostUnit;

type
  TfrmEdit = class(TForm)
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
    valThemeDirNotExists: TJvCustomValidator;
    procedure valThemeDirNotExistsValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure cbBasedOnSelect(Sender: TObject);

    procedure edThemeNameKeyPress(Sender: TObject; var Key: Char);
    procedure btnConfigureClick(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    { Private declarations }
  public
    { Public declarations }
    function ValidateWindow: Boolean;
    procedure ClearValidation;

    function InitUi: Boolean;
    function SaveUi(AApply: Boolean): Boolean;

    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
  end;

var
  frmEdit: TfrmEdit;

implementation

uses
  uThemeListWnd;

{$R *.dfm}

procedure TfrmEdit.edThemeNameKeyPress(Sender: TObject; var Key: Char);
begin
  PluginHost.Editing := True;
end;

function TfrmEdit.InitUi: Boolean;
var
  df: TSC_DEFAULT_FIELDS;
  tmpItem: TSharpEListItem;
  tmpThemeItem: TThemeListItem;
begin
  Result := False;
  case FPluginHost.EditMode of
    sceAdd: begin
        pagAdd.Show;

        CenterReadDefaults(df);
        edAuthor.Text := df.Author;
        edName.Text := '';
        edWebsite.Text := df.Website;

        cbBasedOn.Items.Clear;
        cbBasedOn.Items.AddObject('New Theme', nil);

        //XmlGetThemeList(TStringList(cbBasedOn.Items));

        cbBasedOn.ItemIndex := 0;
        cbBasedOn.Enabled := True;

        edName.Enabled := True;

        if ((Visible) and (edName.Enabled)) then
          edName.SetFocus;

        Result := True;
      end;
  sceEdit: begin

      if frmList.lbThemeList.ItemIndex <> -1 then begin
        tmpItem := frmList.lbThemeList.Item[frmList.lbThemeList.ItemIndex];
        tmpThemeItem := TThemeListItem(tmpItem.Data);

        edName.Text := tmpThemeItem.Name;
        edAuthor.Text := tmpThemeItem.Author;
        edWebsite.Text := tmpThemeItem.Website;
        edName.SetFocus;

        cbBasedOn.Items.Clear;
        cbBasedOn.Items.AddObject('Not Applicable',nil);

        cbBasedOn.Enabled := False;

        Result := True;
      end;
    end;
  end;
end;

function TfrmEdit.SaveUi(AApply:Boolean): Boolean;
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

  case FPluginHost.EditMode of
    sceAdd: begin
        sName := edName.Text;
        sAuthor := edAuthor.Text;
        sWebsite := edWebsite.Text;

        sTemplate := '';
        if cbBasedOn.ItemIndex <> 0 then
          sTemplate := cbBasedOn.text;

        df.Author := sAuthor;
        df.Website := sWebsite;
        CenterWriteDefaults(df);
        frmList.ThemeManager.Add(sName, sAuthor, sWebsite, sTemplate);

        frmList.EditTheme(sName);
        exit;
      end;
    sceEdit: begin
      tmpThemeItem := TThemeListItem(frmList.lbThemeList.SelectedItem.Data);

      frmList.ThemeManager.Edit(tmpThemeItem.Name,edName.Text,
        edAuthor.Text, edWebsite.Text);

      frmList.lbThemeList.Invalidate;
    end;

  end;

  frmList.BuildThemeList;
end;

function TfrmEdit.ValidateWindow: Boolean;
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

procedure TfrmEdit.btnConfigureClick(Sender: TObject);
begin
  frmList.ConfigureItem;
end;

procedure TfrmEdit.cbBasedOnSelect(Sender: TObject);
begin
  FPluginHost.Editing := True;
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

procedure TfrmEdit.valThemeDirNotExistsValidate(Sender: TObject;
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

