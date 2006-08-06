library Weather;

uses
  windows,
  registry,
  Classes,
  Messages,
  activex,
  sysutils,
  Jclstrings,
  forms,
  SharpApi,
  uWeatherList in 'uWeatherList.pas',
  uWeatherOptions in 'uWeatherOptions.pas',
  uWeatherMgr in 'uWeatherMgr.pas';

{$E ser}

{$R *.RES}

function Start(owner: hwnd): hwnd;
var
  fn: string;
begin
  Result := HInstance;
  force := False;

  // Weather Options
  fn := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatheroptions.xml';
  ForceDirectories(ExtractFilePath(fn));
  Try
    WeatherOptions := TWeatherSettings.Create(fn);
  Except
    Debug('Error Initialising TWeatherOptions',DMT_ERROR);
  End;

  // Weather Manager
  fn := GetSharpeUserSettingsPath + 'SharpCore\Services\Weather\weatherlist.xml';
  ForceDirectories(ExtractFilePath(fn));
  Try
    WeatherList := TWeatherList.Create(fn);
  Except
    Debug('Error Initialising TWeatherStore',DMT_ERROR);
  End;

  // Weather update manager
  Try
    WeatherMgr := TWeatherMgr.Create;
  Except
    Debug('Error Initialising TWeatherMgr',DMT_ERROR);
  End;

  
end;

procedure Stop;
begin
    FreeAndNil(WeatherOptions);
    Freeandnil(WeatherList);
    FreeAndNil(WeatherMgr);
end;

function SCMsg(msg: string): integer;
begin
  Result := HInstance;
  if msg = '_forceupdate' then begin
    debug('Force Weather Update', DMT_INFO);
    WeatherMgr.ForceUpdate;
  end;

end;

exports
  Start,
  SCMsg,
  Stop;

begin

end.

