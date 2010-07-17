program SharpSplash;

{$R 'metadata.res' 'metadata.rc'}
{$R 'VersionInfo.res' 'VersionInfo.rc'}
{$R *.res}

uses
//  VCLFixPack,
  Forms,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSplashForm in 'uSplashForm.pas' {SharpSplashWnd},
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  GR32_PNG in '..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';

begin
  Application.Initialize;
  Application.Title := 'SharpSplash';
  Application.CreateForm(TSharpSplashWnd, SharpSplashWnd);
  Application.Run;
end.
