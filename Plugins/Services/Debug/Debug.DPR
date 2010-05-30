{
Source Name: Debug.dpr
Description: Debug Service
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

library Debug;

uses
  Windows,
  Messages,
  Classes,
  Contnrs,
  DateUtils,
  SysUtils,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  SharpApi;

type
  TDebugLog = class(TObject)
    private
      FErrorLog : THandle;
      procedure WriteString(Handle : THandle; Text : String);
    public
      constructor Create; reintroduce;
      destructor Destroy; override;

      procedure WriteLog(Module,Msg : String; msgType : integer);
  end;

  TActionEvent = class(TObject)
    procedure MessageHandler(var msg: TMessage);
  end;

var
  DebugMsgWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'TSharpEDebugWnd');

var
  Thread : THandle;
  ThreadID : dword;
  DebugLog : TDebugLog;

{$R *.RES}


function msgThread(): LongInt; stdcall;
var
  wMSG   : tmsg;
  AE : TActionEvent;
  wnd : hwnd;
  TempClass: TWndClass;
  ClassRegistered: Boolean;
  Instance: Pointer;
begin
  AE := TActionEvent.Create;

  DebugMsgWndClass.hInstance := HInstance;
  {$IFDEF PIC} UtilWindowClass.lpfnWndProc := @DefWindowProc; {$ENDIF}
  ClassRegistered := GetClassInfo(HInstance, DebugMsgWndClass.lpszClassName, TempClass);
  if not ClassRegistered or (TempClass.lpfnWndProc <> @DefWindowProc) then
  begin
    if ClassRegistered then
      Windows.UnregisterClass(DebugMsgWndClass.lpszClassName, HInstance);
    Windows.RegisterClass(DebugMsgWndClass);
  end;
  wnd := CreateWindowEx(WS_EX_TOOLWINDOW, DebugMsgWndClass.lpszClassName,
                        '', WS_POPUP {+ 0}, 0, 0, 0, 0, 0, 0, HInstance, nil);
  SetWindowLong(wnd, GWL_WNDPROC, Longint(MakeObjectInstance(AE.MessageHandler)));

  try
    while wMSG.message <> WM_USER+$FFFF do
    begin
      GetMessage(wMsg,0,0,0);
      TranslateMessage(wMsg);
      DispatchMessage(wMsg);
    end;
  except
  end;

  Instance := Pointer(GetWindowLong(wnd, GWL_WNDPROC));
  DestroyWindow(wnd);
  if Instance <> @DefWindowProc then
    FreeObjectInstance(Instance);
  AE.Free;

  result := 0;  
end;

function Start(owner: hwnd): hwnd;
begin
  DebugLog := TDebugLog.Create;

  ThreadID := 0;
  Thread := CreateThread(nil, 0, TFNThreadStartRoutine(@msgThread), nil, 0, ThreadID);

  result := 0;       
  ServiceDone('Debug');
end;

procedure Stop;
begin
  if Thread <> 0 then
  begin
    PostThreadMessage(ThreadID,WM_USER+$FFFF,0,0);
    WaitForSingleObject(Thread,10000);
    CloseHandle(Thread);
  end;

  DebugLog.Free;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Debug';
    Description := 'Logging of all Debug Messages';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteService;
    ExtraData := 'priority: 1| delay: 0';
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Start,
  Stop,
  GetMetaData;

{ TActionEvent }

procedure TActionEvent.MessageHandler(var msg: TMessage);
var
  cmsg: TConsoleMsg;
begin
  if msg.Msg = WM_COPYDATA then
  begin
    cmsg := PConsoleMsg(PCopyDataStruct(msg.lParam)^.lpData)^;
    DebugLog.WriteLog(cmsg.module,cmsg.msg,msg.WParam);
  end;
end;


{ TDebugList }

constructor TDebugLog.Create;
var
  Dir : String;
  LogErrorFile : String;
begin
  Inherited Create;

  Dir := SharpApi.GetSharpeDirectory + 'Logs\';
  ForceDirectories(Dir);

  LogErrorFile := Dir + 'Error.txt';
  if not FileExists(LogErrorFile) then
    FileClose(FileCreate(LogErrorFile));

  FErrorLog := FileOpen(LogErrorFile,fmOpenReadWrite or fmShareDenyWrite);
  if FErrorLog > 0 then
    FileSeek(FErrorLog,0,2);
end;

destructor TDebugLog.Destroy;
begin
  if FErrorLog > 0 then
    FileClose(FErrorLog);

  inherited Destroy;
end;

procedure TDebugLog.WriteLog(Module, Msg: String; msgType: integer);
var
  Text : String;
begin
  // Currently we only handle DMT_ERROR
  if msgType <> DMT_ERROR then
    exit;
  if FErrorLog <= 0 then
    exit;

  Text := FormatDateTime('dd/mm/yyyy hh:nn:ss', now) + '|';
  Text := Text + Module + '|' + Msg + #13#10;

  case msgType of
    DMT_ERROR: WriteString(FErrorLog,Text);
  end;
end;

procedure TDebugLog.WriteString(Handle: THandle; Text: String);
var
  Len : Word;
begin
  Len := Length(Text);
  if Len > 0 then
    FileWrite(Handle,Pointer(Text)^,Len);
end;

begin
end.


