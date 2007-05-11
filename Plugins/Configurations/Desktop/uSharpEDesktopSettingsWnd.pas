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
  JvSpin, SharpEGaugeBoxEdit;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmDesktopSettings = class(TForm)
    JvPageList1: TJvPageList;
    JvIconPage: TJvStandardPage;
    JvTextPage: TJvStandardPage;
    JvAnimationPage: TJvStandardPage;
    Panel1: TPanel;
    pn_iconsize: TPanel;
    icon32: TImage32;
    icon48: TImage32;
    icon64: TImage32;
    iconcustom: TImage32;
    rb_icon32: TRadioButton;
    rb_icon48: TRadioButton;
    rb_icon64: TRadioButton;
    rb_iconcustom: TRadioButton;
    Label1: TLabel;
    pn_alphablendbg: TPanel;
    SharpESwatchManager1: TSharpESwatchManager;
    IconColors: TSharpEColorEditorEx;
    Panel4: TPanel;
    imlFontIcons: TImageList;
    Panel5: TPanel;
    cbxFontName: TComboBox;
    Label5: TLabel;
    Panel7: TPanel;
    se_fontsize: TJvSpinEdit;
    Label9: TLabel;
    cb_bold: TCheckBox;
    cb_italic: TCheckBox;
    cb_underline: TCheckBox;
    textcolors: TSharpEColorEditorEx;
    Panel6: TPanel;
    pn_anim: TPanel;
    Panel9: TPanel;
    cb_anim: TCheckBox;
    pn_alphablend: TPanel;
    Panel10: TPanel;
    sgb_iconalpha: TSharpeGaugeBox;
    Panel11: TPanel;
    cb_alphablend: TCheckBox;
    pn_colorblendbg: TPanel;
    pn_colorblend: TPanel;
    sbg_iconcblendalpha: TSharpeGaugeBox;
    Panel13: TPanel;
    Panel14: TPanel;
    cb_colorblend: TCheckBox;
    pn_iconshadowbg: TPanel;
    pn_iconshadow: TPanel;
    sgb_iconshadow: TSharpeGaugeBox;
    Panel15: TPanel;
    Panel16: TPanel;
    cb_iconshadow: TCheckBox;
    Panel2: TPanel;
    Panel12: TPanel;
    Panel17: TPanel;
    sgb_iconsize: TSharpeGaugeBox;
    pn_textshadowbg: TPanel;
    pn_textshadow: TPanel;
    sgb_textshadow: TSharpeGaugeBox;
    Panel20: TPanel;
    Panel21: TPanel;
    cb_textshadow: TCheckBox;
    pn_fontalphablendbg: TPanel;
    pn_fontalphablend: TPanel;
    sgb_fontalphablend: TSharpeGaugeBox;
    Panel24: TPanel;
    Panel25: TPanel;
    cb_fontalphablend: TCheckBox;
    Panel3: TPanel;
    Panel18: TPanel;
    pn_animscalebg: TPanel;
    pn_animscale: TPanel;
    sgb_animscale: TSharpeGaugeBox;
    Panel22: TPanel;
    Panel23: TPanel;
    cb_animscale: TCheckBox;
    pn_animalphabg: TPanel;
    pn_animalpha: TPanel;
    sgb_animalpha: TSharpeGaugeBox;
    Panel26: TPanel;
    Panel27: TPanel;
    cb_animalpha: TCheckBox;
    pn_animbrightnessbg: TPanel;
    pn_animbrightness: TPanel;
    sgb_animbrightness: TSharpeGaugeBox;
    Panel28: TPanel;
    Panel29: TPanel;
    cb_animbrightness: TCheckBox;
    pn_animcolorblendbg: TPanel;
    pn_animcolorblend: TPanel;
    sgb_animcolorblend: TSharpeGaugeBox;
    Panel30: TPanel;
    Panel31: TPanel;
    cb_animcolorblend: TCheckBox;
    Panel19: TPanel;
    animcolors: TSharpEColorEditorEx;
    Panel8: TPanel;
    procedure cb_animscaleClick(Sender: TObject);
    procedure cb_animClick(Sender: TObject);
    procedure cb_boldClick(Sender: TObject);
    procedure sgb_iconalphaChangeValue(Sender: TObject; Value: Integer);
    procedure cb_textshadowClick(Sender: TObject);
    procedure cb_fontalphablendClick(Sender: TObject);
    procedure cbxFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cb_iconshadowClick(Sender: TObject);
    procedure cb_colorblendClick(Sender: TObject);
    procedure cb_alphablendClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rb_iconcustomClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FBlue32,FBlue48,FBlue64 : TBitmap32;
    FWhite32,FWhite48,FWhite64 : TBitmap32;
    FFontList : TFontList;
    procedure SendUpdate;
    procedure RefreshFontList;
    procedure UpdateIconControls;
    procedure UpdateAlphaControls;
    procedure UpdateFontAlphaControls;
    procedure UpdateBlendControls;
    procedure UpdateIconShadowControls;
    procedure UpdateTextShadowControls;
    procedure UpdateAnimationControls;
    procedure DrawCustomIcon;
  public
    sTheme : String;
    sFontName : String;
  end;

var
  frmDesktopSettings: TfrmDesktopSettings;

implementation

{$R *.dfm}
{$R icons.res}

{ TfrmConfigListWnd }

procedure LoadBmpFromRessource(Bmp : TBitmap32; ResName : String);
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
  if Bmp = nil then exit;

  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(22,22);
  TempBmp.Clear(color32(0,0,0,0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, ResName, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      Bmp.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;
end;

procedure TfrmDesktopSettings.DrawCustomIcon;
var
  c : TColor32;
begin
  with iconcustom.Bitmap do
  begin
    SetSize(64,64);
    clear(color32(iconcustom.Color));
    Font.Size := 48;
    if rb_iconcustom.Checked then
       c := clBlack32
       else c := clLightGray32;
    RenderText(32-TextWidth('?') div 2,32-TextHeight('?') div 2,'?',1,c);
  end;
end;

procedure TfrmDesktopSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;

  FBlue32  := TBitmap32.Create;
  FBlue48  := TBitmap32.Create;
  FBlue64  := TBitmap32.Create;
  FWhite32 := TBitmap32.Create;
  FWhite48 := TBitmap32.Create;
  FWhite64 := TBitmap32.Create;

  FFontList := TFontList.Create;

  LoadBmpFromRessource(FBlue32,'Blue32');
  LoadBmpFromRessource(FBlue48,'Blue48');
  LoadBmpFromRessource(FBlue64,'Blue64');
  LoadBmpFromRessource(FWhite32,'White32');
  LoadBmpFromRessource(FWhite48,'White48');
  LoadBmpFromRessource(FWhite64,'White64');

  DrawCustomIcon;
end;

procedure TfrmDesktopSettings.UpdateIconControls;
begin
  pn_iconsize.Visible := rb_iconcustom.checked;

  if rb_icon32.Checked then
     icon32.Bitmap.Assign(FBlue32)
     else icon32.Bitmap.Assign(FWhite32);

  if rb_icon48.Checked then
     icon48.Bitmap.Assign(FBlue48)
     else icon48.Bitmap.Assign(FWhite48);

  if rb_icon64.Checked then
     icon64.Bitmap.Assign(FBlue64)
     else icon64.Bitmap.Assign(FWhite64);

  DrawCustomIcon;
end;

procedure TfrmDesktopSettings.UpdateAnimationControls;
begin
  pn_anim.Visible := cb_anim.checked;
  pn_animscale.Visible := cb_animscale.Checked;
  pn_animalpha.Visible := cb_animalpha.Checked;
  pn_animbrightness.Visible := cb_animbrightness.Checked;
  pn_animcolorblend.Visible := cb_animcolorblend.Checked;
end;

procedure TfrmDesktopSettings.UpdateFontAlphaControls;
begin
  pn_fontalphablend.visible := cb_fontalphablend.checked;
end;

procedure TfrmDesktopSettings.UpdateAlphaControls;
begin
  pn_alphablend.visible := cb_alphablend.checked;
end;

procedure TfrmDesktopSettings.UpdateBlendControls;
begin
  pn_colorblend.visible := cb_colorblend.checked;
end;

procedure TfrmDesktopSettings.UpdateTextShadowControls;
begin
  pn_textshadow.visible := cb_textshadow.checked;
end;

procedure TfrmDesktopSettings.UpdateIconShadowControls;
begin
  pn_iconshadow.Visible := cb_iconshadow.Checked;
end;

procedure TfrmDesktopSettings.SendUpdate;
begin
  if Visible then
     SharpEBroadCast(WM_SHARPCENTERMESSAGE, SCM_SET_SETTINGS_CHANGED, 0);
end;

procedure TfrmDesktopSettings.rb_iconcustomClick(Sender: TObject);
begin
  UpdateIconControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.FormShow(Sender: TObject);
begin
  RefreshFontList;
  if cbxFontName.Items.IndexOf(sFontName) <> 0 then
     cbxFontName.ItemIndex := cbxFontName.Items.IndexOf(sFontName);
  UpdateIconControls;
  UpdateAlphaControls;
  UpdateFontAlphaControls;
  UpdateBlendControls;
  UpdateIconShadowControls;
  UpdateTextShadowControls;
  UpdateAnimationControls;
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

procedure TfrmDesktopSettings.cb_alphablendClick(Sender: TObject);
begin
  UpdateAlphaControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cb_colorblendClick(Sender: TObject);
begin
  UpdateBlendControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cb_iconshadowClick(Sender: TObject);
begin
  UpdateIconShadowControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.RefreshFontList;
var
  fi: TFontInfo;
  i: integer;
  DuplicateCheck: Integer;
begin
  FFontList.List.Clear;

  cbxFontName.Items.Clear;
  //cbxFontName.Sorted := True;
  try
    FFontList.RefreshFontInfo;
    for i := 0 To pred(FFontList.List.Count) do begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cbxFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
      cbxFontName.Items.Add(FFontList.List.Strings[i]);
    end;
  finally
    cbxFontName.ItemIndex := 0;
  end;
end;

procedure TfrmDesktopSettings.cbxFontNameDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  fi:TFontInfo;
  imageindex : integer;
  itemindex  : integer;
  textheight : integer;
begin
  cbxFontName.canvas.fillrect(rect);

  itemindex := FFontList.List.IndexOf(cbxFontName.Items.Strings[index]);
  fi := TFontInfo(FFontList.List.Objects[itemindex]);

  imageindex := -1;
  case fi.FontType of
    ftTrueType : imageindex := 0;
    ftRaster   : imageindex := 1;
    ftDevice   : imageindex := 2;
  end;

  imlFontIcons.Draw(cbxFontName.Canvas,rect.left,rect.top,imageindex);

  cbxFontName.Canvas.Font.Name := fi.ShortName;
  textheight := cbxFontName.Canvas.TextHeight(fi.FullName);

  if textheight > cbxFontName.ItemHeight then
     cbxFontName.Canvas.Font.Name := 'Arial';

  cbxFontName.canvas.textout(rect.left+imlFontIcons.width+2,rect.top,fi.FullName);
end;

procedure TfrmDesktopSettings.cb_fontalphablendClick(Sender: TObject);
begin
  UpdateFontAlphaControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cb_textshadowClick(Sender: TObject);
begin
  UpdateTextShadowControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.sgb_iconalphaChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.cb_boldClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDesktopSettings.cb_animClick(Sender: TObject);
begin
  UpdateAnimationControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cb_animscaleClick(Sender: TObject);
begin
  UpdateAnimationControls;
  SendUpdate;
end;

end.

