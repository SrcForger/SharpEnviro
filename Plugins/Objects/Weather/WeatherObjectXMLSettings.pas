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
      UseThemeSettings : boolean;
      ColorBlend       : boolean;
      AlphaBlend       : boolean;
      Location         : boolean;
      DetailedLocation : boolean;
      Temperature      : boolean;
      Wind             : boolean;
      Condition        : boolean;
      CustomFormat     : boolean;
      TextShadow       : boolean;
      DisplayIcon      : boolean;
      BlendColor       : integer;
      BlendValue       : integer;
      AlphaValue       : integer;
      Spacing          : integer;
      CustomData       : String;
      FontName         : String;
      FontSize         : integer;
      FontColor        : integer;
      FontBold         : boolean;
      FontItalic       : boolean;
      FontUnderline    : boolean;
      FontShadow       : boolean;
      FontShadowValue  : integer;
      FontShadowColor  : integer;
      FontAlpha        : boolean;
      FontAlphaValue   : integer;
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
    AlphaBlend       := BoolValue('AlphaBlend',False);
    ColorBlend       := BoolValue('ColorBlend',False);
    UseThemeSettings := BoolValue('UseThemeSettings',True);
    Location         := BoolValue('Location',True);
    DetailedLocation := BoolValue('DetailedLocation',True);
    Temperature      := BoolValue('Temperature',True);
    Wind             := BoolValue('Wind',True);
    Condition        := BoolValue('Condition',True);
    
    CustomFormat     := BoolValue('CustomFormat',False);
    CustomData       := Value('CustomData','');
    WeatherLocation  := Value('WeatherLocation','');

    BlendColor       := IntValue('BlendColor',0);
    BlendValue       := IntValue('BlendValue',0);
    AlphaValue       := IntValue('AlphaValue',255);
    Spacing          := IntValue('Spacing',0);
    TextShadow       := BoolValue('TextShadow',False);
    DisplayIcon      := BoolValue('DisplayIcon',True);
    FontName         := Value('FontName','Verdana');
    FontSize         := IntValue('FontSize',10);
    FontColor        := IntValue('FontColor',0);
    FontBold         := BoolValue('FontBold',False);
    FontItalic       := BoolValue('FontItalic',False);
    FontUnderline    := BoolValue('FontUnderline',False);
    FontShadow       := BoolValue('FontShadow',False);
    FontShadowValue  := IntValue('FontShadowValue',0);
    FontShadowColor  := IntValue('FontShadowColor',0);
    FontAlpha        := BoolValue('FontAlpha',False);
    FontAlphaValue   := IntValue('FontAlphaValue',255);
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
    Add('Spacing', Spacing);
    Add('TextShadow', TextShadow);
    Add('DisplayIcon', DisplayIcon);
    Add('ColorBlend', ColorBlend);
    Add('AlphaBlend', AlphaBlend);
    Add('UseThemeSettings', UseThemeSettings);
    Add('Temperature', Temperature);
    Add('Condition', Condition);
    Add('Location', Location);
    Add('DetailedLocation', DetailedLocation);
    Add('Wind', Wind);

    Add('CustomFormat', CustomFormat);
    Add('CustomData', CustomData);
    Add('WeatherLocation', WeatherLocation);

    Add('BlendColor', BlendColor);
    Add('BlendValue', BlendValue);
    Add('AlphaValue', AlphaValue);
    Add('FontName', FontName);
    Add('FontSize', FontSize);
    Add('FontColor', FontColor);
    Add('FontBold', FontBold);
    Add('FontItalic', FontItalic);
    Add('FontUnderline', FontUnderline);
    Add('FontShadow', FontShadow);
    Add('FontShadowValue', FontShadowValue);
    Add('FontShadowColor', FontShadowColor);
    Add('FontAlpha', FontAlpha);
    Add('FontAlphaValue', FontAlphaValue);
    Add('WeatherSkin', WeatherSkin);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;

end.
