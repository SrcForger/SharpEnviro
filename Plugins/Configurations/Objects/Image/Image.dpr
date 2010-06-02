{
Source Name: Image
Description: Image Object Config Dll
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

library Image;
uses
  VCLFixPack,
  Controls,
  Classes,
  Windows,
  Forms,
  SysUtils,
  GR32,
  GR32_Image,
  JvPageList,
  SharpEUIC,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SharpThemeApiEx,
  uISharpETheme,
  uSharpDeskObjectSettings,
  uVistaFuncs,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings},
  ImageObjectXMLSettings in '..\..\..\Objects\Image\ImageObjectXMLSettings.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs )
  private
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdCall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('Image',frmSettings.pagImage);
  ATabItems.AddObject('Display',frmSettings.pagDisplay);
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
  PluginHost.Refresh(rtSize);
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
  Settings : TImageXMLSettings;
  ITheme : ISharpETheme;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpCore\Services\VWM\VWM.xml';
  
  Settings := TImageXMLSettings.Create(strtoint(PluginHost.PluginId),nil,'Image');
  Settings.LoadSettings;

  with frmSettings, Settings do
  begin
    case LocationType of
      ilFile:
      begin
        sgbFileScaling.Value := Size;
        spc.TabIndex := 0;
        imagefile.Text := Path;
      end;
      ilURL:
      begin
        sgbURLScaling.Value := Size;
        spc.TabIndex := 1;
        imageurl.Text := Path;
        sgbURLInterval.Value := RefreshInterval;
      end;
      ilDirectory:
      begin
        spc.TabIndex := 2;
        imageDirectory.Text := Path;
        sgbDirectoryInterval.Value := RefreshInterval;
        sgbDirectoryHeight.Value := ImageHeight;
        sgbDirectoryWidth.Value := ImageWidth;
      end;
    end;
    ITheme := GetCurrentTheme;

    // assign the theme default values
    if ITheme.Desktop.Icon.IconAlphaBlend then
      UIC_AlphaBlend.DefaultValue := 'True'
      else UIC_AlphaBlend.DefaultValue := 'False';
    if ITheme.Desktop.Icon.IconBlending then
      UIC_ColorBlend.DefaultValue := 'True'
      else UIC_ColorBlend.DefaultValue := 'False';
    UIC_BlendAlpha.DefaultValue := inttostr(ITheme.Desktop.Icon.IconAlpha);
    UIC_ColorAlpha.DefaultValue := inttostr(ITheme.Desktop.Icon.IconBlendAlpha);
    UIC_Colors.DefaultValue := inttostr(ITheme.Desktop.Icon.IconBlendColor);

    // load the actual values
    cbalphablend.Checked               := Theme[DS_ICONALPHABLEND].BoolValue;
    cbcolorblend.Checked               := Theme[DS_ICONBLENDING].BoolValue;
    sgbiconalpha.Value                 := Theme[DS_ICONALPHA].IntValue;
    sbgimagencblendalpha.Value         := Theme[DS_ICONBLENDALPHA].IntValue;
    IconColors.Items.Item[0].ColorCode := Theme[DS_ICONBLENDCOLOR].IntValue;

    // load if settings are changed
    UIC_AlphaBlend.HasChanged := Theme[DS_ICONALPHABLEND].isCustom;
    UIC_ColorBlend.HasChanged := Theme[DS_ICONBLENDING].isCustom;
    UIC_BlendAlpha.Haschanged := Theme[DS_ICONALPHA].isCustom;
    UIC_ColorAlpha.HasChanged := Theme[DS_ICONBLENDALPHA].isCustom;
    UIC_Colors.HasChanged     := Theme[DS_ICONBLENDCOLOR].isCustom;
  end;

  Settings.Free;
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
  Settings : TImageXMLSettings;
begin

  with frmSettings, Settings do
  begin
    Settings := TImageXMLSettings.Create(strtoint(PluginHost.PluginId),nil,'Image');
    Settings.LoadSettings;

    // save the normal settings
    case spc.TabIndex of
      0:
      begin
        Size := sgbFileScaling.Value;
        LocationType := ilFile;
        Path := imagefile.Text;
      end;
      1:
      begin
        Size := sgbURLScaling.Value;
        LocationType := ilURL;
        RefreshInterval := sgbURLInterval.Value;
        Path := imageurl.Text;
      end;
      2:
      begin
        ImageHeight := sgbDirectoryHeight.Value;
        ImageWidth := sgbDirectoryWidth.Value;
        LocationType := ilDirectory;
        RefreshInterval := sgbDirectoryInterval.Value;
        Path := imageDirectory.Text;
      end;
    end;


    // save which UIC items have changed and should be saved to xml
    Theme[DS_ICONALPHABLEND].isCustom := UIC_AlphaBlend.HasChanged;
    Theme[DS_ICONBLENDING].isCustom   := UIC_ColorBlend.HasChanged;
    Theme[DS_ICONALPHA].isCustom      := UIC_BlendAlpha.Haschanged;
    Theme[DS_ICONBLENDALPHA].isCustom := UIC_ColorAlpha.HasChanged;
    Theme[DS_ICONBLENDCOLOR].isCustom := UIC_Colors.HasChanged;

    // save the actual values (will only be saved to XMl if isCustom = True)
    Theme[DS_ICONALPHABLEND].BoolValue := cbalphablend.Checked;
    Theme[DS_ICONBLENDING].BoolValue   := cbcolorblend.Checked;
    Theme[DS_ICONALPHA].IntValue       := sgbiconalpha.Value;
    Theme[DS_ICONBLENDALPHA].IntValue  := sbgimagencblendalpha.Value;
    Theme[DS_ICONBLENDCOLOR].IntValue  := IconColors.Items.Item[0].ColorCode;
  end;
  Settings.SaveSettings(True);
  Settings.Free;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Image';
    Description := 'Image Object Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suDesktopObject)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Image';
    Description := 'The Image object allows you to locally and remotely display images';
    Status := '';
  end;
end;

function InitPluginInterface( APluginHost: ISharpCenterHost ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin;
end.

