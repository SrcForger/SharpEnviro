{
Source Name: uSharpBarAPI.pas
Description: SharpBar Tools API unit
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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

unit uSharpBarAPI;

interface

uses Forms, windows, GR32, sysutils, SharpAPI, classes;

type
  TModuleSize = record
                  Min      : integer;
                  Width    : integer;
                  Priority : integer;
                end;
  PModuleSize = ^TModuleSize;


function GetModuleXMLFile(BarID, ModuleID : integer) : String;

function GetFreeBarSpace(BarWnd : hWnd) : integer;
function GetBarPluginHeight(BarWnd : Hwnd) : Integer;
procedure PaintBarBackGround(BarWnd : Hwnd; bmp : TBitmap32; const pos : TForm; Width : integer); overload;
procedure PaintBarBackGround(BarWnd : Hwnd; bmp : TBitmap32; const pos : TRect); overload;
procedure PaintBarBackGround(BarWnd : Hwnd; bmp : TBitmap32; const pos : TForm); overload;

implementation

uses
  JclSimpleXML;

function GetFreeBarSpace(BarWnd : hWnd) : integer;
begin
  result := SendMessage(BarWnd, WM_GETFREEBARSPACE, 0,0);
end;

function GetBarPluginHeight(BarWnd : Hwnd) : Integer;
begin
  result := SendMessage(BarWnd,WM_GETBARHEIGHT,0,0);
end;

procedure PaintBarBackGround(BarWnd : Hwnd; bmp : TBitmap32;const pos : TRect);
var
  bkbmp : ^TBitmap32;
begin
  bkbmp := Pointer(SendMessage(BarWnd, WM_GETBACKGROUNDHANDLE,0,0));
  if (bkbmp <> nil) and (integer(bkbmp) > 0) then
  begin
    bkBmp^.DrawTo(bmp, 0,0, pos);
  end;
end;

procedure PaintBarBackGround(BarWnd : Hwnd; bmp : TBitmap32;const pos : TForm);
begin
  PaintBarBackGround(BarWnd,bmp,rect(pos.Left,pos.Top,
                     pos.Left + pos.Width, pos.Top + pos.Height));
end;

procedure PaintBarBackGround(BarWnd : Hwnd; bmp : TBitmap32; const pos : TForm; Width : integer);
begin
  PaintBarBackGround(BarWnd,bmp,rect(pos.Left,pos.Top,
                     pos.Left + Width, pos.Top + pos.Height));
end;


function GetModuleXMLFile(BarID, ModuleID : integer) : String;
var
  Dir : String;
  XML : TJclSimpleXML;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(BarID) + '\';
  if not FileExists(Dir + inttostr(ModuleID) + '.xml') then
  begin
    ForceDirectories(Dir);
    XML := TJclSimpleXML.Create;
    XML.Root.Name := 'ModuleSettings';
    XML.SaveToFile(Dir + inttostr(ModuleID) + '.xml');
  end;
  result := Dir + inttostr(ModuleID) + '.xml';
end;

end.
