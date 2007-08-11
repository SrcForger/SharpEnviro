{
Source Name: SharpDialogs.pas
Description: Header Units for SharpDialogs.dll
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
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
