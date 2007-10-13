{
Source Name: SystemTray.dpr
Description: SystemTray service library file
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

library SystemTray;
uses
  Forms,
  windows,
  classes,
  sysutils,
  shellapi,
  messages,
  JclSysInfo,
  winver in 'winver.pas',
  declaration in 'declaration.pas',
  TrayManager in 'TrayManager.pas' {TrayMessageWnd},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  TrayNotifyWnd in 'TrayNotifyWnd.pas' {TrayNWnd};

{$E ser}

{$R *.RES}

{$WARN SYMBOL_PLATFORM OFF}

//var
  //TrayManager : TTrayManager;

procedure StartShellServices;
var
  Dir : String;
begin
  Dir := IncludeTrailingBackslash(SharpAPI.GetSharpeDirectory);
  ShellExecute(Application.Handle, nil, pChar(Dir + 'SharpShellServices.exe'),nil,nil,SW_SHOWNORMAL);
end;

procedure TerminateShellServices;
var
  PID : DWord;
begin
  PID := GetPidFromProcessName('SharpShellServices.exe');
  TerminateApp(PID,100);
end;

procedure Stop;
begin
  TerminateShellServices;
  TrayMessageWnd.Free;
  TrayMessageWnd := nil;
end;

function Start(owner: hwnd): hwnd;
begin
  if TrayMessageWnd = nil then
  begin
    TrayMessageWnd := TTrayMessageWnd.Create(nil);
    SetParent (TrayNWnd.Handle,TrayMessageWnd.Handle);
  end;
  TerminateShellServices;
  sleep(1000);
  StartShellServices;
  Result := owner;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop;

begin
end.


