{
Source Name: xml settings
Description: drive object xml settings
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

unit DriveObjectXMLSettings;

interface

uses Graphics,
     JclSimpleXML,
     SharpApi,
     SysUtils,
     uSharpDeskTDeskSettings,
     uSharpDeskFunctions,
     uSharpDeskObjectSettings;

type
  TXMLSettings = class(TDesktopXMLSettings)
  private

  public
    {Settings Block}

      IconFile : string;
      Caption : string;
      Target : string;
      ShowCaption : boolean;
      CaptionAlign : integer;
           
      {End Settings Block}
      procedure LoadSettings; override;
      procedure SaveSettings(SaveToFile : boolean); reintroduce;

      property Theme : TThemeSettingsArray read ts;
    end;


implementation

procedure TXMLSettings.LoadSettings;
begin
  inherited InitLoadSettings;
  inherited LoadSettings;

  with FXMLRoot.Items do
  begin
    IconFile         := Value('IconFile','icon.drive.hdd');
    Caption          := Value('Caption','C');
    Target           := Value('Target','C');
    ShowCaption      := BoolValue('ShowCaption',True);
    CaptionAlign     := IntValue('CaptionAlign',0);
  end;
end;

procedure TXMLSettings.SaveSettings(SaveToFile : boolean);
begin
  if FXMLRoot = nil then
    exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  with FXMLRoot.Items do
  begin
    Add('IconFile',IconFile);
    Add('Target',Target);
    with FXMLRoot.Items.ItemNamed['Target'].Properties do
    begin
      Add('CopyValue',False);
      Add('SortValue',True);
    end;

    Add('Caption', Caption);
    Add('ShowCaption', ShowCaption);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;

end.
