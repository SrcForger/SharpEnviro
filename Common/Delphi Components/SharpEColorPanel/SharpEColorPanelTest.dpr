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
  SharpEColorPanel in 'SharpEColorPanel.pas',
  SharpERoundPanel in '..\SharpERoundPanel\SharpERoundPanel.pas',
  uSharpETabList in '..\SharpETabList\uSharpETabList.pas',
  uSharpeColorBox in '..\SharpEColorBox\uSharpeColorBox.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpGraphicsUtils in '..\..\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpCenterScheme in '..\SharpECenterScheme\SharpCenterScheme.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainWnd, MainWnd);
  Application.Run;
end.
