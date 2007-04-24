program SharpESwatchManagerTest;

uses
  Forms,
  uSwatchManagerTest in 'uSwatchManagerTest.pas' {Form3},
  SharpESwatchManager in 'SharpESwatchManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
