{
Source Name: uLinkWnd.pas
Description: Link Object Settings Window
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

unit uLinkWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, uSEListboxPainter, JclFileUtils,
  uSharpCenterPluginTabList, uSharpCenterCommon, ImgList, PngImageList,
  SharpEListBox, SharpEListBoxEx, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit, SharpEUIC,
  SharpEFontSelectorFontList, JvPageList, JvExControls, SharpEPageControl,
  ComCtrls, Mask, JvExMask, JvToolEdit, SharpEColorEditorEx,
  SharpDialogs, SharpERoundPanel, SharpIconUtils, JvExStdCtrls, JvCheckBox;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmLink = class(TForm)
    plMain: TJvPageList;
    pagLink: TJvStandardPage;
    Label9: TLabel;
    Label5: TLabel;
    Target: TJvFilenameEdit;
    pn_caption: TPanel;
    cb_caption: TCheckBox;
    Label1: TLabel;
    spc: TSharpEPageControl;
    pl: TJvPageList;
    pagesingle: TJvStandardPage;
    pagemulti: TJvStandardPage;
    edit_caption: TEdit;
    memo_caption: TMemo;
    Panel2: TPanel;
    cb_calign: TComboBox;
    Label3: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label4: TLabel;
    Icon: TJvFilenameEdit;
    SharpERoundPanel1: TSharpERoundPanel;
    IconPreview: TImage32;
    pagIcon: TJvStandardPage;
    Panel1: TPanel;
    lblIconTransDet: TLabel;
    Panel5: TPanel;
    lblIconSizeDet: TLabel;
    CheckBox1: TLabel;
    Panel6: TPanel;
    lblColorBlendDet: TLabel;
    Panel7: TPanel;
    lblIconShadowDet: TLabel;
    Panel10: TPanel;
    lblIconColorDet: TLabel;
    lblIconColor: TLabel;
    UICSize: TSharpEUIC;
    SharpERoundPanel5: TSharpERoundPanel;
    rdoIconCustom: TRadioButton;
    sgbIconSize: TSharpeGaugeBox;
    SharpERoundPanel4: TSharpERoundPanel;
    Icon64: TImage32;
    rdoIcon64: TRadioButton;
    SharpERoundPanel3: TSharpERoundPanel;
    icon48: TImage32;
    rdoIcon48: TRadioButton;
    SharpERoundPanel2: TSharpERoundPanel;
    icon32: TImage32;
    rdoIcon32: TRadioButton;
    UICColorBlend: TSharpEUIC;
    chkColorBlend: TJvCheckBox;
    UICIconShadow: TSharpEUIC;
    chkIconShadow: TJvCheckBox;
    UICIconTrans: TSharpEUIC;
    chkIconTrans: TJvCheckBox;
    UICColorBlendValue: TSharpEUIC;
    sgbColorBlend: TSharpeGaugeBox;
    UICIconShadowValue: TSharpEUIC;
    sgbIconShadow: TSharpeGaugeBox;
    UICIconTransValue: TSharpEUIC;
    sgbIconTrans: TSharpeGaugeBox;
    UICColorBlendColor: TSharpEUIC;
    sceColorBlend: TSharpEColorEditorEx;
    UICIconShadowColor: TSharpEUIC;
    sceIconShadow: TSharpEColorEditorEx;
    pagFont: TJvStandardPage;
    lblFontNameDet: TLabel;
    lblFontSizeDet: TLabel;
    lblFontTransDet: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lblFontStyleDet: TLabel;
    Label14: TLabel;
    lblFontColor: TLabel;
    lblFontColorDet: TLabel;
    imlFontIcons: TImageList;
    UICFontName: TSharpEUIC;
    cboFontName: TComboBox;
    UICFontSize: TSharpEUIC;
    sgbFontSize: TSharpeGaugeBox;
    UICFontTrans: TSharpEUIC;
    chkFontTrans: TJvCheckBox;
    UICFontTransValue: TSharpEUIC;
    sgbFontTrans: TSharpeGaugeBox;
    UICUnderline: TSharpEUIC;
    chkUnderline: TJvCheckBox;
    UICItalic: TSharpEUIC;
    chkItalic: TJvCheckBox;
    UICBold: TSharpEUIC;
    chkBold: TJvCheckBox;
    UICFontColor: TSharpEUIC;
    sceFontColor: TSharpEColorEditorEx;
    pagFontShadow: TJvStandardPage;
    lblFontShadowDet: TLabel;
    pnlTextShadow: TPanel;
    lblFontShadowTypeDet: TLabel;
    lblFontShadowTransDet: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lblFontShadowColDet: TLabel;
    UICFontShadow: TSharpEUIC;
    chkFontShadow: TJvCheckBox;
    UICFontShadowType: TSharpEUIC;
    cboFontShadowType: TComboBox;
    UICFontShadowTrans: TSharpEUIC;
    sgbFontShadowTrans: TSharpeGaugeBox;
    UICFontShadowColor: TSharpEUIC;
    sceShadowColor: TSharpEColorEditorEx;
    procedure FormCreate(Sender: TObject);
    procedure TargetButtonClick(Sender: TObject);
    procedure spcTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure IconButtonClick(Sender: TObject);
    procedure TargetBeforeDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure cb_captionClick(Sender: TObject);
    procedure IconBeforeDialog(Sender: TObject; var AName: string;
      var AAction: Boolean);
    procedure TargetChange(Sender: TObject);
    procedure cb_calignChange(Sender: TObject);
    procedure IconChange(Sender: TObject);
    procedure edit_captionChange(Sender: TObject);
    procedure memo_captionChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure chkColorBlendClick(Sender: TObject);
    procedure chkIconShadowClick(Sender: TObject);
    procedure chkIconTransClick(Sender: TObject);
    procedure sgbColorBlendChangeValue(Sender: TObject; Value: Integer);
    procedure sgbIconShadowChangeValue(Sender: TObject; Value: Integer);
    procedure sgbIconTransChangeValue(Sender: TObject; Value: Integer);
    procedure rdoIcon32Click(Sender: TObject);
    procedure rdoIcon48Click(Sender: TObject);
    procedure rdoIcon64Click(Sender: TObject);
    procedure rdoIconCustomClick(Sender: TObject);
    procedure sgbIconSizeChangeValue(Sender: TObject; Value: Integer);
    procedure UICSizeReset(Sender: TObject);
    procedure UICColorBlendReset(Sender: TObject);
    procedure sceColorBlendResize(Sender: TObject);
    procedure sceIconShadowResize(Sender: TObject);
    procedure sceColorBlendChangeColor(ASender: TObject; AValue: Integer);
    procedure sceIconShadowChangeColor(ASender: TObject; AValue: Integer);
    procedure cboFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cboFontNameChange(Sender: TObject);
    procedure UICFontNameReset(Sender: TObject);
    procedure sgbFontSizeChangeValue(Sender: TObject; Value: Integer);
    procedure chkFontTransClick(Sender: TObject);
    procedure UICFontTransReset(Sender: TObject);
    procedure sgbFontTransChangeValue(Sender: TObject; Value: Integer);
    procedure chkBoldClick(Sender: TObject);
    procedure chkItalicClick(Sender: TObject);
    procedure chkUnderlineClick(Sender: TObject);
    procedure UICFontColorClick(Sender: TObject);
    procedure sceFontColorChangeColor(ASender: TObject; AValue: Integer);
    procedure sceFontColorResize(Sender: TObject);
    procedure chkFontShadowClick(Sender: TObject);
    procedure UICFontShadowTypeReset(Sender: TObject);
    procedure cboFontShadowTypeChange(Sender: TObject);
    procedure sgbFontShadowTransChangeValue(Sender: TObject; Value: Integer);
    procedure sceShadowColorResize(Sender: TObject);
    procedure sceShadowColorChangeColor(ASender: TObject; AValue: Integer);
    procedure UICFontShadowReset(Sender: TObject);
  private
    FBlue32, FBlue48, FBlue64: TBitmap32;
    FWhite32, FWhite48, FWhite64: TBitmap32;
    FFontList: TFontList;
    procedure RefreshFontList;
    procedure UpdateSettings;
    procedure UpdateIcon;
    procedure SendUpdate;
    procedure LoadResources;
  public
    sObjectID: string;
    procedure UpdateIconPage;
    procedure UpdateFontPage;
    procedure UpdateFontShadowPage;
    procedure UpdatePageUI;
    procedure UpdateLinkPage;
    property FontList : TFontList read FFontList;
  end;

var
  frmLink: TfrmLink;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}
{$R Icons.res}

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

procedure TfrmLink.cboFontNameChange(Sender: TObject);
begin
  UICFontName.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.cboFontNameDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
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

procedure TfrmLink.cboFontShadowTypeChange(Sender: TObject);
begin
  UICFontShadowType.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.cb_calignChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.cb_captionClick(Sender: TObject);
begin
  if cb_caption.Checked then
    pn_caption.Height := 227
    else pn_caption.Height := 51;

  UpdateSettings;
end;

procedure TfrmLink.chkBoldClick(Sender: TObject);
begin
  UICBold.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.chkColorBlendClick(Sender: TObject);
begin
  UpdateIconPage;
  SendUpdate;
  UICColorBlend.UpdateStatus;
end;

procedure TfrmLink.chkFontShadowClick(Sender: TObject);
begin
  UICFontShadow.UpdateStatus;
  SendUpdate;
  UpdateFontShadowPage;
end;

procedure TfrmLink.chkFontTransClick(Sender: TObject);
begin
  UICFontTrans.UpdateStatus;
  SendUpdate;
  UpdateFontPage;
end;

procedure TfrmLink.chkIconShadowClick(Sender: TObject);
begin
  UpdateIconPage;
  SendUpdate;
  UICIconShadow.UpdateStatus;
end;

procedure TfrmLink.chkIconTransClick(Sender: TObject);
begin
  UpdateIconPage;
  SendUpdate;
  UICIconTrans.UpdateStatus;
end;

procedure TfrmLink.chkItalicClick(Sender: TObject);
begin
  UICItalic.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.chkUnderlineClick(Sender: TObject);
begin
  UICUnderline.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.edit_captionChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;

  FFontList := TFontList.Create;
  FBlue32 := TBitmap32.Create;
  FBlue48 := TBitmap32.Create;
  FBlue64 := TBitmap32.Create;
  FWhite32 := TBitmap32.Create;
  FWhite48 := TBitmap32.Create;
  FWhite64 := TBitmap32.Create;
  LoadResources;

  RefreshFontList;
end;

procedure TfrmLink.FormDestroy(Sender: TObject);
begin
  FBlue32.Free;
  FBlue48.Free;
  FBlue64.Free;
  FWhite32.Free;
  FWhite48.Free;
  FWhite64.Free;
  FFontList.Free;
end;

procedure TfrmLink.FormShow(Sender: TObject);
begin
  UpdateIcon;
  cb_caption.OnClick(cb_caption);

  Label5.Font.Color := clGrayText;
  Label1.Font.Color := clGrayText;
  Label4.Font.Color := clGrayText;
end;

procedure TfrmLink.IconBeforeDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  AAction := False;
end;

procedure TfrmLink.IconButtonClick(Sender: TObject);
var
  s : String;
begin
  s := SharpDialogs.IconDialog(Target.Text,SMI_ALL_ICONS,Mouse.CursorPos);
  if length(trim(s)) > 0 then
  begin
    Icon.Text := s;
    UpdateIcon;
  end;
end;

procedure TfrmLink.IconChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.LoadResources;
begin
  LoadBmpFromRessource(FBlue32, 'Blue32');
  LoadBmpFromRessource(FBlue48, 'Blue48');
  LoadBmpFromRessource(FBlue64, 'Blue64');
  LoadBmpFromRessource(FWhite32, 'White32');
  LoadBmpFromRessource(FWhite48, 'White48');
  LoadBmpFromRessource(FWhite64, 'White64');
end;

procedure TfrmLink.memo_captionChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.rdoIcon32Click(Sender: TObject);
begin
  rdoIcon48.Checked := False;
  rdoIcon64.Checked := False;
  rdoIconCustom.Checked := False;

  SendUpdate;
  UICSize.UpdateStatusFromValue('32');
  UpdateIconPage;
end;

procedure TfrmLink.rdoIcon48Click(Sender: TObject);
begin
  rdoIcon32.Checked := False;
  rdoIcon64.Checked := False;
  rdoIconCustom.Checked := False;

  SendUpdate;
  UICSize.UpdateStatusFromValue('48');
  UpdateIconPage;
end;

procedure TfrmLink.rdoIcon64Click(Sender: TObject);
begin
  rdoIcon32.Checked := False;
  rdoIcon48.Checked := False;
  rdoIconCustom.Checked := False;

  SendUpdate;
  UICSize.UpdateStatusFromValue('96');
  UpdateIconPage;
end;

procedure TfrmLink.rdoIconCustomClick(Sender: TObject);
begin
  rdoIcon32.Checked := False;
  rdoIcon48.Checked := False;
  rdoIcon64.Checked := False;

  SendUpdate;
  UICSize.UpdateStatusFromValue(inttostr(sgbIconSize.Value));
  UpdateIconPage;  
end;

procedure TfrmLink.RefreshFontList;
var
  fi: TFontInfo;
  i: integer;
  DuplicateCheck: Integer;
begin
  FFontList.List.Clear;

  cboFontName.Items.Clear;
  try
    FFontList.RefreshFontInfo;
    for i := 0 to pred(FFontList.List.Count) do
    begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cboFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
        cboFontName.Items.Add(FFontList.List.Strings[i]);
    end;
  finally
    cboFontName.ItemIndex := 0;
  end;
end;

procedure TfrmLink.sceColorBlendChangeColor(ASender: TObject; AValue: Integer);
begin
  UICColorBlendColor.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sceColorBlendResize(Sender: TObject);
begin
  UICColorBlendColor.Height := sceColorBlend.Height + 4;
  UpdateIconPage;
end;

procedure TfrmLink.sceFontColorChangeColor(ASender: TObject; AValue: Integer);
begin
  UICFontColor.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sceFontColorResize(Sender: TObject);
begin
  UICFontColor.Height := sceFontColor.Height + 4;
  UpdateFontPage;
end;

procedure TfrmLink.sceIconShadowChangeColor(ASender: TObject; AValue: Integer);
begin
  UICIconShadowColor.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sceIconShadowResize(Sender: TObject);
begin
  UICIconShadowColor.Height := sceIconShadow.Height + 4;
  UpdateIconPage;
end;

procedure TfrmLink.sceShadowColorChangeColor(ASender: TObject; AValue: Integer);
begin
  UICFontShadowColor.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sceShadowColorResize(Sender: TObject);
begin
  UICFontShadowColor.Height := sceShadowColor.Height + 4;
  UpdateFontShadowPage;
end;

procedure TfrmLink.SendUpdate;
begin
  if Visible then
    CenterDefineSettingsChanged;
end;

procedure TfrmLink.sgbColorBlendChangeValue(Sender: TObject; Value: Integer);
begin
  UICColorBlendValue.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sgbFontShadowTransChangeValue(Sender: TObject;
  Value: Integer);
begin
  UICFontShadowTrans.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sgbFontSizeChangeValue(Sender: TObject; Value: Integer);
begin
  UICFontSize.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sgbFontTransChangeValue(Sender: TObject; Value: Integer);
begin
  UICFontTransValue.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sgbIconShadowChangeValue(Sender: TObject; Value: Integer);
begin
  UICIconShadowValue.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.sgbIconSizeChangeValue(Sender: TObject; Value: Integer);
begin
  UICSize.UpdateStatusFromValue(inttostr(sgbIconSize.Value));
  SendUpdate;
end;

procedure TfrmLink.sgbIconTransChangeValue(Sender: TObject; Value: Integer);
begin
  UICIconTransValue.UpdateStatus;
  SendUpdate;
end;

procedure TfrmLink.spcTabChange(ASender: TObject; const ATabIndex: Integer;
  var AChange: Boolean);
begin
  pl.ActivePageIndex := ATabIndex;
  if pl.ActivePageIndex = 1 then
    memo_caption.lines.CommaText := edit_caption.Text
    else edit_caption.Text := memo_caption.Lines.CommaText;
  UpdateSettings;
  AChange := True;
end;

procedure TfrmLink.TargetBeforeDialog(Sender: TObject; var AName: string;
  var AAction: Boolean);
begin
  AAction := False;
end;

procedure TfrmLink.TargetButtonClick(Sender: TObject);
var
  s : String;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,Mouse.CursorPos);
  if length(trim(s)) > 0 then
    Target.Text := s;
end;

procedure TfrmLink.TargetChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmLink.UICColorBlendReset(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmLink.UICFontColorClick(Sender: TObject);
begin
  SendUpdate;
  UpdateFontPage;
end;

procedure TfrmLink.UICFontNameReset(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmLink.UICFontShadowReset(Sender: TObject);
begin
  SendUpdate;
  UpdateFontShadowPage;
end;

procedure TfrmLink.UICFontShadowTypeReset(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmLink.UICFontTransReset(Sender: TObject);
begin
  SendUpdate;
  UpdateFontPage;
end;

procedure TfrmLink.UICSizeReset(Sender: TObject);
begin
  if CompareText(UICSize.DefaultValue,'32') = 0 then
    rdoIcon32.Checked := True
  else if CompareText(UICSize.DefaultValue,'48') = 0 then
    rdoIcon48.Checked := True
  else if CompareText(UICSize.DefaultValue,'64') = 0 then
    rdoIcon64.Checked := True
  else
  begin
    rdoIconCustom.Checked := True;
    sgbIconSize.Value := StrToInt(UICSize.DefaultValue);
  end;
  UICSize.HasChanged := False;
  SendUpdate;
end;

procedure TfrmLink.UpdateFontPage;
begin
  if not pagFont.Visible then
    exit;

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

procedure TfrmLink.UpdateFontShadowPage;
begin
  if not pagFontShadow.Visible then
    exit;

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

procedure TfrmLink.UpdateIcon;
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
  SharpIconUtils.IconStringToIcon(Icon.Text,Target.Text,Bmp,32);
  IconPreview.Bitmap.SetSize(32,32);
  IconPreview.Bitmap.Clear(color32(IconPreview.Color));
  Bmp.DrawTo(IconPreview.Bitmap,Rect(0,0,32,32));
  Bmp.Free;
end;

procedure TfrmLink.UpdateIconPage;
begin
  if not PagIcon.Visible then
    exit;

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
    UICColorBlendColor.Visible := chkColorBlend.checked;

    // Icon Shadow Transparency
    lblIconShadowDet.Enabled := chkIconShadow.Checked;
    sgbIconShadow.Enabled := chkIconShadow.Checked;
    UICIconShadowColor.Visible := chkIconShadow.checked;

    // Icon Transparency
    lblIconTransDet.Enabled := chkIconTrans.Checked;
    sgbIconTrans.Enabled := chkIconTrans.Checked;

    // Icon Color Labels
    lblIconColor.Enabled := (chkIconShadow.Checked or chkColorBlend.Checked);
    lblIconColorDet.Enabled := (chkIconShadow.Checked or chkColorBlend.Checked);

    // Update Page Height
    if (chkIconShadow.Checked or chkColorBlend.Checked) then
      Self.Height := 586 else
      Self.Height := 359;

    // Refresh size
    CenterUpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmLink.UpdateLinkPage;
begin
  if not pagLink.Visible then
    exit;

  Height := 391;
  CenterUpdateSize;
end;

procedure TfrmLink.UpdatePageUI;
begin
  if pagIcon.Visible then
    UpdateIconPage else
    if pagFont.Visible then
      UpdateFontPage else
      if pagFontShadow.Visible then
        UpdateFontShadowPage
      else UpdateLinkPage;
end;

procedure TfrmLink.UpdateSettings;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

