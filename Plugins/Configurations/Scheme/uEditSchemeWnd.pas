{
Source Name: uEditSchemeWnd
Description: Edit/Create Scheme Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit uEditSchemeWnd;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  ExtCtrls,
  SharpeColorEditorEx,
  ContNrs,
  uSchemeList,
  SharpERoundPanel,
  JclIniFiles,
  SharpApi,
  SharpCenterApi,
  SharpThemeApi,
  SharpESwatchManager,
  SharpECenterScheme,
  SharpEColorEditor, ImgList, PngImageList, JvErrorIndicator, JvComponentBase,
  JvValidators;

type
  TfrmEditScheme = class(TForm)
    edName: TLabeledEdit;
    edAuthor: TLabeledEdit;
    pnlContainer: TPanel;
    SharpECenterScheme1: TSharpECenterScheme;
    vals: TJvValidators;
    err: TJvErrorIndicator;
    PngImageList1: TPngImageList;
    valSchemeName: TJvRequiredFieldValidator;
    valSchemeUnique: TJvCustomValidator;
    valAuthor: TJvRequiredFieldValidator;
    valSchemeNameInvalidChars: TJvCustomValidator;

    procedure FormCreate(Sender: TObject);
    procedure edNameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure valSchemeUniqueValidate(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
    procedure valSchemeNameInvalidCharsValidate(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
  private
    FSchemeItem: TSchemeItem;
    FSelectedColorIdx: Integer;
    FEditMode: TSCE_EDITMODE_ENUM;

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    property SchemeItem: TSchemeItem read FSchemeItem write FSchemeItem;

    procedure InitUI(AEditMode: TSCE_EditMode_Enum);

    function Save(AEditMode: TSCE_EditMode_Enum; AApply: Boolean): Boolean;
    property EditMode: TSCE_EDITMODE_ENUM read FEditMode write FEditMode;
    function Validate: boolean;
  end;

var
  frmEditScheme: TfrmEditScheme;

implementation

uses JclStrings,
  uSchemeListWnd;

{$R *.dfm}

procedure TfrmEditScheme.edNameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CenterDefineEditState(True);
end;

procedure TfrmEditScheme.FormCreate(Sender: TObject);
begin
  FSelectedColorIdx := 0;
end;

procedure TfrmEditScheme.InitUI(AEditMode: TSCE_EditMode_Enum);
var
  tmpItem, lstItem: TSchemeItem;
  df:TSC_DEFAULT_FIELDS;
begin
  case AEditMode of
    sceAdd: begin

        CenterReadDefaults(df);
        tmpItem := TSchemeItem.Create(nil);

        edName.Text := '';
        edAuthor.Text := df.Author;
        SchemeItem := tmpItem;
      end;
    sceEdit: begin

        if frmSchemeList.lbSchemeList.SelectedItem = nil then exit;

        lstItem := TSchemeItem(frmSchemeList.lbSchemeList.SelectedItem.Data);

        tmpItem := TSchemeItem.Create(nil);
        tmpItem.Name := lstItem.Name;
        tmpItem.Author := lstItem.Author;

        edName.Text := tmpItem.Name;
        edAuthor.Text := tmpItem.Author;
        SchemeItem := tmpItem;

      end;
  end;
end;

procedure TfrmEditScheme.valSchemeNameInvalidCharsValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  s: string;
begin
  s := string(ValueToValidate);
  Valid := not (StrContainsChars(s, ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':'], False));
end;

procedure TfrmEditScheme.valSchemeUniqueValidate(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  bExistsName: Boolean;
  sName, sSkinDir, sSchemeDir: string;
begin
  sName := trim(StrRemoveChars(edName.Text,
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
  sSkinDir := GetSharpeDirectory + 'skins';
  sSchemeDir := Format('%s\%s\schemes\', [sSkinDir, XmlGetSkin(FSchemeManager.PluginID)]);

  bExistsName := FileExists(sSchemeDir + sName + '.xml');
  if ((CompareText(edName.Text, SchemeItem.Name) = 0) and (FEditMode = sceEdit)) then
    bExistsName := False;

  Valid := not (bExistsName);
end;

function TfrmEditScheme.Save(AEditMode: TSCE_EditMode_Enum;
  AApply: Boolean): Boolean;
var
  scheme: TSchemeItem;
  sOriginalName: string;
begin
  Result := True;
  if not (AApply) then
    exit;

  case AEditMode of
    sceAdd: begin

        FSchemeItem.Name := edName.Text;
        FSchemeItem.Author := edAuthor.Text;
        FSchemeManager.Save(edName.Text, edAuthor.Text);
        FSchemeItem.Free;

        Result := True;
        frmSchemeList.EditScheme(edName.Text);
        Exit;
      end;
    sceEdit: begin

        if AApply then begin

          scheme := TSchemeItem(frmSchemeList.lbSchemeList.SelectedItem.Data);
          sOriginalName := scheme.Name;

          FSchemeManager.Save(edName.Text, edAuthor.Text, sOriginalName);

          if Not(CompareText(edName.Text,sOriginalName) = 0) then
            FSchemeManager.Delete(scheme);

          scheme.Name := edName.Text;
          scheme.Author := edAuthor.Text;
        end;

        Result := True;
        SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(suScheme), 0);
      end;
  end;

  frmSchemeList.RebuildSchemeList;
end;

function TfrmEditScheme.Validate: boolean;
begin
  err.BeginUpdate;
  try
    err.ClearErrors;
    vals.ValidationSummary := nil;
    Result := vals.Validate;
  finally
    err.EndUpdate;
  end;
end;

end.

