{
Source Name: MainWnd
Description: Alarm Clock module main window
Copyright (C) Mathias Tillman <mathias@sharpenviro.com>

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

unit MainWnd;

interface

uses
  Windows, SysUtils, Classes, Forms, Dialogs, Types, DateUtils, SharpIconUtils,
  uISharpBarModule, ISharpESkinComponents, JclShell, Graphics,
  SharpApi, SharpCenterApi, Menus, SharpEButton, ExtCtrls, SharpEBaseControls, Controls,
  GR32, GR32_PNG, GR32_Image, JclSimpleXML, IXmlBaseUnit, cbAudioPlay, DirectShow,
  ImgList, PngImageList;

type
  TAlarmTime = class
  private
    wParent : TWinControl;

    iSec, iMin, iHou : integer;
    iDay, iMon, iYea: integer;

    IsTemp : boolean;

    Sound: TcbAudioPlay;
    FDeviceIdx : integer;

  public
    constructor Create(par : TWinControl); reintroduce;
    destructor Destroy; reintroduce;

    procedure SetTime(sSec, sMin, sHou, sDay, sMon, sYea : string);

    function Compare(t : TDateTime) : boolean; overload;
    function Compare(alarm : TAlarmTime) : boolean; overload;

    procedure SoundLoad(s : string);
    procedure SoundClose;
    procedure SoundPlay;
    procedure SoundStop;

    property Sec: integer read iSec write iSec;
    property Min: integer read iMin write iMin;
    property Hou: integer read iHou write iHou;

    property Day: integer read iDay write iDay;
    property Mon: integer read iMon write iMon;
    property Yea: integer read iYea write iYea;

  end;

  TSHQUERYRBINFO = packed record
     cbSize : DWord;
     i64Size : Int64;
     i64NumItems : Int64;
  end;

  TAlarmSettings = record
    IsOn, IsAlarming : boolean;
    Timeout, Snooze : integer;

    Sound : string;

    Alarm: TAlarmTime;
  end;

  TMainForm = class(TForm)
    btnAlarm: TSharpEButton;
    alarmUpdTimer: TTimer;
    alarmSnoozeTimer: TTimer;
    alarmTimeoutTimer: TTimer;
    mnuRight: TPopupMenu;
    mnuSnoozeBtn: TMenuItem;
    mnuTurnOffBtn: TMenuItem;
    mnuDisableBtn: TMenuItem;
    N1: TMenuItem;
    mnuConfigBtn: TMenuItem;
    PngImageList1: TPngImageList;

    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure btnAlarmOnClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure alarmOnTimer(Sender: TObject);
    procedure alarmOnSnoozeTimer(Sender: TObject);
    procedure alarmOnTimeoutTimer(Sender: TObject);
    procedure mnuRightSnoozeClick(Sender: TObject);
    procedure mnuRightTurnOffClick(Sender: TObject);
    procedure mnuRightDisableClick(Sender: TObject);
    procedure mnuRightConfigClick(Sender: TObject);
  public
    alarmSettings : TAlarmSettings;

    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure LoadIcons;

    procedure UpdateAlarm;

    procedure Timeout;
    procedure Snooze;
  end;


implementation

uses
  uSharpXMLUtils;

{$R *.dfm}

{TAlarmTime}
constructor TAlarmTime.Create(par : TWinControl);
begin
  wParent := par;
  Sound := nil;
  IsTemp := False;
end;

destructor TAlarmTime.Destroy;
begin
  SoundClose;
  FreeAndNil(Sound);
end;

procedure TAlarmTime.SetTime(sSec, sMin, sHou, sDay, sMon, sYea : string);
begin
  iSec := StrToInt(sSec);
  iMin := StrToInt(sMin);
  iHou := StrToInt(sHou);
  iDay := StrToInt(sDay);
  iMon := StrToInt(sMon);
  iYea := StrToInt(sYea);
end;

function TAlarmTime.Compare(t : TDateTime) : boolean;
var
  tMili, tSec, tMin, tHou: word;
  tDay, tMon, tYea: word;
begin
  DecodeDateTime(t, tYea, tMon, tDay, tHou, tMin, tSec, tMili);

  Result := ((iSec < 0) or (iSec = tSec)) and
            ((iMin < 0) or (iMin = tMin)) and
            ((iHou < 0) or (iHou = tHou)) and
            ((iDay <= 0) or (iDay = tDay)) and
            ((iMon <= 0) or (iMon = tMon)) and
            ((iYea <= 0) or (iYea = tYea));
end;


function TAlarmTime.Compare(alarm : TAlarmTime) : boolean;
begin
  Result := ((iSec < 0) or (iSec = alarm.Sec)) and
            ((iMin < 0) or (iMin = alarm.Min)) and
            ((iHou < 0) or (iHou = alarm.Hou)) and
            ((iDay <= 0) or (iDay = alarm.Day)) and
            ((iMon <= 0) or (iMon = alarm.Mon)) and
            ((iYea <= 0) or (iYea = alarm.Yea));
end;

procedure TAlarmTime.SoundLoad(s : string);
var
  ResSt : TResourceStream;
  TempPath, TempFile : PChar;
begin
  IsTemp := False;

  if (s = '') or (s = 'Default') or (not FileExists(s)) then
  begin
    IsTemp := True;

    ResSt := TResourceStream.Create(hInstance, 'wavdefault', RT_RCDATA);
    
    TempPath := nil;
    TempFile := nil;

    try
      GetMem(TempPath, MAX_PATH);
      GetMem(TempFile, MAX_PATH);
      GetTempPath(MAX_PATH, TempPath);
      GetTempFileName(TempPath, 'alarmclock', 0, TempFile);
      ResSt.SaveToFile(string(TempFile));

      FreeAndNil(Sound);
      Sound := TcbAudioPlay.Create(wParent, TempFile, FDeviceIdx);
      Sound.Loop := True;
    finally
      FreeMem(TempPath);
      FreeMem(TempFile);
      ResSt.free;
    end;
  end else
  begin
    FreeAndNil(Sound);
    Sound := TcbAudioPlay.Create(wParent, s, FDeviceIdx);
    Sound.Loop := True;
  end;
end;

procedure TAlarmTime.SoundClose;
begin
  if Sound = nil then
    exit;

  if IsTemp and FileExists(Sound.FileName) then
    DeleteFile(Sound.FileName);
end;

procedure TAlarmTime.SoundPlay;
begin
  if (Sound = nil) or (Sound.FileName = '') then
    exit;

  Sound.Play;
end;

procedure TAlarmTime.SoundStop;
var
  Pos : LONGLONG;
begin
  if (Sound = nil) or (Sound.FileName = '') then
    exit;

  Sound.Stop;
  Pos := 0;
  Sound.SetCurrentPosition(Pos, AM_SEEKING_AbsolutePositioning);
end;


{TMainForm}

procedure TMainForm.LoadIcons;
var
  TempBmp : TBitmap32;
  size : integer;
  IconName : string;
begin
  TempBmp := TBitmap32.Create;
  try
    TempBmp.Clear(color32(0,0,0,0));
    try
      size := GetNearestIconSize(mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y);

      TempBmp.DrawMode := dmBlend;
      TempBmp.CombineMode := cmMerge;
      TempBmp.SetSize(size, size);

      TempBmp.Clear(color32(0,0,0,0));

      if alarmSettings.IsAlarming then
        IconName := 'icon.alarm.active'
      else if not alarmSettings.IsOn then
        IconName := 'icon.alarm.off'
      else
        IconName := 'icon.alarm.on';

      IconStringToIcon(IconName, '', TempBmp, size);
      btnAlarm.Glyph32.Assign(tempBmp);
    except
    end;

    btnAlarm.UpdateSkin;

  finally
    TempBmp.Free;
  end;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  n : integer;
begin
  alarmSettings.IsAlarming := False;
  alarmSettings.Timeout := 60 * 1000;
  alarmSettings.Snooze := 60 * 90 * 1000;
  alarmSettings.Alarm.SetTime('0', '0', '0', '0', '0', '0');
  alarmSettings.Sound := 'Default';

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with XML.Root.Items do
    begin
      for n := 0 to Count - 1 do
      with XML.Root.Items.Item[n].Items do
      begin
        if XML.Root.Items.Item[n].Name = 'Settings' then
        begin
          // In seconds
          alarmSettings.Timeout := IntValue('Timeout', 60) * 1000;
          alarmSettings.Snooze := IntValue('Snooze', 60*9) * 1000;
        end else if XML.Root.Items.Item[n].Name = 'Time' then
        begin
          alarmSettings.IsAlarming := False;
          alarmSettings.IsOn := (alarmSettings.IsOn) or (BoolValue('AutoStart', False));

          alarmSettings.Alarm.SetTime(Value('Second', '0'),
                                      Value('Minute', '0'),
                                      Value('Hour', '0'),
                                      Value('Day', '0'),
                                      Value('Month', '0'),
                                      Value('Year', '0'));

          alarmSettings.Sound := Value('Sound', 'Default');
          alarmUpdTimer.Enabled := alarmSettings.IsOn;
        end;
      end;
    end;
  XML.Free;

  LoadIcons;
end;

procedure TMainForm.SaveSettings;
var
  XML : TJclSimpleXML;
begin
  XML := TJclSimpleXML.Create;
  with XML.Root do
  begin
    Name := 'AlarmClockModuleSettings';

    // Clear the list so we don't get duplicates.
    Items.Clear;

    Items.Add('Settings');
    with Items.ItemNamed['Settings'].Items do
    begin
      Add('Timeout', alarmSettings.Timeout div 1000);
      Add('Snooze', alarmSettings.Snooze div 1000);
    end;

    Items.Add('Time');
    with Items.ItemNamed['Time'].Items do
    begin
      Add('AutoStart', alarmSettings.IsOn);
      Add('Sound', alarmSettings.Sound);

      Add('Second', alarmSettings.Alarm.Sec);
      Add('Minute', alarmSettings.Alarm.Min);
      Add('Hour', alarmSettings.Alarm.Hou);
      Add('Day', alarmSettings.Alarm.Day);
      Add('Month', alarmSettings.Alarm.Mon);
      Add('Year', alarmSettings.Alarm.Yea);
    end;
  end;

  if not SaveXMLToSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    SharpApi.SendDebugMessageEx('AlarmClock',PChar('Failed to Save settings to File: ' + mInterface.BarInterface.GetModuleXMLFile(mInterface.ID)),clred,DMT_ERROR);
  XML.Free;
end;

procedure TMainForm.mnuRightConfigClick(Sender: TObject);
begin
  SharpCenterApi.CenterCommand(sccLoadSetting,
      PChar('Modules'),
	  PChar('AlarmClock'),
      PChar(inttostr(mInterface.BarInterface.BarID) + ':' + inttostr(mInterface.ID)));
end;

procedure TMainForm.mnuRightDisableClick(Sender: TObject);
begin
  if alarmSettings.IsOn then
  begin
    alarmSettings.IsOn := False;
    alarmSettings.IsAlarming := False;

    alarmTimeoutTimer.Enabled := False;
    alarmSnoozeTimer.Enabled := False;
    alarmUpdTimer.Enabled := False;
  end else
  begin
    alarmSettings.IsOn := True;
    LoadSettings;
  end;

  UpdateAlarm;
end;

procedure TMainForm.mnuRightSnoozeClick(Sender: TObject);
begin
  Snooze;
end;

procedure TMainForm.mnuRightTurnOffClick(Sender: TObject);
begin
  alarmSettings.IsAlarming := False;
  alarmTimeoutTimer.Enabled := False;
  alarmSnoozeTimer.Enabled := False;

  UpdateAlarm;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  btnAlarm.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSize;
begin
  btnAlarm.Width := Width - 4;
  Repaint;
end;

procedure TMainForm.ReAlignComponents(Broadcast : boolean = True);
var
  newWidth : integer;
begin
  self.Caption := 'AlarmClock';

  btnAlarm.Left := 2;

  newWidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;

  if (btnAlarm.Glyph32 <> nil) then
    newWidth := newWidth + btnAlarm.GetIconWidth;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;

  if (newWidth <> Width) and (Broadcast) then
    mInterface.BarInterface.UpdateModuleSize
  else
    UpdateSize;
end;

procedure TMainForm.alarmOnTimeoutTimer(Sender: TObject);
begin
  alarmSettings.IsAlarming := True;
  alarmTimeoutTimer.Enabled := False;
  alarmSnoozeTimer.Enabled := False;

  Snooze;
  UpdateAlarm;
end;

procedure TMainForm.alarmOnSnoozeTimer(Sender: TObject);
begin
  alarmSettings.IsAlarming := True;
  alarmTimeoutTimer.Enabled := False;
  alarmSnoozeTimer.Enabled := False;

  Timeout;
  UpdateAlarm;
end;

procedure TMainForm.alarmOnTimer(Sender: TObject);
begin
  if alarmSettings.Alarm.Compare(Now) and not alarmSettings.IsAlarming then
  begin
    alarmSettings.IsAlarming := true;
    UpdateAlarm;

    Timeout;
  end;
end;

procedure TMainForm.UpdateAlarm;
begin
  if alarmSettings.IsAlarming then
  begin
    alarmSettings.Alarm.SoundLoad(alarmSettings.Sound);
    alarmSettings.Alarm.SoundPlay;
  end else
  begin
    alarmSettings.Alarm.SoundStop;
    alarmSettings.Alarm.SoundClose;
  end;

  LoadIcons;
  Repaint;
end;

procedure TMainForm.Timeout;
begin
  if (not alarmSettings.IsOn) then
    exit;

  alarmTimeoutTimer.Interval := alarmSettings.Timeout;
  alarmTimeoutTimer.Enabled := True;
end;

procedure TMainForm.Snooze;
begin
  if (not alarmSettings.IsOn) or (not alarmSettings.IsAlarming) then
    exit;

  alarmSettings.IsAlarming := False;
  alarmSnoozeTimer.Interval := alarmSettings.Snooze;
  alarmSnoozeTimer.Enabled := True;

  UpdateAlarm;
end;

procedure TMainForm.btnAlarmOnClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  m : TMenuItem;
begin

  if Button = mbLeft then
  begin
    Snooze;
  end else if Button = mbRight then
  begin
    p := ClientToScreen(Point(btnAlarm.Left, btnAlarm.Top));

    // Get the cordinates on the screen where the popup should appear.
    p := ClientToScreen(Point(0, Self.Height));
    if p.Y > Monitor.Top + Monitor.Height div 2 then
      p.Y := p.Y - Self.Height;

    m := mnuRight.Items[0];
    m.Enabled := (alarmSettings.IsAlarming);

    m := mnuRight.Items[1];
    m.Enabled := (alarmSettings.IsAlarming) or (alarmTimeoutTimer.Enabled) or (alarmSnoozeTimer.Enabled);

    m := mnuRight.Items[2];
    if alarmSettings.IsOn then
    begin
      m.ImageIndex := 3;
      m.Caption := 'Disable'
    end else
    begin
      m.ImageIndex := 2;    
      m.Caption := 'Enable';
    end;

    // Show the menu
    mnuRight.Popup(p.X, p.Y);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  alarmSettings.Alarm := TAlarmTime.Create(Self);
  alarmSettings.IsOn := False;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // Save settings before the Alarm clock is removed
  SaveSettings;

  FreeAndNil(alarmSettings.Alarm);
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  Bmp.Assign(mInterface.Background);

  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

end.
