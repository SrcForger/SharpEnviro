﻿{
Source Name: MultimediaInput.dpr
Description: MultimediaInput Service Config DLL
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

library MultimediaInput;
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
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    procedure Load;
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdCall;

    function GetPluginDescriptionText: String; override; stdCall;
    procedure Refresh; override; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpCore\Services\MultimediaInput\MultimediaInput.xml';
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'Support for Multimedia Input Devices (Keyboard, Mouse)';
end;

procedure TSharpCenterPlugin.Load;
begin
  if PluginHost.Xml.Load then begin
    with PluginHost.Xml.XmlRoot.Items, frmSettings do
    begin
      chkShowOSD.Checked := BoolValue('ShowOSD',True);
      cboVertPos.ItemIndex := IntValue('OSDVertPos',2);
      cboHorizPos.ItemIndex := IntValue('OSDHorizPos',1);
      UpdateUI;
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

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmSettings);
end;

procedure TSharpCenterPlugin.Save;
begin
  with PluginHost.Xml.XmlRoot.Items, frmSettings do
  begin
    Name := 'MultimediaInputServiceSettings';
    Clear;
    Add('ShowOSD',chkShowOSD.Checked);
    Add('OSDVertPos',cboVertPos.ItemIndex);
    Add('OSDHorizPos',cboHorizPos.ItemIndex);

    PluginHost.Xml.Save;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Multimedia Input';
    Description := 'Multimedia Input Service Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suMMInput)]);
  end;
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