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
  Windows, ShellApi, SysUtils;

function IsSeperateExplorerFixApplied : boolean;
function ApplySeperateExplorerFix : boolean;
function SetNewShell(path : PChar) : boolean;
function IsWow64(): boolean;

const
  cSeperateExplorerKey = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer';
  cWinLogonKey = 'Software\Microsoft\Windows NT\CurrentVersion\winlogon';
  cIniFileMap = 'Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\system.ini\boot';
  cUserWinLogon = 'USR:Software\Microsoft\Windows NT\CurrentVersion\Winlogon';

implementation

function IsWow64(): boolean;
type
  TIsWow64Process = function(Handle: THandle; var Res: boolean): boolean; stdcall;
var
  IsWow64Result: boolean;
  IsWow64Process: TIsWow64Process;
begin
  result := False;
  IsWow64Process := GetProcAddress(GetModuleHandle('kernel32'), 'IsWow64Process');
  if Assigned(IsWow64Process) then
    if IsWow64Process(GetCurrentProcess, IsWow64Result) then
      result := IsWow64Result;
end;

function ApplySeperateExplorerFix : boolean;
const
  intEnable: Dword = 1;
var
  hndReg: HKey;
begin
  result := False;

  if RegOpenKeyEx(HKEY_CURRENT_USER, cSeperateExplorerKey, 0, KEY_ALL_ACCESS, hndReg) = ERROR_SUCCESS then
  begin
    if RegSetValueEx(hndReg, 'DesktopProcess', 0, REG_DWORD, @intEnable, SizeOf(DWord)) = ERROR_SUCCESS then
      result := True;
    RegCloseKey(hndReg);
  end;
end;

function IsSeperateExplorerFixApplied : boolean;
var
  hndReg: HKey;
  regVal: PByte;
  regValSize: DWord;
  regValType: DWord;
begin
  result := False;
  regValType := REG_DWORD;

  if RegOpenKeyEx(HKEY_CURRENT_USER, cSeperateExplorerKey, 0, KEY_READ, hndReg) = ERROR_SUCCESS then
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
  //regVal: PChar;
  //regValSize: DWord;
  //regValType: DWord;
  //regMask: DWord;
begin
  result := False;
  //regValType := REG_SZ;
  
  if RegOpenKeyEx(HKEY_CURRENT_USER, cWinLogonKey, 0, KEY_ALL_ACCESS, hndReg) = ERROR_SUCCESS then
  begin
    if RegSetValueEx(hndReg, 'Shell', 0, REG_SZ, path, Length(path) + 1) = ERROR_SUCCESS then
      result := True;
    RegCloseKey(hndReg);
  end;

  ShellExecute(0,'open','SharpAdmin.exe','-IniFileMapping','',SW_SHOWNORMAL);
{  regMask := 0;
  if IsWow64 then regMask := KEY_WOW64_64KEY;

  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, cIniFileMap, 0, KEY_ALL_ACCESS or regMask, hndReg) = ERROR_SUCCESS then
    if RegQueryValueEx(hndReg, 'Shell', nil, @regValType, nil, @regValSize) = ERROR_SUCCESS then
    begin
      GetMem(regVal, regValSize);
      if RegQueryValueEx(hndReg, 'Shell', nil, nil, PByte(regVal), @regValSize) = ERROR_SUCCESS then
        if CompareText(cUserWinLogon,regVal) <> 0 then
        begin
          if RegSetValueEx(hndReg, 'Shell', 0, REG_SZ, PChar(cUserWinLogon), Length(cUserWinLogon) + 1) = ERROR_SUCCESS then
            result := True;
          RegCloseKey(hndReg);
        end;
    end;    }
end;

end.
