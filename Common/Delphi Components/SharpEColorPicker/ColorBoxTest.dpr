program ColorBoxTest;

uses
  Forms,
  uColorBoxTest in 'uColorBoxTest.pas' {Form1},
  uSchemeList in '..\..\..\Plugins\Configurations\Scheme\uSchemeList.pas',
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas',
  SharpEColorPicker in 'SharpEColorPicker.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\Units\SharpFX\SharpFX.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpECenterScheme in '..\SharpECenterScheme\SharpECenterScheme.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
