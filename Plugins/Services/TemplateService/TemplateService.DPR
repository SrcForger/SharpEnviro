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
  windows,
  SharpApi;

{$E ser}

{$R *.RES}

// Service is started
function Start(owner: hwnd): hwnd;
begin
  Result := owner;
  ServiceDone('Template');
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

// Data retrieved by SharpCore
function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Template';
    Description := 'Template';
    Author := 'Author (E-Mail)';
    Version := '0.7.4.0';
    DataType := tteService;
    ExtraData := 'priority: 170| delay: 0';
  end;
end;


//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  SCMsg,
  GetMetaData;

begin
end.


