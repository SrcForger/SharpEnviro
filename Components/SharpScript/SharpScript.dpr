program SharpScript;

uses
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

{$R *.res}
{$R metadata.res}

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
