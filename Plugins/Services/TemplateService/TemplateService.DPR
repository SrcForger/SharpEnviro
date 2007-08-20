{
Source Name: Service.dpr
Description: SharpE Service library file
Copyright (C) Author (E-Mail)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.SharpE-Shell.org

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

library TemplateService;

uses
  windows;

{$E ser}

{$R *.RES}

// Service is started
procedure Stop;
begin
end;

// Service is stopped
function Start(owner: hwnd): hwnd;
begin
  Result := owner;
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


