{
Source Name: uSharpEMenuLoader.pas
Description: SharpE Menu Loader Functions
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

unit uSharpEMenuLoader;

interface

uses JvSimpleXML,SysUtils,
     uSharpEMenu,
     uSharpEMenuSettings,
     SharpESkinManager;

function LoadMenu(pFileName : String; pManager: TSharpESkinManager) : TSharpEMenu;

implementation

uses uSharpEMenuItem;

function LoadMenuFromXML(pXML : TJvSimpleXMLElems; pManager: TSharpESkinManager; pSettings : TSharpEMenuSettings) : TSharpEMenu;
var
  n : integer;
  menu : TSharpEMenu;
  menuitem : TSharpEMenuItem;
  typestring : String;
begin
  menu := TSharpEMenu.Create(pManager,pSettings);
  result := menu;
  for n := 0 to pXML.Count - 1 do
      with pXML.Item[n].Items do
      begin
        if CompareText(pXML.Item[n].Name,'Settings') = 0 then
        begin
          // custom Settings for this menu exist...
          menu.Settings.LoadFromXML(pXML.Item[n].Items);
        end else
        begin
          typestring := Value('type','none');
          if CompareText(typestring,'link') = 0 then
             menu.AddLinkItem(Value('Caption'),Value('Target'),Value('Icon'),False)
          else
          if CompareText(typestring,'separator') = 0 then
             menu.AddSeparatorItem(False)
          else
          if CompareText(typestring,'dynamicdirectory') = 0 then
             menu.AddDynamicDirectoryItem(Value('Target'),
                                          IntValue('MaxItems',-1),
                                          IntValue('Sort',0),
                                          Value('Filter'), False)
          else
          if CompareText(typestring,'drivelist') = 0 then
             menu.AddDriveListItem(BoolValue('ShowDriveNames',True),False)
          else
          if CompareText(typestring,'label') = 0 then
             menu.AddLabelItem(Value('Caption'),False)
          else
          if CompareText(typestring,'submenu') = 0 then
          begin
            menuitem := TSharpEMenuItem(menu.AddSubMenuItem(Value('Caption'),Value('Icon'),Value('Icon'),False));
            if ItemNamed['items'] <> nil then
               menuitem.SubMenu := LoadMenuFromXML(ItemNamed['items'].Items,pManager,menu.settings);
          end;
        end;
      end;
end;

function LoadMenu(pFileName : String; pManager: TSharpESkinManager) : TSharpEMenu;
var
  XML : TJvSimpleXML;
  RootMenu : TSharpEMenu;
  tempSettings : TSharpEMenuSettings;
begin
  tempSettings := TSharpEMenuSettings.Create;
  tempSettings.LoadFromXML; // Load the default settings;

  RootMenu := nil;
  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(pFileName) then
    begin
      XML.LoadFromFile(pFileName);
      RootMenu := LoadMenuFromXML(XML.Root.Items,pManager,tempSettings);
    end;
  finally
    XML.Free;
  end;
  
  if RootMenu = nil then
     RootMenu := TSharpEMenu.Create(pManager,tempSettings);
  result := RootMenu;

  tempSettings.Free;
end;

end.
