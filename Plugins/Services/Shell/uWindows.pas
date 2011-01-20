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

uses Windows, Messages, Classes, SysUtils,
     SharpAPI,
     MonitorList, VWMFunctions,
     uTypes, uDeskArea, uTray, uTaskItem;

type
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

    constructor Create; reintroduce;
    destructor Destroy; override;
  end;

var
  WindowsClass : TWindowStructureClass;

function DeskAreaTimerWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
function ShellTrayWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
function MsTaskSwWClassWndProc(wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;

implementation

uses uTaskManager;

constructor TWindowStructureClass.Create;
begin
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
    ShellTrayWnd := CreateWindowEx(WS_EX_TOOLWINDOW, ShellTrayWndClass.lpszClassName, 'Shell_TrayWnd', WS_POPUP or WS_CLIPCHILDREN, 0, 0, 0, 0, 0, 0, hInstance, nil);
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

              // Hack for fullscreen check
              //PostMessage(TaskMsgManager.WndList[n],WM_SHARPSHELLMESSAGE,HSHELL_WINDOWACTIVATED + 32768,GetForegroundWindow);
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
    end;
  end;
  if result = 0 then
    Result := DefWindowProc(wnd, Msg, wParam, lParam);
end;

end.
