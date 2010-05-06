{
Source Name: VWM.service
Description: Virtual Window Manager Service
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
along with this program.  If not, see <http://www.gnu.org/licenses/>.}

library VWM;

uses

  Windows,
  Classes,
  MultiMon,
  Messages,
  Math,
  SharpAPI,
  MonitorList,
  SharpThemeApiEx,
  uISharpESkin,
  Dialogs,
  SysUtils,
  JclSimpleXML,
  ISharpESkinComponents,
  SharpTypes,
  {$IFDEF DEBUG}DebugDialog,{$ENDIF}
  VWMFunctions in '..\..\..\Common\Units\VWM\VWMFunctions.pas',
  uSystemFuncs in '..\..\..\Common\Units\SystemFuncs\uSystemFuncs.pas',
  SharpNotify in '..\..\..\Common\Units\SharpNotify\SharpNotify.pas';

{$R *.res}

type
  TActionEvent = class(TObject)
    procedure MessageHandler(var Message: TMessage);
  end;

var
  VWMMsgWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'SharpE_VWM');

const

  VWMStartMessage = 5;
  VWMMoveMessage = 50;

var
  SkinInterface : ISharpESkinInterface;
  ActionEvent: TActionEvent;
  Handle: THandle;
  CurrentDesktop: integer;
  VWMCount: integer;
  sFocusTopMost: boolean;
  sFollowFocus: boolean;
  sResetOnResChange: boolean;
  sShowOCD: boolean;
  LastDShellMessageTime: Int64;
  SkinManager: ISharpESkinManager;
  LastActiveWnd: hwnd;

procedure AllocateMsgWnd;
var
  TempClass: TWndClass;
  ClassRegistered: Boolean;
begin
  VWMMsgWndClass.hInstance := HInstance;
{$IFDEF PIC}
  UtilWindowClass.lpfnWndProc := @DefWindowProc;
{$ENDIF}
  ClassRegistered := GetClassInfo(HInstance, VWMMsgWndClass.lpszClassName, TempClass);
  if not ClassRegistered or (TempClass.lpfnWndProc <> @DefWindowProc) then
  begin
    if ClassRegistered then
      Windows.UnregisterClass(VWMMsgWndClass.lpszClassName, HInstance);
    Windows.RegisterClass(VWMMsgWndClass);
  end;
  Handle := CreateWindowEx(WS_EX_TOOLWINDOW, VWMMsgWndClass.lpszClassName,
    '', WS_POPUP {+ 0}, 0, 0, 0, 0, 0, 0, HInstance, nil);
  SetWindowLong(Handle, GWL_WNDPROC, Longint(MakeObjectInstance(ActionEvent.MessageHandler)));
end;

procedure DeAllocateMsgWnd;
var
  Instance: Pointer;
begin
  Instance := Pointer(GetWindowLong(Handle, GWL_WNDPROC));
  DestroyWindow(Handle);
  if Instance <> @DefWindowProc then FreeObjectInstance(Instance);
end;
procedure ShowOCD;
var
  x, y: integer;
  mon: HMonitor;
  moninfo: TMonitorInfo;
  p: TPoint;
begin
  if not sShowOCD then
    exit;

  GetCursorPos(p);
  mon := MonitorFromPoint(p, MONITOR_DEFAULTTOPRIMARY);
  moninfo.cbSize := SizeOf(moninfo);
  GetMonitorInfo(mon, @moninfo);
  x := moninfo.rcMonitor.Left + (moninfo.rcMonitor.Right - moninfo.rcMonitor.Left) div 2;
  y := moninfo.rcMonitor.Bottom - 30;

  SharpNotify.CreateNotifyText(0, nil, x, y, inttostr(CurrentDEsktop), neBottomCenter, SkinManager, 2000, moninfo.rcMonitor, True);
end;

procedure LoadVWMSettings;
var
  XML: TJclSimpleXML;
  Dir: string;
  FName: string;
  fileloaded: boolean;
  movetw : boolean;
begin
  VWMCount := 4;
  SharpApi.UnRegisterShellHookReceiver(Handle);
  sFocusTopMost := False;
  sFollowFocus := False;
  sResetOnResChange := True;
  sShowOCD := True;
  movetw := True;
  Dir := GetSharpeUserSettingsPath + 'SharpCore\Services\VWM\';
  FName := Dir + 'VWM.xml';
  if FileExists(FName) then
  begin
    XML := TJclSimpleXML.Create;
    try
      XML.LoadFromFile(FName);
      fileloaded := True;
    except
      fileloaded := False;
    end;
    if FileLoaded then
    begin
      VWMCount := XML.Root.Items.IntValue('VWMCount', VWMCount);
      VWMCount := Max(2, Min(VWMCount, 12));
      movetw := XML.Root.Items.BoolValue('MoveToolWindows', movetw);
      sFocusTopMost := XML.Root.Items.BoolValue('FocusTopMost', sFocusTopMost);
      sFollowFocus := XML.Root.Items.BoolValue('FollowFocus', sFollowFocus);
      sShowOCD := XML.Root.Items.BoolValue('ShowOCD', sShowOCD);
      sResetOnResChange := XML.Root.Items.BoolValue('ResetOnDisplayChange', sResetOnResChange);
    end;
    XML.Free;
  end;
  VWMFunctions.VWMMoveToolWindows := movetw;
  if sFollowFocus then
    SharpApi.RegisterShellHookReceiver(Handle);
end;

procedure RegisterSharpEActions;
var
  n: integer;
begin
  // Register Actions
  SharpApi.RegisterActionEx('!AllToOneVWM', 'VWM', handle, 0);
  SharpApi.RegisterActionEx('!NextVWM', 'VWM', handle, 1);
  SharpApi.RegisterActionEx('!PreviousVWM', 'VWM', handle, 2);
  for n := 0 to VWMCount - 1 do
  begin
    SharpApi.RegisterActionEx(PChar('!SwitchToVWM(' + inttostr(n + 1) + ')'),
      'VWM',
      handle,
      VWMStartMessage + n);

    SharpApi.RegisterActionEx(PChar('!MoveWindowToVWM(' + inttostr(n + 1) + ')'),
      'VWM',
      handle,
      VWMMoveMessage + n);
  end;
end;

procedure UnregisterSharpEActions;
var
  n: integer;
begin
  // Unregister Actions
  SharpApi.UnRegisterAction('!AllToOneVWM');
  SharpApi.UnRegisterAction('!NextVWM');
  SharpApi.UnRegisterAction('!PreviousVWM');
  for n := 0 to VWMCount - 1 do
  begin
    SharpApi.UnRegisterAction(PCHar('!SwitchToVWM(' + inttostr(n + 1) + ')'));
    SharpApi.UnRegisterAction(PChar('!MoveWindowToVWM(' + inttostr(n + 1) + ')'));
  end;
end;

function GetWndClass(pHandle: hwnd): string;
var
  buf: array[0..254] of Char;
begin
  GetClassName(pHandle, buf, SizeOf(buf));
  result := buf;
end;

procedure TActionEvent.MessageHandler(var Message: TMessage);
var
  newdesk: integer;
  changed: boolean;
  cname : String;
  wnd: hwnd;
begin
  changed := False;
  // Message Handlers
  case Message.Msg of
    WM_SHELLHOOKWINDOWCREATED: begin
        if sFollowFocus then
          RegisterShellHookReceiver(Handle)
      end;
    WM_SHARPEACTIONMESSAGE:
      begin
        case Message.lparam of
          0: begin // !AllToOneVWM
              VWMFunctions.VWMMoveAllToOne(CurrentDesktop, False); // has to be called two times ...
              VWMFunctions.VWMMoveAllToOne(CurrentDesktop, True); // ... reason ... unknown =)
              Changed := True;
            end;

          1: begin // !NextVWM
              newdesk := CurrentDesktop + 1;
              if newdesk > VWMCount then
                newdesk := 1;
              VWMFunctions.VWMSwitchDesk(CurrentDesktop, newdesk, sFocusTopMost);
              CurrentDesktop := newdesk;
              ShowOCD;
              Changed := True;
            end;

          2: begin // !NextVWM
              newdesk := CurrentDesktop - 1;
              if newdesk < 1 then
                newdesk := VWMCount;
              VWMFunctions.VWMSwitchDesk(CurrentDesktop, newdesk, sFocusTopMost);
              CurrentDesktop := newdesk;
              ShowOCD;
              Changed := True;
            end;
        else
          begin
            if (Message.lparam >= VWMMoveMessage)
              and (Message.lparam < VWMMoveMessage + VWMCount) then
            begin
              wnd := GetForegroundWindow;
              if wnd <> 0 then
              begin
                cname := GetWndClass(wnd);
                if IsWindowVisible(wnd)
                  and (CompareText(cname,'TSharpBarMainForm') <> 0)
                  and (CompareText(cname,'TSharpDeskMainForm') <> 0)
                  and (CompareText(cname,'TSharpEMenuWnd') <> 0)
                  and (CompareText(cname,'TSharpCoreMainWnd') <> 0) then
                begin
                  VWMFunctions.VWMMoveWindotToVWM(Message.lparam - VWMMoveMessage + 1,CurrentDesktop,VWMCount,wnd);
                end;
              end;
            end else
            if (Message.lparam >= VWMStartMessage)
              and (Message.lparam < VWMStartMessage + VWMCount) then
            begin
              VWMFunctions.VWMSwitchDesk(CurrentDesktop, Message.lparam - VWMStartMessage + 1, sFocusTopMost);
              CurrentDesktop := Message.lparam - VWMStartMessage + 1;
              ShowOCD;
              Changed := True;
            end;
          end;
        end;
      end;
    WM_SHARPEUPDATEACTIONS:
      begin
        RegisterSharpEActions;
      end;
    WM_VWMSWITCHDESKTOP:
      begin
        if (Message.lparam > 0)
          and (Message.lparam <= VWMCount) then
        begin
          VWMFunctions.VWMSwitchDesk(CurrentDesktop, Message.lparam, sFocusTopMost, Cardinal(Message.WParam));
          CurrentDesktop := Message.lparam;
          ShowOCD;
          Changed := True;
          Message.Result := CurrentDesktop;
        end else Message.Result := 0;
      end;
    WM_VWMGETDESKCOUNT:
      begin
        Message.result := VWMCount;
      end;
    WM_VWMGETCURRENTDESK:
      begin
        Message.result := CurrentDesktop;
      end;
    WM_VWMGETMOVETOOLWINDOWS:
      begin
        if VWMFunctions.VWMMoveToolWindows then
          Message.result := 1
        else Message.result := 0;
      end;
    WM_SHARPEUPDATESETTINGS:
      begin
        if Message.wparam = Integer(suVWM) then
        begin
          CurrentDesktop := 1;
          VWMFunctions.VWMMoveAllToOne(CurrentDesktop, False); // has to be called two times ...
          VWMFunctions.VWMMoveAllToOne(CurrentDesktop, True); // ... reason ... unknown =)
          UnregisterSharpEActions;
          LoadVWMSettings;
          RegisterSharpEActions;
          SharpApi.SharpEBroadCast(WM_VWMUPDATESETTINGS, 0, 0);
        end;
      end;
    WM_DISPLAYCHANGE:
      begin
        if sResetOnResChange then
        begin
          MonList.GetMonitors;
          CurrentDesktop := 1;

          VWMFunctions.VWMMoveAllToOne(CurrentDesktop, False); // has to be called two times ...
          VWMFunctions.VWMMoveAllToOne(CurrentDesktop, True); // ... reason ... unknown =)
          SharpApi.SharpEBroadCast(WM_VWMUPDATESETTINGS, 0, 0);
        end;
      end;
    WM_SHARPSHELLMESSAGE:
      begin
        Message.Result := 0;

        if sFollowFocus then
        begin
          wnd := Cardinal(Message.lparam);
          case Message.WParam of
            HSHELL_WINDOWCREATED, HSHELL_WINDOWDESTROYED: begin
                LastDShellMessageTime := GetTickCount;
              end;
            HSHELL_GETMINRECT: begin
                LastDShellMessageTime := GetTickCount;
              end;
            HSHELL_WINDOWACTIVATED, HSHELL_WINDOWACTIVATED + 32768: begin
                if (GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) and
                  (((IsWindowVisible(Wnd) and not IsIconic(wnd)) and
                  ((GetWindowLong(Wnd, GWL_HWNDPARENT) = 0) or
                  (GetWindowLong(Wnd, GWL_HWNDPARENT) = Integer(GetDesktopWindow))) and
                  (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0))) and
                  (GetTickCount - LastDShellMessageTime > 200) and
                  (LastActiveWnd <> wnd) then
                begin
                  newdesk := VWMFunctions.VWMGetWindowVWM(CurrentDesktop, VWMCount, wnd);
                  if newdesk <> CurrentDesktop then
                  begin
                    VWMFunctions.VWMSwitchDesk(CurrentDesktop, NewDesk, False);
                    CurrentDesktop := NewDesk;
                    ShowOCD;
                    Changed := True;
                  end;
                end;
                LastActiveWnd := wnd;
              end;
          end;
        end;
      end;
  else Message.Result := DefWindowProc(Handle, Message.Msg, Message.WParam, Message.LParam);
  end;
  if Changed then
    SharpApi.SharpEBroadCast(WM_VWMDESKTOPCHANGED, CurrentDesktop, 0);
end;

// Service is started
function StartEx(owner: hwnd; pSkinInterface : ISharpESkinInterface): hwnd;
begin
  SkinInterface := pSkinInterface;
  SkinManager := SkinInterface.SkinManager;

  ActionEvent := TActionEvent.Create;
  AllocateMsgWnd;
  LastDShellMessageTime := GetTickCount;
  LoadVWMSettings;
  CurrentDesktop := 1;
  VWMFunctions.VWMMoveAllToOne(CurrentDesktop, False); // has to be called two times ...
  VWMFunctions.VWMMoveAllToOne(CurrentDesktop, True); // ... reason ... unknown =)
  Result := Owner;

  // Register Actions
  RegisterSharpEActions;
  SharpApi.SharpEBroadCast(WM_VWMUPDATESETTINGS, 0, 0);
  ServiceDone('VWM');
end;

// Service is stopped
procedure Stop;
begin
  VWMFunctions.VWMMoveAllToOne(1, False); // has to be called two times ...
  VWMFunctions.VWMMoveAllToOne(1, True); // ... reason ... unknown =)

  // Unregister Actions
  UnregisterSharpEActions;
  DeAllocateMsgWnd;
  ActionEvent.Free;
  VWMCount := 0;
  SharpApi.SharpEBroadCast(WM_VWMUPDATESETTINGS, 0, 0);
end;

// Service receives a message
function SCMsg(msg: string): Integer;
begin
  Result := HInstance;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'VWM';
    Description := 'Manages the Virtual Window Manager';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteService;
    ExtraData := 'priority: 120| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  StartEx,
  Stop,
  SCMsg,
  GetMetaData;

begin

end.

