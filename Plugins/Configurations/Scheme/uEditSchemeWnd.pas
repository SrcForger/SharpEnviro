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
  SharpELabel, SharpERoundPanel, PngSpeedButton, ImgList, JvShape, JclIniFiles;

type
  TfrmEditScheme = class(TForm)
    Panel1: TPanel;
    PngBitBtn1: TPngBitBtn;
    btn_cancel: TPngBitBtn;
    Panel3: TPanel;
    Panel2: TPanel;
    tmrUpdatePreview: TTimer;
    bmlMain: TBitmap32List;
    sbAvailableColors: TScrollBox;
    Panel5: TJvPanel;
    Label1: TLabel;
    EdtAuthor: TEdit;
    lblName: TLabel;
    EdtSkinName: TEdit;
    pnlSchemePreview: TJvPanel;
    imgBarPreview: TImage32;
    Label2: TLabel;
    Label3: TLabel;
    cbBackgroundTint: TSharpEColorBox;
    Label4: TLabel;
    procedure col6Click(Sender: TObject);
    procedure col5Click(Sender: TObject);
    procedure col4Click(Sender: TObject);
    procedure col3Click(Sender: TObject);
    procedure col2Click(Sender: TObject);
    procedure col1Click(Sender: TObject);
    procedure EdtSkinNameChange(Sender: TObject);
    procedure EdtAuthorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure tmrUpdatePreviewTimer(Sender: TObject);
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
    procedure SetAuthor(const Value: string);
    procedure SetSchemeName(const Value: string);
    procedure ClickColor(Sender: TObject);
    function GetSchemeName: string;
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
    property Edit: Boolean read FEdit write FEdit;
    property SchemeItem: TSchemeItem read FSchemeItem write FSchemeItem;
    property Colors: TObjectList read FColors write SetColors;
    property SchemeName: string read GetSchemeName write SetSchemeName;
    property SkinName: string read FSkinName write FSkinName;
    property Author: string read FAuthor write SetAuthor;
  end;

var
  frmEditScheme: TfrmEditScheme;

implementation

uses JclStrings, SharpThemeApi, SharpApi, uSchemeListWnd;

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
  for i := 0 to Pred(sbAvailableColors.ControlCount) do
  begin
    sbAvailableColors.Controls[i].Free;
  end;

  for i := Pred(FColors.Count) downto 0 do
  begin
    tmpPanel := TPanel.Create(sbAvailableColors);
    tmpItem := TSchemeColorItem(FColors[i]);
    tmpSkinColor := GetSchemeColorByTag(tmpItem.Tag);

    colBkg := clBtnFace;

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
      align := alLeft;
      BackgroundColor := colBkg;
      Color := tmpItem.Color;
      Tag := i;
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
      Caption := Format('%s - <i>%s</i>', [tmpSkinColor.info, tmpSkinColor.tag]);
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
  if Self.ModalResult <> mrCancel then
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
  end;
end;

procedure TfrmEditScheme.SetAuthor(const Value: string);
begin
  FAuthor := Value;
  EdtAuthor.Text := Value;
end;

procedure TfrmEditScheme.SetSchemeName(const Value: string);
begin
  FSchemeName := Value;
  EdtSkinName.Text := Value;
end;

procedure TfrmEditScheme.ClickColor(Sender: TObject);
var
  tmpItem: TSchemeColorItem;
begin
  tmpItem := TSchemeColorItem(FColors[(TSharpEColorBox(Sender).Tag)]);
  tmpItem.Color := TSharpEColorBox(Sender).Color;
  tmpItem.UnparsedColor := ColorToString(TSharpEColorBox(Sender).Color);
end;

function TfrmEditScheme.GetSchemeName: string;
begin
  Result := FSchemeName;
end;

procedure TfrmEditScheme.tmrUpdatePreviewTimer(Sender: TObject);
var
  bmp: TBitmap32;
  bmpTint: TBitmap32;
  y, x: Integer;
  c: TColor;
  cx, cy: Integer;
begin
  bmp := TBitmap32.Create;
  try

    bmlMain.Bitmap[FSelectedColorIdx].DrawTo(imgBarPreview.Bitmap);
    BarPreview.CreateBarPreview(bmp, FSkinName, FSchemeItem.GetItemAsColorArray(FColors), 200);

    bmpTint := TBitmap32.Create;
    try
      bmpTint.SetSize(imgBarPreview.Bitmap.Width, imgBarPreview.Bitmap.Height);
      bmpTint.DrawMode := dmBlend;
      bmpTint.MasterAlpha := 100;
      bmpTint.Clear(Color32(cbBackgroundTint.Color));
      bmpTint.DrawTo(imgBarPreview.Bitmap);
    finally
      bmpTint.Free;
    end;

    pnlSchemePreview.Height := bmp.Height + 20;
    bmp.DrawMode := dmBlend;

    cx := (imgBarPreview.Width div 2) - (bmp.Width div 2);
    cy := (imgBarPreview.Height div 2) - (bmp.Height div 2);

    bmp.DrawTo(imgBarPreview.Bitmap, cX, CY);
  finally
    bmp.Free;
  end;
end;

procedure TfrmEditScheme.FormShow(Sender: TObject);
begin
  FSelectedColorIdx := 0;
  tmrUpdatePreviewTimer(nil);

  if Not(FEdit) then begin
    if FileExists(GetSharpeUserSettingsPath+'author.dat') then
      EdtAuthor.Text := IniReadString(GetSharpeUserSettingsPath+'author.dat',
        'main','author');
  end;
  EdtSkinName.SetFocus;
end;

procedure TfrmEditScheme.EdtAuthorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  FAuthor := EdtAuthor.Text;
end;

procedure TfrmEditScheme.EdtSkinNameChange(Sender: TObject);
begin
  FSchemeName := EdtSkinName.Text;
end;

procedure TfrmEditScheme.col1Click(Sender: TObject);
begin
  FSelectedColorIdx := 0;
end;

procedure TfrmEditScheme.col2Click(Sender: TObject);
begin
  FSelectedColorIdx := 1;
end;

procedure TfrmEditScheme.col3Click(Sender: TObject);
begin
  FSelectedColorIdx := 2;
end;

procedure TfrmEditScheme.col4Click(Sender: TObject);
begin
  FSelectedColorIdx := 3;
end;

procedure TfrmEditScheme.col5Click(Sender: TObject);
begin
  FSelectedColorIdx := 4;
end;

procedure TfrmEditScheme.col6Click(Sender: TObject);
begin
  FSelectedColorIdx := 5;
end;

end.

