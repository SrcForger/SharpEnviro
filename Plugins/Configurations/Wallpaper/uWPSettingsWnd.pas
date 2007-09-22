{
Source Name: uWPSettingsWnd.pas
Description: Theme Wallpaper Settings Window
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

unit uWPSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi,
  JvExComCtrls, JvComCtrls, ExtCtrls, JvPageList, JvExControls, JvComponent,
  SharpEGaugeBoxEdit, Buttons, PngBitBtn, GR32_Image, SharpEColorEditorEx, Mask,
  JvExMask, JvToolEdit, SharpThemeApi, Contnrs, GR32, GR32_Resamplers, SharpCenterApi,
  SharpESwatchManager, SharpGraphicsUtils, JPeg, SharpETabList, SharpERoundPanel,
  SharpEPageControl;

type
  TWPItem = class
  private
  public
    WPLoaded: boolean;
    BmpPreview: TBitmap32;
    Bmp: TBitmap32;
    MonID: integer;
    Mon: TMonitor;
      Name: string;
    Image: string;
    Color: integer;
    Alpha: integer;
    Size: TThemeWallpaperSize;
    ColorChange: boolean;
    Hue: integer;
    Saturation: integer;
    Lightness: integer;
    Gradient: boolean;
    GradientType: TThemeWallpaperGradientType;
    GDStartColor: integer;
    GDStartAlpha: integer;
    GDEndColor: integer;
    GDEndAlpha: integer;
    MirrorHoriz: boolean;
    MirrorVert: boolean;

    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure LoadFromFile;
  published
  end;

  TfrmWPSettings = class(TForm)
    secWpColor: TSharpEColorEditorEx;
    ssmConfig: TSharpESwatchManager;
    dlgOpen: TOpenDialog;
    plConfig: TJvPageList;
    pagWallpaper: TJvStandardPage;
    pagColor: TJvStandardPage;
    pagGradient: TJvStandardPage;
    lblWpFile: TLabel;
    lblWpFileDet: TLabel;
    Panel6: TPanel;
    edtWpFile: TEdit;
    btnWpBrowse: TButton;
    lblWpAlign: TLabel;
    lblWpAlignDet: TLabel;
    Panel7: TPanel;
    rdoWpAlignStretch: TRadioButton;
    rdoWpAlignScale: TRadioButton;
    rdoWpAlignCenter: TRadioButton;
    rdoWpAlignTile: TRadioButton;
    lblWpMirror: TLabel;
    lblWpMirrorDet: TLabel;
    Panel8: TPanel;
    chkWpMirrorVert: TCheckBox;
    chkWpMirrorHoriz: TCheckBox;
    imgWallpaper: TImage32;
    lblWpTrans: TLabel;
    lblWpTransDet: TLabel;
    Panel9: TPanel;
    sgbWpTrans: TSharpeGaugeBox;
    lblWpColor: TLabel;
    lblWpColorDet: TLabel;
    pnlMonitor: TSharpERoundPanel;
    lblMonitorDet: TLabel;
    lblMonitor: TLabel;
    Panel3: TSharpERoundPanel;
    cboMonitor: TComboBox;
    lblApplyColorDet: TLabel;
    chkApplyColor: TCheckBox;
    imgColor: TImage32;
    pnlColor: TPanel;
    lblHSLColor: TLabel;
    lblHSLColorDet: TLabel;
    Panel10: TPanel;
    sgbLum: TSharpeGaugeBox;
    sgbSat: TSharpeGaugeBox;
    sgbHue: TSharpeGaugeBox;
    chkApplyGrad: TCheckBox;
    lblApplyGrad: TLabel;
    pnlGrad: TPanel;
    lblGradType: TLabel;
    lblGradTypeDet: TLabel;
    Panel5: TPanel;
    cboGradType: TComboBox;
    lblGradTrans: TLabel;
    lblGradTransDet: TLabel;
    Panel11: TPanel;
    sgbGradStartTrans: TSharpeGaugeBox;
    sgbGradEndTrans: TSharpeGaugeBox;
    lblGradColor: TLabel;
    lblGradColorDet: TLabel;
    secGradColor: TSharpEColorEditorEx;
    imgGradient: TImage32;
    procedure fedit_image_KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure MirrorChangeEvent(Sender: TObject);
    procedure AlignmentChangeEvent(Sender: TObject);
    procedure cb_gtypeChange(Sender: TObject);
    procedure WallpaperColorUiChangeEvent(Sender: TObject);
    procedure WallpaperTransChangeEvent(Sender: TObject; Value: Integer);
    procedure edtWallpaperChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnWpBrowseClick(Sender: TObject);
    procedure ApplyColorClickEvent(Sender: TObject);
    procedure ApplyGradientClickEvent(Sender: TObject);
    procedure MonitorChangeEvent(Sender: TObject);
    procedure HSLColorChangeEvent(Sender: TObject; Value: Integer);
  private

    procedure RenderGradient(AW, AH: Integer;
      AGradientType: TThemeWallpaperGradientType;
      AColorGradFrom, AColorGradTo, AAlphaFrom, AAlphaTo: Integer; var ABitmap: TBitmap32);
  public
    FTheme: string;
    FCurrentWP: TWPItem;
    procedure UpdateGUIFromWPItem(AWPItem: TWPItem);
    procedure UpdateWPItemFromGuid;
    procedure RenderPreview;

    procedure UpdateWallpaperPage;
    procedure UpdateColorPage;
    procedure UpdateGradientPage;
  end;

var
  frmWPSettings: TfrmWPSettings;
  WPList: TObjectList;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

constructor TWPItem.Create;
begin
  inherited Create;

  wploaded := False;

  Bmp := TBitmap32.Create;
  BmpPreview := TBitmap32.Create;
  TLinearResampler.Create(BmpPreview);

  // Default Settings
  Color := 0;
  Alpha := 255;
  Size := twsScale;
  ColorChange := False;
  Hue := 0;
  Saturation := 0;
  Lightness := 0;
  Gradient := False;
  GradientType := twgtVert;
  GDStartColor := 0;
  GDStartAlpha := 0;
  GDEndColor := 0;
  GDEndAlpha := 255;
  MirrorHoriz := False;
  MirrorVert := False;

  //TLinearResampler.Create(Bmp);
end;

destructor TWPItem.Destroy;
begin
  Bmp.Free;
  BmpPreview.Free;

  inherited Destroy;
end;

procedure TWPItem.LoadFromFile;
var
  b: boolean;
begin
  b := False;
  if FileExists(Image) then
  try
    Bmp.LoadFromFile(Image);
    b := True;
  except
  end;

  if not b then
  begin
    if Mon <> nil then
      Bmp.SetSize(Mon.Width, Mon.Height)
    else Bmp.SetSize(187, 144);
    Bmp.Clear(color32(0, 0, 0, 0));
  end;
  wploaded := b;
end;

procedure TfrmWPSettings.UpdateColorPage;
begin
  LockWindowUpdate(Self.Handle);
  try
    lblApplyColorDet.Font.Color := clGrayText;
    lblHSLColorDet.Font.Color := clGrayText;

    pnlColor.Visible := chkApplyColor.Checked;

    if chkApplyColor.Checked then
      Self.Height := 150 else
      Self.Height := 60;

    if pnlMonitor.Visible then
      Self.Height := Self.Height + 100;

    CenterUpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmWPSettings.UpdateGradientPage;
begin
  LockWindowUpdate(Self.Handle);
  try
    lblApplyGrad.Font.Color := clGrayText;
    lblGradTypeDet.Font.Color := clGrayText;
    lblGradTransDet.Font.Color := clGrayText;
    lblGradColorDet.Font.Color := clGrayText;

    pnlGrad.Visible := chkApplyGrad.Checked;

    if chkApplyGrad.Checked then
      Self.Height := 450 else
      Self.Height := 60;

    if pnlMonitor.Visible then
      Self.Height := Self.Height + 100;

    CenterUpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmWPSettings.RenderGradient(AW, AH: Integer;
  AGradientType: TThemeWallpaperGradientType;
  AColorGradFrom, AColorGradTo, AAlphaFrom, AAlphaTo: Integer; var ABitmap: TBitmap32);
const
  cSize = 12;
var
  iW, iH: Integer;
  bmp: TBitmap32;
  x, y: integer;
begin
  iW := AW + (2 * cSize);
  iH := AH + (2 * cSize);

  bmp := TBitmap32.Create;
  try
    bmp.DrawMode := dmBlend;
    bmp.CombineMode := cmMerge;
    bmp.SetSize(iW, iH);
    bmp.Clear(color32(clsilver));
    for x := 0 to iW do
      for y := 0 to iH do
        if y mod 2 = 0 then
          bmp.FillRect(2 * x * csize, y * csize, 2 * x * csize + csize, y * csize + csize, clWhite32)
        else bmp.FillRect(2 * x * csize + csize, y * csize, 2 * x * csize + 2 * csize, y * csize + csize, clWhite32);

    ABitmap.SetSize(iW, iH);
    bmp.DrawTo(ABitmap);
  finally
    bmp.Free;
  end;

  ABitmap.BeginUpdate;
  ApplyGradient(ABitmap, AGradientType,
    AColorGradFrom,
    AColorGradTo,
    AAlphaFrom,
    AAlphaTo);
  ABitmap.EndUpdate;

  ABitmap.FrameRectS(0, 0, ABitmap.Width, ABitmap.Height, Color32(0, 0, 0, 255));
end;

procedure TfrmWPSettings.RenderPreview;
var
  w, w2, h, h2: integer;
  WPBmp: TBitmap32;
  RSBmp: TBitmap32;
  x, y: integer;
begin
  if FCurrentWP = nil then exit;
  if FCurrentWP.Mon = nil then exit;

  WPBmp := TBitmap32.Create;
  TLinearResampler.Create(WPBmp);
  WPBmp.DrawMode := dmBlend;
  WPBmp.CombineMode := cmMerge;
  RSBmp := TBitmap32.Create;
  TLinearResampler.Create(RSBmp);

  with FCurrentWP do
  begin
    // decide size
    if Mon.Width > Mon.Height then
    begin
      w := imgWallpaper.Width;
      h := round(imgWallpaper.Width * (Mon.Height / Mon.Width));
    end else
    begin
      h := imgWallpaper.Height;
      w := round(imgWallpaper.Height * (Mon.Width / Mon.Height));
    end;
    w2 := round(Bmp.Width * (w / Mon.Width));
    h2 := round(Bmp.Height * (h / Mon.Height));

    BmpPreview.SetSize(w, h);
    BmpPreview.Clear(color32(FCurrentWP.Color));

    RSBmp.SetSize(w2, h2);
    Bmp.DrawTo(RSBmp, Rect(0, 0, w2, h2));
    WPBmp.SetSize(w, h);
    WPBmp.Clear(color32(0, 0, 0, 0));
    case Size of
      twsStretch: RSBmp.DrawTo(WPBmp, Rect(0, 0, w, h));
      twsCenter: RSBmp.DrawTo(WPBmp, WPBmp.Width div 2 - RSBmp.Width div 2,
          WPBmp.Height div 2 - RSBmp.Height div 2);
      twsScale:
        begin
          if ((w2 <> 0) and (h2 <> 0)) then begin
            if w2 / h2 = w / h then
              RSBmp.Drawto(WPBmp, Rect(0, 0, w, h))
            else if (w2 / h2) > (w / h) then
              RSBmp.DrawTo(WPBmp, Rect(0, round(h / 2 - (w / w2) * h2 / 2), w, round(h / 2 + (w / w2) * h2 / 2)))
            else RSBmp.DrawTo(WPBmp, Rect(round(w / 2 - (h / h2) * w2 / 2), 0, round(w / 2 + (h / h2) * w2 / 2), h));
          end;
        end;
      twsTile:
        for x := 0 to w div w2 do
          for y := 0 to h div h2 do
            RSBmp.DrawTo(WPBmp, x * w2, y * h2);
    end;

    imgWallpaper.bitmap.assign(WPBmp);
    imgWallpaper.bitmap.FrameRectS(0, 0, w, h, Color32(0, 0, 0, 255));

    if MirrorHoriz then
      WPBmp.Canvas.CopyRect(Rect(WPBmp.Width, 0, 0, WPBmp.Height), WPBmp.Canvas, Rect(0, 0, WPBmp.Width, WPBmp.Height));
    if MirrorVert then
      WPBmp.Canvas.CopyRect(Rect(0, WPBmp.Height, WPBmp.Width, 0), WPBmp.Canvas, Rect(0, 0, WPBmp.Width, WPBmp.Height));

    if ColorChange then
      HSLChangeImage(WPBmp, Hue, Saturation, Lightness);

    imgColor.bitmap.assign(WPBmp);
    imgColor.bitmap.FrameRectS(0, 0, w, h, Color32(0, 0, 0, 255));

    if Gradient then
      ApplyGradient(WPBmp, GradientType,
        GDStartColor, GDEndColor, GDStartAlpha, GDEndAlpha);

    WPBmp.MasterAlpha := Alpha;
    WPBmp.DrawTo(BmpPreview, 0, 0);

    BmpPreview.FrameRectS(0, 0, w, h, Color32(0, 0, 0, 255));
  end;

  RSBmp.Free;
  WPBmp.Free;
end;

procedure TfrmWPSettings.HSLColorChangeEvent(Sender: TObject; Value: Integer);
begin
  UpdateWPItemFromGuid;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.UpdateWallpaperPage;
begin
  LockWindowUpdate(Self.Handle);
  try
    lblWpFileDet.Font.Color := clGrayText;
    lblWpAlignDet.Font.Color := clGrayText;
    lblWpMirrorDet.Font.Color := clGrayText;
    lblWpTransDet.Font.Color := clGrayText;
    lblWpColorDet.Font.Color := clGrayText;

    if pnlMonitor.Visible then
      Self.Height := 600 else
      Self.Height := 500;

    CenterUpdateSize;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmWPSettings.UpdateWPItemFromGuid;
begin
  if FCurrentWP = nil then exit;

  if rdoWpAlignCenter.Checked then
    FCurrentWP.Size := twsCenter else
    if rdoWpAlignScale.Checked then
      FCurrentWP.Size := twsScale else
      if rdoWpAlignStretch.Checked then
        FCurrentWP.Size := twsStretch else
        if rdoWpAlignTile.Checked then
          FCurrentWP.Size := twsTile;

  FCurrentWP.MirrorHoriz := chkWpMirrorHoriz.Checked;
  FCurrentWP.MirrorVert := chkWpMirrorVert.Checked;
  FCurrentWP.Image := edtWpFile.Text;
  FCurrentWP.Alpha := sgbWpTrans.Value;
  FCurrentWP.ColorChange := chkApplyColor.checked;
  FCurrentWP.Hue := sgbHue.Value;
  FCurrentWP.Saturation := sgbSat.Value;
  FCurrentWP.Lightness := sgbLum.Value;
  FCurrentWP.Gradient := chkApplyGrad.Checked;
  case cboGradType.ItemIndex of
    0: FCurrentWP.GradientType := twgtHoriz;
    1: FCurrentWP.GradientType := twgtVert;
    2: FCurrentWP.GradientType := twgtTSHoriz;
    3: FCurrentWP.GradientType := twgtTSVert;
  end;
  FCurrentWP.GDStartAlpha := sgbGradStartTrans.Value;
  FCurrentWP.GDEndAlpha := sgbGradEndTrans.Value;
  FCurrentWP.Color := secWpColor.Items.Item[0].ColorCode;
  FCurrentWP.GDStartColor := secGradColor.Items.Item[0].ColorCode;
  FCurrentWP.GDEndColor := secGradColor.Items.Item[1].ColorCode;

  RenderPreview;
  CenterUpdatePreview;
end;

procedure TfrmWPSettings.UpdateGUIFromWPItem(AWPItem: TWPItem);
begin
  chkWpMirrorVert.OnClick := nil;
  chkWpMirrorHoriz.OnClick := nil;
  chkApplyColor.OnClick := nil;
  chkApplyGrad.OnClick := nil;
  rdoWpAlignStretch.OnClick := nil;
  rdoWpAlignScale.OnClick := nil;
  rdoWpAlignCenter.OnClick := nil;
  rdoWpAlignTile.OnClick := nil;
  edtWpFile.OnChange := nil;
  try

    FCurrentWP := AWPItem;
    case AWPItem.Size of
      twsCenter: rdoWpAlignCenter.Checked := True;
      twsScale: rdoWpAlignScale.Checked := True;
      twsStretch: rdoWpAlignStretch.Checked := True;
      twsTile: rdoWpAlignTile.Checked := True;
    end;
    chkWpMirrorHoriz.Checked := AWPItem.MirrorHoriz;
    chkWpMirrorVert.Checked := AWPItem.MirrorVert;
    edtWpFile.Text := AWPItem.Image;
    sgbWpTrans.Value := AWPItem.Alpha;
    chkApplyColor.checked := AWPItem.ColorChange;
    sgbHue.Value := AWPItem.Hue;
    sgbSat.Value := AWPItem.Saturation;
    sgbLum.Value := AWPItem.Lightness;
    chkApplyGrad.Checked := AWPItem.Gradient;
    case AWPItem.GradientType of
      twgtHoriz: cboGradType.ItemIndex := 0;
      twgtVert: cboGradType.ItemIndex := 1;
      twgtTSHoriz: cboGradType.ItemIndex := 2;
      twgtTSVert: cboGradType.ItemIndex := 3;
    end;
    sgbGradStartTrans.Value := AWPItem.GDStartAlpha;
    sgbGradEndTrans.Value := AWPItem.GDEndAlpha;
    secWpColor.Items.Item[0].ColorCode := AWPItem.Color;
    secGradColor.Items.Item[0].ColorCode := AWPItem.GDStartColor;
    secGradColor.Items.Item[1].ColorCode := AWPItem.GDEndColor;

    UpdateWPItemFromGuid;
    RenderPreview;
    CenterUpdatePreview;
  finally
    chkWpMirrorVert.OnClick := MirrorChangeEvent;
    chkWpMirrorHoriz.OnClick := MirrorChangeEvent;
    chkApplyColor.OnClick := ApplyColorClickEvent;
    chkApplyGrad.OnClick := ApplyGradientClickEvent;
    rdoWpAlignStretch.OnClick := AlignmentChangeEvent;
    rdoWpAlignScale.OnClick := AlignmentChangeEvent;
    rdoWpAlignCenter.OnClick := AlignmentChangeEvent;
    rdoWpAlignTile.OnClick := AlignmentChangeEvent;
    edtWpFile.OnChange := edtWallpaperChange;
  end;
end;

procedure TfrmWPSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
  WPList := TObjecTList.Create(False);
end;

procedure TfrmWPSettings.FormDestroy(Sender: TObject);
begin
  WPList.Free;
end;

procedure TfrmWPSettings.edtWallpaperChange(Sender: TObject);
var
  SList: TStringList;
  loaded: boolean;
  exists: boolean;
  i: integer;
  os: boolean;
begin
  if FCurrentWP = nil then exit;

  os := FCurrentWP.WPLoaded;
  loaded := False;
  exists := False;
  SList := TStringList.Create;
  SList.Add(SharpApi.GetSharpeUserSettingsPath + 'Themes\' + FTheme + '\' + edtWpFile.text);
  SList.Add(edtWpFile.text);
  SList.Add(SharpApi.GetSharpeDirectory + edtWpFile.text);
  for i := 0 to SList.Count - 1 do
    if FileExists(SList[i]) then
    try
      FCurrentWP.Image := SList[i];
      FCurrentWP.LoadFromFile;
      exists := True;
      loaded := True;
      break;
    except
    end;
  SList.Free;
  if not loaded then
  begin
    if not exists then
    begin
      FCurrentWP.Image := edtWpFile.Text;
      FCurrentWP.LoadFromFile;
    end;

    if loaded <> os then
    begin
      RenderPreview;
      CenterUpdatePreview;
    end;
  end else
  begin
    RenderPreview;
    CenterUpdatePreview;
  end;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.WallpaperTransChangeEvent(Sender: TObject;
  Value: Integer);
begin
  UpdateWPItemFromGuid;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.WallpaperColorUiChangeEvent(Sender: TObject);
begin
  UpdateWPItemFromGuid;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.MonitorChangeEvent(Sender: TObject);
begin
  FCurrentWP := TWPItem(cboMonitor.Items.Objects[cboMonitor.ItemIndex]);
  UpdateWPItemFromGuid;
  RenderPreview;
  CenterUpdatePreview;
end;

procedure TfrmWPSettings.cb_gtypeChange(Sender: TObject);
begin
  UpdateWPItemFromGuid;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.ApplyGradientClickEvent(Sender: TObject);
begin
  UpdateWPItemFromGuid;
  UpdateGradientPage;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.ApplyColorClickEvent(Sender: TObject);
begin
  UpdateWPItemFromGuid;
  UpdateColorPage;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.btnWpBrowseClick(Sender: TObject);
begin
  if dlgOpen.Execute then begin
    edtWpFile.Text := dlgOpen.FileName;
  end;
end;

procedure TfrmWPSettings.AlignmentChangeEvent(Sender: TObject);
begin
  UpdateWPItemFromGuid;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.MirrorChangeEvent(Sender: TObject);
begin
  UpdateWPItemFromGuid;
  CenterDefineSettingsChanged;
end;

procedure TfrmWPSettings.fedit_image_KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtWpFile.OnChange(edtWpFile);
end;

end.

