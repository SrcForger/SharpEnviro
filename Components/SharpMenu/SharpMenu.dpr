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
  SharpThemeApi,
  SharpESkinManager,
  SharpESkin,
  uSharpEMenuWnd in 'Forms\uSharpEMenuWnd.pas' {SharpEMenuWnd},
  uSharpEMenuLoader in 'Units\uSharpEMenuLoader.pas',
  uSharpEMenu in 'Units\uSharpEMenu.pas',
  uSharpEMenuActions in 'Units\uSharpEMenuActions.pas',
  uSharpEMenuIcon in 'Units\uSharpEMenuIcon.pas',
  uSharpEMenuIcons in 'Units\uSharpEMenuIcons.pas',
  uSharpEMenuItem in 'Units\uSharpEMenuItem.pas',
  uSharpEMenuConsts in 'Units\uSharpEMenuConsts.pas',
  uSkinManagerThreads in '..\..\Common\Units\Threads\uSkinManagerThreads.pas',
  uPropertyList in '..\..\Common\Units\PropertyList\uPropertyList.pas',
  uSharpEMenuPopups in 'Units\uSharpEMenuPopups.pas',
  uSharpEMenuSettings in 'Units\uSharpEMenuSettings.pas',
  uControlPanelItems in '..\..\Common\Units\ControlPanelItems\uControlPanelItems.pas',
  SharpIconUtils in '..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas';

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
  iconcachefile : String;
  mfile : String;
  Pos : TPoint;
  i : integer;
  popupdir : integer;
  st : Int64;
  MutexHandle : THandle;
  SystemSkinLoadThread : TSystemSkinLoadThread;
  menusettings : TSharpEMenuSettings;

function RegisterShellHook(wnd : hwnd; param : dword) : boolean; stdcall; external 'shell32.dll' index 181;

procedure TEventClass.OnAppDeactivate(Sender : TObject);
begin
  if (SharpEMenuIcons <> nil) and (menusettings.CacheIcons) then
     SharpEMenuIcons.SaveIconCache(iconcachefile);
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
  Application.ShowMainForm := False;
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

  menusettings := TSharpEMenuSettings.Create;
  menusettings.LoadFromXML;

  Pos := Mouse.CursorPos;
  popupdir := 1;
  // Check Params
  if ParamCount >= 2 then
  begin
    if TryStrToInt(ParamStr(1),i) then
       Pos.X := i;
    if TryStrToInt(ParamStr(2),i) then
       Pos.Y := i;
    if TryStrToInt(ParamStr(3),i) then
       popupdir := i;
  end;

  if (ParamCount = 1) or (ParamCount >=2) then
     mfile := ParamStr(ParamCount);
  if not FileExists(mfile) then
     mfile := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Menu.xml';
  if not FileExists(mfile) then halt;

  SharpThemeApi.InitializeTheme;
  SharpThemeApi.LoadTheme(False,[tpScheme,tpSkin,tpIconSet]);

  iconcachefile := ExtractFileName(mfile);
  setlength(iconcachefile,length(iconcachefile) - length(ExtractFileExt(iconcachefile)));
  iconcachefile := iconcachefile + '.iconcache';
  SharpEMenuIcons := TSharpEMenuIcons.Create;

  if menusettings.CacheIcons then
     SharpEMenuIcons.LoadIconCache(iconcachefile);

  // init Classes

  SkinManager := TSharpESkinManager.Create(nil,[scBar,scMenu,scMenuItem]);
  SystemSkinLoadThread := TSystemSkinLoadThread.Create(SkinManager);
  mn := uSharpEMenuLoader.LoadMenu(mfile,SkinManager);
  Application.Title := 'SharpMenu';
  Application.CreateForm(TSharpEMenuwnd, wnd);

  SystemSkinLoadThread.WaitFor;
  SystemSkinLoadThread.Free;

  wnd.InitMenu(mn,true);
  i := Pos.X + SkinManager.Skin.MenuSkin.SkinDim.XAsInt;
  if (i + wnd.Width > (wnd.Monitor.Left + wnd.Monitor.Width)) then
     i := (wnd.Monitor.Left + wnd.Monitor.Width) - wnd.Width;
  wnd.Left := i;

  // Check position
  i := Pos.Y + SkinManager.Skin.MenuSkin.SkinDim.YAsInt;
  if popupdir < 0 then
     i := i - wnd.Picture.Height;
  if (i + wnd.Picture.Height) > (wnd.Monitor.Top + wnd.Monitor.Height) then
      i := wnd.Monitor.Top + wnd.Monitor.Height - wnd.Picture.Height;
  if i < 0 then
  begin
    wnd.Height := wnd.Monitor.Height;
    i := 0;
  end;
  wnd.top := i;

  wnd.Show;

  // Register Shell Hook
  RegisterShellHook(0,1);
  RegisterShellHook(wnd.Handle,3);

  Application.Run;

  // Free Classes
  if SharpEMenuPopups <> nil then
     SharpEMenuPopups.Free;
  SkinManager.Free;
  events.Free;
  
  CloseHandle(MuteXHandle);
end.
