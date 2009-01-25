program ColorBoxTest;

uses
  Forms,
  SharpThemeApiEx,
  uColorBoxTest in 'uColorBoxTest.pas' {Form1},
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas',
  SharpEColorPicker in 'SharpEColorPicker.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\Units\SharpFX\SharpFX.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpAPIEx in '..\..\Libraries\SharpApiEx\SharpAPIEx.pas';

{$R *.res}

begin
  Application.Initialize;

  GetCurrentTheme.LoadTheme;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
