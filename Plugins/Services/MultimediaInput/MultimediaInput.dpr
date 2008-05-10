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
  SharpThemeApi,
  Registry,
  MMSystem,
  Math,
  SharpTypes,
  SharpESkinManager,
  SharpNotify in '..\..\..\Common\Units\SharpNotify\SharpNotify.pas',
  SoundControls in '..\..\Modules\VolumeControl\SoundControls.pas',
  MediaPlayerList in '..\..\Modules\MediaController\MediaPlayerList.pas';

type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var msg: TMessage);
  end;

var
  AE:TActionEvent;
  h:THandle;
  SkinManager : TSharpESkinManager;
  sShowOSD : boolean;
  MPlayers : TMediaPlayerList;

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

function GetWndClass(wnd : hwnd) : String;
var
  buf: array [0..254] of Char;
begin
  GetClassName(wnd, buf, SizeOf(buf));
  result := buf;
end;

  function GetCaption(wnd : hwnd) : string;
  var
    buf:Array[0..1024] of char;
  begin
    GetWindowText(wnd,@buf,sizeof(buf));
    result := buf;
  end;

procedure BroadCastMediaAppCommand(pType : integer);
var
  wnd : hwnd;
  wndclass : String;
  mitem : TMediaPlayerItem;
  param : word;
begin
  wnd := GetTopWindow(0);
  while (wnd <> 0) do
  begin
    if ((GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) or
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_APPWINDOW <> 0)) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0)) then
      begin
        wndclass := GetWndClass(wnd);
        mitem := MPlayers.GetItem(wndclass,'');
        if mitem <> nil then
        begin
          case pType of
            APPCOMMAND_MEDIA_PLAY,APPCOMMAND_MEDIA_PLAY_PAUSE  : param := mitem.btnPlay;
            APPCOMMAND_MEDIA_PAUSE : param := mitem.btnPause;
            APPCOMMAND_MEDIA_STOP  : param := mitem.btnStop;
            APPCOMMAND_MEDIA_NEXTTRACK  : param := mitem.btnNext;
            APPCOMMAND_MEDIA_PREVIOUSTRACK  : param := mitem.btnPrev;
          else param := 0;
          end;
          if mitem.AppCommand then
            SendMessage(wnd,WM_APPCOMMAND,0,MakeLParam(0,param))
          else SendMessage(wnd,WM_COMMAND,param,0);
          exit;
        end;
      end;
    wnd := GetNextWindow(wnd,GW_HWNDNEXT);
  end;
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

  MPlayers := TMediaPlayerList.Create;

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

  MPlayers.Free;
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
  if not (Win32MajorVersion < 6) then
    exit;

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
  if not (Win32MajorVersion < 6) then
    exit;

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
  if not (Win32MajorVersion < 6) then
    exit;

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
      msg.result := 1;
      case msg.LParamHi of
        APPCOMMAND_BROWSER_HOME: ExecDefaultApp('HTTP');
        APPCOMMAND_LAUNCH_MAIL: ExecDefaultApp('mailto');
        APPCOMMAND_VOLUME_UP: VolumeUp(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
        APPCOMMAND_VOLUME_DOWN: VolumeDown(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
        APPCOMMAND_VOLUME_MUTE: VolumeMute(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
        APPCOMMAND_MICROPHONE_VOLUME_UP: VolumeUp(MIXERLINE_COMPONENTTYPE_SRC_FIRST);
        APPCOMMAND_MICROPHONE_VOLUME_DOWN: VolumeDown(MIXERLINE_COMPONENTTYPE_SRC_FIRST);
        APPCOMMAND_MICROPHONE_VOLUME_MUTE,APPCOMMAND_MIC_ON_OFF_TOGGLE: VolumeMute(MIXERLINE_COMPONENTTYPE_SRC_FIRST);
        APPCOMMAND_MEDIA_NEXTTRACK,APPCOMMAND_MEDIA_PREVIOUSTRACK,
        APPCOMMAND_MEDIA_STOP,APPCOMMAND_MEDIA_PLAY_PAUSE,
        APPCOMMAND_MEDIA_PLAY,APPCOMMAND_MEDIA_PAUSE: BroadCastMediaAppCommand(msg.LParamHi);
        else msg.result := 0;
      end;
    end;
  end
  else if msg.Msg = WM_SHARPEUPDATESETTINGS then
  begin
    if (msg.wparam = Integer(suCursor)) or (msg.wparam = Integer(suScheme))
       or (msg.wparam = Integer(suSkin)) or (msg.wparam = Integer(suTheme)) then
    begin
      SharpThemeApi.LoadTheme(True,[tpSkin,tpScheme]);
      SkinManager.UpdateSkin;
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
  end else msg.Result := DefWindowProc(h,msg.Msg,Msg.WParam,msg.LParam);
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


