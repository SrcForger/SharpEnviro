program SharpCenterSchemeTest;

uses
  Forms,
  uMain in 'uMain.pas' {Form2},
  SharpCenterScheme in 'SharpCenterScheme.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
