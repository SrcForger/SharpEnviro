program SharpSkin;

uses
  Forms,
  MainWnd in 'MainWnd.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'SharpEnviro Skin Validator';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
