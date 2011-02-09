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

unit uSettingsWnd;

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
  JvSimpleXml,
  Menus,
  ComCtrls,
  SharpApi,
  JvExComCtrls,
  JvComCtrls,
  ExtCtrls,
  JvPageList,
  JvExControls,
  JvComponent,
  SharpEGaugeBoxEdit,
  Buttons,
  PngBitBtn,
  GR32_Image,
  GR32_Backends,
  SharpEColorEditorEx,
  Mask,
  JvExMask,
  JvToolEdit,
  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts,
  Contnrs,
  GR32,
  GR32_Resamplers,
  SharpCenterApi,
  SharpESwatchManager,
  SharpGraphicsUtils,
  JPeg,
  SharpETabList,
  SharpERoundPanel,
  SharpEPageControl, SharpECenterHeader, JvXPCore, JvXPCheckCtrls,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit, JvBrowseFolder;

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
    FileName: string;
    ColorStr: string;
    Alpha: integer;
    Size: TThemeWallpaperSize;
    ColorChange: boolean;
    Hue: integer;
    Saturation: integer;
    Lightness: integer;
    Gradient: boolean;
    GradientType: TThemeWallpaperGradientType;
    GDStartColorStr: string;
    GDStartAlpha: integer;
    GDEndColorStr: string;
    GDEndAlpha: integer;
    MirrorHoriz: boolean;
    MirrorVert: boolean;
    Switch : Boolean;
    SwitchPath : string;
    SwitchRecursive : Boolean;
    SwitchRandomize : Boolean;
    SwitchTimeout : Integer;

    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure LoadFromFile;
  end;

  TfrmSettingsWnd = class(TForm)
    secWpColor: TSharpEColorEditorEx;
    ssmConfig: TSharpESwatchManager;
    dlgOpen: TOpenDialog;
    plConfig: TJvPageList;
    pagWallpaper: TJvStandardPage;
    pagColor: TJvStandardPage;
    pagGradient: TJvStandardPage;
    pnlWallpaperFilePath: TPanel;
    edtWpFile: TEdit;
    btnWpBrowse: TButton;
    Panel7: TPanel;
    Panel8: TPanel;
    imgWallpaper: TImage32;
    Panel9: TPanel;
    sgbWpTrans: TSharpeGaugeBox;
    pnlMonitor: TSharpERoundPanel;
    cboMonitor: TComboBox;
    imgColor: TImage32;
    pnlColorHSL: TPanel;
    Panel10: TPanel;
    sgbLum: TSharpeGaugeBox;
    sgbSat: TSharpeGaugeBox;
    sgbHue: TSharpeGaugeBox;
    pnlGrad: TPanel;
    Panel5: TPanel;
    cboGradType: TComboBox;
    Panel11: TPanel;
    sgbGradStartTrans: TSharpeGaugeBox;
    sgbGradEndTrans: TSharpeGaugeBox;
    secGradColor: TSharpEColorEditorEx;
    imgGradient: TImage32;
    chkApplyColor: TJvXPCheckbox;
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    chkApplyGrad: TJvXPCheckbox;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader4: TSharpECenterHeader;
    SharpECenterHeader5: TSharpECenterHeader;
    SharpECenterHeader6: TSharpECenterHeader;
    SharpECenterHeader7: TSharpECenterHeader;
    rdoWpAlignStretch: TJvXPCheckbox;
    rdoWpAlignScale: TJvXPCheckbox;
    rdoWpAlignCenter: TJvXPCheckbox;
    rdoWpAlignTile: TJvXPCheckbox;
    SharpECenterHeader8: TSharpECenterHeader;
    chkWpMirrorVert: TJvXPCheckbox;
    chkWpMirrorHoriz: TJvXPCheckbox;
    SharpECenterHeader9: TSharpECenterHeader;
    SharpECenterHeader10: TSharpECenterHeader;
    chkAutoWallpaper: TJvXPCheckbox;
    pnlWallpaperDirectoryPath: TPanel;
    edtWpDirectory: TEdit;
    btnWpDirectoryBrowse: TButton;
    chkWpRecursive: TJvXPCheckbox;
    sgbWpChangeInterval: TSharpeGaugeBox;
    chkWpRandomize: TJvXPCheckbox;
    pnlWallpaperOptions: TPanel;
    pnlWallpaper: TPanel;
    pnlColor: TPanel;
    pnlGradient: TPanel;
    SharpECenterHeader11: TSharpECenterHeader;
    SharpECenterHeader12: TSharpECenterHeader;
    Panel1: TPanel;
    procedure fedit_image_KeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure MirrorChangeEvent(Sender: TObject);
    procedure AlignmentChangeEvent(Sender: TObject);
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
    procedure cboGradTypeSelect(Sender: TObject);
    procedure chkAutoWallpaperClick(Sender: TObject);
    procedure btnWpDirectoryBrowseClick(Sender: TObject);
    procedure chkWpRecursiveClick(Sender: TObject);
    procedure chkWpRandomizeClick(Sender: TObject);
    procedure sgbWpChangeIntervalChangeValue(Sender: TObject; Value: Integer);
    procedure edtWpDirectoryChange(Sender: TObject);
    procedure secColorExpandCollapse(ASender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    FCurrentWP: TWPItem;
    FTheme: ISharpETheme;
    procedure UpdateWpItem;

    procedure UpdateSize;
  public
    procedure UpdateGUIFromWPItem(AWPItem: TWPItem);
    procedure UpdateWPItemFromGUI;
    procedure RenderPreview;

    procedure UpdatePageUI;
    procedure UpdateWallpaperPage;
    procedure UpdateColorPage;
    procedure UpdateGradientPage;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
    property CurrentWP: TWPItem read FCurrentWP write FCurrentWP;
    property Theme: ISharpETheme read FTheme write FTheme;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;
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
  ColorStr := '0';
  Alpha := 255;
  Size := twsScale;
  ColorChange := False;
  Hue := 0;
  Saturation := 0;
  Lightness := 0;
  Gradient := False;
  GradientType := twgtVert;
  GDStartColorStr := '0';
  GDStartAlpha := 0;
  GDEndColorStr := '0';
  GDEndAlpha := 255;
  MirrorHoriz := False;
  MirrorVert := False;
  SwitchRecursive := False;
  SwitchRandomize := True;
  SwitchTimeout := 0;

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
  loaded: boolean;
  SList: TStringList;
  i: integer;
begin
  loaded := False;
  SList := TStringList.Create;
  SList.Add(SharpApi.GetSharpeUserSettingsPath + 'Themes\' + frmSettingsWnd.PluginHost.PluginId + '\' + FileName);
  SList.Add(FileName);
  SList.Add(SharpApi.GetSharpeDirectory + FileName);
  for i := 0 to SList.Count - 1 do
    if FileExists(SList[i]) then try
      Bmp.LoadFromFile(SList[i]);
      loaded := True;
      break;
    except
    end;
  SList.Free;

  if not loaded then begin
    if Mon <> nil then
      Bmp.SetSize(Mon.Width, Mon.Height)
    else
      Bmp.SetSize(187, 144);
    Bmp.Clear(color32(0, 0, 0, 0));
  end;
  wploaded := loaded;
end;

procedure TfrmSettingsWnd.UpdateWpItem;
begin
  UpdateWPItemFromGUI;
  FPluginHost.SetSettingsChanged;
end;

procedure TfrmSettingsWnd.UpdateSize;
begin
  if pagWallpaper.Visible then
    Self.Height := pnlWallpaper.Height + pnlMonitor.Height + 50
  else if pagColor.Visible then
    Self.Height := pnlColor.Height + pnlMonitor.Height + 50
  else if pagGradient.Visible then
    Self.Height := pnlGradient.Height + pnlMonitor.Height + 50;

  FPluginHost.Refresh(rtSize);
end;

procedure TfrmSettingsWnd.UpdateColorPage;
begin
  if not pagColor.Visible then
    exit;

  pnlColorHSL.Visible := chkApplyColor.Checked;
  UpdateSize;
end;

procedure TfrmSettingsWnd.UpdateGradientPage;
begin
  if not pagGradient.Visible then
    exit;

  pnlGrad.Visible := chkApplyGrad.Checked;
  UpdateSize;
end;

procedure TfrmSettingsWnd.UpdateWallpaperPage;
begin
  UpdateSize;
end;


procedure TfrmSettingsWnd.RenderPreview;
var
  w, w2, h, h2: integer;
  WPBmp: TBitmap32;
  RSBmp: TBitmap32;
  x, y: integer;
  bInvalid: Boolean;
  cGDStartColor, cGDEndColor, cBackground: TColor;

begin

  bInvalid := false;
  if FCurrentWP = nil then
    bInvalid := true;
  if FCurrentWP.Mon = nil then
    bInvalid := true;

  if bInvalid then begin
    exit;
  end;


  WPBmp := TBitmap32.Create;
  TLinearResampler.Create(WPBmp);
  WPBmp.DrawMode := dmBlend;
  WPBmp.CombineMode := cmMerge;
  RSBmp := TBitmap32.Create;
  TLinearResampler.Create(RSBmp);

  with FCurrentWP do begin
    // decide size
    if Mon.Width > Mon.Height then begin
      w := imgWallpaper.Width;
      h := round(imgWallpaper.Width * (Mon.Height / Mon.Width));
    end
    else begin
      h := imgWallpaper.Height;
      w := round(imgWallpaper.Height * (Mon.Width / Mon.Height));
    end;
    w2 := round(Bmp.Width * (w / Mon.Width));
    h2 := round(Bmp.Height * (h / Mon.Height));

    cBackground := FTheme.Scheme.ParseColor(FCurrentWP.ColorStr);
    BmpPreview.SetSize(w, h);
    BmpPreview.Clear(color32(cBackground));

    RSBmp.SetSize(w2, h2);
    Bmp.DrawTo(RSBmp, Rect(0, 0, w2, h2));
    WPBmp.SetSize(w, h);
    WPBmp.Clear(color32(0, 0, 0, 0));
    case Size of
      twsStretch: RSBmp.DrawTo(WPBmp, Rect(0, 0, w, h));
      twsCenter: RSBmp.DrawTo(WPBmp, WPBmp.Width div 2 - RSBmp.Width div 2,
          WPBmp.Height div 2 - RSBmp.Height div 2);
      twsScale: begin
          if ((w2 <> 0) and (h2 <> 0)) then begin
            if w2 / h2 = w / h then
              RSBmp.Drawto(WPBmp, Rect(0, 0, w, h))
            else if (w2 / h2) > (w / h) then
              RSBmp.DrawTo(WPBmp, Rect(0, round(h / 2 - (w / w2) * h2 / 2), w, round(h / 2 + (w / w2) * h2 / 2)))
            else
              RSBmp.DrawTo(WPBmp, Rect(round(w / 2 - (h / h2) * w2 / 2), 0, round(w / 2 + (h / h2) * w2 / 2), h));
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

    if Gradient then begin
      cGDStartColor := FTheme.Scheme.ParseColor(GDStartColorStr);
      cGDEndColor := FTheme.Scheme.ParseColor(GDEndColorStr);
      ApplyGradient(WPBmp, GradientType,
        cGDStartColor, cGDEndColor, GDStartAlpha, GDEndAlpha);
    end;

    WPBmp.MasterAlpha := Alpha;
    WPBmp.DrawTo(BmpPreview, 0, 0);

    BmpPreview.FrameRectS(0, 0, w, h, Color32(0, 0, 0, 255));
  end;

  RSBmp.Free;
  WPBmp.Free;
end;

procedure TfrmSettingsWnd.HSLColorChangeEvent(Sender: TObject; Value: Integer);
begin
  UpdateWpItem;
end;

procedure TfrmSettingsWnd.chkAutoWallpaperClick(Sender: TObject);
begin
  pnlWallpaperFilePath.Visible := not chkAutoWallpaper.Checked;
  pnlWallpaperDirectoryPath.Visible := chkAutoWallpaper.Checked;
  
  UpdateWpItem;
  UpdateSize;
end;

procedure TfrmSettingsWnd.chkWpRandomizeClick(Sender: TObject);
begin
  sgbWpChangeInterval.Enabled := chkWpRandomize.Checked;

  UpdateWpItem;
end;

procedure TfrmSettingsWnd.chkWpRecursiveClick(Sender: TObject);
begin
  UpdateWpItem;
end;

procedure TfrmSettingsWnd.secColorExpandCollapse(ASender: TObject);
begin
  UpdatePageUI;
end;

procedure TfrmSettingsWnd.sgbWpChangeIntervalChangeValue(Sender: TObject;
  Value: Integer);
begin
  if Value = 1 then
    sgbWpChangeInterval.Suffix := ' minute'
  else
    sgbWpChangeInterval.Suffix := ' minutes';

  UpdateWpItem;
end;

procedure TfrmSettingsWnd.UpdateWPItemFromGUI;
begin
  if FCurrentWP = nil then
    exit;

  if rdoWpAlignCenter.Checked then
    FCurrentWP.Size := twsCenter
  else if rdoWpAlignScale.Checked then
    FCurrentWP.Size := twsScale
  else if rdoWpAlignStretch.Checked then
    FCurrentWP.Size := twsStretch
  else if rdoWpAlignTile.Checked then
    FCurrentWP.Size := twsTile;

  FCurrentWP.MirrorHoriz := chkWpMirrorHoriz.Checked;
  FCurrentWP.MirrorVert := chkWpMirrorVert.Checked;

  FCurrentWP.Switch := chkAutoWallpaper.Checked;
  FCurrentWP.SwitchPath := edtWpDirectory.Text;
  FCurrentWP.SwitchRecursive := chkWpRecursive.Checked;
  FCurrentWP.SwitchRandomize := chkWpRandomize.Checked;
  FCurrentWP.SwitchTimeout := sgbWpChangeInterval.Value * 1000 * 60;
  FCurrentWP.FileName := edtWpFile.Text;

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
  FCurrentWP.ColorStr := inttostr(secWpColor.Items.Item[0].ColorCode);
  FCurrentWP.GDStartColorStr := inttostr(secGradColor.Items.Item[0].ColorCode);
  FCurrentWP.GDEndColorStr := inttostr(secGradColor.Items.Item[1].ColorCode);

  RenderPreview;
  FPluginHost.Refresh(rtPreview);
end;

procedure TfrmSettingsWnd.UpdateGUIFromWPItem(AWPItem: TWPItem);
var
  i : integer;
  oldtab : integer;
begin
  oldtab := plConfig.ActivePageIndex;
  chkWpMirrorVert.OnClick := nil;
  chkWpMirrorHoriz.OnClick := nil;
  chkApplyColor.OnClick := nil;
  chkApplyGrad.OnClick := nil;
  rdoWpAlignStretch.OnClick := nil;
  rdoWpAlignScale.OnClick := nil;
  rdoWpAlignCenter.OnClick := nil;
  rdoWpAlignTile.OnClick := nil;
  edtWpFile.OnChange := nil;
  edtWpDirectory.OnChange := nil;
  secWpColor.OnUiChange := nil;
  secGradColor.OnUiChange := nil;
  try

    FCurrentWP := AWPItem;

    rdoWpAlignStretch.Checked := false;
    rdoWpAlignScale.Checked := false;
    rdoWpAlignCenter.Checked := false;
    rdoWpAlignTile.Checked := false;
    case AWPItem.Size of
      twsCenter: rdoWpAlignCenter.Checked := True;
      twsScale: rdoWpAlignScale.Checked := True;
      twsStretch: rdoWpAlignStretch.Checked := True;
      twsTile: rdoWpAlignTile.Checked := True;
    end;
    chkWpMirrorHoriz.Checked := AWPItem.MirrorHoriz;
    chkWpMirrorVert.Checked := AWPItem.MirrorVert;
    edtWpFile.DoubleBuffered := true;
    edtWpFile.Text := AWPItem.FileName;
    edtWpDirectory.DoubleBuffered := True;
    edtWpDirectory.Text := AWPItem.SwitchPath;

    chkAutoWallpaper.Checked := AWPItem.Switch;
    pnlWallpaperFilePath.Visible := not chkAutoWallpaper.Checked;
    pnlWallpaperDirectoryPath.Visible := chkAutoWallpaper.Checked;
    chkWpRecursive.Checked := AWPItem.SwitchRecursive;
    chkWpRandomize.Checked := AWPItem.SwitchRandomize;
    sgbWpChangeInterval.Enabled := chkWpRandomize.Checked;
    sgbWpChangeInterval.Value := AWPItem.SwitchTimeout div 1000 div 60;
    if sgbWpChangeInterval.Value = 1 then
      sgbWpChangeInterval.Suffix := ' minute'
    else
      sgbWpChangeInterval.Suffix := ' minutes';

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
    if TryStrToInt(AWPItem.ColorStr,i) then
      secWpColor.Items.Item[0].ColorCode := i
    else secWpColor.Items.Item[0].ColorCode := FTheme.Scheme.ParseColor(AWPItem.ColorStr);
    if TryStrToInt(AWPItem.GDStartColorStr,i) then
      secGradColor.Items.Item[0].ColorCode := i
    else secGradColor.Items.Item[0].ColorCode := FTheme.Scheme.ParseColor(AWPItem.GDStartColorStr);
    if TryStrToInt(AWPItem.GDEndColorStr,i) then
      secGradColor.Items.Item[0].ColorCode := i
    else secGradColor.Items.Item[0].ColorCode := FTheme.Scheme.ParseColor(AWPItem.GDEndColorStr);

    UpdateWPItemFromGUI;
    RenderPreview;
    FPluginHost.Refresh(rtPreview);
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
    edtWpDirectory.OnChange := edtWallpaperChange;
    secWpColor.OnUiChange := WallpaperColorUiChangeEvent;
    secGradColor.OnUiChange := WallpaperColorUiChangeEvent;    
  end;
  plConfig.ActivePageIndex := oldtab;
end;

procedure TfrmSettingsWnd.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;

  WPList := TObjecTList.Create(True);
end;

procedure TfrmSettingsWnd.FormDestroy(Sender: TObject);
begin
  WPList.Free;
end;

procedure TfrmSettingsWnd.edtWallpaperChange(Sender: TObject);
var
  SList: TStringList;
  loaded: boolean;
  exists: boolean;
  i: integer;
begin
  if FCurrentWP = nil then
    exit;

  loaded := False;
  exists := False;
  SList := TStringList.Create;
  SList.Add(SharpApi.GetSharpeUserSettingsPath + 'Themes\' + frmSettingsWnd.PluginHost.PluginId + '\' + edtWpFile.text);
  SList.Add(edtWpFile.text);
  SList.Add(SharpApi.GetSharpeDirectory + edtWpFile.text);
  for i := 0 to SList.Count - 1 do
    if FileExists(SList[i]) then try
      FCurrentWP.FileName := SList[i];
      FCurrentWP.LoadFromFile;
      exists := True;
      loaded := True;
      break;
    except
    end;
  SList.Free;
  if not loaded then begin
    if not exists then begin
      FCurrentWP.FileName := edtWpFile.Text;
      FCurrentWP.LoadFromFile;
    end;
  end;

  RenderPreview;
  FPluginHost.Refresh(rtPreview);
  UpdateWpItem;
end;

procedure TfrmSettingsWnd.edtWpDirectoryChange(Sender: TObject);
begin
  UpdateWpItem;
end;

procedure TfrmSettingsWnd.WallpaperTransChangeEvent(Sender: TObject;
  Value: Integer);
begin
  UpdateWpItem;
end;

procedure TfrmSettingsWnd.WallpaperColorUiChangeEvent(Sender: TObject);
begin
  UpdateWpItem;
end;

procedure TfrmSettingsWnd.MonitorChangeEvent(Sender: TObject);
begin
  UpdateWPItemFromGUI;
  FCurrentWP := TWPItem(cboMonitor.Items.Objects[cboMonitor.ItemIndex]);
  UpdateGUIFromWPItem(FCurrentWP);

  RenderPreview;
  FPluginHost.Refresh(rtPreview);
end;

procedure TfrmSettingsWnd.cboGradTypeSelect(Sender: TObject);
begin
  UpdateWpItem
end;

procedure TfrmSettingsWnd.ApplyGradientClickEvent(Sender: TObject);
begin
  UpdateWpItem;

  UpdatePageUI;
end;

procedure TfrmSettingsWnd.ApplyColorClickEvent(Sender: TObject);
begin
  UpdateWpItem;

  UpdatePageUI;
end;

procedure TfrmSettingsWnd.btnWpBrowseClick(Sender: TObject);
begin
  if dlgOpen.Execute then begin
    edtWpFile.Text := dlgOpen.FileName;
  end;
end;

procedure TfrmSettingsWnd.btnWpDirectoryBrowseClick(Sender: TObject);
var
  newDirectory : string;
begin
  newDirectory := edtWpDirectory.Text;
  if BrowseForFolder('Browse for wallpaper directory...', True, newDirectory) then
    edtWpDirectory.Text := newDirectory;
end;

procedure TfrmSettingsWnd.AlignmentChangeEvent(Sender: TObject);
begin
  rdoWpAlignStretch.Checked := false;
  rdoWpAlignScale.Checked := false;
  rdoWpAlignCenter.Checked := false;
  rdoWpAlignTile.Checked := false;
  TJvXPCheckbox(sender).Checked := true;

  UpdateWPItemFromGUI;
  FPluginHost.SetSettingsChanged;
end;

procedure TfrmSettingsWnd.MirrorChangeEvent(Sender: TObject);
begin
  UpdateWpItem;
end;

procedure TfrmSettingsWnd.fedit_image_KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  edtWpFile.OnChange(edtWpFile);
end;

procedure TfrmSettingsWnd.UpdatePageUI;
begin
  if pagColor.Visible then
    UpdateColorPage
  else if pagGradient.Visible then
    UpdateGradientPage
  else if pagWallpaper.Visible then
    UpdateWallpaperPage
end;

end.

