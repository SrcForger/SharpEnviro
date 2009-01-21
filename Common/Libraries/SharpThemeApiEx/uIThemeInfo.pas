{
Source Name: uIThemeInfo.pas
Description: IThemeInfo Interface
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

unit uIThemeInfo;

interface

uses
  uThemeConsts;

type
  IThemeInfo = interface(IInterface)
    ['{CC91F335-01D2-4A52-A808-81C6E3B436B6}']
    procedure LoadFromFile; stdcall;
    procedure SaveToFile; stdcall;

    function GetName : String; stdcall;
    procedure SetName(Value : String); stdcall;
    property Name : String read GetName write SetName;

    function GetDirectory : String; stdcall;
    property Directory : String read GetDirectory;

    function GetInfo: TThemeInfoAdditional; stdcall;
    property Info : TThemeInfoAdditional read GetInfo;

    procedure SetInfo(pAuthor, pWebsite, pComment : String);
  end;

implementation

end.
