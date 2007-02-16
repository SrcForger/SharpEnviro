program SharpDesk2;

uses
  Forms,
  MainForm in 'Forms\MainForm.pas' {SharpDeskMainWnd},
  uSharpEDesktop in 'Units\uSharpEDesktop.pas',
  uSharpEDesktopItem in 'Units\uSharpEDesktopItem.pas',
  uExecServiceExtractShortcut in '..\..\Plugins\Services\Exec\uExecServiceExtractShortcut.pas',
  uSharpEDesktopManager in 'Units\uSharpEDesktopManager.pas',
  uSharpEDesktopRenderer in 'Units\uSharpEDesktopRenderer.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TSharpDeskMainWnd, SharpDeskMainWnd);
  Application.Run;
end.
