program SharpDesk2;

uses
  Forms,
  MainForm in 'Forms\MainForm.pas' {SharpDeskMainWnd},
  uSharpEDesktop in 'Units\uSharpEDesktop.pas',
  uSharpEDesktopItem in 'Units\uSharpEDesktopItem.pas',
  uExecServiceExtractShortcut in '..\..\Plugins\Services\Exec\uExecServiceExtractShortcut.pas',
  uSharpEDesktopManager in 'Units\uSharpEDesktopManager.pas',
  uSharpEDesktopRenderer in 'Units\uSharpEDesktopRenderer.pas',
  SharpIconUtils in '..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  uSharpEDesktopLinkRenderer in 'Units\uSharpEDesktopLinkRenderer.pas',
  SharpThemeApi in '..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  GR32_PNG in '..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSharpDeskMainWnd, SharpDeskMainWnd);
  Application.Run;
end.
