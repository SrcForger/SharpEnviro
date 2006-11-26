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
    
  end;
end;

end.
