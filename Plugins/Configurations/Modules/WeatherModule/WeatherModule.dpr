{
Source Name: WeatherModule.dpr
Description: Weather Module Config
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

library WeatherModule;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uEditWnd in 'uEditWnd.pas' {frmEdit};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdCall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
end;

procedure TSharpCenterPlugin.Load;
var
  xml:TJclSimpleXML;
  n: Integer;
  WeatherFile : String;
  s : String;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmEdit do
    begin
      WeatherFile := GetSharpEUserSettingsPath+'SharpCore\Services\Weather\WeatherList.xml';

      s := Value('Location', '');
      if FileExists(WeatherFile) then
      begin
        xml := TJclSimpleXML.Create;

        try
          xml.LoadFromFile(WeatherFile);

          for n := 0 to XML.Root.Items.Count - 1 do
            if CompareText(XML.Root.Items.Item[n].Properties.Value('LocationID'),s) = 0 then
            begin
              s := XML.Root.Items.Item[n].Properties.Value('Location',s);
              break;
            end;
        finally
          xml.Free;
       end;
      end;

      cbLocation.ItemIndex := cbLocation.Items.IndexOf(s);
      if cbLocation.ItemIndex = -1 then cbLocation.ItemIndex := 0;

      chkDisplayIcon.Checked := BoolValue('ShowIcon', True);
      chkDisplayLabels.Checked := BoolValue('ShowLabels', True);
      chkDisplayNotification.Checked := BoolValue('ShowNotification', True);
      edtTopLabel.Text := Value('TopLabel', 'Temperature: {#TEMPERATURE#}°{#UNITTEMP#}');
      edtBottomLabel.Text := Value('BottomLabel', 'Condition: {#CONDITION#}');
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmEdit = nil then frmEdit := TfrmEdit.Create(nil);
  frmEdit.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmEdit);

  Load;
  result := PluginHost.Open(frmEdit);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmEdit);
end;

procedure TSharpCenterPlugin.Save;
var
  xml:TJclSimpleXML;
  n: Integer;
  WeatherFile : String;
  s : String;
begin
  PluginHost.Xml.XmlRoot.Name := 'WeatherModuleSettings';

  WeatherFile := GetSharpEUserSettingsPath+'SharpCore\Services\Weather\WeatherList.xml';

  s := frmEdit.cbLocation.Text;
  if FileExists(WeatherFile) then
  begin
    xml := TJclSimpleXML.Create;

    try
      xml.LoadFromFile(WeatherFile);

      for n := 0 to XML.Root.Items.Count - 1 do
        if CompareText(XML.Root.Items.Item[n].Properties.Value('Location'),s) = 0 then
        begin
          s := XML.Root.Items.Item[n].Properties.Value('LocationID',s);
          break;
        end;

    finally
      xml.Free;
    end;
  end;

  with PluginHost.Xml.XmlRoot.Items, frmEdit do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    Add('Location', s);
    Add('ShowIcon', chkDisplayIcon.Checked);
    Add('ShowLabels', chkDisplayLabels.Checked);
    Add('ShowNotification', chkDisplayNotification.Checked);
    Add('TopLabel', edtTopLabel.Text);
    Add('BottomLabel', edtBottomLabel.Text);
  end;

  PluginHost.Xml.Save;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Weather Module';
    Description := 'Weather Module Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.5';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(): TPluginData;
begin
  with Result do
  begin
	Name := 'Weather Module';
    Description := 'Configure the Weather module';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmEdit,AEditing,Theme);
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

