{
Source Name: QuickScript
Description: QuickScript Module Config Dll
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

library QuickScript;
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
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uQuickScriptWnd in 'uQuickScriptWnd.pas' {frmQuickScript};

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
  PluginHost.Xml.XmlRoot.Name := 'QuickScriptModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmQuickScript do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    Add('Caption', (rb_text.Checked or rb_icontext.Checked));
    Add('Icon', (rb_icon.Checked or rb_icontext.Checked));
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
var
  ShowIcon, ShowCaption : boolean;
begin
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmQuickScript do
    begin
      ShowIcon := BoolValue('Icon',True);
      ShowCaption := BoolValue('Caption',True);
      if ShowIcon and ShowCaption then
        rb_icontext.Checked := True
      else if ShowCaption then
        rb_text.Checked := True
      else rb_icon.Checked := True;
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmQuickScript = nil then frmQuickScript := TfrmQuickScript.Create(nil);
  frmQuickScript.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmQuickScript);

  Load;
  result := PluginHost.Open(frmQuickScript);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmQuickScript);
end;

function TSharpCenterPlugin.GetPluginDescriptionText : String;
begin
  result := 'Quick Script Module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Quick Script';
    Description := 'Quick Script Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmQuickScript);
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

