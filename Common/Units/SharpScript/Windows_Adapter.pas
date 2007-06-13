{
Source Name: Windows_Adapter.pas
Description: JvInterpreter Adapater Unit
             Adds window function and const support to any script
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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
unit Windows_Adapter;

interface

uses Windows,
     Messages,
     SysUtils,
     Classes,
     JvInterpreter,
     JclSysInfo;


procedure RegisterWindowLog(pLog : TStrings);
procedure UnregisterWindowLog;
procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);

implementation

uses Variants,
     Types,
     DateUtils;

var
  FLog : TStrings;
  FLogEnabled : boolean;

procedure UnregisterwindowLog;
begin
  FLogEnabled := False;
  FLog := nil;
end;

procedure RegisterWindowLog(pLog : TStrings);
begin
  FLogEnabled := True;
  FLog := pLog;
end;

procedure AddLog(logmsg : String);
begin
  if not FLogEnabled then exit;

  try
    if FLog <> nil then FLog.Add(logmsg);
  except
    FLog := nil;
  end;
end;

procedure Adapter_FindWindow(var Value: Variant; Args: TJvInterpreterArgs);
var
  P1,P2 : String;
begin
  try
    P1 := VarToStr(Args.Values[0]);
    P2 := VarToStr(Args.Values[1]);
    if length(P1) = 0 then
       Value := Windows.FindWindow(nil,PChar(P2))
       else if length(P2) = 0 then
            Value := Windows.FindWindow(PChar(P1),nil)
            else Value := Windows.FindWindow(PChar(P1),PChar(P2));
    AddLog('FindWindow("'+VarToStr(Args.Values[0])+','+VarToStr(Args.Values[1])+'") -> ' + IntToStr(Value));
  except
    AddLog('Failed to call FindWindow("'+VarToStr(Args.Values[0])+'")');
  end;
end;


procedure RegisterJvInterpreterAdapter(JvInterpreterAdapter: TJvInterpreterAdapter);
begin
  with JvInterpreterAdapter do
  begin
    // Directory Consts
    AddConst('Windows','WINDOWS_DIR',GetWindowsFolder);
    AddConst('Windows','WINDOWS_SYSTEM_DIR',GetWindowsSystemFolder);
    AddConst('Windows','WINDOWS_TEMP_DIR',GetWindowsTempFolder);
    AddConst('Windows','DESKTOP_DIR',GetDesktopFolder);
    AddConst('Windows','STARTUP_DIR',GetStartmenuFolder);
    AddConst('Windows','COMMON_STARTUP_DIR',GetCommonStartupFolder);

    // System Info
    AddConst('Windows','USER_NAME',GetLocalUserName);
    AddConst('Windows','COMPUTER_NAME',GetLocalComputerName);
    AddConst('Windows','DOMAIN_NAME',GetDomainName);

    // Messages
    AddConst('Windows','WM_SHOWWINDOW',WM_SHOWWINDOW);
    AddConst('Windows','WM_CLOSE',WM_CLOSE);
    AddConst('Windows','WM_WININICHANGE',WM_WININICHANGE);
    AddConst('Windows','WM_ACTIVATE',WM_ACTIVATE);

    // Window Functions
    AddFunction('Windows','FindWindow',Adapter_FindWindow,2,[varString,varString],varInteger);
  end;
end;

end.
