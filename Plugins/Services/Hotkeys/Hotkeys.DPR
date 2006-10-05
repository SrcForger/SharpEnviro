{
Source Name: Hotkeys
Description: Hotkeys Service for SharpE
Copyright (C) Pixol (pixol@sharpe-shell.org)

3rd Party Libraries used: JCL, JVCL, PNGImage
Common: SharpApi, SharpFX

Sourceforge Project Site
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

library Hotkeys;
uses
  Forms,
  windows,
  dialogs,
  graphics,
  sysutils,
  SharpAPI,
  uHotkeyServiceGeneral in 'uHotkeyServiceGeneral.pas',
  uHotkeyServiceMain in 'uHotkeyServiceMain.pas',
  uScHotkeyMgr in '..\..\Common\HotkeyEdit\uScHotkeyMgr.pas',
  VKToString in '..\..\Common\HotkeyEdit\VKToString.pas',
  uHotkeyServiceList in '..\..\Configurations\Hotkeys\uHotkeyServiceList.pas';

{$E service}

procedure Stop;
begin
  HKService.UnregisterAllKeys;
  HKService.Free;

  DeallocateHWnd(h);
end;

//starts the service

function Start(owner: hwnd): hwnd;
begin
  //Application.ShowMainForm := false;
  HKService := THotkeyService.Create;
  h := AllocateHWnd(HKService.MessageHandler);

  // Load the Hotkeys
  HKService.AddHotkeys(True);

  result := owner;

end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop;
begin

end.

