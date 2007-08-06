{
Source Name: Not available
Description: Startup Apps service
Copyright (C) Pixol (pixol@sharpe-shell.org)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

end.

