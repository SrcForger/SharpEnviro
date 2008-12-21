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
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvSimpleXml,
  JvPageList,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,

  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin,
      ISharpCenterPluginTabs)
  private
    procedure Load;
  public
    constructor Create(APluginHost: TInterfacedSharpCenterHostBase);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;

    function GetPluginDescriptionText: string; override; stdcall;
    procedure Refresh; override; stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;

  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
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

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: string;
begin
  result := Format('Desktop Configuration for "%s"', [PluginHost.PluginId]);
end;

procedure TSharpCenterPlugin.Load;
var
  fileName: string;
  iIconSize: Integer;
begin

  with PluginHost, PluginHost.Xml, frmSettingsWnd do begin

    // Icon + font settings
    fileName := GetSharpeUserSettingsPath + '\Themes\' + PluginId + '\DesktopIcon.xml';
    PluginHost.Xml.XmlFilename := fileName;
    if PluginHost.Xml.Load then begin

      with XmlRoot.Items do begin

{$REGION 'IconTab'}
        rdoIcon32.Checked := false;
        rdoIcon48.Checked := false;
        rdoIcon64.Checked := false;
        rdoIconCustom.Checked := false;
        iIconSize := IntValue('IconSize', 32);
        case iIconSize of
          32: rdoIcon32.Checked := True;
          48: rdoIcon48.Checked := True;
          64: rdoIcon64.Checked := True;
        else
          rdoIconcustom.Checked := True;
        end;

        sgbiconsize.Value := iIconSize;
        chkIconTrans.Checked := BoolValue('IconAlphaBlend', False);
        sgbIconTrans.value := IntValue('IconAlpha', 255);
        chkColorBlend.Checked := BoolValue('IconBlending', False);
        sgbColorBlend.Value := IntValue('IconBlendAlpha', 255);
        chkIconShadow.Checked := BoolValue('IconShadow', True);
        sgbIconShadow.Value := IntValue('IconShadowAlpha', 196);
        sceIconColor.Items.Item[0].ColorCode := IntValue('IconBlendColor', 0);
        sceIconColor.Items.Item[1].ColorCode := IntValue('IconShadowColor', 0);
{$ENDREGION}

{$REGION 'FontTab'}
        FFontName := Value('FontName', 'Verdana');
        sgbFontSize.Value := IntValue('TextSize', 12);
        chkBold.Checked := BoolValue('TextBold', False);
        chkItalic.Checked := BoolValue('TextItalic', False);
        chkUnderline.Checked := BoolValue('TextUnderline', False);
        chkFontTrans.Checked := BoolValue('TextAlpha', False);
        sgbFontTrans.Value := IntValue('TextAlphaValue', 255);
        chkFontShadow.Checked := BoolValue('TextShadow', True);
        sgbFontShadowTrans.Value := IntValue('TextShadowAlpha', 196);
        sceFontColor.Items.Item[0].ColorCode := IntValue('TextColor', clWhite);
        sceShadowColor.Items.Item[0].ColorCode := IntValue('TextShadowColor', 0);
        cboFontShadowType.ItemIndex := Max(0, Min(3, IntValue('TextShadowType', 0)));
{$ENDREGION}
      end;
    end;

    // Animation settings
    fileName := SharpApi.GetSharpeUserSettingsPath + '\Themes\' + PluginId + '\DesktopAnimation.xml';
    PluginHost.Xml.XmlFilename := fileName;
    if PluginHost.Xml.Load then begin

      with XmlRoot.Items do begin

        chkAnim.Checked := BoolValue('UseAnimations', True);
        chkAnimSize.Checked := BoolValue('Scale', False);
        sgbAnimSize.Value := IntValue('ScaleValue', 0);
        chkAnimTrans.Checked := BoolValue('Alpha', True);
        sgbAnimTrans.Value := IntValue('AlphaValue', 64);
        chkAnimColorBlend.Checked := BoolValue('Blend', False);
        sgbAnimColorBlend.Value := IntValue('BlendValue', 255);
        chkAnimBrightness.Checked := BoolValue('Brightness', True);
        sgbAnimBrightness.Value := IntValue('BrightnessValue', 64);
        sceAnimColor.Items.Item[0].ColorCode := IntValue('BlendColor', clWhite);
      end;
    end;

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

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmSettingsWnd);
end;

procedure TSharpCenterPlugin.Save;
var
  iIconSize: integer;
  sDir: string;
begin
  // Init
  sDir := GetSharpeUserSettingsPath + '\Themes\' + PluginHost.PluginId + '\';

  with frmSettingsWnd, PluginHost.Xml do begin

    XMLRoot.Items.Clear;
    XMLRoot.Name := 'SharpEThemeDesktopIcon';

    with XMLRoot.Items do
    begin
      if rdoIcon32.Checked then
        iIconSize := 32
      else if rdoIcon48.Checked then
        iIconSize := 48
      else if rdoIcon64.Checked then
        iIconSize := 64
      else
        iIconSize := sgbIconSize.Value;

      Add('IconSize', iIconSize);
      Add('IconAlphaBlend', chkIconTrans.Checked);
      Add('IconAlpha', sgbIconTrans.Value);
      Add('IconBlending', chkColorBlend.Checked);
      Add('IconBlendAlpha', sgbColorBlend.Value);
      Add('IconShadow', chkIconShadow.Checked);
      Add('IconShadowAlpha', sgbIconShadow.Value);
      Add('IconBlendColor',
        sceIconColor.Items.Item[0].ColorCode);
      Add('IconShadowColor',
        sceIconColor.Items.Item[1].ColorCode);
      Add('FontName', cboFontName.Text);
      Add('TextSize', sgbFontSize.Value);
      Add('TextBold', chkBold.Checked);
      Add('TextItalic', chkItalic.Checked);
      Add('TextUnderline', chkUnderline.Checked);
      Add('TextAlpha', chkFontTrans.Checked);
      Add('TextAlphaValue', sgbFontTrans.Value);
      Add('TextShadow', chkFontShadow.Checked);
      Add('TextShadowAlpha', sgbFontShadowTrans.Value);
      Add('TextShadowType', cboFontShadowType.ItemIndex);
      Add('TextColor', sceFontColor.Items.Item[0].ColorCode);
      Add('TextShadowColor',
        sceShadowColor.Items.Item[0].ColorCode);
    end;

    XmlFilename := sDir + 'DesktopIcon.xml';
    PluginHost.Xml.Save;

    XMLRoot.Items.Clear;
    XMLRoot.Name := 'SharpEThemeDesktopAnimation';

    with XMLRoot.Items do
    begin
      Add('UseAnimations', chkAnim.Checked);
      Add('Scale', chkAnimSize.Checked);
      Add('ScaleValue', sgbAnimSize.Value);
      Add('Alpha', chkAnimTrans.Checked);
      Add('AlphaValue', sgbAnimTrans.Value);
      Add('Blend', chkAnimColorBlend.Checked);
      Add('BlendValue', sgbAnimColorBlend.Value);
      Add('Brightness', chkAnimBrightness.Checked);
      Add('BrightnessValue', sgbAnimBrightness.Value);
      Add('BlendColor', sceAnimColor.Items.Item[0].ColorCode);
    end;

    XmlFilename := sDir + 'DesktopAnimation.xml';
    PluginHost.Xml.Save;

  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Desktop';
    Description := 'Desktop Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suDesktopIcon)]);
  end;
end;

function InitPluginInterface(APluginHost: TInterfacedSharpCenterHostBase): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

//
//procedure Save;
//var
//  XML: TJvSimpleXML;
//  iIconSize: integer;
//  sDir, sFileName: string;
//begin
//  // Init
//  sDir := SharpApi.GetSharpeUserSettingsPath + '\Themes\' +
//    frmDesktopSettings.FTheme + '\';
//  sFileName := sDir + 'DesktopIcon.xml';
//
//  with frmDesktopSettings do begin
//
//    xml := TJvSimpleXML.Create(nil);
//    try
//      XML.Root.Name := 'SharpEThemeDesktopIcon';
//      XML.Root.Items.Clear;
//
//      with XML.Root.Items do
//      begin
//        if rdoIcon32.Checked then
//          iIconSize := 32
//        else if rdoIcon48.Checked then
//          iIconSize := 48
//        else if rdoIcon64.Checked then
//          iIconSize := 64
//        else
//          iIconSize := sgbIconSize.Value;
//
//        Add('IconSize', iIconSize);
//        Add('IconAlphaBlend', chkIconTrans.Checked);
//        Add('IconAlpha', sgbIconTrans.Value);
//        Add('IconBlending', chkColorBlend.Checked);
//        Add('IconBlendAlpha', sgbColorBlend.Value);
//        Add('IconShadow', chkIconShadow.Checked);
//        Add('IconShadowAlpha', sgbIconShadow.Value);
//        Add('IconBlendColor',
//          sceIconColor.Items.Item[0].ColorCode);
//        Add('IconShadowColor',
//          sceShadowColor.Items.Item[0].ColorCode);
//        Add('FontName', cboFontName.Text);
//        Add('TextSize', sgbFontSize.Value);
//        Add('TextBold', chkBold.Checked);
//        Add('TextItalic', chkItalic.Checked);
//        Add('TextUnderline', chkUnderline.Checked);
//        Add('TextAlpha', chkFontTrans.Checked);
//        Add('TextAlphaValue', sgbFontTrans.Value);
//        Add('TextShadow', chkFontShadow.Checked);
//        Add('TextShadowAlpha', sgbFontShadowTrans.Value);
//        Add('TextShadowType', cboFontShadowType.ItemIndex);
//        Add('TextColor', sceFontColor.Items.Item[0].ColorCode);
//        Add('TextShadowColor',
//          sceShadowColor.Items.Item[0].ColorCode);
//      end;
//
//      XML.SaveToFile(sFileName + '~');
//      if FileExists(sFileName) then
//        DeleteFile(sFileName);
//      RenameFile(sFileName + '~', sFileName);
//
//      sFileName := sDir + 'DesktopAnimation.xml';
//      XML.Root.Name := 'SharpEThemeDesktopAnimation';
//      XML.Root.Items.Clear;
//
//      with XML.Root.Items do
//      begin
//        Add('UseAnimations', chkAnim.Checked);
//        Add('Scale', chkAnimSize.Checked);
//        Add('ScaleValue', sgbAnimSize.Value);
//        Add('Alpha', chkAnimTrans.Checked);
//        Add('AlphaValue', sgbAnimTrans.Value);
//        Add('Blend', chkAnimColorBlend.Checked);
//        Add('BlendValue', sgbAnimColorBlend.Value);
//        Add('Brightness', chkAnimBrightness.Checked);
//        Add('BrightnessValue', sgbAnimBrightness.Value);
//        Add('BlendColor', sceAnimColor.Items.Item[0].ColorCode);
//      end;
//
//      XML.SaveToFile(sFileName + '~');
//      if FileExists(sFileName) then
//        DeleteFile(sFileName);
//      RenameFile(sFileName + '~', sFileName);
//
//
//    finally
//      xml.Free;
//    end;
//
//  end;
//end;
//
//
//
//procedure ClickTab(ATab: TStringItem);
//begin
//  TJvStandardPage(ATab.FObject).Show;
//  frmDesktopSettings.UpdatePageUi;
//end;
//
//function GetMetaData(): TMetaData;
//begin
//  with result do
//  begin
//    Name := 'Desktop';
//    Description := 'Desktop Theme Configuration';
//    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
//    Version := '0.7.5.2';
//    DataType := tteConfig;
//    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
//      Integer(suDesktopIcon)]);
//  end;
//end;
//
//procedure GetCenterTheme(const ATheme: TCenterThemeInfo; const AEdit: Boolean);
//begin
//  AssignThemeToForm(ATheme,frmDesktopSettings);
//end;
//
//exports
//  Open,
//  Close,
//  Save,
//  SetText,
//  GetMetaData,
//  AddTabs,
//  GetCenterTheme,
//  ClickTab;
//
//end.

