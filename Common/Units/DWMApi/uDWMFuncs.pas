{Source Name: uDWMFuncs
Description: Provides dynamically loaded DWM functions (for compatibility with XP)
Copyright (C) Mathias Tillman mathias@sharpenviro.com

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
unit uDWMFuncs;

interface

uses Windows,
      SharpApi;

const
  DWMWA_EXTENDED_FRAME_BOUND = 9;
  DWMWA_DISALLOW_PEEK = 12;

function DwmIsCompositionEnabled(var Enabled: Boolean): HRESULT;
function DwmGetWindowAttribute(hwnd: HWND; dwAttribute: DWORD; pvAttribute: Pointer; cbAttribute: DWORD): HRESULT;
function DwmSetWindowAttribute(hwnd: HWND; dwAttribute: DWORD; pvAttribute: Pointer; cbAttribute: DWORD): HRESULT;

// Peek
procedure DwmPeekDesktop;
procedure DwmStopPeekDesktop;
procedure DwmPeekWindow(wnd: HWND);
procedure DwmStopPeekWindow;

implementation

var
  FDWMDll : THandle;
  FDwmIsCompositionEnabled: function(var Enabled: BOOL): HRESULT; stdcall;
  FDwmGetWindowAttribute: function(hwnd: HWND; dwAttribute: DWORD; pvAttribute: Pointer; cbAttribute: DWORD): HRESULT; stdcall;
  FDwmSetWindowAttribute: function(hwnd: HWND; dwAttribute: DWORD; pvAttribute: Pointer; cbAttribute: DWORD): HRESULT; stdcall;

function DwmIsCompositionEnabled(var Enabled: Boolean): HRESULT;
var
  e: BOOL;
begin
  Result := S_FALSE;
  e := False;

  if Assigned(FDwmIsCompositionEnabled) then
    Result := FDwmIsCompositionEnabled(e);

  Enabled := e;
end;

function DwmGetWindowAttribute(hwnd: HWND; dwAttribute: DWORD; pvAttribute: Pointer; cbAttribute: DWORD): HRESULT;
begin
  Result := S_FALSE;
  
  if Assigned(FDwmGetWindowAttribute) then
    Result := FDwmGetWindowAttribute(hwnd, dwAttribute, pvAttribute, cbAttribute);
end;

function DwmSetWindowAttribute(hwnd: HWND; dwAttribute: DWORD; pvAttribute: Pointer; cbAttribute: DWORD): HRESULT;
begin
  Result := S_FALSE;
  
  if Assigned(FDwmSetWindowAttribute) then
    Result := FDwmSetWindowAttribute(hwnd, dwAttribute, pvAttribute, cbAttribute);
end;

procedure DwmPeekDesktop;
var
  b: Boolean;
begin
  if IsWindowVisible(FindWindow('TSharpDeskMainForm', nil)) then
  begin
    DwmPeekWindow(FindWindow('TSharpDeskMainForm', nil));
    exit;
  end;

  DwmIsCompositionEnabled(b);
  if b then
    PostMessage(FindWindow('TSharpExplorerForm', nil), WM_AEROPEEKDESKTOP, FindWindow('Shell_TrayWnd', nil), 0);
end;

procedure DwmStopPeekDesktop;
var
  b: Boolean;
begin
  DwmIsCompositionEnabled(b);
  if b then
    PostMessage(FindWindow('TSharpExplorerForm', nil), WM_AEROPEEKSTOPDESKTOP, 0, 0);
end;

procedure DwmPeekWindow(wnd: HWND);
var
  b: Boolean;
begin
  DwmIsCompositionEnabled(b);
  if b then
    PostMessage(FindWindow('TSharpExplorerForm', nil), WM_AEROPEEKWINDOW, FindWindow('Shell_TrayWnd', nil), wnd);
end;

procedure DwmStopPeekWindow;
var
  b: Boolean;
begin
  DwmIsCompositionEnabled(b);
  if b then
    PostMessage(FindWindow('TSharpExplorerForm', nil), WM_AEROPEEKSTOPWINDOW, 0, 0);
end;

initialization
  FDWMDll := LoadLibrary('dwmapi.dll');
  if FDWMDll <> 0 then
  begin
    @FDwmIsCompositionEnabled := GetProcAddress(FDWMDll, 'DwmIsCompositionEnabled');
    @FDwmGetWindowAttribute := GetProcAddress(FDWMDll, 'DwmGetWindowAttribute');
    @FDwmSetWindowAttribute := GetProcAddress(FDWMDll, 'DwmSetWindowAttribute');
  end;

finalization
  if FDWMDll <> 0 then
    FreeLibrary(FDWMDll);

end.
