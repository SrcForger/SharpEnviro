{
Source Name: ThemeList
Description: Theme List Edit Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

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

unit uThemeListEditWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExControls, JvComponent, JvLabel, ImgList,
  PngImageList, JvExStdCtrls, JvEdit, JvValidateEdit, JvValidators,
  JvErrorIndicator, ExtCtrls, JvPageList, SharpApi, SharpCenterApi,
  uThemeListManager, JclStrings, JvComponentBase, jpeg, JvHtControls, GR32_Image,
  JvLinkLabel;

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
    pagEdit: TJvStandardPage;
    btnConfigure: TButton;
    img: TImage;
    lblName: TLabel;
    lblSite: TJvLabel;
    procedure valThemeDirNotExistsValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
    procedure cbBasedOnSelect(Sender: TObject);

    procedure edThemeNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure btnConfigureClick(Sender: TObject);
    procedure lblSiteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
    procedure ClearValidation;

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

procedure TfrmEditItem.FormShow(Sender: TObject);
begin
  lblSite.Font.Style := [fsUnderline];
  lblSite.font.Color := clNavy;
end;

procedure TfrmEditItem.lblSiteClick(Sender: TObject);
begin
  SharpExecute(lblSite.Caption);
end;

function TfrmEditItem.ValidateWindow(AEditMode: TSCE_EDITMODE_ENUM): Boolean;
begin
  Result := False;

  case AEditMode of
    sceAdd, sceEdit:
      begin
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

