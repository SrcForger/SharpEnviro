{
Source Name: RecycleBinObjectXMLSettings.pas
Description: RecycleBin Object Settings class
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

unit RecycleBinObjectXMLSettings;

interface

uses JvSimpleXML,
     SharpApi,
     SysUtils,
     uSharpDeskFunctions,
     uSharpDeskObjectSettings;

type
    TRecycleXMLSettings = class(TDesktopXMLSettings)
    private
    public
      {Settings Block}
      Icon             : String;
      Icon2            : String;
      ShowData         : boolean;
      CaptionAlign     : integer;
      Caption          : string;
      Target           : string;
      MLineCaption     : boolean;
      procedure LoadSettings; override;
      procedure SaveSettings(SaveToFile : boolean); reintroduce;
    published
      property theme : TThemeSettingsArray read ts; 
    end;


implementation



procedure TRecycleXMLSettings.LoadSettings;
begin
  inherited InitLoadSettings;
  inherited LoadSettings;

  with FXMLRoot.Items do
  begin
    Icon         := Value('Icon','icon.application');
    Icon2        := Value('Icon2','icon.application');
    Target       := 'shell:RecycleBinFolder';
    ShowData     := BoolValue('ShowData',True);
    Caption      := Value('Caption','');
    CaptionAlign := IntValue('CaptionAlign',2);
    MLineCaption := BoolValue('MLineCaption',False);
  end;
end;

procedure TRecycleXMLSettings.SaveSettings(SaveToFile : boolean);
begin
  if FXMLRoot = nil then exit;

  inherited InitSaveSettings;
  inherited SaveSettings;

  with FXMLRoot.Items do
  begin
    Add('Icon',Icon);
    Add('Icon2',Icon2);
    Add('ShowData',ShowData);
    Add('Caption',Caption).Properties.Add('SortValue',True);
    Add('CaptionAlign',CaptionAlign);
    Add('MLineCaption',MLineCaption);
  end;

  inherited FinishSaveSettings(SaveToFile);
end;


end.
