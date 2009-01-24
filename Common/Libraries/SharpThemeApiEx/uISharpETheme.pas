{
Source Name: uISharpETheme.pas
Description: ISharpETheme Interface
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

unit uISharpETheme;

interface

uses
  uThemeConsts,
  uIThemeInfo,
  uIThemeSkin,
  uIThemeScheme,
  uIThemeDesktop,
  uIThemeIcons,
  uIThemeWallpaper;

type
  ISharpETheme = interface(IInterface)
    ['{E9D92334-43FA-4B06-8107-9842BE275554}']
    function GetThemeInfo : IThemeInfo; stdcall;
    property Info : IThemeInfo read GetThemeInfo;

    function GetThemeSkin : IThemeSkin; stdcall;
    property Skin : IThemeSkin read GetThemeSkin;

    function GetThemeScheme : IThemeScheme; stdcall;
    property Scheme : IThemeScheme read GetThemeScheme;

    function GetThemeDesktop : IThemeDesktop; stdcall;
    property Desktop : IThemeDesktop read GetThemeDesktop;

    function GetThemeIcons : IThemeIcons; stdcall;
    property Icons : IThemeIcons read GetThemeIcons;

    function GetThemeWallpaper : IThemeWallpaper; stdcall;
    property Wallpaper : IThemeWallpaper read GetThemeWallpaper;

    procedure LoadTheme(pParts: TThemeParts = ALL_THEME_PARTS); stdcall;
    procedure SetCurrentTheme(Name : String); stdcall;    
  end;

implementation

end.
