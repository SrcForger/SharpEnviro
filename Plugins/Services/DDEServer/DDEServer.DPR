{
Source Name: DDServer.dpr
Description: DDEServer Service
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

library DDEServer;

uses
  windows,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  SharpApi;

type
  TShellDDEInit = procedure (init: Boolean); stdcall;

const
  ShellDDEInit : TShellDDEInit = nil;

var
  dllHandle : THandle;

{$R *.RES}

function Start(owner: hwnd): hwnd;
begin                         
  dllHandle := LoadLibrary('Shell32.dll');
  if dllHandle <> 0 then
  begin
    SharpApi.SendDebugMessageEx('DDEServer','Loading Shell32.dll - success',0,DMT_INFO);
    @ShellDDEInit := GetProcAddress(dllHandle,PChar(188));
    if Assigned(ShellDDEInit) then
    begin
      ShellDDEInit(True);
      SharpApi.SendDebugMessageEx('DDEServer','Getting address and executing ShellDDEInit - success',0,DMT_INFO);
    end else SharpApi.SendDebugMessageEx('DDEService','Getting address and executing ShellDDEInit - failed',0,DMT_ERROR);
  end else SharpApi.SendDebugMessageEx('DDEService','Loading Shell32.dll - failed',0,DMT_ERROR);
  result := 0;
  ServiceDone('DDEServer');
end;

procedure Stop;
begin
  if dllhandle <> 0 then
  begin
    if Assigned(ShellDDEInit) then
      ShellDDEInit(False);
    @ShellDDEInit := nil;
    FreeLibrary(dllHandle);
    dllHandle := 0;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'DDEServer';
    Description := 'Loads System DDE Server';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteService;
    ExtraData := 'priority: 19| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  GetMetaData;

begin
end.


