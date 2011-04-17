program StartupTest;

uses
  ShareMem,
  Forms,
  uStartupTest in 'uStartupTest.pas' {Form1},
  uStartup in 'uStartup.pas',
  FileUtils in '..\Exec\FileUtils.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas',
  MonitorList in '..\..\..\Common\Units\MonitorList\MonitorList.pas',
  SharpTypes in '..\..\..\Common\Units\SharpTypes\SharpTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

