{
Source Name: SharpCore
Description: Core component for loading services and other components
Copyright (C) Nathan LaFreniere

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

program SharpCore;

uses
  Windows, Messages, ShellAPI;

{$R *.res}

const
  WM_ICONTRAY = WM_USER + 1;
  ID_EXIT = 1;

var
  wndClass: TWndClass;
  wndMsg: TMsg;
  nidTray: TNotifyIconData;
  menPopup: HMenu;
  curPoint: TPoint;
  menServices: HMenu;

procedure BuildMenu();
begin
  menPopup := CreatePopupMenu; // Create menu and submenu for services
  menServices := CreatePopupMenu;

  AppendMenu(menPopup, MF_POPUP, menServices, 'Services');
  AppendMenu(menPopup, MF_SEPARATOR, 0, 0);
  AppendMenu(menPopup, 0, ID_EXIT, 'Exit');
end;

function WindowProc(hWnd,Msg,wParam,lParam:Integer):Integer; stdcall;
begin
  case Msg of
    WM_DESTROY: PostQuitMessage(0);

    WM_CLOSE: Shell_NotifyIcon(NIM_DELETE, @nidTray);  // Make sure we remove tray icon

    WM_CREATE: begin    // Create and display tray icon
      with nidTray do
      begin
        cbSize := SizeOf(nidTray);
        Wnd := hWnd;
        uID := 0;
        uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
        uCallbackMessage := WM_ICONTRAY;
        hIcon := LoadIcon(hInstance, 'MAINICON');
        szTip := 'SharpCore';
      end;
      Shell_NotifyIcon(NIM_ADD, @nidTray);
      BuildMenu;
    end;

    WM_ICONTRAY: begin // User clicked tray icon, lParam stores which button they used
      case lParam of
        WM_RBUTTONDOWN: begin
          GetCursorPos(curPoint); // Cursor position so we know where to put the menu
          SetForegroundWindow(hWnd);
          TrackPopupMenu(menPopup, 0, curPoint.X, curPoint.Y, 0, hWnd, nil); // Display menu
          DestroyMenu(menPopup);
        end;
      end;
    end;

    WM_COMMAND: begin // Menu commands
      case LoWord(wParam) of
        ID_EXIT: SendMessage(hWnd, WM_CLOSE, 0, 0);
      end;
    end;

  end;
 Result := DefWindowProc(hWnd,Msg,wParam,lParam);
end;

begin

 wndClass.lpszClassName:= 'SharpCore';
 wndClass.lpfnWndProc :=  @WindowProc;
 wndClass.hInstance := hInstance;
 wndClass.hbrBackground:= 1;
 wndClass.hIcon := LoadIcon(hInstance, 'MAINICON');

 RegisterClass(wndClass);

 CreateWindow(wndClass.lpszClassName, 'SharpCore', 0,
              10, 10, 340, 220, 0, 0, hInstance, nil);

 while GetMessage(wndMsg, 0, 0, 0) do DispatchMessage(wndMsg);

end.
