﻿{
Source Name: Clock
Description: Clock Module Config Dll
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

library Clock;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JvPageList,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uClockWnd in 'uClockWnd.pas' {frmClock};

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

procedure TSharpCenterPlugin.Save;
begin
  with PluginHost.Xml.XmlRoot do
  begin
    Name := 'ClockModuleSettings';

    // Clear the list so we don't get duplicates.
    Items.Clear;

    Items.Add('Style', frmClock.cboSize.ItemIndex);
    Items.Add('Format', frmClock.editTop.Text);
    Items.Add('BottomFormat', frmClock.editBottom.Text);
    Items.Add('TooltipFormat', frmClock.editTooltip.Text);

    PluginHost.Xml.Save;
  end;
end;

procedure TSharpCenterPlugin.Load;
begin
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot do
    begin
      frmClock.cboSize.ItemIndex := Items.IntValue('Style', 3);
      frmClock.editTop.Text := Items.Value('Format', 'HH:MM:SS');
      frmClock.editBottom.Text := Items.Value('BottomFormat', 'DD.MM.YYYY');
      frmClock.editTooltip.Text := Items.Value('TooltipFormat', 'DDDD - DD.MM.YYYY');
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmClock = nil then frmClock := TfrmClock.Create(nil);
  frmClock.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmClock);

  Load;
  result := PluginHost.Open(frmClock);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmClock);
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  result := 'Configure formatting options for the clock module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Clock';
    Description := 'Clock Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmClock);
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
