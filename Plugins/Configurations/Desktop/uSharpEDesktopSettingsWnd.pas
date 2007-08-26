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
  JvSpin, SharpEGaugeBoxEdit, SharpERoundPanel;

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
    SharpESwatchManager1: TSharpESwatchManager;
    imlFontIcons: TImageList;
    Panel5: TPanel;
    cbxFontName: TComboBox;
    Label5: TLabel;
    Panel7: TPanel;
    sefontsize: TJvSpinEdit;
    Label9: TLabel;
    cbbold: TCheckBox;
    cbitalic: TCheckBox;
    cbunderline: TCheckBox;
    textcolors: TSharpEColorEditorEx;
    Panel6: TPanel;
    pnanim: TPanel;
    Panel9: TPanel;
    cbanim: TCheckBox;
    pntextshadowbg: TPanel;
    pntextshadow: TPanel;
    sgbtextshadow: TSharpeGaugeBox;
    Panel20: TPanel;
    Panel21: TPanel;
    cbtextshadow: TCheckBox;
    pnfontalphablendbg: TPanel;
    pnfontalphablend: TPanel;
    sgbfontalphablend: TSharpeGaugeBox;
    Panel24: TPanel;
    Panel25: TPanel;
    cbfontalphablend: TCheckBox;
    Panel18: TPanel;
    pnanimscalebg: TPanel;
    pnanimscale: TPanel;
    sgbanimscale: TSharpeGaugeBox;
    Panel22: TPanel;
    Panel23: TPanel;
    cbanimscale: TCheckBox;
    pnanimalphabg: TPanel;
    pnanimalpha: TPanel;
    sgbanimalpha: TSharpeGaugeBox;
    Panel26: TPanel;
    Panel27: TPanel;
    cbanimalpha: TCheckBox;
    pnanimbrightnessbg: TPanel;
    pnanimbrightness: TPanel;
    sgbanimbrightness: TSharpeGaugeBox;
    Panel28: TPanel;
    Panel29: TPanel;
    cbanimbrightness: TCheckBox;
    pnanimcolorblendbg: TPanel;
    pnanimcolorblend: TPanel;
    sgbanimcolorblend: TSharpeGaugeBox;
    Panel30: TPanel;
    Panel31: TPanel;
    cbanimcolorblend: TCheckBox;
    Panel19: TPanel;
    animcolors: TSharpEColorEditorEx;
    Panel8: TPanel;
    Panel3: TPanel;
    Label2: TLabel;
    cbalphablend: TCheckBox;
    Panel4: TPanel;
    Label3: TLabel;
    CheckBox1: TLabel;
    SharpERoundPanel1: TSharpERoundPanel;
    icon32: TImage32;
    rbicon32: TRadioButton;
    SharpERoundPanel2: TSharpERoundPanel;
    icon48: TImage32;
    rbicon48: TRadioButton;
    SharpERoundPanel3: TSharpERoundPanel;
    Icon64: TImage32;
    rbicon64: TRadioButton;
    SharpERoundPanel4: TSharpERoundPanel;
    rbiconcustom: TRadioButton;
    sgbiconsize: TSharpeGaugeBox;
    sgbiconalpha: TSharpeGaugeBox;
    Panel1: TPanel;
    Label1: TLabel;
    cbcolorblend: TCheckBox;
    sbgiconcblendalpha: TSharpeGaugeBox;
    Panel2: TPanel;
    Label4: TLabel;
    cbiconshadow: TCheckBox;
    sgbiconshadow: TSharpeGaugeBox;
    Panel10: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    IconColors: TSharpEColorEditorEx;
    procedure IconColorsUiChange(Sender: TObject);
    procedure cbanimscaleClick(Sender: TObject);
    procedure cbanimClick(Sender: TObject);
    procedure cbboldClick(Sender: TObject);
    procedure SendUpdateEvent(Sender: TObject; Value: Integer);
    procedure cbtextshadowClick(Sender: TObject);
    procedure cbfontalphablendClick(Sender: TObject);
    procedure cbxFontNameDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure cbiconshadowClick(Sender: TObject);
    procedure cbiconblendClick(Sender: TObject);
    procedure cbalphablendClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbiconcustomClick(Sender: TObject);
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
    sTheme : String;
    sFontName : String;
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
  sgbiconsize.Enabled := rbiconcustom.checked;

  if rbicon32.Checked then
     icon32.Bitmap.Assign(FBlue32)
     else icon32.Bitmap.Assign(FWhite32);

  if rbicon48.Checked then
     icon48.Bitmap.Assign(FBlue32)
     else icon48.Bitmap.Assign(FWhite32);

  if rbicon64.Checked then
     icon64.Bitmap.Assign(FBlue32)
     else icon64.Bitmap.Assign(FWhite32);
end;

procedure TfrmDesktopSettings.UpdateAnimationControls;
begin
  pnanim.Visible := cbanim.checked;
  pnanimscale.Visible := cbanimscale.Checked;
  pnanimalpha.Visible := cbanimalpha.Checked;
  pnanimbrightness.Visible := cbanimbrightness.Checked;
  pnanimcolorblend.Visible := cbanimcolorblend.Checked;
  AnimColors.Items.Item[0].Visible := cbanimcolorblend.checked;
end;

procedure TfrmDesktopSettings.UpdateFontAlphaControls;
begin
  pnfontalphablend.visible := cbfontalphablend.checked;
end;

procedure TfrmDesktopSettings.UpdateAlphaControls;
begin

end;

procedure TfrmDesktopSettings.UpdateBlendControls;
begin
  IconColors.Items.Item[0].Visible := cbcolorblend.checked;
end;

procedure TfrmDesktopSettings.UpdateTextShadowControls;
begin
  pntextshadow.visible := cbtextshadow.checked;
  TextColors.Items.Item[1].Visible := cbtextshadow.checked;
end;

procedure TfrmDesktopSettings.UpdateIconShadowControls;
begin
  IconColors.Items.Item[1].Visible := cbiconshadow.Checked;
end;

procedure TfrmDesktopSettings.SendUpdate;
begin
  if Visible then
     CenterDefineSettingsChanged;
end;

procedure TfrmDesktopSettings.rbiconcustomClick(Sender: TObject);
begin
  rbicon32.Checked := False;
  rbicon48.Checked := False;
  rbicon64.Checked := False;
  rbiconcustom.Checked := False;

  TRadioButton(Sender).OnClick := nil;
  TRadioButton(Sender).Checked := True;
  TRadioButton(Sender).OnClick := rbiconcustomClick;

  UpdateIconControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.FormShow(Sender: TObject);
begin
  RefreshFontList;
  if cbxFontName.Items.IndexOf(sFontName) <> 0 then
     cbxFontName.ItemIndex := cbxFontName.Items.IndexOf(sFontName);

  Label1.Font.Color := clGray;
  Label2.Font.Color := clGray;
  Label3.Font.Color := clGray;
  Label4.Font.Color := clGray;
  Label5.Font.Color := clGray;
  Label6.Font.Color := clGray;

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

procedure TfrmDesktopSettings.cbalphablendClick(Sender: TObject);
begin
  UpdateAlphaControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cbiconblendClick(Sender: TObject);
begin
  UpdateBlendControls;
  SendUpdate;
end;

procedure TfrmDesktopSettings.cbiconshadowClick(Sender: TObject);
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

