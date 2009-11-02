{
Source Name: MainWnd
Description: RSS Reader Monitor module main window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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
  Windows, SysUtils, Classes, Forms, Dialogs, DateUtils, SharpIconUtils,
  GR32, uISharpBarModule, ISharpESkinComponents, JclShell, MPlayer,
  SharpApi, Menus, SharpEButton, ExtCtrls, SharpEBaseControls, Controls,
  GR32_PNG, GR32_Image, JclSimpleXML;


type

  TAlarmTime = class
  private
    iSec, iMin, iHou : integer;
    iDay, iMon, iYea: integer;

    IsPlaying : Boolean;
    Sound: TMediaPlayer;

    procedure SoundNotify(Sender: TObject);

  public
    constructor Create(par : TWinControl); reintroduce;
    destructor Destroy; reintroduce;

    procedure SetTime(sSec, sMin, sHou, sDay, sMon, sYea : string);

    function Compare(t : TDateTime) : boolean; overload;
    function Compare(alarm : TAlarmTime) : boolean; overload;

    procedure SoundLoad(s : string);
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

    Alarm: TAlarmTime;
  end;

  TMainForm = class(TForm)
    btnAlarm: TSharpEButton;
    alarmUpdTimer: TTimer;
    alarmSnoozeTimer: TTimer;
    alarmTimeoutTimer: TTimer;
    mnuRight: TPopupMenu;
    urnOff1: TMenuItem;
    urnOff2: TMenuItem;
    Disable1: TMenuItem;

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
  public
    alarmSettings : TAlarmSettings;

    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure LoadIcons;

    procedure UpdateAlarm;

    procedure Timeout;
    procedure Snooze;
  end;


implementation

{$R *.dfm}
{$R AlarmGlyphs.res}

constructor TAlarmTime.Create(par : TWinControl);
begin
  Sound := TMediaPlayer.Create(Application);
  Sound.Parent := par;

  Sound.DeviceType := dtAutoSelect;

  Sound.Visible := False;
  Sound.Left := 0;
  Sound.Top := 0;

  Sound.Notify := True;
  Sound.OnNotify := SoundNotify;
end;

destructor TAlarmTime.Destroy;
begin
  Sound.Stop;
  Sound.Free;
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
  if (s = '') or (s = 'Default') or (not FileExists(s)) then
  begin
    ResSt := TResourceStream.Create(hInstance, 'wavdefault', RT_RCDATA);
    
    TempPath := nil;
    TempFile := nil;

    try
      GetMem(TempPath, MAX_PATH);
      GetMem(TempFile, MAX_PATH);
      GetTempPath(MAX_PATH, TempPath);
      GetTempFileName(TempPath, 'alarmclock', 0, TempFile);
      StrCopy(TempFile, StrCat(TempFile, '.wav'));
      ResSt.SaveToFile(string(TempFile));

      Sound.Close;
      Sound.Filename := string(TempFile);
      Sound.Wait := true;
      Sound.Open;
    finally
      FreeMem(TempPath);
      FreeMem(TempFile);
      ResSt.free;
    end;
  end else
  begin
    Sound.Close;
    Sound.FileName := s;
    Sound.Wait := true;
    Sound.Open;
  end;
end;

procedure TAlarmTime.SoundPlay;
begin
  if Sound.FileName = '' then
    exit;

  IsPlaying := True;
  Sound.Play;
end;

procedure TAlarmTime.SoundStop;
begin
  if Sound.FileName = '' then
    exit;

  IsPlaying := False;
  Sound.Stop;
  Sound.Rewind;
end;

procedure TAlarmTime.SoundNotify(Sender: TObject);
begin
  with Sender as TMediaPlayer do
  begin
    case Mode of
      mpStopped:
      begin
        if IsPlaying then
        begin
          Rewind;
          Play;
        end;
      end;
    end;

    Notify := True;
  end;
end;


procedure TMainForm.LoadIcons;
var
  TempBmp : TBitmap32;
  ResStream : TResourceStream;
  Alpha : boolean;
begin
  TempBmp := TBitmap32.Create;

  TempBmp.Clear(color32(0,0,0,0));
  try
    if alarmSettings.IsAlarming then
      ResStream := TResourceStream.Create(HInstance, 'alarmactive', RT_RCDATA)
    else if not alarmSettings.IsOn then
      ResStream := TResourceStream.Create(HInstance, 'alarmoff', RT_RCDATA)
    else
      ResStream := TResourceStream.Create(HInstance, 'alarmon', RT_RCDATA);
      
    try
      LoadBitmap32FromPng(TempBmp,ResStream,Alpha);
      btnAlarm.Glyph32.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  btnAlarm.UpdateSkin;

  TempBmp.Free;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  Loaded : boolean;

  n : integer;
begin
  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    Loaded := True;
  except
    Loaded := False;
  end;
  if Loaded then
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
          alarmSettings.IsOn := BoolValue('AutoStart', False);

          alarmSettings.Alarm.SetTime(Value('Second', '0'),
                                      Value('Minute', '0'),
                                      Value('Hour', '0'),
                                      Value('Day', '0'),
                                      Value('Month', '0'),
                                      Value('Year', '0'));

          if Value('Sound', '') <> '' then
            alarmSettings.Alarm.SoundLoad(Value('Sound', ''));

          alarmUpdTimer.Enabled := alarmSettings.IsOn;
        end;
      end;
    end;
  XML.Free;

  LoadIcons;
end;

procedure TMainForm.mnuRightDisableClick(Sender: TObject);
begin
  if alarmSettings.IsOn then
  begin
    alarmSettings.IsAlarming := False;
    alarmTimeoutTimer.Enabled := False;
    alarmSnoozeTimer.Enabled := False;

    alarmSettings.IsOn := False;
    alarmUpdTimer.Enabled := alarmSettings.IsOn;
  end else
  begin
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
  alarmTimeoutTimer.Enabled := False;
  alarmSnoozeTimer.Enabled := False;

  Snooze;
end;

procedure TMainForm.alarmOnSnoozeTimer(Sender: TObject);
begin
  alarmTimeoutTimer.Enabled := False;
  alarmSnoozeTimer.Enabled := False;

  alarmSettings.IsAlarming := True;
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
    alarmSettings.Alarm.SoundPlay
  else
    alarmSettings.Alarm.SoundStop;

  LoadIcons;
  Repaint;
end;

procedure TMainForm.Timeout;
begin
  alarmTimeoutTimer.Interval := alarmSettings.Timeout;
  alarmTimeoutTimer.Enabled := True;
end;

procedure TMainForm.Snooze;
begin
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

    m := mnuRight.Items[0];
    m.Enabled := (alarmSettings.IsAlarming);

    m := mnuRight.Items[1];
    m.Enabled := (alarmSettings.IsAlarming) or (alarmTimeoutTimer.Enabled) or (alarmSnoozeTimer.Enabled);

    m := mnuRight.Items[2];
    if alarmSettings.IsOn then
      m.Caption := 'Disable'
    else
      m.Caption := 'Enable';

    // Show the menu
    mnuRight.Popup(p.X, p.Y);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  alarmSettings.Alarm := TAlarmTime.Create(Self);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
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
