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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SharpeColorEditorEx, ContNrs, Buttons, PngBitBtn,
  GraphicsFx, pngimage, JvExStdCtrls, JvEdit, GR32_Image, BarPreview, GR32,
  uSchemeList, PngImageList,
  SharpELabel, SharpERoundPanel, PngSpeedButton, ImgList, JvShape, JclIniFiles,
  SharpApi, SharpCenterApi, SharpThemeApi, SharpESwatchManager, SharpECenterScheme,
  SharpEColorEditor;

type
  TfrmEditScheme = class(TForm)
    edName: TLabeledEdit;
    edAuthor: TLabeledEdit;
    pnlContainer: TPanel;
    SharpESwatchManager1: TSharpESwatchManager;
    SharpECenterScheme1: TSharpECenterScheme;
    SharpERoundPanel1: TSharpERoundPanel;
    secEx: TSharpEColorEditorEx;
    procedure secExUiChange(Sender: TObject);
    procedure secExSliderChange(Sender: TObject);

    procedure FormShow(Sender: TObject);
    procedure secExChangeValue(ASender: TObject; AValue: Integer);
    procedure edNameKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

    procedure FormCreate(Sender: TObject);
  private
    FColors: TObjectList;
    FSchemeItem: TSchemeItem;
    FSelectedColorIdx: Integer;
    FEdit: Boolean;
    procedure SetColors(const Value: TObjectList);

    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    property Edit: Boolean read FEdit write FEdit;
    property SchemeItem: TSchemeItem read FSchemeItem write FSchemeItem;
    property Colors: TObjectList read FColors write SetColors;

    procedure InitUI(AEditMode: TSCE_EditMode_Enum);
    function ValidateEdit(AEditMode: TSCE_EditMode_Enum): Boolean;
    function Save(AEditMode: TSCE_EditMode_Enum; AApply: Boolean): Boolean;
  end;

var
  frmEditScheme: TfrmEditScheme;

implementation

uses JclStrings, uSchemeListWnd;

{$R *.dfm}

procedure TfrmEditScheme.SetColors(const Value: TObjectList);
var
  tmpItem: TSchemeColorItem;
  tmpSkinColor: TSharpESkinColor;

  i: Integer;
  h: Integer;
begin
  FColors := Value;
  h := 0;
  LockWindowUpdate(Self.Handle);
  try
    secEx.BeginUpdate;
    secEx.Items.Clear;
    
    for i := 0 to Pred(FColors.Count) do
    begin
      tmpItem := TSchemeColorItem(FColors[i]);
      tmpSkinColor := FSchemeManager.GetSkinColorByTag(tmpItem.Tag);

      with secEx.Items.Add(Self) do
      begin
        Title := tmpSkinColor.Name;
        ColorCode := tmpItem.Color;
        Tag := Integer(tmpItem);

        if tmpSkinColor.schemetype = stInteger then
          ValueEditorType := vetValue
        else
          ValueEditorType := vetColor;

        Visible := True;
        Value := tmpItem.Color;
        Description := tmpSkinColor.Info + ':';
        ValueText := tmpSkinColor.Name;
      end;

    end;

  finally

    secEx.EndUpdate;

    if FColors.Count <> 0 then
      h := 3 * secEx.Items.Item[0].ColorEditor.CollapseHeight
        +
        secEx.Items.Item[0].ColorEditor.ExpandedHeight;

    Self.Height := h+10;
    LockWindowUpdate(0);
  end;

end;

procedure TfrmEditScheme.FormCreate(Sender: TObject);
begin
  FSelectedColorIdx := 0;

  if not (FEdit) then
  begin
    if FileExists(GetSharpeUserSettingsPath + 'author.dat') then
      edAuthor.Text := IniReadString(GetSharpeUserSettingsPath + 'author.dat',
        'main', 'author');
  end;

end;

procedure TfrmEditScheme.InitUI(AEditMode: TSCE_EditMode_Enum);
var
  tmpItem, lstItem: TSchemeItem;
begin

  case AEditMode of
    sceAdd:
      begin

        tmpItem := TSchemeItem.Create(nil);
        tmpItem.Name := '';
        tmpItem.Author := '';
        tmpItem.LoadSkinColorDefaults(FSchemeManager.Theme);

        edName.Text := '';
        edAuthor.Text := '';

        Colors := tmpItem.Colors;
        SchemeItem := tmpItem;
        Edit := False;
      end;
    sceEdit:
      begin

        lstItem := TSchemeItem(frmSchemeList.lbSchemeList.
          Item[frmSchemeList.lbSchemeList.ItemIndex].Data);

        tmpItem := TSchemeItem.Create(nil);
        tmpItem.Name := lstItem.Name;
        tmpItem.Author := lstItem.Author;
        lstItem.Assign(tmpItem.Colors);

        edName.Text := tmpItem.Name;
        edAuthor.Text := tmpItem.Author;

        Colors := tmpItem.Colors;
        SchemeItem := tmpItem;
        Edit := True;

      end;
    sceDelete:
      begin

      end;
  end; 
end;

function TfrmEditScheme.ValidateEdit(AEditMode: TSCE_EditMode_Enum): Boolean;
var
  bInvalidAuthor, bExistsName: Boolean;
  sName, sSkinDir, sSchemeDir: String;
begin
  sName := trim(StrRemoveChars(edName.Text,
      ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
  sSkinDir := GetSharpeDirectory + 'skins';
  sSchemeDir := Format('%s\%s\schemes\', [sSkinDir, FSchemeManager.GetSkinName]);

  bExistsName := FileExists(sSchemeDir+sName+'.xml');
  if ((CompareText(edName.Text, SchemeItem.Name) = 0) and (AEditMode = sceEdit))
    then
    bExistsName := False;

  bInvalidAuthor := (edAuthor.Text = '');

  Result := not ((bExistsName = True) or (bInvalidAuthor = True));
end;

function TfrmEditScheme.Save(AEditMode: TSCE_EditMode_Enum;
  AApply: Boolean): Boolean;
var
  lstItem: TSchemeItem;
begin
  Result := True;
  if Not(AApply) then exit;

  case AEditMode of
    sceAdd:
      begin

        FSchemeItem.Name := edName.Text;
        FSchemeItem.Author := edAuthor.Text;
        FSchemeItem.Save;
        FSchemeItem.Free;

        Result := True;
        frmSchemeList.UpdateEditTabs;
        SharpEBroadCast(WM_SHARPEUPDATESETTINGS,Integer(suScheme),0);

      end;
    sceEdit:
      begin

        if AApply then
        begin

          lstItem := TSchemeItem(frmSchemeList.lbSchemeList.
            Item[frmSchemeList.lbSchemeList.ItemIndex].Data);

          lstItem.Name := edName.Text;
          lstItem.Author := edAuthor.Text;
          FSchemeItem.Assign(lstItem.Colors);
          lstItem.Save;
        end;

        Result := True;
        frmSchemeList.UpdateEditTabs;
        SharpEBroadCast(WM_SHARPEUPDATESETTINGS,Integer(suScheme),0);
      end;
  end;
end;

procedure TfrmEditScheme.edNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CenterDefineEditState(True);
end;

procedure TfrmEditScheme.secExChangeValue(ASender: TObject;
  AValue: Integer);
var
  tmpItem: TSchemeColorItem;
begin
  tmpItem := TSchemeColorItem(TSharpEColorEditorExItem(ASender).Tag);

  if TSharpEColorEditorExItem(ASender).ValueEditorType = vetColor then
  begin
    tmpItem.Color := AValue;
    tmpItem.UnparsedColor := ColorToString(AValue);
  end
  else
  begin
    tmpItem.Color := AValue;
    tmpItem.UnparsedColor := '';
  end; 
end;

procedure TfrmEditScheme.FormShow(Sender: TObject);
begin
  edName.SetFocus;
end;

procedure TfrmEditScheme.secExSliderChange(Sender: TObject);
begin
  CenterUpdatePreview;
  CenterDefineEditState(True);
end;

procedure TfrmEditScheme.secExUiChange(Sender: TObject);
begin
  CenterUpdatePreview;
  CenterDefineEditState(True);
end;

end.

