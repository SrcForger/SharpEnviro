{
Source Name: uIThemeSkin.pas
Description: IThemeSkin Interface
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

unit uIThemeSkin;

interface

uses
  uThemeConsts;

type
  IThemeSkin = interface(IInterface)
    ['{4E2402BA-48B7-447C-9285-937CE0F0B9A4}']
    procedure LoadFromFile; stdcall;
    procedure SaveToFile; stdcall;
    procedure SaveToFileSkinAndGlass; stdcall;
    procedure SaveToFileFont; stdcall;    

    function GetName : String; stdcall;
    procedure SetName(Value : String); stdcall;
    property Name : String read GetName write SetName;

    function GetDirectory : String; stdcall;
    property Directory : String read GetDirectory;

    function GetSkinFont: TThemeSkinFont; stdcall;
    procedure SetSkinFont(Value : TThemeSkinFont); stdcall;
    property SkinFont : TThemeSkinFont read GetSkinFont write SetSkinFont;

    function GetGlassEffect: TThemeSkinGlassEffect; stdcall;
    procedure SetGlassEffect(Value: TThemeSkinGlassEffect); stdcall;
    property GlassEffect : TThemeSkinGlassEffect read GetGlassEffect write SetGlassEffect;
  end;
  
implementation

end.
