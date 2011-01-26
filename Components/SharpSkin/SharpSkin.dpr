program SharpSkin;

uses
  ShareMem,
  Forms,
  MainWnd in 'MainWnd.pas' {MainForm};

{$R 'VersionInfo.res'}
{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SharpEnviro Skin Validator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
