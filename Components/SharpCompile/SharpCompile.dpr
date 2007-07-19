{
Source Name: SharpCompile.dpr
Description: SharpCompile
Copyright (C) Martin Kr�mer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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

program SharpCompile;



uses
  VistaTheme in 'VistaTheme.pas',
  Forms,
  MainWnd in 'MainWnd.pas' {MainForm},
  DelphiCompiler in 'DelphiCompiler.pas',
  DebugWnd in 'DebugWnd.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SharpCompile';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
