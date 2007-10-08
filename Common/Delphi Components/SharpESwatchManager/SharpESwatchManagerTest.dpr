program SharpESwatchManagerTest;

uses
  Forms,
  uSwatchManagerTest in 'uSwatchManagerTest.pas' {Form3},
  SharpESwatchManager in 'SharpESwatchManager.pas',
  SharpFX in '..\..\Units\SharpFX\SharpFX.pas',
  SharpGraphicsUtils in '..\..\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpECenterScheme in '..\SharpECenterScheme\SharpECenterScheme.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
