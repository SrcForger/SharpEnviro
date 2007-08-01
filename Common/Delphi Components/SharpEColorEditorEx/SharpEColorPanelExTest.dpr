program SharpEColorPanelExTest;

uses
  Forms,
  uSharpEColorPanelExTest in 'uSharpEColorPanelExTest.pas' {Form1},
  SharpEColorEditorEx in 'SharpEColorEditorEx.pas',
  SharpESwatchManager in '..\SharpESwatchManager\SharpESwatchManager.pas',
  uSharpEColorEditorManualTest in 'uSharpEColorEditorManualTest.pas' {Form2},
  SharpEColorEditor in '..\SharpEColorEditor\SharpEColorEditor.pas',
  graphicsFX in '..\..\Units\SharpFX\graphicsFX.pas',
  SharpEColorPicker in '..\SharpEColorPicker\SharpEColorPicker.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\Units\SharpFX\SharpFX.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas',
  uSchemeList in '..\..\..\Plugins\Configurations\Scheme\uSchemeList.pas',
  SharpECenterScheme in '..\SharpECenterScheme\SharpECenterScheme.pas',
  SharpESwatchCollection in '..\SharpESwatchCollection\SharpESwatchCollection.pas',
  SharpGraphicsUtils in '..\..\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpETabList in '..\SharpETabList\SharpETabList.pas',
  SharpERoundPanel in '..\SharpERoundPanel\SharpERoundPanel.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
