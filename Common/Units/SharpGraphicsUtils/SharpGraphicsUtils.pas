{
Source Name: SharpGraphicsUtils.pas
Description: Graphics32 related help Functions
Copyright (C) Malx <>
              Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpGraphicsUtils;

interface

uses Windows, Graphics, GR32, GR32_Blend, Math, uThemeConsts;

type
  THSLColor = record
   Hue,
   Saturation,
   Lightness : Integer;
  end;

  procedure FastBlur(aBitmap32: TBitmap32; aRadius: Integer; aPasses: Integer = 2);
  procedure LightenBitmap(Bmp : TBitmap32; Amount :integer); overload;
  procedure LightenBitmap(Bmp, Src : TBitmap32; Left,Top : integer); overload;
  procedure LightenBitmap(Bmp : TBitmap32; Amount :integer; Rect : TRect); overload;

  procedure ReplaceColor32(bmp : Tbitmap32; Source, New : TColor32);
  procedure ReplaceTransparentAreas(Dst,AlphaSource : TBitmap32; ReplaceColor : TColor32);

  procedure HSLChangeImage(bmp : Tbitmap32; HMod,SMod,LMod : integer);
  function ChangeBrightnessHSL32(Src : TColor32; Amount : integer) : TColor32;  

  procedure VGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
  procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
  procedure ApplyGradient(Bmp : TBitmap32; gtype : TThemeWallpaperGradientType;
                          GDStartColor, GDEndColor, GDStartAlpha, GDEndAlpha : integer);

  procedure BlendImageA(bmp : Tbitmap32; color : TColor; blendalpha : integer);
  procedure BlendImageC(bmp : Tbitmap32; color : TColor; alpha:integer);
  function ColorToColor32Alpha(Color : TColor; Alpha : integer) : TColor32;
  function LightenColor32(Color : TColor32; Amount : integer) : TColor32;

  function GetColorAverage(Src : TBitmap32) : integer;  

implementation


function GetColorAverage(Src : TBitmap32) : integer;
var
  PSrc : PColor32;
  MaxValue : double;
  RSum,GSum,BSum : double;
  AlphaFactor : double;
  R,G,B,A : byte;
  X,Y : integer;
begin
  RSum := 0;
  GSum := 0;
  BSum := 0;
  PSrc := Src.PixelPtr[0, 0];

  for Y := 0 to Src.Height - 1 do
  begin
    for X := 0 to Src.Width - 1 do
    begin
      Color32ToRGBA(PSrc^,R,G,B,A);
      AlphaFactor := A / 255;
      RSum := RSum + R * AlphaFactor;
      GSum := GSum + G * AlphaFactor;
      BSum := BSum + B * AlphaFactor;
      inc(PSrc);
    end;
  end;

  MaxValue := Max(BSum,Max(RSum, GSum));
  if MaxValue > 0 then
  begin
    RSum := RSum / MaxValue * 255;
    GSum := GSum / MaxValue * 255;
    BSum := BSum / MaxValue * 255;

    result := RGB(round(RSum),round(GSum),round(BSum));
  end else result := 0;
end;

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

procedure VGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
var
   nR,nG,nB,nt : real;
   sR,sG,sB : integer;
   eR,eG,eB : integer;
   y : integer;
begin
  sR := GetRValue(color1);
  sG := GetGValue(color1);
  sB := GetBValue(color1);
  eR := GetRValue(color2);
  eG := GetGValue(color2);
  eB := GetBValue(color2);
  nR:=(eR-sR)/(Rect.Bottom-Rect.Top);
  nG:=(eG-sG)/(Rect.Bottom-Rect.Top);
  nB:=(eB-sB)/(Rect.Bottom-Rect.Top);
  nt:=(et-st)/(Rect.Bottom-Rect.Top);
  for y:=0 to Rect.Bottom-Rect.Top do
      Bmp.HorzLineT(Rect.Left,y+Rect.Top,Rect.Right,
                    color32(sr+round(nr*y),sg+round(ng*y),sb+round(nb*y),st+round(nt*y)));
end;


// ######################################


procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; st,et : byte; Rect : TRect);
var
   nR,nG,nB,nt : real;
   sR,sG,sB : integer;
   eR,eG,eB : integer;
   x : integer;
begin
  sR := GetRValue(color1);
  sG := GetGValue(color1);
  sB := GetBValue(color1);
  eR := GetRValue(color2);
  eG := GetGValue(color2);
  eB := GetBValue(color2);
  nR:=(eR-sR)/(Rect.Right-Rect.Left);
  nG:=(eG-sG)/(Rect.Right-Rect.Left);
  nB:=(eB-sB)/(Rect.Right-Rect.Left);
  nt:=(et-st)/(Rect.Right-Rect.Left);
  for x:=0 to Rect.Right-Rect.Left do
      Bmp.VertLineT(x+Rect.Left,Rect.Top,Rect.Bottom,
                    color32(sr+round(nr*x),sg+round(ng*x),sb+round(nb*x),st+round(nt*x)));
end;

procedure ApplyGradient(Bmp : TBitmap32; gtype : TThemeWallpaperGradientType;
                        GDStartColor, GDEndColor, GDStartAlpha, GDEndAlpha : integer);
var
  R,R2 : TRect;
begin
  R := Bmp.Canvas.ClipRect;
  R.Right := R.Right - 1;
  R.Bottom := R.Bottom - 1;
  case gtype of
    twgtHoriz: HGradient(Bmp,GDStartColor,GDEndColor,255-GDStartAlpha,255-GDEndAlpha,R);
    twgtVert: VGradient(Bmp,GDStartColor,GDEndColor,255-GDStartAlpha,255-GDEndAlpha,R);
    twgtTSHoriz:
    begin
      R2 := R;
      R2.Right := R2.Right div 2;
      HGradient(Bmp,GDStartColor,GDEndColor,255-GDStartAlpha,255-GDEndAlpha,R2);
      R2 := R;
      R2.Left := R2.Right div 2 + 1;
      HGradient(Bmp,GDEndColor,GDStartColor,255-GDEndAlpha,255-GDStartAlpha,R2);
    end;
    twgtTSVert:
    begin
      R2 := R;
      R2.Bottom := R2.Bottom div 2;
      VGradient(Bmp,GDStartColor,GDEndColor,255-GDStartAlpha,255-GDEndAlpha,R2);
      R2 := R;
      R2.Top := R2.Bottom div 2 + 1;
      VGradient(Bmp,GDEndColor,GDStartColor,255-GDEndAlpha,255-GDStartAlpha,R2);
    end;
  end;
end;

procedure LightenBitmap(Bmp, Src : TBitmap32; Left,Top : integer);
var
  P: PColor32;
  PSrc : PColor32;
  h,s,l : byte;
  X,Y : integer;
begin
  PSrc := Src.PixelPtr[0, 0];
  P := Bmp.PixelPtr[0, 0];
  inc(P,(Top)*Bmp.Width+Left);
  for Y := 0 to Src.Height - 1 do
  begin
    for X := 0 to Src.Width - 1 do
    begin
      RGBtoHSL(PSrc^,h,s,l);
      P^ := lighten(P^,l-128);
      inc(P);
      inc(PSrc);
    end;
    inc(P,(Bmp.Width-Src.Width));
  end
end;

procedure lightenBitmap(bmp : Tbitmap32; amount :integer);
var
  P: PColor32;
  I : integer;
begin
  with bmp do
  begin
    P := PixelPtr[0, 0];
    for I := 0 to Width * Height - 1 do
    begin
      P^ := lighten(P^,amount);
      Inc(P); // proceed to the next pixel
    end;
  end;
end;

procedure LightenBitmap(Bmp : TBitmap32; Amount :integer; Rect : TRect);
var
  P: PColor32;
  X,Y : integer;
begin
  with Bmp do
  begin
    P := PixelPtr[0, 0];
    inc(P,(Rect.Top-1)*width+Rect.Left);
    for Y := Rect.Top to Rect.Bottom - 1 do
    begin
      for X := Rect.Left to Rect.Right- 1 do
      begin
        P^ := lighten(P^,amount);
        inc(P);
      end;
      inc(P,Rect.Left+(width-Rect.Right));
    end;
  end
end;

procedure ReplaceTransparentAreas(Dst,AlphaSource : TBitmap32; ReplaceColor : TColor32);
var
  P,D     : PColor32;
  i       : integer;
  R,G,B,A : byte;
begin
  if (Dst.Width <> AlphaSource.Width) or (Dst.Height <> AlphaSource.Height) then
     exit;

  with AlphaSource do
  try
    P := PixelPtr[0, 0];
    D := Dst.PixelPtr[0, 0];
    for I := 0 to Width * Height - 1 do
    begin
      Color32ToRGBA(D^,R,G,B,A);
      if P^ shr 24 <= 32 then
         D^ := ReplaceColor;
      Inc(P);
      Inc(D);
    end;
  finally
  end;
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

function ChangeBrightnessHSL32(Src : TColor32; Amount : integer) : TColor32;
var
  h,s,l : byte;
begin
  RGBToHSL(Src,h,s,l);
  l := l + Amount;
  l := Min(Max(l,0),255);
  result := HSLToRGB(h,s,l);
end;

procedure HSLChangeImage(bmp : Tbitmap32; HMod,SMod,LMod : integer);
var
  P          : PColor32;
  i          : integer;
  alpha      : byte;
  new_hsl    : THslColor;
  new_rgb    : TColor32;
  h,s,l      : byte; 
begin
  with bmp do
  try
    P := PixelPtr[0, 0];
    for I := 0 to Width * Height - 1 do
    begin
      alpha := (P^ shr 24);
      if alpha > 0 then
      begin
        RGBToHSL(P^,h,s,l);
        new_hsl.Hue := h + HMod;
        new_hsl.Saturation := s + SMod;
        new_hsl.Lightness := l + LMod;

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

  h,s,l : byte;
begin
  RGBToHSL(RGB((color and $00FF0000) shr 16,
               (color and $0000FF00) shr 8,
                color and $000000FF),
                h,s,l);
  source_hsl.Hue := h;
  source_hsl.Lightness := l;
  source_hsl.Saturation := s;

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
           RGBToHSL(RGB((P^ and $00FF0000) shr 16,
                        (P^ and $0000FF00) shr 8,
                         P^ and $000000FF),
                         h,s,l);
           hsl[i].Hue := h;
           hsl[i].Lightness := l;
           hsl[i].Saturation := s;
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

function LightenColor32(Color : TColor32; Amount : integer) : TColor32;
var
  R,G,B,A : integer;
begin
  A := Color shr 24;
  R := (Color and $00FF0000) shr 16;
  G := (Color and $0000FF00) shr 8;
  B := Color and $000000FF;
  
  R := R + Amount;
  G := G + Amount;
  B := B + Amount;
  A := A + Amount;

  if R > 255 then
    R := 255
  else
  if R < 0 then
    R := 0;

  if G > 255 then
    G := 255
  else
  if G < 0 then
    G := 0;

  if B > 255 then
    B := 255
  else
  if B < 0 then
    B := 0;

  if A > 255 then
    A := 255
  else
  if A < 0 then
    A := 0;

  result := Color32(R,G,B,A);
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

// source: Graphics32 Newsgroup
procedure FastBlur(aBitmap32: TBitmap32; aRadius: Integer; aPasses: Integer = 2);
// Quick box blur algoritm

// aPasses:
// 1: Blur quality too low
// 2: Best speed / quality compromise
// 3: Good quality but impossible to have a small blur radius. Even radius 1 gives a large blur.

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
  if aRadius <= 0 then
  begin
   Exit;
  end;

  lBoxSize := (aRadius * 2) + 1;

  lWidth1  := aBitmap32.Width  - 1;
  lHeight1 := aBitmap32.Height - 1;

  // Process horizontally
  SetLength(lSumArray, aBitmap32.Width + 2 * aRadius + 1);

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

        lColor32 := PColor32(aBitmap32.PixelPtr[xBitmap, yBitmap])^;

        lSumArray[x].A := lSumArray[x - 1].A + lColor32 shr 24;
        lSumArray[x].R := lSumArray[x - 1].R + lColor32 shr 16 and $FF;
        lSumArray[x].G := lSumArray[x - 1].G + lColor32 shr 8  and $FF;
        lSumArray[x].B := lSumArray[x - 1].B + lColor32        and $FF;
      end;

      for xBitmap := 0 to lWidth1 do
      begin
        x := xBitmap + aRadius + 1;

        PColor32(aBitmap32.PixelPtr[xBitmap, yBitmap])^ :=
          ((lSumArray[x + aRadius].A - lSumArray[x - aRadius - 1].A) div lBoxSize) shl 24 or
          ((lSumArray[x + aRadius].R - lSumArray[x - aRadius - 1].R) div lBoxSize) shl 16 or
          ((lSumArray[x + aRadius].G - lSumArray[x - aRadius - 1].G) div lBoxSize) shl 8 or
           (lSumArray[x + aRadius].B - lSumArray[x - aRadius - 1].B) div lBoxSize;
      end;
    end;
  end;

  // Process vertically
  SetLength(lSumArray, aBitmap32.Height + 2 * aRadius + 1);

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

        lColor32 := PColor32(aBitmap32.PixelPtr[xBitmap, yBitmap])^;

        lSumArray[y].A := lSumArray[y - 1].A + lColor32 shr 24;
        lSumArray[y].R := lSumArray[y - 1].R + lColor32 shr 16 and $FF;
        lSumArray[y].G := lSumArray[y - 1].G + lColor32 shr 8  and $FF;
        lSumArray[y].B := lSumArray[y - 1].B + lColor32        and $FF;
      end;

      for yBitmap := 0 to lHeight1 do
      begin
        y := yBitmap + aRadius + 1;

        PColor32(aBitmap32.PixelPtr[xBitmap, yBitmap])^ :=
          ((lSumArray[y + aRadius].A - lSumArray[y - aRadius - 1].A) div lBoxSize) shl 24 or
          ((lSumArray[y + aRadius].R - lSumArray[y - aRadius - 1].R) div lBoxSize) shl 16 or
          ((lSumArray[y + aRadius].G - lSumArray[y - aRadius - 1].G) div lBoxSize) shl 8  or
           (lSumArray[y + aRadius].B - lSumArray[y - aRadius - 1].B) div lBoxSize;
      end;
    end;
  end;
end;


end.
