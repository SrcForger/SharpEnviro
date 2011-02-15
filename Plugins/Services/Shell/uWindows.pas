{
Source Name: uWindows.pas
Description: Window Structure class
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

unit uWindows;

interface

uses Windows, Messages, Classes, SysUtils, Forms,
     ShlObj, ShellApi, ActiveX, ComObj, UxTheme,
     SharpAPI,
     MonitorList, VWMFunctions,
     uTypes, uDeskArea, uTray, uTaskItem,
     uSystemFuncs,
     uFullscreen;

const
  Class_HxHelpPane: TGUID =
      '{8cec58e7-07a1-11d9-b15e-000d56bfe6ee}';
  IID_HxHelpPane : TGUID =
      '{8CEC5884-07A1-11D9-B15E-000D56BFE6EE}';

type
  TSHFindFiles = function(pidlRoot: PItemIDList; pidlSavedSearch: PItemIDList): HRESULT; stdcall;
  TSHFindComputer = function(pidlRoot: PItemIDList; pidlSavedSearch: PItemIDList): HRESULT; stdcall;
  TExitWindowsDialog = function(parentWnd: HWND): HRESULT; stdcall;

  TMonitorWnds = record
    MonitorID: integer;
    Wnds: TWndArray;
  end;
  TMonitorWndsArray = array of TMonitorWnds;
  PMonitorWnds = ^TMonitorWnds;


  TWindowStructureClass = class
  public
    ShellTrayWnd     : hwnd;
    TrayNotifyWnd    : hwnd;
    TrayClockWWnd    : hwnd;
    ReBarWindow32    : hwnd;
    MsTaskSwWClass   : hwnd;
    DeskAreaTimerWnd : hwnd;

    ShellTrayWndClass: TWndClass;
    TrayNotifyWndClass: TWndClass;
    ReBarWindow32Class: TWndClass;
    TrayClockWClass: TWndClass;
    MsTaskSwWClassClass: TWndClass;
    DeskAreaTimerWndClass: TWndClass;

    WM_SHELLHOOK : integer;

    FWndList: TMonitorWndsArray;  // Used for minimize all and restore all

    FShellHandle: THandle;
    FSHFindFiles: TSHFindFiles;
    FSHFindComputer: TSHFindComputer;
    FExitWindowsDialog: TExitWindowsDialog;

    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

  IHxHelpPane = interface
  ['{8cec58e7-07a1-11d9-b15e-000d56bfe6ee}']
    function ShowHelp(address : PWideChar): HRESULT; stdcall;
  end;

var
  WindowsClass : TWindowStructureClass;
  FullscreenChecker : TFullscreenChecker;

function DeskAreaTimerWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
function ShellTrayWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
function MsTaskSwWClassWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;

implementation

uses uTaskManager;


// Window related functions
function GetWndList(Monitor: TMonitor): TWndArray;

  procedure AddMonitor(var list : TWndArray; Mon : TMonitor);
  var
    i : integer;
    tmp : TWndArray;
  begin
    tmp := VWMGetWindowList(Mon.BoundsRect);
    for i := 0 to High(tmp) do
    begin
      setlength(list,length(list)+1);
      list[high(list)] := tmp[i];
    end;      
  end;

begin
  setlength(Result,0);
  AddMonitor(Result, Monitor);
end;

procedure MinimizeAllWindows(Monitor: TMonitor; sAllMonitors: Boolean = False);
var
  n, i: integer;
  pItem: PMonitorWnds;
begin
  if sAllMonitors then
  begin
    SetLength(WindowsClass.FWndList, Screen.MonitorCount);

    for n := 0 to High(WindowsClass.FWndList) do
    begin
      pItem := @WindowsClass.FWndList[n];
      pItem.MonitorID := Screen.Monitors[n].MonitorNum;
      pItem.Wnds := GetWndList(Screen.Monitors[n]);

      for i := 0 to High(pItem.Wnds) do
      begin
        if IsWindowNotMinimized(pItem.Wnds[i]) then
        begin
          ShowWindow(pItem.Wnds[i], SW_SHOWMINNOACTIVE);
          if not IsIconic(pItem.Wnds[i]) then
            PostMessage(pItem.Wnds[i],WM_SYSCOMMAND,SC_MINIMIZE,0);
        end;
      end;
    end;

    exit;
  end;

  pItem := nil;
  for n := 0 to High(WindowsClass.FWndList) do
    if (WindowsClass.FWndList[n].MonitorID = Monitor.MonitorNum) or (WindowsClass.FWndList[n].MonitorID = -1) then
    begin
      pItem := @WindowsClass.FWndList[n];
      break;
    end;

  if pItem = nil then
  begin
    SetLength(WindowsClass.FWndList, Length(WindowsClass.FWndList) + 1);
    pItem := @WindowsClass.FWndList[High(WindowsClass.FWndList)];
  end;

  pItem.MonitorID := Monitor.MonitorNum;
  pItem.Wnds := GetWndList(Monitor);

  for n := 0 to High(pItem.Wnds) do
  begin
    if IsWindowNotMinimized(pItem.Wnds[n]) then
    begin
      ShowWindow(pItem.Wnds[n], SW_SHOWMINNOACTIVE);
      if not IsIconic(pItem.Wnds[n]) then
        PostMessage(pItem.Wnds[n],WM_SYSCOMMAND,SC_MINIMIZE,0);
    end;
  end;
end;

procedure RestoreAllWindows(Monitor: TMonitor; sAllMonitors: Boolean = False);
var
  n, i: integer;
  pItem: PMonitorWnds;
begin
  if sAllMonitors then
  begin
    for n := 0 to Screen.MonitorCount - 1 do
    begin
      pItem := nil;
      for i := 0 to High(WindowsClass.FWndList) do
        if WindowsClass.FWndList[i].MonitorID = Screen.Monitors[n].MonitorNum then
        begin
          pItem := @WindowsClass.FWndList[i];
          break;
        end;

      if pItem = nil then
        continue;

      for i := 0 to High(pItem.Wnds) do
      begin
        if IsIconic(pItem.Wnds[i]) then
        begin
          ShowWindow(pItem.Wnds[i], SW_SHOWNOACTIVATE);
          if IsIconic(pItem.Wnds[i]) then
            SendMessage(pItem.Wnds[i], WM_SYSCOMMAND, SC_RESTORE, 0);
        end;
      end;

      pItem.MonitorID := -1;
      SetLength(pItem.Wnds, 0);
    end;

    exit;
  end;

  pItem := nil;
  for n := Low(WindowsClass.FWndList) to High(WindowsClass.FWndList) do
    if WindowsClass.FWndList[n].MonitorID = Monitor.MonitorNum then
    begin
      pItem := @WindowsClass.FWndList[n];
      break;
    end;

  if pItem = nil then
    exit;

  for n := 0 to High(pItem.Wnds) do
  begin
    if IsIconic(pItem.Wnds[n]) then
    begin
      ShowWindow(pItem.Wnds[n], SW_SHOWNOACTIVATE);
      if IsIconic(pItem.Wnds[n]) then
        SendMessage(pItem.Wnds[n], WM_SYSCOMMAND, SC_RESTORE, 0);
    end;
  end;

  pItem.MonitorID := -1;
  SetLength(pItem.Wnds, 0);
end;

// Show or hide task switcher
function DwmpStartOrStopFlip3D: Boolean;
type
  TDwmpStartOrStopFlip3D = function: HRESULT; stdcall;
var
  h: THandle;
  FDwmpStartOrStopFlip3D: TDwmpStartOrStopFlip3D;
begin
  Result := False;

  if not IsCompositionActive then
    exit;

  h := LoadLibrary('dwmapi.dll');
  if h = 0 then
    exit;

  @FDwmpStartOrStopFlip3D := GetProcAddress(h, PChar(105));
  if not Assigned(FDwmpStartOrStopFlip3D) then
  begin
    FreeLibrary(h);
    exit;
  end;

  Result := (FDwmpStartOrStopFlip3D = 0);
  FreeLibrary(h);
end;

procedure ShowHelp(address: string);
var
  FComObject : IHxHelpPane;
  wAddress: PWideChar;
begin
  GetMem(wAddress, sizeof(WideChar) * Succ(Length(address)));
  try
    StringToWideChar(address, wAddress, Succ(Length(address)));

    CoInitialize(nil);
    if CoCreateInstance(Class_HxHelpPane, nil, CLSCTX_REMOTE_SERVER or CLSCTX_INPROC_SERVER, IID_HxHelpPane, FComObject) = 0 then
      FComObject.ShowHelp(wAddress);
  finally
    FreeMem(wAddress);
  end;
end;

constructor TWindowStructureClass.Create;
begin
  SetLength(FWndList, 0);

  FShellHandle := LoadLibrary('shell32.dll');
  if FShellHandle <> 0 then
  begin
    @FSHFindFiles := GetProcAddress(FShellHandle, PAnsiChar(90));
    @FSHFindComputer := GetProcAddress(FShellHandle, PAnsiChar(91));
    @FExitWindowsDialog := GetProcAddress(FShellHandle, PAnsiChar(60));
  end;

  WM_SHELLHOOK := RegisterWindowMessage('SHELLHOOK');

  with ShellTrayWndClass do
  begin
    style := 0;
    lpfnWndProc := @ShellTrayWndProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := SysInit.hInstance;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 1;
    lpszMenuName := nil;
    lpszClassName := 'Shell_TrayWnd';
  end;
  
  with TrayNotifyWndClass do
  begin
    style := 0;
    lpfnWndProc := @DefWindowProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := SysInit.hInstance;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 1;
    lpszMenuName := nil;
    lpszClassName := 'TrayNotifyWnd';
  end;
  
  with ReBarWindow32Class do
  begin
    style := 0;
    lpfnWndProc := @DefWindowProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := SysInit.hInstance;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 1;
    lpszMenuName := nil;
    lpszClassName := 'ReBarWindow32';
  end;
  
  with TrayClockWClass do
  begin
    style := 0;
    lpfnWndProc := @DefWindowProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := SysInit.hInstance;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 1;
    lpszMenuName := nil;
    lpszClassName := 'TrayClockWClass';
  end;
  
  with MsTaskSwWClassClass do
  begin
    style := 0;
    lpfnWndProc := @MsTaskSwWClassWndProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := SysInit.hInstance;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 1;
    lpszMenuName := nil;
    lpszClassName := 'MSTaskSwWClass';
  end;
  
  with DeskAreaTimerWndClass do
  begin
    style := 0;
    lpfnWndProc := @DeskAreaTimerWndProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := SysInit.hInstance;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 1;
    lpszMenuName := nil;
    lpszClassName := 'DeskAreaTimerWnd';
  end;

  if Windows.RegisterClass(ShellTrayWndClass) <> 0 then
  begin
    // Shell_TrayWnd
    ShellTrayWnd := CreateWindowEx(WS_EX_TOOLWINDOW, ShellTrayWndClass.lpszClassName, '', WS_POPUP or WS_CLIPCHILDREN, 0, 0, 0, 0, 0, 0, hInstance, nil);
    if ShellTrayWnd <> 0 then
    begin
      // TrayNotifyWnd
      if Windows.RegisterClass(TrayNotifyWndClass) <> 0 then
      begin
        TrayNotifyWnd := CreateWindow(TrayNotifyWndClass.lpszClassName, 'TrayNotifyWnd', WS_CHILDWINDOW or WS_CLIPSIBLINGS or WS_CLIPCHILDREN, 0, 0, 0, 0, ShellTrayWnd, 0, hInstance, nil);
        if TrayNotifyWnd <> 0 then
        begin
          // TrayClockWClass
          if Windows.RegisterClass(TrayClockWClass) <> 0 then
          begin
            TrayClockWWnd := CreateWindow(TrayClockWClass.lpszClassName, 'TrayClockWClass', WS_CHILDWINDOW or WS_CLIPSIBLINGS or WS_CLIPCHILDREN, 0, 0, 0, 0, TrayNotifyWnd, 0, hInstance, nil);
            if TrayClockWWnd = 0 then
            begin
              SendDebugMessageEx('Shell','Failed to create "TrayClockWClass" window',0,0);
              Windows.UnregisterClass(PChar('TrayClockWClass'),hinstance);
            end;
          end else
            SendDebugMessageEx('Shell','Failed to register "TrayClockWClass" window class',0,0);
        end else
        begin
          SendDebugMessageEx('Shell','Failed to create "TrayNotifyWnd" window',0,0);
          Windows.UnregisterClass(PChar('TrayNotifyWnd'),hinstance);
        end;
      end else SendDebugMessageEx('Shell','Failed to register "TrayNotifyWnd" window class',0,0);

      // ReBarWindow32
      if Windows.RegisterClass(ReBarWindow32Class) <> 0 then
      begin
        ReBarWindow32 := CreateWindow(ReBarWindow32Class.lpszClassName, 'ReBarWindow32', WS_CHILDWINDOW, 0, 0, 0, 0, ShellTrayWnd, 0, hInstance, nil);
        if ReBarWindow32 <> 0 then
        begin

          // MsTaskSwWClassClass
          if Windows.RegisterClass(MsTaskSwWClassClass) <> 0 then
          begin
            MsTaskSwWClass := CreateWindow(MsTaskSwWClassClass.lpszClassName, 'SharpETaskMsgManager', WS_CHILDWINDOW, 0, 0, 0, 0, ReBarWindow32, 0, hInstance, nil);
            if MsTaskSwWClass = 0 then
            begin
              SendDebugMessageEx('Shell','Failed to create "MsTaskSwWClass" window',0,0);
              Windows.UnregisterClass(PChar('MsTaskSwWClass'),hinstance);
            end;
          end else SendDebugMessageEx('Shell','Failed to register "MsTaskSwWClass" window class',0,0);
        end else
        begin
          SendDebugMessageEx('Shell','Failed to create "ReBarWindow32" window',0,0);
          Windows.UnregisterClass(PChar('ReBarWindow32'),hinstance);
        end;
      end else SendDebugMessageEx('Shell','Failed to register "ReBarWindow32" window class',0,0);
    end else
    begin
      SendDebugMessageEx('Shell','Failed to create "Shell_TrayWnd" window',0,0);
      Windows.UnregisterClass(PChar('Shell_TrayWnd'),hinstance);
    end;
  end else SendDebugMessageEx('Shell','Failed to register "Shell_TrayWnd" window class',0,0);

  DeskAreaTimerWndClass.hInstance := hInstance;
  if Windows.RegisterClass(DeskAreaTimerWndClass) <> 0 then
  begin
    DeskAreaTimerWnd := CreateWindow(DeskAreaTimerWndClass.lpszClassName, 'DeskAreaTimerWnd', 0, 0, 0, 0, 0, 0, 0, hInstance, nil);
    if DeskAreaTimerWnd <> 0 then
    begin
      SetTimer(DeskAreaTimerWnd,1,3000,nil);
      RegisterActionEx('!EnableDeskArea','Services',DeskAreaTimerWnd,0);
      RegisterActionEx('!DisableDeskArea','Services',DeskAreaTimerWnd,1);
    end else
    begin
      Windows.UnregisterClass(PChar('DeskAreaTimerWndClass'),hInstance);
      SendDebugMessageEx('Shell','Failed to register "DeskAreaTimerWnd" window',0,0);
    end;
  end else
    SendDebugMessageEx('Shell','Failed to register "DeskAreaTimerWndClass" window class',0,0);

  // Set Shell_TrayWnd properties
  if ShellTrayWnd <> 0 then
  begin
    SetProp(ShellTrayWnd, 'AllowConsentToStealFocus', 1);
    SetProp(ShellTrayWnd, 'TaskBandHWND', ShellTrayWnd);
  end;
end;

destructor TWindowStructureClass.Destroy;
var
  i : integer;
begin
  if DeskAreaTimerWnd <> 0 then
  begin
    KillTimer(DeskAreaTimerWnd,1);
    DestroyWindow(DeskAreaTimerWnd);
    Windows.UnregisterClass(PChar('DeskAreaTimerWnd'),hInstance);
    UnRegisterAction('!EnableDeskArea');
    UnRegisterAction('!DisableDeskArea');
  end;

  if MsTaskSwWClass <> 0 then
  begin
    DestroyWindow(MsTaskSwWClass);
    Windows.UnregisterClass(PChar('MsTaskSwWClass'),hinstance)
  end;
  if ReBarWindow32 <> 0 then
  begin
    DestroyWindow(ReBarWindow32);
    Windows.UnregisterClass(PChar('ReBarWindow32'),hinstance)
  end;
  if TrayNotifyWnd <> 0 then
  begin
    DestroyWindow(TrayNotifyWnd);
    Windows.UnregisterClass(PChar('TrayNotifyWnd'),hinstance)
  end;
  if TrayClockWWnd <> 0 then
  begin
    DestroyWindow(TrayClockWWnd);
    Windows.UnregisterClass(PChar('TrayClockWClass'),hinstance)
  end;
  if ShellTrayWnd <> 0 then
  begin
    RemoveProp(ShellTrayWnd,'AllowConsentToStealFocus');
    RemoveProp(ShellTrayWnd,'TaskBandHWND');    
    DestroyWindow(ShellTrayWnd);
    Windows.UnregisterClass(PChar('Shell_TrayWnd'),hinstance)
  end;

  if FShellHandle <> 0 then
    FreeLibrary(FShellHandle);

  for i := 0 to High(FWndList) do
    SetLength(FWndList[i].Wnds, 0);

  SetLength(FWndList, 0);
end;

function DeskAreaTimerWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
begin
  case Msg of
    WM_SHARPEACTIONMESSAGE: begin
      case LParam of
        0 : DeskAreaManager.Enable;
        1 : DeskAreaManager.Disable;
      end;
    end;
    WM_SHARPEUPDATEACTIONS: begin
      RegisterActionEx('!EnableDeskArea','Services',WindowsClass.DeskAreaTimerWnd,0);
      RegisterActionEx('!DisableDeskArea','Services',WindowsClass.DeskAreaTimerWnd,1);
    end;
    WM_SHARPEUPDATESETTINGS: begin
      if WParam = Integer(suDeskArea) then
      begin
        DeskAreaManager.LoadSettings;
        DeskAreaManager.SetDeskArea;
      end;
    end;
    WM_DISPLAYCHANGE: DeskAreaManager.ScreenChange := True;
  end;

  if (Msg = WM_TIMER) and (wParam = 1) then
  begin
    if DeskAreaManager.ScreenChange then
    begin
      MonList.GetMonitors;
      DeskAreaManager.ScreenChange := False;
    end
    else if DeskAreaManager <> nil then
      DeskAreaManager.SetDeskArea;
      
    result := 0;
  end else
    Result := DefWindowProc(wnd, Msg, wParam, lParam);
end;

function ShellTrayWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
var
  n : integer;
  TrayCmd: integer;
  Icondata: TNotifyIconDataV7;
  IconIdent : TNotifyIconIdentifierMsg;
  AppBarMsgData : TAppBarMsgDataV2;
  data: pCopyDataStruct;
  hidden : boolean;
  shared : boolean;
  state  : integer;
  statemask : integer;
  pItem : TTrayIcon;
  e : boolean;
  wpos: PWindowPos;
  sstruct : PStyleStruct;
  cpos : TPoint;

  shellApp: Variant;
begin
  if TrayManager = nil then
  begin
    Result := DefWindowProc(wnd, Msg, wParam, lParam);
    exit;
  end;

  case msg of
    WM_SHOWWINDOW: begin
      result := 0;
      if wParam = 1 then
        ShowWindow(wnd, SW_SHOW)
      else if wParam = 0 then
        ShowWindow(wnd, SW_HIDE);
    end;
    WM_STYLECHANGING: begin
      sstruct := PStyleStruct(lParam);
      if ((wParam = GWL_STYLE) and ((sstruct.styleNew and WS_VISIBLE) = WS_VISIBLE)) then
      begin
        sstruct.styleNew := sstruct.styleNew and not WS_VISIBLE;
        result := 0;
      end else result := DefWindowProc(wnd, Msg, wParam, lParam);
    end;
    WM_WINDOWPOSCHANGING: begin
      wpos := PWINDOWPOS(lParam);
      if (wpos.flags and SWP_SHOWWINDOW) = SWP_SHOWWINDOW then
      begin
        wpos.flags := wpos.flags and not SWP_SHOWWINDOW;
        wpos.flags := wpos.flags or SWP_HIDEWINDOW;
        wpos.flags := wpos.flags or SWP_NOACTIVATE;
        result := 0;
      end else result := DefWindowProc(wnd, Msg, wParam, lParam);
    end;
    WM_COPYDATA:
    begin
      //SharpApi.SendDebugMessage('shell','---------TRAY MESSAGE--------',0);
      //SharpApi.SendDebugMessage('shell','LParam(size):' + inttostr(SizeOf(LParam)),0);
      Data := pCopyDataStruct(LParam);
      case Data.dwData of
        SH_APPBAR_DATA :
        begin
          //SharpApi.SendDebugMessage('TRAY','dwData: SH_APPBAR_DATA',0);
          AppBarMsgData := pAppBarMsgDataV2(Data.lpData)^;
          Result := TrayManager.HandleAppBarMessage(AppBarMsgData,lparam);
        end;
        SH_ICON_IDENTIFIER:
        begin
          //SharpApi.SendDebugMessage('shell','dwData: SH_UNKNOWN_3',0);
          //SharpApi.SendDebugMessage('shell','lpData: ' + inttostr(SizeOf(Data.lpData)),0);
          IconIdent := pNotifyIconIdentifierMsg(PCHAR(Data.lpdata))^;
          if GetCursorPosSecure(cpos) then
          begin
            case IconIdent.dwMessage of
              2: result := MAKELONG(16,16);
              else result := MAKELONG(cpos.X,cpos.y);
            end;
          end else result := MAKELONG(0,0);
        end;
        SH_TRAY_DATA :
        begin
          //SharpApi.SendDebugMessage('shell','dwData: SH_TRAY_DATA',0);
          //SharpApi.SendDebugMessage('shell','lpdata(size):' + inttostr(SizeOf(Data.lpdata)),0);
          TrayCmd := pINT(PCHAR(Data.lpdata) + 4)^;
          Icondata := pNotifyIconDataV7(PCHAR(Data.lpdata) + 8)^;
          hidden := false;
          shared := false;
          if (IconData.uFlags and NIF_STATE) = NIF_STATE then
          begin
            state := IconData.dwState;
            statemask := IconData.dwStateMask;

            if (state and statemask and NIS_HIDDEN) <> 0 then
              hidden := True;
            if (statemask and state and NIS_SHAREDICON) <> 0 then
              shared := True;
          end;

          pItem := TrayManager.FindTrayIcon(IconData);
          e := True;
          if (IconData.uID = 1) and (Shared) then e := False;

          if e then
          begin
            case TrayCmd of
              NIM_ADD: begin
                //SharpApi.SendDebugMessage('shell','TrayCmd: NIM_ADD',0);
                //DebugIconData(IconData);
                if pItem = nil then
                  TrayManager.ModifyTrayIcon(pItem,IconData,Hidden,Shared,TrayCmd)
                else
                  e := false;
              end;
              NIM_SETVERSION: begin
                //SharpApi.SendDebugMessage('shell','TrayCmd: NIM_SETVERSION',0);
                //DebugIconData(IconData);
                TrayManager.UpdateTrayVersion(pItem,IconData);
              end;
              NIM_MODIFY: begin
                //SharpApi.SendDebugMessage('shell','NIM_MODIFY: NIM_ADD',0);
                //DebugIconData(IconData);
                if (pItem <> nil) then
                  TrayManager.ModifyTrayIcon(pItem,IconData,Hidden,Shared,TrayCmd)
                else
                  e := False;
              end;
              NIM_DELETE: begin
                //SharpApi.SendDebugMessage('shell','TrayCmd: NIM_DELETE',0);
                //DebugIconData(IconData);
                if (pItem <> nil) then
                  TrayManager.RemoveTrayIcon(pItem)
                else
                  e := False;
              end;
            end;
          end;

          if e then Result := 1
            else Result := 0;
        end;
        else
        begin
           SharpApi.SendDebugMessage('shell','dwData: SH_UNKNOWN(' + inttostr(Data.dwData) + ')',0);
           Result := DefWindowProc(wnd, Msg, WParam, LParam);
        end;
      end;
    end;
    WM_REGISTERWITHTRAY: begin
      if TrayManager.WndList.IndexOf(inttostr(Cardinal(WParam))) = -1 then
      begin
        TrayManager.WndList.Add(inttostr(Cardinal(WParam)));
        // Broadcast all icons to the new tray client
        TrayManager.BroadCastAllToOne(Cardinal(WParam));
        result := 1;
      end else result :=0;
    end;
    WM_UNREGISTERWITHTRAY: begin
      n := TrayManager.WndList.IndexOf(inttostr(Cardinal(WParam)));
      if n > 0 then
      begin
        TrayManager.WndList.Delete(n);
        result := 1;
      end else result := 0;
    end;

    // These are sent by Shell.Application OLE object
    WM_COMMAND: begin
      case wParam of
        // Run Dialog, .FileRun
        $191: begin
          SharpApi.SharpExecute('!RunDlg');
        end;
        // Set Time, .SetTime
        $198: begin
          shellApp := CreateOleObject('Shell.Application');
          shellApp.ControlPanelItem('timedate.cpl');
        end;
        // Window Switcher, .WindowSwitcher
        $19B: begin
          if not DwmpStartOrStopFlip3D then
          begin
            PostMessage(FindWindow('AltTab_KeyHookWnd', nil), WM_USER, $50494C46, 0);
          end;
        end;
        // Minimize all, .MinimizeAll
        $19F: begin
          SendMessage(WindowsClass.MsTaskSwWClass, WM_MINIMIZEALLWINDOWS, MonList.MonitorFromWindow(GetForegroundWindow).MonitorNum, 0);
        end;
        // Restore all, .UndoMinimizeALL
        $1A0: begin
          SendMessage(WindowsClass.MsTaskSwWClass, WM_RESTOREALLWINDOWS, MonList.MonitorFromWindow(GetForegroundWindow).MonitorNum, 0);
        end;
        // Show Help, .Help
        $1F7: begin
          ShowHelp('mshelp://help/?id=home');
        end;
        // Shut down dialog, .ShutdownWindows
        $1FA: begin
          if Assigned(WindowsClass.FExitWindowsDialog) then
            WindowsClass.FExitWindowsDialog(0);
        end;
        // Windows security dialog, .WindowsSecurity
        $1389: begin

        end;
        // Find Files .FindFiles
        $A085: begin
          if Assigned(WindowsClass.FSHFindFiles) then
            WindowsClass.FSHFindFiles(nil, nil);
        end;
        // Find Computer .FindComputer
        $A086: begin
          if Assigned(WindowsClass.FSHFindComputer) then
            WindowsClass.FSHFindComputer(nil, nil);
        end;
      end;
      
      Result := 1;
    end;
    WM_MINIMIZEALLWINDOWS, WM_RESTOREALLWINDOWS: begin
      PostMessage(WindowsClass.MsTaskSwWClass, Msg, wParam, lParam);
      Result := 1;
    end
    else Result := DefWindowProc(wnd, Msg, wParam, lParam);
  end;

  // Office fix...
  if msg = WM_USER + 236 then
    Result := 1
end;

function MsTaskSwWClassWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
var
  n : integer;
  ms : TMemoryStream;
  cds : TCopyDataStruct;
  pItem : TTaskItem;
  h : hwnd;
  vwm : integer;
  deskswitch : boolean;
  b : integer;
  R : TRect;
begin
  result := 0;
  if TaskMsgManager <> nil then
  begin
    if (Msg = WM_TIMER) and (wParam = 1) then
    begin
      if IsWindow(TaskManager.LastActiveTask) then
      begin
        pItem := TaskManager.GetItemByHandle(TaskManager.LastActiveTask);
        GetWindowRect(TaskManager.LastActiveTask,R);
        if ((R.Left <> TaskManager.LastActiveTaskPos.Left) // Check if Window has moved but exclude minimized windows
           or (R.Top <> TaskManager.LastActiveTaskPos.Top)) and (pItem <> nil) and (not IsIconic(pItem.Handle)) then
        begin
          vwm := VWMGetWindowVWM(GetCurrentVWM,GetVWMCount,TaskManager.LastActiveTask);
          TaskManager.LastActiveTaskPos := R;
          pItem.LastVWM := vwm; // Update the VWM of the task and forward it to all modules
          for n := High(TaskMsgManager.WndList) downto 0 do
            if IsWindow(TaskMsgManager.WndList[n]) then
            begin
              PostMessage(TaskMsgManager.WndList[n],WM_TASKVWMCHANGE,pItem.Handle,pItem.LastVWM);
            end
            else TaskMsgManager.DeleteWnd(n);
        end;
      end;
    end else
    if Integer(Msg) = WindowsClass.WM_SHELLHOOK then
    begin
      deskswitch := False;
      if (wparam = HSHELL_WINDOWACTIVATED) or (wparam = HSHELL_WINDOWACTIVATED + 32768) then
      begin
        FullscreenChecker.ActiveWnd := GetForegroundWindow;

        h := Cardinal(lparam);
        pItem := TaskManager.GetItemByHandle(h);
        if pItem <> nil then
        begin
          if not (pItem.Visible) then
          begin
            if pItem.LastVWM <> GetCurrentVWM then
            begin
//              VWMFunctions.VWMMoveWindotToVWM(pItem.LastVWM,GetCurrentVWM,GetVWMCount,pItem.Handle);
              SharpApi.SwitchToVWM(pItem.LastVWM,pItem.Handle);
              deskswitch := True;
            end;
          end else
          if (WindowInRect(pItem.Handle,MonList.DesktopRect))then
          begin
            vwm := VWMGetWindowVWM(GetCurrentVWM,GetVWMCount,h);
            if vwm <> pItem.LastVWM then
            begin
              pItem.LastVWM := vwm;
              for n := High(TaskMsgManager.WndList) downto 0 do
                if IsWindow(TaskMsgManager.WndList[n]) then
                  PostMessage(TaskMsgManager.WndList[n],WM_TASKVWMCHANGE,pItem.Handle,pItem.LastVWM)
                else TaskMsgManager.DeleteWnd(n);
            end;
          end;
        end;
      end;
      TaskManager.HandleShellMessage(wparam,Cardinal(lparam));
      if (not deskswitch) and (GetTickCount - TaskMsgManager.LastAppCommand > 100) then
      begin
        for n := High(TaskMsgManager.WndList) downto 0 do
          if IsWindow(TaskMsgManager.WndList[n]) then
          begin
            if wparam = HSHELL_APPCOMMAND then
            begin
              b := SendMessage(TaskMsgManager.WndList[n],WM_SHARPSHELLMESSAGE,WParam,LParam);
              if b <> 0 then
                result := 1;
            end
            else PostMessage(TaskMsgManager.WndList[n],WM_SHARPSHELLMESSAGE,WParam,LParam)
          end
          else TaskMsgManager.DeleteWnd(n);
        if wparam = HSHELL_APPCOMMAND then
          TaskMsgManager.LastAppCommand := GetTickCount;
      end else result := 1;
    end else
    case Msg of
      WM_CHECKFULLSCREEN:
      begin
        FullscreenChecker.ResetMonitor(lParam);
      end;
      WM_REGISTERSHELLHOOK: TaskMsgManager.AddWnd(Cardinal(WParam));
      WM_UNREGISTERSHELLHOOK: TaskMsgManager.DeleteWndByHandle(Cardinal(WParam));
      WM_REQUESTWNDLIST: begin
        ms := TMemoryStream.Create;
        TaskManager.SaveToStream(ms);
        with cds do
        begin
          dwData := TaskManager.ItemCount;
          cbData := ms.Size;
          lpData := ms.Memory;
        end;
        sendmessage(Cardinal(WParam), WM_COPYDATA, WM_REQUESTWNDLIST, Cardinal(@cds));
        ms.Free;
      end;
      WM_TASKVWMCHANGE: begin
        pItem := TaskManager.GetItemByHandle(Cardinal(wParam));
        if pItem <> nil then
        begin
          pItem.LastVWM := lParam;
          for n := High(TaskMsgManager.WndList) downto 0 do
            if IsWindow(TaskMsgManager.WndList[n]) and (TaskMsgManager.WndList[n] <> wnd) then
              PostMessage(TaskMsgManager.WndList[n],WM_TASKVWMCHANGE,WParam,LParam)
            else TaskMsgManager.DeleteWnd(n);     
        end;
      end;
      WM_MINIMIZEALLWINDOWS: begin
        for n := 0 to Screen.MonitorCount - 1 do
          if Screen.Monitors[n].MonitorNum = wParam then
            break;

        if (n < Screen.MonitorCount) or (lParam = 1) then
          MinimizeAllWindows(Screen.Monitors[n], (lParam = 1));
      end;
      WM_RESTOREALLWINDOWS: begin
        for n := 0 to Screen.MonitorCount - 1 do
          if Screen.Monitors[n].MonitorNum = wParam then
            break;

        if (n < Screen.MonitorCount) or (lParam = 1) then
          RestoreAllWindows(Screen.Monitors[n], (lParam = 1));
      end;
    end;
  end;
  if result = 0 then
    Result := DefWindowProc(wnd, Msg, wParam, lParam);
end;

end.
