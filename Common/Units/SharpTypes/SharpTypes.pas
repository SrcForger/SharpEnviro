{
Source Name: SharpTypes.pas
Description: Type and Const declarations for the whole Shell
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

unit SharpTypes;

interface

uses
  Windows;

// Global
type
  THandleArray = array of hwnd;

// Taskbar
type
  TSharpETaskItemStates = (tisFull,tisCompact,tisMini);
  TSharpeTaskManagerSortType = (stCaption,stWndClass,stTime,stIcon);  

// Skin System
type
  TSharpESkinItem = (scBasic,scButton,scBar,scProgressBar,scMiniThrobber,scEdit,
                     scTaskItem,scMenu,scMenuItem,scTaskSwitch,scNotify);
  TSharpESkinItems = set of TSharpESkinItem;
const
 ALL_SHARPE_SKINS = [scBasic,scButton,scBar,scProgressBar,scMiniThrobber,scEdit,
                     scTaskItem,scMenu,scMenuItem,scTaskSwitch,scNotify];

// SharpBar
type
  TSharpEBarAutoPos = (apTop,apCenter,apBottom,apNone);

implementation

end.
