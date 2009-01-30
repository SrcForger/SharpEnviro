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
  Math, SoundControls, MMSystem, uISharpBarModule;


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
    FDLow,FDMed,FDHigh,FDMute : TBitmap32;
    lastvolume : integer;
    lastmute : boolean;
    procedure InitDefaultImages;
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
  end;


implementation

{$R *.dfm}
{$R glyphs.res}

procedure TMainForm.InitDefaultImages;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(32,32);
  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, 'high', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FDHigh.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'medium', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FDMed.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'low', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FDLow.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'muted', RT_RCDATA);
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
  mute.Width := mInterface.SkinInterface.SkinManager.Skin.ButtonSkin.WidthMod;
  if mute.Glyph32 <> nil then
    mute.Width := mute.Width + mute.GetIconWidth;
  mute.Width := mute.Width - 4;
  pbar.Left := mute.Left + mute.Width + 2;
  pbar.Width := Width - mute.Left - mute.Width - 4;
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

  newWidth := sWidth + mute.Width + 6;
  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;  
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  FDLow  := TBitmap32.Create;
  FDMed  := TBitmap32.Create;
  FDHigh := TBitmap32.Create;
  FDMute := TBitmap32.Create;
  lastvolume := -1;
  InitDefaultImages;
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
  i := Integer(GetMasterVolume(sMixer));
  if (i<>lastvolume) or (GetMasterMuteStatus(sMixer)<>lastmute) then
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
end;

procedure TMainForm.muteClick(Sender: TObject);
begin
  MuteMaster(sMixer);
  ClockTimer.OnTimer(ClockTimer);
end;

procedure TMainForm.cshapeMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  cshape.Tag := 1;
  if x>cshape.Width then pbar.Value := pbar.Max
     else if x<0 then pbar.Value := 0
     else pbar.Value := round((X/cshape.Width) * pbar.Max);
  SetMasterVolume(pbar.Value,(sMixer));
end;

procedure TMainForm.cshapeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if cshape.Tag = 1 then
  begin
    if x>cshape.Width then pbar.Value := pbar.Max
       else if x<0 then pbar.Value := 0
       else pbar.Value := round((X/cshape.Width) * pbar.Max);
    SetMasterVolume(pbar.Value,(sMixer));
  end;
end;

procedure TMainForm.cshapeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  cshape.Tag := 0;
  if x>cshape.Width then pbar.Value := pbar.Max
     else if x<0 then pbar.Value := 0
     else pbar.Value := round((X/cshape.Width) * pbar.Max);
  SetMasterVolume(pbar.Value,(sMixer));
end;

procedure TMainForm.muteMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    SharpApi.SharpExecute('sndvol32.exe');
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
