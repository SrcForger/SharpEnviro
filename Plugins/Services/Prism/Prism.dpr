{
Source Name: Prism.service
Description: Service for memory and cpu optimisation
Copyright (C) Lee Green <Pixol@sharpe-shell.org>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 6
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
library Prism;

uses
  windows,
  Classes,
  Messages,
  Dialogs,
  sysutils,
  ExtCtrls,
  graphics,
  forms,
  JvComponent,
  JvSimpleXml,
  SharpApi,
  uCPUGeneral in 'uCPUGeneral.pas',
  uPrismController in 'uPrismController.pas',
  uPrismSettings in '..\SettingsDll\uPrismSettings.pas';

{$E ser}

{$R *.RES}

function Start(owner: hwnd): hwnd;
var
  fn: string;
begin
  // Specidfy the Service configuration filename
  fn := GetSharpeUserSettingsPath +
    'SharpCore\Services\Prism\Prism.xml';

  // Create the Prism form and Settings Class
  PrismSettings := TPrismSettings.Create(fn);
  PrismController := TPrismController.Create;
  PrismController.ApplySettings;
end;

// Free all service resources

procedure Stop;
begin
  PrismController.Free;
  PrismSettings.Free;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop;

end.

