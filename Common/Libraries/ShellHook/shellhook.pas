{
Source Name: shellhook.pas
Description: header unit for shellhook.dll
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

unit shellhook;

interface

uses
  Windows,
  Messages,
  SysUtils;

type
    TCallBackProcedure = procedure(handle: hwnd);

    procedure SHSetHook; external 'shellhook.dll'
    procedure SHUnSetHook; external 'shellhook.dll'
    procedure SHSetMainHandle(Handle: HWND); external 'shellhook.dll'
    procedure SHSetCallBack(callproc: TProcedure); external 'shellhook.dll'
    procedure SHResetMsgFlag; external 'shellhook.dll'

const
    WM_SHELLHOOK     = WM_APP + 750;

    M_NEWTASK        = 0;
    M_DELTASK         = 1;
    M_ACTIVATETASK    = 3;
    M_CAPTIONUPDATE   = 4;
    M_TASKFLASHING    = 5;
    M_GETMINRECT      = 6;

implementation

end.
