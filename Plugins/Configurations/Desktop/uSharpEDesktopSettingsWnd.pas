{
Source Name: uSharpDeskSettingsWnd.pas
Description: SharpDesk Settings Window
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

unit uSharpEDesktopSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi,
  JvExComCtrls, JvComCtrls, ExtCtrls, JvPageList, JvExControls, JvComponent,
  GR32_Image, GR32, GR32_PNG, SharpEColorEditor, SharpESwatchManager,
  SharpEColorEditorEx, SharpEFontSelectorFontList, ImgList, Mask, JvExMask,
  JvSpin, SharpEGaugeBoxEdit, SharpERoundPanel, SharpEUIC, JvExStdCtrls,
  JvCheckBox;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmDesktopSettings = class(TForm)
    plMain: TJvPageList;
    pagIcon: TJvStandardPage;
    pagFont: TJvStandardPage;
    pagAnimation: TJvStandardPage;
    SharpESwatchManager1: TSharpESwatchManager;
    imlFontIcons: TImageList;
    sceFontColor: TSharpEColorEditorEx;
    pnlAnim: TPanel;
    Panel3: TPanel;
    lblIconTransDet: TLabel;
    Panel4: TPanel;
    lblIconSizeDet: TLabel;
    CheckBox1: TLabel;
    SharpERoundPanel1: TSharpERoundPanel;
    icon32: TImage32;
    rdoIcon32: TRadioButton;
    SharpERoundPanel2: TSharpERoundPanel;
    icon48: TImage32;
    rdoIcon48: TRadioButton;
    SharpERoundPanel3: TSharpERoundPanel;
    Icon64: TImage32;
    rdoIcon64: TRadioButton;
    SharpERoundPanel4: TSharpERoundPanel;
    rdoIconCustom: TRadioButton;
    sgbIconSize: TSharpeGaugeBox;
    sgbIconTrans: TSharpeGaugeBox;
    Panel1: TPanel;
    lblColorBlendDet: TLabel;
    sgbColorBlend: TSharpeGaugeBox;
    Panel2: TPanel;
    lblIconShadowDet: TLabel;
    sgbIconShadow: TSharpeGaugeBox;
    Panel10: TPanel;
    lblIconColorDet: TLabel;
    lblIconColor: TLabel;
    sceIconColor: TSharpEColorEditorEx;
    lblFontNameDet: TLabel;
    lblFontSizeDet: TLabel;
    lblFontTransDet: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lblFontStyleDet: TLabel;
    Label14: TLabel;
    lblFontColor: TLabel;
    lblFontColorDet: TLabel;
    pagFontShadow: TJvStandardPage;
    lblFontShadowDet: TLabel;
    pnlTextShadow: TPanel;
    lblFontShadowTypeDet: TLabel;
    lblFontShadowTransDet: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lblFontShadowColDet: TLabel;
    cboFontName: TComboBox;
    chkIconTrans: TJvCheckBox;
    chkColorBlend: TJvCheckBox;
    chkIconShadow: TJvCheckBox;
    chkUnderline: TJvCheckBox;
    chkItalic: TJvCheckBox;
    chkBold: TJvCheckBox;
    chkFontShadow: TJvCheckBox;
    Panel5: TPanel;
    sgbFontSize: TSharpeGaugeBox;
    Panel7: TPanel;
    sgbFontTrans: TSharpeGaugeBox;
    Panel11: TPanel;
    sgbFontShadowTrans: TSharpeGaugeBox;
    chkAnim: TJvCheckBox;
    lblAnimDet: TLabel;
    Panel9: TPanel;
    lblAnimTransDet: TLabel;
    lblAnimSizeDet: TLabel;
    Panel12: TPanel;
    chkAnimTrans: TJvCheckBox;
    chkAnimSize: TJvCheckBox;
    Panel13: TPanel;
    chkAnimBrightness: TJvCheckBox;
    lblAnimBrightnessDet: TLabel;
    chkAnimColorBlend: TJvCheckBox;
    lblAnimColorBlendDet: TLabel;
    Panel14: TPanel;
    Panel15: TPanel;
    sgbAnimTrans: TSharpeGaugeBox;
    sgbAnimBrightness: TSharpeGaugeBox;
    sgbAnimColorBlend: TSharpeGaugeBox;
    sgbAnimSize: TSharpeGaugeBox;
    sceAnimColor: TSharpEColorEditorEx;
    chkFontTrans: TJvCheckBox;
    sceShadowColor: TSharpEColorEditorEx;
    Panel6: TPanel;
    cboFontShadowType: TComboBox;
    procedure IconColorsUiChange(Sender: TObject);

    procedure cbboldClick(Sender: TObject);
    procedure SendUpdateEvent(Sender: TObject; Value: Integer);

    procedure cboFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure UpdateIcontPageEvent(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rdoIconCustomClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sceIconColorUiChange(Sender: TObject);

    procedure cboFontNameChange(Sender: TObject);
    procedure FontStyleCheckEvent(Sender: TObject);
    procedure UpdateColorChangeEvent(Sender: TObject);
    procedure UpdateFontPageEvent(Sender: TObject);
    procedure ShadowTypeCheckEvent(Sender: TObject);
    procedure UpdateFontShadowPageEvent(Sender: TObject);
    procedure cboFontShadowTypeChange(Sender: TObject);
    procedure UpdateAnimationPageEvent(Sender: TObject);
  private
    FBlue32, FBlue48, FBlue64: TBitmap32;
    FWhite32, FWhite48, FWhite64: TBitmap32;
    FFontList: TFontList;
    procedure SendUpdate;
    procedure RefreshFontList;

    procedure UpdateIconPage;
    procedure UpdateFontPage;
    procedure UpdateFontShadowPage;
    procedure UpdateAnimationPage;
    procedure LoadResources;
  public
    FTheme: string;
    FFontName: string;
    procedure UpdatePageUi;
  end;

var
  frmDesktopSettings: TfrmDesktopSettings;

implementation

uses
  SharpCenterApi;

{$R *.dfm}
{$R icons.res}

{ TfrmConfigListWnd }

procedure LoadBmpFromRessource(Bmp: TBitmap32; ResName: string);
var
  ResStream: TResourceStream;
  TempBmp: TBitmap32;
  b: boolean;
begin
  if Bmp = nil then exit;

  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(22, 22);
  TempBmp.Clear(color32(0, 0, 0, 0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp, ResStream, b);
      Bmp.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;
end;

procedure TfrmDesktopSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;

  FFontList := TFontList.Create;
  FBlue32 := TBitmap32.Create;
  FBlue48 := TBitmap32.Create;
  FBlue64 := TBitmap32.Create;
  FWhite32 := TBitmap32.Create;
  FWhite48 := TBitmap32.Create;
  FWhite64 := TBitmap32.Create;
  LoadResources;
end;

procedure TfrmDesktopSettings.UpdateIconPage;
begin
  LockWindowUpdate(Self.Handle);
  try
    // Set Grey Texts
    lblIconSizeDet.Font.Color := clGrayText;
    lblIconTransDet.Font.Color := clGrayText;
    lblColorBlendDet.Font.Color := clGrayText;
    lblIconShadowDet.Font.Color := clGrayText;
    lblIconColorDet.Font.Color := clGrayText;

    // Icon Size
    sgbiconsize.Enabled := rdoIconCustom.checked;
    if rdoIcon32.Checked then
      icon32.Bitmap.Assign(FBlue32)
    else icon32.Bitmap.Assign(FWhite32);
    if rdoIcon48.Checked then
      icon48.Bitmap.Assign(FBlue32)
    else icon48.Bitmap.Assign(FWhite32);
    if rdoIcon64.Checked then
      icon64.Bitmap.Assign(FBlue32)
    else icon64.Bitmap.Assign(FWhite32);

    // Icon Color Blend
    lblColorBlendDet.Enabled := chkColorBlend.Checked;
    sgbColorBlend.Enabled := chkColorBlend.Checked;
    sceIconColor.Items.Item[0].Visible := chkColorBlend.checked;

    // Icon Shadow Transparency
    lblIconShadowDet.Enabled := chkIconShadow.Checked;
    sgbIconShadow.Enabled := chkIconShadow.Checked;
    sceIconColor.Items.Item[1].Visible := chkIconShadow.checked;

    // Refresh ColorEditorEx
    sceIconColor.Invalidate;

    // Icon Transparency
    lblIconTransDet.Enabled := chkIconTrans.Checked;
    sgbIconTrans.Enabled := chkIconTrans.Checked;

    // Icon Color Labels
    lblIconColor.Enabled := (chkIconShadow.Checked or chkColorBlend.Checked);
    lblIconColorDet.Enabled := (chkIconShadow.Checked or chkColorBlend.Checked);

    // Update Page Height
    if (chkIconShadow.Checked or chkColorBlend.Checked) then
      Self.Height := 580 else
      Self.Height := 360;

    // Refresh size
    CenterUpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmDesktopSettings.UpdateAnimationPage;
begin
  LockWindowUpdate(Self.Handle);
  try
    // Set Grey Texts
    lblAnimTransDet.Font.Color := clGrayText;
    lblAnimSizeDet.Font.Color := clGrayText;
    lblAnimBrightnessDet.Font.Color := clGrayText;
    lblAnimColorBlendDet.Font.Color := clGrayText;
    lblAnimDet.Font.Color := clGrayText;

    // Hide/Show Animation Options
    pnlAnim.Visible := chkAnim.checked;

    // Animation Transparency
    lblAnimTransDet.Enabled := chkAnimTrans.Checked;
    sgbAnimTrans.Enabled := chkAnimTrans.Checked;

    // Animation Brightness
    lblAnimBrightnessDet.Enabled := chkAnimBrightness.Checked;
    sgbAnimBrightness.Enabled := chkAnimBrightness.Checked;

    // Animation Size
    lblAnimSizeDet.Enabled := chkAnimSize.Checked;
    sgbAnimSize.Enabled := chkAnimSize.Checked;

    // Animation Color Blend
    lblAnimColorBlendDet.Enabled := chkAnimColorBlend.Checked;
    sgbAnimColorBlend.Enabled := chkAnimColorBlend.Checked;
    sceAnimColor.Visible := chkAnimColorBlend.Checked;
    sceAnimColor.Items.Item[0].Visible := chkAnimColorBlend.checked;

    // Update Page Height
    if chkAnim.Checked then begin

      if sceAnimColor.Visible then
      Self.Height := 580 else
      Self.Height := 360;

    end else
      Self.Height := 50;

    // Refresh size
    CenterUpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmDesktopSettings.LoadResources;
begin
  LoadBmpFromRessource(FBlue32, 'Blue32');
  LoadBmpFromRessource(FBlue48, 'Blue48');
  LoadBmpFromRessource(FBlue64, 'Blue64');
  LoadBmpFromRessource(FWhite32, 'White32');
  LoadBmpFromRessource(FWhite48, 'White48');
  LoadBmpFromRessource(FWhite64, 'White64');
end;

procedure TfrmDesktopSettings.UpdateFontPage;
begin
  LockWindowUpdate(Self.Handle);
  try

    // Set Grey Texts
    lblFontNameDet.Font.Color := clGrayText;
    lblFontSizeDet.Font.Color := clGrayText;
    lblFontTransDet.Font.Color := clGrayText;
    lblFontStyleDet.Font.Color := clGrayText;
    lblFontColorDet.Font.Color := clGrayText;

    // Font Transparency
    lblFontTransDet.Enabled := chkFontTrans.Checked;
    sgbFontTrans.Enabled := chkFontTrans.Checked;

    // Update Page Height
    Self.Height := 580;
    CenterUpdateSize;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmDesktopSettings.UpdateFontShadowPage;
begin
  LockWindowUpdate(Self.Handle);
  try

    // Set Grey Texts
    lblFontShadowDet.Font.Color := clGrayText;
    lblFontShadowTypeDet.Font.Color := clGrayText;
    lblFontShadowTransDet.Font.Color := clGrayText;
    lblFontShadowColDet.Font.Color := clGrayText;

    // Font Shadow
    pnlTextShadow.Visible := chkFontShadow.Checked;

    // Update Page Height
    if chkFontShadow.Checked then
      Self.Height := 440 else
      Self.Height := 50;

    CenterUpdateSize;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmDesktopSettings.SendUpdate;
begin
  if Visible then
    CenterDefineSettingsChanged;
end;

procedure TfrmDesktopSettings.rdoIconCustomClick(Sender: TObject);
begin
  rdoIcon32.Checked := False;
  rdoIcon48.Checked := False;
  rdoIcon64.Checked := False;
  rdoIconCustom.Checked := False;

  TRadioButton(Sender).OnClick := nil;
  TRadioButton(Sender).Checked := True;
  TRadioButton(Sender).OnClick := rdoIconCustomClick;

  UpdateIconPage;
  SendUpdate;
end;

procedure TfrmDesktopSettings.ShadowTypeCheckEvent(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.FormShow(Sender: TObject);
begin
  RefreshFontList;
  if cboFontName.Items.IndexOf(FFontName) <> 0 then
    cboFontName.ItemIndex := cboFontName.Items.IndexOf(FFontName);

  UpdatePageUi;
end;

procedure TfrmDesktopSettings.FormDestroy(Sender: TObject);
begin
  FBlue32.Free;
  FBlue48.Free;
  FBlue64.Free;
  FWhite32.Free;
  FWhite48.Free;
  FWhite64.Free;

  FFontList.Free;
end;

procedure TfrmDesktopSettings.UpdateIcontPageEvent(Sender: TObject);
begin
  UpdateIconPage;
  SendUpdate;
end;

procedure TfrmDesktopSettings.UpdatePageUi;
begin
  if pagIcon.Visible then
    UpdateIconPage else
    if pagFont.Visible then
      UpdateFontPage else
      if pagFontShadow.Visible then
        UpdateFontShadowPage;

end;

procedure TfrmDesktopSettings.RefreshFontList;
var
  fi: TFontInfo;
  i: integer;
  DuplicateCheck: Integer;
begin
  FFontList.List.Clear;

  cboFontName.Items.Clear;
  try
    FFontList.RefreshFontInfo;
    for i := 0 to pred(FFontList.List.Count) do begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cboFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
        cboFontName.Items.Add(FFontList.List.Strings[i]);
    end;
  finally
    cboFontName.ItemIndex := 0;
  end;
end;

procedure TfrmDesktopSettings.UpdateColorChangeEvent(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.sceIconColorUiChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.cboFontNameChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.cboFontNameDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  fi: TFontInfo;
  imageindex: integer;
  itemindex: integer;
  textheight: integer;
begin
  cboFontName.canvas.fillrect(rect);

  itemindex := FFontList.List.IndexOf(cboFontName.Items.Strings[index]);
  fi := TFontInfo(FFontList.List.Objects[itemindex]);

  imageindex := -1;
  case fi.FontType of
    ftTrueType: imageindex := 0;
    ftRaster: imageindex := 1;
    ftDevice: imageindex := 2;
  end;

  imlFontIcons.Draw(cboFontName.Canvas, rect.left, rect.top, imageindex);

  cboFontName.Canvas.Font.Name := fi.ShortName;
  textheight := cboFontName.Canvas.TextHeight(fi.FullName);

  if textheight > cboFontName.ItemHeight then
    cboFontName.Canvas.Font.Name := 'Arial';

  cboFontName.canvas.textout(rect.left + imlFontIcons.width + 2, rect.top, fi.FullName);
end;

procedure TfrmDesktopSettings.cboFontShadowTypeChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.UpdateAnimationPageEvent(Sender: TObject);
begin
  UpdateAnimationPage;
  SendUpdate;
end;

procedure TfrmDesktopSettings.UpdateFontShadowPageEvent(Sender: TObject);
begin
  UpdateFontShadowPage;
end;

procedure TfrmDesktopSettings.UpdateFontPageEvent(Sender: TObject);
begin
  UpdateFontPage;
end;

procedure TfrmDesktopSettings.FontStyleCheckEvent(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.SendUpdateEvent(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.cbboldClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.IconColorsUiChange(Sender: TObject);
begin
  SendUpdate;
end;

end.

