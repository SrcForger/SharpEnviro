{
Source Name: SharpThemeApi.pas
Description: Header unir for SharpThemeApi.dll
Copyright (C)  Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.Sharpe-Shell.org

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

unit SharpThemeApi;

interface

uses
  Windows,
  Classes;

type
  TThemePart = (tpSkin,tpScheme,tpInfo,tpIconSet,tpDesktopIcon);
  TThemeParts = set of TThemePart;

  TSharpESkinColor = record
    Name: string;
    Tag: string;
    Info: string;
    Color: integer;
  end;

  TSharpEColorSet = array of TSharpESkinColor;

  TSharpEIcon = record
    FileName: string;
    Tag: string;
  end;

const
  ALL_THEME_PARTS = [tpSkin,tpScheme,tpInfo,tpIconSet,tpDesktopIcon];


// ThemeAPIControls
procedure InitializeTheme; external 'SharpThemeApi.dll' name 'InitializeTheme';
function Initialized: boolean; external 'SharpThemeApi.dll' name 'Initialized';
function LoadTheme(pName: PChar; ForceReload: Boolean = False; ThemeParts : TThemeParts = ALL_THEME_PARTS) : boolean; overload external 'SharpThemeApi.dll' name 'LoadTheme';
function LoadTheme(ForceReload: Boolean = False; ThemeParts : TThemeParts = ALL_THEME_PARTS) : boolean; overload; external 'SharpThemeApi.dll' name 'LoadCurrentTheme';

// Global data
function GetCurrentSharpEThemeName : PChar; external 'SharpThemeApi.dll' name 'GetCurrentSharpEThemeName';

// Theme Info
function GetThemeName: PChar; external 'SharpThemeApi.dll' name 'GetThemeName';
function GetThemeAuthor: PChar; external 'SharpThemeApi.dll' name 'GetThemeAuthor';
function GetThemeComment: PChar; external 'SharpThemeApi.dll' name 'GetThemeComment';
function GetThemeWebsite: PChar; external 'SharpThemeApi.dll' name 'GetThemeWebsite';

// Theme Data
function GetThemeDirectory: PChar; overload; external 'SharpThemeApi.dll' name 'GetCurrentThemeDirectory';
function GetThemeDirectory(pName : PChar): PChar; overload external 'SharpThemeApi.dll' name 'GetThemeDirectory';

// Theme Scheme
function GetSchemeColorSet(pSet : integer) : TSharpEColorSet; external 'SharpThemeApi.dll' name 'GetSchemeColorSet';
function GetSchemeName : PChar; external 'SharpThemeApi.dll' name 'GetSchemeName';
function SchemeCodeToColor(pCode : integer) : integer; external 'SharpThemeApi.dll' name 'SchemeCodeToColor';
function ColorToSchemeCode(pColor : integer) : integer; external 'SharpThemeApi.dll' name 'ColorToSchemeCode';
function GetSchemeColorCount: Integer; external 'SharpThemeApi.dll' name 'GetSchemeColorCount';
function GetSchemeColorByIndex(pIndex: integer): TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSchemeColorByIndex';
function GetSchemeColorIndexByTag(pTag: string): Integer; external 'SharpThemeApi.dll' name 'GetSchemeColorIndexByTag';
function GetSchemeColorByTag(pTag: string): TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSchemeColorByTag';
function ParseColor(AColorStr:PChar):Integer; external 'SharpThemeApi.dll' name 'ParseColor';
function GetSchemeDirectory : PChar; external 'SharpThemeApi.dll' name 'GetSchemeDirectory';

// Theme Skin
function GetSkinName : PChar; external 'SharpThemeApi.dll' name 'GetSkinName';
function GetSkinColorCount : integer; external 'SharpThemeApi.dll' name 'GetSkinColorCount';
function GetSkinColor(pIndex : integer) : TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSkinColor';
function GetSkinDirectory : PChar; external 'SharpThemeApi.dll' name 'GetSkinDirectory';

// Theme IconSet
function GetIconSetName : PChar; external 'SharpThemeApi.dll' name 'GetIconSetName';
function GetIconSetAuthor : PChar; external 'SharpThemeApi.dll' name 'GetIconSetAuthor';
function GetIconSetWebsite : PChar; external 'SharpThemeApi.dll' name 'GetIconSetWebsite';
function GetIconSetDirectory : PChar; external 'SharpThemeApi.dll' name 'GetIconSetDirectory';
function GetIconSetIconsCount : integer; external 'SharpThemeApi.dll' name 'GetIconSetIconsCount';
function GetIconSetIcon(pIndex : integer) : TSharpEIcon; overload; external 'SharpThemeApi.dll' name 'GetIconSetIconByIndex';
function GetIconSetIcon(pTag : PChar) : TSharpEIcon; overload; external 'SharpThemeApi.dll' name'GetIconSetIconByTag';
function IsIconInIconSet(pTag : PChar) : boolean; external 'SharpThemeApi.dll' name 'IsIconInIconSet';

// Theme DesktopIcon
function GetDesktopIconSize        : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconSize';
function GetDesktopIconAlpha       : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconAlpha';
function GetDesktopIconBlending    : boolean; external 'SharpThemeApi.dll' name 'GetDesktopIconBlending';
function GetDesktopIconBlendColor  : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconBlendColor';
function GetDesktopIconBlendAlpha  : integer; external 'SharpThemeApi.dll' name 'GetDesktopIconBlendAlpha';
function GetDesktopFontName        : String;  external 'SharpThemeApi.dll' name 'GetDesktopFontName';
function GetDesktopTextSize        : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextSize';
function GetDesktopTextBold        : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextBold';
function GetDesktopTextItalic      : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextItalic';
function GetDesktopTextUnderline   : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextUnderline';
function GetDesktopTextColor       : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextColor';
function GetDesktopTextAlpha       : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextAlpha';
function GetDesktopTextShadow      : boolean; external 'SharpThemeApi.dll' name 'GetDesktopTextShadow';
function GetDesktopTextShadowAlpha : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowAlpha';
function GetDesktopTextShadowColor : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowColor';
function GetDesktopTextShadowType  : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowType';
function GetDesktopTextShadowSize  : integer; external 'SharpThemeApi.dll' name 'GetDesktopTextShadowSize';


implementation

end.
