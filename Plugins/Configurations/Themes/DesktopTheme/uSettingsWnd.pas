{
Source Name: uSharpDeskSettingsWnd.pas
Description: SharpDesk Settings Window
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
  Menus,
  ComCtrls,
  SharpApi,
  JvExComCtrls,
  JvComCtrls,
  ExtCtrls,
  JvPageList,
  JvExControls,
  JvComponent,
  GR32_Image,
  GR32,
  GR32_PNG,
  SharpEColorEditor,
  SharpESwatchManager,
  SharpEColorEditorEx,
  SharpEFontSelectorFontList,
  ImgList,
  SharpEGaugeBoxEdit,
  SharpERoundPanel,
  JvExStdCtrls,
  JvCheckBox, SharpECenterHeader, JvXPCore, JvXPCheckCtrls,ISharpCenterHostUnit,
  ISharpCenterPluginUnit;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmSettingsWnd = class(TForm)
    plMain: TJvPageList;
    pagExplorerDesktop: TJvStandardPage;
    pagIcon: TJvStandardPage;
    pagFont: TJvStandardPage;
    pagAnimation: TJvStandardPage;
    SharpESwatchManager1: TSharpESwatchManager;
    imlFontIcons: TImageList;
    sceFontColor: TSharpEColorEditorEx;
    pnlAnim: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    SharpERoundPanel1: TSharpERoundPanel;
    icon32: TImage32;
    SharpERoundPanel2: TSharpERoundPanel;
    icon48: TImage32;
    SharpERoundPanel3: TSharpERoundPanel;
    Icon64: TImage32;
    SharpERoundPanel4: TSharpERoundPanel;
    sgbIconSize: TSharpeGaugeBox;
    sgbIconTrans: TSharpeGaugeBox;
    Panel1: TPanel;
    sgbColorBlend: TSharpeGaugeBox;
    Panel2: TPanel;
    sgbIconShadow: TSharpeGaugeBox;
    Panel10: TPanel;
    sceIconColor: TSharpEColorEditorEx;
    pagFontShadow: TJvStandardPage;
    cboFontName: TComboBox;
    Panel5: TPanel;
    sgbFontSize: TSharpeGaugeBox;
    Panel7: TPanel;
    sgbFontTrans: TSharpeGaugeBox;
    Panel9: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    sgbAnimTrans: TSharpeGaugeBox;
    sgbAnimBrightness: TSharpeGaugeBox;
    sgbAnimColorBlend: TSharpeGaugeBox;
    sgbAnimSize: TSharpeGaugeBox;
    sceAnimColor: TSharpEColorEditorEx;
    SharpECenterHeader1: TSharpECenterHeader;
    pnlTextShadow: TPanel;
    SharpECenterHeader2: TSharpECenterHeader;
    SharpECenterHeader3: TSharpECenterHeader;
    Panel11: TPanel;
    sgbFontShadowTrans: TSharpeGaugeBox;
    SharpECenterHeader4: TSharpECenterHeader;
    sceShadowColor: TSharpEColorEditorEx;
    Panel6: TPanel;
    cboFontShadowType: TComboBox;
    SharpECenterHeader5: TSharpECenterHeader;
    SharpECenterHeader6: TSharpECenterHeader;
    SharpECenterHeader7: TSharpECenterHeader;
    SharpECenterHeader8: TSharpECenterHeader;
    SharpECenterHeader9: TSharpECenterHeader;
    SharpECenterHeader10: TSharpECenterHeader;
    SharpECenterHeader11: TSharpECenterHeader;
    SharpECenterHeader12: TSharpECenterHeader;
    SharpECenterHeader13: TSharpECenterHeader;
    Panel8: TPanel;
    SharpECenterHeader14: TSharpECenterHeader;
    SharpECenterHeader15: TSharpECenterHeader;
    SharpECenterHeader16: TSharpECenterHeader;
    SharpECenterHeader17: TSharpECenterHeader;
    SharpECenterHeader18: TSharpECenterHeader;
    SharpECenterHeader19: TSharpECenterHeader;
    chkColorBlend: TJvXPCheckbox;
    chkIconShadow: TJvXPCheckbox;
    chkIconTrans: TJvXPCheckbox;
    chkFontShadow: TJvXPCheckbox;
    chkBold: TJvXPCheckbox;
    chkItalic: TJvXPCheckbox;
    chkUnderline: TJvXPCheckbox;
    chkAnimTrans: TJvXPCheckbox;
    chkAnimSize: TJvXPCheckbox;
    chkAnimBrightness: TJvXPCheckbox;
    chkAnimColorBlend: TJvXPCheckbox;
    chkFontTrans: TJvXPCheckbox;
    rdoIcon32: TJvXPCheckbox;
    rdoIcon48: TJvXPCheckbox;
    rdoIcon64: TJvXPCheckbox;
    rdoIconCustom: TJvXPCheckbox;
    chkAnim: TJvXPCheckbox;
    SharpECenterHeader20: TSharpECenterHeader;
    chkClearType: TJvXPCheckbox;
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
    procedure chkClearTypeClick(Sender: TObject);
  private
    FBlue32, FBlue48, FBlue64: TBitmap32;
    FWhite32, FWhite48, FWhite64: TBitmap32;
    FFontList: TFontList;
    FPluginHost: ISharpCenterHost;
    procedure SendUpdate;
    procedure RefreshFontList;

    procedure UpdateIconPage;
    procedure UpdateFontPage;
    procedure UpdateFontShadowPage;
    procedure UpdateAnimationPage;
    procedure LoadResources;
  public
    FFontName: string;
    FExplorerDesktop: boolean;
    procedure UpdatePageUi;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;

implementation

uses
  SharpCenterApi;

{$R *.dfm}

{ TfrmConfigListWnd }

procedure LoadBmpFromRessource(Bmp: TBitmap32; ResName: string);
var
  ResStream: TResourceStream;
  TempBmp: TBitmap32;
  b: boolean;
begin
  if Bmp = nil then
    exit;

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

procedure TfrmSettingsWnd.FormCreate(Sender: TObject);
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

procedure TfrmSettingsWnd.UpdateIconPage;
begin
  LockWindowUpdate(Self.Handle);
  try

    // Icon Size
    sgbiconsize.Enabled := rdoIconCustom.checked;
    if rdoIcon32.Checked then
      icon32.Bitmap.Assign(FBlue32)
    else
      icon32.Bitmap.Assign(FWhite32);
    if rdoIcon48.Checked then
      icon48.Bitmap.Assign(FBlue48)
    else
      icon48.Bitmap.Assign(FWhite48);
    if rdoIcon64.Checked then
      icon64.Bitmap.Assign(FBlue64)
    else
      icon64.Bitmap.Assign(FWhite64);

    // Icon Color Blend
    sgbColorBlend.Enabled := chkColorBlend.Checked;
    sceIconColor.Items.Item[0].Visible := chkColorBlend.checked;

    // Icon Shadow Transparency
    sgbIconShadow.Enabled := chkIconShadow.Checked;
    sceIconColor.Items.Item[1].Visible := chkIconShadow.checked;

    // Refresh ColorEditorEx
    sceIconColor.Invalidate;

    // Icon Transparency
    sgbIconTrans.Enabled := chkIconTrans.Checked;

    // Update Page Height
    if (chkIconShadow.Checked or chkColorBlend.Checked) then
      Self.Height := 680
    else
      Self.Height := 440;

    // Refresh size
    FPluginHost.Refresh;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmSettingsWnd.UpdateAnimationPage;
begin
  LockWindowUpdate(Self.Handle);
  try
    // Hide/Show Animation Options
    pnlAnim.Visible := chkAnim.checked;

    // Animation Transparency
    sgbAnimTrans.Enabled := chkAnimTrans.Checked;

    // Animation Brightness
    sgbAnimBrightness.Enabled := chkAnimBrightness.Checked;

    // Animation Size
    sgbAnimSize.Enabled := chkAnimSize.Checked;

    // Animation Color Blend
    sgbAnimColorBlend.Enabled := chkAnimColorBlend.Checked;
    sceAnimColor.Visible := chkAnimColorBlend.Checked;
    sceAnimColor.Items.Item[0].Visible := chkAnimColorBlend.checked;

    // Update Page Height
    if chkAnim.Checked then begin

      if sceAnimColor.Visible then
        Self.Height := 520
      else
        Self.Height := 380;

    end
    else
      Self.Height := 70;

    // Refresh size
    PluginHost.Refresh;
  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmSettingsWnd.LoadResources;
begin
  LoadBmpFromRessource(FBlue32, 'Blue32');
  LoadBmpFromRessource(FBlue48, 'Blue48');
  LoadBmpFromRessource(FBlue64, 'Blue64');
  LoadBmpFromRessource(FWhite32, 'White32');
  LoadBmpFromRessource(FWhite48, 'White48');
  LoadBmpFromRessource(FWhite64, 'White64');
end;

procedure TfrmSettingsWnd.UpdateFontPage;
begin
  LockWindowUpdate(Self.Handle);
  try

    // Font Transparency
    sgbFontTrans.Enabled := chkFontTrans.Checked;

    // Update Page Height
    Self.Height := 580;
    PluginHost.Refresh;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmSettingsWnd.UpdateFontShadowPage;
begin
  LockWindowUpdate(Self.Handle);
  try

    // Font Shadow
    pnlTextShadow.Visible := chkFontShadow.Checked;

    // Update Page Height
    if chkFontShadow.Checked then
      Self.Height := 440
    else
      Self.Height := 85;

    PluginHost.Refresh;

  finally
    LockWindowUpdate(0);
  end;
end;

procedure TfrmSettingsWnd.SendUpdate;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

procedure TfrmSettingsWnd.rdoIconCustomClick(Sender: TObject);
begin
  rdoIcon32.Checked := False;
  rdoIcon48.Checked := False;
  rdoIcon64.Checked := False;
  rdoIconCustom.Checked := False;

  TJvXPCheckbox(Sender).OnClick := nil;
  TJvXPCheckbox(Sender).Checked := True;
  TJvXPCheckbox(Sender).OnClick := rdoIconCustomClick;

  UpdateIconPage;
  SendUpdate;
end;

procedure TfrmSettingsWnd.ShadowTypeCheckEvent(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.FormShow(Sender: TObject);
begin
  RefreshFontList;
  if cboFontName.Items.IndexOf(FFontName) <> 0 then
    cboFontName.ItemIndex := cboFontName.Items.IndexOf(FFontName);

  UpdatePageUi;
end;

procedure TfrmSettingsWnd.FormDestroy(Sender: TObject);
begin
  FBlue32.Free;
  FBlue48.Free;
  FBlue64.Free;
  FWhite32.Free;
  FWhite48.Free;
  FWhite64.Free;

  FFontList.Free;
end;

procedure TfrmSettingsWnd.UpdateIcontPageEvent(Sender: TObject);
begin
  UpdateIconPage;
  SendUpdate;
end;

procedure TfrmSettingsWnd.UpdatePageUi;
begin
  if FExplorerDesktop then
  begin
    pagExplorerDesktop.Show;
    Self.Height := 300;
    exit;
  end;

  if pagIcon.Visible then
    UpdateIconPage
  else if pagFont.Visible then
    UpdateFontPage
  else if pagFontShadow.Visible then
    UpdateFontShadowPage
  else if pagAnimation.Visible then
    UpdateAnimationPage;
end;

procedure TfrmSettingsWnd.RefreshFontList;
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

procedure TfrmSettingsWnd.UpdateColorChangeEvent(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.sceIconColorUiChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.cboFontNameChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.cboFontNameDrawItem(Control: TWinControl;
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

procedure TfrmSettingsWnd.cboFontShadowTypeChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.chkClearTypeClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.UpdateAnimationPageEvent(Sender: TObject);
begin
  UpdateAnimationPage;
  SendUpdate;
end;

procedure TfrmSettingsWnd.UpdateFontShadowPageEvent(Sender: TObject);
begin
  UpdateFontShadowPage;
  SendUpdate;
end;

procedure TfrmSettingsWnd.UpdateFontPageEvent(Sender: TObject);
begin
  UpdateFontPage;
  SendUpdate;
end;

procedure TfrmSettingsWnd.FontStyleCheckEvent(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.SendUpdateEvent(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.cbboldClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettingsWnd.IconColorsUiChange(Sender: TObject);
begin
  SendUpdate;
end;

end.

