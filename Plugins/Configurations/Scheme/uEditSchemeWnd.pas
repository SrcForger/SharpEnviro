{
Source Name: uEditSchemeWnd
Description: Edit/Create Scheme Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
 - OS : Windows 2000 or higher

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
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
  private
    FColors: TObjectList;
    FAuthor: string;
    FName: string;
    FSchemeName: string;
    FSchemeItem: TSchemeItem;
    FSkinName: string;
    FSelectedColorIdx: Integer;
    FEdit: Boolean;
    FUpdateEditState: Boolean;

    procedure SetColors(const Value: TObjectList);

    function GetSchemeName: string;
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

procedure TfrmEditScheme.btn_cancelClick(Sender: TObject);
begin
  modalresult := mrCancel;
end;

procedure TfrmEditScheme.btn_okClick(Sender: TObject);
begin
  {if length(trim(StrRemoveChars(edit_name.Text,['"','<','>','|','/','\','*','?','.',':']))) <=0 then
  begin
    Showmessage('Please enter a valid scheme name first');
    exit;
  end;
  modalresult := mrOk;   }
end;

procedure TfrmEditScheme.SetColors(const Value: TObjectList);
var
  //tmpLabel: TJvHtLabel;
  tmpEdit: TEdit;
  tmpItem: TSchemeColorItem;
  tmpSkinColor: TSharpESkinColor;
  tmpPanel: TPanel;

  colBkg: TColor;
  i: Integer;
  h, h2: Integer;
begin
  FColors := Value;

  LockWindowUpdate(Self.Handle);
  try
    secEx.BeginUpdate;
    secEx.Items.Clear;
    h := 0;
    for i := 0 to Pred(FColors.Count) do
    begin
      tmpItem := TSchemeColorItem(FColors[i]);
      tmpSkinColor := frmSchemeList.SchemeItems.GetSkinColorByTag(tmpItem.Tag);

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
      h := (FColors.Count - 1) * secEx.Items.Item[0].ColorEditor.CollapseHeight
        +
        secEx.Items.Item[0].ColorEditor.ExpandedHeight;

    Self.Height := h + 70;
    LockWindowUpdate(0);
  end;

end;

procedure TfrmEditScheme.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  tmpSchemeItem: TSchemeItem;
  bExists: Boolean;

begin
  if Self.ModalResult <> mrCancel then
  begin
    // Check if exists
    bExists := frmSchemeList.SchemeItems.IndexOfSkinName(edName.Text) <> -1;

    if not (FEdit) then
    begin
      if bExists then
        CanClose := False
      else
        CanClose := True;
    end
    else
    begin
      if bExists = False then
        Canclose := True
      else if
        CompareText(frmSchemeList.lbSchemeList.Item[frmSchemeList.lbSchemeList.ItemIndex].SubItemText[0],
        edName.Text) = 0 then
        CanClose := True
      else
        CanClose := False;
    end;

    if not (FEdit) then
      IniWriteString(GetSharpeUserSettingsPath + 'author.dat', 'main', 'author',
        edAuthor.Text);
  end
  else
    MessageDlg('You have entered a duplicate FTheme name' + #13 + #10 +
      'Please choose another name', mtError, [mbOK], 0);
end;

function TfrmEditScheme.GetSchemeName: string;
begin
  Result := FSchemeName;
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
  tmpSchemeItems: TSchemeList;
  sTheme: string;
begin
  sTheme := frmSchemeList.Theme;
  tmpSchemeItems := frmSchemeList.SchemeItems;

  case AEditMode of
    sceAdd:
      begin

        tmpItem := TSchemeItem.Create(frmSchemeList.SchemeItems);
        tmpItem.Name := '';
        tmpItem.Author := '';
        tmpItem.LoadSkinColorDefaults(sTheme);

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

        tmpItem := TSchemeItem.Create(frmSchemeList.SchemeItems);
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
begin

  bExistsName := ((frmSchemeList.SchemeItems.IndexOfSkinName(edName.Text) <>
    -1));
  if ((CompareText(edName.Text, SchemeItem.Name) = 0) and (AEditMode = sceEdit))
    then
    bExistsName := False;

  bInvalidAuthor := (edAuthor.Text = '');

  Result := not ((bExistsName = True) or (bInvalidAuthor = True));
end;

function TfrmEditScheme.Save(AEditMode: TSCE_EditMode_Enum;
  AApply: Boolean): Boolean;
var
  tmpItem, lstItem, newItem: TSchemeItem;
  tmpSchemeItems: TSchemeList;
  sTheme: string;
begin
  sTheme := frmSchemeList.Theme;
  tmpSchemeItems := frmSchemeList.SchemeItems;
  tmpItem := FSchemeItem;

  case AEditMode of
    sceAdd:
      begin

        newItem := TSchemeItem.Create(frmSchemeList.SchemeItems);
        newItem.Name := edName.Text;
        newItem.Author := edAuthor.Text;
        newItem.DefaultItem := False;

        // Assign colours
        tmpItem.Assign(newItem.Colors);

        newItem.Filename := tmpSchemeItems.GetSkinSchemeDir(sTheme)
          + trim(StrRemoveChars(newItem.Name,
          ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':'])) + '.xml';

        tmpSchemeItems.Add(newItem);
        FSchemeItem.Free;

        CenterUpdateSettings;
        Result := True;
      end;
    sceEdit:
      begin

        if AApply then
        begin
          lstItem := TSchemeItem(frmSchemeList.lbSchemeList.
            Item[frmSchemeList.lbSchemeList.ItemIndex].Data);

          lstItem.Name := edName.Text;
          lstItem.Author := edAuthor.Text;
          lstItem.Filename := tmpSchemeItems.GetSkinSchemeDir(sTheme)
            + trim(StrRemoveChars(lstItem.Name,
            ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':'])) + '.xml';
          FSchemeItem.Assign(lstItem.Colors);
        end;

        CenterUpdateSettings;
        Result := True;
      end;
    sceDelete:
      begin

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

