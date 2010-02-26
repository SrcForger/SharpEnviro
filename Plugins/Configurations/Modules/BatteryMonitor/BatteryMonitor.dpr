{
Source Name: BatteryMonitor
Description: BatteryMonitor Module Config Dll
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

library BatteryMonitor;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uBatteryMonitorWnd in 'uBatteryMonitorWnd.pas' {frmBMon};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin)
  private
    barID : string;
    moduleID : string;
    procedure LoadSettings;
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    function GetPluginDescriptionText: string; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
end;

procedure TSharpCenterPlugin.Save;
begin
  if frmBMon = nil then
    exit;

  with PluginHost.Xml.XmlRoot do
  begin
    Name := 'BatteryMonitorModuleSettings';

    // Clear the list so we don't get duplicates.
    Items.Clear;

    Items.Add('showicon', frmBMon.cb_icon.Checked);

    PluginHost.Xml.Save;
  end;
end;

procedure TSharpCenterPlugin.LoadSettings;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot do
    begin
      frmBMon.cb_icon.Checked := Items.BoolValue('showicon', True);
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmBMon = nil then frmBMon := TfrmBMon.Create(nil);
  frmBMon.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmBMon);

  LoadSettings;
  result := PluginHost.Open(frmBMon);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmBMon);
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  result := 'The battery monitor module displays laptop status';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Battery Monitor';
    Description := 'Battery Monitor Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmBMon,AEditing,Theme);
end;

function InitPluginInterface(APluginHost: ISharpCenterHost) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

