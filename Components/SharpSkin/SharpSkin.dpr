{
Source Name: SharpSkin.dpr
Description: SharpSkin Project File
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

program SharpSkin;

uses
  Forms,
  MainForm in 'Forms\MainForm.pas' {Form1},
  Defaults in 'Units\Defaults.pas',
  BarForm in 'Forms\BarForm.pas' {BarWnd},
  AboutWnd in 'Forms\AboutWnd.pas' {AboutForm},
  QuickHelpWnd in 'Forms\QuickHelpWnd.pas' {QuickHelpForm},
  SchemeEditWnd in 'Forms\SchemeEditWnd.pas' {SchemeEditForm},
  SharpFX in '..\..\Common\Units\SharpFX\SharpFX.pas',
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  graphicsFX in '..\..\Common\Units\SharpFX\graphicsFX.pas',
  GR32_PNG in '..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';
{$R *.res}
{$R metadata.res}

begin
  Application.Initialize;
  Application.Title := 'SharpSkin';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TQuickHelpForm, QuickHelpForm);
//  Application.CreateForm(TSchemeEditForm, SchemeEditForm);
  //Application.CreateForm(TBarWnd, BarWnd);
  Application.Run;
end.
