{
Source Name: uShellSwitcher.pas
Description: Tool Unit for changing the default shell
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

unit uShellSwitcher;

interface

uses
  Windows, SysUtils,Registry;

function IsSeperateExplorerFixApplied : boolean;
function ApplySeperateExplorerFix : boolean;
function SetNewShell(path : String) : boolean;

const
  cSeperateExplorerKey = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer';
  cWinLogonKey = 'Software\Microsoft\Windows NT\CurrentVersion\winlogon';
  cIniFileMap = 'Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\system.ini\boot';
  cUserWinLogon = 'USR:Software\Microsoft\Windows NT\CurrentVersion\Winlogon';

implementation

function ApplySeperateExplorerFix : boolean;
var
  Reg : TRegistry;
begin
  result := False;

  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.Access := KEY_ALL_ACCESS;
  try
    Reg.OpenKey(cSeperateExplorerKey,True);
    Reg.WriteInteger('DesktopProcess',1);
    result := True;
    Reg.CloseKey;
  except
  end;
  Reg.Free;
end;

function IsSeperateExplorerFixApplied : boolean;
var
  Reg : TRegistry;
begin
  result := False;

  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_LOCAL_MACHINE;
  Reg.Access := KEY_READ;
  try
    if Reg.OpenKey(cSeperateExplorerKey,False) then
    begin
      result := (Reg.ReadInteger('DesktopProcess') = 1);
      Reg.CloseKey;
    end;
  except
  end;
  Reg.Free;
end;

function SetNewShell(path : String) : boolean;
var
  Reg : TRegistry;
  s : String;
begin
  result := False;

  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.Access := KEY_ALL_ACCESS;
  try
    Reg.OpenKey(cWinLogonKey,True);
    Reg.WriteString('shell',path);
    Reg.CloseKey;
  except
  end;

  Reg.RootKey := HKEY_LOCAL_MACHINE;
  try
    if Reg.OpenKey(cIniFileMap,False) then
    begin
      s := Reg.ReadString('shell');
      if CompareText(cUserWinLogon,s) <> 0 then
         Reg.WriteString('shell',cUserWinLogon); 
    end;
  except
  end;

  Reg.Free;
end;

end.
