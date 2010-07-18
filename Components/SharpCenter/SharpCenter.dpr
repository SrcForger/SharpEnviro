{
Source Name: SharpCenter.dpr
Description: SharpE Center Configuration Tool
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

program SharpCenter;

{$R 'metadata.res'}
{$R 'VersionInfo.res'}
{$R *.res}

uses
//  VCLFixPack,
  Forms,
  Windows,
  SharpApi,
  SharpCenterApi,
  SharpThemeApiEx,
  JvValidators,
  uThemeConsts,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSharpCenterMainWnd in 'uSharpCenterMainWnd.pas' {SharpCenterWnd},
  uSharpCenterDllMethods in 'uSharpCenterDllMethods.pas',
  uSharpCenterHelperMethods in 'uSharpCenterHelperMethods.pas',
  uSharpCenterHistoryList in 'uSharpCenterHistoryList.pas',
  uSharpCenterFavManager in 'uSharpCenterFavManager.pas',
  uSharpCenterManager in 'uSharpCenterManager.pas',
  uSharpCenterThemeManager in 'uSharpCenterThemeManager.pas',
  ISharpCenterPluginUnit in '..\..\Common\Interfaces\ISharpCenterPluginUnit.pas',
  uSharpCenterPluginManager in 'uSharpCenterPluginManager.pas',
  uSharpCenterHost in 'uSharpCenterHost.pas',
  ISharpCenterHostUnit in '..\..\Common\Interfaces\ISharpCenterHostUnit.pas',
  IXmlBaseUnit in '..\..\Common\Interfaces\IXmlBaseUnit.pas';

function CheckMutex: Boolean;
var
  MutexHandle:THandle;
begin
  Result := False;
  MutexHandle := CreateMutex(nil, TRUE, Pchar('SharpCenterMutexX'));
  if MutexHandle <> 0 then begin
    if GetLastError = ERROR_ALREADY_EXISTS then begin
      CloseHandle(MutexHandle);
      Result := True;
      Exit;
    end;
  end;
end;

var
  CenterWnd : HWND;

  enumCommandType: TSCC_COMMAND_ENUM;
  sPluginID: string;
  sCmd: string;
begin
  Application.Initialize;
  {$IFDEF VER185} Application.MainFormOnTaskBar := True; {$ENDIF}

  GetCurrentTheme.LoadTheme(ALL_THEME_PARTS); // Initialize Theme Api

  if CheckMutex then
  begin
    if SharpCenterWnd.GetCommandLineParams(enumCommandType, sCmd, sPluginID) then
      SharpCenterApi.CenterCommand(enumCommandType, PAnsiChar(sCmd), PAnsiChar(sPluginID));

    CenterWnd := FindWindow('TSharpCenterWnd', 'SharpCenter');
    SetForegroundWindow(CenterWnd);
    Application.Terminate;
  end else
  begin
    Application.CreateForm(TSharpCenterWnd, SharpCenterWnd);
    SharpCenterWnd.Icon := Application.Icon;
    Application.Run;
  end;
 end.
