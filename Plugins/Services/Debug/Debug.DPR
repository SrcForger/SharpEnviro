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
//  VCLFixPack,
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
      procedure WriteString(Text : String);
    public
      constructor Create; reintroduce;
      destructor Destroy; override;

      procedure WriteLog(Module,Msg : String; msgType : integer);
  end;

  TActionEvent = class(TObject)
    procedure ParseCopyData(str: string; var module, msg: string);
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

{$R 'VersionInfo.res'}
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

procedure TActionEvent.ParseCopyData(str: string; var module, msg: string);
begin
  module := Copy(str, 0, Pos('||', str) - 1);
  msg := Copy(str, Length(module) + 3);
end;

procedure TActionEvent.MessageHandler(var msg: TMessage);
var
  module, mess: string;
begin
  if msg.Msg = WM_COPYDATA then
  begin
    ParseCopyData(PChar(PCopyDataStruct(msg.lParam)^.lpData), module, mess);
    DebugLog.WriteLog(module,mess,msg.WParam);
  end;
end;


{ TDebugList }

constructor TDebugLog.Create;
begin
  Inherited Create;
end;

destructor TDebugLog.Destroy;
begin
  inherited Destroy;
end;

procedure TDebugLog.WriteLog(Module, Msg: String; msgType: integer);
var
  Text : String;
begin
  Text := FormatDateTime('dd/mm/yyyy hh:nn:ss', now) + '|';

  case msgType of
    DMT_INFO: Text := Text + 'INFO|';
    DMT_STATUS: Text := Text + 'STATUS|';
    DMT_WARN: Text := Text + 'WARN|';
    DMT_ERROR: Text := Text + 'ERROR|';
    DMT_TRACE: Text := Text + 'TRACE|';
  end;

  Text := Text + Module + '|' + Msg + #13#10;

  WriteString(Text);
end;

procedure TDebugLog.WriteString(Text: String);
var
  Dir, LogFile : String;
  Log: THandle;
  Len : Word;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'Logs\';
  ForceDirectories(Dir);

  LogFile := Dir + 'Log';
  LogFile := LogFile + '-' + FormatDateTime('yyyy-mm-dd', now);
  LogFile := LogFile + '.log';
  if not FileExists(LogFile) then
    FileClose(FileCreate(LogFile));

  Log := FileOpen(LogFile,fmOpenReadWrite or fmShareDenyWrite);
  if Log > 0 then
    FileSeek(Log,0,2);

  Len := Length(Text);
  if Len > 0 then
    FileWrite(Log,Pointer(Text)^,Len);

  FileClose(Log);
end;

begin
end.


