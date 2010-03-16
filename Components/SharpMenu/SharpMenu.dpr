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
  ISharpESkinComponents,
  uSystemFuncs,
  SharpTypes,
  uSharpEMenuWnd in 'Forms\uSharpEMenuWnd.pas' {SharpEMenuWnd},
  uSharpEMenuLoader in 'Units\uSharpEMenuLoader.pas',
  uSharpEMenu in 'Units\uSharpEMenu.pas',
  uSharpEMenuActions in 'Units\uSharpEMenuActions.pas',
  uSharpEMenuIcon in 'Units\uSharpEMenuIcon.pas',
  uSharpEMenuIcons in 'Units\uSharpEMenuIcons.pas',
  uSharpEMenuItem in 'Units\uSharpEMenuItem.pas',
  uSharpEMenuConsts in 'Units\uSharpEMenuConsts.pas',
  uPropertyList in '..\..\Common\Units\PropertyList\uPropertyList.pas',
  uSharpEMenuPopups in 'Units\uSharpEMenuPopups.pas',
  uSharpEMenuSettings in 'Units\uSharpEMenuSettings.pas',
  uControlPanelItems in '..\..\Common\Units\ControlPanelItems\uControlPanelItems.pas',
  SharpIconUtils in '..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  uSharpEMenuSaver in 'Units\uSharpEMenuSaver.pas';

type
  TLoadCacheThread = class(TThread)
  private
    pMenuIcons : ^TSharpEMenuIcons;
    pIconCacheFile : string;
  protected
    procedure Execute; override;
  public
    constructor Create(createSuspended: boolean; var menuIcons : TSharpEMenuIcons; iconcachefile : string);
  end;

{$R *.res}
{$R metadata.res}

var
  SkinManager : TSharpESkinManager;
  SkinManagerInterface : ISharpESkinManager;
  mn : TSharpEMenu;
  wnd : TSharpEMenuWnd;
  iconcachefile : String;
  mfile : String;
  Pos : TPoint;
  i : integer;
  popupdir : integer;
  st : Int64;
  MutexHandle : THandle;
  menusettings : TSharpEMenuSettings;
  Mon : TMonitor;
  TimeList : TStringList;
  loadCacheThread : TLoadCacheThread;

constructor TLoadCacheThread.Create(createSuspended: boolean; var menuIcons : TSharpEMenuIcons; IconCacheFile : string);
begin
  inherited Create(createSuspended);

  pMenuIcons := @menuIcons;
  pIconCacheFile := IconCacheFile;
end;

procedure TLoadCacheThread.Execute;
begin
  pMenuIcons.LoadIconCache(pIconCacheFile);
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
  TimeList.Add(inttostr(i2) + ' ('+msg + ')');
//  SharpApi.SendDebugMessage('SharpMenu',inttostr(i2) + ' ('+msg + ')',0);
  st := i;
end;

begin
  st := GetCurrentTime;  
  TimeList := TStringList.Create;
  TimeList.Clear;
  SharpEMenuPopups := nil;
  SharpEMenuIcons := nil;

  DebugTime('Init');
  Application.Initialize;
  Application.ShowMainForm := False;
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
                 GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);

  st := GetCurrentTime;
  MutexHandle := CreateMutex(nil, TRUE, 'SharpMenuMutex');
  if MuteXHandle <> 0 then
  begin
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(MuteXHandle);
      halt;
    end;
  end;

  DebugTime('global menu options');
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

  DebugTime('menu specific options');
  // Open the menu specific options, which may override
  // settings from the global menu options.
  menusettings.LoadFromXML(mfile);

  DebugTime('CreateForm');
  Application.Title := 'SharpMenu';
  Application.CreateForm(TSharpEMenuWnd, wnd);
  DebugTime('LoadTheme');
  GetCurrentTheme.LoadTheme([tpSkinScheme,tpIconSet,tpSkinFont]);

  wnd.MuteXHandle := MutexHandle;
  wnd.MenuID := mfile;
  wnd.HideTimeout := menusettings.HideTimeout;

  DebugTime('IconStuff');
  iconcachefile := ExtractFileName(mfile);
  setlength(iconcachefile,length(iconcachefile) - length(ExtractFileExt(iconcachefile)));
  iconcachefile := iconcachefile + '.iconcache';
  SharpEMenuIcons := TSharpEMenuIcons.Create;
  if menusettings.UseGenericIcons then
    SharpEMenuIcons.LoadGenericIcons;

  loadCacheThread := TLoadCacheThread.Create(true, SharpEMenuIcons, iconcachefile);
  if (menusettings.CacheIcons) and (menusettings.UseIcons) then
  begin
    loadCacheThread.Resume;
    // SharpEMenuIcons.LoadIconCache(iconcachefile);
  end;

  // init Classes

  DebugTime('SkinManager and Menu XML');
  SkinManager := TSharpESkinManager.Create(nil,[scBar,scMenu,scMenuItem]);
  SkinManagerInterface := SkinManager;
  mn := uSharpEMenuLoader.LoadMenu(mfile,SkinManagerInterface,False);

  DebugTime('InitMenu');
  wnd.InitMenu(mn,true);
  DebugTime('ScreenPos');
  Mon := Screen.MonitorFromPoint(Pos);
  if Mon = nil then
    Mon := wnd.Monitor;

  // Check position
  i := Pos.X + SkinManagerInterface.Skin.Menu.LocationOffset.X;
  if (i + wnd.Width > (Mon.Left + Mon.Width)) then
     i := (Mon.Left + Mon.Width) - wnd.Width;
  wnd.Left := i;

  i := Pos.Y + SkinManagerInterface.Skin.Menu.LocationOffset.Y;
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
  
  // Register Shell Hook
  SharpApi.RegisterShellHookReceiver(wnd.Handle);

  DebugTime('wnd show');
  wnd.Show;
  DebugTime('ForceForegroundWindow');
  ForceForeGroundWindow(wnd.handle);

  if not loadCacheThread.Suspended then
    loadCacheThread.WaitFor;
  loadCacheThread.Free;

  Application.Run;

  for i := 0 to TimeList.Count - 1 do
    SharpApi.SendDebugMessage('SharpMenu',TimeList[i],0);
  TimeList.Free;

  if (menusettings.CacheIcons) and (menuSettings.UseIcons) then
     SharpEMenuIcons.SaveIconCache(iconcachefile);

  // Free Classes
  //if SharpEMenuPopups <> nil then
  //   SharpEMenuPopups.Free;
  SharpEMenuIcons.Free;     

  SkinManagerInterface := nil;
end.
