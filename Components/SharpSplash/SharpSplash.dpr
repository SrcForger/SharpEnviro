program SharpSplash;

uses
//  VCLFixPack,
  Forms,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSplashForm in 'uSplashForm.pas' {SharpSplashWnd},
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  GR32_PNG in '..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';

{$R *.res}
{$R metadata.res}

begin
  Application.Initialize;
  Application.Title := 'SharpSplash';
  Application.CreateForm(TSharpSplashWnd, SharpSplashWnd);
  Application.Run;
end.
