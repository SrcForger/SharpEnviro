program StartupTest;

uses
  Forms,
  uStartupTest in 'uStartupTest.pas' {Form1},
  uStartup in 'uStartup.pas',
  FileUtils in '..\Exec\FileUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

