{
Source Name: WeatherModule.dpr
Description: Weather Module Config
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

library WeatherModule;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  SharpThemeApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uEditWnd in 'uEditWnd.pas' {frmEdit};

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
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
  SharpCenterApi.GetBarModuleIds(PluginHost.PluginId, barID, moduleID);
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
end;

procedure TSharpCenterPlugin.Load;
begin
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmEdit do
    begin
        cbLocation.ItemIndex := cbLocation.Items.IndexOf(Value('Location', ''));
        if cbLocation.ItemIndex = -1 then cbLocation.ItemIndex := 0;

        chkDisplayIcon.Checked := BoolValue('ShowIcon', True);
        chkDisplayLabels.Checked := BoolValue('ShowLabels', True);
        edtTopLabel.Text := Value('TopLabel', 'Temperature: {#TEMPERATURE#}°{#UNITTEMP#}');
        edtBottomLabel.Text := Value('BottomLabel', 'Condition: {#CONDITION#}');
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmEdit = nil then frmEdit := TfrmEdit.Create(nil);
  frmEdit.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmEdit);

  Load;
  result := PluginHost.Open(frmEdit);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmEdit);
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlRoot.Name := 'WeatherModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmEdit do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    Add('Location', cbLocation.Text);
    Add('ShowIcon', chkDisplayIcon.Checked);
    Add('ShowLabels', chkDisplayLabels.Checked);
    Add('TopLabel', edtTopLabel.Text);
    Add('BottomLabel', edtBottomLabel.Text);
  end;

  PluginHost.Xml.Save;
end;

function TSharpCenterPlugin.GetPluginDescriptionText : String;
begin
  result := 'Configure Weather Module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Weather Module';
    Description := 'Weather Module Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmEdit);
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

