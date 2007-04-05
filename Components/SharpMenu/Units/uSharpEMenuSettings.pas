{
Source Name: uSharpeMenuSettings.pas
Description: SharpE Menu Settings Class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.net

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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

unit uSharpEMenuSettings;

interface

uses
  SysUtils, Classes, Types, JvSimpleXML;

type
  TSharpEMenuSettings = class
  private
  public
    WrapMenu : boolean;
    WrapCount : integer;
    WrapPosition : integer;
    CacheIcons : boolean;

    procedure LoadFromXML; overload;
    procedure LoadFromXML(pFileName : String); overload;
    procedure LoadFromXML(pXML : TJvSimpleXMLElems); overload;
    procedure Assign(from : TSharpEMenuSettings);
    constructor Create; reintroduce;
  published
  end;

implementation

uses
  SharpApi;

constructor TSharpEMenuSettings.Create;
begin
  inherited Create;

  // Default settings
  WrapMenu := False;
  WrapCount := 20;
  WrapPosition := 1;
  CacheIcons := True;
end;

procedure TSharpEMenuSettings.Assign(from : TSharpeMenuSettings);
begin
  WrapMenu := from.WrapMenu;
  WrapCount := from.WrapCount;
  WrapPosition := from.WrapPosition;
  CacheIcons := from.CacheIcons;
end;

procedure TSharpEMenuSettings.LoadFromXML;
begin
  LoadFromXML(SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Settings\SharpMenu.xml');
end;

procedure TSharpEMenuSettings.LoadFromXML(pXML : TJvSimpleXMLElems);
begin
  with pXML do
  begin
    WrapMenu := BoolValue('WrapMenu',WrapMenu);
    WrapCount := IntValue('WrapCount',WrapCount);
    WrapPosition := IntValue('WrapPosition',WrapPosition);
    CacheIcons := BoolValue('CacheIcons',CacheIcons);
  end;
end;

procedure TSharpEMenuSettings.LoadFromXML(pFileName : String);
var
  XML : TJvSimpleXML;
begin
  if not FileExists(pFileName) then exit;

  XML := TJvSimpleXMl.Create(nil);
  try
    XML.LoadFromFile(pFileName);
    if XML.Root.Items.ItemNamed['Settings'] <> nil then
       LoadFromXML(XML.Root.Items.ItemNamed['Settings'].Items);
  finally
    XML.Free;
  end;
end;

end.
