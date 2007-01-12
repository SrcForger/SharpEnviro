program TabListTest;

uses
  Forms,
  uTabListTest in 'uTabListTest.pas' {Form12},
  uSharpETabList in 'uSharpETabList.pas',
  graphicsFX in 'E:\SVN\Common\Units\SharpFX\graphicsFX.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
