program SharpEPageControlTest;

uses
  Forms,
  uSharpeEPageControlTest in 'uSharpeEPageControlTest.pas' {Form4},
  SharpEPageControl in 'SharpEPageControl.pas',
  SharpETabList in '..\SharpETabList\SharpETabList.pas',
  SharpERoundPanel in '..\SharpERoundPanel\SharpERoundPanel.pas',
  graphicsFX in '..\..\Units\SharpFX\graphicsFX.pas',
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
