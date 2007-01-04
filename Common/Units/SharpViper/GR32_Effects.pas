{
Source Name: GR32_Effects.pas
Description: GR32 Special Effects file
Copyright (C) Viper <tom_viper@msn.com>

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
unit GR32_Effects;

interface

uses
  GR32_Transforms, Gr32_filters, GR32_Image, GR32, GR32_Blend,
  Gr32_LowLevel, Math, Types, Windows;

  procedure FastBlur(Src: TBitmap32; aRadius: Integer; aPasses:
    Integer = 3);
  { Filter Function: X, Y are the coordinates of flare center. }
  procedure Flare(Src, Dest: TBitmap32; const X, Y: Integer);
  procedure GlassTiles(Src, Dest: TBitmap32; const TileWidth, TileHeight: Word);
  procedure GrayscaleFilterMMX(Src, Dest: TBitmap32; const Filter: TColor32);
  procedure LightenBitmap(Src: TBitmap32;iLightenAmount: integer = 16);
  procedure Mirror(Src, Dest: TBitmap32);
  procedure Negative(Src: TBitmap32);
  procedure NegativeRGB(Src: TBitmap32);
  procedure Sepia(Src: TBitmap32; SepiaIntensity: integer = 30);

procedure ExtractChannel(Src, Dest: TBitmap32; iChannel: integer = 0);

implementation

{$REGION ' FlareFX32 '}
type
  TRGBFloat = record
    r: Real;
    g: Real;
    b: Real;
  end;
  TReflect = record
    CCol : TRGBFloat;
    Size : Real;
    xp   : Integer;
    yp   : Integer;
    Types: Integer;
  end;
{$ENDREGION}

var
  SColor, SGlow, SInner, SOuter, SHalo: Real;
  Color, Glow, Inner, Outer, Halo     : TRGBFloat;
  Ref1  : array [0 .. 18] of TReflect;
  NumRef: Integer;

{$REGION ' ExtractChannel '}
procedure ExtractChannel(Src, Dest: TBitmap32; iChannel: integer = 0);
var
  i: Integer;
  D, S: PColor32;
begin
  //iChannel Values:
  //                 0 := Red
  //                 1 := Green
  //                 2 := Blue

  CheckParams(Dest, Src);

  Dest.SetSize(Src.Width, Src.Height);
  D := @Dest.Bits[0];
  S := @Src.Bits[0];

  for i := 0 to Src.Width * Src.Height - 1 do
   begin
    case iChannel of
     0: D^ := S^ and $FFFF0000;
     1: D^ := S^ and $FF00FF00;
     2: D^ := S^ and $FF0000FF;
    end;

    Inc(S);
    Inc(D);
   end;

  Dest.Changed;
end;
{$ENDREGION}
{$REGION ' Flare '}
{ Filter Function: X, Y are the coordinates of flare center. }
procedure Flare(Src, Dest: TBitmap32; const X, Y: Integer);
procedure FixPix(var AColor: TColor32; const Procent: Real;
  const ColPro: TRGBFloat);
var
  a      : Cardinal;
  r, g, b: Integer;
begin
  a := AColor shr 24 and $FF;
  r := AColor shr 16 and $FF;
  g := AColor shr  8 and $FF;
  b := AColor        and $FF;

  r := r + Trunc( (255 - r) * Procent * ColPro.r );
  g := g + Trunc( (255 - g) * Procent * ColPro.g );
  b := b + Trunc( (255 - b) * Procent * ColPro.b );

  AColor := (a shl 24) or (r shl 16) or (g shl 8) or b;
end; { FixPix }
procedure MColor(var AColor: TColor32; h: Real);
var
  Procent: Real;
begin
  Procent := SColor - h;
  Procent := Procent / SColor;
  if Procent > 0.0 then
  begin
    Procent := Procent * Procent;
    FixPix(AColor, Procent, Color);
  end;
end; { MColor }
procedure MGlow(var AColor: TColor32; h: Real);
var
  Procent: Real;
begin
  Procent := SGlow - h;
  Procent := Procent / SGlow;
  if Procent > 0.0 then
  begin
    Procent := Procent * Procent;
    FixPix(AColor, Procent, Glow);
  end;
end; { MGlow }
procedure MInner(var AColor: TColor32; h: Real);
var
  Procent: Real;
begin
  Procent := SInner - h;
  Procent := Procent / SInner;
  if Procent > 0.0 then
  begin
    Procent := Procent * Procent;
    FixPix(AColor, Procent, Inner);
  end;
end; { MInner }
procedure MOuter(var AColor: TColor32; h: Real);
var
  Procent: Real;
begin
  Procent := SOuter - h;
  Procent := Procent / SOuter;
  if   Procent > 0.0
  then FixPix(AColor, Procent, Outer);
end; { MOuter }
procedure MHalo(var AColor: TColor32; h: Real);
var
  Procent: Real;
begin
  Procent := h - SHalo;
  Procent := Procent / (SHalo * 0.07);
  Procent := Abs(Procent);
  if   Procent < 1.0
  then FixPix(AColor, 1.0 - Procent, Halo);
end; { MHalo }
procedure InitRef(sx, sy, Width, Height, Matt: Integer);
var
  xh, yh, dx, dy: Integer;
begin
  xh              := Width  div 2;
  yh              := Height div 2;
  dx              := xh - sx;
  dy              := yh - sy;
  NumRef          := 19;
  Ref1[0].Types   := 1;
  Ref1[0].Size    := Matt * 0.027;
  Ref1[0].xp      := Round(0.6699 * dx + xh);
  Ref1[0].yp      := Round(0.6699 * dy + yh);
  Ref1[0].CCol.r  := 0.0;
  Ref1[0].CCol.g  := 14.0 / 255.0;
  Ref1[0].CCol.b  := 113.0 / 255.0;
  Ref1[1].Types   := 1;
  Ref1[1].Size    := Matt * 0.01;
  Ref1[1].xp      := Round(0.2692 * dx + xh);
  Ref1[1].yp      := Round(0.2692 * dy + yh);
  Ref1[1].CCol.r  := 90.0 / 255.0;
  Ref1[1].CCol.g  := 181.0 / 255.0;
  Ref1[1].CCol.b  := 142.0 / 255.0;
  Ref1[2].Types   := 1;
  Ref1[2].Size    := Matt * 0.005;
  Ref1[2].xp      := Round(-0.0112 * dx + xh);
  Ref1[2].yp      := Round(-0.0112 * dy + yh);
  Ref1[2].CCol.r  := 56.0 / 255.0;
  Ref1[2].CCol.g  := 140.0 / 255.0;
  Ref1[2].CCol.b  := 106.0 / 255.0;
  Ref1[3].Types   := 2;
  Ref1[3].Size    := Matt * 0.031;
  Ref1[3].xp      := Round(0.6490 * dx + xh);
  Ref1[3].yp      := Round(0.6490 * dy + yh);
  Ref1[3].CCol.r  := 9.0 / 255.0;
  Ref1[3].CCol.g  := 29.0 / 255.0;
  Ref1[3].CCol.b  := 19.0 / 255.0;
  Ref1[4].Types   := 2;
  Ref1[4].Size    := Matt * 0.015;
  Ref1[4].xp      := Round(0.4696 * dx + xh);
  Ref1[4].yp      := Round(0.4696 * dy + yh);
  Ref1[4].CCol.r  := 24.0 / 255.0;
  Ref1[4].CCol.g  := 14.0 / 255.0;
  Ref1[4].CCol.b  := 0.0;
  Ref1[5].Types   := 2;
  Ref1[5].Size    := Matt * 0.037;
  Ref1[5].xp      := Round(0.4087 * dx + xh);
  Ref1[5].yp      := Round(0.4087 * dy + yh);
  Ref1[5].CCol.r  := 24.0 / 255.0;
  Ref1[5].CCol.g  := 14.0 / 255.0;
  Ref1[5].CCol.b  := 0.0;
  Ref1[6].Types   := 2;
  Ref1[6].Size    := Matt * 0.022;
  Ref1[6].xp      := Round(-0.2003 * dx + xh);
  Ref1[6].yp      := Round(-0.2003 * dy + yh);
  Ref1[6].CCol.r  := 42.0 / 255.0;
  Ref1[6].CCol.g  := 19.0 / 255.0;
  Ref1[6].CCol.b  := 0.0;
  Ref1[7].Types   := 2;
  Ref1[7].Size    := Matt * 0.025;
  Ref1[7].xp      := Round(-0.4103 * dx + xh);
  Ref1[7].yp      := Round(-0.4103 * dy + yh);
  Ref1[7].CCol.b  := 17.0 / 255.0;
  Ref1[7].CCol.g  := 9.0 / 255.0;
  Ref1[7].CCol.r  := 0.0;
  Ref1[8].Types   := 2;
  Ref1[8].Size    := Matt * 0.058;
  Ref1[8].xp      := Round(-0.4503 * dx + xh);
  Ref1[8].yp      := Round(-0.4503 * dy + yh);
  Ref1[8].CCol.b  := 10.0 / 255.0;
  Ref1[8].CCol.g  := 4.0 / 255.0;
  Ref1[8].CCol.r  := 0.0;
  Ref1[9].Types   := 2;
  Ref1[9].Size    := Matt * 0.017;
  Ref1[9].xp      := Round(-0.5112 * dx + xh);
  Ref1[9].yp      := Round(-0.5112 * dy + yh);
  Ref1[9].CCol.r  := 5.0 / 255.0;
  Ref1[9].CCol.g  := 5.0 / 255.0;
  Ref1[9].CCol.b  := 14.0 / 255.0;
  Ref1[10].Types  := 2;
  Ref1[10].Size   := Matt * 0.2;
  Ref1[10].xp     := Round(-1.496 * dx + xh);
  Ref1[10].yp     := Round(-1.496 * dy + yh);
  Ref1[10].CCol.r := 9.0 / 255.0;
  Ref1[10].CCol.g := 4.0 / 255.0;
  Ref1[10].CCol.b := 0.0;
  Ref1[11].Types  := 2;
  Ref1[11].Size   := Matt * 0.5;
  Ref1[11].xp     := Round(-1.496 * dx + xh);
  Ref1[11].yp     := Round(-1.496 * dy + yh);
  Ref1[11].CCol.r := 9.0 / 255.0;
  Ref1[11].CCol.g := 4.0 / 255.0;
  Ref1[11].CCol.b := 0.0;
  Ref1[12].Types  := 3;
  Ref1[12].Size   := Matt * 0.075;
  Ref1[12].xp     := Round(0.4487 * dx + xh);
  Ref1[12].yp     := Round(0.4487 * dy + yh);
  Ref1[12].CCol.r := 34.0 / 255.0;
  Ref1[12].CCol.g := 19.0 / 255.0;
  Ref1[12].CCol.b := 0.0;
  Ref1[13].Types  := 3;
  Ref1[13].Size   := Matt * 0.1;
  Ref1[13].xp     := dx + xh;
  Ref1[13].yp     := dy + yh;
  Ref1[13].CCol.r := 14.0 / 255.0;
  Ref1[13].CCol.g := 26.0 / 255.0;
  Ref1[13].CCol.b := 0.0;
  Ref1[14].Types  := 3;
  Ref1[14].Size   := Matt * 0.039;
  Ref1[14].xp     := Round(-1.301 * dx + xh);
  Ref1[14].yp     := Round(-1.301 * dy + yh);
  Ref1[14].CCol.r := 10.0 / 255.0;
  Ref1[14].CCol.g := 25.0 / 255.0;
  Ref1[14].CCol.b := 13.0 / 255.0;
  Ref1[15].Types  := 4;
  Ref1[15].Size   := Matt * 0.19;
  Ref1[15].xp     := Round(1.309 * dx + xh);
  Ref1[15].yp     := Round(1.309 * dy + yh);
  Ref1[15].CCol.r := 9.0 / 255.0;
  Ref1[15].CCol.g := 0.0;
  Ref1[15].CCol.b := 17.0 / 255.0;
  Ref1[16].Types  := 4;
  Ref1[16].Size   := Matt * 0.195;
  Ref1[16].xp     := Round(1.309 * dx + xh);
  Ref1[16].yp     := Round(1.309 * dy + yh);
  Ref1[16].CCol.r := 9.0 / 255.0;
  Ref1[16].CCol.g := 16.0 / 255.0;
  Ref1[16].CCol.b := 5.0 / 255.0;
  Ref1[17].Types  := 4;
  Ref1[17].Size   := Matt * 0.20;
  Ref1[17].xp     := Round(1.309 * dx + xh);
  Ref1[17].yp     := Round(1.309 * dy + yh);
  Ref1[17].CCol.r := 17.0 / 255.0;
  Ref1[17].CCol.g := 4.0 / 255.0;
  Ref1[17].CCol.b := 0.0;
  Ref1[18].Types  := 4;
  Ref1[18].Size   := Matt * 0.038;
  Ref1[18].xp     := Round(-1.301 * dx + xh);
  Ref1[18].yp     := Round(-1.301 * dy + yh);
  Ref1[18].CCol.r := 17.0 / 255.0;
  Ref1[18].CCol.g := 4.0 / 255.0;
  Ref1[18].CCol.b := 0.0;
end; { InitRef }
procedure mrt1(var AColor: TColor32; const i, Col, Row: Integer);
var
  Procent: Real;
begin
  Procent := Ref1[i].Size - Hypot(Ref1[i].xp - Col, Ref1[i].yp - Row);
  Procent := Procent / Ref1[i].Size;
  if Procent > 0.0 then
  begin
    Procent := Procent * Procent;
    FixPix(AColor, Procent, Ref1[i].CCol);
  end;
end; { mrt1 }
procedure mrt2(var AColor: TColor32; const i, Col, Row: Integer);
var
  Procent: Real;
begin
  Procent := Ref1[i].Size - Hypot(Ref1[i].xp - Col, Ref1[i].yp - Row);
  Procent := Procent / (Ref1[i].Size * 0.15);
  if Procent > 0.0 then
  begin
    if   Procent > 1.0
    then Procent := 1.0;
    FixPix(AColor, Procent, Ref1[i].CCol);
  end;
end; { mrt2 }
procedure mrt3(var AColor: TColor32; const i, Col, Row: Integer);
var
  Procent: Real;
begin
  Procent := Ref1[i].Size - Hypot(Ref1[i].xp - Col, Ref1[i].yp - Row);
  Procent := Procent / (Ref1[i].Size * 0.12);
  if Procent > 0.0 then
  begin
    if   Procent > 1.0
    then Procent := 1.0 - (Procent * 0.12);
    FixPix(AColor, Procent, Ref1[i].CCol);
  end;
end; { mrt3 }
procedure mrt4(var AColor: TColor32; const i, Col, Row: Integer);
var
  Procent: Real;
begin
  Procent := Hypot(Ref1[i].xp - Col, Ref1[i].yp - Row) - Ref1[i].Size;
  Procent := Procent / (Ref1[i].Size * 0.04);
  Procent := Abs(Procent);
  if   Procent < 1.0
  then FixPix(AColor, 1.0 - Procent, Ref1[i].CCol);
end; { mrt4 }
var
  Col, Row, Matt, i: Integer;
  Width, Height    : Integer;
  hyp              : Real;
  AColor           : TColor32;
  a                : Cardinal;
  r, g, b          : Integer;
  SRow, DRow       : PColor32Array;
begin
  CheckParams(Dest, Src);

  if   Dest.Width <> Src.Width
  then Dest.Width := Src.Width;

  if   Dest.Height <> Src.Height
  then Dest.Height := Src.Height;

  Matt   := Src.Width;
  Width  := Src.Width;
  Height := Src.Height;

  SColor := Matt * 0.0375;
  SGlow  := Matt * 0.078125;
  SInner := Matt * 0.1796875;
  SOuter := Matt * 0.3359375;
  SHalo  := Matt * 0.084375;

  Color.r := 239.0/255.0;
  Color.g := 239.0/255.0;
  Color.b := 239.0/255.0;
  Glow.r  := 245.0/255.0;
  Glow.g  := 245.0/255.0;
  Glow.b  := 245.0/255.0;
  Inner.r := 255.0/255.0;
  Inner.g := 38.0/255.0;
  Inner.b := 43.0/255.0;
  Outer.r := 69.0/255.0;
  Outer.g := 59.0/255.0;
  Outer.b := 64.0/255.0;
  Halo.r  := 80.0/255.0;
  Halo.g  := 15.0/255.0;
  Halo.b  := 4.0/255.0;

  InitRef(X, Y, Width, Height, Matt);

  {Loop through the rows}
  for Row := 0 to Src.Height - 1 do
  begin
    SRow := Src.ScanLine[Row];
    DRow := Dest.ScanLine[Row];
    for Col := 0 to Src.Width - 1 do
    begin
      AColor := SRow[Col];

      hyp := Hypot(Col - X, Row - Y);
      MColor(AColor, hyp);  // make color
      MGlow (AColor, hyp);  // make glow
      MInner(AColor, hyp);  // make inner
      MOuter(AColor, hyp);  // make outer
      MHalo (AColor, hyp);  // make halo

      for i := 0 to NumRef - 1 do
      begin
        case Ref1[i].Types of
          1: mrt1(AColor, i, Col, Row);
          2: mrt2(AColor, i, Col, Row);
          3: mrt3(AColor, i, Col, Row);
          4: mrt4(AColor, i, Col, Row);
        end;
      end;

      a := SRow[Col] shr 24 and $FF;
      r := AColor    shr 16 and $FF;
      g := AColor    shr  8 and $FF;
      b := AColor           and $FF;

      DRow[Col] := (a shl 24) or (r shl 16) or (g shl 8) or b;
    end;
  end;

  Dest.Changed;
end;
{$ENDREGION}
{$REGION ' FastBlur '}
procedure FastBlur(Src: TBitmap32; aRadius: Integer; aPasses:
Integer = 3);
// Quick box blur algoritm

// aPasses:
// 1: Blur quality too low
// 2: Best speed / quality compromise
// 3: Good quality but impossible to have a small blur radius. Even
//radius 1 gives a large blur.

type
   PSumRecord = ^TSumRecord;
   TSumRecord = packed record
     B, G, R, A: cardinal;
   end;

var
  iPass:        integer;
  lBoxSize:     cardinal;
  lColor32:     TColor32;
  lHeight1:     integer;
  lSumArray:    array of TSumRecord;
  lWidth1:      integer;
  x:            integer;
  xBitmap:      integer;
  y:            integer;
  yBitmap:      integer;
begin
//  CheckParams(Dest, Src);

  if aRadius <= 0 then
  begin
   Exit;
  end;

  lBoxSize := (aRadius * 2) + 1;

  lWidth1  := Src.Width  - 1;
  lHeight1 := Src.Height - 1;

  // Process horizontally
  SetLength(lSumArray, Src.Width + 2 * aRadius + 1);

  for yBitmap := 0 to lHeight1 do
  begin

    for iPass := 1 to aPasses do
    begin

      // First element is zero
      lSumArray[0].A := 0;
      lSumArray[0].R := 0;
      lSumArray[0].G := 0;
      lSumArray[0].B := 0;

      for x := Low(lSumArray) + 1 to High(lSumArray) do
      begin

        xBitmap := x - aRadius - 1;

        if xBitmap < 0 then
        begin
          xBitmap := 0;
        end
        else if xBitmap > lWidth1 then
        begin
          xBitmap := lWidth1;
        end;

        lColor32 := PColor32(Src.PixelPtr[xBitmap, yBitmap])^;

        lSumArray[x].A := lSumArray[x - 1].A + lColor32 shr 24;
        lSumArray[x].R := lSumArray[x - 1].R + lColor32 shr 16 and $FF;
        lSumArray[x].G := lSumArray[x - 1].G + lColor32 shr 8  and $FF;
        lSumArray[x].B := lSumArray[x - 1].B + lColor32        and $FF;

      end;

      for xBitmap := 0 to lWidth1 do
      begin

        x := xBitmap + aRadius + 1;

        PColor32(Src.PixelPtr[xBitmap, yBitmap])^ :=
          ((lSumArray[x + aRadius].A - lSumArray[x - aRadius - 1].A)
div lBoxSize) shl 24 or
          ((lSumArray[x + aRadius].R - lSumArray[x - aRadius - 1].R)
div lBoxSize) shl 16 or
          ((lSumArray[x + aRadius].G - lSumArray[x - aRadius - 1].G)
div lBoxSize) shl 8 or
           (lSumArray[x + aRadius].B - lSumArray[x - aRadius - 1].B)
div lBoxSize;

      end;
    end;

  end;

  // Process vertically
  SetLength(lSumArray, Src.Height + 2 * aRadius + 1);

  for xBitmap := 0 to lWidth1 do
  begin

    for iPass := 1 to aPasses do
    begin

      // First element is zero
      lSumArray[0].A := 0;
      lSumArray[0].R := 0;
      lSumArray[0].G := 0;
      lSumArray[0].B := 0;

      for y := Low(lSumArray) + 1 to High(lSumArray) do
      begin

        yBitmap := y - aRadius - 1;

        if yBitmap < 0 then
        begin
          yBitmap := 0;
        end
        else if yBitmap > lHeight1 then
        begin
          yBitmap := lHeight1;
        end;

        lColor32 := PColor32(Src.PixelPtr[xBitmap, yBitmap])^;

        lSumArray[y].A := lSumArray[y - 1].A + lColor32 shr 24;
        lSumArray[y].R := lSumArray[y - 1].R + lColor32 shr 16 and $FF;
        lSumArray[y].G := lSumArray[y - 1].G + lColor32 shr 8  and $FF;
        lSumArray[y].B := lSumArray[y - 1].B + lColor32        and $FF;

      end;

      for yBitmap := 0 to lHeight1 do
      begin

        y := yBitmap + aRadius + 1;

        PColor32(Src.PixelPtr[xBitmap, yBitmap])^ :=
          ((lSumArray[y + aRadius].A - lSumArray[y - aRadius - 1].A)
div lBoxSize) shl 24 or
          ((lSumArray[y + aRadius].R - lSumArray[y - aRadius - 1].R)
div lBoxSize) shl 16 or
          ((lSumArray[y + aRadius].G - lSumArray[y - aRadius - 1].G)
div lBoxSize) shl 8  or
           (lSumArray[y + aRadius].B - lSumArray[y - aRadius - 1].B)
div lBoxSize;

      end;
    end;
  end;
Src.Changed;
end;
{$ENDREGION}
{$REGION ' GlassTiles '}
procedure GlassTiles(Src, Dest: TBitmap32; const TileWidth, TileHeight: Word);
type
  PSmallPointRec = ^TSmallPointRec;
  TSmallPointRec = record
    case Integer of
      //Signed
      0: (X, Y: SmallInt);
      1: (Entries: array[0..1] of SmallInt);
      2: (Point: TSmallPoint);
      //Unsigned
      3: (uX, uY: Word);
      4: (uEntries: array[0..1] of Word);
      5: (uXY: Cardinal);
  end;
  TWrapLookupTable = array of TSmallPointRec;

 procedure ApplyWrapLookupTable(Src, Dest: TBitmap32; Table: TWrapLookupTable);
 var
  I, J, P: Integer;
  DstPtr: PColor32;
  SrcRow: PColor32Array;
  PTablePointX, PTablePointY: PSmallPointRec;
 begin
  Dest.BeginUpdate;
  try
    if (Dest.Width <> Src.Width) or (Dest.Height <> Src.Height) then
      Dest.SetSizeFrom(Src);

    if not (Length(Table) = Max(Src.Width, Src.Height)) then
    begin
      //Repair table by extending with normal corresponding coords.
      J := Length(Table) - 1;
      SetLength(Table, Max(Src.Width, Src.Height));
      for I := J to Length(Table) - 1 do
        for P := Low(Table[I].Entries) to High(Table[I].Entries) do
          Table[I].Entries[P] := J;
    end;

    DstPtr := @Dest.PixelPtr[0, 0]^;
    PTablePointY := @Table[0];
    for J := 0 to Src.Height - 1 do
    begin
      SrcRow := Src.Scanline[PTablePointY.Y];
      PTablePointX := @Table[0];
      for I := 0 to Src.Width - 1 do
      begin
        DstPtr^ := SrcRow[PTablePointX.X];
        Inc(PTablePointX);
        Inc(DstPtr);
      end;
      Inc(PTablePointY);
    end;
  finally
    Dest.EndUpdate;
    Dest.Changed;
  end;
 end;
var
  I, J: Integer;
  C, T, CT, OT, WH, TWH: TSmallPointRec;
  WrapProc: TWrapProc;
  Table: TWrapLookupTable;
begin
  CheckParams(Dest, Src);

  if (Dest.Width <> Src.Width) or (Dest.Height <> Src.Height) then
    Dest.SetSizeFrom(Src);

  WrapProc := WRAP_PROCS[Src.WrapMode];
  SetLength(Table, Max(Src.Width, Src.Height));

  DivMod(TileWidth, 2, C.uX, T.uX);
  DivMod(TileHeight, 2, C.uY, T.uY);

  CT.uXY := 0; OT.uXY := 0;
  WH.uX := Src.Width - 1; WH.uY := Src.Height - 1;
  TWH.uX := TileWidth; TWH.uY := TileHeight;

  for I := 0 to Length(Table) - 1 do
    for J := Low(C.Entries) to High(C.Entries) do
    begin
      Inc(OT.Entries[J]);
      if OT.Entries[J] >= C.uEntries[J] then
      begin
        Inc(CT.Entries[J], TWH.Entries[J]);
        OT.Entries[J] := - C.uEntries[J] - T.uEntries[J];
      end;
      Table[I].Entries[J] := WrapProc(CT.Entries[J] + OT.Entries[J] * 2, WH.uEntries[J]);
    end;

  ApplyWrapLookupTable(Src, Dest, Table);
end;
{$ENDREGION}
{$REGION ' GrayscaleFilterMMX '}
procedure GrayscaleFilterMMX(Src, Dest: TBitmap32; const Filter: TColor32);
type
  PPackedQuadWord = ^TPackedQuadWord;
  TPackedQuadWord = packed record B, G, R, A: Word end;
const
  FixShift = 30;
var
  SumScaler: Cardinal;
  PackedFilter: TPackedQuadWord;

  procedure PrepareFilter(Filter: TColor32);
    procedure PrepareRegisters(P: PPackedQuadWord);
    asm
      PXOR  MM0, MM0
      MOVQ  MM1, [EAX]
    end;
  var
    SR, SG, SB: Single;
  begin
    with TColor32Entry(Filter) do
    begin
      SR := $FFFF * (R/255);
      SG := $FFFF * (G/255);
      SB := $FFFF * (B/255);
      PackedFilter.A := 0;
      PackedFilter.R := Round(SR);
      PackedFilter.G := Round(SG);
      PackedFilter.B := Round(SB);
      SumScaler := Round((1 shl FixShift) / (255 * ((SR + SG + SB) /
$FFFF)));
    end;
    PrepareRegisters(@PackedFilter);
  end;
  function GetFilteredColor(const Color: TColor32): TColor32;
    function Dummy(const Color: TColor32; const SumScaler: Cardinal):
Cardinal;
    asm
          MOVD      MM2, EAX
          PUNPCKLBW MM2, MM0 // MM0 initialized in 'PrepareRegisters'
          PSLLW     MM2, 8
          PMULHUW   MM2, MM1 // MM1 loaded in 'PrepareRegisters'
          MOVD      ECX, MM2
          MOVZX     EAX, CX
          SHR       ECX, 16
          ADD       EAX, ECX
          PSRLQ     MM2, 32
          MOVD      ECX, MM2
          AND       ECX, $FFFF
          ADD       EAX, ECX
          IMUL      EDX
          SHRD      EAX, EDX, FixShift
          MOV       EDX, EAX
          SHL       EDX, 8
          ADD       EAX, EDX
          SHL       EDX, 8
          ADD       EAX, EDX
    end;
  begin
    Result := Color and $FF000000;
    Inc(Result, Dummy(Color, SumScaler));
  end;

var
    I: Integer;
    SrcPtr, DstPtr: PColor32;
begin
  CheckParams(Dest, Src);

   if Src.Empty  then
   begin
     Dest.SetSize(0,0);
     Exit;
   end;
   try
     Dest.SetSizeFrom(Src);
     SrcPtr := @Src.Bits[0];
     DstPtr := @Dest.Bits[0];
     if (Filter and $00FFFFFF) > 0 then
     begin
       PrepareFilter(Filter);
       for I := 0 to Dest.Width * Dest.Height - 1 do
       begin
         DstPtr^ := GetFilteredColor(SrcPtr^);
         Inc(SrcPtr);
         Inc(DstPtr);
       end;
     end else
     begin
       for I := 0 to Dest.Width * Dest.Height - 1 do
       begin
         DstPtr^ := (SrcPtr^ and $FF000000);
         Inc(SrcPtr);
         Inc(DstPtr);
       end;
     end;
   finally
     EMMS;
     Dest.Changed;
   end;
end;
{$ENDREGION}
{$REGION ' LightenBitmap '}
procedure LightenBitmap(Src: TBitmap32;iLightenAmount: integer = 16);
var
a: integer;
cp: PColor32;
begin
//  CheckParams(Dest, Src);

    with Src do
    try
        cp := @Bits[0];
        for a := 0 to Height * Width - 1 do begin
            cp^ := Lighten(cp^, iLightenAmount);
            Inc(cp);
        end;
    finally
     EMMS;
     Src.Changed;
    end;
end;
{$ENDREGION}
{$REGION ' Mirror '}
procedure Mirror(Src, Dest: TBitmap32);
begin
  Src.FlipHorz(Dest);
end;
{$ENDREGION}
{$REGION ' Negative '}
procedure Negative(Src: TBitmap32);
begin
  Invert(Src, Src);
end;
{$ENDREGION}
{$REGION ' NegativeRGB '}
procedure NegativeRGB(Src: TBitmap32);
begin
  InvertRGB(Src,Src);
end;
{$ENDREGION}
{$REGION ' Sepia '}
procedure Sepia(Src: TBitmap32; SepiaIntensity: integer = 30);
var
  i:             integer;
  P:             PColor32Entry;
  RedIntensity:  integer;
begin
//  CheckParams(Dest, Src);

  RedIntensity := MulDiv(SepiaIntensity, 16, 9);

  P := @Src.Bits[0];

  for i := 0 to Src.Width * Src.Height - 1 do
   begin
    P.b := Intensity(P.ARGB);
    P.r := Clamp(P.b + RedIntensity);
    P.g := Clamp(P.b + SepiaIntensity);

    Inc(P);
   end;

  Src.Changed;
end;
{$ENDREGION}

end.
