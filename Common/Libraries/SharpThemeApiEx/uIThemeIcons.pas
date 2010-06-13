{
Source Name: uIThemeIcons.pas
Description: IThemeIcons Interface
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

unit uIThemeIcons;

interface

uses
  uThemeConsts;

type
  IThemeIcons = interface(IInterface)
    ['{9D23626F-B592-46B7-91A7-9143D7BB324B}']
    procedure LoadIcons; stdcall;    
    procedure LoadFromFile; stdcall;
    procedure SaveToFile; stdcall;

    function GetName : String; stdcall;
    procedure SetName(Value : String); stdcall;
    property Name : String read GetName write SetName;

    function GetDirectory : String; stdcall;
    property Directory : String read GetDirectory;

    function GetInfo: TThemeIconSetInfo; stdcall;
    property Info : TThemeIconSetInfo read GetInfo;

    function GetIcons : TSharpEIcons; stdcall;
    property Icons : TSharpEIcons read GetIcons;

    procedure SetInfo(pAuthor, pWebsite, pComment : String);

    procedure GetIconsFromDir(var pIcons : TSharpEIcons; pDirectory : String); stdcall;

    function GetIconCount: integer; stdcall;
        
    function GetIconByTag(pTag: String): TSharpEIcon; stdcall;
    function GetIconFileSizedByTag(pTag: String; pTargetSize : integer): String; stdcall;
    function GetIconFileSizesByIndex(pIndex: integer; pTargetSize : integer): String; stdcall;        
    function GetIconIndexByTag(pTag : String) : integer; stdcall;
    function IsIconInIconSet(pTag: String): boolean; stdcall;
  end;

implementation

end.
