{
Source Name: uSharpCoreHelperMethods
Description: a general library of functions
Copyright (C) Lee Green

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
unit uSharpCoreHelperMethods;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  shellapi,
  ComCtrls,
  Registry,

  // SharpE
  sharpapi,

  // Program
  uSharpCoreStrings,

  // JCL
  JclFileUtils;

function ReadRegVal(Key: string; Value: string; DefValue: string; RK: HKEY):
  string;
procedure WriteRegVal(Key, Name, Value: string; RK: HKEY);

function SharpCoreFile: string;
function SharpCoreSettingsFile: string;
function SharpCorePath: string;
function SharpCoreSettingsPath: string;

function ServiceSettingsUserPath(servicefilename: string): string;
function ServiceSettingsGlobalPath(servicefilename: string): string;

function SharpCoreServicePath: string;

procedure DInfo(Text: string);
procedure DError(Text: string);
procedure DStatus(Text: string);
procedure DTrace(Text: string);

implementation

uses
  uSharpCoreMainWnd;

function ReadRegVal(Key, Value, DefValue: string; RK: HKEY): string;
var
  reg: tregistry;
begin
  reg := tregistry.create;
  with Reg do begin
    try

      RootKey := RK;
      OpenKey(key, true);

      if ValueExists(Value) = false then
        WriteString(Value, DefValue);

      result := ReadString(Value);

    finally
      CloseKey;
      Free;
    end;
  end;
end;

procedure WriteRegVal(Key, Name, Value: string; RK: HKEY);
var
  reg: tregistry;
begin
  reg := tregistry.create;
  with Reg do begin
    try

      RootKey := RK;
      OpenKey(key, true);

      WriteString(Name, Value);
    finally
      CloseKey;
      Free;
    end;
  end;
end;

function SharpCoreSettingsFile: string;
const
  SettingsFile = 'SharpCore\conf.xml';
begin
  Result := GetSharpeUserSettingsPath + SettingsFile;
end;

function SharpCoreFile: string;
begin
  Result := ExtractFilePath(Application.ExeName) + 'SharpCore.exe';
end;

function SharpCorePath: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName));
end;

function SharpCoreSettingsPath: string;
const
  SettingsPath = 'SharpCore\';
begin
  Result := GetSharpeUserSettingsPath +
    SettingsPath;
end;

function ServiceSettingsUserPath(servicefilename: string): string;
const
  ServiceConfigFile = 'uscf.xml';
  SettingsPath = 'SharpCore\';
begin
  Result := Format('%sServices\%s\%s',
    [IncludeTrailingPathDelimiter(GetSharpeUserSettingsPath +
      SettingsPath),
    PathRemoveExtension(ExtractFileName(servicefilename)), ServiceConfigFile]);
end;

function ServiceSettingsGlobalPath(servicefilename: string): string;
const
  ServiceConfigFile = 'scf.xml';
  SettingsPath = 'SharpCore\';
begin
  Result := Format('%sServices\%s\%s',
    [IncludeTrailingPathDelimiter(GetSharpeGlobalSettingsPath +
      SettingsPath),
    PathRemoveExtension(ExtractFileName(servicefilename)), ServiceConfigFile]);
end;

function SharpCoreServicePath: string;
const
  ServicePath = 'Services';
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(application.ExeName) +
    ServicePath);
end;

procedure DError(Text: string);
begin
  SendDebugMessageEx(Pchar(rsApplicationName), pchar(Text), clblack, DMT_ERROR);
end;

procedure DInfo(Text: string);
begin
  SendDebugMessageEx(Pchar(rsApplicationName), pchar(Text), clblack, DMT_INFO);
end;

procedure DStatus(Text: string);
begin
  SendDebugMessageEx(Pchar(rsApplicationName), pchar(Text), clblack, DMT_STATUS);
end;

procedure DTrace(Text: string);
begin
  SendDebugMessageEx(PChar(rsApplicationName), pchar(Text), clblack, DMT_TRACE);
end;

end.




