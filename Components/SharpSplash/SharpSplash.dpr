program SharpSplash;

uses
  Forms,
  uSplashForm in 'uSplashForm.pas' {SplashForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SharpSplash';
  Application.CreateForm(TSplashForm, SplashForm);
  Application.Run;
end.
