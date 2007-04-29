program SharpEColorPanelExTest;

uses
  Forms,
  uSharpEColorPanelExTest in 'uSharpEColorPanelExTest.pas' {Form1},
  SharpEColorEditorEx in 'SharpEColorEditorEx.pas',
  SharpESwatchManager in '..\SharpESwatchManager\SharpESwatchManager.pas',
  uSharpEColorEditorManualTest in 'uSharpEColorEditorManualTest.pas' {Form2};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
