{
Source Name: SharpDialogs.pas
Description: Header Units for SharpDialogs.dll
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

unit SharpDialogs;

interface

uses Types;

type
  TTargetDialogSelectItem = (stiFile,stiRecentFiles,stiMostUsedFiles,stiDrive,
                             stiDirectory,stiShellFolders,stiScript,stiAction);
  TTargetDialogSelectItems = Set of TTargetDialogSelectItem;

  TIconMenuSelectItem = (smiShellIcon,smiCustomIcon,smiSharpEIcon);
  TIconMenuSelectItems = Set of TIconMenuSelectItem;


const
  SMI_ALL_ICONS = [smiShellIcon,smiCustomIcon,smiSharpEIcon];
  STI_ALL_TARGETS = [stiFile,stiRecentFiles,stiMostUsedFiles,stiDrive,
                     stiDirectory,stiShellFolders,stiScript,stiAction];

function TargetDialogSkin(TargetItems : TTargetDialogSelectItems; PopupPoint : TPoint) : PChar; external 'SharpDialogs.dll';                     
function TargetDialog(TargetItems : TTargetDialogSelectItems; PopupPoint : TPoint) : PChar; external 'SharpDialogs.dll';
function IconDialog(pTarget : String; IconItems : TIconMenuSelectItems; PopupPoint : TPoint) : PChar; external 'SharpDialogs.dll';

implementation

end.
