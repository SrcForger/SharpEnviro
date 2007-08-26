{
Source Name: TaskManager.dpr
Description: TaskManager Service library file
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.SharpE-Shell.org

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

library TaskManager;

uses
  windows,
  messages,
  SysUtils,
  Classes,
  SharpApi;


type
  TTaskManager = Class(Tobject)
    private
      WM_SHELLHOOK : integer;    
      FWndList : array of hwnd;
      FMsgWnd : hwnd;
      Procedure MessageHandler(var msg: TMessage);
      Procedure RegisterHook;
      Procedure UnregisterHook;
      Procedure AllocateMsgWnd;
      Procedure DeAllocateMsgWnd;
      Procedure DeleteWnd(Index : Integer);
      Procedure DeleteWndByHandle(wnd : hwnd);
      Procedure AddWnd(wnd : hwnd);
      function FindWindow(wnd : hwnd) : integer;
    public
      constructor Create; reintroduce;
      destructor Destroy; override;
    end;

var
  TM : TTaskManager;
  ShellHookMsgWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'SharpE_ShellHook');

{$E ser}

{$R *.RES}

function RegisterShellHook(wnd : hwnd; param : dword) : boolean; stdcall; external 'shell32.dll' index 181;

// Service is started
function Start(owner: hwnd): hwnd;
begin
  Result := owner;
  
  TM := TTaskManager.Create;
end;

// Service is stopped
procedure Stop;
begin
  TM.Free;
end;

// Service receives a message
function SCMsg(msg: string): integer;
begin
  Result := HInstance;
end;


//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  SCMsg;

{ TTaskManager }

procedure TTaskManager.AddWnd(wnd: hwnd);
begin
  if FindWindow(wnd) <> -1 then
    exit;

  setlength(FWndList,length(FWndList)+1);
  FWndList[High(FWndList)] := wnd;
end;

procedure TTaskManager.AllocateMsgWnd;
var
  TempClass: TWndClass;
  ClassRegistered: Boolean;
begin
  ShellHookMsgWndClass.hInstance := HInstance;
{$IFDEF PIC}
  UtilWindowClass.lpfnWndProc := @DefWindowProc;
{$ENDIF}
  ClassRegistered := GetClassInfo(HInstance, ShellHookMsgWndClass.lpszClassName,TempClass);
  if not ClassRegistered or (TempClass.lpfnWndProc <> @DefWindowProc) then
  begin
    if ClassRegistered then
      Windows.UnregisterClass(ShellHookMsgWndClass.lpszClassName, HInstance);
    Windows.RegisterClass(ShellHookMsgWndClass);
  end;
  FMsgWnd := CreateWindowEx(WS_EX_TOOLWINDOW, ShellHookMsgWndClass.lpszClassName,
                            '', WS_POPUP {+ 0}, 0, 0, 0, 0, 0, 0, HInstance, nil);
  SetWindowLong(FMsgWnd, GWL_WNDPROC, Longint(MakeObjectInstance(MessageHandler)));
end;

constructor TTaskManager.Create;
begin
  inherited Create;

  WM_SHELLHOOK := RegisterWindowMessage('SHELLHOOK');
  AllocateMsgWnd;
  setlength(FWndList,0);

  SharpApi.SharpEBroadCast(WM_SHELLHOOKWINDOWCREATED,FMsgWnd,0);

  RegisterHook;
end;

procedure TTaskManager.DeAllocateMsgWnd;
var
  Instance: Pointer;
begin
  Instance := Pointer(GetWindowLong(FMsgWnd, GWL_WNDPROC));
  DestroyWindow(FMsgWnd);
  if Instance <> @DefWindowProc then FreeObjectInstance(Instance);
end;

procedure TTaskManager.DeleteWnd(Index: Integer);
var
  n : integer;
begin
  if (Index > High(FWndList)) or (Index < Low(FWndList)) then
    exit;

  for n := Index to High(FWndList) - 1 do
    FWndList[n] := FWndList[n+1];
  setlength(FWndList,length(FWndList)-1);
end;

procedure TTaskManager.DeleteWndByHandle(wnd: hwnd);
var
  Index : integer;
begin
  Index := FindWindow(wnd);
  if Index <> -1 then
    DeleteWnd(Index);
end;

destructor TTaskManager.destroy;
begin
  UnregisterHook;

  DeAllocateMsgWnd;
  setlength(FWndList,0);

  inherited Destroy;
end;

function TTaskManager.FindWindow(wnd: hwnd): integer;
var
  n : integer;
begin
  result := -1;
  for n := 0 to High(FWndList) do
    if FWndList[n] = wnd then
    begin
      result := n;
      break;
    end;
end;

procedure TTaskManager.MessageHandler(var msg: TMessage);
var
  n : integer;
begin
  if msg.Msg = WM_SHELLHOOK then
  begin
    for n := High(FWndList) downto 0 do
      if IsWindow(FWndList[n]) then
        PostMessage(FWndList[n],WM_SHARPSHELLMESSAGE,msg.WParam,msg.LParam)
      else DeleteWnd(n);
  end else
  case msg.Msg of
    WM_REGISTERSHELLHOOK: AddWnd(msg.WParam);
    WM_UNREGISTERSHELLHOOK: DeleteWndByHandle(msg.WParam);
  end;
end;

procedure TTaskManager.RegisterHook;
var
  mm: MINIMIZEDMETRICS;
begin
  FillChar(mm, SizeOf(MINIMIZEDMETRICS), 0);

  mm.cbSize := SizeOf(MINIMIZEDMETRICS);
  SystemParametersInfo(SPI_GETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

  mm.iArrange := mm.iArrange or ARW_HIDE;
  SystemParametersInfo(SPI_SETMINIMIZEDMETRICS, sizeof(MINIMIZEDMETRICS),@mm, 0);

  RegisterShellHook(0,1);
  RegisterShellHook(FMsgWnd,3);
end;

procedure TTaskManager.UnregisterHook;
begin
  RegisterShellHook(FMsgWnd,0);
end;

end.


