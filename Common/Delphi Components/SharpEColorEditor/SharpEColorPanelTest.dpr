program SharpEColorPanelTest;

{%File 'ModelSupport\SharpEColorPanel\SharpEColorPanel.txvpck'}
{%File 'ModelSupport\SharpAPI\SharpAPI.txvpck'}
{%File 'ModelSupport\uMain\uMain.txvpck'}
{%File 'ModelSupport\SharpGraphicsUtils\SharpGraphicsUtils.txvpck'}
{%File 'ModelSupport\uSharpeColorBox\uSharpeColorBox.txvpck'}
{%File 'ModelSupport\SharpCenterScheme\SharpCenterScheme.txvpck'}
{%File 'ModelSupport\SharpERoundPanel\SharpERoundPanel.txvpck'}
{%File 'ModelSupport\SharpThemeApi\SharpThemeApi.txvpck'}
{%File 'ModelSupport\uSharpETabList\uSharpETabList.txvpck'}
{%File 'ModelSupport\default.txvpck'}

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
  SharpESwatchManager in '..\SharpESwatchManager\SharpESwatchManager.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainWnd, MainWnd);
  Application.Run;
end.
