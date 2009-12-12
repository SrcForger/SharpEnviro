program SharpEColorPanelTest;



uses
  Forms,
  uMain in 'uMain.pas' {MainWnd},
  SharpERoundPanel in '..\SharpERoundPanel\SharpERoundPanel.pas',
  SharpGraphicsUtils in '..\..\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpEColorPicker in '..\SharpEColorPicker\SharpEColorPicker.pas',
  SharpEColorEditor in 'SharpEColorEditor.pas',
  SharpESwatchCollection in '..\SharpESwatchCollection\SharpESwatchCollection.pas',
  graphicsFX in '..\..\Units\SharpFX\graphicsFX.pas',
  SharpFX in '..\..\Units\SharpFX\SharpFX.pas',
  SharpESwatchManager in '..\SharpESwatchManager\SharpESwatchManager.pas',
  SharpETabList in '..\SharpETabList\SharpETabList.pas',
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas',
  SharpEPageControl in '..\SharpEPageControl\SharpEPageControl.pas',
  SharpThemeApiEx, uThemeConsts;

{$R *.res}

begin
  Application.Initialize;

  GetCurrentTheme.LoadTheme;
  Application.CreateForm(TMainWnd, MainWnd);
  Application.Run;
end.
