{
Source Name: uSharpDeskMainForm.pas
Description: Main window for displaying and controling all desktop objects
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

uses GR32, Math;

type
  THSLColor = record
   Hue,
   Saturation,
   Lightness : Integer;
  end;

  procedure HSLChangeImage(bmp : Tbitmap32; HMod,SMod,LMod : integer);
  function HSLtoRGB(H,S,L : integer): TColor32;
  function RGBtoHSL(RGB: TColor32) : THslColor;

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
  H,S,L : byte;
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

end.
