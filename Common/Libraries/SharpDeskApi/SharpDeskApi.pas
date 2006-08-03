{
Source Name: SharpDeskApi.pas
Description: Header for SharpDeskApi.dll
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 6
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
unit SharpDeskAPI;

interface
uses
    Windows,
    Gr32,
    classes,
    Graphics,
    SharpApi,
    JvSimpleXML;

type
    TWallpaperAlign = (waTile,waCenter,waStretch);
    TTextAlign = (taTop,taRight,taBottom,taLeft,taCenter);
     TDeskFont = record
                  Name        : String;
                  Color       : integer;
                  Bold        : boolean;
                  Italic      : boolean;
                  Underline   : boolean;
                  AALevel     : integer;
                  Alpha       : integer;
                  Size        : integer;
                  ShadowColor : integer;
                  ShadowAlpha : boolean;
                  ShadowAlphaValue : integer;
                  Shadow      : boolean;
                end;
    TDeskCaption = record
                     Caption   : TStringList;
                     Align     : TTextAlign;
                     Xoffset   : integer;
                     Yoffset   : integer;
                     Draw      : boolean;
                     LineSpace : integer;
                   end;
    TDeskIcon   = record
                    Icon        : TBitmap32;
                    Size        : integer;
                    Alpha       : integer;
                    Blend       : boolean;
                    BlendColor  : integer;
                    BlendValue  : integer;
                    Shadow      : boolean;
                    ShadowColor : integer;
                    ShadowAlpha : integer;
                    Xoffset     : integer;
                    Yoffset     : integer;
                  end;
    TAlignInfo = record
                   IconLeft : integer;
                   IconTop  : integer;
                   CaptionLeft : integer;
                   CaptionTop  : integer;
                 end;                  

const
     SDM_DEBUG = 0;           // Perform some Debug Action
     SDM_CLICK = 1;           // Click             | P1=Mouse.X | P2=Mouse.Y
     SDM_DOUBLE_CLICK = 2;    // Double Click      | P1=Mouse.X | P2=Mouse.Y
     SDM_MOUSE_ENTER = 3;     // On Mouse Enter    | P1=Mouse.X | P2=Mouse.Y
     SDM_MOUSE_LEAVE = 4;     // On Mouse Leave    | P1=Mouse.X | P2=Mouse.Y
     SDM_MOUSE_MOVE = 5;      // On Mouse Move;    | P1=Mouse.X | P2=Mouse.Y
     SDM_MOUSE_UP = 6;        // On Mouse Up;      | P1=Mouse.X | P2=Mouse.Y | P3=Button
     SDM_MOUSE_DOWN = 7;      // On Mouse Down;    | P1=Mouse.X | P2=Mouse.Y | P3=Button
     SDM_CLOSE_LAYER = 8;     // Close the Layer
     SDM_SHUTDOWN = 9;        // Shutdown whole Object and Close all Objects
     SDM_REPAINT_LAYER = 10;  // Repaint the Layer
     SDM_MENU_CLICK = 11;     // Object Menu Click | P1=Index
     SDM_SELECT = 12;
     SDM_DESELECT = 13;
     SDM_MOVE_LAYER = 14;
     SDM_MENU_POPUP = 15;
     SDM_UPDATE_LAYER = 16;
     SDM_DELETE_LAYER = 17;
     SDM_WEATHER_UPDATE = 18;
     SDM_INIT_DONE = 19;
     SDM_KEY_SET_FOCUS = 20;
     SDM_KEY_REMOVE_FOCUS = 21;
     SDM_KEY_SEND_INPUT = 22;

function LoadBmp(Bmp : TBitmap32; IconFile : string) : boolean; external 'SharpDeskApi.dll';
function LoadJpg(Bmp : TBitmap32; IconFile : string) : boolean; external 'SharpDeskApi.dll';
function LoadPng(out Bmp : TBitmap32; IconFile : string) : boolean; external 'SharpDeskApi.dll';
function LoadIco(Bmp : TBitmap32; IconFile : string; Size : integer) : boolean; external 'SharpDeskApi.dll';
function extrIcon(Bmp : TBitmap32; FileName : string) : boolean; external 'SharpDeskApi.dll';
function extrShellIcon(Bmp : TBitmap32; FileName : string) : boolean; external 'SharpDeskApi.dll';
function GetIconList(IconSet : widestring) : PChar; external 'SharpDeskApi.dll';
// function GetAlphaBMP(Bmp : TBitmap32) : TBitmap32; external 'SharpDeskApi.dll';
procedure IconToImage(Bmp : TBitmap32; const icon : hicon); external 'SharpDeskApi.dll';
procedure LightenBitmap(Bmp : TBitmap32; Amount :integer); external 'SharpDeskApi.dll' name 'LightenBitmapA'; overload;
procedure LightenBitmap(Bmp : TBitmap32; Amount :integer; Rect : TRect); external 'SharpDeskApi.dll' name 'LightenBitmapB'; overload;
procedure BlendImage(Bmp : TBitmap32; Color : TColor; alpha : integer); external 'SharpDeskApi.dll' name 'BlendImageA'; overload;
procedure BlendImage(Bmp : TBitmap32; Color : TColor); external 'SharpDeskApi.dll' name 'BlendImageB'; overload;
procedure CreateDropShadow(Bmp : TBitmap32; StartX, StartY, sAlpha, color :integer); external 'SharpDeskApi.dll';
// procedure RemoveAlpha(var Bmp : TBitmap32); external 'SharpDeskApi.dll';
procedure releasebuffer(p : pChar); external 'SharpDeskApi.dll';

function LoadIcon(bmp : TBitmap32; Icon,Target,IconSet : String; Size : integer) : boolean; external 'SharpDeskApi.dll';

// Align: -1=Left; 0=Center; 1=Right
function RenderText(dst : TBitmap32; Font : TDeskFont; Text : TStringList; Align : integer; Spacing : integer) : boolean; overload; external 'SharpDeskApi.dll'; 
function RenderText(dst : TBitmap32; Font : TDeskFont; Text : String; Align : integer; Spacing : integer) : boolean; overload; external 'SharpDeskApi.dll' name 'RenderTextB'; 
function RenderTextNA(dst : TBitmap32; Font : TDeskFont; Text : TStringList; Align : integer; Spacing : integer; BGColor : integer) : boolean; external 'SharpDeskApi.dll';
function RenderIcon(dst : TBitmap32; Icon : TDeskIcon; SizeMod : TPoint) : boolean; external 'SharpDeskApi.dll';
function RenderObject(dst : TBitmap32; Icon : TDeskIcon; Font : TDeskFont; Caption : TDeskCaption; SizeMod : TPoint; OffsetMod : TPoint) : boolean; external 'SharpDeskApi.dll';
function RenderIconCaptionAligned(dst : TBitmap32; Icon : TBitmap32; Caption : TBitmap32; CaptionAlign : TTextAlign; IconOffset : TPoint; CaptionOffset : TPoint; IconHasShadow : boolean; CaptionHasShadow : boolean) : TAlignInfo; external 'SharpDeskApi.dll';

// wrapper functions
function DeskFont(Name : String; Color : integer; Bold : boolean; Italic : boolean; Underline : boolean; AALevel : integer; Alpha : integer; Size : integer; ShadowColor : integer; ShadowAlpha : boolean; ShadowAlphaValue : integer; Shadow : boolean) : TDeskFont;
function DeskIcon(Icon : TBitmap32; Size : integer; Alpha : integer; Blend : boolean; BlendColor : integer; BlendValue : integer; Shadow : boolean; ShadowColor : integer; ShadowAlpha : integer; XOffset : integer; YOffset : integer) : TDeskIcon;
function DeskCaption(Caption : TStringList; Align : TTextAlign; Xoffset : integer; Yoffset : integer; Draw : boolean; LineSpace : integer) : TDeskCaption;
function IntToTextAlign(value : integer) : TTextAlign;

function RegisterInputArea(ID,X1,Y1,X2,Y2 : integer) : integer; external 'SharpDesk.exe';
function DeleteInputArea(oID,ID : integer) : boolean; external 'SharpDesk.exe';

                       
implementation

function DeskFont(Name        : String;
                  Color       : integer;
                  Bold        : boolean;
                  Italic      : boolean;
                  Underline   : boolean;
                  AALevel     : integer;
                  Alpha       : integer;
                  Size        : integer;
                  ShadowColor : integer;
                  ShadowAlpha : boolean;                  
                  ShadowAlphaValue : integer;
                  Shadow      : boolean) : TDeskFont;
begin
  DeskFont.Name        := Name;
  DeskFont.Color       := Color;
  DeskFont.Bold        := Bold;
  DeskFont.Italic      := Italic;
  DeskFont.Underline   := Underline;
  DeskFont.AALevel     := AALevel;
  DeskFont.Alpha       := Alpha;
  DeskFont.Size        := Size;
  DeskFont.ShadowColor := ShadowColor;
  DeskFont.ShadowAlpha := ShadowAlpha;
  DeskFont.ShadowAlphaValue := ShadowAlphaValue;
  DeskFont.Shadow      := Shadow;
end;

function DeskIcon(Icon        : TBitmap32;
                  Size        : integer;
                  Alpha       : integer;
                  Blend       : boolean;
                  BlendColor  : integer;
                  BlendValue  : integer;
                  Shadow      : boolean;
                  ShadowColor : integer;
                  ShadowAlpha : integer;
                  XOffset     : integer;
                  YOffset     : integer) : TDeskIcon;
begin
  result.Icon        := Icon;
  result.Size        := Size;
  result.Blend       := Blend;
  result.BlendColor  := BlendColor;
  result.BlendValue  := BlendValue;
  result.Shadow      := Shadow;
  result.ShadowColor := ShadowColor;
  result.ShadowAlpha := ShadowAlpha;
  result.XOffset     := XOffset;
  result.YOffset     := YOffset;
end;

function DeskCaption(Caption   : TStringList;
                     Align     : TTextAlign;
                     Xoffset   : integer;
                     Yoffset   : integer;
                     Draw      : boolean;
                     LineSpace : integer) : TDeskCaption;
begin
  result.Caption   := Caption;
  result.Align     := Align;
  result.Xoffset   := XOffset;
  result.Yoffset   := YOffset;
  result.LineSpace := LineSpace;
end;

function IntToTextAlign(value : integer) : TTextAlign;
begin
  case value of
    0: result := taTop;
    1: result := taRight;
    3: result := taLeft;
    4: result := taCenter;
    else result := taBottom
  end;
end;

end.

