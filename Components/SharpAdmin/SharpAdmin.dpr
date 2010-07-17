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

{$R 'SharpAdmin.res' 'SharpAdmin.rc'}
{$R 'VersionInfo.res' 'VersionInfo.rc'}
{$R 'VistaElevated.res' 'VistaElevated.rc'}

uses
//  VCLFixPack,
  Windows,
  SysUtils,
  Classes,
  JclStrings,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSystemFuncs;

const
  cIniFileMap = 'Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\system.ini\boot';
  cUserWinLogon = 'USR:Software\Microsoft\Windows NT\CurrentVersion\Winlogon';

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

function DeleteKeyValue(cmd: string): boolean;
var
    Handle  : HKEY;
    regMask: DWord;
    x64: boolean;
    hk: cardinal;
    value, key, hks: string;
    tokens, list: TStringList;
    params: string;
    i: Integer;
begin
  Result := false;

  cmd := StrAfter('-DeleteKeyValue',cmd);

  list := TStringList.Create;
  tokens := TStringList.Create;
  try

    // Get keys to delete
    StrTokenToStrings(cmd,'^',list);

    for i := 0 to pred(list.count) do begin

      hks := '';
      key := '';
      value := '';

      // Get tokens for delete list
      params := list[i];
      StrTokenToStrings(params,',',tokens);

      // Check for exact parameter count
      if tokens.count = 4 then begin
        hks := tokens[0];
        key := tokens[1];
        value := tokens[2];
        x64 := StrToBool(tokens[3]);

        if trim(hks) = 'HKCU' then begin
          hk := HKEY_CURRENT_USER;
        end
        else begin
          hk := HKEY_LOCAL_MACHINE;
        end; 

        // 64 bit gubbins
        regMask := 0;
        if x64 then regMask := KEY_WOW64_64KEY;

        // Most important open in read only mode, and 64 bit access if needed
        if RegOpenKeyEx(hk, PChar(key), 0, KEY_SET_VALUE or regMask, Handle) <> ERROR_SUCCESS then
          exit;

        if RegDeleteValue(Handle, pchar(value) ) = ERROR_SUCCESS then
          result := true;

        RegCloseKey(Handle);
      end;

    end;

  finally
    list.Free;
    tokens.Free;
  end;
end;

var
  n : integer;
  par,cmd : String;
begin
  if ParamCount = 0 then
  begin
    Writeln('SharpE Administrator Utilities');
    Writeln('Tool application to execute tasks which require administrator access');
    Writeln('');
    Writeln('Commands:');
    Writeln('-IniFileMapping   set HKLM shell boot path to current users winlogon key ');
    WriteLn('-DeleteKeyValue   delete a key value in the registry, params = hkey:string,' +
      'key:string, keyvalue:string, x64:bool ( seperate with ^ for multiple commands ');
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
    end else if CompareText(par,'DeleteKeyValue') = 0 then
    begin
      {$WARNINGS OFF}
      if DeleteKeyValue(CmdLine) then
        Writeln('Deleting RunOnce Key... Success')
      else Writeln('Deleting RunOnce Key... Failed');
      {$WARNINGS ON}
    end;
  end;
end.
