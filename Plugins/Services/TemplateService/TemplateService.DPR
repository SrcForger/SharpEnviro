{
Source Name: SystemTray.dpr
Description: SystemTray service library file
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

{  10:09:37 AM: all a service needs to handle is start, stop, scmsg, displayinfownd and i think reload}

library TemplateService;
uses
  //Forms,
  windows;
  //classes,
  //dialogs,
  //graphics,
  //sysutils,
  //jclstrings,
  //messages,
  //JclSysInfo,
  //shellapi;
  //winver in '..\SystemTray\winver.pas',
  //declaration in '..\SystemTray\declaration.pas',
  //TrayManager in '..\SystemTray\TrayManager.pas' {TrayMessageWnd},
  //SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas';

{$E ser}

{$R *.RES}

//var
  //TrayManager : TTrayManager;

{
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
}

procedure Stop;
begin
//  TerminateShellServices;
//  TrayMessageWnd.Free;
//  TrayMessageWnd := nil;
end;

function Start(owner: hwnd): hwnd;
begin
//  if TrayMessageWnd = nil then TrayMessageWnd := TTrayMessageWnd.Create(nil);
//  TerminateShellServices;
//  sleep(200);
//  StartShellServices;
  Result := owner;
end;

{
procedure DisplayInfoWnd;
begin
  // Set the Form Position
  CompServ.DisplayInfoWnd;
end;
}

{
procedure Reload;
begin
  ItemStorage.Clear;
  ItemStorage.Load();
end;
}

{
function SCMsg(msg: string): integer;
begin
  Result := HInstance;
  if msg = '_forceupdate' then begin
    debug('Force Weather Update', DMT_INFO);
    WeatherMgr.ForceUpdate;
  end;
end;
}

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop;
  //SCMsg
  //Reload
  //DisplayInfoWnd

end.


