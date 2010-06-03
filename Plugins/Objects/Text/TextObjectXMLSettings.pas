{
Source Name: TextLayer XML settings
Description: Text desktop object settings class
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

unit TextObjectXMLSettings;

interface

uses JvSimpleXML,
     SharpApi,
     SysUtils,
     uSharpDeskTDeskSettings,
     uSharpDeskFunctions,
     uSharpDeskObjectSettings;

type
    TXMLSettings = class(TDesktopXMLSettings)
    public
      {Settings Block}
      AlphaValue       : integer;
      AlphaBlend       : boolean;
      BlendColor       : integer;
      BlendValue       : integer;
      Text             : string;
      BGSkin           : string;
      Shadow           : boolean;
      ColorBlend       : boolean;
      ShowCaption      : boolean;
      UseThemeSettings : boolean;
      BGThickness      : boolean;
      BGTrans          : boolean;
      BGTransValue     : integer;
      BGType           : integer;
      BGColor          : integer;
      BGBorderColor    : integer;
      BGThicknessValue : integer;
      BGTHBlend        : boolean;
      BGTHBlendColor   : integer;        
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
    AlphaValue       := IntValue('AlphaValue',255);
    AlphaBlend       := BoolValue('AlphaBlend',False);
    BlendValue       := IntValue('BlendValue',0);
    ColorBlend       := BoolValue('ColorBlend',False);
    Text             := Value('Text','');
    if length(Text) = 0 then
      Text := '<font color="#ffffff">Text.Object</font>';
    Text := StringReplace(Text,'#;01;#','<',[rfReplaceAll, rfIgnoreCase]);
    Text := StringReplace(Text,'#;02;#','>',[rfReplaceAll, rfIgnoreCase]);
    Shadow           := BoolValue('Shadow',False);
    ShowCaption      := BoolValue('ShowCaption',True);
    UseThemeSettings := BoolValue('UseThemeSettings',True);
    BGSkin           := Value('BGSkin','');    
    BGType           := IntValue('BGType',0);    
    BGColor          := IntValue('BGColor',-6);
    BGBorderColor    := IntValue('BGBorderColor',-5);
    BlendColor       := IntValue('BlendColor',-1);
    BGTrans          := BoolValue('BGTrans',False);
    BGTransValue     := IntValue('BGTransValue',0);
    BGThickness      := BoolValue('BGThickness',True);    
    BGThicknessValue := IntValue('BGThicknessValue',1);
    BGTHBlend        := BoolValue('BGTHBlend',False);
    BGTHBlendColor   := IntValue('BGTHBlendColor',0);       
  end;
end;

procedure TXMLSettings.SaveSettings(SaveToFile : boolean);
begin
  if FXMLRoot = nil then
    exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  Text := StringReplace(Text,'<','#;01;#',[rfReplaceAll, rfIgnoreCase]);
  Text := StringReplace(Text,'>','#;02;#',[rfReplaceAll, rfIgnoreCase]);

  with FXMLRoot.Items do
  begin
    Add('AlphaValue', AlphaValue);
    Add('AlphaBlend', AlphaBlend);
    Add('BlendValue', BlendValue);
    Add('ColorBlend', ColorBlend);
    Add('Text', Text);
    Add('Shadow', Shadow);
    Add('ShowCaption', ShowCaption);
    Add('UseThemeSettings', UseThemeSettings);
    Add('BGColor',BGColor);
    Add('BGBorderColor',BGBorderColor);
    Add('BGType', BGType);
    Add('BGSkin', BGSkin);
    Add('BlendColor',BlendColor);
    Add('BGTrans', BGTrans);
    Add('BGTransValue', BGTransValue);
    Add('BGThickness', BGThickness);
    Add('BGThicknessValue', BGThicknessValue);
    Add('BGTHBlend', BGTHBlend);
    Add('BGTHBlendColor', BGTHBlendColor);
  end;
end;

end.
