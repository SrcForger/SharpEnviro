{
Source Name: graphicsFX
Description: Graphics FX methods
Copyright (C) Delusional (delusional@lowdimension.net)

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
unit graphicsFX;

interface

uses
    Types, Windows, Graphics, Classes;

type pBitmap = ^Tbitmap;
     pLongInt = ^Longint;  

procedure gradientH (canvas : TCanvas; rect : TRect; sColour, eColour : TColor);
procedure gradientV (canvas : TCanvas; rect : TRect; sColour, eColour : TColor);
procedure gradientD (canvas : TCanvas; rect : TRect; sColour, eColour : TColor);
//procedure doAlphaBlend(pBmap : pBitmap;pBmap2 : pBitmap;alpha : Integer); overload;
function doAlphaBlend(srcCanvas : TCanvas; srcrect : TRect; color : Tcolor; alpha : Integer) : TCanvas; overload;

function AlterColor (Color:TColor; Percent:Byte): TColor;
function Darker (Color:TColor; Percent: Byte): TColor;
function Lighter (Color:TColor; Percent: Byte): TColor;

implementation

{ Gradient procedures }

procedure gradientH (canvas : TCanvas; rect : TRect; sColour, eColour : TColor);
var
    curCol : integer;
    sR, sG, sB, cR, cG, cB : double;
    width : integer;
begin
    canvas.Pen.Color := sColour;
    width := (rect.Right - rect.Left);

    sR := GetRValue(sColour);
    sG := GetGValue(sColour);
    sB := GetBValue(sColour);

    cR := (GetRValue(eColour)-GetRValue(sColour))/width;
    cG := (GetGValue(eColour)-GetGValue(sColour))/width;
    cB := (GetBValue(eColour)-GetBValue(sColour))/width;

    for curCol := rect.Left to rect.Right do
    begin
        canvas.MoveTo(curCol, rect.Top);
        canvas.LineTo(curCol, rect.Bottom);

        canvas.Pen.Color := RGB(Round(sR+curCol*cR), Round(sG+curCol*cG), Round(sB+curCol*cB));
    end;
end;

procedure gradientV (canvas : TCanvas; rect : TRect; sColour, eColour : TColor);
var
    curRow                 : integer;
    sR, sG, sB, cR, cG, cB : double; 
    height : integer;
begin
    canvas.Pen.Color := sColour;
    height := rect.Bottom - rect.Top;

    sR := GetRValue(sColour);
    sG := GetGValue(sColour);
    sB := GetBValue(sColour);

    cR := (GetRValue(eColour)-GetRValue(sColour))/height;
    cG := (GetGValue(eColour)-GetGValue(sColour))/height;
    cB := (GetBValue(eColour)-GetBValue(sColour))/height;

    for curRow := rect.Top to rect.Bottom do
    begin
        canvas.MoveTo(rect.Left, curRow);
        canvas.LineTo(rect.Right, curRow);

        canvas.Pen.Color := RGB(Round(sR+curRow*cR), Round(sG+curRow*cG), Round(sB+curRow*cB));
    end;
end;

procedure gradientD (canvas : TCanvas; rect : TRect; sColour, eColour : TColor);
var
    Pw : Real;
    x0,y0,x1,y1,x2,y2,x3,y3 : Real;
    points:array[0..3] of TPoint; 
    DiffR, DiffG, DiffB : Integer;
    FromR, FromG, FromB : integer;
    width, height, i : integer;  
    R,G,B:Byte;
    preStyle : TPenStyle;
    preMode  : TPenMode;
begin
    preStyle := canvas.Pen.Style;
    preMode  := canvas.Pen.Mode;

    canvas.Pen.Style := psclear;
    canvas.Pen.Mode := pmCopy;
    width  := rect.Right - rect.Left + 1;
    height := rect.Bottom - rect.Top + 1;

    FromR := sColour and $000000ff;  //Strip out separate RGB values
    FromG := (sColour shr 8) and $000000ff;
    FromB := (sColour shr 16) and $000000ff;

    DiffR := (eColour and $000000ff) - FromR;  //Find the difference
    DiffG := ((eColour shr 8) and $000000ff) - FromG;
    DiffB := ((eColour shr 16) and $000000ff) - FromB;

    Pw := (width+height) / 255;
    for I := 0 to 254 do begin        //Make trapeziums of color
    
        y0 := height-1-(i*Pw);
        if (y0>0) then x0:=0 else
        begin
            x0:=-y0;
            y0:=0;
        end;

        y1:= height-1-((i+1)*pw);
        if (y1>0) then x1:=0 else
        begin
            x1:=-y1;
            y1:=0;
        end;

        x2:=(i*pw);
        if (x2<width) then y2:=height-1 else
        begin
            y2:=height-1-(x2-width);
            x2:=width-1;
        end;

        x3:=(i+1)*pw;
        if (x3<width) then y3:=height-1 else
        begin
            y3:=height-1-(x3-width);
            x3:=width-1;
        end;

        R := fromr + MulDiv(I, diffr, 255);    //Find the RGB values
        G := fromg + MulDiv(I, diffg, 255);
        B := fromb + MulDiv(I, diffb, 255);
        canvas.Brush.Color := RGB(R, G, B);  //Plug colors into brush
        points[0]:=point(Trunc(x0),Trunc(y0));
        points[1]:=point(Trunc(x1),Trunc(y1));
        points[3]:=point(Trunc(x2),Trunc(y2));
        points[2]:=point(Trunc(x3),Trunc(y3));
        canvas.polygon(points);
    end;

    canvas.Pen.Style := preStyle;
    canvas.Pen.Mode := preMode;
end;

{******************Malx*********************************}

{ Alphablending routines }

{procedure doAlphaBlend(pBmap : pBitmap; pBmap2 : pBitmap; alpha : Integer); overload;
var bitmap      : Tbitmap;
    bitmap2     : Tbitmap;
    CB1,CR1,CG1 : Byte;
    CB,CR,CG    : Byte;
    P32         : Pointer;
    P33         : Pointer;
    X,Y         : Integer;
    P,P3        : PLongInt;
    P2          : pChar;
begin
  if alpha > 255 then alpha := 255;
  if alpha < 0 then alpha := 0;
  bitmap  := pBmap^;
  bitmap.HandleType := bmDIB;
  bitmap.PixelFormat := pf32bit;
  bitmap2 := pBmap2^;
  bitmap2.HandleType:=bmDIB;
  bitmap2.PixelFormat:=pf32bit;
  for Y := 0 to bitmap.Height-1 do begin
    if Y > bitmap2.Height-1 then break;
    X:=-1;
    while X+1<bitmap.Width do begin
      Inc(X);
      if X > bitmap2.Width-1 then break;
      P32:=bitmap.ScanLine[Y];
      P33:=bitmap2.ScanLine[Y];
      P:=PLongInt(P32);
      P3:=PLongInt(P33);
      Inc(PChar(P),X*SizeOf(LongInt));
      Inc(PChar(P3),X*SizeOf(LongInt));
      CR:=GetBValue(P^);
      CG:=GetGValue(P^);
      CB:=GetRValue(P^);
      CR1:=GetBValue(P3^);
      CG1:=GetGValue(P3^);
      CB1:=GetRValue(P3^);
      CB := Round(((255-alpha)*CB1+alpha*CB)/255);
      CG := Round(((255-alpha)*CG1+alpha*CG)/255);
      CR := Round(((255-alpha)*CR1+alpha*CR)/255);
      P^ := CB;
      P2 := pChar(P);
      P2[1] := char(CG);
      P2[2] := char(CR);
    end;
  end;
end;     }

function doAlphaBlend(srcCanvas : TCanvas; srcrect : TRect; color : Tcolor; alpha : Integer) : TCanvas; overload;
var bitmap      : Tbitmap;
    CB1,CR1,CG1 : Byte;
    CB,CR,CG    : Byte;
    P32         : Pointer;
    X,Y         : Integer;
    P           : PLongInt;
    P2          : pChar;
    dstRect     : TRect;
begin

  if alpha > 255 then alpha := 255;
  if alpha < 0 then alpha := 0;
  CB1:=GetBValue(colortorgb(color));
  CG1:=GetGValue(colortorgb(color));
  CR1:=GetRValue(colortorgb(color));

  dstRect := Rect(0, 0, srcRect.Right - srcRect.Left, srcRect.Bottom - srcRect.Top);

  bitmap := TBitmap.Create;
  bitmap.Canvas.CopyMode := cmSrcCopy;
  srcCanvas.CopyMode := cmSrcCopy;
  bitmap.Canvas.CopyRect(dstRect, srcCanvas, srcRect);

  bitmap.HandleType:=bmDIB;
  bitmap.PixelFormat:=pf32bit;
  for Y := 0 to bitmap.Height-1 do begin
    X:=-1;
    while X+1<bitmap.Width do begin
      Inc(X);
      P32:=bitmap.ScanLine[Y];
      P:=PLongInt(P32);
      Inc(PChar(P),X*SizeOf(LongInt));
      CR:=GetBValue(P^);
      CG:=GetGValue(P^);
      CB:=GetRValue(P^);
      CB := Round(((255-alpha)*CB1+alpha*CB)/255);
      CG := Round(((255-alpha)*CG1+alpha*CG)/255);
      CR := Round(((255-alpha)*CR1+alpha*CR)/255);
      P^ := CB;
      P2 := pChar(P);
      P2[1] := char(CG);
      P2[2] := char(CR);
    end;
  end;

  srcCanvas.CopyRect(srcRect, bitmap.Canvas, dstRect);
  bitmap.Free;

  doAlphaBlend := srcCanvas;
end;

{******************Lowspirit****************************}

function AlterColor (Color:TColor; Percent:Byte):TColor;
var
    r,g,b:Byte;
begin
    Color:=ColorToRGB(Color);
    r:=GetRValue(Color);
    g:=GetGValue(Color);
    b:=GetBValue(Color);

    if (r > 135) or (g > 135) or (b > 135)
    then
        AlterColor := Darker (Color,Percent)
    else
        AlterColor := Lighter (Color,Percent);
end;

function Darker(Color:TColor;  Percent:Byte):TColor;  
var
    r,g,b:Byte;
begin      
    Color:=ColorToRGB(Color);
    r:=GetRValue(Color);
    g:=GetGValue(Color);
    b:=GetBValue(Color);

    r:=r-muldiv(r,Percent,100);  //Percent% closer to black
    g:=g-muldiv(g,Percent,100);
    b:=b-muldiv(b,Percent,100);
    result:=RGB(r,g,b);
end;

function Lighter(Color:TColor; Percent:Byte):TColor;  
var
    r,g,b:Byte;
begin   
    Color:=ColorToRGB(Color);
    r:=GetRValue(Color);
    g:=GetGValue(Color);
    b:=GetBValue(Color);
    
    r:=r+muldiv(255-r,Percent,100); //Percent% closer to white
    g:=g+muldiv(255-g,Percent,100);
    b:=b+muldiv(255-b,Percent,100);
    result:=RGB(r,g,b);
end;

end.
