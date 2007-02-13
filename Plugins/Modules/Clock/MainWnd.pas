{
Source Name: MainWnd
Description: Clock module main window
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math, SharpEEdit, SharpELabel,
  SharpESkinLabel;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    ClockTimer: TTimer;
    lb_clock: TSharpESkinLabel;
    OpenWindowsDateTimesettings1: TMenuItem;
    lb_bottomclock: TSharpESkinLabel;
    procedure lb_clockDblClick(Sender: TObject);
    procedure ClockTimerTimer(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sFormat : String;
    sBottomFormat : String;
    sStyle  : TSharpELabelStyle;
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

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sFormat := 'HH:MM:SS';
  sBottomFormat := 'DD.MM.YYYY';
  sStyle  := lsMedium;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sFormat := Value('Format','HH:MM:SS');
    sBottomFormat := Value('BottomFormat','DD.MM.YYYY');
    case IntValue('Style',1) of
      0: sStyle := lsSmall;
      2: sStyle := lsBig;
      else sStyle := lsMedium
    end;
  end;
  if lb_clock.LabelStyle = sStyle then
     if lb_clock.LabelStyle = lsSmall then lb_clock.LabelStyle := lsMedium
        else lb_clock.LabelStyle := lsSmall;
  ClockTimer.OnTimer(ClockTimer);
  lb_clock.Updateskin;
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
  if lb_bottomClock.Visible then
  begin
    lb_clock.Left := newWidth div 2 - lb_clock.Width div 2;
    lb_bottomclock.Left := newWidth div 2 - lb_bottomclock.Width div 2;
  end else lb_clock.Left := 0;

  Background.Bitmap.BeginUpdate;
  Background.Bitmap.SetSize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background.Bitmap,self);
  Background.Bitmap.EndUpdate;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := sFormat;
  ClockTimer.OnTimer(ClockTimer);

//  newWidth := lb_clock.Canvas.TextWidth(sFormat)+4;
  if lb_bottomClock.Visible then
  begin
    lb_clock.Top := 1 + ((Height - 2 - 4) div 2 div 2) - (lb_clock.Height div 2);
    lb_bottomclock.Top := Height - 3 - ((Height - 2 - 4) div 2 div 2) - (lb_bottomclock.Height div 2); 
    newWidth := max(lb_clock.Width,lb_bottomClock.Width);
  end else
  begin
    newWidth := lb_clock.Width;
    lb_clock.Top := Height div 2 - (lb_clock.Height div 2) - 2;
  end;
  Tag := newWidth;
  Hint := inttostr(NewWidth);
  if newWidth <> width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.edit_format.Text := sFormat;
    SettingsForm.edit_bottom.Text := sBottomFormat;
    SettingsForm.edit_bottom.OnChange(SettingsForm.edit_bottom);
    case sStyle of
      lsSmall  : SettingsForm.cb_small.Checked := True;
      lsMedium : SettingsForm.cb_medium.Checked := True;
      lsBig    : SettingsForm.cb_large.Checked := True;
    end;

    if SettingsForm.ShowModal = mrOk then
    begin
      sFormat  := SettingsForm.edit_format.Text;
      sBottomFormat := SettingsForm.edit_bottom.Text;
      if SettingsForm.cb_small.Checked then sStyle := lsSmall
         else if SettingsForm.cb_large.Checked then sStyle := lsBig
              else sStyle := lsMedium;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Format',sFormat);
        Add('BottomFormat',sBottomFormat);
        case sStyle of
          lsSmall  : Add('Style',0);
          lsMedium : Add('Style',1);
          lsBig    : Add('Style',2);
       end;
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
      ClockTimer.OnTimer(ClockTimer);
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.ClockTimerTimer(Sender: TObject);
var
  s : string;
  ow,nw : integer;
  ov : boolean;
begin
  ow := Width;
  ov := lb_bottomclock.visible;
  DateTimeToString(s,sFormat,now());
  lb_clock.Caption := s;
  if length(trim(sBottomFormat)) > 0 then
  begin
    DateTimeToString(s,sBottomFormat,now());
    lb_bottomclock.Caption := s;
    if lb_clock.LabelStyle <> lsSmall then
       lb_clock.LabelStyle := lsSmall;
    nw := max(lb_bottomclock.Width,lb_clock.Width);
    lb_bottomclock.Visible := True;
  end else
  begin
    if lb_clock.LabelStyle <> sStyle then
       lb_clock.LabelStyle := sStyle;
    nw := lb_clock.Width;
    lb_bottomclock.Visible := False;
  end;
  if (nw - ow > 4) or (lb_bottomclock.visible <> ov) then
     RealignComponents(True);
end;

procedure TMainForm.lb_clockDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('timedate.cpl');
end;

end.
