{
Source Name: SharpSkin.dpr
Description: SharpSkin Project File
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

program SharpSkin;

uses
  Forms,
  MainForm in 'MainForm.pas' {Form1},
  Defaults in 'Defaults.pas',
  BarForm in 'BarForm.pas' {BarWnd},
  AboutWnd in 'AboutWnd.pas' {AboutForm},
  QuickHelpWnd in 'QuickHelpWnd.pas' {QuickHelpForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SharpSkin';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TQuickHelpForm, QuickHelpForm);
  //Application.CreateForm(TBarWnd, BarWnd);
  Application.Run;
end.
