{
Source Name: Weather Service
Description: Weather Service for SharpE
Copyright (C) Pixol (pixol@sharpe-shell.org)

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

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

