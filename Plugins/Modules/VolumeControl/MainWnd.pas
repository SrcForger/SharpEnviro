{
Source Name: MainWnd
Description: Volume Control module main window
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32, GR32_PNG, SharpEBaseControls, SharpEButton,
  ExtCtrls, SharpEProgressBar, JclSimpleXML, SharpApi, Menus,
  Math, SoundControls, MMSystem, uISharpBarModule, uVistaFuncs;


type
  TMainForm = class(TForm)
    ClockTimer: TTimer;
    mute: TSharpEButton;
    pbar: TSharpEProgressBar;
    cshape: TShape;
    procedure FormPaint(Sender: TObject);
    procedure muteMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cshapeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cshapeMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure cshapeMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure muteClick(Sender: TObject);
    procedure ClockTimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
  private
    sWidth  : integer;
    sMixer  : integer;
    sButtonRight : boolean;
    FDLow,FDMed,FDHigh,FDMute : TBitmap32;
    lastvolume : integer;
    lastmute : boolean;
    procedure LoadIcons;
    procedure AdjustVolume(value: Integer; mixer: Integer);
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
  end;

var
  forceupdate : boolean;

implementation

{$R *.dfm}
{$R glyphs.res}

procedure TMainForm.LoadIcons;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
  ResIDSuffix : String;
begin
  if mInterface = nil then
    exit;
  if mInterface.SkinInterface = nil then
    exit;

  TempBmp := TBitmap32.Create;
  if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 16 then
  begin
    TempBmp.SetSize(16,16);
    ResIDSuffix := '';
  end else
  begin
    TempBmp.SetSize(32,32);
    ResIDSuffix := '32';
  end;

  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, 'high'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FDHigh.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'medium'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FDMed.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'low'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FDLow.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'muted'+ResIDSuffix, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FDMute.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  tempBmp.Free;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  sWidth  := 50;
  sMixer  := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
  sButtonRight := False;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sWidth := IntValue('Width',50);
      sMixer := IntValue('Mixer',MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
      sButtonRight := BoolValue('ButtonRight',False);
    end;
  XMl.Free;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  pbar.SkinManager := mInterface.SkinInterface.SkinManager;
  mute.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSize;
begin
  LoadIcons;
  forceupdate := True;
  mute.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
  if mute.Glyph32 <> nil then
    mute.Width := mute.Width + mute.GetIconWidth;
  mute.Width := mute.Width - 4;
  if sButtonRight then
  begin
    mute.Left := Width - 2 - mute.Width;
    pbar.Left := 2;
    pbar.Width := Width - mute.Width - 4 - pbar.Left;
  end else
  begin
    mute.Left := 2;
    pbar.Left := mute.Left + mute.Width + 2;
    pbar.Width := Width - mute.Left - mute.Width - 4;
  end;
  pbar.Height := Height - 8;
  cshape.Left   := pbar.Left;
  cshape.Top    := pbar.Top;
  cshape.Width  := pbar.Width;
  cshape.Height := pbar.Height;
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
begin
  self.Caption := inttostr(sMixer);
  if ClockTimer.Enabled then
    ClockTimer.OnTimer(ClockTimer);

  mute.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
  if mute.Glyph32 <> nil then
    mute.Width := mute.Width + mute.GetIconWidth;
        
  newWidth := sWidth + mute.Width + 6;
  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;  
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  forceupdate := False;
  DoubleBuffered := True;
  FDLow  := TBitmap32.Create;
  FDMed  := TBitmap32.Create;
  FDHigh := TBitmap32.Create;
  FDMute := TBitmap32.Create;
  lastvolume := -1;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FDLow.free;
  FDMed.free;
  FDHigh.free;
  FDMute.free;
end;

procedure TMainForm.ClockTimerTimer(Sender: TObject);
var
  i : integer;
  v : real;
begin
  try
    i := Integer(GetMasterVolume(sMixer));
    if (i<>lastvolume) or (GetMasterMuteStatus(sMixer)<>lastmute) or forceupdate then
    begin
      lastvolume := i;
      lastmute   := GetMasterMuteStatus(sMixer);
      pbar.Value := i;
      v := i / pbar.Max;
      if (lastmute) then mute.Glyph32.Assign(FDMute)
         else if v > 0.8 then mute.Glyph32.Assign(FDHigh)
         else if v > 0.3 then mute.Glyph32.Assign(FDMed)
         else mute.Glyph32.Assign(FDLow);
      mute.UpdateSkin;
    end;
    forceupdate := False;
    ClockTimer.Interval := 250;
  except
    // We couldn't get a device so increase the time to 30 seconds
    // so we don't keep trying every 250 milliseconds.
    ClockTimer.Interval := 30000;
    // Assign some defaults in case there is no audio device attached.
    mute.Glyph32.Assign(FDMute);
    mute.UpdateSkin;
    pbar.Value := 0;
    // Force an update incase the audio service was off and
    // the user turned it back on or a device was added.
    forceupdate := True;
  end;
end;

procedure TMainForm.muteClick(Sender: TObject);
begin
  try
    MuteMaster(sMixer);
  except
    // Squash any exceptions that may occur here as some
    // systems may not have an audio device attached.
  end;
  ClockTimer.OnTimer(ClockTimer);
end;

procedure TMainForm.cshapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  newValue : Integer;
begin
  cshape.Tag := 1;
  if x>cshape.Width then newValue := pbar.Max
     else if x<0 then newValue := 0
     else newValue := round((X/cshape.Width) * pbar.Max);

  AdjustVolume(newValue, sMixer);
  // Only update the postion if we were able update the volume.
  pbar.Value := newValue;
end;

procedure TMainForm.cshapeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  newValue : Integer;
begin
  if cshape.Tag = 1 then
  begin
    if x>cshape.Width then newValue := pbar.Max
       else if x<0 then newValue := 0
       else newValue := round((X/cshape.Width) * pbar.Max);

    AdjustVolume(newValue, sMixer);
    // Only update the postion if we were able update the volume.
    pbar.Value := newValue;
  end;
end;

procedure TMainForm.cshapeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  newValue : Integer;
begin
  cshape.Tag := 0;
  if x>cshape.Width then newValue := pbar.Max
     else if x<0 then newValue := 0
     else newValue := round((X/cshape.Width) * pbar.Max);

  AdjustVolume(newValue, sMixer);
  // Only update the postion if we were able update the volume.
  pbar.Value := newValue;
end;

procedure TMainForm.AdjustVolume(value: Integer; mixer: Integer);
begin
  try
    SetMasterVolume(value, mixer);
  except
    // Squash any exceptions that may occur here as some
    // systems may not have an audio device attached.
  end;
end;

procedure TMainForm.muteMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
  begin
    if IsWindowsVista or IsWindows7 then
      SharpApi.SharpExecute('sndvol.exe')
    else
      SharpApi.SharpExecute('sndvol32.exe');
  end;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
