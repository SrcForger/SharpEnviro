{
Source Name: Clock
Description: Clock Object Config Dll
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

library Clock;

{$R 'res\icons.res'}
{$R 'VersionInfo.res'}
{$R *.res}

uses
  ShareMem,
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
  ClockObjectXMLSettings in '..\..\..\Objects\Clock\ClockObjectXMLSettings.pas',
  uSharpDeskObjectSettings in '..\..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas';

{$E .dll}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs)
  private
    procedure Load;
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
  ATabItems.AddObject('Analog Skins', frmSettings.pagAnalog);
  ATabItems.AddObject('Digital Skins', frmSettings.pagDigital);
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
  xmlSettings: TClockXMLSettings;
  ITheme: ISharpETheme;
begin
  xmlSettings := TClockXMLSettings.Create(strtoint(PluginHost.PluginId), nil, 'Clock');
  try
    xmlSettings.LoadSettings;

    ITheme := GetCurrentTheme;

    with frmSettings, xmlSettings do
    begin
     {$REGION 'Load custom options'}
      frmSettings.ClockSkin := xmlSettings.Skin;
      frmSettings.ClockSkinCategory := xmlSettings.SkinCategory;
      frmSettings.ClockSkinFilter := xmlSettings.SkinFilter;
      {$ENDREGION}
    end;

  finally
    xmlSettings.Free;
  end;

  frmSettings.BuildSkinList;
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
  xmlSettings: TClockXMLSettings;
begin
  xmlSettings := TClockXMLSettings.Create(strtoint(PluginHost.PluginId), nil, 'Clock');
  try

    xmlSettings.LoadSettings;
    with frmSettings, xmlSettings do
    begin

      {$REGION 'Save custom options'}
      if frmSettings.pagDigital.Visible then
      begin
        xmlSettings.Skin := TSkinItem(lbDigitalSkins.SelectedItem.Data).SkinName;
        xmlSettings.SkinCategory := 'Digital';
        xmlSettings.SkinFilter := TSkinItem(lbDigitalSkins.SelectedItem.Data).SkinFilter;
      end else
      begin
        xmlSettings.Skin := TSkinItem(lbAnalogSkins.SelectedItem.Data).SkinName;
        xmlSettings.SkinCategory := 'Analog';
        xmlSettings.SkinFilter := TSkinItem(lbAnalogSkins.SelectedItem.Data).SkinFilter;
      end;
      {$ENDREGION}

      // Update form settings
      frmSettings.ClockSkin := xmlSettings.Skin;
      frmSettings.ClockSkinCategory := xmlSettings.SkinCategory;
    end;
    xmlSettings.SaveSettings(True);

  finally
    xmlSettings.Free;
  end;

  frmSettings.UpdateList;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Clock';
    Description := 'Clock Object Configuration';
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
    Name := 'Clock';
    Description := 'The Clock object shows the current time on your desktop';
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

