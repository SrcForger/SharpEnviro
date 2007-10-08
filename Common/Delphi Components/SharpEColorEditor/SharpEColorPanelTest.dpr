program SharpEColorPanelTest;



uses
  Forms,
  uMain in 'uMain.pas' {MainWnd},
  SharpERoundPanel in '..\SharpERoundPanel\SharpERoundPanel.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpGraphicsUtils in '..\..\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpEColorPicker in '..\SharpEColorPicker\SharpEColorPicker.pas',
  SharpEColorEditor in 'SharpEColorEditor.pas',
  SharpESwatchCollection in '..\SharpESwatchCollection\SharpESwatchCollection.pas',
  graphicsFX in '..\..\Units\SharpFX\graphicsFX.pas',
  SharpFX in '..\..\Units\SharpFX\SharpFX.pas',
  uSchemeList in '..\..\..\Plugins\Configurations\Scheme\uSchemeList.pas',
  SharpECenterScheme in '..\SharpECenterScheme\SharpECenterScheme.pas',
  SharpESwatchManager in '..\SharpESwatchManager\SharpESwatchManager.pas',
  SharpETabList in '..\SharpETabList\SharpETabList.pas',
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas',
  SharpEPageControl in '..\SharpEPageControl\SharpEPageControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainWnd, MainWnd);
  Application.Run;
end.
