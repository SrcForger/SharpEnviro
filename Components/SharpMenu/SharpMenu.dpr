{
Source Name: SharpMenu.dpr
Description: SharpE Menu Component
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
  SharpThemeApiEx,
  uThemeConsts,
  SharpESkinManager,
  SharpTypes,
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
  SharpIconUtils in '..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  uSharpEMenuSaver in 'Units\uSharpEMenuSaver.pas';

{$R *.res}
{$R metadata.res}

var
  SkinManager : TSharpESkinManager;
  mn : TSharpEMenu;
  wnd : TSharpEMenuWnd;
  iconcachefile : String;
  mfile : String;
  Pos : TPoint;
  i : integer;
  popupdir : integer;
  st : Int64;
  MutexHandle : THandle;
  SystemSkinLoadThread : TSystemSkinLoadThread;
  menusettings : TSharpEMenuSettings;
  Mon : TMonitor;

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
  Application.ShowMainForm := False;
  {$IFDEF VER185} Application.MainFormOnTaskBar := True; {$ENDIF}
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
                 GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);  

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

  GetCurrentTheme.LoadTheme([tpSkinScheme,tpIconSet,tpSkinFont]);

  iconcachefile := ExtractFileName(mfile);
  setlength(iconcachefile,length(iconcachefile) - length(ExtractFileExt(iconcachefile)));
  iconcachefile := iconcachefile + '.iconcache';
  SharpEMenuIcons := TSharpEMenuIcons.Create;

  if (menusettings.CacheIcons) and (menusettings.UseIcons) then
     SharpEMenuIcons.LoadIconCache(iconcachefile);

  // init Classes

  SkinManager := TSharpESkinManager.Create(nil,[scBar,scMenu,scMenuItem]);
  SystemSkinLoadThread := TSystemSkinLoadThread.Create(SkinManager);
  mn := uSharpEMenuLoader.LoadMenu(mfile,SkinManager,False);
  Application.Title := 'SharpMenu';
  Application.CreateForm(TSharpEMenuwnd, wnd);
  SystemSkinLoadThread.WaitFor;
  SystemSkinLoadThread.Free;

  wnd.InitMenu(mn,true);
  Mon := Screen.MonitorFromPoint(Pos);
  if Mon = nil then
    Mon := wnd.Monitor;

  // Check position
  i := Pos.X + SkinManager.Skin.MenuSkin.SkinDim.XAsInt;
  if (i + wnd.Width > (Mon.Left + Mon.Width)) then
     i := (Mon.Left + Mon.Width) - wnd.Width;
  wnd.Left := i;

  i := Pos.Y + SkinManager.Skin.MenuSkin.SkinDim.YAsInt;
  if popupdir < 0 then
     i := i - wnd.Picture.Height;
  if (i + wnd.Picture.Height) > (Mon.Top + Mon.Height) then
      i := Mon.Top + Mon.Height - wnd.Picture.Height;
  if i < Mon.Top then
  begin
    wnd.Height := Mon.Height;
    i := Mon.Top;
  end;
  wnd.top := i;

  wnd.Show;

  // Register Shell Hook
  SharpApi.RegisterShellHookReceiver(wnd.Handle);

  Application.Run;

  if (menusettings.CacheIcons) and (menuSettings.UseIcons) then
     SharpEMenuIcons.SaveIconCache(iconcachefile);  

  // Free Classes
  if SharpEMenuPopups <> nil then
     SharpEMenuPopups.Free;
  SharpEMenuIcons.Free;     

  SkinManager.Free;

  CloseHandle(MuteXHandle);
end.
