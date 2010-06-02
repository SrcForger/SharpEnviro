{
Source Name: RecycleBinObjectXMLSettings.pas
Description: RecycleBin Object Settings class
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

unit ClockObjectXMLSettings;

interface

uses Graphics,
     JvSimpleXML,
     SharpApi,
     SysUtils,
     uSharpDeskFunctions,
     uSharpDeskObjectSettings;

type
    TClockXMLSettings = class(TDesktopXMLSettings)
    private
    public
      {Settings Block}
      AlphaBlend : Boolean;
      BitmapMasterAlpha : integer;
      Color : TColor;
      Shadow : Boolean;
      SkinType : Boolean;
      AnalogSkin : String;
      DrawText : Boolean;
      DrawOverlay : Boolean;

      BitmapName : String;
      BitmapSize : integer;

      procedure LoadSettings; override;
      procedure SaveSettings(SaveToFile : boolean); reintroduce;

      property theme : TThemeSettingsArray read ts; 
    end;


implementation


procedure TClockXMLSettings.LoadSettings;
var
   alphablend : boolean;
begin
  inherited InitLoadSettings;
  inherited LoadSettings;
  
  with FXMLRoot.Items do
  begin
    AlphaBlend := BoolValue('AlphaBlend',False);
    if AlphaBlend then
      BitmapMasterAlpha := IntValue('AlphaValue',255)
    else
      BitmapMasterAlpha := 255;

    Color := StringToColor(Value('FontColor','0'));
    Shadow := BoolValue('DrawShadow',false);
    SkinType := BoolValue('ClockType',False);
    AnalogSkin := Value('AnalogSkin','');
    DrawText := BoolValue('DrawText',True);
    DrawOverlay := BoolValue('DrawOverlay',True);

    BitmapName := Value('FontName', 'Arial');
    BitmapSize := IntValue('FontSize', 32);
  end;
end;

procedure TClockXMLSettings.SaveSettings(SaveToFile : boolean);
begin
  if FXMLRoot = nil then exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  with FXMLRoot.Items do
  begin
    Add('AlphaBlend',AlphaBlend);
    Add('AlphaValue',BitmapMasterAlpha);
    Add('FontColor', ColorToString(Color));
    Add('DrawShadow',Shadow);
    Add('ClockType',SkinType);
    Add('AnalogSkin',AnalogSkin);
    Add('DrawText',DrawText);
    Add('DrawOverlay',DrawOverlay);

    Add('FontName',BitmapName);
    Add('FontSize', BitmapSize);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;


end.
