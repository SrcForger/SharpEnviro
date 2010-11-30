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
  ImageLocationType = (ilFile, ilURL, ilDirectory);

type
    TImageXMLSettings = class(TDesktopXMLSettings)
    private
    public
      {Settings Block}
      Path : String;
      Size : integer;
      RefreshInterval : integer;
      LocationType : ImageLocationType;
      ImageHeight : Integer;
      ImageWidth : Integer;
      ImageRandomize : Boolean;
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
    Path := Value('IconFile','icon.application');
    Size := IntValue('Size',100);
    RefreshInterval := IntValue('URLRefresh',30);
    LocationType := ImageLocationType(IntValue('LocationType', Int64(ilFile)));
    ImageHeight := IntValue('ImageHeight', 500);
    ImageWidth := IntValue('ImageWidth', 500);
    ImageRandomize := BoolValue('ImageRandomize', True);
  end;
end;

procedure TImageXMLSettings.SaveSettings(SaveToFile : boolean);
begin
  if FXMLRoot = nil then exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  with FXMLRoot.Items do
  begin
    Add('IconFile',Path).Properties.Add('SortValue',True);
    Add('Size',Size);
    Add('URLRefresh',RefreshInterval);
    Add('LocationType', Int64(LocationType));
    Add('ImageHeight', ImageHeight);
    Add('ImageWidth', ImageWidth);
    Add('ImageRandomize', ImageRandomize);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;


end.
