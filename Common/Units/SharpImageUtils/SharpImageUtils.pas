{
Source Name: SharpImageUtils.pas
Description: Image loading related help Functions
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

unit SharpImageUtils;

interface

uses
  GR32,GR32_PNG,GR32_Resamplers,JPeg,SharpIconUtils,SysUtils,Classes,GifImg,
  Graphics;

function LoadImage(Image : String; Bmp : TBitmap32) : Boolean; overload;
function LoadImage(Image : TStream; Ext : String; Bmp : TBitmap32) : Boolean; overload;
procedure RescaleImage(Src,Dst : TBitmap32; Width,Height : integer; Resample : boolean);
procedure ScaleImage(Src,Dst : TBitmap32; Factor : real; Resample : boolean);

implementation

procedure LoadGifFromStream(Image : TStream; Bmp : TBitmap32; Background : TColor32);
var
  Gif : TGifImage;
  P : PColor32;
  I : integer;
begin
  if (Image = nil) or (Bmp = nil) then
    exit;

  Gif := TGifImage.Create;
  try
    Gif.LoadFromStream(Image);
    Bmp.SetSize(Gif.Width,Gif.Height);
    Bmp.Clear(Background);
    Bmp.Assign(Gif);
    P := @Bmp.Bits[0];
    for I := 0 to Bmp.Width * Bmp.Height - 1 do
    begin
      if P^ = color32(Gif.BackgroundColor) then
        P^ := Background;
      Inc(P);
    end;
  except
    Bmp.SetSize(16,16);
    Bmp.Clear(color32(0,0,0,0));
  end;
  Gif.Free;
end;

function LoadImage(Image : TStream; Ext : String; Bmp : TBitmap32) : Boolean;
var
  b : boolean;
  Jpeg : TJpegImage;
begin
  result := False;
  if (Image <> nil) then
    if (Image.Size > 0) then
    begin
      if CompareText(Ext,'.bmp') = 0 then
      begin
        Bmp.LoadFromStream(Image);
        result := True;
      end else
      if (CompareText(Ext,'.jpg') = 0) or (CompareText(Ext,'.jpeg') = 0) then
      begin
        Jpeg := TJpegImage.Create;
        Jpeg.LoadFromStream(Image);
        Bmp.Assign(Jpeg);
        Jpeg.Free;
        result := True;
      end else
      if (CompareText(Ext,'.png') = 0) then
      begin
        GR32_PNG.LoadBitmap32FromPNG(Bmp,Image,b);
        result := True;
      end else
      if (CompareText(Ext,'.gif') = 0) then
      begin
        LoadGifFromStream(Image,Bmp,Color32(255,255,255,255));
        result := True;
      end;
    end;
end;

function LoadImage(Image : String; Bmp : TBitmap32) : Boolean;
var
  b : boolean;
  Ext : String;
begin
  Result := False;

  if FileExists(Image) then
  begin
    Ext := ExtractFileExt(Image);
    if CompareText(Ext,'.bmp') = 0 then
    begin
      Bmp.LoadFromFile(Image);
      result := True;
    end else
    if (CompareText(Ext,'.jpg') = 0) or (CompareText(Ext,'.jpeg') = 0) then
    begin
      Bmp.LoadFromFile(Image);
      result := True;
    end else
    if (CompareText(Ext,'.png') = 0) then
    begin
      GR32_PNG.LoadBitmap32FromPNG(Bmp,Image,b);
      result := True;
    end else
    if (CompareText(Ext,'.gif') = 0) then
    begin
      Bmp.LoadFromFile(Image);
      result := True;
    end;
  end;
    
  if not Result then
    result := SharpIconUtils.IconStringToIcon(Image,Image,Bmp);
end;

procedure RescaleImage(Src,Dst : TBitmap32; Width,Height : integer; Resample : boolean);
var
  R : TRect;
begin
  if Src = nil then
    exit;
  if Dst = nil then
    Dst := TBitmap32.Create;
  Dst.SetSize(Width,Height);
  Dst.Clear(color32(0,0,0,0));

  if (Src.Width/Src.Height) = (Width/Height) then
   begin
     R.Left   := 0;
     R.Top    := 0;
     R.Right  := Width;
     R.Bottom := Height;
   end
   else if (Src.Width/Src.Height) > (Width/Height) then
   begin
     R.Left   := 0;
     R.Top    := round((Height div 2 - ((Width/Src.Width)*Src.Height) / 2));
     R.Right  := Width;
     R.bottom := round((Height div 2 + ((Width/Src.Width)*Src.Height) / 2));
   end else
   begin
     R.Left   := round((Width div 2 - ((Height/Src.Height)*Src.Width) / 2));
     R.Top    := 0;
     R.Right  := round((Width div 2 + ((Height/Src.Height)*Src.Width) / 2));
     R.bottom := Height;
   end;

   if Resample then
     TLinearResampler.Create(Src);
   Src.DrawTo(Dst,R);
end;

procedure ScaleImage(Src,Dst : TBitmap32; Factor : real; Resample : boolean);
var
  Temp : TBitmap32;
begin
  Temp := TBitmap32.Create;
  Temp.SetSize(round(Src.Width * Factor), round(Src.Height * Factor));
  if Resample then
    TLinearResampler.Create(Src);
  Src.DrawTo(Temp,Rect(0,0,Temp.Width,Temp.Height));
  Dst.Assign(Temp);
  Temp.Free;
end;

end.
