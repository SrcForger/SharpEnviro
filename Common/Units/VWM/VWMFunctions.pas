{
Source Name: VWMFunctions.pas
Description: Basic VWM functions
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit VWMFunctions;

interface

uses
  Windows,
  Messages,
  Forms,
  Types,
  MonitorList,
  Math;

type
  TWndArray = array of hwnd;

var
  VWMSpacing : integer;

function WindowInRect(wnd : hwnd; Rect : TRect) : boolean;  
function VWMGetWindowList(pArea : TRect) : TWndArray;
function VWMGetDeskArea(CurrentVWM,index : integer) : TRect;
procedure VWMSwitchDesk(pCurrentDesk,pNewDesk : integer; sFocusTopMost : boolean; pExceptWnd : hwnd = 0);
procedure VWMMoveAllToOne(CurrentVWM : integer; broadcast : boolean);
function VWMGetWindowVWM(pCurrentVWM,pVWMCount : integer; pHandle : hwnd) : integer;
procedure VWMMoveWindotToVWM(pTargetVWM,pCurrentVWM,pVWMCount : integer; pHandle : hwnd);

implementation

uses
  uSystemFuncs,
  SharpApi;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

function WindowInRect(wnd : hwnd; Rect : TRect) : boolean;
var
  WPos : TRect;
begin
  GetWindowRect(wnd,WPos);
  if (PointInRect(Point(WPos.Left + (WPos.Right - WPos.Left) div 2,
                        WPos.Top + (WPos.Bottom - WPos.Top) div 2), Rect))
     or (PointInRect(Point(WPos.Left + 10,WPos.Top), Rect))
     or (PointInRect(Point(WPos.Right - 10,
                           WPos.Top), Rect))
     or (PointInRect(Point(WPos.Right - 10,
                           WPos.Bottom),Rect))
     or (PointInRect(Point(WPos.Left + 10,
                           WPos.Bottom),Rect)) then
    result := True
  else result := False;
end;

procedure VWMMoveWindotToVWM(pTargetVWM,pCurrentVWM,pVWMCount : integer; pHandle : hwnd);
var
  wndVWM : integer;
  distance : integer;
  wndPos : TRect;
begin
  if not IsWindow(pHandle) then
    exit;

  wndVWM := VWMGetWindowVWM(pCurrentVWM,pVWMCount,pHandle);
  if pTargetVWM = wndVWM then
    exit;

  if pCurrentVWM = pTargetVWM then
  begin
    distance := (wndVWM) * (MonList.DesktopWidth + VWMSpacing);
    GetWindowRect(pHandle,wndpos);
    SetWindowPos(pHandle,0,wndpos.Left - distance,wndpos.Top,0,0,SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOSIZE);
  end
  else
  if pCurrentVWM = wndVWM then
  begin
    distance := (pTargetVWM) * (MonList.DesktopWidth + VWMSpacing);
    GetWindowRect(pHandle,wndpos);
    SetWindowPos(pHandle,0,wndpos.Left + distance,wndpos.Top,0,0,SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOSIZE);
    if VWMGetWindowVWM(pCurrentVWM,pVWMCount,pHandle) = pCurrentVWM then
      SetWindowPos(pHandle,0,wndpos.Left + 2 * distance,wndpos.Top,0,0,SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOSIZE);
  end
  else
  begin
    distance := (pTargetVWM - wndVWM) * (MonList.DesktopWidth + VWMSpacing);
    GetWindowRect(pHandle,wndpos);
    SetWindowPos(pHandle,0,wndpos.Left + distance,wndpos.Top,0,0,SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOSIZE);
  end;
  PostMessage(GetShellTaskMgrWindow,WM_TASKVWMCHANGE,pHandle,pTargetVWM);
end;

function VWMGetWindowVWM(pCurrentVWM,pVWMCount : integer; pHandle : hwnd) : integer;
var
  WPos : TRect;
  n: Integer;
  VWMRect : TRect;
begin
  result := 0;
  if not IsWindow(pHandle) then
    exit;

  GetWindowRect(pHandle,WPos);
  if WindowInRect(pHandle,MonList.DesktopRect) then
  begin
    // Current VWM!
    result := pCurrentVWM;
    exit;
  end;

  result := 0;
  for n := 0 to pVWMCount do
  begin
    VWMRect := VWMGetDeskArea(pCurrentVWM,n);
    VWMRect.Left := VWMRect.Left - VWMSpacing div 2;
    VWMRect.Right := VWMRect.Right + VWMSpacing div 2;
    if WindowInRect(pHandle,VWMRect) then
    begin
      result := n + 1;
      break;
    end;
  end;

  if result > pVWMCount then
    result  := pVWMCount
  else
  if result = 0 then
    result := 1;
end;

function VWMGetDeskArea(CurrentVWM,index : integer) : TRect;
begin
  if (index + 1 <> CurrentVWM) then
    index := index + 1
  else index := 0;
  result.Left := MonList.DesktopLeft + index * MonList.DesktopWidth + Max(0,index - 1) * VWMSpacing;
  result.Right := MonList.DesktopLeft + (index + 1) * MonList.DesktopWidth + Max(0,index - 1) * VWMSpacing;
  result.Top := MonList.DesktopTop;
  result.Bottom := MonList.DesktopTop + MonList.DesktopHeight;
end;

function VWMGetWindowList(pArea : TRect) : TWndArray;
type
  PParam = ^TParam;
  TParam = record
    wndlist: TWndArray;
  end;
var
  EnumParam : TParam;

  function EnumWindowsProc(Wnd: HWND; LParam: LPARAM): BOOL; stdcall;
  begin
    if ((GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) or
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_APPWINDOW <> 0)) and
       ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
       (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
       (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))  then
    begin
      if ((pArea.Right - pArea.Left) = 0) or (WindowInRect(wnd,pArea)) then
      with PParam(LParam)^ do
      begin
       setlength(wndlist,length(wndlist)+1);
       wndlist[high(wndlist)] := wnd;
      end;
    end;
    result := True;
  end;

begin
  setlength(EnumParam.wndlist,0);
  EnumWindows(@EnumWindowsProc, Integer(@EnumParam));
  result := EnumParam.wndlist;
  setlength(EnumParam.wndlist,0);
end;

procedure VWMSwitchDesk(pCurrentDesk,pNewDesk : integer; sFocusTopMost : boolean; pExceptWnd : hwnd = 0);
var
  n : integer;
  distance : integer;
  wndpos : TRect;
  SrcList : TWndArray;
  DstList : TWndArray;
  R : TRect;
begin
  // Move the windows from the Src to the Dst Desktop
  R := MonList.DesktopRect;
  distance := (pCurrentDesk) * (MonList.DesktopWidth + VWMSpacing);
  SrcList := VWMGetWindowList(R);
  for n := 0 to High(SrcList) do
  begin
    if SrcList[n] <> pExceptWnd then
    begin
      GetWindowRect(SrcList[n],wndpos);
      SetWindowPos(SrcList[n],0,wndpos.Left + distance,wndpos.Top,0,0,SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOSIZE);
    end;
  end;

  // Move the windows from the Dst to the Src Desktop
  R := MonList.DesktopRect;
  distance := (pNewDesk) * (MonList.DesktopWidth + VWMSpacing);
  R.Left := R.Left + distance;
  R.Right := R.Right + distance;
  DstList := VWMGetWindowList(R);
  for n := 0 to High(DstList) do
  begin
    if DstList[n] <> pExceptWnd then
    begin
      GetWindowRect(DstList[n],wndpos);
      SetWindowPos(DstList[n],0,wndpos.Left - distance,wndpos.Top,0,0,SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOSIZE);
    end;
  end;

  if (sFocusTopMost) and (length(DstList) > 0) then
    ForceForeGroundWindow(DstList[0]);

  setlength(SrcList,0);
  setlength(DstList,0);
end;

procedure VWMMoveAllToOne(CurrentVWM : integer; broadcast : boolean);
var
  wndlist : TWndArray;
  wndpos : TRect;
  n : integer;
  desknr : integer;
  distance : integer;
  shellwnd : hwnd;
begin
  wndlist := VWMGetWindowList(Rect(0,0,0,0));
  shellwnd := GetShellTaskMgrWindow;
  for n := 0 to High(wndlist) do
  begin
    GetWindowRect(wndlist[n],wndpos);
    if not (PointInRect(Point(wndpos.Left + (wndpos.Right - wndpos.Left) div 2,
                              wndpos.Top + (wndpos.Bottom - wndpos.Top) div 2), MonList.DesktopRect)) then
    begin
      desknr := round(Int(wndpos.Left / (MonList.DesktopWidth + VWMSpacing)));
      if wndpos.left < MonList.DesktopLeft then
        distance := (desknr - 1) * (MonList.DesktopWidth + VWMSpacing)
      else distance := (desknr + 1) * (MonList.DesktopWidth + VWMSpacing);
      SetWindowPos(wndlist[n],0,wndpos.Left - distance,wndpos.Top,0,0,SWP_NOACTIVATE or SWP_NOOWNERZORDER or SWP_NOSIZE);
      if broadcast then
        PostMessage(shellwnd,WM_TASKVWMCHANGE,wndlist[n],CurrentVWM);
    end;
  end;
  setlength(wndlist,0);
end;

Initialization
   VWMSpacing := 32;

end.
