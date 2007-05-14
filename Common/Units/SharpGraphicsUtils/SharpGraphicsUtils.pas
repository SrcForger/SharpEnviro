{
Source Name: SharpGraphicsUtils.pas
Description: Graphics32 related help Functions
Copyright (C) Malx <>
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit SharpGraphicsUtils;

interface

uses Windows, Graphics, GR32, Math;

type
  THSLColor = record
   Hue,
   Saturation,
   Lightness : Integer;
  end;

  procedure ReplaceColor32(bmp : Tbitmap32; Source, New : TColor32);

  procedure HSLChangeImage(bmp : Tbitmap32; HMod,SMod,LMod : integer);
  function HSLtoRGB(H,S,L : integer): TColor32;
  function RGBtoHSL(RGB: TColor32) : THslColor;

  procedure BlendImageA(bmp : Tbitmap32; color : TColor; blendalpha : integer);
  procedure BlendImageC(bmp : Tbitmap32; color : TColor; alpha:integer);
  function ColorToColor32Alpha(Color : TColor; Alpha : integer) : TColor32;

implementation


function Max2(const A, B, C: Integer): Integer;
asm
      CMP       EDX,EAX
      CMOVG     EAX,EDX
      CMP       ECX,EAX
      CMOVG     EAX,ECX
end;

function Min2(const A, B, C: Integer): Integer;
asm
      CMP       EDX,EAX
      CMOVL     EAX,EDX
      CMP       ECX,EAX
      CMOVL     EAX,ECX
end;

procedure ReplaceColor32(bmp : Tbitmap32; Source, New : TColor32);
var
  P       : PColor32;
  i       : integer;
begin
  with bmp do
  try
    P := PixelPtr[0, 0];
    for I := 0 to Width * Height - 1 do
    begin
      if P^ = Source then
         P^ := New;
      Inc(P);
    end;
  finally
  end;
end;

function HSLtoRGB(H,S,L : integer): TColor32;
var
  V, M, M1, M2, VSF: Integer;
begin
  Result := Color32(0,0,0,0);
  if L <= $7F then
    V := L * (256 + S) shr 8
  else
    V := L + S - L * S div 255;
  if V > 0 then begin
    M := L * 2 - V;
    H := H * 6;
    VSF := (V - M) * (H and $ff) shr 8;
    M1 := M + VSF;
    M2 := V - VSF;
    case H shr 8 of
      0: Result := Color32(V, M1, M, 0);
      1: Result := Color32(M2, V, M, 0);
      2: Result := Color32(M, V, M1, 0);
      3: Result := Color32(M, M2, V, 0);
      4: Result := Color32(M1, M, V, 0);
      5: Result := Color32(V, M, M2, 0);
    end;
  end;
end;

function RGBtoHSL(RGB: TColor32) : THslColor;
var
  R, G, B, D, Cmax, Cmin, HL: Integer;
  H,S,L : integer;
begin
  R := (RGB shr 16) and $ff;
  G := (RGB shr 8) and $ff;
  B := RGB and $ff;
  Cmax := Max2(R, G, B);
  Cmin := Min2(R, G, B);
  L := (Cmax + Cmin) div 2;

  if Cmax = Cmin then
  begin
    H := 0;
    S := 0
  end
  else
  begin
    D := (Cmax - Cmin) * 255;
    if L <= $7F then
      S := D div (Cmax + Cmin)
    else
      S := D div (255 * 2 - Cmax - Cmin);

    D := D * 6;
    if R = Cmax then
      HL := (G - B) * 255 * 255 div D
    else if G = Cmax then
      HL := 255 * 2 div 6 + (B - R) * 255 * 255 div D
    else
      HL := 255 * 4 div 6 + (R - G) * 255 * 255 div D;

    if HL < 0 then HL := HL + 255 * 2;
    H := HL;
  end;
  with result do begin
    hue := h;
    saturation := s;
    Lightness := l;
  end;
end;

procedure HSLChangeImage(bmp : Tbitmap32; HMod,SMod,LMod : integer);
var
  P          : PColor32;
  i          : integer;
  alpha      : byte;
  new_hsl    : THslColor;
  hsl        : THSLColor;

  new_rgb    : TColor32;
begin
  with bmp do
  try
    P := PixelPtr[0, 0];
    for I := 0 to Width * Height - 1 do
    begin
      alpha := (P^ shr 24);
      if alpha > 0 then
      begin
        hsl := RGBToHSL(P^);
        new_hsl.Hue := hsl.Hue + HMod;
        new_hsl.Saturation := hsl.Saturation + SMod;
        new_hsl.Lightness := hsl.Lightness + LMod;

        new_hsl.Hue := Min(Max(new_hsl.Hue,0),255);
        new_hsl.Saturation := Min(Max(new_hsl.Saturation,0),255);
        new_hsl.Lightness := Min(Max(new_hsl.Lightness,0),255);

        new_rgb := HSLToRGB(new_hsl.Hue,new_hsl.Saturation,new_hsl.Lightness);
        new_rgb := (new_rgb and $00FFFFFF) + ((byte(alpha) and $FF) shl 24);
        P^ := new_rgb;
      end;
      Inc(P);
    end;
  finally
  end;
end;

procedure BlendImageA(bmp : Tbitmap32; color : TColor; blendalpha : integer);
var
  P          : PColor32;
  i          : integer;
  alpha      : byte;
  source_hsl : THslColor;
  new_hsl    : THslColor;
  hsl        : Array of THSLColor;

  diff       : integer;
  lighten    : integer;
  new_rgb    : TColor32;

  weighted_sum : Int64;
  total_weight : LongInt;
  power_hue    : Integer;

  sum_b        : LongInt;
  nr_b         : LongInt;
  average_b    : Integer;

  tempbmp     : TBitmap32;
begin
  source_hsl := RGBToHSL(color32(color));

  if (blendalpha < 1) then exit;

  with bmp do begin
      tempbmp := TBitmap32.create;
      if (blendalpha < 255) then begin //Create an image to blend to if needed
        tempbmp.Assign(bmp);
        tempbmp.MasterAlpha := 255-blendalpha;
        tempbmp.DrawMode := dmBlend;
      end;

    try

      //* First translate all nontransparent pixels to HSL
      //* The reason we go throw the picture in two step is
      //* because we want to analyse in which Hue the "power"
      //* of the picture lies.
      SetLength(hsl,Width*Height);
      weighted_sum := 0;
      total_weight := 0;
      sum_b := 0;
      nr_b := 0;
      P := PixelPtr[0, 0];
      for I := 0 to Width * Height - 1 do begin
         alpha := (P^ shr 24);
         if alpha <> 0 then begin
           hsl[i] := RGBToHSL(P^);
           inc(weighted_sum,hsl[i].hue*hsl[i].saturation);
           inc(total_weight,hsl[i].saturation);
           inc(sum_b, hsl[i].Lightness);
           inc(nr_b);
        end;
        Inc(P);
      end;
      if total_weight <> 0 then
        power_hue := round(weighted_sum/total_weight)
      else
       power_hue := 0;

      if nr_b <> 0 then
        average_b := round(sum_b/nr_b)
      else
        average_b := 0;

      lighten :=round((average_b - source_hsl.Lightness)/2);
      //* Time to go throw the picture again and actually write
      //* the new data to the picture. I try to explain step for step,
      //* it is here the magic begins....

      // All new pixel will use the hue of the blending color
      new_hsl.Hue := source_hsl.Hue;

      P := PixelPtr[0, 0];
      for I := 0 to Width * Height - 1 do begin
        alpha := (P^ shr 24);
        if alpha > 0 then begin //Only nontransparent pixels...

          // To avoid that same S and B but different Hue would result in the
          // same color (clBlue and clRed for an example), we need to adjust
          // the brightness according to the difference in hue.
          // This could result in big parts of a picture being very bright or
          // dark because its hue. Therefore we try to minimize this problem by
          // letting the power_hue being unchanged.
          diff := hsl[i].Hue-power_hue;
          if diff > 128 then dec(diff,255);
          if diff < -128 then inc(diff,255);
          diff := (64-abs(abs(diff)-64))*sign(diff);

          //Avoid lighten/darken grey pixels
          diff := round(diff*hsl[i].Saturation/256);

          //Add avarage lighten/darken
          diff := diff - lighten;

          // This is not enough, those actions could really mess things up if
          // we for an example trying to light already very bright parts
          // resulting in big white areas. (Or black in the other direction)
          // Therefore we want this effect to wear of when we already are bright
          // or dark.
          if diff > 0 then begin
             if hsl[i].Lightness > 128 then begin
                diff := round(diff*(128-(hsl[i].Lightness-127))/128);
             end;
          end
          else if diff < 0 then begin
             if hsl[i].Lightness < 128 then begin
                diff := round(diff*hsl[i].Lightness/128);
             end;
          end;


          new_hsl.Lightness := hsl[i].Lightness + diff;
          if new_hsl.Lightness > 255 then new_hsl.Lightness := 255;
          if new_hsl.Lightness < 0 then new_hsl.Lightness := 0;

          // But we cant let the new pixel have a higher saturation then the
          // blending color, that could result in colors when blending to grey.
          new_hsl.Saturation := min(hsl[i].saturation,source_hsl.saturation);
          new_rgb := HSLToRGB(new_hsl.Hue,new_hsl.Saturation,new_hsl.Lightness);
          //if wincolor(new_rgb) = wincolor(color32(172,75,53)) then begin
          //  bmp.canvas.TextOut(0,0,inttostr(new_hsl.Hue))
          //end;
          new_rgb := (new_rgb and $00FFFFFF) + ((byte(alpha) and $FF) shl 24);
          P^ := new_rgb;
        end;
        Inc(P);
      end;
     finally
      //bmp.canvas.TextOut(0,0,inttostr(power_hue));
      //bmp.canvas.TextOut(0,12,inttostr(lighten));
       if (blendalpha < 255) then begin
         tempbmp.DrawTo(bmp);
       end;
       tempbmp.Free;
    end;
  end;
end;


procedure BlendImageC(bmp : Tbitmap32; color : TColor; alpha:integer);
var
  P            : PColor32;
  I            : integer;
   sum1,sum2   : real;
   CB,CR,CG    : Integer;
   oCB,oCR,oCG : Integer;
   nCB,nCR,nCG : Integer;
   tempAlpha   : integer;
   change      : Integer;
begin
  alpha := min(alpha,255);
  alpha := max(alpha,0);
  CR := GetRValue(colortorgb(color));
  CG := GetGValue(colortorgb(color));
  CB := GetBValue(colortorgb(color));
  sum1 := (CB+CR+CG)/3;
  with bmp do begin
    try
      P := PixelPtr[0, 0];
      for I := 0 to Width * Height - 1 do
      begin
        tempAlpha := (P^ shr 24);
        if tempAlpha <> 0 then begin
          oCR    := (P^ and $00FF0000)shr 16;
          oCG    := (P^ and $0000FF00)shr 8;
          oCB    :=  P^ and $0000FF;
          sum2   := (oCB+oCR+oCG)/3;
          change := round(sum2-sum1);
          nCR    := CR + change;
          nCG    := CG + change;
          nCB    := CB + change;
          nCR    := round((alpha/255)*nCR+((255-alpha)/255)*oCR);
          nCG    := round((alpha/255)*nCG+((255-alpha)/255)*oCG);
          nCB    := round((alpha/255)*nCB+((255-alpha)/255)*oCB);
          if nCB > 255 then nCB := 255
          else if nCB < 0 then nCB := 0;
          if nCR > 255 then nCR := 255
          else if nCR < 0 then nCR := 0;
          if nCG > 255 then nCG := 255
          else if nCG < 0 then nCG := 0;
          P^ := color32(nCR,nCG,nCB,tempAlpha);
        end;
        Inc(P); // proceed to the next pixel
      end;
    finally
    end;
  end;
end;

function ColorToColor32Alpha(Color : TColor; Alpha : integer) : TColor32;
var
 R,G,B,A : byte;
begin
  R := GetRValue(Color);
  G := GetGValue(Color);
  B := GetBValue(Color);
  A := Alpha;
  if Alpha > 255 then A := 255
     else if Alpha < 0 then A := 0;
  result := Color32(R,G,B,A);
end;

end.
