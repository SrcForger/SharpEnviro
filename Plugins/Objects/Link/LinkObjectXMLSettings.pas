{
Source Name: LinkObjectXMLSettings.pas
Description: Link Object Settings class
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

unit LinkObjectXMLSettings;

interface

uses JvSimpleXML,
     SharpApi,
     SysUtils,
     uSharpDeskFunctions,
     uSharpDeskObjectSettings;

type
    TLinkXMLSettings = class(TDesktopXMLSettings)
    private
    public
      {Settings Block}
      CaptionAlign     : integer;
      Caption          : string;
      Target           : string;
      Icon             : String;
      ShowCaption      : boolean;
      MLineCaption     : boolean;
      procedure LoadSettings(OnlyAdd : boolean = False); overload;
      procedure SaveSettings(SaveToFile : boolean); reintroduce;

      property theme : TThemeSettingsArray read ts; 
    end;


implementation



procedure TLinkXMLSettings.LoadSettings(OnlyAdd : boolean = False);
begin
  if (not OnlyAdd) then
  begin
    inherited InitLoadSettings;
    inherited LoadSettings;
  end;

  with FXMLRoot.Items do
  begin
    Icon         := Value('Icon','icon.application');
    Caption      := Value('Caption','Link');
    Target       := Value('Target','explorer');
    CaptionAlign := IntValue('CaptionAlign',2);
    MLineCaption := BoolValue('MLineCaption',False);
    ShowCaption  := BoolValue('ShowCaption',True);
  end;
end;

procedure TLinkXMLSettings.SaveSettings(SaveToFile : boolean);
begin
  if FXMLRoot = nil then exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  with FXMLRoot.Items do
  begin
    Add('Target',Target);
    Add('Icon',Icon);
    Add('Caption',Caption).Properties.Add('SortValue',True);
    Add('CaptionAlign',CaptionAlign);
    Add('MLineCaption',MLineCaption);
    Add('ShowCaption',ShowCaption);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;


end.
