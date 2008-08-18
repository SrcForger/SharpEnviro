{
Source Name: SharpAdmin.dpr
Description: SharpE Administrator Utilities for Vista compatibility
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

program SharpAdmin;

{$APPTYPE CONSOLE}

uses
  Windows,SysUtils;

{$R VistaElevated.res}

const
  cIniFileMap = 'Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\system.ini\boot';
  cUserWinLogon = 'USR:Software\Microsoft\Windows NT\CurrentVersion\Winlogon';

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

function IniFileMappingFix : boolean;
var
  hndReg: HKey;
  regVal: PChar;
  regValSize: DWord;
  regValType: DWord;
  regMask: DWord;
begin
  result := False;
  regValType := REG_SZ;
  
  regMask := 0;
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
        end else result := True;
    end;
end;

var
  n : integer;
  par : String;
begin
  if ParamCount = 0 then
  begin
    Writeln('SharpE Administrator Utilities');
    Writeln('Tool application to execute tasks which require administrator access');
    Writeln('');
    Writeln('Commands:');
    Writeln('-IniFileMapping   set HKLM shell boot path to current users winlogon key ');
  end;

  for n := 1 to ParamCount do
  begin
    par := ParamStr(n);
    if par[1] = '-' then
      par := copy(par,2,length(par)-1);
    if CompareText(par,'IniFileMapping') = 0 then
    begin
      if IniFileMappingFix then
        Writeln('Applying IniFileMapping fix... Success')
      else Writeln('Applying IniFileMapping fix... Failed');
    end;
  end;
end.
