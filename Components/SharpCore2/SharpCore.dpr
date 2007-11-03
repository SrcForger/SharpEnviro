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
  Windows,
  Messages,
  ShellAPI,
  SharpAPI,
  Classes,
  SysUtils,
  uComponentMan in 'uComponentMan.pas';

{$R *.res}
{$R metadata.res}

const
  WM_ICONTRAY = WM_USER + 1;
  ID_EXIT = 1;
  ID_SHUTDOWN = 2;
  ID_REBOOT = 3;
  ID_SHELLSWITCH = 4;

var
  wclClass: TWndClass;
  wndMsg: TMsg;
  nidTray: TNotifyIconData;
  menPopup: HMenu;
  curPoint: TPoint;
  menServices: HMenu;
  hndMutex: THandle;
  stlCmdLine: TStringList;
  i: Integer;
  bDebug: Boolean;
  strExtension: String;
  bReboot: Boolean;
  wndDebug: Integer;
  lstComponents: TComponentList;

procedure DebugMsg(Msg: String; MsgType: Integer = DMT_TRACE);
begin
  SendDebugMessageEx(PChar('SharpCore'), PChar(Msg), 0, MsgType);
end;

procedure BuildMenu();
var
  strName: String;
  i: integer;
  modData: TComponentData;
begin
  DebugMsg('Creating popup menu');
  menPopup := CreatePopupMenu; // Create menu and submenu for services
  menServices := CreatePopupMenu;

  for i := 0 to lstComponents.Count - 1 do
  begin
    modData := TComponentData(lstComponents.Items[i]^);
    strName := modData.MetaData.Name;
    if modData.MetaData.DataType = tteService then // we only want to list services
      AppendMenu(menServices, 0, modData.ID, PChar(strName));
  end;

  AppendMenu(menPopup, MF_POPUP, menServices, 'Services');
  AppendMenu(menPopup, 0, ID_SHELLSWITCH, 'Set Explorer as shell');
  AppendMenu(menPopup, MF_SEPARATOR, 0, nil);
  AppendMenu(menPopup, 0, ID_REBOOT, 'Reboot SharpE');
  AppendMenu(menPopup, 0, ID_SHUTDOWN, 'Shutdown SharpE');
  AppendMenu(menPopup, 0, ID_EXIT, 'Exit SharpCore');
end;

procedure RunAll();
var
  i: integer;
  modData: TComponentData;
  hndFile: THandle;
begin

end;

function WindowProc(hWnd,Msg,wParam,lParam:Integer):Integer; stdcall;
begin
  case Msg of
    WM_DESTROY: PostQuitMessage(0);

    WM_CLOSE: begin
      Shell_NotifyIcon(NIM_DELETE, @nidTray);  // Make sure we remove tray icon
      DestroyMenu(menPopup);
      lstComponents.Free;
    end;

    WM_CREATE: begin    // Create and display tray icon
      DebugMsg('Creating tray icon');
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
      lstComponents := TComponentList.Create;
      lstComponents.BuildList(strExtension); //enumerate services and components
      BuildMenu;
    end;

    WM_ICONTRAY: begin // User clicked tray icon, lParam stores which button they used
      case lParam of
        WM_RBUTTONDOWN: begin
          GetCursorPos(curPoint); // Cursor position so we know where to put the menu
          SetForegroundWindow(hWnd);
          TrackPopupMenu(menPopup, 0, curPoint.X, curPoint.Y, 0, hWnd, nil); // Display menu
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

 stlCmdLine := TStringList.Create;

 bDebug := False;
 bReboot := False;
 strExtension := '.service';
 wndDebug := 0;
 stlCmdLine.DelimitedText := GetCommandLine;
 for i := 0 to stlCmdLine.Count - 1 do
 begin
   if LowerCase(stlCmdLine[i]) = '-debug' then bDebug := True;
   if LowerCase(stlCmdLine[i]) = '-reboot' then bReboot := True;
   if (LowerCase(stlCmdLine[i]) = '-ext') then
    if (i + 1) <= (stlCmdLine.Count - 1) then
      strExtension := stlCmdLine[i + 1]
    else
      strExtension := '.service';
 end;
 stlCmdLine.Free;

 if bDebug then
 begin
  if ShellExecute(hInstance, 'open', PChar(GetSharpEDirectory + 'SharpConsole.exe'),
   '', PChar(GetSharpEDirectory), 0) = 0 then
    begin
      while wndDebug = 0 do //wait for SharpConsole to open
        wndDebug := FindWindow('TSharpConsoleWnd', nil);
      DebugMsg('Debug flag found, started SharpConsole'); //would be silly to send the message if sharpconsole isn't open yet
    end
  else
    DebugMsg('SharpConsole could not be started');
 end;

 if bReboot then DebugMsg('Reboot flag found'); //need to add sharpe reboot code
 DebugMsg('Starting with service extension ' + strExtension);

 DebugMsg('Checking mutex');
 hndMutex := CreateMutex(nil, TRUE, 'SharpCore');
 if hndMutex <> 0 then
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    DebugMsg('Mutex already exists, exiting');
    CloseHandle(hndMutex);
    Exit;
  end;

 DebugMsg('Creating main window');
 wclClass.lpszClassName:= 'SharpCore';
 wclClass.lpfnWndProc :=  @WindowProc;
 wclClass.hInstance := hInstance;
 wclClass.hbrBackground:= 1;
 wclClass.hIcon := LoadIcon(hInstance, 'MAINICON');

 Windows.RegisterClass(wclClass);

 CreateWindow(wclClass.lpszClassName, 'SharpCore', 0,
              10, 10, 340, 220, 0, 0, hInstance, nil);

 while GetMessage(wndMsg, 0, 0, 0) do DispatchMessage(wndMsg);

end.
