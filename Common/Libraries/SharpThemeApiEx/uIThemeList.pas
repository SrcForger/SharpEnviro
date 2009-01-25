{
Source Name: uIThemeList.pas
Description: IThemeList Interface
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

unit uIThemeList;

interface

uses
  uThemeConsts;

type
  IThemeList = interface(IInterface)
    ['{24D59DAD-FD78-418C-AE4E-0528037C6050}']

    function GetThemes: TThemeListItemSet; stdcall;
    property Themes : TThemeListItemSet read GetThemes;

    procedure UpdateThemeList; stdcall;
    function GetThemeCount : integer; stdcall;
  end;

implementation

end.
