{
Source Name: uTimeCalendar.pas
Description: Shows the built-in Windows calendar
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

unit uTimeCalendar;

interface

uses Windows, Forms, Classes, ActiveX, ComObj, SysUtils;

const
  Class_TimeDateCPL: TGUID =
      '{A323554A-0FE1-4E49-AEE1-6722465D799F}';
  IID_TimeDateCPL : TGUID =
      '{A323554A-0FE1-4E49-AEE1-6722465D799F}';

  TimeCalendarWidth: integer = 263;
  TimeCalendarHeight: integer = 241;

type
  ITimeDateCPL = interface(IUnknown)
      ['{4376DF10-A662-420B-B30D-958881461EF9}']
      function ShowCalendar(position: integer; rcPos: PRect): Integer; stdcall;
      function Quit: Integer; stdcall;
      function ShowTooltip: Integer; stdcall;
      function UpdateCalendar: Integer; stdcall;
      function Unkown: Integer; stdcall;
  end;

  TTimeCalendar = class
  private
    FTimeDateCPL: ITimeDateCPL;

  public
    constructor Create;
    destructor Destroy; override;

    procedure Show(wnd: TForm);
    
  end;

implementation

constructor TTimeCalendar.Create;
begin
  CoInitialize(nil);
  if CoCreateInstance(
      Class_TimeDateCPL,
      nil,
      CLSCTX_INPROC_SERVER,
      ITimeDateCPL,
      FTimeDateCPL) <> S_OK then
    FTimeDateCPL := nil;
end;

destructor TTimeCalendar.Destroy;
begin
  FTimeDateCPL := nil;

  CoUninitialize;
end;

procedure TTimeCalendar.Show(wnd: TForm);
var
  rc, clockRc, clockClientRc: TRect;

  osVerInfo: TOSVersionInfo;
  clockWnd: HWND;
  w, h: integer;
  ptDiff: TPoint;
begin
  if not Assigned(FTimeDateCPL) then
    exit;

  GetWindowRect(wnd.Handle, rc);

  FTimeDateCPL.UpdateCalendar;
  FTimeDateCPL.ShowCalendar(0, @rc);

  // Fix Vista positioning
  clockWnd := FindWindowA('ClockFlyoutWindow', nil);
  GetClientRect(clockWnd, clockClientRc);
  GetWindowRect(clockWnd, clockRc);

  ptDiff.X := 15;
  ptDiff.Y := 15;
  osVerInfo.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(osVerInfo) then
    if osVerInfo.dwMajorVersion <> 7 then
    begin
      ptDiff.X := 0;
      ptDiff.Y := 0;
    end;

  w := (clockRc.Right - clockRc.Left);
  h := (clockRc.Bottom - clockRc.Top);

  clockRc.Left := (rc.Left + ((rc.Right - rc.Left) div 2)) - (w div 2) + ptDiff.X;
  if (rc.Top > 1) then
    clockRc.Top := rc.Top - h - ptDiff.Y
  else
    clockRc.Top := rc.Top + (rc.Bottom - rc.Top) + ptDiff.Y;

  if clockRc.Top <= 0 then
    clockRc.Top := rc.Top + (rc.Bottom - rc.Top) + ptDiff.Y;
  if clockRc.Top > wnd.Monitor.Height - h - ptDiff.Y then
    clockRc.Top := wnd.Monitor.Height - h - ptDiff.Y;
  if clockRc.Left <= 0 then
    clockRc.Left := ptDiff.X;
  if clockRc.Left > wnd.Monitor.Width - w - ptDiff.X then
    clockRc.Left := wnd.Monitor.Width - w - ptDiff.X;

  SetWindowPos(clockWnd, 0, clockRc.Left, clockRc.Top, w, h, SWP_NOACTIVATE or SWP_NOZORDER);
end;

end.
