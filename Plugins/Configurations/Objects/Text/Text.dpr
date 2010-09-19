{
Source Name: Text
Description: Text Object Config Dll
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

library Text;

{$R *.res}

uses
//  VCLFixPack,
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
  SysUtils,
  Graphics,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings},
  SharpCenterApi,
  SharpApi,
  SharpThemeApiEx,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uISharpETheme,
  TextObjectXMLSettings in '..\..\..\Objects\Text\TextObjectXMLSettings.pas',
  uSharpDeskObjectSettings in '..\..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas';

{$E .dll}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs)
  private
    procedure Load;
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    procedure AddPluginTabs(ATabItems: TStringList); stdcall;
    procedure ClickPluginTab(ATab: TStringItem); stdcall;
  end;

  { TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.FObject <> nil then begin
    tmpPag := TJvStandardPage(ATab.FObject);
    tmpPag.Show;
  end;
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

procedure TSharpCenterPlugin.Load;
var
  xmlSettings: TXMLSettings;
  ITheme: ISharpETheme;
  txt : string;
begin
  xmlSettings := TXMLSettings.Create(strtoint(PluginHost.PluginId), nil, 'Text');
  try

    xmlSettings.LoadSettings;

    ITheme := GetCurrentTheme;

    with frmSettings, xmlSettings do
    begin
      txt := xmlSettings.Text;
      txt := StringReplace(txt,'<br>',sLineBreak,[rfReplaceAll, rfIgnoreCase]);

      edText.Text := txt;
    end;
  finally
    xmlSettings.Free;
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

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettings,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  xmlSettings: TXMLSettings;

  txt : string;
begin
  SharpApi.SendDebugMessage('Text', 'Saving ' + PluginHost.PluginId, 0);

  xmlSettings := TXMLSettings.Create(strtoint(PluginHost.PluginId), nil, 'Text');
  try

    xmlSettings.LoadSettings;
    with frmSettings, xmlSettings do
    begin
      txt := edText.Text;
      txt := StringReplace(txt,sLineBreak,'<br>',[rfReplaceAll, rfIgnoreCase]);

      xmlSettings.Text := txt;
    end;
    xmlSettings.SaveSettings(True);

  finally
    xmlSettings.Free;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Text';
    Description := 'Text Object Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suDesktopObject)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Text';
    Description := 'The text object allows you to put text on your desktop supporting basic HTML';
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

begin;

end.

