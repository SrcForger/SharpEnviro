{
Source Name: ImageObjectXMlSettings.pas
Description: Image Object Settings class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
    published
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
