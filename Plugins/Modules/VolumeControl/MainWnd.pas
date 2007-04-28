{
Source Name: MainWnd
Description: Volume Control module main window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32, GR32_PNG, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager,  ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Menus, Math, SoundControls, MMSystem;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    ClockTimer: TTimer;
    pbar: TSharpEProgressBar;
    mute: TSharpEButton;
    cshape: TShape;
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
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth  : integer;
    sMixer  : integer;
    FDLow,FDMed,FDHigh,FDMute : TBitmap32;
    lastvolume : integer;
    lastmute : boolean;
    procedure InitDefaultImages;
  public
    ModuleID : integer;
    BarWnd   : hWnd;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

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
  item : TJvSimpleXMLElem;
begin
  sWidth  := 100;
  sMixer  := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sWidth := IntValue('Width',100);
    sMixer := IntValue('Mixer',MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
  end;
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
  
  mute.Width := Height + 2;
  pbar.Left := mute.Left + mute.Width + 2;
  pbar.Width := Width - mute.Left - mute.Width - 4;
  pbar.Height := Height - 8;
  cshape.Left   := pbar.Left;
  cshape.Top    := pbar.Top;
  cshape.Width  := pbar.Width;
  cshape.Height := pbar.Height;

  Background.Bitmap.BeginUpdate;
  Background.Bitmap.SetSize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background.Bitmap,self);
  Background.Bitmap.EndUpdate;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := inttostr(sMixer);
  ClockTimer.OnTimer(ClockTimer);

  newWidth := sWidth + mute.Width + 6;
  Tag := newWidth;
  Hint := inttostr(newWidth);
  if newWidth <> Width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);

  mute.Width := Height + 2;
  pbar.Left := mute.Left + mute.Width + 2;
  pbar.Width := Width - mute.Left - mute.Width - 4;
  pbar.Height := Height - 8;
  cshape.Left   := pbar.Left;
  cshape.Top    := pbar.Top;
  cshape.Width  := pbar.Width;
  cshape.Height := pbar.Height;
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
  n : integer;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.tb_size.Position := sWidth;
    for n := 0 to SettingsForm.IDList.Count -1 do
        if strtoint(SettingsForm.IDList[n]) = sMixer then
        begin
          SettingsForm.cb_mlist.ItemIndex := n;
          break;
        end;

    if SettingsForm.ShowModal = mrOk then
    begin
      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      sWidth := SettingsForm.tb_size.Position;
      if SettingsForm.IDList.Count = 0 then sMixer := 0
         else sMixer := strtoint(SettingsForm.IDList[SettingsForm.cb_mlist.ItemIndex]);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
        Add('Mixer',sMixer);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
      ClockTimer.OnTimer(ClockTimer);
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
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
  i := GetMasterVolume(sMixer);
  if (i<>lastvolume) or (GetMaterMuteStatus(sMixer)<>lastmute) then
  begin
    lastvolume := i;
    lastmute   := GetMaterMuteStatus(sMixer);
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

end.
