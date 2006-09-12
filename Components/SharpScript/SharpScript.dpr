program SharpScript;

uses
  Forms,
  MainWnd in 'Forms\MainWnd.pas' {MainForm},
  CreateInstallScriptWnd in 'Forms\CreateInstallScriptWnd.pas' {CreateInstallScriptForm},
  LibTar in 'E:\Units\LibTar.pas',
  InstallWnd in 'Forms\InstallWnd.pas' {InstallForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TCreateInstallScriptForm, CreateInstallScriptForm);
  Application.CreateForm(TInstallForm, InstallForm);
  Application.Run;
end.
