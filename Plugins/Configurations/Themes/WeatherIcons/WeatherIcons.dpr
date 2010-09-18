{
Source Name: WeatherIcons
Description: Weather Icons Config Dll
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

library WeatherIcons;
uses
  SysUtils,
  Controls,
  Classes,
  Windows,
  Forms,
  JclSimpleXml,
  uSharpXMLUtils,
  SharpCenterApi,
  SharpThemeApiEx,
  uThemeConsts,
  uISharpETheme,
  uSharpETheme,
  SharpFileUtils,
  SharpApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uVistaFuncs,
  DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',
  uListWnd in 'uListWnd.pas' {frmListWnd},
  BarPreview in '..\..\..\..\Common\Units\BarPreview\BarPreview.pas',
  BarForm in '..\..\..\..\Common\Units\BarPreview\BarForm.pas' {BarWnd},
  uWeatherOptions in '..\..\..\Services\Weather\uWeatherOptions.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    procedure Load;
  public
    constructor Create(APluginHost: ISharpCenterHost);
    destructor Destroy; override;

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdCall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmListWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

destructor TSharpCenterPlugin.Destroy;
begin
  inherited Destroy;
end;

procedure TSharpCenterPlugin.Load;
var
  weatherOpts : TWeatherOptions;
begin
  weatherOpts := TWeatherOptions.Create;
  try
    weatherOpts.LoadSettings;
    frmListWnd.IconSet := weatherOpts.IconSet;
  finally
    weatherOpts.Free;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmListWnd = nil then
    frmListWnd := TfrmListWnd.Create(nil);

  frmListWnd.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmListWnd);

  Load;
  result := PluginHost.Open(frmListWnd);
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmListWnd,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  weatherOpts : TWeatherOptions;
begin
  weatherOpts := TWeatherOptions.Create;
  try
    weatherOpts.LoadSettings;
    weatherOpts.IconSet := frmListWnd.IconSet;
    weatherOpts.SaveSettings;
  finally
    weatherOpts.Free;
  end;

  // Send update message
  SharpApi.BroadcastGlobalUpdateMessage(suWeather);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Icons';
    Description := 'Weather Icons Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply), Integer(suSkin)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
var
  i : integer;
  dirs, files: TStringList;
begin
  with Result do
  begin
  	Name := 'Weather Icons';
    Description := Format('Weather Icon Cofiguration',[pluginID]);
  	Status := '';

    files := TStringList.Create;
    dirs := TStringList.Create;
    try
      SharpFileUtils.FindFiles(dirs, GetSharpeDirectory + '\Icons\Weather', '*.*', False, True);
      for i := 0 to dirs.Count - 1 do
      begin
        if FileExists(dirs[i] + '\IconSet.xml') then
          files.Add(dirs[i] + '\IconSet.xml');
      end;
      if files.Count <> 0 then
        Status := IntToStr(files.Count);
    finally
      dirs.Free;
      files.Free;
    end;
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

begin
end.
