program SharpERoundPanelTest;

uses
  Forms,
  uMain in 'uMain.pas' {Form2},
  SharpERoundPanel in 'SharpERoundPanel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
