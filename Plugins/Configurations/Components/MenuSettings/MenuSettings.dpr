{
Source Name: MenuSettings.dpr
Description: Menu Settings Configuration
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

library MenuSettings;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  JvPageList,
  Graphics,
  Math,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpDeskTDeskSettings,
  uSharpCenterPluginScheme,
  settingsWnd in 'settingsWnd.pas' {frmSettings};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    procedure LoadSettings;
  public
    constructor Create( APluginHost: ISharpCenterHost );

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

procedure TSharpCenterPlugin.LoadSettings;
var
  dir, fileName: string;
begin
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Settings\';
  fileName := dir + 'SharpMenu.xml';
  PluginHost.Xml.XmlFilename := fileName;

  with PluginHost, frmSettings do begin

    if Xml.Load then begin

    if Xml.XmlRoot.Items.ItemNamed['Settings'] <> nil then
         with Xml.XmlRoot.Items.ItemNamed['Settings'].Items do
         begin
           chkMenuWrapping.Checked := BoolValue('WrapMenu',True);
           sgbWrapCount.Value := IntValue('WrapCount',25);
           cboWrapPos.ItemIndex := IntValue('WrapPosition',1);
           chkUseIcons.Checked := BoolValue('UseIcons',True);
           chkUseGenericIcons.Checked := BoolValue('UseGenericIcons',False);
           chkCacheIcons.Checked := BoolValue('CacheIcons', True);
           chkHideTimeout.Checked := (IntValue('HideTimeout', 0) > 0);
           edtHideTimeout.Text := FloatToStr(FloatValue('HideTimeout',0.0) / 1000.0);
           UpdateUi;
         end;
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettings = nil then frmSettings := TfrmSettings.Create(nil);
  uVistaFuncs.SetVistaFonts(frmSettings);

  frmSettings.IsUpdating := true;
  try

    result := PluginHost.Open(frmSettings);
    frmSettings.PluginHost := PluginHost;
    frmSettings.Plugin := Self;
    LoadSettings;

  finally
    frmSettings.IsUpdating := false;
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettings,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  dir : String;
  fileName : String;
  fHide : Extended;
begin
  try
    fHide := StrToFloat(frmSettings.edtHideTimeout.Text);
  except
    exit;
  end;

  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Settings\';
  fileName := dir + 'SharpMenu.xml';

  with PluginHost, frmSettings do begin
    Xml.XmlRoot.Clear;
    Xml.XmlRoot.Name := 'SharpEMenuSettings';
    with Xml.XmlRoot.Items.Add('Settings').Items do
    begin
      Add('WrapMenu',chkMenuWrapping.Checked);
      Add('WrapCount',sgbWrapCount.Value);
      Add('WrapPosition',cboWrapPos.ItemIndex);
      Add('UseIcons',chkUseIcons.Checked);
      Add('UseGenericIcons',chkUseGenericIcons.Checked);
      Add('CacheIcons', chkCacheIcons.Checked);
      if chkHideTimeout.Checked then
        Add('HideTimeout',Round(fHide*1000.0))
      else
        Add('HideTimeout','0');
    end;

    PluginHost.Xml.Save;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Menu Options';
    Description := 'Menu Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suSharpMenu)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Menu Options';
    Description := 'Define global menu options.';
    Status := '';
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

