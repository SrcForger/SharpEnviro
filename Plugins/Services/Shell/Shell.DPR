{
Source Name: Shell.dpr
Description: SystemTray and TaskManager service library file
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

library Shell;
uses
  MultiMon,
  uxtheme,
  math,
  windows,
  classes,
  sysutils,
  shellapi,
  registry,
  messages,
  Contnrs,
  JclSysInfo,
  JclSimpleXML,
  MonitorList,
  winver in 'winver.pas',
  declaration in 'declaration.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uTaskManager in 'uTaskManager.pas',
  uTaskItem in 'uTaskItem.pas',
  VWMFunctions in '..\..\..\Common\Units\VWM\VWMFunctions.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas';

type
  TTaskMsgManager = Class(Tobject)
    private
      Procedure RegisterHook;
      Procedure UnregisterHook;
      Procedure DeleteWnd(Index : Integer);
      Procedure DeleteWndByHandle(wnd : hwnd);
      Procedure AddWnd(wnd : hwnd);
      function FindWindow(wnd : hwnd) : integer;
    public
      WndList : array of hwnd;    
      constructor Create; reintroduce;
      destructor Destroy; override;
    end;

  TTrayIcon = class
  private
  public
    data : TNotifyIconDataV7;
    hidden : boolean;
    shared : boolean;
    valid  : boolean;
    orig_icon : hicon;
    display : TTrayIcon;
  end;

  TAppBarItem = class
    Data : TAppBarMsgDataV2;
    AutoHideBar : boolean;
    constructor Create(pData : TAppBarMsgDataV2);
  end;

  TTrayManager = class(TObject)
  private
    FDllHandle : THandle;
    SHLockShared : function (Handle: THandle; DWord: DWORD): pointer; stdcall;
    SHUnlockShared : function (Pnt: Pointer): BOOL; stdcall;
    function FindTrayIcon(pData : TNotifyIconDataV7) : TTrayIcon;
    procedure ResetIcon(pItem : TTrayIcon);
    procedure ResetSharing(pItem : TTrayIcon);
    procedure RemoveTrayIcon(pItem : TTrayIcon);
    procedure ModifyTrayIcon(pItem : TTrayIcon; pData : TNotifyIconDataV7; Hidden,Shared : boolean; Action : integer);
    procedure UpdateTrayVersion(pItem : TTrayIcon; pData : TNotifyIconDataV7);
    procedure CheckForDeadIcons;
    procedure BroadCastTrayMessage(pItem: TTrayIcon; action : integer);
    procedure BroadCastAllToOne(wnd : hwnd);
    function GetAppBarItem(pWnd : hwnd) : TAppBarItem;
    function GetAutoHideAppBar(pEdge : Cardinal) : TAppBarItem;
    function HandleAppBarMessage(msg : TAppBarMsgDataV2; lparam : dword) : integer;
    function LockAppBarMemory(abmd: TAppBarMsgDataV2): pAppBarDataV1;
    function UnLockAppBarMempory(Pnt: pAppBarDataV1): boolean;
  public
    Icons : TObjectList;
    AppBarList : TObjectList;
    WndList : TStringList;
    constructor Create; reintroduce;
    destructor Destroy; override;    
  end;

  TDeskAreaManager = class
  private
    FAutoModeList : array of boolean;
    FOffsetList : array of TRect;
    FMonIDList : array of integer;
    FScreenChange : Boolean;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure LoadSettings;
    procedure SetDeskArea;
    procedure SetFullScreenArea;

    procedure Enable;
    procedure Disable;

    property ScreenChange : Boolean read FScreenChange write FScreenChange;
  end;  


{$R *.RES}

{$WARN SYMBOL_PLATFORM OFF}

function RegisterShellHook(wnd : hwnd; param : dword) : boolean; stdcall; external 'shell32.dll' index 181;

function DeskAreaTimerWndProc(Wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall; forward;
function ShellTrayWndProc(Wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall; forward;
function MsTaskSwWClassWndProc(Wnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall; forward;

var
  TaskMsgManager : TTaskMsgManager;
  TaskManager : TTaskManager;
  TrayManager : TTrayManager;
  DeskAreaManager : TDeskAreaManager;
  lastappcommand : int64;  

  WM_SHELLHOOK : integer;

  ShellTrayWnd     : hwnd;
  TrayNotifyWnd    : hwnd;
  ReBarWindow32    : hwnd;
  MsTaskSwWClass   : hwnd;
  DeskAreaTimerWnd : hwnd;

  ShellTrayWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @ShellTrayWndProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 1;
    lpszMenuName: nil;
    lpszClassName: 'Shell_TrayWnd');
  TrayNotifyWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 1;
    lpszMenuName: nil;
    lpszClassName: 'TrayNotifyWnd');
  ReBarWindow32Class: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 1;
    lpszMenuName: nil;
    lpszClassName: 'ReBarWindow32');
  MsTaskSwWClassClass: TWndClass = (
    style: 0;
    lpfnWndProc: @MsTaskSwWClassWndProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 1;
    lpszMenuName: nil;
    lpszClassName: 'MSTaskSwWClass');
  DeskAreaTimerWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DeskAreaTimerWndProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 1;
    lpszMenuName: nil;
    lpszClassName: 'DeskAreaTimerWnd');


function GetWndCaption(pHandle: hwnd): string;
var
  buf: array[0..254] of Char;
begin
  GetWindowText(pHandle, buf, SizeOf(buf));
  result := buf;
end;

function GetWndClass(pHandle: hwnd): string;
var
  buf: array[0..254] of Char;
begin
  GetClassName(pHandle, buf, SizeOf(buf));
  result := buf;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
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
      RegisterActionEx('!EnableDeskArea','Services',DeskAreaTimerWnd,0);
      RegisterActionEx('!DisableDeskArea','Services',DeskAreaTimerWnd,1);
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
  end else Result := DefWindowProc(wnd, Msg, wParam, lParam);
end;

procedure DebugIconData(pData : TNotifyIconDataV7);
begin
  SharpApi.SendDebugMessage('shell','version: ' + inttostr(pData.Union.uVersion),0);
  SharpApi.SendDebugMessage('shell','size: ' + inttostr(pData.cbSize),0);
  SharpApi.SendDebugMessage('shell','wnd: ' + inttostr(pData.Wnd),0);
  SharpApi.SendDebugMessage('shell','uID: ' + inttostr(pData.uID),0);
  SharpApi.SendDebugMessage('shell','uFlags: ' + inttostr(pData.uFlags),0);
  SharpApi.SendDebugMessage('shell','uCallbackMessage: ' + inttostr(pData.uCallbackMessage),0);
  SharpApi.SendDebugMessage('shell','Icon: ' + inttostr(pData.Icon),0);
  SharpApi.SendDebugMessage('shell','szTip: ' + pData.szTip,0);        
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
      ShowWindow(wnd, SW_HIDE);
    end;
    WM_STYLECHANGING: begin
      sstruct := PStyleStruct(lParam);
      if (sstruct.styleNew and WS_VISIBLE) = WS_VISIBLE then
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
                         if hidden then e := False
                         else if pItem = nil then TrayManager.ModifyTrayIcon(pItem,IconData,False,False,TrayCmd)
                         else e := False;
                       end;
              NIM_SETVERSION: begin
                //SharpApi.SendDebugMessage('shell','TrayCmd: NIM_SETVERSION',0);
                //DebugIconData(IconData);
                TrayManager.UpdateTrayVersion(pItem,IconData);
              end;
              NIM_MODIFY: begin
                            //SharpApi.SendDebugMessage('shell','NIM_MODIFY: NIM_ADD',0);
                            //DebugIconData(IconData);
                            if (hidden) and (pItem<>nil) then TrayManager.RemoveTrayIcon(pItem)
                            else if (pItem <> nil) then TrayManager.ModifyTrayIcon(pItem,IconData,False,False,TrayCmd)
                            else e := False;
                        end;
              NIM_DELETE: begin
                            //SharpApi.SendDebugMessage('shell','TrayCmd: NIM_DELETE',0);
                            //DebugIconData(IconData);
                            if (pItem <> nil) then TrayManager.RemoveTrayIcon(pItem)
                              else e := False;
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
begin
  result := 0;
  if TaskMsgManager <> nil then
  begin
    if Integer(Msg) = WM_SHELLHOOK then
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
      if (not deskswitch) and (GetTickCount - lastappcommand > 100) then
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
          lastappcommand := GetTickCount;
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

procedure CreateWindowStructure;
begin
  ShellTrayWndClass.hInstance := hInstance;
  TrayNotifyWndClass.hInstance := hInstance;
  ReBarWindow32Class.hInstance := hInstance;
  MsTaskSwWClassClass.hInstance := hInstance;
  
  if Windows.RegisterClass(ShellTrayWndClass) <> 0 then
  begin
    // Shell_TrayWnd
    ShellTrayWnd := CreateWindow(ShellTrayWndClass.lpszClassName, 'Shell_TrayWnd', 0, 0, 0, 0, 0, 0, 0, hInstance, nil);
    if ShellTrayWnd <> 0 then
    begin
      // TrayNotifyWnd
      if Windows.RegisterClass(TrayNotifyWndClass) <> 0 then
      begin
        TrayNotifyWnd := CreateWindow(TrayNotifyWndClass.lpszClassName, 'TrayNotifyWnd', WS_CHILDWINDOW, 0, 0, 0, 0, ShellTrayWnd, 0, hInstance, nil);
        if TrayNotifyWnd = 0 then
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
end;

procedure DesroyWindowStructure;
begin
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
  if ShellTrayWnd <> 0 then
  begin
    DestroyWindow(ShellTrayWnd);
    Windows.UnregisterClass(PChar('Shell_TrayWnd'),hinstance)
  end;
end;

function NETFramework35: Boolean;
var
  Reg: TRegistry;
begin
  Result := False;
  Reg := TRegistry.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('SOFTWARE\Microsoft\NET Framework Setup\NDP\v3.5', False) then
      if Reg.ReadBool('Install') then
        result := True;
  finally
    Reg.Free
  end;
end;

procedure StartShellServices;
var
  Dir : String;
begin
  Dir := IncludeTrailingBackslash(SharpAPI.GetSharpeDirectory);
  //ShellExecute(Application.Handle, nil, pChar(Dir + 'SharpShellServices.exe'),nil,nil,SW_SHOWNORMAL);
  if (NETFramework35) and (FileExists(Dir + 'SharpShellServicesNET.exe')) then
    SharpExecute(Dir + 'SharpShellServicesNET.exe')
  else SharpExecute(Dir + 'SharpShellServices.exe');
end;

procedure TerminateShellServices;
var
  PID : DWord;
begin
  PID := GetPidFromProcessName('SharpShellServicesNET.exe');
  if PID = INVALID_HANDLE_VALUE then  
    PID := GetPidFromProcessName('SharpShellServices.exe');
  if PID <> INVALID_HANDLE_VALUE then  
    TerminateApp(PID,100);
end;

procedure Stop;
begin
  FreeAndNil(DeskAreaManager);
  FreeAndNil(TrayManager);
  FreeAndNil(TaskMsgManager);
  FreeAndNil(TaskManager);

  DesroyWindowStructure;
  TerminateShellServices;
end;

function Start(owner: hwnd): hwnd;
begin
  InitThemeLibrary;

  TaskMsgManager := nil;
  TrayManager := nil;
  DeskAreaManager := nil;
  CreateWindowStructure;
  TaskMsgManager     := TTaskMsgManager.Create;
  TrayManager     := TTrayManager.Create;
  DeskAreaManager := TDeskAreaManager.Create;
  DeskAreaManager.LoadSettings;
  TaskManager := TTaskManager.Create;
  TaskManager.ListMode := True;
  TaskManager.Enabled := True;
  TaskManager.InitList;

  SharpApi.SharpEBroadCast(WM_SHELLHOOKWINDOWCREATED,MsTaskSwWClass,0);
  TaskMsgManager.RegisterHook;

  TerminateShellServices;
  sleep(1000);
  StartShellServices;
  ServiceDone('Shell');
  Result := owner;
  SendNotifyMessage(HWND_BROADCAST, RegisterWindowMessage('TaskbarCreated'), 0, 0);  
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Shell';
    Description := 'Provides the core shell functionality (Taskbar,Tray,DeskArea)';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteService;
    ExtraData := 'priority: 20| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  GetMetaData;

{ TTaskMsgManager }

procedure TTaskMsgManager.AddWnd(wnd: hwnd);
begin
  if FindWindow(wnd) <> -1 then
    exit;

  setlength(WndList,length(WndList)+1);
  WndList[High(WndList)] := wnd;
end;

constructor TTaskMsgManager.Create;
begin
  inherited Create;

  lastappcommand := GetTickCount;
  WM_SHELLHOOK := RegisterWindowMessage('SHELLHOOK');
  setlength(WndList,0);
end;

procedure TTaskMsgManager.DeleteWnd(Index: Integer);
var
  n : integer;
begin
  if (Index > High(WndList)) or (Index < Low(WndList)) then
    exit;

  for n := Index to High(WndList) - 1 do
    WndList[n] := WndList[n+1];
  setlength(WndList,length(WndList)-1);
end;

procedure TTaskMsgManager.DeleteWndByHandle(wnd: hwnd);
var
  Index : integer;
begin
  Index := FindWindow(wnd);
  if Index <> -1 then
    DeleteWnd(Index);
end;

destructor TTaskMsgManager.Destroy;
begin
  UnregisterHook;

  setlength(WndList,0);

  inherited;
end;

function TTaskMsgManager.FindWindow(wnd: hwnd): integer;
var
  n : integer;
begin
  result := -1;
  for n := 0 to High(WndList) do
    if WndList[n] = wnd then
    begin
      result := n;
      break;
    end;
end;

procedure TTaskMsgManager.RegisterHook;
var
  mm: MINIMIZEDMETRICS;
begin
  FillChar(mm, SizeOf(MINIMIZEDMETRICS), 0);

  mm.cbSize := SizeOf(MINIMIZEDMETRICS);
  SystemParametersInfo(SPI_GETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

  mm.iArrange := mm.iArrange or ARW_HIDE;
  SystemParametersInfo(SPI_SETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

  RegisterShellHook(MsTaskSwWClass,1);
  RegisterShellHook(MsTaskSwWClass,3);
end;

procedure TTaskMsgManager.UnregisterHook;
begin
  RegisterShellHook(MsTaskSwWClass,0);
end;

{ TTrayManager }

procedure TTrayManager.BroadCastAllToOne(wnd: hwnd);
var
  n : integer;
  cds: TCopyDataStruct;
  pItem : TTrayIcon;
begin
  if not IsWindow(wnd) then exit;

  CheckForDeadIcons;

  if Icons.Count = 0 then exit;

  for n := 0 to Icons.Count -1 do
  begin
    pItem := TTrayIcon(Icons.Items[n]);
    if pItem.valid then
    begin
      with cds do
      begin
        dwData := 1;
        cbData := SizeOf(TNotifyIconDataV7);
        lpData := @pItem.data;
      end;
    end;

    // forward the tray message
    SendMessage(wnd,WM_COPYDATA,0,Cardinal(@cds));
  end;
end;

procedure TTrayManager.BroadCastTrayMessage(pItem: TTrayIcon;
  action: integer);
var
  n : integer;
  wnd : hwnd;
  cds: TCopyDataStruct;
begin
  // no tray registered -> exit
  if WndList.Count = 0 then exit;

  n := WndList.Count -1;
  while n>=0 do
  begin
    try
      wnd := StrToInt64(WndList[n]);
    except
      wnd := 0;
    end;

    // window doesn't exist anymore -> delete it
    if not IsWindow(wnd) then
    begin
      WndList.Delete(n);
      n := n - 1;
      Continue;
    end;

    with cds do
    begin
      // action:
      // 1 = add/modify
      // 2 = delete
      dwData := action;
      cbData := SizeOf(TNotifyIconDataV7);
      lpData := @pItem.data;
    end;

    // forward the tray message
    SendMessage(wnd,WM_COPYDATA,0,Cardinal(@cds));
    n := n -1;
  end;
end;

constructor TTrayManager.Create;
begin
  inherited Create;

  Icons := TObjectList.Create;
  Icons.OwnsObjects := True;
  Icons.Clear;
  AppBarList := TObjectList.Create;
  AppBarList.OwnsObjects := True;
  AppBarList.Clear;
  WndList := TStringList.Create;
  WndList.Duplicates := dupIgnore;
  WndList.Clear;

  FDllHandle := LoadLibrary('SHLWAPI.DLL');
  if FDllHandle <> 0 then
  begin
    @SHLockShared := GetProcAddress(FDllHandle, PChar(8));
    @SHUnLockShared := GetProcAddress(FDllHandle, PChar(9));
  end;
end;

procedure TTrayManager.CheckForDeadIcons;
var
  pItem : TTrayIcon;
  n : integer;
begin
  if Icons.Count = 0 then exit;

  for n := Icons.Count - 1 downto 0 do
  begin
    pItem := TTrayIcon(Icons.Items[n]);
    if not IsWindow(pItem.data.Wnd) then
    begin
      BroadCastTrayMessage(pItem,2);
      reseticon(pItem);
      Icons.Remove(pItem);
    end;
  end;
end;

destructor TTrayManager.Destroy;
begin
  WndList.Free;
  WndList := nil;
  Icons.Clear;
  Icons.Free;
  AppBarList.Clear;
  AppBarList.Free;

  if FDllHandle <> 0 then
  begin
    FreeLibrary(FDllHandle);
    FDllHandle := 0;
    SHLockShared := nil;
    SHUnlockShared := nil;
  end;

  inherited Destroy;
end;

function TTrayManager.FindTrayIcon(pData: TNotifyIconDataV7): TTrayIcon;
var
  n : integer;
  pItem : TTrayIcon;
begin
  for n := 0 to Icons.Count - 1 do
  begin
    pItem := TTrayIcon(Icons.Items[n]);
    if (pItem.data.Wnd = pData.Wnd) and
       (pItem.data.uID = pData.uID) then
    begin
      result := pItem;
      exit;
    end;
  end;
  result := nil;
end;

function TTrayManager.GetAppBarItem(pWnd: hwnd): TAppBarItem;
var
  n : integer;
begin
  result := nil;
  for n := 0 to AppBarList.Count - 1 do
    if TAppBarItem(AppBarList[n]).Data.abd.Wnd = pWnd then
    begin
      result := TAppBarItem(AppBarList[n]);
      exit;
    end;
end;

function TTrayManager.GetAutoHideAppBar(pEdge: Cardinal): TAppBarItem;
var
  n : integer;
begin
  result := nil;
  for n := 0 to AppBarList.Count - 1 do
    if ((TAppBarItem(AppBarList[n]).AutoHideBar) and (TAppBarItem(AppBarList[n]).Data.abd.uEdge = pEdge)) then
    begin
      result := TAppBarItem(AppBarList[n]);
      exit;
    end;
end;

function TTrayManager.HandleAppBarMessage(msg: TAppBarMsgDataV2; lparam : dword): integer;
var
  phandle : pAppBarDataV1;
  shellwndrect : TRect;
  shellwndmon : HMonitor;
  shellwndmoninfo : TMonitorInfo;
  ABItem : TAppBarItem;
  mon : HMonitor;
  moninfo : TMonitorInfo;
begin
  result := 0;
  case msg.dwMessage of
    // Retrieves the autohide and always-on-top states of the Windows taskbar.
    ABM_GETSTATE: result := 0; // Taskbar is neither in autohide nor always-on-top state

    // Registers a new appbar
    ABM_NEW: begin
      ABItem := TAppBarItem.Create(msg); // Create new app bar item;
      AppBarList.Add(ABItem);
      result := 1;
    end;

    // Registers or unregisters an autohide appbar for an edge of the screen.
    ABM_SETAUTOHIDEBAR: begin
      ABItem := GetAppBarItem(msg.abd.Wnd);
      if ABItem <> nil then
      begin
        if lparam = 0 then // unregister
        begin
          AppBarList.Remove(ABItem);
          result := 1;
        end else // register
        begin
          if GetAutoHideAppBar(msg.abd.uEdge) = nil then // register new
          begin
            ABItem.Data.abd.uEdge := msg.abd.uEdge;
            ABItem.AutoHideBar := True;
            result := 1;
          end else result := 0; // there is already an auto hide bar at this edge
        end;
      end;
    end;

    // Retrieves the handle to the autohide appbar associated with an edge of the screen.
    ABM_GETAUTOHIDEBAR: begin
      ABItem := GetAutoHideAppBar(msg.abd.uEdge);
      if ABItem <> nil then
        result := ABItem.Data.abd.Wnd
      else result := 0;
    end;

    // Notifies the system that an appbar has been activated.
    ABM_ACTIVATE: begin
      result := 1; // always return true
    end;

    // Unregisters an appbar by removing it from the system's internal list.
    ABM_REMOVE: begin
      ABItem := GetAppBarItem(msg.abd.Wnd);
      if ABItem <> nil then
      begin
        AppBarList.Remove(ABItem);
        if DeskAreaManager <> nil then
          DeskAreaManager.SetDeskArea;
      end;
      result := 1; // always return true
    end;

    // Sets the autohide and always-on-top states of the Microsoft Windows taskbar.
    ABM_SETSTATE: begin // we ignore this messages... 
      result := 1; // always return true
    end;

    // Notifies the system when an appbar's position has changed
    ABM_WINDOWPOSCHANGED: begin
      result := 1; // always return true
    end;

    // Requests a size and screen position for an appbar
    ABM_QUERYPOS,ABM_SETPOS: begin
      ABItem := GetAppBarItem(msg.abd.Wnd);
      if ABItem <> nil then
      begin
        ABItem.Data.abd.uEdge := msg.abd.uEdge;
        ABItem.Data.abd.rc := msg.abd.rc;        
        phandle := LockAppBarMemory(msg);
        if phandle <> nil then
        begin
          mon := MonitorFromWindow(phandle.Wnd, MONITOR_DEFAULTTONEAREST);
          moninfo.cbSize := SizeOf(moninfo);
          GetMonitorInfo(mon, @moninfo);
          if phandle.rc.Top < moninfo.rcWork.Top then
            phandle.rc.Top := moninfo.rcWork.Top;
          if phandle.rc.Bottom > moninfo.rcWork.Bottom then
            phandle.rc.Bottom := moninfo.rcWork.Bottom;
          ABItem.Data.abd.rc := phandle.rc;
          UnLockAppBarMempory(phandle);
        end;
      end;
      result := 1; // always return true
      if msg.dwMessage = ABM_SETPOS then
        if DeskAreaManager <> nil then
          DeskAreaManager.SetDeskArea;
    end;

    // Retrieves the bounding rectangle of the Windows taskbar
    ABM_GETTASKBARPOS: begin
      phandle := LockAppBarMemory(msg);
      if phandle <> nil then
      begin
        result := 1;
        if TrayNotifyWnd <> 0 then
        begin
          GetWindowRect(TrayNotifyWnd,phandle.rc);
          GetWindowRect(ShellTrayWnd,shellwndrect);
          shellwndmon := MonitorFromWindow(ShellTrayWnd, MONITOR_DEFAULTTONEAREST);
          shellwndmoninfo.cbSize := SizeOf(shellwndmoninfo);
          GetMonitorInfo(shellwndmon, @shellwndmoninfo);
          if shellwndrect.Top < shellwndmoninfo.rcMonitor.Top
             + (shellwndmoninfo.rcMonitor.Bottom - shellwndmoninfo.rcMonitor.Top) div 2 then
            phandle.uEdge := ABE_TOP
          else phandle.uEdge := ABE_BOTTOM;
        end;
        UnLockAppBarMempory(phandle);
      end;
    end;
  end;
end;

function TTrayManager.LockAppBarMemory(abmd: TAppBarMsgDataV2): pAppBarDataV1;
begin
  if (abmd.hSharedMemory <> 0) and (@SHLockShared <> nil) and (@SHUnLockShared <> nil) then
    result := pAppBarDataV1(SHLockShared(abmd.hSharedMemory,abmd.dwSourceProcessID))
  else result := nil;
end;

procedure TTrayManager.ModifyTrayIcon(pItem: TTrayIcon;
  pData: TNotifyIconDataV7; Hidden, Shared: boolean; Action: integer);
var
  n : integer;
  tempItem : TTrayIcon;
  foundshared : boolean;
begin
  if pItem = nil then
  begin
    pItem := TTrayIcon.Create;
    pItem.data.Wnd := pData.Wnd;
    pItem.data.uID := pdata.uID;
    pItem.data.Union.uVersion := 0;
    Icons.Add(pItem);
  end;
  pItem.data.uFlags := pData.uFlags;
  pItem.data.cbSize := pData.cbSize;

  if (pData.uFlags and NIF_MESSAGE) = NIF_MESSAGE then
     pItem.data.uCallbackMessage := pData.uCallbackMessage;

  if (pData.uFlags and NIF_TIP) = NIF_TIP then
  begin
    pItem.data.szTip := pData.szTip;
  end else
  if (pData.uFlags and NIF_INFO) = NIF_INFO then
  begin
    pItem.data.szInfo := pData.szInfo;
    pItem.data.szInfoTitle := pData.szInfoTitle;
    pItem.data.dwInfoFlags := pData.dwInfoFlags;
  end;

  foundshared := False;
  if (pData.uFlags and NIF_ICON) = NIF_ICON then
  begin
    ResetIcon(pItem);
    if pData.Icon <> 0 then
    begin
      if Shared then
      begin
        for n := Icons.Count - 1 downto 0  do
        begin
          tempItem := TTrayIcon(Icons.Items[n]);
          if (tempItem <> pItem) and
             (tempItem.hidden) and
             (not tempItem.shared) and
             (tempItem.data.Wnd = pData.Wnd) and
             (tempItem.orig_icon = pData.Icon) and
             (tempItem.data.Icon <> 0) then
          begin
            ResetSharing(tempItem);
            pItem.display := tempItem;
            pItem.data.Icon := tempItem.data.Icon;
            pItem.shared := True;
            foundshared := true;
            break;
          end;
        end;
      end;
      if not foundshared then
      begin
        pItem.data.Icon := CopyIcon(pData.Icon);
        pItem.shared := False;
      end;
      pItem.orig_icon := pData.Icon;
      pItem.hidden := hidden;
      if hidden = false then pItem.valid := true
         else pItem.valid := false;
    end;
  end;

  if pItem.valid then
     BroadCastTrayMessage(pItem,1)
     else BroadCastTrayMessage(pItem,2);
end;

procedure TTrayManager.RemoveTrayIcon(pItem: TTrayIcon);
begin
  if pItem.valid then
  begin
    BroadCastTrayMessage(pItem,2);
  end;

  if pItem.hidden then
     resetsharing(pItem);

  reseticon(pItem);
  Icons.Extract(pItem);
  pItem.Free;
end;

procedure TTrayManager.ResetIcon(pItem: TTrayIcon);
begin
  if ((not pItem.shared) and (pItem.Data.Icon <> 0)) then
     DestroyIcon(pItem.data.Icon);

  pItem.display := nil;
  pItem.orig_icon := 0;
  pItem.data.Icon := 0;
  pItem.valid := False;
end;

procedure TTrayManager.ResetSharing(pItem: TTrayIcon);
var
  n : integer;
  tempItem : TTrayIcon;
begin
  for n := 0 to Icons.Count - 1 do
  begin
    tempItem := TTrayIcon(Icons.Items[n]);
    if tempItem.display = pItem then
       resetIcon(tempItem);
  end;
end;

function TTrayManager.UnLockAppBarMempory(Pnt: pAppBarDataV1): boolean;
begin
 if (Pnt <> nil) and (@SHUnLockShared <> nil) then
    result := SHUnLockShared(Pnt)
    else result := False;
end;

procedure TTrayManager.UpdateTrayVersion(pItem: TTrayIcon;
  pData: TNotifyIconDataV7);
begin
  if pItem = nil then exit;
  
  pItem.data.Union.uVersion := pData.Union.uVersion;

  if pItem.valid then
     BroadCastTrayMessage(pItem,1)
     else BroadCastTrayMessage(pItem,2);
end;

{ TAppBarItem }

constructor TAppBarItem.Create(pData: TAppBarMsgDataV2);
begin
  inherited Create;
  AutoHideBar := False;
  Data.abd.cbSize := pData.abd.cbSize;
  Data.abd.Wnd := pData.abd.Wnd;
  Data.abd.uCallBackMessage := pData.abd.uCallBackMessage;
end;

{ TDeskAreaManager }


constructor TDeskAreaManager.Create;
begin
  inherited Create;

  setlength(FAutoModeList,0);
  setlength(FOffsetList,0);
  setlength(FMonIDList,0);

  FScreenChange := False;

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
  end else SendDebugMessageEx('Shell','Failed to register "DeskAreaTimerWndClass" window class',0,0);
end;

destructor TDeskAreaManager.Destroy;
begin
  if DeskAreaTimerWnd <> 0 then
  begin
    KillTimer(DeskAreaTimerWnd,1);
    DestroyWindow(DeskAreaTimerWnd);
    Windows.UnregisterClass(PChar('DeskAreaTimerWnd'),hInstance);
    UnRegisterAction('!EnableDeskArea');
    UnRegisterAction('!DisableDeskArea');
  end;

  SetFullScreenArea;
  setlength(FOffsetList,0);
  setlength(FAutoModeList,0);
  setlength(FMonIDList,0);

  inherited Destroy;
end;

procedure TDeskAreaManager.Enable;
begin
  SetTimer(DeskAreaTimerWnd,1,3000,nil);
  SetDeskArea;
end;

procedure TDeskAreaManager.Disable;
begin
  KillTimer(DeskAreaTimerWnd,1);
  SetFullScreenArea;
end;

procedure TDeskAreaManager.SetDeskArea;
var
  n,i,k : integer;
  BR : array of TBarRect;
  Area : TRect;
  am : boolean;
  MonID : integer;
  Index : integer;
  ABItem : TAppBarItem;
  r : Cardinal;
  MonCount : integer;
begin
  setlength(BR,0);
  for n := 0 to SharpApi.GetSharpBarCount - 1 do
  begin
    setlength(BR,length(BR)+1);
    BR[High(BR)] := SharpApi.GetSharpBarArea(n);
  end;

  MonCount := MonList.MonitorCount;

  for n := 0 to MonCount - 1 do
  begin
    if MonList.Monitors[n] = MonList.PrimaryMonitor then
      MonID := -100
    else MonID := MonList.Monitors[n].MonitorNum;

    Index := -1;
    for i := 0 to High(FMonIDList) do
      if FMonIDList[i] = MonID then
      begin
        Index := i;
        break;
      end;

    Area := MonList.Monitors[n].BoundsRect;

    if Index <> -1 then
      am := FAutoModeList[Index]
      else am := True;
    if am then
    begin
      for i := 0 to High(BR) do
      begin
        if IsWindowVisible(BR[i].wnd) then
           if PointInRect(Point(BR[i].R.Left + (BR[i].R.Right - BR[i].R.Left) div 2,
                                BR[i].R.Top + (BR[i].R.Bottom - BR[i].R.Top) div 2),
                          MonList.Monitors[n].BoundsRect) then
           begin
             if BR[i].R.Top < MonList.Monitors[n].Top + MonList.Monitors[n].Height div 2 then
                Area.Top := Max(Area.Top,BR[i].R.Bottom)
                else Area.Bottom := Min(Area.Bottom,BR[i].R.Top);
           end;
      end;
    end;

    // apply custom monitor offsets
    if Index <> -1 then
    begin
      Area.Left   := Area.Left + FOffsetList[Index].Left;
      Area.Top    := Area.Top + FOffsetList[Index].Top;
      Area.Right  := Area.Right - FOffsetList[Index].Right;
      Area.Bottom := Area.Bottom - FOffsetList[Index].Bottom;
    end;

    // apply app bars
    if TrayManager <> nil then
      for i := 0 to TrayManager.AppBarList.Count - 1 do
      begin
        ABItem := TAppBarItem(TrayManager.AppBarList.Items[i]);
        if not ABItem.AutoHideBar then
          if PointInRect(Point(ABItem.Data.abd.rc.Left + (ABItem.Data.abd.rc.Right - ABItem.Data.abd.rc.Left) div 2,
                               ABItem.Data.abd.rc.Top + (ABItem.Data.abd.rc.Bottom - ABItem.Data.abd.rc.Top) div 2),
                         MonList.Monitors[n].BoundsRect) then
          begin
            if ((ABItem.Data.abd.uEdge = ABE_RIGHT) and (Area.Right > ABItem.Data.abd.rc.Left)) then
              Area.Right := ABItem.Data.abd.rc.Left
            else if ((ABItem.Data.abd.uEdge = ABE_LEFT) and (Area.Left < ABItem.Data.abd.rc.Right) and (Area.Right > ABItem.Data.abd.rc.Left)) then
              Area.Left := ABItem.Data.abd.rc.Right
          end;
      end;

    if ((Win32MajorVersion = 5) and (Win32MinorVersion >= 1)) or (Win32MajorVersion = 6) then
    begin
      if not uxTheme.IsThemeActive then
      begin
        Area.Top := Area.Top + 4;
        Area.Bottom := Area.Bottom - 4;
      end;
    end;

    k := 0;
    if (Area.Left <> MonList.Monitors[n].WorkareaRect.Left) or
       (Area.Right <> MonList.Monitors[n].WorkareaRect.Right) or
       (Area.Top <> MonList.Monitors[n].WorkareaRect.Top) or
       (Area.Bottom <> MonList.Monitors[n].WorkareaRect.Bottom) then
    begin
      SystemParametersInfo(SPI_SETWORKAREA, k, @Area, SPIF_UPDATEINIFILE);
  //      SharpEBroadCast(WM_SETTINGCHANGE,SPI_SETWORKAREA, 0)
  //      SendMessage(HWND_BROADCAST, WM_SETTINGCHANGE, SPI_SETWORKAREA, 0);
      SendMessageTimeOut(HWND_BROADCAST, WM_SETTINGCHANGE, SPI_SETWORKAREA, 0,SMTO_ABORTIFHUNG,20,r);
    end
  end;
  setlength(BR,0);
end;

procedure TDeskAreaManager.SetFullScreenArea;
var
  n : integer;
  i : cardinal;
  Area : TRect;
  Mon : TMonitorItem;
  r: Cardinal;
begin
  i := 0;
  try
    for n := 0 to MonList.MonitorCount - 1 do
    begin
      Mon := MonList.Monitors[n];
      Area := Rect(Mon.Left,Mon.Top,Mon.Left + Mon.Width, Mon.Top + Mon.Height);
      SystemParametersInfo(SPI_SETWORKAREA, i, @Area, SPIF_UPDATEINIFILE);
      SendMessageTimeOut(HWND_BROADCAST, WM_SETTINGCHANGE, SPI_SETWORKAREA, 0,SMTO_ABORTIFHUNG,20,r);
    end;
  except
    exit;
  end;
end;

procedure TDeskAreaManager.LoadSettings;
var
  XML : TJclSimpleXML;
  Dir : String;
  n : integer;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpCore\Services\DeskArea\';
  setlength(FOffsetList,0);
  setlength(FAutoModeList,0);
  setlength(FMonIDList,0);
  if FileExists(Dir + 'DeskArea.xml') then
  begin
    XML := TJclSimpleXML.Create;
    try
      XML.LoadFromFile(Dir + 'DeskArea.xml');
      if XML.Root.Items.ItemNamed['Monitors'] <> nil then
         with XML.Root.Items.ItemNamed['Monitors'].Items do
         begin
           for n := 0 to Count - 1 do
               with XML.Root.Items.ItemNamed['Monitors'].Items.Item[n].Items do
               begin
                 setlength(FMonIDList,length(FMonIDList)+1);
                 FMonIDList[High(FMonIDList)] := IntValue('ID',-1);
                 setlength(FAutoModeList,length(FAutoModeList)+1);
                 FAutoModeList[High(FAutoModeList)] := BoolValue('AutoMode',True);
                 setlength(FOffsetList,length(FOffsetList)+1);
                 with FOffsetList[High(FOffsetList)] do
                 begin
                   Left   := IntValue('Left',0);
                   Top    := IntValue('Top',0);
                   Right  := IntValue('Right',0);
                   Bottom := IntValue('Bottom',0);
                 end;
               end;
         end;
    finally
      XML.Free;
    end;
  end;
end;

begin
end.


