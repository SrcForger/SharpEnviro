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
  uSharpEMenuConsts in 'Units\uSharpEMenuConsts.pas';

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
  ps : String;
  mfile : String;
  Pos : TPoint;
  i : integer;


procedure TEventClass.OnAppDeactivate(Sender : TObject);
begin
  Application.Terminate;
end;

begin
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
     mfile := ParamStr(3);
  if not FileExists(mfile) then
     mfile := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Menu.xml';
  if not FileExists(mfile) then halt;

  Application.Initialize;

  // init Classes
  events := TEventClass.Create;
  SkinManager := TSharpESkinManager.Create(nil);
  SkinManager.SkinSource := ssSystem;
  SkinManager.SchemeSource := ssSystem;
  mn := uSharpEMenuLoader.LoadMenu(mfile,SkinManager);
  Application.CreateForm(TSharpEMenuWnd, wnd);
  Application.OnDeactivate := events.OnAppDeactivate;

  wnd.InitMenu(mn,true);
  wnd.Left := Pos.X;

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
  Application.Run;

  // Free Classes
  SkinManager.Free;
  events.Free;
end.
