{
Source Name: Proxy
Description: Proxy Configuration
Copyright (C) Mathias Tillman (mathias@sharpenviro.com)

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

library Proxy;
uses
  ShareMem,
  Controls,
  Classes,
  Windows,
  SysUtils,
  Forms,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SharpCenterApi,
  SharpApi,
  GR32,
  SharpThemeApiEx,
  uVistaFuncs,
  uSharpCenterPluginScheme,
  DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings},
  uSharpHTTP in '..\..\..\..\Common\Units\SharpHTTP\uSharpHTTP.pas';

{$E .dll}

{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin)
  private
    procedure Load;
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

procedure TSharpCenterPlugin.Load;
begin
  frmSettings.LoadSettings;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettings = nil then
    frmSettings := TfrmSettings.Create(nil);
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
begin
  frmSettings.SaveSettings;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Proxy';
    Description := 'Proxy Configuration';
    Author := 'Mathias Tillman (mathias@sharpenviro.com)';
    DataType := tteConfig;
    ExtraData := format('configmode: %d', [Integer(scmApply)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Proxy';
    Description := 'Define proxy address used for several modules';
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

