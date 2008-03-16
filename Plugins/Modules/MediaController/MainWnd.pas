{
Source Name: MainWnd.pas
Description: Button Module - Main Window
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, SharpEButton, SharpESkinManager, 
  SharpApi, Menus, Math, ShellApi,
  GR32,  Types, SharpEBaseControls, ExtCtrls;


type
  TMainForm = class(TForm)
    SharpESkinManager1: TSharpESkinManager;
    btn_next: TSharpEButton;
    btn_prev: TSharpEButton;
    btn_pause: TSharpEButton;
    btn_stop: TSharpEButton;
    btn_play: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btn_prevClick(Sender: TObject);
    procedure btn_stopClick(Sender: TObject);
    procedure btn_pauseClick(Sender: TObject);
    procedure btn_playClick(Sender: TObject);
    procedure btn_nextClick(Sender: TObject);
  protected
  private
    Background  : TBitmap32;
    procedure WMExecAction(var msg : TMessage); message WM_SHARPEACTIONMESSAGE;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateBackground(new : integer = -1);
    procedure UpdateSharpEActions;
  end;

var
 WM_SHELLHOOK : integer;

implementation


uses uSharpBarAPI;

{$R *.dfm}

procedure TMainForm.UpdateSharpEActions;
begin
  SharpApi.RegisterActionEx('!MC-Play','Modules',Handle,1);
  SharpApi.RegisterActionEx('!MC-Pause','Modules',Handle,2);
  SharpApi.RegisterActionEx('!MC-Stop','Modules',Handle,3);
  SharpApi.RegisterActionEx('!MC-Prev','Modules',Handle,4);
  SharpApi.RegisterActionEx('!MC-Next','Modules',Handle,5);
end;

procedure TMainForm.WMExecAction(var msg : TMessage);
begin
  case msg.LParam of
    1: btn_play.OnClick(btn_play);
    2: btn_pause.OnClick(btn_pause);
    3: btn_stop.OnClick(btn_stop);
    4: btn_prev.OnClick(btn_prev);
    5: btn_next.OnClick(btn_next);
  end;
end;

procedure TMainForm.LoadSettings;
begin
  UpdateActions;
end;

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  NewWidth := Max(1,NewWidth);

  UpdateBackground(NewWidth);

  Width := NewWidth;
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
  i : integer;
begin
  btn_play.Width    := btn_play.Height;
  btn_pause.Width   := btn_pause.Height;
  btn_stop.Width    := btn_stop.Height;
  btn_prev.Width    := btn_prev.Height;
  btn_next.Width    := btn_next.Height;

  btn_play.Left := 2;
  btn_pause.Left := btn_play.Left + btn_play.Width + 1;
  btn_stop.Left := btn_pause.Left + btn_pause.Width + 1;
  btn_prev.Left := btn_stop.Left + btn_stop.Width + 3;
  btn_next.Left := btn_prev.Left + btn_prev.Width + 1;
  i := 0;

  newWidth := btn_next.Left + btn_next.Width + i + 2;
  Tag := NewWidth;
  Hint := inttostr(NewWidth);
  if newWidth <> Width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;

procedure BroadCastAppCommand(pType : integer);
var
  wnd : hwnd;
  result : boolean;
begin
  result := False;
  if (IsServiceStarted('MultimediaInput') = MR_STARTED) and
     (IsServiceStarted('Shell') = MR_STARTED) then
  begin
    wnd := SharpApi.GetShellTaskMgrWindow;
    if wnd <> 0 then
      SendMessage(wnd,WM_SHELLHOOK,HSHELL_APPCOMMAND,MakeLParam(0,pType));
  end else
  begin
    wnd := GetTopWindow(0);
    while (wnd <> 0) and (not result) do
    begin
      if ((GetWindowLong(Wnd, GWL_STYLE) and WS_SYSMENU <> 0) or
         (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_APPWINDOW <> 0)) and
         ((IsWindowVisible(Wnd) or IsIconic(wnd)) and
         (GetWindowLong(Wnd, GWL_STYLE) and WS_CHILD = 0) and
         (GetWindowLong(Wnd, GWL_EXSTYLE) and WS_EX_TOOLWINDOW = 0)) then
//       (GetWindowLong(wnd, GWL_EXSTYLE) and WS_EX_TOPMOST = 0) then
        begin
          result := (SendMessage(wnd,WM_APPCOMMAND,0,MakeLParam(0,pType)) <> 0);
        end;
      wnd := GetNextWindow(wnd,GW_HWNDNEXT);
    end;
  end;    
end;

//#############################
//            PLAY
//#############################
procedure TMainForm.btn_playClick(Sender: TObject);
begin
  BroadCastAppCommand(APPCOMMAND_MEDIA_PLAY_PAUSE);
end;

//#############################
//        NEXT TRACK
//#############################
procedure TMainForm.btn_nextClick(Sender: TObject);
begin
BroadCastAppCommand(APPCOMMAND_MEDIA_NEXTTRACK);
end;

//#############################
//            PAUSE
//#############################
procedure TMainForm.btn_pauseClick(Sender: TObject);
begin
  BroadCastAppCommand(APPCOMMAND_MEDIA_PLAY_PAUSE);
end;


//#############################
//            STOP
//#############################
procedure TMainForm.btn_stopClick(Sender: TObject);
begin
  BroadCastAppCommand(APPCOMMAND_MEDIA_STOP);
end;


//#############################
//       PREVIOUS TRACK
//#############################
procedure TMainForm.btn_prevClick(Sender: TObject);
begin
  BroadCastAppCommand(APPCOMMAND_MEDIA_PREVIOUSTRACK);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  WM_SHELLHOOK := RegisterWindowMessage('SHELLHOOK');
  DoubleBuffered := True;
  Background  := TBitmap32.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SharpApi.UnRegisterAction('!MC-Play');
  SharpApi.UnRegisterAction('!MC-Pause');
  SharpApi.UnRegisterAction('!MC-Stop');
  SharpApi.UnRegisterAction('!MC-Prev');
  SharpApi.UnRegisterAction('!MC-Next');

  Background.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

end.
