{
Source Name: Service.dpr
Description: SharpE Service library file
Copyright (C) Author (E-Mail)

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

library TemplateService;

uses
  windows;

{$E ser}

{$R *.RES}

// Service is started
function Start(owner: hwnd): hwnd;
begin
  Result := owner;
end;

// Service is stopped
procedure Stop;
begin
end;

// Service receives a message
function SCMsg(msg: string): integer;
begin
  Result := HInstance;
end;


//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  SCMsg;

end.


