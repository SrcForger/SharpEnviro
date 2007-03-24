program SharpShutdown;

uses
  Forms,
  MainWnd in 'MainWnd.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SharpShutdown';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
