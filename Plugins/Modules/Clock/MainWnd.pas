{
Source Name: MainWnd
Description: Clock module main window
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
  Windows, SysUtils, Classes, Controls, Forms, Messages,
  StdCtrls, SharpEBaseControls, Commctrl, SharpTypes,
  JclSimpleXML, SharpApi, Menus, Math,
  SharpESkinLabel, GR32, ExtCtrls, ToolTipApi,
  uISharpBarModule;


type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    OpenWindowsDateTimesettings1: TMenuItem;
    lb_bottomclock: TSharpESkinLabel;
    lb_clock: TSharpESkinLabel;
    ClockTimer: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lb_clockDblClick(Sender: TObject);
    procedure ClockTimerTimer(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
  protected
  private
    sFormat : String;
    sBottomFormat : String;
    sStyle  : TSharpELabelStyle;
    FTipWnd : hwnd;
    FTipSet : boolean;
    FOldTip : String;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
  end;


implementation

{$R *.dfm}

procedure TMainForm.WMNotify(var msg: TWMNotify);
begin
  if Msg.NMHdr.code = TTN_SHOW then
  begin
    SetWindowPos(Msg.NMHdr.hwndFrom, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    Msg.result := 1;
    exit;
  end else Msg.result := 0;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  sFormat := 'HH:MM:SS';
  sBottomFormat := 'DD.MM.YYYY';
  sStyle  := lsMedium;

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
      sFormat := Value('Format','HH:MM:SS');
      sBottomFormat := Value('BottomFormat','DD.MM.YYYY');
      case IntValue('Style',1) of
        0: sStyle := lsSmall;
        2: sStyle := lsBig;
        else sStyle := lsMedium
      end;
    end;
  XML.Free;

  if lb_clock.LabelStyle = sStyle then
     if lb_clock.LabelStyle = lsSmall then lb_clock.LabelStyle := lsMedium
        else lb_clock.LabelStyle := lsSmall;

  if ClockTimer.Enabled then
    ClockTimer.OnTimer(nil);
  lb_clock.Updateskin;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  lb_clock.SkinManager := mInterface.SkinInterface.SkinManager;
  lb_bottomclock.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSize;
begin
  if FTipSet then
     ToolTipApi.UpdateToolTipRect(FTipWnd,Self,0,Rect(0,0,Width,Height));

  if lb_bottomClock.Visible then
  begin
    lb_clock.Left := Width div 2 - lb_clock.Width div 2;
    lb_bottomclock.Left := Width div 2 - lb_bottomclock.Width div 2;
  end else lb_clock.Left := 0;
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
begin
  self.Caption := sFormat;
  if ClockTimer.Enabled then
    ClockTimer.OnTimer(nil);

  lb_clock.UpdateSkin;
  if lb_bottomClock.Visible then
  begin
    lb_clock.AutoPos := apTop;
    newWidth := max(lb_clock.Width,lb_bottomClock.Width);
  end else
  begin
    newWidth := lb_clock.Width;
    lb_clock.AutoPos := apCenter;
  end;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize;
end;


procedure TMainForm.ClockTimerTimer(Sender: TObject);
var
  d : String;
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

  DateTimeToString(d,'DDDD - DD.MM.YYYY',now());
  if (CompareText(d,FOldTip) <> 0) and (FTipSet) then
  begin
    ToolTipApi.UpdateToolTipText(FTipWnd,Self,0,d);
    FOldTip := d;
  end;
  if IsWindowVisible(FTipWnd) then
     SendMessage(FTipWnd,TTM_UPDATE,0,0);

  if ((nw - ow > 4) or (lb_bottomclock.visible <> ov))
    and (Sender <> nil) then
    RealignComponents;
end;

procedure TMainForm.lb_clockDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('timedate.cpl');
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FTipSet := False;
  FOldTip := '.';
  DoubleBuffered := True;

  FTipWnd := ToolTipApi.RegisterToolTip(self);
end;

procedure TMainForm.FormDblClick(Sender: TObject);
begin
  lb_clockDblClick(lb_clock);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ToolTipApi.DeleteToolTip(FTipWnd,Self,0);
  if FTipWnd <> 0 then
     DestroyWindow(FTipWnd);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if not FTipSet then
     ToolTipApi.AddToolTip(FTipWnd,self,0,Rect(0,0,Width,Height),'.');
  FTipSet := True;
end;

end.
