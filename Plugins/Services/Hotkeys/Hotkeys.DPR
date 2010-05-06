{
Source Name: Hotkeys
Description: Hotkeys Service for SharpE
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

library Hotkeys;

uses
  Classes,
  Forms,
  windows,
  dialogs,
  graphics,
  sysutils,
  SharpAPI,
  {$IFDEF DEBUG}DebugDialog,{$ENDIF}
  uHotkeyServiceGeneral in 'uHotkeyServiceGeneral.pas',
  uHotkeyServiceMain in 'uHotkeyServiceMain.pas',
  uHotkeyServiceList in '..\..\Configurations\Services\HotkeyList\uHotkeyServiceList.pas';

{$E dll}

procedure Stop;
begin
  HKService.UnregisterAllKeys;
  HKService.Free;

  Classes.DeallocateHWnd(h);
end;

//starts the service

function Start(owner: hwnd): hwnd;
begin
  //Application.ShowMainForm := false;
  HKService := THotkeyService.Create;
  h := Classes.AllocateHWnd(HKService.MessageHandler);

  // Load the Hotkeys
  HKService.AddHotkeys(True);
  ServiceDone('Hotkeys');
  result := owner;

end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Hotkeys';
    Description := 'Manages system-wide hotkeys';
    Author := 'Lee Green (Pixol@sharpe-shell.org)';
    Version := '0.7.6.5';
    DataType := tteService;
    ExtraData := 'priority: 80| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  GetMetaData;
begin

end.

