{
Source Name: SharpConsole.dpr
Description: SharpE Debug Console Utility
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

program SharpConsole;

{$R 'metadata.res'}
{$R 'VersionInfo.res'}
{$R *.res}

uses
//  VCLFixPack,
  Forms,
  uVistaFuncs,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  Main in 'Main.pas' {SharpConsoleWnd},
  uDebugging,
  uTDebugging,
  SharpApi,
  TextConverterUnit in 'TextConverterUnit.pas',
  uDebugList in 'uDebugList.pas',
  FatThings in 'FatThings.pas';

begin
  Application.Initialize;
  Application.Title := 'SharpConsole';
  Application.CreateForm(TSharpConsoleWnd, SharpConsoleWnd);
  uVistaFuncs.SetVistaFonts(SharpConsoleWnd);
  Debugging.LogDirectory := SharpApi.GetSharpeUserSettingsPath + 'Logs\';
  Debugging.PrintBanners := True;
  Debugging.Comment := 'SharpCore Logging System';
  Debugging.FileNaming := dfnDaily;

  Application.Run;
end.
