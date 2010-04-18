{
Source Name: uSharpeMenuSettings.pas
Description: SharpE Menu Settings Class
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

unit uSharpEMenuSettings;

interface

uses
  SysUtils, Classes, Types, JclSimpleXML;

type
  TSharpEMenuSettings = class
  private
  public
    WrapMenu : boolean;
    WrapCount : integer;
    WrapPosition : integer;
    CacheIcons : boolean;
    UseIcons : boolean;
    UseGenericIcons : boolean;
    ShowExtensions : boolean;
    HideTimeout : integer;

    procedure LoadFromXML; overload;
    procedure LoadFromXML(pFileName : String); overload;
    procedure LoadFromXML(pXML : TJclSimpleXMLElems); overload;
    procedure SaveToXML(pXML : TJclSimpleXMLElems);
    procedure Assign(from : TSharpEMenuSettings);
    constructor Create; reintroduce;
  end;

implementation

uses
  SharpApi;

constructor TSharpEMenuSettings.Create;
begin
  inherited Create;

  // Default settings
  WrapMenu := True;
  WrapCount := 25;
  WrapPosition := 1;
  CacheIcons := True;
  UseIcons := True;
  UseGenericIcons := False;
  ShowExtensions := False;
  HideTimeout := 0;
end;

procedure TSharpEMenuSettings.Assign(from : TSharpeMenuSettings);
begin
  WrapMenu := from.WrapMenu;
  WrapCount := from.WrapCount;
  WrapPosition := from.WrapPosition;
  CacheIcons := from.CacheIcons;
  UseIcons := from.UseIcons;
  UseGenericIcons := from.UseGenericIcons;
  ShowExtensions := from.ShowExtensions;
  HideTimeout := from.HideTimeout;
end;

procedure TSharpEMenuSettings.LoadFromXML;
begin
  LoadFromXML(SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Settings\SharpMenu.xml');
end;

procedure TSharpEMenuSettings.LoadFromXML(pXML : TJclSimpleXMLElems);
begin
  with pXML do
  begin
    WrapMenu := BoolValue('WrapMenu',WrapMenu);
    WrapCount := IntValue('WrapCount',WrapCount);
    WrapPosition := IntValue('WrapPosition',WrapPosition);
    CacheIcons := BoolValue('CacheIcons',CacheIcons);
    UseIcons := BoolValue('UseIcons',UseIcons);
    UseGenericIcons := BoolValue('UseGenericIcons',UseGenericIcons);
    ShowExtensions := BoolValue('ShowExtensions',ShowExtensions);
    HideTimeout := IntValue('HideTimeout',HideTimeout);
  end;
end;

procedure TSharpEMenuSettings.SaveToXML(pXML: TJclSimpleXMLElems);
begin
  with pXML do
  begin
    Add('WrapMenu',WrapMenu);
    Add('WrapCount',WrapCount);
    Add('WrapPosition',WrapPosition);
    Add('CacheIcons',CacheIcons);
    Add('UseIcons',UseIcons);
    Add('UseGenericIcons',UseGenericIcons);
    Add('ShowExtensions',ShowExtensions);
    Add('HideTimeout',HideTimeout);
  end;
end;

procedure TSharpEMenuSettings.LoadFromXML(pFileName : String);
var
  XML : TJclSimpleXML;
begin
  if not FileExists(pFileName) then exit;

  XML := TJclSimpleXMl.Create;
  try
    XML.LoadFromFile(pFileName);
    if XML.Root.Items.ItemNamed['Settings'] <> nil then
       LoadFromXML(XML.Root.Items.ItemNamed['Settings'].Items);
  finally
    XML.Free;
  end;
end;

end.
