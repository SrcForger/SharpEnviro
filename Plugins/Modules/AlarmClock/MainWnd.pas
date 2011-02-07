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
  uISharpBarModule, ISharpESkinComponents, JclShell, JclStrings, Graphics,
  SharpApi, SharpCenterApi, Menus, SharpEButton, ExtCtrls, SharpEBaseControls, Controls,
  GR32, GR32_PNG, GR32_Image, JclSimpleXML, IXmlBaseUnit, cbAudioPlay, DirectShow,
  ImgList, PngImageList,
  SharpNotify;

type
  TAlarmTimeRecord = record
    Second, Minute, Hour : integer;
    Day, Month, Year: integer;
  end;

  PAlarmTimeRecord = ^TAlarmTimeRecord;

  TAlarmTime = class
  private
    wParent : TWinControl;
    IsTemp : boolean;

    FStart: TAlarmTimeRecord; 
    FCurrent: TAlarmTimeRecord;

    FName: String;
    FIsOn, FIsAlarming : boolean;
    FSnoozeCount : integer;

    // Audio
    Sound: TcbAudioPlay;
    FDeviceIdx : integer;

  public
    constructor Create(par : TWinControl); reintroduce;
    destructor Destroy; reintroduce;

    function GetTime: TDateTime;

    procedure SetTime(item: PAlarmTimeRecord; sSec, sMin, sHou, sDay, sMon, sYea : integer); overload;
    procedure SetTime(sSec, sMin, sHou, sDay, sMon, sYea : string); overload;
    procedure SetTime(t : TDateTime); overload;
    procedure SetCurrent(t : TDateTime);

    function Compare(alarm : TAlarmTime) : boolean; overload;
    function Compare(t : TDateTime) : boolean; overload;

    procedure SoundLoad(s : string);
    procedure SoundClose;
    procedure SoundPlay;
    procedure SoundStop;

    property Start: TAlarmTimeRecord read FStart write FStart;
    property Current: TAlarmTimeRecord read FCurrent write FCurrent;

    property Name: String read FName write FName;
    property IsOn: Boolean read FIsOn write FIsOn;
    property IsAlarming: Boolean read FIsAlarming write FIsAlarming;
    property SnoozeCount: integer read FSnoozeCount write FSnoozeCount;

  end;

  TSHQUERYRBINFO = packed record
     cbSize : DWord;
     i64Size : Int64;
     i64NumItems : Int64;
  end;

  TAlarmSettings = record
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
    procedure btnAlarmMouseEnter(Sender: TObject);
    procedure btnAlarmMouseLeave(Sender: TObject);

  private
    procedure ShowNotify(ATimeout: integer = 0);
    procedure UpdateNotify;

  public
    alarmSettings : TAlarmSettings;

    FNotifyWnd : TNotifyItem;
    FNotifyText : String;

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
  FSnoozeCount := 0;
end;

destructor TAlarmTime.Destroy;
begin
  SoundClose;
  FreeAndNil(Sound);
end;

function TAlarmTime.GetTime: TDateTime;
var
  tMili, tSec, tMin, tHou: word;
  tDay, tMon, tYea: word;
  tmp, tmp2: TDateTime;
begin
  DecodeDateTime(Now, tYea, tMon, tDay, tHou, tMin, tSec, tMili);

  if FCurrent.Year > 0  then
    tYea := FCurrent.Year;
  if FCurrent.Month > 0  then
    tMon := FCurrent.Month;
  if FCurrent.Day > 0  then
    tDay := FCurrent.Day;
  if (FCurrent.Hour >= 0) and (FCurrent.Hour < 24)  then
    tHou := FCurrent.Hour;
  if (FCurrent.Minute >= 0) and (FCurrent.Minute < 60)  then
    tMin := FCurrent.Minute;
  if (FCurrent.Second >= 0) and (FCurrent.Second < 60)  then
    tSec := FCurrent.Second;

  tmp := EncodeDateTime(tYea, tMon, tDay, tHou, tMin, tSec, 0);
  tmp2 := EncodeDateTime(tYea, tMon, tDay, 23, 59, 59, 0);
  if (FStart.Day <= 0) and ((CompareTime(Now, tmp) > 0)) and (CompareTime(tmp, tmp2) < 0) then
    tDay := tDay + 1;

  Result := EncodeDateTime(tYea, tMon, tDay, tHou, tMin, tSec, 0);
end;

procedure TAlarmTime.SetTime(item: PAlarmTimeRecord; sSec, sMin, sHou, sDay, sMon, sYea : integer);
begin
  item.Second := sSec;
  item.Minute := sMin;
  item.Hour := sHou;
  item.Day := sDay;
  item.Month := sMon;
  item.Year := sYea;
end;

procedure TAlarmTime.SetTime(sSec, sMin, sHou, sDay, sMon, sYea : string);
begin
  SetTime(@FStart, StrToInt(sSec), StrToInt(sMin), StrToInt(sHou), StrToInt(sDay), StrToInt(sMon), StrToInt(sYea));
end;

procedure TAlarmTime.SetTime(t : TDateTime);
var
  tMili, tSec, tMin, tHou: word;
  tDay, tMon, tYea: word;
begin
  DecodeDateTime(t, tYea, tMon, tDay, tHou, tMin, tSec, tMili);
  SetTime(@FStart, tSec, tMin, tHou, tDay, tMon, tYea);
end;

procedure TAlarmTime.SetCurrent(t : TDateTime);
var
  tMili, tSec, tMin, tHou: word;
  tDay, tMon, tYea: word;
begin
  DecodeDateTime(t, tYea, tMon, tDay, tHou, tMin, tSec, tMili);
  SetTime(@FCurrent, tSec, tMin, tHou, tDay, tMon, tYea);
end;

function TAlarmTime.Compare(t : TDateTime) : boolean;
var
  tMili, tSec, tMin, tHou: word;
  tDay, tMon, tYea: word;
begin
  DecodeDateTime(t, tYea, tMon, tDay, tHou, tMin, tSec, tMili);

  Result := ((FStart.Second < 0) or (FStart.Second = tSec)) and
            ((FStart.Minute < 0) or (FStart.Minute = tMin)) and
            ((FStart.Hour < 0) or (FStart.Hour = tHou)) and
            ((FStart.Day <= 0) or (FStart.Day = tDay)) and
            ((FStart.Month <= 0) or (FStart.Month = tMon)) and
            ((FStart.Year <= 0) or (FStart.Year = tYea));
end;


function TAlarmTime.Compare(alarm : TAlarmTime) : boolean;
begin
  Result := ((FStart.Second < 0) or (FStart.Second = alarm.Start.Second)) and
            ((FStart.Minute < 0) or (FStart.Minute = alarm.Start.Minute)) and
            ((FStart.Hour < 0) or (FStart.Hour = alarm.Start.Hour)) and
            ((FStart.Day <= 0) or (FStart.Day = alarm.Start.Day)) and
            ((FStart.Month <= 0) or (FStart.Month = alarm.Start.Month)) and
            ((FStart.Year <= 0) or (FStart.Year = alarm.Start.Year));
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
procedure TMainForm.ShowNotify(ATimeout: integer);
var
  BmpToDisplay: TBitmap32;
  NS: ISharpENotifySkin;
  SkinText: ISharpESkinText;

  sList : TStringList;
  n: integer;

  edge : TSharpNotifyEdge;
  LineWidth, LineHeight: integer;
  ypos : integer;
begin
  if Assigned(FNotifyWnd) then
    SharpNotify.CloseNotifyWindow(FNotifyWnd);
      
  FNotifyWnd := nil;

  BmpToDisplay := TBitmap32.Create;
  BmpToDisplay.DrawMode := dmBlend;
  BmpToDisplay.CombineMode := cmMerge;

  NS := mInterface.SkinInterface.SkinManager.Skin.Notify;
  SkinText := NS.Background.CreateThemedSkinText;
  SkinText.AssignFontTo(BmpToDisplay.Font, mInterface.SkinInterface.SkinManager.Scheme);

  sList := TStringList.Create;
  try
    StrToStrings(FNotifyText, sLineBreak, sList);

    LineWidth := 0;
    LineHeight := 0;
    for n := 0 to sList.Count - 1 do
    begin
      if LineWidth < BmpToDisplay.TextWidth(sList[n]) then
        LineWidth := BmpToDisplay.TextWidth(sList[n]);
      if LineHeight < BmpToDisplay.TextHeight(sList[n]) then
        LineHeight := BmpToDisplay.TextHeight(sList[n]);
    end;

    BmpToDisplay.SetSize(LineWidth + 8, (LineHeight * sList.Count) + 8);

    ypos := 4;
    for n := 0 to sList.Count - 1 do
    begin
      SkinText.RenderToW(BmpToDisplay, 4, ypos, sList[n], mInterface.SkinInterface.SkinManager.Scheme);
      ypos := ypos + LineHeight;
    end;
  finally
    sList.Free;
  end;

  if Top < Monitor.Top + Monitor.Height div 2 then
  begin
    edge := neTopLeft;
    ypos := Monitor.Top + Height - 1;
  end else
  begin
    edge := neBottomLeft;
    ypos := Monitor.Top + Monitor.Height - Height;
  end;

  FNotifyWnd := SharpNotify.CreateNotifyWindowBitmap(
    0,
    nil,
    Left,
    ypos,
    BmpToDisplay,
    edge,
    mInterface.SkinInterface.SkinManager,
    ATimeout,
    Monitor.BoundsRect);

  BmpToDisplay.Free;
end;

procedure TMainForm.UpdateNotify;
var
  tmpTime: TDateTime;
  t: TAlarmTime;
begin
  if (alarmSettings.Alarm.IsOn) then
  begin
    tmpTime := alarmSettings.Alarm.GetTime;
    t := TAlarmTime.Create(Self);
    t.SetCurrent(tmpTime);

    if alarmSettings.Alarm.IsAlarming then
      FNotifyText := Format(alarmSettings.Alarm.Name + ' %d/%.2d/%.2d %.2d:%.2d:%.2d' + sLineBreak + 'Click the icon to Snooze',
            [t.Current.Year, t.Current.Month, t.Current.Day,
            t.Current.Hour, t.Current.Minute, t.Current.Second])
    else
    begin
      if alarmSettings.Alarm.SnoozeCount > 0 then
        FNotifyText := Format(alarmSettings.Alarm.Name + ' snoozed until %.2d:%.2d:%.2d', [t.Current.Hour, t.Current.Minute, t.Current.Second])
      else
        FNotifyText := Format(alarmSettings.Alarm.Name + ' set at %d/%.2d/%.2d %.2d:%.2d:%.2d',
            [t.Current.Year, t.Current.Month, t.Current.Day,
            t.Current.Hour, t.Current.Minute, t.Current.Second]);

      t.Free;
    end;
  end else
    FNotifyText := 'Alarm is disabled';
end;

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

      if alarmSettings.Alarm.IsAlarming then
        IconName := 'icon.alarm.active'
      else if not alarmSettings.Alarm.IsOn then
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
  alarmSettings.Alarm.SnoozeCount := 0;
  alarmSettings.Alarm.IsAlarming := False;
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
          alarmSettings.Alarm.IsAlarming := False;
          alarmSettings.Alarm.IsOn := (alarmSettings.Alarm.IsOn) or (BoolValue('AutoStart', False));

          alarmSettings.Alarm.Name := Value('Name', 'Alarm #' + IntToStr(n));
          alarmSettings.Alarm.SetTime(Value('Second', '0'),
                                      Value('Minute', '0'),
                                      Value('Hour', '0'),
                                      Value('Day', '0'),
                                      Value('Month', '0'),
                                      Value('Year', '0'));
                                      
          alarmSettings.Alarm.Current := alarmSettings.Alarm.Start;

          alarmSettings.Sound := Value('Sound', 'Default');
          alarmUpdTimer.Enabled := alarmSettings.Alarm.IsOn;
        end;
      end;
    end;
  XML.Free;

  LoadIcons;
  UpdateNotify;
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
      Add('AutoStart', alarmSettings.Alarm.IsOn);
      Add('Sound', alarmSettings.Sound);

      Add('Name', alarmSettings.Alarm.Name);
      Add('Second', alarmSettings.Alarm.Start.Second);
      Add('Minute', alarmSettings.Alarm.Start.Minute);
      Add('Hour', alarmSettings.Alarm.Start.Hour);
      Add('Day', alarmSettings.Alarm.Start.Day);
      Add('Month', alarmSettings.Alarm.Start.Month);
      Add('Year', alarmSettings.Alarm.Start.Year);
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
  if alarmSettings.Alarm.IsOn then
  begin
    alarmSettings.Alarm.IsOn := False;
    alarmSettings.Alarm.IsAlarming := False;

    alarmTimeoutTimer.Enabled := False;
    alarmSnoozeTimer.Enabled := False;
    alarmUpdTimer.Enabled := False;
  end else
  begin
    alarmSettings.Alarm.IsOn := True;
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
  alarmSettings.Alarm.Current := alarmSettings.Alarm.Start;
  alarmSettings.Alarm.SnoozeCount := 0;
  alarmSettings.Alarm.IsAlarming := False;
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
  alarmSettings.Alarm.IsAlarming := True;
  alarmTimeoutTimer.Enabled := False;
  alarmSnoozeTimer.Enabled := False;

  Snooze;
  UpdateAlarm;
end;

procedure TMainForm.alarmOnSnoozeTimer(Sender: TObject);
begin
  alarmSettings.Alarm.IsAlarming := True;
  alarmTimeoutTimer.Enabled := False;
  alarmSnoozeTimer.Enabled := False;

  Timeout;
  UpdateAlarm;
end;

procedure TMainForm.alarmOnTimer(Sender: TObject);
begin
  if alarmSettings.Alarm.Compare(Now) and not alarmSettings.Alarm.IsAlarming then
  begin
    alarmSettings.Alarm.IsAlarming := true;
    UpdateAlarm;
    UpdateNotify;

    Timeout;
  end;
end;

procedure TMainForm.UpdateAlarm;
begin
  if alarmSettings.Alarm.IsAlarming then
  begin
    UpdateNotify;
    ShowNotify(5000);
  
    alarmSettings.Alarm.SoundLoad(alarmSettings.Sound);
    alarmSettings.Alarm.SoundPlay;
  end else
  begin
    UpdateNotify;
    alarmSettings.Alarm.SoundStop;
    alarmSettings.Alarm.SoundClose;
  end;

  LoadIcons;
  Repaint;
end;

procedure TMainForm.Timeout;
begin
  if (not alarmSettings.Alarm.IsOn) then
    exit;

  alarmSnoozeTimer.Enabled := False;
  alarmTimeoutTimer.Interval := alarmSettings.Timeout;
  alarmTimeoutTimer.Enabled := True;

  UpdateNotify;
end;

procedure TMainForm.Snooze;
begin
  if (not alarmSettings.Alarm.IsOn) or (not alarmSettings.Alarm.IsAlarming) then
    exit;

  alarmSettings.Alarm.SetCurrent(IncMilliSecond(Now, alarmSettings.Snooze));
  alarmSettings.Alarm.SnoozeCount := alarmSettings.Alarm.SnoozeCount + 1;
  alarmSettings.Alarm.IsAlarming := False;
  
  alarmSnoozeTimer.Interval := alarmSettings.Snooze;
  alarmSnoozeTimer.Enabled := True;
  alarmTimeoutTimer.Enabled := False;

  UpdateAlarm;
  UpdateNotify;
end;

procedure TMainForm.btnAlarmMouseEnter(Sender: TObject);
begin
  ShowNotify;
end;

procedure TMainForm.btnAlarmMouseLeave(Sender: TObject);
begin
  if Assigned(FNotifyWnd) then
    SharpNotify.CloseNotifyWindow(FNotifyWnd);

  FNotifyWnd := nil;
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
    m.Enabled := (alarmSettings.Alarm.IsAlarming);

    m := mnuRight.Items[1];
    m.Enabled := (alarmSettings.Alarm.IsAlarming) or (alarmTimeoutTimer.Enabled) or (alarmSnoozeTimer.Enabled);

    m := mnuRight.Items[2];
    if alarmSettings.Alarm.IsOn then
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
  alarmSettings.Alarm.IsOn := False;
  FNotifyText := '';
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
