{
Source Name: uIThemeDesktop.pas
Description: IThemeDesktop Interface
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

unit uIThemeDesktop;

interface

uses
  uThemeConsts;

type
  IThemeDesktop = interface(IInterface)
    ['{4C2502B5-C47D-4BB0-98A4-F862340CA28B}']
    procedure LoadFromFile; stdcall;
    procedure SaveToFile; stdcall;
    procedure SaveToFileAnimation; stdcall;
    procedure SaveToFileIcon; stdcall;    

    function GetIcon: TThemeDesktopIcon; stdcall;
    procedure SetIcon(Value :TThemeDesktopIcon); stdcall;
    property Icon : TThemeDesktopIcon read GetIcon write SetIcon;

    function GetAnimation: TThemeDesktopAnim; stdcall;
    procedure SetAnimation(Value : TThemeDesktopAnim); stdcall;
    property Animation : TThemeDesktopAnim read GetAnimation write SetAnimation;
  end;

implementation

end.
