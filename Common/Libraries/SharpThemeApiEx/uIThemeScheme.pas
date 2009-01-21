{
Source Name: uIThemeScheme.pas
Description: IThemeScheme Interface
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

unit uIThemeScheme;

interface

uses
  uThemeConsts;

type
  IThemeScheme = interface(IInterface)
    ['{385321E7-534F-4CB9-8D66-F76F37C4421D}']
    procedure LoadFromFile; stdcall;
    procedure LoadCustomScheme; stdcall;    
    procedure SaveToFile; stdcall;

    function GetName : String; stdcall;
    procedure SetName(Value : String); stdcall;
    property Name : String read GetName write SetName;

    function GetDirectory : String; stdcall;
    property Directory : String read GetDirectory;

    function GetColors : TSharpEColorSet; stdcall;
    property Colors : TSharpEColorSet read GetColors;

    function ParseColor(pSrc : String) : integer; stdcall;
    function SchemeCodeToColor(pCode: integer): integer; stdcall;
    function GetColorByTag(pTag: String): TSharpESkinColor; stdcall;
    function GetColorIndexByTag(pTag: String): Integer; stdcall;
    function GetColorByIndex(pIndex: integer): TSharpESkinColor; stdcall;
    function GetColorCount: Integer; stdcall;
  end;

implementation

end.
