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
  TStringObject = Class(TObject)
  public
    Str:String;
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
    lblIconTrans: TLabel;
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
    lblIconShadow: TLabel;
    sgbIconShadow: TSharpeGaugeBox;
    Panel10: TPanel;
    lblIconColorDet: TLabel;
    Label7: TLabel;
    sceIconColor: TSharpEColorEditorEx;
    lblFontNameDet: TLabel;
    lblFontSizeDet: TLabel;
    lblFontTransDet: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    lblFontStyleDet: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    lblFontColorDet: TLabel;
    pagFontShadow: TJvStandardPage;
    lblFontShadowDet: TLabel;
    textpanel: TPanel;
    lblShadowTypeDet: TLabel;
    lblFontShadowTrans: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lblFontShadowColDet: TLabel;
    sceShadowColor: TSharpEColorEditorEx;
    cboFontName: TComboBox;
    chkIconTrans: TJvCheckBox;
    chkColorBlend: TJvCheckBox;
    chkIconShadow: TJvCheckBox;
    chkUnderline: TJvCheckBox;
    chkItalic: TJvCheckBox;
    chkBold: TJvCheckBox;
    chkFontShadow: TJvCheckBox;
    cbShadowType: TComboBox;
    Panel5: TPanel;
    sgbFontSize: TSharpeGaugeBox;
    Panel7: TPanel;
    sgbFontTrans: TSharpeGaugeBox;
    Panel11: TPanel;
    sgbFontShadowTrans: TSharpeGaugeBox;
    chkAnim: TJvCheckBox;
    Label5: TLabel;
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
    procedure IconColorsUiChange(Sender: TObject);
    procedure cbanimscaleClick(Sender: TObject);
    procedure cbanimClick(Sender: TObject);
    procedure cbboldClick(Sender: TObject);
    procedure SendUpdateEvent(Sender: TObject; Value: Integer);
    procedure cbtextshadowClick(Sender: TObject);
    procedure cbfontalphablendClick(Sender: TObject);
    procedure cboFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure chkIconShadowClick(Sender: TObject);
    procedure cbiconblendClick(Sender: TObject);
    procedure chkIconTransClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rdoIconCustomClick(Sender: TObject);
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
  public
    FTheme : String;
    FFontName : String;
  end;

var
  frmDesktopSettings: TfrmDesktopSettings;

implementation

uses
  SharpCenterApi;

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
end;

procedure TfrmDesktopSettings.UpdateIconControls;
begin
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
end;

procedure TfrmDesktopSettings.UpdateAnimationControls;
begin
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
  lblAnimColorBlendDet.Enabled := chkColorBlend.Checked;
  sgbAnimColorBlend.Enabled := chkColorBlend.Checked;
  sceAnimColor.Visible := chkColorBlend.Checked;
  sceAnimColor.Items.Item[0].Visible := chkColorBlend.checked;
end;

procedure TfrmDesktopSettings.UpdateFontAlphaControls;
begin

end;

procedure TfrmDesktopSettings.UpdateAlphaControls;
begin

end;

procedure TfrmDesktopSettings.UpdateBlendControls;
begin
  sceIconColor.Items.Item[0].Visible := chkColorBlend.checked;
end;

procedure TfrmDesktopSettings.UpdateTextShadowControls;
begin

end;

procedure TfrmDesktopSettings.UpdateIconShadowControls;
begin
  sceIconColor.Items.Item[1].Visible := chkIconShadow.Checked;
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

  UpdateIconControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.FormShow(Sender: TObject);
begin
  RefreshFontList;
  if cboFontName.Items.IndexOf(FFontName) <> 0 then
     cboFontName.ItemIndex := cboFontName.Items.IndexOf(FFontName);

  //Label1.Font.Color := clGray;
  //Label2.Font.Color := clGray;
  //Label3.Font.Color := clGray;
  //Label4.Font.Color := clGray;
  //Label5.Font.Color := clGray;
  //Label6.Font.Color := clGray;

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

procedure TfrmDesktopSettings.chkIconTransClick(Sender: TObject);
begin
  UpdateAlphaControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cbiconblendClick(Sender: TObject);
begin
  UpdateBlendControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.chkIconShadowClick(Sender: TObject);
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

  cboFontName.Items.Clear;
  try
    FFontList.RefreshFontInfo;
    for i := 0 To pred(FFontList.List.Count) do begin
      fi := TFontInfo(FFontList.List.Objects[i]);
      DuplicateCheck := cboFontName.Items.IndexOf(fi.FullName);

      if DuplicateCheck = -1 then
      cboFontName.Items.Add(FFontList.List.Strings[i]);
    end;
  finally
    cboFontName.ItemIndex := 0;
  end;
end;

procedure TfrmDesktopSettings.cboFontNameDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  fi:TFontInfo;
  imageindex : integer;
  itemindex  : integer;
  textheight : integer;
begin
  cboFontName.canvas.fillrect(rect);

  itemindex := FFontList.List.IndexOf(cboFontName.Items.Strings[index]);
  fi := TFontInfo(FFontList.List.Objects[itemindex]);

  imageindex := -1;
  case fi.FontType of
    ftTrueType : imageindex := 0;
    ftRaster   : imageindex := 1;
    ftDevice   : imageindex := 2;
  end;

  imlFontIcons.Draw(cboFontName.Canvas,rect.left,rect.top,imageindex);

  cboFontName.Canvas.Font.Name := fi.ShortName;
  textheight := cboFontName.Canvas.TextHeight(fi.FullName);

  if textheight > cboFontName.ItemHeight then
     cboFontName.Canvas.Font.Name := 'Arial';

  cboFontName.canvas.textout(rect.left+imlFontIcons.width+2,rect.top,fi.FullName);
end;

procedure TfrmDesktopSettings.cbfontalphablendClick(Sender: TObject);
begin
  UpdateFontAlphaControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cbtextshadowClick(Sender: TObject);
begin
  UpdateTextShadowControls;
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

procedure TfrmDesktopSettings.cbanimClick(Sender: TObject);
begin
  UpdateAnimationControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cbanimscaleClick(Sender: TObject);
begin
  UpdateAnimationControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.IconColorsUiChange(Sender: TObject);
begin
  SendUpdate;
end;

end.

