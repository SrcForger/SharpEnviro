program SharpEListBoxTest;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  SharpEListBoxEx in 'SharpEListBoxEx.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
