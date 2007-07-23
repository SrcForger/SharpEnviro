program TabListTest;

uses
  Forms,
  uTabListTest in 'uTabListTest.pas' {Form12},
  graphicsFX in '..\..\Units\SharpFX\graphicsFX.pas',
  SharpETabList in 'SharpETabList.pas',
  SharpERoundPanel in '..\SharpERoundPanel\SharpERoundPanel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
