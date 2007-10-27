program SharpSplash;

uses
  Forms,
  uSplashForm in 'uSplashForm.pas' {SplashForm},
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  GR32_PNG in '..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas';

{$R *.res}

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'SharpSplash';
    Description := 'Displays a splash screen';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteComponent;
    ExtraData := 'priority: 10| delay: 0';
  end;
end;

exports
  GetMetaData;

begin
  Application.Initialize;
  Application.Title := 'SharpSplash';
  Application.CreateForm(TSplashForm, SplashForm);
  if not SplashForm.TerminateFlag then
    Application.Run;
end.
