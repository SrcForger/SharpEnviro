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
  Dialogs, StdCtrls, ExtCtrls, uSharpeColorBox, ContNrs, Buttons, PngBitBtn,
  GraphicsFx, pngimage, JvExStdCtrls, JvEdit, GR32_Image, BarPreview, GR32,
  uSchemeList, PngImageList, JvExExtCtrls, JvComponent, JvPanel, JvHtControls,
  SharpELabel, SharpERoundPanel, PngSpeedButton, ImgList, JvShape, JclIniFiles,
    SharpApi, SharpThemeApi;

type
  TfrmEditScheme = class(TForm)
    edName: TLabeledEdit;
    edAuthor: TLabeledEdit;
    SharpERoundPanel1: TSharpERoundPanel;
    sbAvailableColors: TScrollBox;

    procedure FormShow(Sender: TObject);
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
    procedure SetColors(const Value: TObjectList);

    procedure ClickColor(Sender: TObject);
    function GetSchemeName: string;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    property Edit: Boolean read FEdit write FEdit;
    property SchemeItem: TSchemeItem read FSchemeItem write FSchemeItem;
    property Colors: TObjectList read FColors write SetColors;

    procedure InitUI(AEditMode: TSCE_EditMode);
    function ValidateEdit(AEditMode: TSCE_EditMode):Boolean;
    function Save(AEditMode: TSCE_EditMode; AApply:Boolean):Boolean;
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
  tmpLabel: TJvHtLabel;
  tmpEdit: TEdit;
  tmpColBox: TSharpEColorBox;
  tmpItem: TSchemeColorItem;
  tmpSkinColor: TSharpESkinColor;
  tmpPanel: TPanel;

  colBkg: TColor;
  i: Integer;
begin
  FColors := Value;

  // Delete old controls
  for i := Pred(sbAvailableColors.ControlCount) downto 0 do
    sbAvailableColors.Controls[i].Free;
    
  for i := 0 to Pred(FColors.Count) do 
  begin
    tmpPanel := TPanel.Create(sbAvailableColors);
    tmpItem := TSchemeColorItem(FColors[i]);
    tmpSkinColor := frmSchemeList.SchemeItems.GetSkinColorByTag(tmpItem.Tag);

    colBkg := clWindow;

    with tmpPanel do
    begin
      Parent := sbAvailableColors;
      Height := 20;
      BorderWidth := 2;
      BorderStyle := bsNone;
      BevelOuter := bvNone;

      Color := colBkg;

      Align := alTop;
    end;

    tmpColBox := TSharpEColorBox.Create(tmpPanel);
    with tmpColBox do
    begin
      Parent := tmpPanel;
      align := alRight;
      BackgroundColor := colBkg;
      Color := tmpItem.Color;
      Tag := Integer(tmpItem);
      OnColorClick := ClickColor;
      Top := 10;
      Left := 0;
    end;

    tmpLabel := TJvHTLabel.Create(tmpPanel);
    with tmpLabel do
    begin
      Parent := tmpPanel;
      align := alClient;
      Color := colBkg;
      tmpLabel.Caption := Format('%s', [tmpSkinColor.info]);
      Top := 10;
    end;
  end;

end;

procedure TfrmEditScheme.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  tmpSchemeItem: TSchemeItem;
  bExists: Boolean;

  procedure FreeControls;
  var
    i: Integer;
  begin
    for i := Pred(sbAvailableColors.ControlCount) downto 0 do
      sbAvailableColors.Controls[i].Free;
  end;

begin
  {if Self.ModalResult <> mrCancel then
  begin
    // Check if exists
    bExists := frmSchemeList.SchemeItems.IndexOfSkinName(EdtSkinName.Text) <> -1;

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
      else if CompareText(frmSchemeList.lbSchemeList.Item[frmSchemeList.lbSchemeList.ItemIndex].SubItemText[0],
        EdtSkinName.Text) = 0 then
        CanClose := True
      else
        CanClose := False;
    end;

    if CanClose then begin
      FreeControls;

      if Not(FEdit) then
        IniWriteString(GetSharpeUserSettingsPath+'author.dat','main','author',EdtAuthor.Text);
    end
    else
      MessageDlg('You have entered a duplicate FTheme name'+#13+#10+'Please choose another name', mtError, [mbOK], 0);
  end;  }
end;

procedure TfrmEditScheme.ClickColor(Sender: TObject);
var
  tmpItem: TSchemeColorItem;
begin
  tmpItem := TSchemeColorItem(TSharpEColorBox(Sender).Tag);
  tmpItem.Color := TSharpEColorBox(Sender).Color;
  tmpItem.UnparsedColor := ColorToString(TSharpEColorBox(Sender).Color);

  SharpEBroadCast(WM_SHARPCENTERMESSAGE,SCM_EVT_UPDATE_PREVIEW,0);
end;

function TfrmEditScheme.GetSchemeName: string;
begin
  Result := FSchemeName;
end;

procedure TfrmEditScheme.FormShow(Sender: TObject);
begin
  FSelectedColorIdx := 0;
  //tmrUpdatePreviewTimer(nil);

  if Not(FEdit) then begin
    if FileExists(GetSharpeUserSettingsPath+'author.dat') then
      edAuthor.Text := IniReadString(GetSharpeUserSettingsPath+'author.dat',
        'main','author');
  end;
  edName.SetFocus;
end;

procedure TfrmEditScheme.InitUI(AEditMode: TSCE_EditMode);
var
  tmpItem: TSchemeItem;
  tmpSchemeItems: TSchemeList;
  sTheme: string;
begin
  sTheme := frmSchemeList.Theme;
  tmpSchemeItems := frmSchemeList.SchemeItems;

  Case AEditMode of
    sceAdd: begin

      tmpItem := TSchemeItem.Create(frmSchemeList.SchemeItems);
      tmpItem.Name := '';
      tmpItem.Author := '';
      tmpItem.LoadSkinColorDefaults(sTheme);

      Colors := tmpItem.Colors;
      SchemeItem := tmpItem;
    end;
    sceDelete: begin
    
    end;
  end;
end;

function TfrmEditScheme.ValidateEdit(AEditMode: TSCE_EditMode):Boolean;
begin
  Result := True;
end;

function TfrmEditScheme.Save(AEditMode: TSCE_EditMode;
  AApply: Boolean): Boolean;
begin
  Result := True;
end;

end.

