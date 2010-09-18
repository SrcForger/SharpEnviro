{
Source Name: SharpDeskApi.pas
Description: Header for SharpDeskApi.dll
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
    TTextAligns = set of TTextAlign;
    TDeskFont = record
                  Name        : String;
                  Color       : integer;
                  Bold        : boolean;
                  Italic      : boolean;
                  Underline   : boolean;
                  ClearType   : boolean;
                  Alpha       : integer;
                  Size        : integer;
                  TextAlpha   : boolean;
                  ShadowColor : integer;
                  ShadowAlphaValue : integer;
                  Shadow      : boolean;
                  ShadowType  : integer;
                  ShadowSize  : integer;
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
     SDM_SETTINGS_UPDATE = 20;


// function GetAlphaBMP(Bmp : TBitmap32) : TBitmap32; external 'SharpDeskApi.dll';
procedure CreateDropShadow(Bmp : TBitmap32; StartX, StartY, sAlpha, color :integer); external 'SharpDeskApi.dll';
// procedure RemoveAlpha(var Bmp : TBitmap32); external 'SharpDeskApi.dll';
procedure releasebuffer(p : pChar); external 'SharpDeskApi.dll';

// Align: -1=Left; 0=Center; 1=Right
function RenderText(dst : TBitmap32; Font : TDeskFont; Text : TStringList; Align : TTextAlign; Spacing : integer) : boolean; overload; external 'SharpDeskApi.dll' name 'RenderTextC';
function RenderText(dst : TBitmap32; Font : TDeskFont; Text : String; Align : TTextAlign; Spacing : integer) : boolean; overload; external 'SharpDeskApi.dll' name 'RenderTextB';
function RenderTextNA(dst : TBitmap32; Font : TDeskFont; Text : TStringList; Align : TTextAlign; Spacing : integer; BGColor : integer) : boolean; external 'SharpDeskApi.dll';
function RenderIcon(dst : TBitmap32; Icon : TDeskIcon; SizeMod : TPoint) : boolean; external 'SharpDeskApi.dll';
function RenderObject(dst : TBitmap32; Icon : TDeskIcon; Font : TDeskFont; Caption : TDeskCaption; SizeMod : TPoint; OffsetMod : TPoint) : boolean; external 'SharpDeskApi.dll';
function RenderIconCaptionAligned(dst : TBitmap32; Icon : TBitmap32; Caption : TBitmap32; CaptionAlign : TTextAlign; IconOffset : TPoint; CaptionOffset : TPoint; IconHasShadow : boolean; CaptionHasShadow : boolean) : TAlignInfo; external 'SharpDeskApi.dll';

// wrapper functions
function DeskFont(Name : String; Color : integer; Bold : boolean; Italic : boolean; Underline : boolean; ClearType : boolean; Alpha : integer; Size : integer; ShadowColor : integer; TextAlpha : boolean; ShadowAlphaValue : integer; Shadow : boolean; ShadowType  : integer; ShadowSize  : integer) : TDeskFont;
function DeskIcon(Icon : TBitmap32; Size : integer; Alpha : integer; Blend : boolean; BlendColor : integer; BlendValue : integer; Shadow : boolean; ShadowColor : integer; ShadowAlpha : integer; XOffset : integer; YOffset : integer) : TDeskIcon;
function DeskCaption(Caption : TStringList; Align : TTextAlign; Xoffset : integer; Yoffset : integer; Draw : boolean; LineSpace : integer) : TDeskCaption;

function IntToTextAlign(a : integer) : TTextAlign; external 'SharpDeskApi.dll' name 'IntToTextAlign';


implementation

function DeskFont(Name        : String;
                  Color       : integer;
                  Bold        : boolean;
                  Italic      : boolean;
                  Underline   : boolean;
                  ClearType   : boolean;
                  Alpha       : integer;
                  Size        : integer;
                  ShadowColor : integer;
                  TextAlpha   : boolean;
                  ShadowAlphaValue : integer;
                  Shadow      : boolean;
                  ShadowType  : integer;
                  ShadowSize  : integer) : TDeskFont;
begin
  DeskFont.Name        := Name;
  DeskFont.Color       := Color;
  DeskFont.Bold        := Bold;
  DeskFont.Italic      := Italic;
  DeskFont.Underline   := Underline;
  DeskFont.ClearType   := ClearType;
  DeskFont.Alpha       := Alpha;
  DeskFont.Size        := Size;
  DeskFont.ShadowColor := ShadowColor;
  DeskFont.TextAlpha   := TextAlpha;
  DeskFont.ShadowAlphaValue := ShadowAlphaValue;
  DeskFont.Shadow      := Shadow;
  DeskFont.ShadowType  := ShadowType;
  DeskFont.ShadowSize  := ShadowSize;
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
  result.Alpha       := Alpha;
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

end.

