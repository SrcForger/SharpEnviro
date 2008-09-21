program SharpECenterHeaderDemo;

uses
  Forms,
  demo in 'demo.pas' {Form1},
  SharpECenterHeader in 'SharpECenterHeader.pas',
  SharpERoundPanel in '..\SharpERoundPanel\SharpERoundPanel.pas',
  graphicsFX in '..\..\Units\SharpFX\graphicsFX.pas',
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
