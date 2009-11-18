program SharpSplash;

uses
  Forms,
  uSplashForm in 'uSplashForm.pas' {SplashForm},
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  GR32_PNG in '..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';

{$R *.res}
{$R metadata.res}

begin
  Application.Initialize;
  Application.Title := 'SharpSplash';
  Application.CreateForm(TSplashForm, SplashForm);
  Application.Run;
end.
