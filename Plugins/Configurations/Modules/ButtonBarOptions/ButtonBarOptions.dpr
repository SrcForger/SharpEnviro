{
Source Name: ButtonBarModuleOptions.dpr
Description: ButtonBar Module Options Config
Copyright (C) Lee Green (lee@sharpenviro.com)

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

library ButtonBarOptions;
uses
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
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  SharpThemeApiEx,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SettingsWnd in 'SettingsWnd.pas' {frmSettings};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh; override; stdCall;

    function GetPluginDescriptionText: String; override; stdCall;
    function GetPluginName: String; override; stdCall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlRoot.Name := 'ButtonBarModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmSettings do
  begin
    // Do not clear the list as the ButtonBarModule also saves to this file.

    if ItemNamed['ShowCaption'] <> nil then
      ItemNamed['ShowCaption'].BoolValue := chkButtonCaption.Checked
    else
      Add('ShowCaption', chkButtonCaption.Checked);

    if ItemNamed['ShowIcon'] <> nil then
      ItemNamed['ShowIcon'].BoolValue := chkButtonIcon.Checked
    else
      Add('ShowIcon', chkButtonIcon.Checked);

    if ItemNamed['Width'] <> nil then
      ItemNamed['Width'].IntValue := sgbWidth.Value
    else
      Add('Width', sgbWidth.Value);
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
begin
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmSettings do
    begin
      chkButtonCaption.Checked := BoolValue('ShowCaption', False);
      chkButtonIcon.Checked := BoolValue('ShowIcon', True);
      sgbWidth.Value := IntValue('Width', 25);
    end;
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

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

function TSharpCenterPlugin.GetPluginDescriptionText : String;
begin
  result := 'Configure global options for the button bar module';
end;

function TSharpCenterPlugin.GetPluginName: String;
begin
  Result := 'Options';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'ButtonBar Module Options';
    Description := 'ButtonBar Module Options Config';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmSettings);
end;

function InitPluginInterface( APluginHost: TInterfacedSharpCenterHostBase ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

