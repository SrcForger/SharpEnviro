{
Source Name: uShellSwitcher.pas
Description: Tool Unit for changing the default shell
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit uShellSwitcher;

interface

uses
  Windows, ShellApi, SysUtils, uSystemFuncs;

function IsSeparateExplorerFixApplied : boolean;
function IsIniFileMappingFixApplied : Boolean;
function ApplyIniFileMappingFix : Boolean;
function ApplySeparateExplorerFix : boolean;
function RemoveSeparateExplorerFix : Boolean;
function SetNewShell(path : PChar) : boolean;

const
  cSeparateExplorerKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer';
  cWinLogonKey = 'Software\Microsoft\Windows NT\CurrentVersion\winlogon';
  cIniFileMap = 'Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\system.ini\boot';
  cUserWinLogon = 'USR:Software\Microsoft\Windows NT\CurrentVersion\Winlogon';

implementation

function ApplySeparateExplorerFix : boolean;
const
  intEnable: Dword = 1;
var
  hndReg: HKey;
begin
  result := False;

  if RegOpenKeyEx(HKEY_CURRENT_USER, cSeparateExplorerKey, 0, KEY_ALL_ACCESS, hndReg) = ERROR_SUCCESS then
  begin
    if RegSetValueEx(hndReg, 'DesktopProcess', 0, REG_DWORD, @intEnable, SizeOf(DWord)) = ERROR_SUCCESS then
      result := True;
    RegCloseKey(hndReg);
  end;
end;

function RemoveSeparateExplorerFix : boolean;
var
  hndReg : HKEY;
begin
  Result := False;

  if RegOpenKeyEx(HKEY_CURRENT_USER, cSeparateExplorerKey, 0, KEY_WRITE, hndReg) = ERROR_SUCCESS then
  begin
    if RegDeleteValue(hndReg, 'DesktopProcess') = ERROR_SUCCESS then
      Result := True;
    RegCloseKey(hndReg);
  end;
end;

function IsSeparateExplorerFixApplied : boolean;
var
  hndReg: HKey;
  regVal: PByte;
  regValSize: DWord;
  regValType: DWord;
begin
  result := False;
  regValType := REG_DWORD;

  if RegOpenKeyEx(HKEY_CURRENT_USER, cSeparateExplorerKey, 0, KEY_READ, hndReg) = ERROR_SUCCESS then
  begin
    if RegQueryValueEx(hndReg, 'DesktopProcess', nil, @regValType, nil, @regValSize) = ERROR_SUCCESS then
    begin
      GetMem(regVal, regValSize);
      if RegQueryValueEx(hndReg, 'DesktopProcess', nil, nil, @regVal, @regValSize) = ERROR_SUCCESS then
        Result := (Integer(regVal) = 1);
      RegCloseKey(hndReg);
    end;
  end;
end;

function SetNewShell(path : PChar) : boolean;
var
  hndReg: HKey;
begin
  result := False;

  if RegOpenKeyEx(HKEY_CURRENT_USER, cWinLogonKey, 0, KEY_ALL_ACCESS, hndReg) = ERROR_SUCCESS then
  begin
    if RegSetValueEx(hndReg, 'Shell', 0, REG_SZ, path, Length(path) + 1) = ERROR_SUCCESS then
      result := True;
    RegCloseKey(hndReg);
  end;
end;

function IsIniFileMappingFixApplied : Boolean;
var
  hndReg : HKEY;
  regVal: PChar;
  regValSize: DWord;
  regValType: DWord;
  regMask: DWord;
begin
  Result := False;
  regValType := REG_SZ;
  regMask := 0;

  if IsWow64 then
    regMask := KEY_WOW64_64KEY;

  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, cIniFileMap, 0, KEY_READ or regMask, hndReg) = ERROR_SUCCESS then
  begin
    if RegQueryValueEx(hndReg, 'Shell', nil, @regValType, nil, @regValSize) = ERROR_SUCCESS then
    begin
      GetMem(regVal, regValSize);
      if RegQueryValueEx(hndReg, 'Shell', nil, nil, PByte(regVal), @regValSize) = ERROR_SUCCESS then
      begin
        Result := (CompareText(cUserWinLogon, regVal) = 0);
      end;
    end;
    RegCloseKey(hndReg);
  end;
end;

function ApplyIniFileMappingFix : Boolean;
begin
  // ShellExecute returns a value greater than 32 if successful.
  Result := (Integer(ShellExecute(0, 'open', 'SharpAdmin.exe', '-IniFileMapping', '', SW_HIDE)) > 32);
end;

end.
