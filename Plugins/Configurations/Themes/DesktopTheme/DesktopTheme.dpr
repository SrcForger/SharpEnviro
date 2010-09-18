{
Source Name: Desktop Configs
Description: SharpE Desktop Global configs
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

library DesktopTheme;

{$R 'res\icons.res'}
{$R *.res}

uses
//  VCLFixPack,
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvPageList,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpApi,
  SharpThemeApiEx,
  uThemeConsts,
  uISharpETheme,
  uSharpETheme,
  SharpCenterApi,
  uSharpDeskTDeskSettings,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin,
      ISharpCenterPluginTabs)
  private
    FTheme : ISharpETheme;
    FXmlDeskSettings : TDeskSettings;
    procedure Load;
  public
    constructor Create(APluginHost: ISharpCenterHost);
    destructor Destroy; override;

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  if FXmlDeskSettings.UseExplorerDesk then
    exit;
    
  if frmSettingsWnd <> nil then
  begin
    ATabItems.AddObject('Icon', frmSettingsWnd.pagIcon);
    ATabItems.AddObject('Font', frmSettingsWnd.pagFont);
    ATabItems.AddObject('Font Shadow', frmSettingsWnd.pagFontShadow);
    ATabItems.AddObject('Animation', frmSettingsWnd.pagAnimation);
  end;
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
begin
  TJvStandardPage(ATab.FObject).Show;
  frmSettingsWnd.UpdatePageUi;
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettingsWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;

  FXmlDeskSettings := TDeskSettings.Create(nil);
  FTheme := TSharpETheme.Create(APluginHost.PluginID);
  FTheme.LoadTheme([tpDesktop,tpSkinScheme]);
end;

destructor TSharpCenterPlugin.Destroy;
begin
  FXmlDeskSettings.Free;
  FTheme := nil;

  inherited Destroy;
end;

procedure TSharpCenterPlugin.Load;
var
  iIconSize: Integer;
  i : integer;
begin
  FTheme.LoadTheme([tpDesktop,tpSkinScheme]);

  with frmSettingsWnd, FTheme.Desktop.Icon do
  begin
    frmSettingsWnd.FExplorerDesktop := FXmlDeskSettings.UseExplorerDesk;

    // Icon Tab
    rdoIcon32.Checked := false;
    rdoIcon48.Checked := false;
    rdoIcon64.Checked := false;
    rdoIconCustom.Checked := false;
    iIconSize := IconSize;
    case iIconSize of
      32: rdoIcon32.Checked := True;
      48: rdoIcon48.Checked := True;
      64: rdoIcon64.Checked := True;
    else
      rdoIconcustom.Checked := True;
    end;

    sgbiconsize.Value := iIconSize;
    chkIconTrans.Checked := IconAlphaBlend;
    sgbIconTrans.value := IconAlpha;
    chkColorBlend.Checked := IconBlending;
    sgbColorBlend.Value := IconBlendAlpha;
    chkIconShadow.Checked := IconShadow;
    sgbIconShadow.Value := IconShadowAlpha;
    if TryStrToInt(IconBlendColorStr,i) then
      sceIconColor.Items.Item[0].ColorCode := i
    else sceIconColor.Items.Item[0].ColorCode := FTheme.Scheme.ParseColor(IconBlendColorStr);
    if TryStrToInt(IconShadowColorStr,i) then
      sceIconColor.Items.Item[1].ColorCode := i
    else sceIconColor.Items.Item[1].ColorCode := FTheme.Scheme.ParseColor(IconShadowColorStr);

    // Font Tab
    FFontName := FontName;
    sgbFontSize.Value := TextSize;
    chkBold.Checked := TextBold;
    chkItalic.Checked := TextItalic;
    chkUnderline.Checked := TextUnderline;
    chkFontTrans.Checked := TextAlpha;
    sgbFontTrans.Value := TextAlphaValue;
    chkFontShadow.Checked := TextShadow;
    sgbFontShadowTrans.Value := TextShadowAlpha;
    if TryStrToInt(TextColorStr,i) then
      sceFontColor.Items.Item[0].ColorCode := i
    else sceFontColor.Items.Item[0].ColorCode := FTheme.Scheme.ParseColor(TextColorStr);
    if TryStrToInt(TextShadowColorStr,i) then
      sceShadowColor.Items.Item[0].ColorCode := i
    else sceShadowColor.Items.Item[0].ColorCode := FTheme.Scheme.ParseColor(TextShadowColorStr);
    cboFontShadowType.ItemIndex := Max(0, Min(3, TextShadowType));
    chkClearType.Checked := TextClearType;
  end;

  with frmSettingsWnd, FTheme.Desktop.Animation do
  begin
    // Animation Tab
    chkAnim.Checked := UseAnimations;
    chkAnimSize.Checked := Scale;
    sgbAnimSize.Value := ScaleValue;
    chkAnimTrans.Checked := Alpha;
    sgbAnimTrans.Value := AlphaValue;
    chkAnimColorBlend.Checked := Blend;
    sgbAnimColorBlend.Value := BlendValue;
    chkAnimBrightness.Checked := Brightness;
    sgbAnimBrightness.Value := BrightnessValue;
    if TryStrToInt(BlendColorStr,i) then
      sceAnimColor.Items.Item[0].ColorCode := i
    else sceAnimColor.Items.Item[0].ColorCode := FTheme.Scheme.ParseColor(BlendColorStr);
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettingsWnd = nil then frmSettingsWnd := TfrmSettingsWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmSettingsWnd);

  frmSettingsWnd.PluginHost := PluginHost;

  Load;
  result := PluginHost.Open(frmSettingsWnd);
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettingsWnd,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  iIconSize: integer;
  IconData : TThemeDesktopIcon;
  AnimData : TThemeDesktopAnim;
begin
  IconData := FTheme.Desktop.Icon;
  with frmSettingsWnd, IconData do
  begin
    if rdoIcon32.Checked then
      iIconSize := 32
    else if rdoIcon48.Checked then
      iIconSize := 48
    else if rdoIcon64.Checked then
      iIconSize := 64
    else
      iIconSize := sgbIconSize.Value;

    IconSize           := iIconSize;
    IconAlphaBlend     := chkIconTrans.Checked;
    IconAlpha          := sgbIconTrans.Value;
    IconBlending       := chkColorBlend.Checked;
    IconBlendAlpha     := sgbColorBlend.Value;
    IconShadow         := chkIconShadow.Checked;
    IconShadowAlpha    := sgbIconShadow.Value;
    IconBlendColorStr  := Inttostr(sceIconColor.Items.Item[0].ColorCode);
    IconShadowColorStr := Inttostr(sceIconColor.Items.Item[1].ColorCode);
    FontName           := cboFontName.Text;
    TextSize           := sgbFontSize.Value;
    TextBold           := chkBold.Checked;
    TextItalic         := chkItalic.Checked;
    TextUnderline      := chkUnderline.Checked;
    TextAlpha          := chkFontTrans.Checked;
    TextAlphaValue     := sgbFontTrans.Value;
    TextShadow         := chkFontShadow.Checked;
    TextShadowAlpha    := sgbFontShadowTrans.Value;
    TextShadowType     := cboFontShadowType.ItemIndex;
    TextColorStr       := Inttostr(sceFontColor.Items.Item[0].ColorCode);
    TextShadowColorStr := Inttostr(sceShadowColor.Items.Item[0].ColorCode);
    TextClearType := chkClearType.Checked;
  end;
  FTheme.Desktop.Icon := IconData;

  AnimData := FTheme.Desktop.Animation;
  with frmSettingsWnd,AnimData do
  begin
    UseAnimations   := chkAnim.Checked;
    Scale           := chkAnimSize.Checked;
    ScaleValue      := sgbAnimSize.Value;
    Alpha           := chkAnimTrans.Checked;
    AlphaValue      := sgbAnimTrans.Value;
    Blend           := chkAnimColorBlend.Checked;
    BlendValue      := sgbAnimColorBlend.Value;
    Brightness      := chkAnimBrightness.Checked;
    BrightnessValue := sgbAnimBrightness.Value;
    BlendColorStr   := Inttostr(sceAnimColor.Items.Item[0].ColorCode);
  end;
  FTheme.Desktop.Animation := AnimData;

  FTheme.Desktop.SaveToFile;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Desktop';
    Description := 'Desktop Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suDesktopIcon)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
	Name := 'Desktop';
    Description := Format('Desktop Configuration for "%s"', [pluginID]);
	Status := '';
  end;
end;

function InitPluginInterface(APluginHost: ISharpCenterHost): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.
