{
Source Name: ToolTipApi
Description: usefull functions for using windows tooltips
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

unit ToolTipApi;

interface

uses
   SysUtils,Controls,Classes,Windows,Messages,Commctrl;


function RegisterBallonWindow(Control : TWinControl) : hwnd;
procedure AddBalloonWindowCallBack(BWnd : hwnd; Control : TWinControl; ID : integer; Icon : integer; Titel : String; Rect : TRect);
procedure SetBalloonPosition(BWnd : hwnd; X,Y : integer);
procedure SetBalloonTracking(BWnd : hwnd; Control: TWinControl; ID : integer;Activate : boolean);

function RegisterToolTip(Control: TWinControl) : hwnd;
procedure EnableToolTip(TipWnd : hwnd);
procedure DisableToolTip(TipWnd : hwnd);
procedure SetTipTitel(TipWnd : hwnd; Icon : integer; Titel : String);
procedure AddToolTip(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect; Text : String);
procedure AddToolTipByCallBack(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect);
procedure DeleteToolTip(TipWnd : hwnd; Control: TWinControl; ID : integer);
procedure UpdateToolTipText(TipWnd : hwnd; Control: TWinControl; ID : integer; Text : String);
procedure UpdateToolTipTextByCallBack(TipWnd : hwnd; Control: TWinControl; ID : integer);
procedure UpdateToolTipRect(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect);

const
 TTS_NOANIMATE = $10;
 TTS_NOFADE = $20;
 TTM_SETTITLE = (WM_USER + 32);


implementation

procedure SetBalloonPosition(BWnd : hwnd; X,Y : integer);
begin
  SendMessage(BWnd, TTM_TRACKPOSITION, 0, MAKELONG(x,y));
end;

procedure SetBalloonTracking(BWnd : hwnd; Control: TWinControl; ID : integer; Activate : boolean);
var
  ti: TToolInfo;
begin
  ti.cbSize := SizeOf(ti);
  ti.hwnd := Control.Handle;
  ti.uId := Id;
  if Activate then
    SendMessage(BWnd, TTM_TRACKACTIVATE , 1, Integer(@ti))
  else SendMessage(BWnd, TTM_TRACKACTIVATE , 0, Integer(@ti)); 
end;

function RegisterBallonWindow(Control : TWinControl) : hwnd;
var
  hWnd, hWndB: THandle;
begin
  hWnd    := Control.Handle;
  hWndB   := CreateWindowEx(WS_EX_TOPMOST,TOOLTIPS_CLASS, nil,
                          WS_POPUP or TTS_BALLOON or TTS_NOPREFIX or TTS_ALWAYSTIP or TTS_NOFADE or TTS_NOANIMATE,
                          0, 0, 0, 0, hWnd, 0, HInstance, nil);
  if hWndB <> 0 then
     SetWindowPos(hWndB, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

  result := hWndB;
end;

procedure AddBalloonWindowCallBack(BWnd : hwnd; Control : TWinControl; ID : integer; Icon : integer; Titel : String; Rect : TRect);
var
  ti: TToolInfo;
  P : PChar;
begin
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS;
  ti.hwnd := Control.Handle;
  ti.lpszText := LPSTR_TEXTCALLBACK;
  ti.lpszText := PChar(Titel);
  ti.uId := Id;
  ti.rect := Rect;
  P := PChar(Titel);
  SendMessage(BWnd, TTM_ADDTOOL, 0, Integer(@ti));
  SendMessagE(BWnd, TTM_SETTITLE, 1, Integer(P));
end;

procedure SetTipTitel(TipWnd : hwnd; Icon : integer; Titel : String);
var
  P : PChar;
begin
  P := PChar(Titel);
  SendMessagE(TipWnd, TTM_SETTITLE, Icon, Integer(P));
end;


function RegisterToolTip(Control: TWinControl) : hwnd;
var
  hWnd, hWndTip: THandle;
begin
  hWnd    := Control.Handle;
  hWndTip := CreateWindowEx(WS_EX_TOPMOST, TOOLTIPS_CLASS, nil,
                          WS_POPUP or TTS_NOPREFIX or TTS_ALWAYSTIP or TTS_NOFADE or TTS_NOANIMATE,
                          0, 0, 0, 0, hWnd, 0, HInstance, nil);
  if hWndTip <> 0 then
     SetWindowPos(hWndTip, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);

  result := hWndTip;
end;

procedure UpdateToolTipTextByCallback(TipWnd : hwnd; Control: TWinControl; ID : integer);
var
  ti: TToolInfo;
begin
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS;
  ti.hwnd := Control.Handle;
  ti.lpszText := LPSTR_TEXTCALLBACK;
  ti.uId := ID;
  SendMessage(TipWnd, TTM_UPDATETIPTEXT, 0, Integer(@ti));
end;

procedure UpdateToolTipText(TipWnd : hwnd; Control: TWinControl; ID : integer; Text : String);
var
  ti: TToolInfo;
begin
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS;
  ti.hwnd := Control.Handle;
  ti.lpszText := PChar(Text);
  ti.uId := ID;
  SendMessage(TipWnd, TTM_UPDATETIPTEXT, 0, Integer(@ti));
end;

procedure UpdateToolTipRect(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect);
var
  ti: TToolInfo;
begin
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS;
  ti.hwnd := Control.Handle;
  ti.Rect := Rect;
  ti.uId := ID;
  SendMessage(TipWnd, TTM_NEWTOOLRECT, 0, Integer(@ti));
end;

procedure AddToolTipByCallBack(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect);
var
  ti: TToolInfo;
begin
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS;
  ti.hwnd := Control.Handle;
  ti.lpszText := LPSTR_TEXTCALLBACK;
  ti.uId := ID;
  ti.rect := Rect;
  SendMessage(TipWnd, TTM_ADDTOOL, 0, Integer(@ti));
end;

procedure AddToolTip(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect; Text : String);
var
  ti: TToolInfo;
begin
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS;
  ti.hwnd := Control.Handle;
  ti.lpszText := PChar(Text);
  ti.uId := ID;
  ti.rect := Rect;
  SendMessage(TipWnd, TTM_ADDTOOL, 0, Integer(@ti));
end;

procedure DeleteToolTip(TipWnd : hwnd; Control: TWinControl; ID : integer);
var
  ti: TToolInfo;
begin
  ti.cbSize := SizeOf(ti);
  ti.uFlags := TTF_TRANSPARENT or TTF_SUBCLASS;
  ti.hwnd := Control.Handle;
  ti.uId := ID;
  SendMessage(TipWnd, TTM_DELTOOL, 0, Integer(@ti));
end;

procedure EnableToolTip(TipWnd : hwnd);
begin
  SendMessage(TipWnd, TTM_ACTIVATE, 1, 0);
end;

procedure DisableToolTip(TipWnd : hwnd);
begin
  SendMessage(TipWnd, TTM_ACTIVATE, 0, 0);
end;

end.
