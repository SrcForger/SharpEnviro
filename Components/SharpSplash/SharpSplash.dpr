{
Source Name: SharpSplash.dpr
Description: SharpE Splash
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

program SharpSplash;

{$R 'metadata.res'}
{$R 'VersionInfo.res'}
{$R *.res}

uses
  ShareMem,
  Forms,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSplashForm in 'uSplashForm.pas' {SharpSplashWnd},
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  GR32_PNG in '..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';

begin
  Application.Initialize;
  Application.Title := 'SharpSplash';
  Application.CreateForm(TSharpSplashWnd, SharpSplashWnd);
  Application.Run;
end.
