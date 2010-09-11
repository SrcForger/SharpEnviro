{
Source Name: WeatherObjectXMlSettings.pas
Description: Weather Object Settings class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit WeatherObjectXMLSettings;

interface

uses JvSimpleXML,
     SysUtils,
     SharpAPI,
     uSharpDeskTDeskSettings,
     uSharpDeskFunctions,
     uSharpDeskObjectSettings;

type
    TXMLSettings = class(TDesktopXMLSettings)
    public
      {Settings Block}
      Location         : boolean;
      DetailedLocation : boolean;
      Temperature      : boolean;
      Wind             : boolean;
      Condition        : boolean;
      CustomFormat     : boolean;
      DisplayIcon      : boolean;
      ShowCaption      : boolean;
      CustomData       : String;
      WeatherSkin      : string;
      WeatherLocation  : String;

      {End Settings Block}
      procedure LoadSettings; override;
      procedure SaveSettings(SaveToFile : boolean); reintroduce;

      property theme : TThemeSettingsArray read ts;
    end;


implementation

procedure TXMLSettings.LoadSettings;
begin
  inherited InitLoadSettings;
  inherited LoadSettings;

  with FXMLRoot.Items do
  begin
    Location         := BoolValue('Location',True);
    DetailedLocation := BoolValue('DetailedLocation',True);
    Temperature      := BoolValue('Temperature',True);
    Wind             := BoolValue('Wind',True);
    Condition        := BoolValue('Condition',True);
    
    CustomFormat     := BoolValue('CustomFormat',False);
    CustomData       := Value('CustomData','');
    WeatherLocation  := Value('WeatherLocation','');

    DisplayIcon      := BoolValue('DisplayIcon',True);
    ShowCaption      := BoolValue('ShowCaption',True);
    WeatherSkin      := Value('WeatherSkin','');
  end;
end;

procedure TXMLSettings.SaveSettings(SaveToFile : boolean);
begin
  if FXMLRoot = nil then exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  with FXMLRoot.Items do
  begin
    Add('DisplayIcon', DisplayIcon);
    Add('ShowCaption', ShowCaption);

    Add('Temperature', Temperature);
    Add('Condition', Condition);
    Add('Location', Location);
    Add('DetailedLocation', DetailedLocation);
    Add('Wind', Wind);

    Add('CustomFormat', CustomFormat);
    Add('CustomData', CustomData);
    Add('WeatherLocation', WeatherLocation);

    Add('WeatherSkin', WeatherSkin);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;

end.
