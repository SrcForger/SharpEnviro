unit uSharpEMenuSaver;
{
Source Name: uSharpEMenuSaver.pas
Description: SharpE Menu Save Functions
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

interface

uses JclSimpleXML,SysUtils,
     uSharpEMenu,
     uSharpEMenuItem,
     uSharpEMenuSettings;

function SaveMenu(pMenu : TSharpEMenu; pFileName : String) : boolean;

implementation

procedure SaveMenuToXMLNode(pXML : TJclSimpleXMLElems; pMenu : TSharpEMenu);
var
  n : integer;
  menuitem : TSharpEMenuItem;
begin

  if pMenu.CustomSettings then
    pMenu.Settings.SaveToXML(pXML.Add('Settings').Items);

  for n := 0 to pMenu.Items.Count - 1 do
  begin
    menuitem := TSharpEMenuItem(pMenu.Items[n]);
    if not menuitem.isDynamic then
      with pXML.Add('item').Items do
      begin
        case menuitem.ItemType of
          mtLink: begin
            Add('type','link');
            Add('Caption',menuitem.Caption);
            Add('Target',menuitem.PropList.GetString('Action'));
            Add('Icon',menuitem.PropList.GetString('IconSource'));
          end;
          mtSeparator : Add('type','separator');
          mtDynamicDir : begin
            Add('type','dynamicdirectory');
            Add('Target',menuitem.PropList.GetString('Action'));
            Add('MaxItems',menuitem.PropList.GetInt('MaxItems'));
            Add('Sort',menuitem.PropList.GetInt('Sort'));
            Add('Filter',menuitem.PropList.GetString('Filter'));
            Add('Recursive',menuitem.PropList.GetBool('Recursive'));
          end;
          mtDriveList: begin
            Add('type','drivelist');
            Add('ShowDriveNames',menuitem.PropList.GetString('ShowDriveNames'));
          end;
          mtCPLList: Add('type','cpllist');
          mtDesktopObjectList: Add('type','objectlist');
          mtLabel: begin
            Add('type','label');
            Add('Caption',menuitem.Caption);
          end;
          mtulist: begin
            Add('type','ulist');
            Add('itemtype',menuitem.PropList.GetInt('Type'));
            Add('count',menuitem.PropList.GetInt('Count'));
          end;
          mtSubMenu: begin
            Add('type','submenu');
            Add('Caption',menuitem.Caption);
            Add('Target',menuitem.PropList.GetString('Target'));
            Add('Icon',menuitem.PropList.GetString('IconSource'));
            if menuitem.SubMenu <> nil then            
              SaveMenuToXMLNode(Add('Items').Items,TSharpEMenu(menuitem.SubMenu));
          end;
      end;
    end;
  end;
end;

function SaveMenu(pMenu : TSharpEMenu; pFileName : String) : boolean;
var
  Dir : String;
  XML : TJclSimpleXML;
begin
  result := False;
  if pMenu = nil then
    exit;

  Dir := ExtractFileDir(pFileName);
  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);

  XML := TJclSimpleXML.Create;
  XML.Root.Name := 'SharpEMenuFile';
  SaveMenuToXMLNode(XML.Root.Items,pMenu);
  try
    XML.SaveToFile(pFileName);
  finally
    XML.Free;
  end;
end;

end.
