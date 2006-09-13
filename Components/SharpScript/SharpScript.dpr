program SharpScript;

uses
  Forms,
  JvInterpreter,
  MainWnd in 'Forms\MainWnd.pas' {MainForm},
  CreateInstallScriptWnd in 'Forms\CreateInstallScriptWnd.pas' {CreateInstallScriptForm},
  InstallWnd in 'Forms\InstallWnd.pas' {InstallForm},
  SharpArchiveUtils_Adapter in '..\..\Common\Units\SharpScript\SharpArchiveUtils_Adapter.pas',
  SharpApi_Adapter in '..\..\Common\Libraries\SharpAPI\SharpApi_Adapter.pas',
  SharpFileUtils_Adapter in '..\..\Common\Units\SharpScript\SharpFileUtils_Adapter.pas',
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpBase_Adapter in '..\..\Common\Units\SharpScript\SharpBase_Adapter.pas',
  CreateGenericScriptWnd in 'Forms\CreateGenericScriptWnd.pas' {CreateGenericScriptForm},
  ScriptControls in 'ScriptControls.pas';

{$R *.res}

begin
  SharpBase_Adapter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  SharpApi_Adapter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  SharpFileUtils_Adapter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);
  SharpArchiveUtils_Adapter.RegisterJvInterpreterAdapter(GlobalJvInterpreterAdapter);

  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCreateInstallScriptForm, CreateInstallScriptForm);
  Application.CreateForm(TCreateGenericScriptForm, CreateGenericScriptForm);
  Application.Run;
end.
