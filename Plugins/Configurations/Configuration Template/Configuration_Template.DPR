{
Source Name: <Configuration_Name>
Description: <Configuration_Name> Configuration for SharpE
Copyright (C) <Author_Name> <Author_Email>

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

library Configuration_Template;
uses
  windows,
  registry,
  Classes,
  Messages,
  activex,
  sysutils,
  Jclstrings,
  forms,
  SharpApi,
  PngSpeedButton;

{$E service}

{What happens when the configuration is opened, first time init}

function Open(const APluginID: Integer; owner: hwnd): hwnd;
begin
  result := 0;
end;

{Handle what is happened when help is clicked}

procedure Help;
begin
  SharpApi.HelpMsg('go {docs}\PathToDocs');
end;

{Handle what happens when the conifguration is closed}

function Close(owner: hwnd; SaveSettings: Boolean): boolean;
begin
  result := False;
end;

{ Set configuration type

SCU_SHARPDESK; SCU_SHARPCORE; SCU_SHARPBAR; SCU_SHARPMENU; SCU_SHARPTHEME;
  SCU_SERVICE; SCU_OBJECT; SCU_MODULE; }

function ConfigDllType: Integer;
begin
  Result := SCU_SERVICE;
end;

{Customise the display name for the conifiguration}

procedure GetDisplayName(const APluginID: Integer; var ADisplayName: PChar);
begin
  ADisplayName := PChar('<Configuration_Name>');
end;

{Define which buttons to add, and what action to perform, if the method is
within this dpr, the button is enabled

BTNMOVEUP; BTNMOVEDOWN; BTNADD; BTNDEL; BTNEDIT; BTNIMPORT; BTNEXPORT;
  BTNCLEAR;
procedure BtnAdd(var AButton:TPngSpeedButton);
begin
end;    }

//Ordinary Dll code, tells delphi what functions to export.
exports
  Open,
  Close,
  Help,
  ConfigDllType,
  GetDisplayName;
begin

end.

