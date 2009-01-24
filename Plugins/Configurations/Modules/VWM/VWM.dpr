{
Source Name: VWM.dpr
Description: VWM Module Config Dll
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

library VWM;
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
  uVWMsWnd in 'uVWMsWnd.pas' {frmVWM};

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
  PluginHost.Xml.XmlRoot.Name := 'VWMModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmVWM do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    Add('Numbers',chkShowNumbers.Checked);
    Add('Background',Colors.Items.Item[0].ColorCode);
    Add('Border',Colors.Items.Item[1].ColorCode);
    Add('Foreground',Colors.Items.Item[2].ColorCode);
    Add('Highlight',Colors.Items.Item[3].ColorCode);
    Add('Text',Colors.Items.Item[4].ColorCode);
    Add('BackgroundAlpha',sgb_Background.Value);
    Add('BorderAlpha',sgb_Border.Value);
    Add('ForegroundAlpha',sgb_Foreground.Value);
    Add('HighlightAlpha',sgb_Highlight.Value);
    Add('TextAlpha',sgb_Text.Value);
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
begin
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmVWM do
    begin
      chkShowNumbers.Checked := BoolValue('Numbers',True);
      Colors.Items.Item[0].ColorCode := IntValue('Background',clWhite);
      Colors.Items.Item[1].ColorCode := IntValue('Border',clBlack);
      Colors.Items.Item[2].ColorCode := IntValue('Foreground',clBlack);
      Colors.Items.Item[3].ColorCode := IntValue('Highlight',clWhite);
      Colors.Items.Item[4].ColorCode := IntValue('Text',clBlack);
      sgb_Background.Value := IntValue('BackgroundAlpha',128);
      sgb_Border.Value     := IntValue('BorderAlpha',128);
      sgb_Foreground.Value := IntValue('ForegroundAlpha',64);
      sgb_Highlight.Value  := IntValue('HighlightAlpha',192);
      sgb_Text.Value       := IntValue('TextAlpha',255);
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmVWM = nil then frmVWM := TfrmVWM.Create(nil);
  frmVWM.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmVWM);

  Load;
  result := PluginHost.Open(frmVWM);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmVWM);
end;

function TSharpCenterPlugin.GetPluginDescriptionText : String;
begin
  result := 'Configure virtual window manager module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'VWM';
    Description := 'VWM Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToPluginForm(frmVWM);
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






