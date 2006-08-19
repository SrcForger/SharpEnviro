{
Source Name: uWeatherParser.pas
Description: weather parser class
Copyright (C) Lee Green <Pixol@Sharpe-shell.org>
              Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uWeatherParser;

interface

uses
  Windows,
  SysUtils,
  Controls,
  Forms,
  Messages,
  shellAPI,
  Classes,
  ExtCtrls,
  Graphics,
  Registry,
  sharpfx,
  StdCtrls,
  Gauges,
  Menus,
  URLMon,
  StrUtils,
  ImgList,
  HTTPGet,
  SharpAPI,
  dialogs,
  jvsimplexml,
  uSharpDeskDebugging;

type
  TOnReadValue = procedure(Value: string);

type
  TWWindBlock = record
    DirAsDegr: string;
    DirAsTxt: string;
    MaxWindSpd: string;
    WindSpd: string;
  end;

type
  TWBaromBlock = record
    CurrentPressure: string;
    RaiseOrFallAsTxt: string;
  end;

type
  TWUV = record
    Value: string;
    ValueAsTxt: string;
  end;

type
  TWMoon = record
    IconCode: string;
    MoonText: string;
  end;

type
  TWFCPart = record
    IconCode: string;
    Wind: TWWindBlock;
    Humidity: string;
    PercentChancePrecip: string;
    ConditionTxt: string;
  end;

  TWFCDay = record
    DayNum: string;
    DayText: string;
    Date: string;

    TimeSunset: string;
    TimeSunrise: string;
    HighTemp: string;
    LowTemp: string;

    Day: TWFCPart;
    Night: TWFCPart;
  end;

type
  TXMLForecast = class
  private
    FOwner : TObject;
    procedure Refresh;
  public
    LastUpdated: string;
    Days: array[0..9] of TWFCDay;
    constructor Create(pOwner : TObject);
  published
    property Owner : TObject read FOwner;    
  end;

  TXMLCC = class
  private
    FOwner : TObject;
    procedure Refresh;
  public
    Wind: TWWindBlock;
    BaromPressure: TWBaromBlock;
    UV: TWUV;
    Moon: TWMoon;
    Visibility, Temperature, Dewpoint, DateTimeLastUpdate, Humidity, IconCode, ConditionTxt:
    string;
    FeelsLikeTemp, ObservationStation: string;
    constructor Create(pOwner : TObject);
  published
    property Owner : TObject read FOwner;
  end;

  TXMLHeadLoc = class
  private
    FOwner : TObject;
    procedure Refresh;
  public
    // head
    Locale, UnitOfTemp, UnitOfDist, DocFormat, UnitOfSpeed, UnitOfPrecip, UnitOfPress: string;
    // loc
    TimeSunset, Latitude, GmtOffsett, LocationName, Longitude, TimeSunrise: string;
    constructor Create(pOwner : TObject);
  published
    property Owner : TObject read FOwner;
  end;

  TXMLWeather = class
  private
    FOnReadValue : TOnReadValue;
    FOwner       : TObject;
  public
    HeadLoc: TXMLHeadLoc;
    CurrentCondition: TXMLCC;
    Forecast: TXMLForecast;
    constructor Create(pOwner : TObject);
    destructor Destroy; override;
    property OnReadValue: TOnReadValue read FOnReadValue write FOnReadValue;    
  published
    property Owner : TObject read FOwner;
  end;

type
  TWeatherParser = class
  private

    xmlCC, xmlForecast, xmlLinks: TJvSimpleXml;
  public
    wxml: TXMLWeather;
    constructor Create;
    destructor Destroy; override;
    procedure Update(WeatherLocation : String);
  end;

//var
//  WP: TWeatherParser;

const
  spath = 'SharpCore\Services\Weather\';

implementation


{ TWeatherParser }

constructor TWeatherParser.Create;
begin
  Inherited Create;
  xmlCC := TJvSimpleXML.Create(nil);
  xmlForecast := TJvSimpleXML.Create(nil);
  xmlLinks := TJvSimpleXML.Create(nil);
  wxml := TXMLWeather.Create(self);
end;

destructor TWeatherParser.Destroy;
begin
  DebugFree(xmlCC);
  DebugFree(xmlForecast);
  DebugFree(xmlLinks);
  DebugFree(wxml);
  inherited;
end;

procedure TWeatherParser.Update(WeatherLocation : String);
var
  tmp: string;
begin
  // Load Current Conditions
  tmp := GetSharpeUserSettingsPath + spath + 'Data\'+WeatherLocation + '\cc.xml';
  if fileexists(tmp) then
  begin
    try
      xmlCC.LoadFromFile(tmp);

    // Refresh all classes
      wxml.HeadLoc.Refresh;
      wxml.CurrentCondition.Refresh;
    except
    end;
  end;

  // Load Forecast
  tmp := GetSharpeUserSettingsPath + spath + 'Data\'+WeatherLocation + '\forecast.xml';
  if fileexists(tmp) then
  begin
    try
      xmlForecast.LoadFromFile(tmp);
    // Refresh all classes
      wxml.Forecast.Refresh;
    except
    end;
  end;

end;

{ TXMLHead }

constructor TXMLHeadLoc.Create(pOwner : TObject);
begin
  Inherited Create;
  FOwner := pOwner;
end;

procedure TXMLHeadLoc.Refresh;
begin
  // head

  with TWeatherParser(FOwner).xmlCC.Root.Items.ItemNamed['head'].Items do begin
    locale := ItemNamed['locale'].Value;
    UnitOfTemp := ItemNamed['ut'].Value;
    UnitOfDist := ItemNamed['ud'].Value;
    DocFormat := ItemNamed['form'].Value;
    UnitOfSpeed := ItemNamed['us'].Value;
    UnitOfPrecip := ItemNamed['up'].Value;
    UnitOfPress := ItemNamed['ur'].Value;
  end;

  // loc
  with TWeatherParser(FOwner).xmlCC.Root.Items.ItemNamed['loc'].Items do begin
    TimeSunset := ItemNamed['suns'].Value;
    TimeSunrise := ItemNamed['sunr'].Value;
    Latitude := ItemNamed['lat'].Value;
    Longitude := ItemNamed['lon'].Value;
    GmtOffsett := ItemNamed['zone'].Value;
    LocationName := ItemNamed['dnam'].Value;
  end;
end;

{ TXMLWeather }

constructor TXMLWeather.Create(pOwner : TObject);
begin
  FOwner := pOwner;
  HeadLoc := TXMLHeadLoc.Create(FOwner);
  CurrentCondition := TXMLCC.Create(FOwner);
  Forecast := TXMLForecast.Create(FOwner);
end;

destructor TXMLWeather.Destroy;
begin
  DebugFree(HeadLoc);
  DebugFree(CurrentCondition);
  DebugFree(Forecast);
  inherited;
end;

{ TXMLCC }

constructor TXMLCC.Create(pOwner : TObject);
begin
  Inherited Create;
  FOwner := pOwner;
end;

procedure TXMLCC.Refresh;
begin
  // cc
  with TWeatherParser(FOwner).xmlCC.Root.Items.ItemNamed['cc'].Items do begin

    // wind block
    wind.DirAsDegr := ItemNamed['wind'].Items.ItemNamed['d'].Value;
    wind.DirAsTxt := ItemNamed['wind'].Items.ItemNamed['t'].Value;
    wind.MaxWindSpd := ItemNamed['wind'].Items.ItemNamed['gust'].Value;
    wind.WindSpd := ItemNamed['wind'].Items.ItemNamed['s'].Value;

    Visibility := ItemNamed['vis'].Value;
    Temperature := ItemNamed['tmp'].Value;
    Dewpoint := ItemNamed['dewp'].Value;
    DateTimeLastUpdate := ItemNamed['lsup'].Value;
    Humidity := ItemNamed['hmid'].Value;
    IconCode := ItemNamed['icon'].Value;
    ConditionTxt := ItemNamed['t'].Value;

    // Barometric pressure
    BaromPressure.CurrentPressure := ItemNamed['bar'].Items.ItemNamed['r'].Value;
    BaromPressure.RaiseOrFallAsTxt := ItemNamed['bar'].Items.ItemNamed['d'].Value;

    FeelsLikeTemp := ItemNamed['flik'].Value;
    ObservationStation := ItemNamed['obst'].Value;

    // UV
    uv.Value := ItemNamed['uv'].Items.ItemNamed['i'].Value;
    uv.ValueAsTxt := ItemNamed['uv'].Items.ItemNamed['t'].Value;

    // moon
    Moon.IconCode := ItemNamed['moon'].Items.ItemNamed['icon'].Value;
    Moon.MoonText := ItemNamed['moon'].Items.ItemNamed['t'].Value;
  end;
end;

{ TXMLForecast }

constructor TXMLForecast.Create(pOwner : TObject);
begin
  Inherited Create;
  FOwner := pOwner;
end;

procedure TXMLForecast.Refresh;
var
  n: integer;
begin
  // fc
  with TWeatherParser(FOwner).xmlForecast.Root.Items.ItemNamed['dayf'].Items do begin
    LastUpdated := ItemNamed['lsup'].Value;

    if Count > 1 then begin
      for n := 1 to Count - 1 do
        with Item[n] do begin
          // read values for each day
          with Days[n-1] do begin
            DayNum := Properties.ItemNamed['d'].Value;
            DayText := Properties.ItemNamed['t'].Value;
            Date := Properties.ItemNamed['dt'].Value;

            TimeSunset := Items.ItemNamed['suns'].Value;
            TimeSunrise := Items.ItemNamed['sunr'].Value;
            HighTemp := Items.ItemNamed['hi'].Value;
            LowTemp := Items.ItemNamed['low'].Value;

            Day.IconCode := Items.Item[4].Items.ItemNamed['icon'].Value;
            Day.Wind.DirAsDegr := Items.Item[4].Items.ItemNamed['wind'].Items.ItemNamed['d'].Value;
            Day.Wind.DirAsTxt:= Items.Item[4].Items.ItemNamed['wind'].Items.ItemNamed['t'].Value;
            Day.Wind.MaxWindSpd := Items.Item[4].Items.ItemNamed['wind'].Items.ItemNamed['gust'].Value;
            Day.Wind.WindSpd := Items.Item[4].Items.ItemNamed['wind'].Items.ItemNamed['s'].Value;
            Day.Humidity := Items.Item[4].Items.ItemNamed['hmid'].Value;
            Day.PercentChancePrecip := Items.Item[4].Items.ItemNamed['ppcp'].Value;
            Day.ConditionTxt := Items.Item[4].Items.ItemNamed['t'].Value;

            Night.IconCode := Items.Item[5].Items.ItemNamed['icon'].Value;
            Night.Wind.DirAsDegr := Items.Item[5].Items.ItemNamed['wind'].Items.ItemNamed['d'].Value;
            Night.Wind.DirAsTxt:= Items.Item[5].Items.ItemNamed['wind'].Items.ItemNamed['t'].Value;
            Night.Wind.MaxWindSpd := Items.Item[5].Items.ItemNamed['wind'].Items.ItemNamed['gust'].Value;
            Night.Wind.WindSpd := Items.Item[5].Items.ItemNamed['wind'].Items.ItemNamed['s'].Value;
            Night.Humidity := Items.Item[5].Items.ItemNamed['hmid'].Value;
            Night.PercentChancePrecip := Items.Item[5].Items.ItemNamed['ppcp'].Value;
            Night.ConditionTxt := Items.Item[5].Items.ItemNamed['t'].Value;
          end;

        end;
    end;
  end;

end;

end.

