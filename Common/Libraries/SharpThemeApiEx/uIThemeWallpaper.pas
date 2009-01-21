{
Source Name: uIThemeWallpaper.pas
Description: IThemeWallpaper Interface
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

unit uIThemeWallpaper;

interface

uses
  uThemeConsts;

type
  IThemeWallpaper = interface(IInterface)
    ['{096FE81F-93D7-4925-8C67-464DBC354EB6}']
    function GetWallpapers : TThemeWallpaperItems; stdcall;
    property Wallpapers : TThemeWallpaperItems read GetWallpapers;

    function GetMonitors : TMonitorWallpapers; stdcall;
    property Monitors : TMonitorWallpapers read GetMonitors;

    function GetMonitorWallpaper(MonitorID: integer): TThemeWallpaperItem; stdcall;
    procedure UpdateMonitor(pMonitor : TWallpaperMonitor); stdcall;
    procedure UpdateWallpaper(pWallpaper : TThemeWallpaperItem); stdcall;

    procedure SaveToFile; stdcall;
    procedure LoadFromFile; stdcall;
  end;

implementation

end.
