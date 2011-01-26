{
Source Name: SharpScript.dpr
Description: SharpE Script Utility
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

program SharpScript;

{$R 'metadata.res'}
{$R 'VersionInfo.res'}
{$R *.res}

uses
  ShareMem,
  Forms,
  SysUtils,
  JvInterpreter,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  MainWnd in 'Forms\MainWnd.pas' {SharpScriptMainWnd},
  CreateInstallScriptWnd in 'Forms\CreateInstallScriptWnd.pas' {CreateInstallScriptForm},
  InstallWnd in 'Forms\InstallWnd.pas' {InstallForm},
  SharpApi_Adapter in '..\..\Common\Libraries\SharpAPI\SharpApi_Adapter.pas',
  SharpFileUtils_Adapter in '..\..\Common\Units\SharpScript\SharpFileUtils_Adapter.pas',
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpCenterAPI in '..\..\Common\Libraries\SharpCenterAPI\SharpCenterAPI.pas',
  SharpBase_Adapter in '..\..\Common\Units\SharpScript\SharpBase_Adapter.pas',
  CreateGenericScriptWnd in 'Forms\CreateGenericScriptWnd.pas' {SharpECreateGenericScriptForm},
  ScriptControls in 'ScriptControls.pas',
  LogWnd in 'Forms\LogWnd.pas' {LogForm},
  Windows_Adapter in '..\..\Common\Units\SharpScript\Windows_Adapter.pas';

var
  Prm : String;
  Ext : String;
  //installscript : TSharpEInstallerScript;
  genericscript : TSharpEGenericScript;
  //newgeneric : boolean;

begin
  SharpBase_Adapter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  SharpApi_Adapter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  SharpFileUtils_Adapter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  Windows_Adapter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);


  //newgeneric := False;
  if ParamCount > 0 then
  begin
    Prm := ParamStr(1);
    SharpApi.SendDebugMessageEx('SharpScript',PChar('Param:'+ParamStr(1)),0,DMT_INFO);
    if CompareText(Prm,'-newgenericscript') = 0 then
    begin
      //newgeneric := True;
    end else
    if FileExists(Prm) then
    begin
      Ext := ExtractFileExt(Prm);
      {if Ext = '.sip' then
      begin
        installscript := TSharpEInstallerScript.Create;
        try
          installscript.DoInstall(Prm);
        finally
          installscript.Free;
          Halt;
        end;
      end else }
      if Ext = '.sescript' then
      begin
        genericscript := TSharpEGenericScript.Create;
        try
          genericscript.ExecuteScript(Prm);
        finally
          genericscript.Free;
          Halt;
        end;
      end;
    end;
  end;

  Application.Initialize;
  Application.CreateForm(TSharpECreateGenericScriptForm, SharpECreateGenericScriptForm);
  //if newgeneric then
  //   CreateGenericScriptForm.show;
  Application.Run;
end.
