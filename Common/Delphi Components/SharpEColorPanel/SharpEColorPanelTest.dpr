program SharpEColorPanelTest;

uses
  Forms,
  uMain in 'uMain.pas' {MainWnd},
  SharpEColorPanel in 'SharpEColorPanel.pas',
  SharpERoundPanel in '..\SharpERoundPanel\SharpERoundPanel.pas',
  uSharpETabList in '..\SharpETabList\uSharpETabList.pas',
  uSharpeColorBox in '..\SharpEColorBox\uSharpeColorBox.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpGraphicsUtils in '..\..\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpCenterScheme in '..\SharpECenterScheme\SharpCenterScheme.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainWnd, MainWnd);
  Application.Run;
end.
