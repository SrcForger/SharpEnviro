{
Source Name: Font
Description: Font Config Dll
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

library Font;
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
  SharpEUIC,
  uVistaFuncs,
  SharpThemeApi,
  SharpApi,
  SysUtils,
  Graphics,
  SharpEFontSelectorFontList,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettingsWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs )
  private
    procedure Load;
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    function GetPluginDescriptionText: String; override; stdCall;
    procedure Refresh; override; stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
    procedure Save; override; stdCall;


  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('Font Face', frmSettingsWnd.pagFont);
  ATabItems.AddObject('Font Shadow', frmSettingsWnd.pagFontShadow);
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.FObject <> nil then begin
    tmpPag := TJvStandardPage(ATab.FObject);
    tmpPag.Show;

    if tmpPag = frmSettingsWnd.pagFont then
      frmSettingsWnd.Height := 500 else
      frmSettingsWnd.Height := 220;
  end;
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettingsWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := Format('Skin Font Configuration for "%s"',[PluginHost.PluginId]);
end;

procedure TSharpCenterPlugin.Load;
begin

end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettingsWnd = nil then frmSettingsWnd := TfrmSettingsWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmSettingsWnd);

  frmSettingsWnd.PluginHost := PluginHost;
  frmSettingsWnd.LoadSettings;
  result := PluginHost.Open(frmSettingsWnd);

end;

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForm(PluginHost.Theme,frmSettingsWnd);
end;

procedure TSharpCenterPlugin.Save;
begin
  frmSettingsWnd.SaveSettings;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Skin Font';
    Description := 'Skin Font Theme Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suTheme)]);
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

