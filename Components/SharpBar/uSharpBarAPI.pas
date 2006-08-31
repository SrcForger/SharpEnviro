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

uses JvSimpleXML, windows, forms,GR32, sysutils, SharpAPI, classes;

type
  TModuleSize = record
                  Min      : integer;
                  Width    : integer;
                  Priority : integer;
                end;
  PModuleSize = ^TModuleSize;


function GetModuleXMLItem(BarWnd : Hwnd; ID : integer) : TJvSimpleXMLElem;

function GetFreeBarSpace(BarWnd : hWnd) : integer;
function GetBarPluginHeight(BarWnd : Hwnd) : Integer;
procedure PaintBarBackGround(BarWnd : Hwnd; bmp : TBitmap32; const pos : TRect); overload;
procedure PaintBarBackGround(BarWnd : Hwnd; bmp : TBitmap32; const pos : TForm); overload;

procedure SaveXMLFile(BarWnd : hWnd);

implementation

function GetFreeBarSpace(BarWnd : hWnd) : integer;
begin
  result := SendMessage(BarWnd, WM_GETFREEBARSPACE, 0,0);
end;

procedure SaveXMLFile(BarWnd : hWnd);
begin
  SendMessage(BarWnd, WM_SAVEXMLFILE,0,0);
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


function GetModuleXMLItem(BarWnd : Hwnd; ID : integer) : TJvSimpleXMLElem;
var
  n : integer;
  XML : ^TJvSimpleXML;
begin
  XML := Pointer(SendMessage(BarWnd, WM_GETXMLHANDLE,0,0));

  if (Xml = nil) or (integer(XML) <= 0) then
  begin
    result := nil;
    exit;
  end;

  for n := 0 to XML^.Root.Items.Count -1 do
  begin
    if XML^.Root.Items.Item[n].Items.IntValue('ID',-1) = ID then
    begin
      // check if the xml item has a Settings sub item - if not create it
      if XML^.Root.Items.Item[n].Items.ItemNamed['Settings'] = nil then
         XML^.Root.Items.Item[n].Items.Add('Settings');
      // set XMLItem to the Settings sub item (will be passed to the module)
      // Item found
      result := XML^.Root.Items.Item[n].Items.ItemNamed['Settings'];
      exit;
      break;
    end;
  end;
  result := nil;
end;

end.
