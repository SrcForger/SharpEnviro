program StartupTest;

uses
  Forms,
  uStartupTest in 'uStartupTest.pas' {Form1},
  uSettingsWnd in 'uSettingsWnd.pas' {FrmSettingsWnd},
  uStartup in 'uStartup.pas',
  uStartupList in 'uStartupList.pas',
  uStartupMgrItem in 'uStartupMgrItem.pas',
  uItemWnd in 'uItemWnd.pas' {frmItemWnd},
  FileUtils in '..\Exec\FileUtils.pas',
  uExecServiceExtractShortcut in '..\Exec\uExecServiceExtractShortcut.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFrmSettingsWnd, FrmSettingsWnd);
  Application.CreateForm(TfrmItemWnd, frmItemWnd);
  Application.Run;
end.

