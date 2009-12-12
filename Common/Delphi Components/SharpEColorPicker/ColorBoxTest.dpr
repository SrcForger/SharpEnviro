program ColorBoxTest;

uses
  Forms,
  uColorBoxTest in 'uColorBoxTest.pas' {Form1},
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas',
  SharpEColorPicker in 'SharpEColorPicker.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\Units\SharpFX\SharpFX.pas',
  SharpAPIEx in '..\..\Libraries\SharpApiEx\SharpAPIEx.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
