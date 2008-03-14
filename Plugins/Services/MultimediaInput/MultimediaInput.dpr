{
Source Name: MultimediaInput.dpr
Description: Multimedia Keyboard and Mouse support
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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
library MultimediaInput;

uses
  windows,
  SysUtils,
  Messages,
  MultiMon,
  Classes,
  SharpApi,
  Registry,
  MMSystem,
  Math,
  SharpESkin,
  SharpESkinManager,
  SharpNotify in '..\..\..\Common\Units\SharpNotify\SharpNotify.pas',
  SoundControls in '..\..\Modules\VolumeControl\SoundControls.pas';

type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var msg: TMessage);
  end;

var
  AE:TActionEvent;
  h:THandle;
  SkinManager : TSharpESkinManager;
  sShowOSD : boolean;

{$E ser}

{$R *.RES}

procedure ShowOSD(pCaption : String);
var
  x,y : integer;
  mon : HMonitor;
  moninfo : TMonitorInfo;
  p : TPoint;
begin
  if not sShowOSD then
    exit;

  GetCursorPos(p);
  mon := MonitorFromPoint(p, MONITOR_DEFAULTTOPRIMARY);
  moninfo.cbSize := SizeOf(moninfo);
  GetMonitorInfo(mon, @moninfo);
  x := moninfo.rcMonitor.Left + (moninfo.rcMonitor.Right - moninfo.rcMonitor.Left) div 2;
  y := moninfo.rcMonitor.Bottom - 32;

  SharpNotify.CraeteNotifyText(0,nil,x,y,pCaption,neBottomCenter,SkinManager,2000,moninfo.rcMonitor,True);
end;

function GetDefaultApp(pType : String) : String;
var
  Reg : TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.Access := KEY_READ;
  Reg.RootKey := HKEY_CLASSES_ROOT;
  if Reg.OpenKey(pType + '\shell\open\command',False) then
  begin
    result := Reg.ReadString('');
    Reg.CloseKey;
  end else result := '';
  Reg.Free;
end;

procedure ExecDefaultApp(pType : String);
var
  f : String;
begin
  f := GetDefaultApp(pType);
  SharpApi.SharpExecute(f);
end;

procedure RegisterActions;
begin
  RegisterActionEx('!VolumeUp', 'Multimedia', h, 1);
  RegisterActionEx('!VolumeDown', 'Multimedia', h, 2);
  RegisterActionEx('!VolumeMute', 'Multimedia', h, 3);
end;

// Service is started
function Start(owner: hwnd): hwnd;
begin
  SkinManager := TSharpESkinManager.Create(nil,[scBasic]);
  SkinManager.SkinSource := ssSystem;
  SkinManager.SchemeSource := ssSystem;
  SkinManager.Skin.UpdateDynamicProperties(SkinManager.Scheme);

  Result := owner;
  sShowOSD := True;

  ae := TActionEvent.Create;
  h := allocatehwnd(Ae.MessageHandler);

  RegisterActions;
  SharpApi.RegisterShellHookReceiver(h);
  ServiceDone('MultimediaInput');
end;

// Service is stopped
procedure Stop;
begin
  SharpApi.UnRegisterShellHookReceiver(h);
  SkinManager.Free;

  DeallocateHWnd(h);
  AE.Free;

  UnRegisterAction('!VolumeUp');
  UnRegisterAction('!VolumeDown');
  UnRegisterAction('!VolumeMute');
end;

{ TActionEvent }

procedure VolumeUp(mixer : integer);
var
  CurrentVolume : integer;
  OSDString : String;
  n : integer;
  p : single;
  TypeString : String;
begin
  CurrentVolume := 0;
  if Win32MajorVersion < 6 then
  begin
    CurrentVolume := SoundControls.GetMasterVolume(mixer);
    CurrentVolume := Min(65535,CurrentVolume + 65535 div 20);
    SoundControls.SetMasterVolume(CurrentVolume,mixer);
  end;
  p := CurrentVolume / 65535 * 100;
  for n := 0 to 20 do
  begin
    if n <= round(p / 5) then
      OSDString := OSDString + '|'
    else OSDString := OSDString + '.';
  end;
  case mixer of
    MIXERLINE_COMPONENTTYPE_SRC_FIRST: TypeString := 'Microphone'
    else TypeString := 'Volume';
  end;
  ShowOSD(TypeString + ' ' + OSDString + ' ' + inttostr(round(p)) + '%');
end;

procedure VolumeDown(mixer : integer);
var
  CurrentVolume : integer;
  TypeString : String;
  OSDString : String;
  n : integer;
  p : single;
begin
  CurrentVolume := 0;
  if Win32MajorVersion < 6 then
  begin
    CurrentVolume := SoundControls.GetMasterVolume(mixer);
    CurrentVolume := Max(0,CurrentVolume - 65535 div 20);
    SoundControls.SetMasterVolume(CurrentVolume,mixer);
  end;
  p := CurrentVolume / 65535 * 100;
  for n := 0 to 20 do
  begin
    if n <= round(p / 5) then
      OSDString := OSDString + '|'
    else OSDString := OSDString + '.';
  end;
  case mixer of
    MIXERLINE_COMPONENTTYPE_SRC_FIRST: TypeString := 'Microphone'
    else TypeString := 'Volume';
  end;
  ShowOSD(TypeString + ' ' + OSDString + ' ' + inttostr(round(p)) + '%');
end;

procedure VolumeMute(mixer : integer);
var
  Mute : boolean;
  TypeString : String;
begin
  Mute := False;
  if Win32MajorVersion < 6 then
  begin
    Mute := SoundControls.GetMaterMuteStatus(mixer);
    Mute := not Mute;
    SoundControls.MuteMaster(mixer);
  end;
  case mixer of
    MIXERLINE_COMPONENTTYPE_SRC_FIRST: TypeString := 'Microphone'
    else TypeString := 'Volume';
  end;
  if Mute then
    ShowOSD(TypeString + ' Mute')
  else ShowOSD(TypeString + ' Enabled');    
end;

procedure TActionEvent.MessageHandler(var msg: TMessage);
begin
  if msg.MSg = WM_SHELLHOOKWINDOWCREATED then
    RegisterShellHookReceiver(h)
  else if msg.Msg = WM_SHARPSHELLMESSAGE then
  begin
    if msg.WParam = HSHELL_APPCOMMAND then
    begin
      msg.result := 0;
      case msg.LParamHi of
        APPCOMMAND_BROWSER_HOME: ExecDefaultApp('HTTP');
        APPCOMMAND_LAUNCH_MAIL: ExecDefaultApp('mailto');        
        APPCOMMAND_VOLUME_UP: VolumeUp(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
        APPCOMMAND_VOLUME_DOWN: VolumeDown(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
        APPCOMMAND_VOLUME_MUTE: VolumeMute(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
        APPCOMMAND_MICROPHONE_VOLUME_UP: VolumeUp(MIXERLINE_COMPONENTTYPE_SRC_FIRST);
        APPCOMMAND_MICROPHONE_VOLUME_DOWN: VolumeDown(MIXERLINE_COMPONENTTYPE_SRC_FIRST);
        APPCOMMAND_MICROPHONE_VOLUME_MUTE,APPCOMMAND_MIC_ON_OFF_TOGGLE: VolumeMute(MIXERLINE_COMPONENTTYPE_SRC_FIRST);
        else msg.result := 1;
      end;
    end;
  end
  else if msg.Msg = WM_SHARPEUPDATEACTIONS then
    RegisterActions
  else if msg.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    case Msg.LParam of
      1: VolumeUp(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
      2: VolumeDown(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
      3: VolumeMute(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
    end;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'MultimediaInput';
    Description := 'Support for Multimedia Input Devices (Keyboard, Mouse)';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteService;
    ExtraData := 'priority: 45| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  GetMetaData;

begin
end.


