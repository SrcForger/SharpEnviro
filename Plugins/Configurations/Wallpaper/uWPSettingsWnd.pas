{
Source Name: uWPSettingsWnd.pas
Description: Theme Wallpaper Settings Window
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

unit uWPSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi,
  JvExComCtrls, JvComCtrls, ExtCtrls, JvPageList, JvExControls, JvComponent,
  SharpEGaugeBoxEdit, Buttons, PngBitBtn, GR32_Image, SharpEColorEditorEx, Mask,
  JvExMask, JvToolEdit, SharpThemeApi, Contnrs, GR32, GR32_Resamplers,
  SharpESwatchManager, SharpGraphicsUtils, JPeg, SharpETabList, SharpERoundPanel;

type
  TWPItem = class
    private
    public
      BmpPreview      : TBitmap32;
      Bmp             : TBitmap32;
      MonID           : integer;
      Mon             : TMonitor;
      Name            : String;
      Image           : String;
      Color           : integer;
      Alpha           : integer;
      Size            : TThemeWallpaperSize;
      ColorChange     : boolean;
      Hue             : integer;
      Saturation      : integer;
      Lightness       : integer;
      Gradient        : boolean;
      GradientType    : TThemeWallpaperGradientType;
      GDStartColor    : integer;
      GDStartAlpha    : integer;
      GDEndColor      : integer;
      GDEndAlpha      : integer;
      MirrorHoriz     : boolean;
      MirrorVert      : boolean;

      constructor Create; reintroduce;
      destructor Destroy; override;

      procedure LoadFromFile;
    published
    end;

  TfrmWPSettings = class(TForm)
    JvPageList1: TJvPageList;
    JvWPPage: TJvStandardPage;
    Panel1: TPanel;
    wpimage: TImage32;
    pn_cchange: TPanel;
    cb_colorchange: TCheckBox;
    sgb_cchue: TSharpeGaugeBox;
    sgb_ccsat: TSharpeGaugeBox;
    sgb_cclight: TSharpeGaugeBox;
    cb_mhoriz: TCheckBox;
    cb_mvert: TCheckBox;
    sgb_wpalpha: TSharpeGaugeBox;
    cb_alignment: TComboBox;
    Label1: TLabel;
    pn_gradient: TPanel;
    cb_gradient: TCheckBox;
    sgb_gstartalpha: TSharpeGaugeBox;
    sgb_gendalpha: TSharpeGaugeBox;
    wpcolors: TSharpEColorEditorEx;
    Panel2: TPanel;
    Panel3: TPanel;
    fedit_image: TJvFilenameEdit;
    SharpESwatchManager1: TSharpESwatchManager;
    cb_gtype: TComboBox;
    Label2: TLabel;
    pgradient: TImage32;
    JvCCPage: TJvStandardPage;
    JvGDPage: TJvStandardPage;
    gdcolors: TSharpEColorEditorEx;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    srr_bg: TSharpERoundPanel;
    ccimage: TImage32;
    tabs: TSharpETabList;
    procedure tabsTabChange(ASender: TObject; const ATabIndex: Integer;
      var AChange: Boolean);
    procedure cb_mhorizClick(Sender: TObject);
    procedure cb_alignmentChange(Sender: TObject);
    procedure cb_gtypeChange(Sender: TObject);
    procedure wpcolorsUiChange(Sender: TObject);
    procedure sgb_gstartalphaChangeValue(Sender: TObject; Value: Integer);
    procedure fedit_imageChange(Sender: TObject);
    procedure sgb_cchueChangeValue(Sender: TObject; Value: Integer);
    procedure cb_gradientClick(Sender: TObject);
    procedure cb_colorchangeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure SendUpdate;
    procedure UpdateCCControls;
    procedure UpdateGDControls;
  public
    sTheme : String;
    currentWP : TWPItem;
    update : boolean;
    procedure UpdateGUIFromWPItem(WPItem : TWPItem);
    procedure UpdateWPItemFromGuid;
    procedure UpdatePreview;
    procedure RenderPreview;
    procedure UpdateGradientPreview;
  end;

var
  frmWPSettings: TfrmWPSettings;
  WPList : TObjectList;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

constructor TWPItem.Create;
begin
  inherited Create;

  Bmp := TBitmap32.Create;
  BmpPreview := TBitmap32.Create;

  // Default Settings
  Color := 0;
  Alpha := 255;
  Size  := twsScale;
  ColorChange := False;
  Hue         := 0;
  Saturation  := 0;
  Lightness   := 0;
  Gradient    := False;
  GradientType := twgtVert;
  GDStartColor := 0;
  GDStartAlpha := 0;
  GDEndColor   := 0;
  GDEndAlpha   := 255;
  MirrorHoriz  := False;
  MirrorVert   := False;

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
  b : boolean;
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
       Bmp.SetSize(Mon.Width,Mon.Height)
       else Bmp.SetSize(187,144);
  end;
end;

procedure TfrmWPSettings.UpdateGradientPreview;
const
  csize = 12;
var
  bmp : TBitmap32;
  x,y : integer;
  gt  : TThemeWallpaperGradientType;
begin
  bmp := TBitmap32.Create;
  bmp.DrawMode := dmBlend;
  bmp.CombineMode := cmMerge;
  bmp.SetSize(pgradient.Width + 2*csize,pgradient.Height + 2*csize);
  bmp.Clear(color32(clsilver));
  for x := 0 to pgradient.Width div (2 * csize) do
      for y := 0 to pgradient.Height div (csize) do
          if y mod 2 = 0 then
             bmp.FillRect(2*x*csize,y*csize,2*x*csize + csize,y*csize + csize,clWhite32)
             else bmp.FillRect(2*x*csize + csize,y*csize,2*x*csize + 2*csize,y*csize + csize,clWhite32);

  case cb_gtype.ItemIndex of
    0: gt := twgtHoriz;
    1: gt := twgtVert;
    2: gt := twgtTSHoriz;
    else gt := twgtTSVert;
  end;

  pgradient.Bitmap.SetSize(pgradient.Width,pgradient.Height);
  bmp.DrawTo(pgradient.Bitmap);
  bmp.Free;

  pgradient.BeginUpdate;
  ApplyGradient(pgradient.Bitmap,gt,
                gdcolors.Items.Item[0].ColorCode,
                gdcolors.Items.Item[1].ColorCode,
                sgb_gstartalpha.Value,
                sgb_gendalpha.Value);
  pgradient.EndUpdate;

  pgradient.Bitmap.FrameRectS(0,0,pgradient.Width,pgradient.Height,Color32(0,0,0,255));
end;

procedure TfrmWPSettings.UpdatePreview;
begin
  SharpCenterBroadCast(SCM_EVT_UPDATE_PREVIEW, 0);
end;

procedure TfrmWPSettings.RenderPreview;
var
  w,w2,h,h2 : integer;
  WPBmp : TBitmap32;
  RSBmp : TBitmap32;
  x,y : integer;
begin
  if CurrentWP = nil then exit;
  if CurrentWP.Mon = nil then exit;

  WPBmp := TBitmap32.Create;
  WPBmp.DrawMode := dmBlend;
  WPBmp.CombineMode := cmMerge;
  RSBmp := TBitmap32.Create;

  with CurrentWP do
  begin
    // decide size
    if Mon.Width > Mon.Height then
    begin
      w := wpimage.Width;
      h := round(wpimage.Width * (Mon.Height / Mon.Width));
    end else
    begin
      h := wpimage.Height;
      w := round(wpimage.Height * (Mon.Width / Mon.Height));
    end;
    w2 := round(Bmp.Width * (w / Mon.Width));
    h2 := round(Bmp.Height * (h / Mon.Height));

    BmpPreview.SetSize(w,h);
    BmpPreview.Clear(color32(CurrentWP.Color));

    RSBmp.SetSize(w2,h2);
    Bmp.DrawTo(RSBmp,Rect(0,0,w2,h2));
    WPBmp.SetSize(w,h);
    WPBmp.Clear(color32(0,0,0,0));
    case Size of
      twsStretch: RSBmp.DrawTo(WPBmp,Rect(0,0,w,h));
      twsCenter: RSBmp.DrawTo(WPBmp,WPBmp.Width div 2 - RSBmp.Width div 2,
                                    WPBmp.Height div 2 - RSBmp.Height div 2);
      twsScale:
        begin
          if w2/h2 = w/h then
             RSBmp.Drawto(WPBmp,Rect(0,0,w,h))
          else if (w2/h2) > (w/h) then
                  RSBmp.DrawTo(WPBmp,Rect(0,round(h / 2 - (w/w2)*h2 / 2),w,round(h / 2 + (w/w2)*h2 / 2)))
          else RSBmp.DrawTo(WPBmp,Rect(round(w / 2 - (h/h2)*w2 / 2),0,round(w / 2 + (h/h2)*w2 / 2),h));
        end;
      twsTile:
        for x := 0 to w div w2 do
            for y := 0 to h div h2 do
                RSBmp.DrawTo(WPBmp,x*w2,y*h2);
    end;

    wpimage.bitmap.assign(WPBmp);
    wpimage.bitmap.FrameRectS(0,0,w,h,Color32(0,0,0,255));

    if MirrorHoriz then
       WPBmp.Canvas.CopyRect(Rect(WPBmp.Width,0,0,WPBmp.Height),WPBmp.Canvas,Rect(0,0,WPBmp.Width,WPBmp.Height));
    if MirrorVert then
       WPBmp.Canvas.CopyRect(Rect(0,WPBmp.Height,WPBmp.Width,0),WPBmp.Canvas,Rect(0,0,WPBmp.Width,WPBmp.Height));

    if ColorChange then
       HSLChangeImage(WPBmp,Hue,Saturation,Lightness);

    ccimage.bitmap.assign(WPBmp);
    ccimage.bitmap.FrameRectS(0,0,w,h,Color32(0,0,0,255));

    if Gradient then
       ApplyGradient(WPBmp,GradientType,
                     GDStartColor,GDEndColor,GDStartAlpha,GDEndAlpha);

    WPBmp.MasterAlpha := Alpha;
    WPBmp.DrawTo(BmpPreview,0,0);

    BmpPreview.FrameRectS(0,0,w,h,Color32(0,0,0,255));
  end;

  RSBmp.Free;
  WPBmp.Free;
end;

procedure TfrmWPSettings.UpdateWPItemFromGuid;
begin
  if update then exit;
  if currentWP = nil then exit;

  case cb_alignment.ItemIndex of
    0: currentWP.Size := twsCenter;
    1: currentWP.Size := twsScale;
    2: currentWP.Size := twsStretch;
    3: currentWP.Size:=  twsTile;
  end;
  currentWP.MirrorHoriz     := cb_mhoriz.Checked;
  currentWP.MirrorVert      := cb_mvert.Checked;
  currentWP.Image           := fedit_image.Text;
  currentWP.Alpha           := sgb_wpalpha.Value;
  currentWP.ColorChange     := cb_colorchange.checked;
  currentWP.Hue             := sgb_cchue.Value;
  currentWP.Saturation      := sgb_ccsat.Value;
  currentWP.Lightness       := sgb_cclight.Value;
  currentWP.Gradient        := cb_gradient.Checked;
  case cb_gtype.ItemIndex of
    0: currentWP.GradientType := twgtHoriz;
    1: currentWP.GradientType := twgtVert;
    2: currentWP.GradientType := twgtTSHoriz;
    3: currentWP.GradientType := twgtTSVert;
  end;
  currentWP.GDStartAlpha := sgb_gstartalpha.Value;
  currentWP.GDEndAlpha   := sgb_gendalpha.Value;
  currentWP.Color        := wpcolors.Items.Item[0].ColorCode;
  currentWP.GDStartColor := gdcolors.Items.Item[0].ColorCode;
  currentWP.GDEndColor   := gdcolors.Items.Item[1].ColorCode;

  RenderPreview;
  UpdatePreview;
  SendUpdate;
end;

procedure TfrmWPSettings.UpdateGUIFromWPItem(WPItem : TWPItem);
begin
  update := True;
  currentWP := WPItem;
  case WPItem.Size of
    twsCenter  : cb_alignment.ItemIndex := 0;
    twsScale   : cb_alignment.ItemIndex := 1;
    twsStretch : cb_alignment.ItemIndex := 2;
    twsTile    : cb_alignment.ItemIndex := 3;
  end;
  cb_mhoriz.Checked      := WPItem.MirrorHoriz;
  cb_mvert.Checked       := WPItem.MirrorVert;
  fedit_image.Text       := WPItem.Image;
  sgb_wpalpha.Value      := WPItem.Alpha;
  cb_colorchange.checked := WPItem.ColorChange;
  sgb_cchue.Value        := WPItem.Hue;
  sgb_ccsat.Value        := WPItem.Saturation;
  sgb_cclight.Value      := WPItem.Lightness;
  cb_gradient.Checked    := WPItem.Gradient;
  case WPItem.GradientType of
    twgtHoriz   : cb_gtype.ItemIndex := 0;
    twgtVert    : cb_gtype.ItemIndex := 1;
    twgtTSHoriz : cb_gtype.ItemIndex := 2;
    twgtTSVert  : cb_gtype.ItemIndex := 3;
  end;
  sgb_gstartalpha.Value := WPItem.GDStartAlpha;
  sgb_gendalpha.Value   := WPItem.GDEndAlpha;
  wpcolors.Items.Item[0].ColorCode := WPItem.Color;
  gdcolors.Items.Item[0].ColorCode := WPItem.GDStartColor;
  gdcolors.Items.Item[1].ColorCode := WPItem.GDEndColor;

  Update := False;
  RenderPreview;
  UpdatePreview;
end;

procedure TfrmWPSettings.UpdateCCControls;
begin
  if cb_colorchange.checked then
     pn_cchange.Height := 193
     else pn_cchange.Height := 32;
end;
procedure TfrmWPSettings.UpdateGDControls;
begin
  if cb_gradient.Checked then
     pn_gradient.Height := 145
     else pn_gradient.Height := 32;

  if cb_gradient.Checked then
     UpdateGradientPreview;

  gdcolors.Items.Item[0].Visible := cb_gradient.Checked;
  gdcolors.Items.Item[1].Visible := cb_gradient.Checked;
end;

procedure TfrmWPSettings.FormCreate(Sender: TObject);
begin
  Update := False;
  Self.DoubleBuffered := true;
  
  WPList := TObjecTList.Create(False);
end;

procedure TfrmWPSettings.SendUpdate;
begin
  if Visible then
     SharpEBroadCast(WM_SHARPCENTERMESSAGE, SCM_SET_SETTINGS_CHANGED, 0);
end;

procedure TfrmWPSettings.FormDestroy(Sender: TObject);
begin
  WPList.Free;
end;

procedure TfrmWPSettings.FormShow(Sender: TObject);
begin
  UpdateCCControls;
  UpdateGDControls
end;

procedure TfrmWPSettings.cb_colorchangeClick(Sender: TObject);
begin
  UpdateCCControls;
  UpdateWPItemFromGuid;
end;

procedure TfrmWPSettings.cb_gradientClick(Sender: TObject);
begin
  UpdateGDControls;
  UpdateWPItemFromGuid;
end;

procedure TfrmWPSettings.sgb_cchueChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateWPItemFromGuid;
end;

procedure TfrmWPSettings.fedit_imageChange(Sender: TObject);
begin
  if CurrentWP = nil then exit;
  CurrentWP.Image := fedit_image.text;
  CurrentWP.LoadFromFile;
  RenderPreview;
  UpdatePreview;
end;

procedure TfrmWPSettings.sgb_gstartalphaChangeValue(Sender: TObject;
  Value: Integer);
begin
  UpdateGradientPreview;
  UpdateWPItemFromGuid;
end;

procedure TfrmWPSettings.wpcolorsUiChange(Sender: TObject);
begin
  UpdateWPItemFromGuid;
  UpdateGradientPreview;
end;

procedure TfrmWPSettings.cb_gtypeChange(Sender: TObject);
begin
  UpdateWPItemFromGuid;
  UpdateGradientPreview;
end;

procedure TfrmWPSettings.cb_alignmentChange(Sender: TObject);
begin
  UpdateWPItemFromGuid;
end;

procedure TfrmWPSettings.cb_mhorizClick(Sender: TObject);
begin
  UpdateWPItemFromGuid;
end;

procedure TfrmWPSettings.tabsTabChange(ASender: TObject;
  const ATabIndex: Integer; var AChange: Boolean);
begin
  AChange := True;
  case ATabIndex of
    0: JvPageList1.ActivePage := JvWPPage;
    1: JvPageList1.ActivePage := JvCCPage;
    2: JvPageList1.ActivePage := JvGDPage;
    else AChange := False;
  end;
end;

end.

