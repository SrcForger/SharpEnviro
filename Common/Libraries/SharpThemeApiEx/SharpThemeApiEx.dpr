{
Source Name: SharpThemeApiEx.dpr
Description: Library file for SharpThemeApiEx.dll
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

library SharpThemeApiEx;

uses
  Windows,
  uThemeInfo in 'uThemeInfo.pas',
  uThemeConsts in 'uThemeConsts.pas',
  uThemeSkin in 'uThemeSkin.pas',
  uThemeScheme in 'uThemeScheme.pas',
  uIThemeInfo in 'uIThemeInfo.pas',
  uISharpETheme in 'uISharpETheme.pas',
  uIThemeSkin in 'uIThemeSkin.pas',
  uIThemeScheme in 'uIThemeScheme.pas',
  uThemeDesktop in 'uThemeDesktop.pas',
  uIThemeDesktop in 'uIThemeDesktop.pas',
  uIThemeIcons in 'uIThemeIcons.pas',
  uThemeIcons in 'uThemeIcons.pas',
  uThemeWallpaper in 'uThemeWallpaper.pas',
  uIThemeWallpaper in 'uIThemeWallpaper.pas',
  uSharpETheme in 'uSharpETheme.pas';

{$R *.res}

var
  Theme : ISharpETheme;

function GetCurrentTheme : ISharpETheme;
var
  temp : TSharpETheme;
begin
  if Theme = nil then
  begin
    temp := TSharpETheme.Create;
    Theme := temp
  end;
  result := Theme;
end;

procedure EntryPointProc(Reason: Integer);
begin
  case reason of
    DLL_PROCESS_ATTACH: begin
    end;

    DLL_PROCESS_DETACH: begin
      if Theme <> nil then
        Theme := nil;
    end;
  end;
end;

exports
  GetCurrentTheme;

begin
  DllProc := @EntryPointProc;
  EntryPointProc(DLL_PROCESS_ATTACH);
end.

