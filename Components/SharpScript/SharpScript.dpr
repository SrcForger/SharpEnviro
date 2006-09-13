program SharpScript;

uses
  Forms,
  MainWnd in 'Forms\MainWnd.pas' {MainForm},
  CreateInstallScriptWnd in 'Forms\CreateInstallScriptWnd.pas' {CreateInstallScriptForm},
  InstallWnd in 'Forms\InstallWnd.pas' {InstallForm},
  SharpArchiveUtils_Adapter in '..\..\Common\Units\SharpScript\SharpArchiveUtils_Adapter.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCreateInstallScriptForm, CreateInstallScriptForm);
  Application.CreateForm(TInstallForm, InstallForm);
  Application.Run;
end.
