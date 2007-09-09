{
Source Name: uSharpBarAPI.pas
Description: SharpBar Tools API unit
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows XP

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

unit uSharpBarAPI;

interface

uses Forms,windows, Math, GR32, sysutils, SharpAPI, classes, JvSimpleXML;

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
  XML : TJvSimpleXML;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpBar\Bars\' + inttostr(BarID) + '\';
  if not FileExists(Dir + inttostr(ModuleID) + '.xml') then
  begin
    ForceDirectories(Dir);
    XML := TJvSimpleXML.Create(nil);
    XML.Root.Name := 'ModuleSettings';
    XML.SaveToFile(Dir + inttostr(ModuleID) + '.xml');
  end;
  result := Dir + inttostr(ModuleID) + '.xml';
end;

end.
