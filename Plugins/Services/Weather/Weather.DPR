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
  ShareMem,
  windows,
  registry,
  Classes,
  Messages,
  activex,
  sysutils,
  Jclstrings,
  forms,
  SharpApi,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uWeatherList in 'uWeatherList.pas',
  uWeatherOptions in 'uWeatherOptions.pas',
  uWeatherMgr in 'uWeatherMgr.pas';

{$R 'VersionInfo.res'}
{$R *.RES}

type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var msg: TMessage);
  end;


var
  AE: TActionEvent;
  h: THandle;

function Start(owner: hwnd): hwnd;
begin
  Result := HInstance;

  // Weather update manager
  WeatherMgr := TWeatherMgr.Create;

  // Message Handler
  ae := TActionEvent.Create;
  h := Classes.AllocateHWnd(Ae.MessageHandler);

  ServiceDone('Weather');
end;

procedure Stop;
begin
  Classes.DeallocateHWnd(h);
  AE.Free;

  FreeAndNil(WeatherMgr);
end;

function SCMsg(msg: string): integer;
begin
  Result := HInstance;
  if msg = '_forceupdate' then begin
    WeatherMgr.ForceUpdate;
  end;
end;

procedure TActionEvent.MessageHandler(var msg: TMessage);
begin
  if msg.Msg = WM_SHARPEUPDATESETTINGS then
  begin
    if (msg.wparam = Integer(suWeather)) then
    begin
      WeatherMgr.WeatherList.Clear;
      WeatherMgr.WeatherList.LoadSettings;
    end;
  end else msg.Result := DefWindowProc(h,msg.Msg,msg.WParam,msg.LParam);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Weather';
    Description := 'Updates weather information for the bar module';
    Author := 'Lee Green (Pixol@sharpe-shell.org)';
    Version := '0.8.0.0';
    DataType := tteService;
    ExtraData := 'priority: 90| delay: 0';
  end;
end;

exports
  Start,
  SCMsg,
  Stop,
  GetMetaData;

begin

end.

