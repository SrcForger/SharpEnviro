﻿{
Source Name: VolumeControl.dpr
Description: VolumeControl Module Config DLL
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

library VolumeControl;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  JvPageList,
  Graphics,
  MMSystem,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uVolumeControlWnd in 'uVolumeControlWnd.pas' {frmVolumeControl};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs)
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create(APluginHost: TInterfacedSharpCenterHostBase);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh; override; stdcall;

    function GetPluginDescriptionText: string; override; stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
  SharpCenterApi.GetBarModuleIds(PluginHost.PluginId, barID, moduleID);
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
end;

procedure TSharpCenterPlugin.Load;
var
  n,i : integer;
begin
  frmVolumeControl.BuildMixerList;

  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmVolumeControl do
    begin
      sgb_Width.Value := IntValue('Width',75);
      i := IntValue('Mixer',MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
      for n := 0 to IDList.Count -1 do
      begin
        if strtoint(IDList[n]) = i then
        begin
          cb_mlist.ItemIndex := n;
          break;
        end;
      end;
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmVolumeControl = nil then frmVolumeControl := TfrmVolumeControl.Create(nil);
  frmVolumeControl.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmVolumeControl);

  Load;
  result := PluginHost.Open(frmVolumeControl);
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlRoot.Name := 'VolumeControlModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmVolumeControl do
  begin
    // Clear the list so we don't get duplicates.
    Clear;
    
    if IDList.Count = 0 then
      Add('Mixer',0)
    else
      Add('Mixer',IDList[cb_mlist.ItemIndex]);

    Add('Width', sgb_Width.Value);
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmVolumeControl);
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  result := 'Configure volume control module';
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
begin
  TJvStandardPage(ATab.FObject).Show;
end;

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  if frmVolumeControl <> nil then
  begin
    ATabItems.AddObject('Volume Control', frmVolumeControl.JvSettingsPage);
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Volume Control';
    Description := 'Volume Control Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmVolumeControl);
end;

function InitPluginInterface(APluginHost: TInterfacedSharpCenterHostBase) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.
