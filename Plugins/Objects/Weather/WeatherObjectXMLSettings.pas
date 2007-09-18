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
     uSharpDeskTThemeSettings,
     uSharpDeskTObjectSettings,
     uSharpDeskFunctions;

type
    TXMLSettings = class
    private
      FXML : TJvSimpleXML;
      FXMLRoot : TJvSimpleXMLElem;
      FObjectID : integer;
      procedure SaveSetting(pXMLElems : TJvSimpleXMLElem; pName,pValue : String; copy : boolean); overload;
      procedure SaveSetting(pXMLElems : TJvSimpleXMLElem; pName : String; pValue : Integer; copy : boolean); overload;
      procedure SaveSetting(pXMLElems : TJvSimpleXMLElem; pName : String; pValue : Boolean; copy : boolean); overload;
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
      CustomFont       : boolean;
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
      WeatherSkin      : boolean;
      WeatkerSkinFile  : String;
      WeatherLocation  : String;

      {End Settings Block}
      constructor Create(pObjectID : integer; pXMLRoot: TJvSimpleXMLElem); reintroduce;
      destructor Destroy;
      procedure LoadSettings;
      procedure SaveSettings(SaveToFile : boolean);
      function GetSettingsFile : String;
    published
      property XML : TJvSimpleXML read FXML;
    end;


implementation

constructor TXMLSettings.Create(pObjectID : integer; pXMLRoot: TJvSimpleXMLElem);
begin
  Inherited Create;
  FObjectID := pObjectID;
  FXMLRoot := pXMLRoot;
  FXML := TJvSimpleXML.Create(nil);
  FXML.Root.Name := 'WeatherObjectSettings';
  if FXMLRoot = nil then
     FXMLRoot := FXML.Root;
end;


destructor TXMLSettings.Destroy;
begin
  FXML.Free;
  FXML := nil;
  Inherited Destroy;
end;


function TXMLSettings.GetSettingsFile : string;
var
  UserDir,Dir : String;
begin
  UserDir := SharpApi.GetSharpeUserSettingsPath;
  Dir := UserDir + 'SharpDesk\Objects\Weather\';
  result := Dir + inttostr(FObjectID) + '.xml';
end;

procedure TXMLSettings.LoadSettings;
var
  n : integer;
  SettingsFile : String;
  csX : TColorSchemeEX;
begin
  if FXML = nil then exit;
  SettingsFile := GetSettingsFile;
  if (not FileExists(SettingsFile)) and (FObjectID <> -1) then
  begin
    SharpApi.SendDebugMessageEx('Weather.object','Settings File does not exist',0,DMT_INFO);
  end;

  try
    if FObjectID <> -1 then
       FXML.LoadFromFile(SettingsFile);
  except
    SharpApi.SendDebugMessageEx('Weather.object',PChar('Failed to load Settings File: '+Settingsfile),0,DMT_ERROR);
  end;

  csX := SharpApi.LoadColorSchemeEx;

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
    
    CustomFormat     := BoolValue('CustomFormat',True);
    CustomData       := Value('CustomData','');
    WeatherLocation  := Value('WeatherLocation','');

    BlendColor       := CodeToColorEx(IntValue('BlendColor',-1),csX);
    BlendValue       := IntValue('BlendValue',0);
    AlphaValue       := IntValue('AlphaValue',255);
    Spacing          := IntValue('Spacing',0);
    TextShadow       := BoolValue('TextShadow',False);
    DisplayIcon      := BoolValue('DisplayIcon',True);
    CustomFont       := BoolValue('CustomFont',False);    
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
    WeatherSkin      := BoolValue('WeatherSkin',False);
    WeatkerSkinFile  := Value('WeatherSkinFile','');
  end;
end;

procedure TXMLSettings.SaveSettings(SaveToFile : boolean);
var
  csX : TColorSchemeEx;
  SettingsFile,SettingsDir : String;
begin
  if FXML = nil then exit;

  FXML.Options := FXML.Options + [sxoAutoCreate];
  FXMLRoot.Clear;

  csX := SharpApi.LoadColorSchemeEx;

  SaveSetting(FXMLRoot,'Spacing',Spacing,True);
  SaveSetting(FXMLRoot,'TextShadow',TextShadow,True);
  SaveSetting(FXMLRoot,'DisplayIcon',DisplayIcon,True);
  SaveSetting(FXMLRoot,'ColorBlend',ColorBlend,True);
  SaveSetting(FXMLRoot,'AlphaBlend',AlphaBlend,True);
  SaveSetting(FXMLRoot,'UseThemeSettings',UseThemeSettings,True);
  SaveSetting(FXMLRoot,'Temperature',Temperature,True);
  SaveSetting(FXMLRoot,'Condition',Condition,True);
  SaveSetting(FXMLRoot,'Location',Location,True);
  SaveSetting(FXMLRoot,'DetailedLocation',DetailedLocation,True);
  SaveSetting(FXMLRoot,'Wind',Wind,True);

  SaveSetting(FXMLRoot,'CustomFormat',CustomFormat,True);
  SaveSetting(FXMLRoot,'CustomData',CustomData,True);
  SaveSetting(FXMLRoot,'WeatherLocation',WeatherLocation,False);

  SaveSetting(FXMLRoot,'BlendColor',ColorToCodeEx(BlendColor,csX),True);
  SaveSetting(FXMLRoot,'BlendValue',BlendValue,True);
  SaveSetting(FXMLRoot,'AlphaValue',AlphaValue,True);
  SaveSetting(FXMLRoot,'CustomFont',CustomFont,True);
  SaveSetting(FXMLRoot,'FontName',FontName,True);
  SaveSetting(FXMLRoot,'FontSize',FontSize,True);
  SaveSetting(FXMLRoot,'FontColor',FontColor,True);
  SaveSetting(FXMLRoot,'FontBold',FontBold,True);
  SaveSetting(FXMLRoot,'FontItalic',FontItalic,True);
  SaveSetting(FXMLRoot,'FontUnderline',FontUnderline,True);
  SaveSetting(FXMLRoot,'FontShadow',FontShadow,True);
  SaveSetting(FXMLRoot,'FontShadowValue',FontShadowValue,True);
  SaveSetting(FXMLRoot,'FontShadowColor',FontShadowColor,True);
  SaveSetting(FXMLRoot,'FontAlpha',FontAlpha,True);
  SaveSetting(FXMLRoot,'FontAlphaValue',FontAlphaValue,True);
  SaveSetting(FXMLRoot,'WeatherSkin',WeatherSkin,True);
  SaveSetting(FXMLRoot,'WeatherSkinFile',WeatkerSkinFile,True);

  if SaveToFile then
  begin
    SettingsFile := GetSettingsFile;
    SettingsDir  := ExtractFileDir(SettingsFile);
    ForceDirectories(SettingsDir);
    try
      FXML.SaveToFile(SettingsDir+'~temp.xml');
    except
      SharpApi.SendDebugMessageEx('Weather.object',PChar('Failed to save Settings to: '+SettingsDir+'~temp.xml'),0,DMT_ERROR);
      DeleteFile(SettingsDir+'~temp.xml');
      exit;
    end;
    if FileExists(SettingsFile) then
       DeleteFile(SettingsFile);
    if not RenameFile(SettingsDir+'~temp.xml',SettingsFile) then
       SharpApi.SendDebugMessageEx('Weather.object','Failed to Rename Settings File',0,DMT_ERROR);
  end;
end;

procedure TXMLSettings.SaveSetting(pXMLElems : TJvSimpleXMLElem; pName,pValue : String; copy : boolean);
begin
  pXMLElems.Items.Add(pName,pValue).Properties.Add('CopyValue',copy);
end;

procedure TXMLSettings.SaveSetting(pXMLElems : TJvSimpleXMLElem; pName : String; pValue : Integer; copy : boolean);
begin
  pXMLElems.Items.Add(pName,pValue).Properties.Add('CopyValue',copy);
end;

procedure TXMLSettings.SaveSetting(pXMLElems : TJvSimpleXMLElem; pName : String; pValue : Boolean; copy : boolean);
begin
  pXMLElems.Items.Add(pName,pValue).Properties.Add('CopyValue',copy);
end;


end.
