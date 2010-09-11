{
Source Name: Weather
Description: Weather Object Config Dll
Copyright (C) Mathias Tillman <mathias@sharpenviro.com>

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

library Weather;

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
  JvSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  SharpEUIC,
  uVistaFuncs,
  SysUtils,
  Graphics,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings},
  SharpCenterApi,
  SharpApi,
  SharpThemeApiEx,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uISharpETheme,
  WeatherObjectXMLSettings in '..\..\..\Objects\Weather\WeatherObjectXMLSettings.pas',
  uSharpDeskObjectSettings in '..\..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas';

{$E .dll}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs)
  private
    procedure Load;
    procedure SetDefaults(xmlSettings: TXMLSettings; ITheme: ISharpETheme);
    procedure SetHasChanged(xmlSettings: TXMLSettings; ITheme: ISharpETheme);
  public
    constructor Create(APluginHost: ISharpCenterHost);

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
  ATabItems.AddObject('Weather', frmSettings.pagWeather);
  ATabItems.AddObject('Icon', frmSettings.pagIcon);
  ATabItems.AddObject('Font', frmSettings.pagFont);
  ATabItems.AddObject('Font Shadow', frmSettings.pagFontShadow);
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.FObject <> nil then begin
    tmpPag := TJvStandardPage(ATab.FObject);
    tmpPag.Show;
  end;

  frmSettings.UpdatePageUI;
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

procedure TSharpCenterPlugin.Load;
var
  xmlSettings: TXMLSettings;
  ITheme: ISharpETheme;
  s: string;
  n: integer;
begin
  xmlSettings := TXMLSettings.Create(strtoint(PluginHost.PluginId), nil, 'Weather');
  try

    xmlSettings.LoadSettings;

    ITheme := GetCurrentTheme;

    with frmSettings, xmlSettings do
    begin
     {$REGION 'Load custom options'}
      // Show caption?
      chkCaption.Checked := ShowCaption;
      {$ENDREGION}

      // Load uic defaults
      SetDefaults(xmlSettings, ITheme);

      {$REGION 'Get default theme options'}

      {$REGION 'Get theme icon options'}
      // Icon Blend
      chkIconBlendAlpha.Checked := Theme[DS_ICONBLENDING].BoolValue;
      sgbIconBlendAlpha.Value := Theme[DS_ICONBLENDALPHA].IntValue;
      sceIconBlendColor.Items.Item[0].ColorCode := Theme[DS_ICONBLENDCOLOR].IntValue;

      // Icon Alpha
      chkIconAlpha.Checked := Theme[DS_ICONALPHABLEND].BoolValue;
      sgbIconAlpha.Value := Theme[DS_ICONALPHA].IntValue;

      // Icon Shadow
      chkIconShadowAlpha.Checked := Theme[DS_ICONSHADOW].BoolValue;
      sgbIconShadowAlpha.Value := Theme[DS_ICONSHADOWALPHA].IntValue;
      sceIconShadowColor.Items.Item[0].ColorCode := Theme[DS_ICONSHADOWCOLOR].IntValue;

      // Icon Size
      rdoIcon32.Checked := false;
      rdoIcon48.Checked := false;
      rdoIcon64.Checked := false;
      case Theme[DS_ICONSIZE].IntValue of
        32: rdoIcon32.Checked := True;
        48: rdoIcon48.Checked := True;
        64: rdoIcon64.Checked := True;
      else
        begin
          rdoIconCustom.Checked := True;
          sgbIconSize.Value := Theme[DS_ICONSIZE].IntValue;
        end;
      end;
      {$ENDREGION}

      {$REGION 'Get the font options'}
      // Font name
      s := Theme[DS_FONTNAME].Value;
      for n := 0 to Pred(cboFontName.Items.Count) do
        if CompareText(cboFontName.Items[n], s) = 0 then
        begin
          cboFontName.ItemIndex := n;
          break;
        end;
      if cboFontName.ItemIndex = -1 then
        cboFontName.ItemIndex := cboFontName.Items.IndexOf('arial');

      // Font size
      sgbTextSize.Value := Theme[DS_TEXTSIZE].IntValue;

      // font alpha
      sgbTextAlphaValue.Value := Theme[DS_TEXTALPHAVALUE].IntValue;
      chkTextAlpha.Checked := Theme[DS_TEXTALPHA].BoolValue;

      // Font styles
      chkTextBold.Checked := Theme[DS_TEXTBOLD].BoolValue;
      chkTextItalic.Checked := Theme[DS_TEXTITALIC].BoolValue;
      chkTextUnderline.Checked := Theme[DS_TEXTUNDERLINE].BoolValue;

      // Font colour
      sceTextColor.Items.Item[0].ColorCode := Theme[DS_TEXTCOLOR].IntValue;

      // Font shadow
      chkTextShadow.Checked := Theme[DS_TEXTSHADOW].BoolValue;
      sgbTextShadowAlpha.Value := Theme[DS_TEXTSHADOWALPHA].IntValue;
      cboTextShadowType.ItemIndex := Theme[DS_TEXTSHADOWTYPE].IntValue;
      sceTextShadowColor.Items.Item[0].ColorCode := Theme[DS_TEXTSHADOWCOLOR].IntValue;
      {$ENDREGION}

      {$ENDREGION}

      // load if xmlSettings are changed
      SetHasChanged(xmlSettings, ITheme);
    end;

  finally
    xmlSettings.Free;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettings = nil then frmSettings := TfrmSettings.Create(nil);
  frmSettings.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmSettings);

  Load;
  result := PluginHost.Open(frmSettings);
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettings,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  xmlSettings: TXMLSettings;
begin
  xmlSettings := TXMLSettings.Create(strtoint(PluginHost.PluginId), nil, 'Weather');
  try

    xmlSettings.LoadSettings;
    with frmSettings, xmlSettings do
    begin

      {$REGION 'Save custom options'}
      ShowCaption := chkCaption.Checked;
      {$ENDREGION}

      {$REGION 'Set IsCustom'}
      Theme[DS_ICONBLENDING].isCustom := uicIconBlend.HasChanged;
      Theme[DS_ICONALPHABLEND].isCustom := uicIconAlpha.HasChanged;
      Theme[DS_ICONSHADOW].isCustom := uicIconShadow.HasChanged;

      Theme[DS_ICONSIZE].isCustom := uicIconSize.HasChanged;
      Theme[DS_ICONBLENDALPHA].isCustom := uicIconBlendAlpha.HasChanged;
      Theme[DS_ICONALPHA].isCustom := uicIconAlphaValue.HasChanged;
      Theme[DS_ICONSHADOWALPHA].isCustom := uicIconShadowAlpha.HasChanged;
      Theme[DS_ICONBLENDCOLOR].isCustom := uicIconBlendColor.HasChanged;
      Theme[DS_ICONSHADOWCOLOR].isCustom := uicIconShadowColor.HasChanged;

      Theme[DS_FONTNAME].isCustom := uicFontName.HasChanged;
      Theme[DS_TEXTSIZE].isCustom := uicTextSize.HasChanged;
      Theme[DS_TEXTALPHA].isCustom := uicTextAlpha.HasChanged;
      Theme[DS_TEXTALPHAVALUE].isCustom := uicTextAlphaValue.HasChanged;
      Theme[DS_TEXTBOLD].isCustom := uicTextBold.HasChanged;
      Theme[DS_TEXTITALIC].isCustom := uicTextItalic.HasChanged;
      Theme[DS_TEXTUNDERLINE].isCustom := uicTextUnderline.HasChanged;
      Theme[DS_TEXTCOLOR].isCustom := uicTextColor.HasChanged;

      Theme[DS_TEXTSHADOW].isCustom := uicTextShadow.HasChanged;
      Theme[DS_TEXTSHADOWALPHA].isCustom := uicTextShadowAlpha.HasChanged;
      Theme[DS_TEXTSHADOWTYPE].isCustom := uicTextShadowType.HasChanged;
      Theme[DS_TEXTSHADOWCOLOR].isCustom := uicTextShadowColor.HasChanged;
      {$ENDREGION}

      {$REGION 'Save values if custom'}
      Theme[DS_ICONBLENDING].BoolValue := chkIconBlendAlpha.Checked;
      Theme[DS_ICONALPHABLEND].BoolValue := chkIconAlpha.Checked;
      Theme[DS_ICONSHADOW].BoolValue := chkIconShadowAlpha.Checked;

      if rdoIcon32.Checked then
        Theme[DS_ICONSIZE].IntValue := 32
      else if rdoIcon48.Checked then
        Theme[DS_ICONSIZE].IntValue := 48
      else if rdoIcon64.Checked then
        Theme[DS_ICONSIZE].IntValue := 64
      else Theme[DS_ICONSIZE].IntValue := sgbIconSize.Value;

      Theme[DS_ICONBLENDALPHA].IntValue := sgbIconBlendAlpha.Value;
      Theme[DS_ICONALPHA].IntValue := sgbIconAlpha.Value;
      Theme[DS_ICONSHADOWALPHA].IntValue := sgbIconShadowAlpha.Value;
      Theme[DS_ICONBLENDCOLOR].IntValue := sceIconBlendColor.Items.Item[0].ColorCode;
      Theme[DS_ICONSHADOWCOLOR].IntValue := sceIconShadowColor.Items.Item[0].ColorCode;

      Theme[DS_FONTNAME].Value := cboFontName.Text;
      Theme[DS_TEXTSIZE].IntValue := sgbTextSize.Value;
      Theme[DS_TEXTALPHAVALUE].IntValue := sgbTextAlphaValue.Value;
      Theme[DS_TEXTALPHA].BoolValue := chkTextAlpha.Checked;
      Theme[DS_TEXTBOLD].BoolValue := chkTextBold.Checked;
      Theme[DS_TEXTITALIC].BoolValue := chkTextItalic.Checked;
      Theme[DS_TEXTUNDERLINE].BoolValue := chkTextUnderline.Checked;
      Theme[DS_TEXTCOLOR].IntValue := sceTextColor.Items.Item[0].ColorCode;

      Theme[DS_TEXTSHADOW].BoolValue := chkTextShadow.Checked;
      Theme[DS_TEXTSHADOWALPHA].IntValue := sgbTextShadowAlpha.Value;
      Theme[DS_TEXTSHADOWTYPE].IntValue := cboTextShadowType.ItemIndex;
      Theme[DS_TEXTSHADOWCOLOR].IntValue := sceTextShadowColor.Items.Item[0].ColorCode;
      {$ENDREGION}
    end;
    xmlSettings.SaveSettings(True);

  finally
    xmlSettings.Free;
  end;
end;

procedure TSharpCenterPlugin.SetDefaults(xmlSettings: TXMLSettings;
  ITheme: ISharpETheme);
begin
  with frmSettings, ITheme do begin
    {$REGION 'Icon Options'}
    uicIconBlend.SetDefaultValue(ITheme.Desktop.Icon.IconBlending);
    uicIconAlpha.SetDefaultValue(ITheme.Desktop.Icon.IconAlphaBlend);
    uicIconShadow.SetDefaultValue(ITheme.Desktop.Icon.IconShadow);

    uicIconSize.SetDefaultValue(ITheme.Desktop.Icon.IconSize);
    uicIconBlendColor.SetDefaultValue(ITheme.Desktop.Icon.IconBlendColor);
    uicIconBlendAlpha.SetDefaultValue(ITheme.Desktop.Icon.IconBlendAlpha);
    uicIconAlphaValue.SetDefaultValue(ITheme.Desktop.Icon.IconAlpha);
    uicIconShadowColor.SetDefaultValue(ITheme.Desktop.Icon.IconShadowColor);
    uicIconShadowAlpha.SetDefaultValue(ITheme.Desktop.Icon.IconShadowAlpha);
    {$ENDREGION}

    {$REGION 'Font Options'}
    uicFontName.SetDefaultValue(cboFontName.Items.IndexOf(ITheme.Desktop.Icon.FontName));
    uicTextSize.SetDefaultValue(ITheme.Desktop.Icon.TextSize);
    uicTextColor.SetDefaultValue(ITheme.Desktop.Icon.TextColor);
    uicTextAlpha.SetDefaultValue(ITheme.Desktop.Icon.TextAlpha);
    uicTextAlphaValue.SetDefaultValue(ITheme.Desktop.Icon.TextAlphaValue);

    uicTextBold.SetDefaultValue(ITheme.Desktop.Icon.TextBold);
    uicTextItalic.SetDefaultValue(ITheme.Desktop.Icon.TextItalic);
    uicTextUnderline.SetDefaultValue(ITheme.Desktop.Icon.TextUnderline);

    uicTextShadow.SetDefaultValue(ITheme.Desktop.Icon.TextShadow);
    uicTextShadowAlpha.SetDefaultValue(ITheme.Desktop.Icon.TextShadowAlpha);
    uicTextShadowColor.SetDefaultValue(ITheme.Desktop.Icon.TextShadowColor);
    uicTextShadowType.SetDefaultValue(ITheme.Desktop.Icon.TextShadowType);
    {$ENDREGION}
  end;
end;

procedure TSharpCenterPlugin.SetHasChanged(xmlSettings: TXMLSettings;
  ITheme: ISharpETheme);
begin
  with frmSettings, xmlSettings, ITheme do begin
    uicIconBlend.HasChanged := Theme[DS_ICONBLENDING].isCustom;
    uicIconAlpha.HasChanged := Theme[DS_ICONALPHABLEND].isCustom;
    uicIconShadow.HasChanged := Theme[DS_ICONSHADOW].isCustom;

    uicIconSize.HasChanged := Theme[DS_ICONSIZE].isCustom;
    uicIconBlendAlpha.HasChanged := Theme[DS_ICONBLENDALPHA].isCustom;
    uicIconAlphaValue.HasChanged := Theme[DS_ICONALPHA].isCustom;
    uicIconShadowAlpha.HasChanged := Theme[DS_ICONSHADOWALPHA].isCustom;
    uicIconBlendColor.HasChanged := Theme[DS_ICONBLENDCOLOR].isCustom;
    uicIconShadowColor.HasChanged := Theme[DS_ICONSHADOWCOLOR].isCustom;

    uicFontName.HasChanged := Theme[DS_FONTNAME].isCustom;
    uicTextSize.HasChanged := Theme[DS_TEXTSIZE].isCustom;
    uicTextAlpha.HasChanged := Theme[DS_TEXTALPHA].isCustom;
    uicTextAlphaValue.HasChanged := Theme[DS_TEXTALPHAVALUE].isCustom;
    uicTextBold.HasChanged := Theme[DS_TEXTBOLD].isCustom;
    uicTextItalic.HasChanged := Theme[DS_TEXTITALIC].isCustom;
    uicTextUnderline.HasChanged := Theme[DS_TEXTUNDERLINE].isCustom;
    uicTextColor.HasChanged := Theme[DS_TEXTCOLOR].isCustom;

    uicTextShadow.HasChanged := Theme[DS_TEXTSHADOW].isCustom;
    uicTextShadowAlpha.HasChanged := Theme[DS_TEXTSHADOWALPHA].isCustom;
    uicTextShadowType.HasChanged := Theme[DS_TEXTSHADOWTYPE].isCustom;
    uicTextShadowColor.HasChanged := Theme[DS_TEXTSHADOWCOLOR].isCustom;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Weather';
    Description := 'Weather Object Configuration';
    Author := 'Mathias Tillman <mathias@sharpenviro.com>';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suDesktopObject)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Weather';
    Description := 'The weather object shows the current weather on your desktop';
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

begin;

end.

