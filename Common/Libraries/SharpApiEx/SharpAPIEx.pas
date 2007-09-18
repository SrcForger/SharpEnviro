{
Source Name: SharpAPI
Description: Header unir for SharpAPI.dll
Copyright (C) Lee Green (Pixol) <pixol@sharpe-shell.org>
              Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpAPIEx;

interface

function GetDelimitedActionList: WideString; external 'SharpAPIEx.dll' name 'GetDelimitedActionList';
function GetRecentItems(ReturnCount: integer): widestring; external 'SharpAPIEx.dll' name 'GetRecentItems';
function GetMostUsedItems(ReturnCount: integer): widestring; external 'SharpAPIEx.dll' name 'GetMostUsedItems';

implementation

end.




