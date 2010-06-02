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
  VCLFixPack,
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
  DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',
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
  uSharpEMenuSaver in 'Units\uSharpEMenuSaver.pas',
  uSharpEMenuDynamicContentThread in 'Units\uSharpEMenuDynamicContentThread.pas',
  uSharpEMenuRenderThread in 'Units\uSharpEMenuRenderThread.pas',
  uSharpEMenuIconThreads in 'Units\uSharpEMenuIconThreads.pas';

{$R *.res}
{$R metadata.res}

type
  TSkinManagerLoadThread = class(TThread)
  private
  protected
    procedure Execute; override;
  public
  end;

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
  loadIconCacheThread : TLoadIconCacheThread;
  loadGenericIconsThread : TLoadGenericIconsThread;
  skinManagerLoadThread : TSkinManagerLoadThread;

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

{ TSkinManagerLoadThread }

procedure TSkinManagerLoadThread.Execute;
begin
  SkinManager := TSharpESkinManager.Create(nil,[scBar,scMenu,scMenuItem]);
end;

begin
  st := GetCurrentTime;  
  TimeList := TStringList.Create;
  TimeList.Clear;
  SharpEMenuPopups := nil;
  SharpEMenuIcons := nil;

  DebugTime('Init');
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
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

  // Init Theme
  GetCurrentTheme.LoadTheme([tpSkinScheme,tpIconSet,tpSkinFont]);

  // Start the thread that will Init and load the Skin Manager
  skinManagerLoadThread := TSkinManagerLoadThread.Create(True);
  skinManagerLoadThread.Resume();

  // Load Global Menu Options
  menusettings := TSharpEMenuSettings.Create;
  menusettings.LoadFromXML;

  // Parse possible params (which define the position and custom menus)
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

  // Parse the menu file param before setting iconcachefile
  // so that we load the appropriate icon cache file
  if (ParamCount = 1) or (ParamCount >=2) then
     mfile := ParamStr(ParamCount);
  if not FileExists(mfile) then
     mfile := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Menu.xml';
  if not FileExists(mfile) then halt;

  // Init Icon Variables and Classes
  iconcachefile := ExtractFileName(mfile);
  setlength(iconcachefile,length(iconcachefile) - length(ExtractFileExt(iconcachefile)));
  iconcachefile := iconcachefile + '.iconcache';

  SharpEMenuIcons := TSharpEMenuIcons.Create;
  // Start Thread which loads the generic icons
  loadGenericIconsThread := TLoadGenericIconsThread.Create(true, SharpEMenuIcons);
  if menusettings.UseGenericIcons then
    loadGenericIconsThread.Resume;

  // Start thread which loads the icon cache
  loadIconCacheThread := TloadIconCacheThread.Create(true, SharpEMenuIcons, iconcachefile);
  if (menusettings.CacheIcons) and (menusettings.UseIcons) then
    loadIconCacheThread.Resume;

  // Open the menu specific options, which may override
  // settings from the global menu options.
  menusettings.LoadFromXML(mfile);

  // Setup application Class
  Application.Title := 'SharpMenu';
  Application.CreateForm(TSharpEMenuWnd, wnd);
  // MuteX and Timeout settings of the main window
  wnd.MuteXHandle := MutexHandle;
  wnd.MenuID := mfile;
  wnd.HideTimeout := menusettings.HideTimeout;

  // Wait for icon loading threads to be finished
  if not loadIconCacheThread.Suspended then
    loadIconCacheThread.WaitFor;
  if not loadGenericIconsThread.Suspended then
    loadGenericIconsThread.WaitFor;
  loadIconCacheThread.Free;    
  loadGenericIconsThread.Free;

  // Wait for skin manager loading thread to be finished
  if not skinManagerLoadThread.Suspended then
    skinManagerLoadThread.WaitFor;
  skinManagerLoadThread.Free;
  SkinManagerInterface := SkinManager;

  // Load menu xml file, but don't load the icons (yet)
  SharpEMenuIcons.OnlyAdd := True;
  mn := uSharpEMenuLoader.LoadMenu(mfile,SkinManagerInterface,False);

  // All cached icons are now loaded, load all icons which aren't cached
  SharpEMenuIcons.OnlyAdd := False;
  SharpEMenuIcons.LoadNotLoadedIcons;

  // Initialize the menu
  wnd.InitMenu(mn,true);
  mn.InitializeDynamicSubMenus;

  // Setup Final screen Position
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

  // Show the Window
  wnd.Show;
  ForceForeGroundWindow(wnd.handle);

  Application.Run;

  for i := 0 to TimeList.Count - 1 do
    SharpApi.SendDebugMessage('SharpMenu',TimeList[i],0);
  TimeList.Free;

  // Save new menu cache
  if (menusettings.CacheIcons) and (menuSettings.UseIcons) then
     SharpEMenuIcons.SaveIconCache(iconcachefile);

  SharpEMenuIcons.Free;     

  SkinManagerInterface := nil;
end.
