{
Source Name: SetShell.dpr
Description: Application for changing the default shell
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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

program SetShell;

uses
  Forms,
  SharpApi,
  MainWnd in 'Forms\MainWnd.pas' {MainForm},
  uShellSwitcher in 'Units\uShellSwitcher.pas',
  VistaTheme in 'VistaTheme.pas',
  uShutdown in '..\..\Common\Units\Shutdown\uShutdown.pas';

{$R *.res}

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'SetShell';
    Description := 'Assists in setting the windows shell';
    Author := 'Martin Kr�mer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteComponent;
    ExtraData := 'priority: 0| delay: 0';
  end;
end;

exports
  GetMetaData;

begin
  Application.Initialize;
  Application.Title := 'SharpE Shell Switcher';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
