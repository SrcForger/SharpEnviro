{
Source Name: SetShell.dpr
Description: Application for changing the default shell
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

program SetShell;

uses
  Forms,
  MainWnd in 'Forms\MainWnd.pas' {MainForm},
  uShellSwitcher in 'Units\uShellSwitcher.pas',
  uSharpCoreShutdown in '..\SharpCore\uSharpCoreShutdown.pas',
  VistaTheme in 'VistaTheme.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SharpE Shell Switcher';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
