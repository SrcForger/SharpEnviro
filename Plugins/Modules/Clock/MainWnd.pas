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
  Types, StdCtrls, SharpEBaseControls, Commctrl, SharpTypes,
  JclSimpleXML, SharpApi, SharpCenterApi, Menus, Math,
  SharpESkinLabel, GR32, ExtCtrls, ToolTipApi,
  uISharpBarModule, ImgList, PngImageList,
  uTimeCalendar;


type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    OpenWindowsDateTimesettings1: TMenuItem;
    lb_bottomclock: TSharpESkinLabel;
    lb_clock: TSharpESkinLabel;
    ClockTimer: TTimer;
    PngImageList1: TPngImageList;
    N1: TMenuItem;
    Configure1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lb_clockDblClick(Sender: TObject);
    procedure ClockTimerTimer(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure Configure1Click(Sender: TObject);
    procedure lb_clockMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure lb_clockClick(Sender: TObject);
    procedure FormClick(Sender: TObject);
  protected
  private
    sFormat : String;
    sBottomFormat : String;
    sTooltipFormat : String;
    sStyle  : TSharpELabelStyle;
    FTipWnd : hwnd;
    FTipSet : boolean;
    FOldTip : String;
    FTimeCalendar: TTimeCalendar;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
  end;


implementation

uses
  uSharpXMLUtils;

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
begin
  // Default some values each time the settings are loaded.
  sFormat := '';
  sBottomFormat := '';
  sTooltipFormat := '';
  sStyle  := lsMedium;
  lb_clock.AutoPos := apCenter;
  lb_bottomclock.Caption := '';
  lb_bottomclock.Visible := False;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with xml.Root.Items do
    begin
      // There should always be a Format element no matter which style is used.
      sFormat := Value('Format', 'T');

      // There should always be a tooltip format element.
      sTooltipFormat := Value('TooltipFormat', 'DDDDDD');

      // The valid values for style are
      // 0 = Small, 1 = Medium, 2 = Big, 3 = Automatic
      // Defaulting to -1 indicates a new config or the xml could be bad. 
      case IntValue('Style', -1) of
        0: lb_clock.LabelStyle := lsSmall;
        1: lb_clock.LabelStyle := lsMedium;
        2: lb_clock.LabelStyle := lsBig;
        3:
        begin
          // This user has specified automatic, so set the style to small
          // and read the bottom label format if there is one.

          sBottomFormat := Value('BottomFormat', '');

          // Make the bottom label visible if a format was specified.
          lb_bottomclock.Visible := Length(Trim(sBottomFormat)) > 0;

          if lb_bottomclock.Visible then
          begin
            // If there is a bottom format then use a small style and
            // reposition the main label to the top.
            lb_clock.LabelStyle := lsSmall;
            lb_clock.AutoPos := apTop;
          end;
        end;
        else
          // Its either a new config or it is messed up so start fresh.
          lb_clock.LabelStyle := lsSmall;
          lb_clock.AutoPos := apTop;
          sBottomFormat := 'DDDDD';
          lb_bottomclock.Visible := True;
      end;
    end;
  XML.Free;

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

  // The top label is always visible so start with its width.
  newWidth := lb_clock.Width;
  
  if lb_bottomClock.Visible then
  begin
    lb_bottomclock.UpdateSkin;
    // The bottom label is visible so see if it is wider than the main label.
    newWidth := max(lb_clock.Width, lb_bottomClock.Width);
  end;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

procedure TMainForm.ClockTimerTimer(Sender: TObject);
var
  d : String;
  s : string;
  ow,nw : integer;
begin
  ow := Width;
  DateTimeToString(s,sFormat,now());
  lb_clock.Caption := s;

  // The top label is always visible so start with its width.
  nw := lb_clock.Width;

  if lb_bottomclock.Visible then
  begin
    DateTimeToString(s,sBottomFormat,now());
    lb_bottomclock.Caption := s;

    // The bottom label is visible so see if it is wider than the main label.
    nw := max(lb_bottomclock.Width,lb_clock.Width);
  end;

  DateTimeToString(d,sTooltipFormat,now());
  
  if (CompareText(d,FOldTip) <> 0) and (FTipSet) then
  begin
    ToolTipApi.UpdateToolTipText(FTipWnd,Self,0,d);
    FOldTip := d;
  end;

  if IsWindowVisible(FTipWnd) then
     SendMessage(FTipWnd,TTM_UPDATE,0,0);

  if (nw - ow > 4) and (Sender <> nil) then
    RealignComponents;
end;

procedure TMainForm.lb_clockMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
begin
  if Button = mbRight then
  begin
    p := ClientToScreen(Point(Self.Left, Self.Top));

    // Get the cordinates on the screen where the popup should appear.
    p := ClientToScreen(Point(0, Self.Height));
    if p.Y > Monitor.Top + Monitor.Height div 2 then
      p.Y := p.Y - Self.Height;

    // Show the menu
    MenuPopup.Popup(p.X, p.Y);
  end;
end;

procedure TMainForm.lb_clockClick(Sender: TObject);
var
  pos: TPoint;
begin
  GetCursorPos(pos);

  FTimeCalendar.Show(pos.x, pos.y);
end;

procedure TMainForm.lb_clockDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('timedate.cpl');
end;

procedure TMainForm.Configure1Click(Sender: TObject);
var
  cfile : string;
begin
  cfile := SharpApi.GetCenterDirectory + '_Modules\Clock.con';

  if FileExists(cfile) then
    SharpCenterApi.CenterCommand(sccLoadSetting,
      PChar(cfile),
      PChar(inttostr(mInterface.BarInterface.BarID) + ':' + inttostr(mInterface.ID)));
end;

procedure TMainForm.FormClick(Sender: TObject);
begin
  lb_clockClick(lb_clock);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FTimeCalendar := TTimeCalendar.Create;

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
  FTimeCalendar.Free;

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
