{
Source Name: SharpMenu.dpr
Description: SharpE Menu Component
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.net

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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


{ Important Note:
If vcl and rtl runtime packages are enabled the Application.OnDeactivate
event isn't working!
NEVER build the application with runtime packages...

BB
}

program SharpMenu;

uses
  Forms,
  Windows,
  Messages,
  Classes,
  Types,
  Math,
  Controls,
  SysUtils,
  SharpApi,
  SharpESkinManager,
  uSharpEMenuWnd in 'Forms\uSharpEMenuWnd.pas' {SharpEMenuWnd},
  uSharpEMenuLoader in 'Units\uSharpEMenuLoader.pas',
  uSharpEMenu in 'Units\uSharpEMenu.pas',
  uSharpEMenuActions in 'Units\uSharpEMenuActions.pas',
  uSharpEMenuIcon in 'Units\uSharpEMenuIcon.pas',
  uSharpEMenuIcons in 'Units\uSharpEMenuIcons.pas',
  uSharpEMenuItem in 'Units\uSharpEMenuItem.pas',
  uSharpEMenuConsts in 'Units\uSharpEMenuConsts.pas',
  uSkinManagerThreads in '..\..\Common\Units\Threads\uSkinManagerThreads.pas',
  uPropertyList in '..\..\Common\Units\PropertyList\uPropertyList.pas';

{$R *.res}

type
  TEventClass = class
  public
    procedure OnAppDeactivate(Sender : TObject);
  end;


var
  SkinManager : TSharpESkinManager;
  mn : TSharpEMenu;
  wnd : TSharpEMenuWnd;
  events : TEventClass;
  handle : THandle;
  ps : String;
  buff : array[0..255] of Char;
  s : string;
  iconcachefile : String;
  mfile : String;
  Pos : TPoint;
  i : integer;
  st : Int64;
  MutexHandle : THandle;
  SystemSkinLoadThread : TSystemSkinLoadThread;


procedure TEventClass.OnAppDeactivate(Sender : TObject);
begin
  if SharpEMenuIcons <> nil then SharpEMenuIcons.SaveIconCache(iconcachefile);
  Application.Terminate;
end;

function GetCurrentTime : Int64;
var
  h,m,s,ms : word;
begin
  DecodeTime(now(),h,m,s,ms);
  result := h*60*60*1000 + m*60*1000 + s*1000 + ms;
end;

procedure DebugTime(msg : String);
var
  i,i2 : Int64;
begin
  i := GetCurrentTime;
  i2 := i-st;
  SharpApi.SendDebugMessage('SharpMenu',inttostr(i2) + ' ('+msg + ')',0);
  st := i;
end;

begin
  Application.Initialize;
  events := TEventClass.Create;
  Application.OnDeactivate := events.OnAppDeactivate;

  st := GetCurrentTime;
  MutexHandle := CreateMutex(nil, TRUE, 'SharpMenuMutex');
  if MuteXHandle <>0 then
  begin
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(MuteXHandle);
      halt;
    end;
  end;

  Pos := Mouse.CursorPos;
  // Check Params
  if ParamCount >= 2 then
  begin
    if TryStrToInt(ParamStr(1),i) then
       Pos.X := i;
    if TryStrToInt(ParamStr(2),i) then
       Pos.Y := i;
  end;

  if (ParamCount = 1) or (ParamCount >=2) then
     mfile := ParamStr(ParamCount);
  if not FileExists(mfile) then
     mfile := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Menu.xml';
  if not FileExists(mfile) then halt;

  iconcachefile := ExtractFileName(mfile);
  setlength(iconcachefile,length(iconcachefile) - length(ExtractFileExt(iconcachefile)));
  iconcachefile := iconcachefile + '.iconcache';
  SharpEMenuIcons := TSharpEMenuIcons.Create;
  SharpEMenuIcons.LoadIconCache(iconcachefile);

  // init Classes

  SkinManager := TSharpESkinManager.Create(nil);
  SystemSkinLoadThread := TSystemSkinLoadThread.Create(SkinManager);
  mn := uSharpEMenuLoader.LoadMenu(mfile,SkinManager);
  Application.Title := 'SharpMenu';
  Application.CreateForm(TSharpEMenuWnd, wnd);
  SystemSkinLoadThread.WaitFor;
  SystemSkinLoadThread.Free;

  wnd.InitMenu(mn,true);
  i := Pos.X;
  if (i + wnd.Width > (wnd.Monitor.Left + wnd.Monitor.Width)) then
     i := (wnd.Monitor.Left + wnd.Monitor.Width) - wnd.Width;
  wnd.Left := i;

  // Check position
  i := Pos.Y;
  if (i + wnd.Picture.Height) > (wnd.Monitor.Top + wnd.Monitor.Height) then
      i := wnd.Monitor.Top + wnd.Monitor.Height - wnd.Picture.Height;
  if i < 0 then
  begin
    wnd.Height := wnd.Monitor.Height;
    i := 0;
  end;
  wnd.top := i;

  wnd.Show;

  // Check if another application got the focus while the menu was initialized
  handle := GetForegroundWindow;
  if handle <> 0 then
  begin
    GetClassName(handle,buff,sizeof(buff));
    s := buff;
    if CompareText(s,wnd.ClassName) <> 0 then
    begin
      Application.Terminate;
    end;
  end;
  Application.Run;

  // Free Classes
  SkinManager.Free;
  events.Free;
  
  CloseHandle(MuteXHandle);
end.
