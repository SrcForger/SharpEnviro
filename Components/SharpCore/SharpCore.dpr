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

{$R 'metadata.res'}
{$R 'VersionInfo.res'}
{$R *.res}

uses
//  VCLFixPack,
  Forms,
  Windows,
  Messages,
  ActiveX,
  ShellAPI,
  SharpAPI,
  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts,
  SharpCenterApi,
  Classes,
  SysUtils,
  uVistaFuncs,
  uSharpESkinInterface,
  uISharpESkin,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uComponentMan in 'uComponentMan.pas';

const
  WM_ICONTRAY = WM_USER + 1;
  ID_EXIT = 1;
  ID_SHUTDOWN = 2;
  ID_REBOOT = 3;
  ID_SHELLSWITCH = 4;

var
  SkinInterface: TSharpESkinInterface;
  ISkinInterface: ISharpESkinInterface;
  wclClass: TWndClass;
  wndMsg: TMsg;
  nidTray: TNotifyIconData;
  menPopup: HMenu;
  curPoint: TPoint;
  menServices: HMenu;
  hndMutex: THandle;
  stlCmdLine: TStringList;
  i: Integer;
  sAction : string;
  bDebug: Boolean;
  bDoStartup: Boolean;
  strExtension: string;
  bReboot: Boolean;
  wndDebug: Integer;
  lstComponents: TComponentList;
  hndWindow: THandle;
  TaskBarCreated: Integer;
  shellInit : boolean;

function ProcessMessage(var Msg: TMsg): Boolean;
var
  Unicode: Boolean;
  MsgExists: Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_NOREMOVE) then
  begin
    Unicode := (Msg.hwnd <> 0) and IsWindowUnicode(Msg.hwnd);
    if Unicode then
      MsgExists := PeekMessageW(Msg, 0, 0, 0, PM_REMOVE)
    else
      MsgExists := PeekMessage(Msg, 0, 0, 0, PM_REMOVE);
    if not MsgExists then Exit;
    Result := True;
    if Msg.Message <> WM_QUIT then
    begin
      TranslateMessage(Msg);
      if Unicode then
        DispatchMessageW(Msg)
      else
        DispatchMessage(Msg);
    end
    //else
     // FTerminate := True;
  end;
end;

procedure DebugMsg(Msg: string; MsgType: Integer = DMT_TRACE);
begin
  SendDebugMessageEx(PChar('SharpCore'), PChar(Msg), 0, MsgType);
end;

procedure BuildMenu();
var
  strName: string;
  i: integer;
  modData: TComponentData;
begin
  DebugMsg('Creating popup menu');
  menPopup := CreatePopupMenu; // Create menu and submenu for services
  menServices := CreatePopupMenu;

  for i := 0 to lstComponents.Count - 1 do begin
    modData := TComponentData(lstComponents.Items[i]);
    strName := modData.MetaData.Name;
    if modData.MetaData.DataType = tteService then // we only want to list services
      AppendMenu(menServices, 0, modData.ID, PChar(strName));
  end;

  AppendMenu(menPopup, MF_POPUP, menServices, 'Services');
  AppendMenu(menPopup, 0, ID_SHELLSWITCH, 'Change Shell');
  AppendMenu(menPopup, MF_SEPARATOR, 0, nil);
  AppendMenu(menPopup, 0, ID_REBOOT, 'Reboot SharpE');
  AppendMenu(menPopup, 0, ID_SHUTDOWN, 'Shutdown SharpE');
  AppendMenu(menPopup, 0, ID_EXIT, 'Exit SharpCore');
end;

function StartService(var modData: TComponentData): Integer;
type
  TStartFunc   = function(owner: hwnd): hwnd;
  TStartFuncEx = function(owner: hwnd; pSkinInterface : ISharpESkinInterface): hwnd;
const
  StartFunc:   TStartFunc = nil;
  StartFuncEx: TStartFuncEx = nil;
begin
  Result := 1;
  if (modData.MetaData.DataType = tteService) and (not modData.Running) and (not modData.Disabled) then
  begin
    modData.FileHandle := LoadLibrary(PChar(modData.FileName));
    @StartFunc   := GetProcAddress(modData.FileHandle, 'Start');
    @StartFuncEx := GetProcAddress(modData.FileHandle, 'StartEx');
    if Assigned(StartFunc) or Assigned(StartFuncEx) then
    begin
      DebugMsg('Starting ' + modData.MetaData.Name);
      if Assigned(StartFunc) then
        StartFunc(hndWindow)
      else StartFuncEx(hndWindow, ISkinInterface);
      CheckMenuItem(menServices, modData.ID, MF_CHECKED);
      modData.Running := True;
    end;
  end;
end;

function StopService(var modData: TComponentData): Integer;
type
  TStopFunc = procedure;
const
  StopFunc: TStopFunc = nil;
begin
  result := 1;
  @StopFunc := GetProcAddress(modData.FileHandle, 'Stop');
  if Assigned(StopFunc) then begin
    DebugMsg('Stopping ' + modData.MetaData.Name);
    StopFunc();
    modData.Running := False;
    CheckMenuItem(menServices, modData.ID, MF_UNCHECKED);
    FreeLibrary(modData.FileHandle);
    modData.FileHandle := 0;
    result := 0;
  end;
end;

function RunAll(): Integer;
var
  modData: TComponentData;
  i : Integer;
  iTimeout: Integer;
  modName: String;
  modMutex: THandle;
type
  TStartFunc = function(owner: hwnd): hwnd;
const
  StartFunc: TStartFunc = nil;
begin
  result := 1;
  for i := 0 to lstComponents.Count - 1 do
  begin
    modData := TComponentData(lstComponents.Items[i]);
    if (modData.MetaData.Name = 'Startup') and not bDoStartup then Continue;
    if (modData.MetaData.DataType = tteService) and (modData.Priority > 0) then
    begin
      if not modData.Disabled then
      begin
        Sleep(modData.Delay);
        StartService(modData);
        iTimeout := 10000;
        modName := modData.MetaData.Name;
        while iTimeout > 0 do
        begin
          modMutex := OpenMutex(MUTEX_ALL_ACCESS, False, PChar('started_' + modName));
          if not (modMutex > 0) then
          begin
            Sleep(100);
            iTimeout := iTimeout - 100;
            if iTimeout = 0 then
              DebugMsg('Timed out waiting for ' + modName);
          end
          else
          begin
            iTimeout := 0;
            modData.Running := True;
            DebugMsg('Started ' + modName);
          end;
        end;
      end
      else
        DebugMsg('Unable to start, as service is disabled');
    end
    else if (modData.MetaData.DataType = tteComponent) and (modData.Priority > 0) then
    begin
      Sleep(modData.Delay);
      DebugMsg('Starting ' + modData.MetaData.Name);
      modData.Running := False;
      ShellExecute(0, nil, PChar(modData.FileName), '', PChar(ExtractFilePath(modData.FileName)), SW_SHOWNORMAL);
      iTimeout := 10000;
      modName := modData.MetaData.Name;
      while iTimeout > 0 do
      begin
        while ProcessMessage(WndMsg) do {loop};

        modMutex := OpenMutex(MUTEX_ALL_ACCESS, False, PChar('started_' + modName));
        if not (modMutex > 0) then
        begin
          Sleep(100);
          iTimeout := iTimeout - 100;
          if iTimeout = 0 then
            DebugMsg('Timed out waiting for ' + modName);
        end
        else
        begin
          iTimeout := 0;
          modData.Running := True;
          DebugMsg('Started ' + modName);
        end;
      end;
    end;
  end;

  SetProcessWorkingSetSize(GetCurrentProcess, dword(-1), dword(-1));

  SharpApi.SendDebugMessage('SharpCore', 'SharpEnviro was loaded successfully', 0);
end;

procedure StopAllServices;
var
  i: Integer;
  modData: TComponentData;
begin
  for i := 0 to lstComponents.Count - 1 do begin
    modData := TComponentData(lstComponents.Items[i]);
    if (modData.Running) and (modData.MetaData.DataType = tteService) then
      StopService(modData)
  end;
end;

procedure StopAll(bReboot: Boolean = False);
var
  i: Integer;
  modData: TComponentData;
  sName: string;
begin
  for i := 0 to lstComponents.Count - 1 do begin
    modData := TComponentData(lstComponents.Items[i]);
    if (modData.Running) and (modData.MetaData.DataType = tteService) then
      StopService(modData)
    else if (modData.MetaData.DataType = tteComponent) then begin
      if (modData.MetaData.Name = 'SharpCore') then Continue;      
      sName := modData.MetaData.Name;
      CloseComponent(PChar(sName));
      modData.Running := False;
    end;
    modData := nil;
  end;
end;

function WindowProc(hWnd: hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
const
  SCMsgFunc: function(msg: string): integer = nil;
var
  modData: TComponentData;
  cdsData: TCopyDataStruct;
  tmdData: TMsgData;
  sName: string;
  sParams: string;
  iPos: Integer;
  iIndex: Integer;
  Theme : ISharpETheme;
begin
  result := 0;
  if Msg = TaskBarCreated then begin // system tray created/updated, add icon again
      Shell_NotifyIcon(NIM_ADD, @nidTray);
    end
  else
  case Msg of
    // Update ThemeAPI
    WM_SHARPEUPDATESETTINGS:
    begin
      if [TSU_UPDATE_ENUM(wParam)] <= [suSkinFont,suSkinFileChanged,suTheme,
                                       suSkin,suIconSet,suScheme] then
      begin
        Theme := GetCurrentTheme;
        case wParam of
          Integer(suSkinFont): begin
            Theme.LoadTheme([tpSkinFont]);
            ISkinInterface.SkinManager.RefreshControls;
          end;
          Integer(suTheme): Theme.LoadTheme(ALL_THEME_PARTS);
          Integer(suSkin): Theme.LoadTheme([tpSkinScheme]);
          Integer(suScheme): begin
            Theme.LoadTheme([tpSkinScheme]);
            ISkinInterface.SkinManager.UpdateScheme;
            ISkinInterface.SkinManager.UpdateSkin;
          end;
          Integer(suSkinFileChanged): begin
            ISkinInterface.SkinManager.UpdateScheme;
            ISkinInterface.SkinManager.UpdateSkin;
          end;
          Integer(suIconSet):  Theme.LoadTheme([tpIconSet]);
        end;
      end;
    end;

    WM_DESTROY: PostQuitMessage(0);

    WM_CLOSE, WM_SHARPTERMINATE: begin
        Shell_NotifyIcon(NIM_DELETE, @nidTray); // Make sure we remove tray icon
        DestroyMenu(menPopup);
        if lstComponents <> nil then
        begin
          StopAllServices;
          FreeAndNil(lstComponents);
        end;
        DestroyWindow(hWnd);
      end;

    WM_CREATE: begin // Create and display tray icon
        DebugMsg('Creating tray icon');
        with nidTray do begin
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
            end;
        end;
      end;

    WM_SHARPEINITIALIZED: begin
      if ShellInit then
        result := 1
      else result := 0;
    end;

    WM_COMMAND: begin // Menu commands
        if HiWord(wParam) = 0 then
          case LoWord(wParam) of
            ID_SHELLSWITCH: SharpExecute('SetShell.exe');
            ID_EXIT: PostMessage(hWnd, WM_CLOSE, 0, 0);
            ID_SHUTDOWN: begin
                StopAll;
                PostMessage(hWnd, WM_CLOSE, 0, 0);
              end;
            ID_REBOOT: begin
                StopAll(True);
                bDoStartup := False;
                Sleep(5000);
                RunAll;
              end;
          else
            if LoWord(wParam) >= 50 then {//user clicked a service} begin
              iIndex := lstComponents.FindByID(LoWord(wParam));
              if (iIndex < lstComponents.Count) and (iIndex > -1) then begin
                modData := TComponentData(lstComponents.Items[iIndex]);
                if modData.Running then begin
                  StopService(modData);
                  BroadcastGlobalUpdateMessage(suCenter);
                end
                else begin
                  StartService(modData);
                  BroadcastGlobalUpdateMessage(suCenter);
                end;
              end;
            end;
          end;
      end;

    WM_COPYDATA: begin // Message from SharpAPI
        if lstComponents = nil then
        begin
          result := 0;
          exit;
        end;

        cdsData := PCopyDataStruct(lParam)^;
        tmdData := PMsgData(cdsData.lpData)^;
        if LowerCase(tmdData.Command) = '_servicestart' then {//start service}
        begin
          iIndex := lstComponents.FindByName(tmdData.Parameters);
          if (iIndex < lstComponents.Count) and (iIndex > -1) then begin
            modData := lstComponents.Items[iIndex];

            StartService(modData);
            if modData.Running then
              result := MR_STARTED
            else
              result := MR_STOPPED;
          end;
        end
        else if LowerCase(tmdData.Command) = '_servicestop' then {//stop service} begin
          iIndex := lstComponents.FindByName(tmdData.Parameters);
          if (iIndex < lstComponents.Count) and (iIndex > -1) then begin
            modData := lstComponents.Items[iIndex];

            StopService(modData);
            if modData.Running then
              result := MR_STARTED
            else
              result := MR_STOPPED;
          end;
        end
        else if LowerCase(tmdData.Command) = '_isstarted' then begin
          iIndex := lstComponents.FindByName(tmdData.Parameters);
          if (iIndex < lstComponents.Count) and (iIndex > -1) then begin
            modData := lstComponents.Items[iIndex];
            if modData.Running then
              result := MR_STARTED
            else
              result := MR_STOPPED;
          end;
        end
        else if LowerCase(tmdData.Command) = '_servicemsg' then {//send a service message} begin
          iPos := Pos('.', tmdData.Parameters);
          sName := Copy(tmdData.Parameters, 0, iPos - 1);
          sParams := Copy(tmdData.Parameters, iPos + 1, Length(tmdData.Parameters) - iPos + 1);
          iIndex := lstComponents.FindByName(sName);
          if (iIndex < lstComponents.Count) and (iIndex > -1) then begin
            modData := lstComponents.Items[iIndex];
            if modData.FileHandle <> 0 then begin
              SCMsgFunc := GetProcAddress(modData.FileHandle, 'SCMsg');
              if Assigned(SCMsgFunc) then
                Result := SCMsgFunc(sParams);
            end;
          end;
        end
      end;
  else
    Result := DefWindowProc(hWnd, Msg, wParam, lParam);
  end;
end;

begin
  shellInit := False;

  // Initialize Themes... (for the services)
  GetCurrentTheme.LoadTheme(ALL_THEME_PARTS);

  // Initialize the SkinInterface which then later can be passed to services
  SkinInterface := TSharpESkinInterface.Create(nil);
  ISkinInterface := SkinInterface;

  stlCmdLine := TStringList.Create;

  sAction := '';
  bDebug := False;
  bReboot := False;
  bDoStartup := False;
  strExtension := '.dll';
  wndDebug := 0;
  stlCmdLine.DelimitedText := GetCommandLine;
  for i := 0 to stlCmdLine.Count - 1 do
  begin
    if LowerCase(stlCmdLine[i]) = '-action' then
      if (i + 1) <= (stlCmdLine.Count - 1) then
          sAction := stlCmdLine[i + 1];
    if LowerCase(stlCmdLine[i]) = '-debug' then
      bDebug := True;
    if LowerCase(stlCmdLine[i]) = '-reboot' then
      bReboot := True;
    if LowerCase(stlCmdLine[i]) = '-startup' then
      bDoStartup := True;
    if (LowerCase(stlCmdLine[i]) = '-ext') then
      if (i + 1) <= (stlCmdLine.Count - 1) then
        strExtension := stlCmdLine[i + 1]
      else
        strExtension := '.dll';
  end;
  stlCmdLine.Free;

  // Only allow actions to be run if we were able to parse
  // one from the command line and we are not starting up
  // otherwise skip executing the action
  if (sAction <> '') and not(bDoStartup) then
  begin
    // We just SharpExecute what ever is given so it could really be anything.
    // We also exit here as the action arg should not be used
    // when it would be the 1st instance.
    SharpExecute(sAction);
    Exit;
  end;

  // Delete app bar data to remove old modules which no longer exist
  // Still existing modules will add their items back on startup
  if bDoStartup or bReboot then
    DeleteFile(SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\ApplicationBar\Apps.xml');

  if bDebug then begin
    if FindWindow('TSharpConsoleWnd', nil) = 0 then begin
      if ShellExecute(hInstance, 'open', PChar(GetSharpEDirectory + 'SharpConsole.exe'),
        '', PChar(''), 0) = 0 then begin
        while wndDebug = 0 do //wait for SharpConsole to open
          wndDebug := FindWindow('TSharpConsoleWnd', nil);
        Sleep(5000);
        DebugMsg('Debug flag found, started SharpConsole'); //would be silly to send the message if sharpconsole isn't open yet
      end
      else
        DebugMsg('SharpConsole could not be started');
    end;
  end;

  if bReboot then
    DebugMsg('Reboot flag found'); //need to add sharpe reboot code
  DebugMsg('Starting with service extension ' + strExtension);

  DebugMsg('Checking mutex');
  hndMutex := CreateMutex(nil, TRUE, 'SharpCore');
  if hndMutex <> 0 then
    if GetLastError = ERROR_ALREADY_EXISTS then begin
      DebugMsg('Mutex already exists, exiting');
      CloseHandle(hndMutex);
      Exit;
    end;

  SharpApi.GetSharpeUserSettingsPath; // initialize the user settings path
  lstComponents := TComponentList.Create;
  lstComponents.BuildList(strExtension); //enumerate services and components

  DebugMsg('Creating main window');
  wclClass.lpszClassName := 'TSharpCoreMainWnd';
  wclClass.lpfnWndProc := @WindowProc;
  wclClass.hInstance := hInstance;
  wclClass.hbrBackground := 1;
  wclClass.hIcon := LoadIcon(hInstance, 'MAINICON');

  Windows.RegisterClass(wclClass);
  TaskBarCreated := RegisterWindowMessage('TaskbarCreated');

  hndWindow := CreateWindow(wclClass.lpszClassName, 'SharpCore', 0,
    10, 10, 340, 220, 0, 0, hInstance, nil);

  shellInit := True;

  Application.Initialize;

  // Initialize COM library (some services might need it)
  CoInitialize(nil);

  RunAll;

  CreateEvent(nil, true, true, 'Global\\SharpEnviroStarted');

  try
    while GetMessage(wndMsg, 0, 0, 0) do
    begin
      TranslateMessage(wndMsg);
      DispatchMessage(wndMsg);
    end;
  finally
    ISkinInterface := nil;
  end;

  CoUninitialize;
  
  end.

