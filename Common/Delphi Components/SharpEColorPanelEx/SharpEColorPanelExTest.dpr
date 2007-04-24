program SharpEColorPanelExTest;

uses
  Forms,
  uSharpEColorPanelExTest in 'uSharpEColorPanelExTest.pas' {Form1},
  SharpEColorEditorEx in 'SharpEColorEditorEx.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
