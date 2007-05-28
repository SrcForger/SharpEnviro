{
Source Name: ToolTipApi
Description: usefull functions for using windows tooltips
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

unit ToolTipApi;

interface

uses
   SysUtils,Controls,Classes,Windows,Messages,Commctrl;


function RegisterToolTip(Control: TWinControl) : hwnd;
procedure EnableToolTip(TipWnd : hwnd);
procedure DisableToolTip(TipWnd : hwnd);
procedure AddToolTip(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect; Text : String);
procedure AddToolTipByCallBack(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect);
procedure DeleteToolTip(TipWnd : hwnd; Control: TWinControl; ID : integer);
procedure UpdateToolTipText(TipWnd : hwnd; Control: TWinControl; ID : integer; Text : String);
procedure UpdateToolTipTextByCallBack(TipWnd : hwnd; Control: TWinControl; ID : integer);
procedure UpdateToolTipRect(TipWnd : hwnd; Control: TWinControl; ID : integer; Rect : TRect);

const
 TTS_NOANIMATE = $10;
 TTS_NOFADE = $20;


implementation

                                                                 
function RegisterToolTip(Control: TWinControl) : hwnd;
var
  hWnd, hWndTip: THandle;
begin
  hWnd    := Control.Handle;
  hWndTip := CreateWindow(TOOLTIPS_CLASS, nil,
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
