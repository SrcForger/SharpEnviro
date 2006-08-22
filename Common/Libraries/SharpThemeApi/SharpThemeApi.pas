{
Source Name: SharpThemeApi.pas
Description: Header unir for SharpThemeApi.dll
Copyright (C)  Martin Krämer <MartinKraemer@gmx.net>

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
  TSharpEColorSet = record
                      BaseColor  : integer;
                      LightColor : integer;
                      DarkColor  : integer;
                      FontColor  : integer;
                    end;

  TSharpESkinColor = record
                       Name  : String;
                       Tag   : String;
                       color : integer;
                     end;

// ThemeAPIControls
procedure InitializeTheme; external 'SharpThemeApi.dll' name 'InitializeTheme';
function LoadTheme(pName : PChar) : boolean; overload; external 'SharpThemeApi.dll' name 'LoadTheme';
function LoadTheme : boolean; overload; external 'SharpThemeApi.dll' name 'LoadCurrentTheme';

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
function ColorToSchemeCode(pCode : integer) : integer; external 'SharpThemeApi.dll' name 'ColorToSchemeCode';

// Theme Skin
function GetSkinName : PChar; external 'SharpThemeApi.dll' name 'GetSkinName';
function GetSkinColorCount : integer; external 'SharpThemeApi.dll' name 'GetSkinColorCount';
function GetSkinColor(pIndex : integer) : TSharpESkinColor; external 'SharpThemeApi.dll' name 'GetSkinColor';

implementation

end.
