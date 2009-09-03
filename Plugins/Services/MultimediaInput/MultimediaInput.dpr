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
  SharpThemeApiEx,
  Registry,
  uISharpESkin,
  JclSimpleXML,
  ISharpESkinComponents,
  IXmlBaseUnit,
  MMSystem,
  Math,
  SharpTypes,
  SharpNotify in '..\..\..\Common\Units\SharpNotify\SharpNotify.pas',
  SoundControls in '..\..\Modules\VolumeControl\SoundControls.pas',
  MediaPlayerList in '..\..\Modules\MediaController\MediaPlayerList.pas',
  uVistaFuncs in '..\..\..\Common\Units\VistaFuncs\uVistaFuncs.pas',
  MMDevApi_tlb in '..\..\Modules\VolumeControl\MMDevApi_tlb.pas';

type
  TActionEvent = Class(Tobject)
  Procedure MessageHandler(var msg: TMessage);
  end;

type
  TVerticalPos = (vpTop,vpCenter,vpBottom);
  THorizontalPos = (hpLeft,hpCenter,hpRight);

var
  SkinInterface: ISharpESkinInterface;
  AE:TActionEvent;
  h:THandle;
  SkinManager : ISharpESkinManager;
  sShowOSD : boolean;
  sOSDVertPos : TVerticalPos;
  sOSDHorizPos : THorizontalPos;
  MPlayers : TMediaPlayerList;

{$R *.RES}

procedure ShowOSD(pCaption : String);
var
  x,y : integer;
  mon : HMonitor;
  moninfo : TMonitorInfo;
  p : TPoint;
  edge: TSharpNotifyEdge;
begin
  if not sShowOSD then
    exit;

  GetCursorPos(p);
  mon := MonitorFromPoint(p, MONITOR_DEFAULTTOPRIMARY);
  moninfo.cbSize := SizeOf(moninfo);
  GetMonitorInfo(mon, @moninfo);
  case sOSDVertPos of
    vpTop:    y := moninfo.rcMonitor.Top + 32;
    vpCenter: y := moninfo.rcMonitor.Top + (moninfo.rcmonitor.Bottom - moninfo.rcmonitor.Top ) div 2;
    else y := moninfo.rcMonitor.Bottom - 32;
  end;
  case sOSDHorizPos of
    hpLeft:   x := moninfo.rcMonitor.Left + 32;
    hpCenter: x := moninfo.rcMonitor.Left + (moninfo.rcMonitor.Right - moninfo.rcMonitor.Left) div 2;
    else x := moninfo.rcMonitor.Right - 32;
  end;
  if (sOSDVertPos = vpTop) and (sOSDHorizPos = hpLeft) then
    edge := neTopLeft
  else if (sOSDVertPos = vpTop) and (sOSDHorizPos = hpCenter) then
    edge := neTopCenter
  else if (sOSDVertPos = vpTop) and (sOSDHorizPos = hpRight) then
    edge := neTopRight
  else if (sOSDVertPos = vpCenter) and (sOSDHorizPos = hpLeft) then
    edge := neCenterLeft
  else if (sOSDVertPos = vpCenter) and (sOSDHorizPos = hpCenter) then
    edge := neCenterCenter
  else if (sOSDVertPos = vpCenter) and (sOSDHorizPos = hpRight) then
    edge := neCenterRight
  else if (sOSDVertPos = vpBottom) and (sOSDHorizPos = hpLeft) then
    edge := neBottomLeft
  else if (sOSDVertPos = vpBottom) and (sOSDHorizPos = hpCenter) then
    edge := neBottomCenter
  else edge := neBottomRight;

  SharpNotify.CraeteNotifyText(0,nil,x,y,pCaption,edge,SkinManager,2000,moninfo.rcMonitor,True);
end;

procedure LoadSettings;
var
  XML : TInterfacedXmlBase;
begin
  sShowOSD := True;
  sOSDVertPos := vpBottom;
  sOSDHorizPos := hpCenter;

  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\MultimediaInput\MultimediaInput.xml';
  if XML.Load then
    with XML.XmlRoot.Items do
    begin
      sShowOSD := BoolValue('ShowOSD',True);
      sOSDVertPos := TVerticalPos(IntValue('OSDVertPos',Integer(sOSDVertPos)));
      sOSDHorizPos := THorizontalPos(IntValue('OSDHorizPos',Integer(sOSDHorizPos)));
    end;
  XML.Free;
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
          case mitem.MessageType of
            smtAppCommand: SendMessage(wnd,WM_APPCOMMAND,0,MakeLParam(0,param));
            smtCommand: SendMessage(wnd,WM_COMMAND,param,0);
            smtKey:
            begin
              SendMessage(wnd, WM_KEYDOWN, VkKeyScan(Chr(param)), 0);
              SendMessage(wnd, WM_CHAR, VkKeyScan(Chr(param)), 0);
              SendMessage(wnd, WM_KEYUP, VkKeyScan(Chr(param)), 0);
            end;
          end;
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
function StartEx(owner: hwnd; pSkinInterface : ISharpESkinInterface): hwnd;
begin
  SkinInterface := pSkinInterface;

  SkinManager := SkinInterface.SkinManager;

  Result := owner;
  LoadSettings;

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
  try
    CurrentVolume := SoundControls.GetMasterVolume(mixer);
    CurrentVolume := Min(65535,CurrentVolume + 65535 div 20);
    SoundControls.SetMasterVolume(CurrentVolume,mixer);

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
  except
    // Squash any exception as there may not be an audio device
    // attached or the audio service may be disabled.
  end;
end;

procedure VolumeDown(mixer : integer);
var
  CurrentVolume : integer;
  TypeString : String;
  OSDString : String;
  n : integer;
  p : single;
begin
  try
    CurrentVolume := SoundControls.GetMasterVolume(mixer);
    CurrentVolume := Max(0,CurrentVolume - 65535 div 20);
    SoundControls.SetMasterVolume(CurrentVolume,mixer);

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
  except
    // Squash any exception as there may not be an audio device
    // attached or the audio service may be disabled.
  end;
end;

procedure VolumeMute(mixer : integer);
var
  Mute : boolean;
  TypeString : String;
begin
  try
    Mute := SoundControls.GetMasterMuteStatus(mixer);
    Mute := not Mute;
    SoundControls.MuteMaster(mixer);
    case mixer of
      MIXERLINE_COMPONENTTYPE_SRC_FIRST: TypeString := 'Microphone'
      else TypeString := 'Volume';
    end;
    if Mute then
      ShowOSD(TypeString + ' Mute')
    else ShowOSD(TypeString + ' Enabled');
  except
    // Squash any exception as there may not be an audio device
    // attached or the audio service may be disabled.
  end;
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
  else if msg.Msg = WM_SHARPEUPDATEACTIONS then
    RegisterActions
  else if msg.Msg = WM_SHARPEACTIONMESSAGE then
  begin
    case Msg.LParam of
      1: VolumeUp(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
      2: VolumeDown(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
      3: VolumeMute(MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
    end;
  end
  else if msg.Msg = WM_SHARPEUPDATESETTINGS then
  begin
    if msg.WParam = Integer(suMMInput) then
      LoadSettings;
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
  StartEx,
  Stop,
  GetMetaData;

begin
end.


