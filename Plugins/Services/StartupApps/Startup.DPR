{
Source Name: Not available
Description: Startup Apps service
Copyright (C) Pixol (pixol@sharpe-shell.org)

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

library Startup;

uses
  Forms,
  windows,
  dialogs,
  graphics,
  sysutils,
  uStartup in 'uStartup.pas',
  FileUtils in '..\Exec\FileUtils.pas';

{$E .ser}

{$R *.RES}

//starts the service

function Start(owner: hwnd): hwnd;
var
  tmp:TStartup;
begin
  // Execute the startup entries
  tmp := TStartup.Create;
  try
    tmp.LoadStartupApps;
  finally
    tmp.Free;
  end;
  Result := Application.Handle;
end;

procedure Stop;
begin
end;

exports
  Start,
  Stop;

begin  
end.

