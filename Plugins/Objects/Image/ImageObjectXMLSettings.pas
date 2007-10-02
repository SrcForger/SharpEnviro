{
Source Name: ImageObjectXMlSettings.pas
Description: Image Object Settings class
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

unit ImageObjectXMLSettings;

interface

uses JvSimpleXML,
     SysUtils,
     SharpApi,
     uSharpDeskObjectSettings,
     uSharpDeskFunctions;

type
    TImageXMLSettings = class(TDesktopXMLSettings)
    private
    public
      {Settings Block}
      IconFile   : String;
      ftURL      : Boolean;
      Size       : integer;
      URLRefresh : integer;
      procedure LoadSettings; override;
      procedure SaveSettings(SaveToFile : boolean); reintroduce;

      property theme : TThemeSettingsArray read ts;
    end;

implementation

procedure TImageXMLSettings.LoadSettings;
begin
  inherited InitLoadSettings;
  inherited LoadSettings;

  with FXMLRoot.Items do
  begin
    IconFile   := Value('IconFile','icon.application');
    Size       := IntValue('Size',100);
    URLRefresh := IntValue('URLRefresh',30);
    ftURL      := BoolValue('ftURL',False);
  end;
end;

procedure TImageXMLSettings.SaveSettings(SaveToFile : boolean);
begin
  if FXMLRoot = nil then exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  with FXMLRoot.Items do
  begin
    Add('IconFile',IconFile).Properties.Add('SortValue',True);;
    Add('Size',Size);
    Add('URLRefresh',URLRefresh);
    Add('ftURL',ftURL);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;


end.
