{Source Name: SharpDeskApi
Copyright (C) Malx <Malx@sharpe-shell.org>
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


library SharpDeskApi;

uses
  Windows,
  Graphics,
  gr32,
  GR32_BLEND,
  GR32_Resamplers,
  Math,
  Classes,
  GR32_PNG in '..\..\3rd party\GR32 Addons\GR32_PNG.pas',
  SharpGraphicsUtils in '..\..\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpThemeApi in '..\SharpThemeApi\SharpThemeApi.pas';

{$R glyphs.res}
{$R *.res}

const
     DESK_SETTINGS = 'Settings\SharpDesk\SharpDesk.xml';
     THEME_SETTINGS = 'Settings\SharpDesk\Themes.xml';
     OBJECT_SETTINGS = 'Settings\SharpDesk\Objects.xml';
     PRESET_SETTINGS = 'Settings\SharpDesk\Presets.xml';

type

    TColorRec = packed record
                  b,g,r,a: Byte;
                end;
    TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
    PColorArray = ^TColorArray;
    TShadowType = (stLeft,stRight,stOutline);
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
    TDeskBackground = record
                        Background : TBitmap32;
                        Spacing    : integer;
                        Alpha      : integer;
                      end;
    TAlignInfo = record
                   IconLeft : integer;
                   IconTop  : integer;
                   CaptionLeft : integer;
                   CaptionTop  : integer;
                 end;

procedure CreateDropShadow(Bmp : TBitmap32; StartX, StartY, sAlpha, color :integer);
var
   P: PColor32;
   X,Y,alpha : integer;
   pass : Array of Array of integer;
begin
  sAlpha := 255 - SAlpha;
  with Bmp do
  begin
    setlength(pass,width,height);

    P := PixelPtr[0, 0];
    inc(P,(starty-1)*width+startx);
    for Y := starty to Height - 1 do
    begin
      for X := startx to Width- 1 do
      begin
        alpha := (P^ shr 24);
        if (alpha <> 0) then pass[X,Y] := sAlpha
            else if (X>1) and (Y>1) then
            begin
              pass[X,Y] := round((pass[X-1,Y] + pass[X,Y-1])/2) - 20;
              if pass[X,Y] > sAlpha-1 then pass[X,Y] := sAlpha;
              if pass[X,Y] < 0 then pass[X,Y] := 0;
              P^ := color32(GetRValue(Color),GetGValue(Color),GetBValue(Color),pass[X,Y]);
            end;
        inc(P); // proceed to the next pixel
      end;
      inc(P,startx);
    end;
  end;
end;                      


procedure releasebuffer(p : pChar);
begin
     FreeMem(p);
end;


procedure GetAlphaBMP(Bmp,Target : TBitmap32);
var
   P,P2: PColor32;
   X,Y,alpha : integer;
   pass : Array of Array of integer;
   tempBmp : TBitmap32;   
begin
  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(Bmp.Width,Bmp.Height);
  TempBmp.Clear(color32(255,255,255,255));
  with Bmp do
  begin
    setlength(pass,width,height);
    P2 := TempBmp.PixelPtr[0,0];
    P := PixelPtr[0, 0];
    inc(P,(1-1)*width+0);
    inc(P2,(1-1)*width+0);
    for Y := 1 to Height do
    begin
      for X := 0 to Width- 1 do
      begin
        alpha := (P^ shr 24);
        if alpha = 255 then P2^ := color32(0,0,0,0)
           else P2^ := color32(P^ shr 16,P^ shr 8,P^,alpha);
        inc(P);
        inc(P2);
      end;
      inc(P,0);
      inc(p2,0);
    end;
  end;
  Target.Assign(TempBmp);
  TempBmp.Free;
end;

procedure RemoveAlpha(Bmp : TBitmap32);
var
   P : PColor32;
   X,Y,alpha : integer;
begin
  with Bmp do
  begin
    P := PixelPtr[0, 0];
    inc(P,(1-1)*width+0);
    for Y := 1 to Height do
    begin
      for X := 0 to Width- 1 do
      begin
        alpha := (P^ shr 24);
        if (alpha<>255) and (alpha <>0) then
            P^ := color32(P^ shr 16,P^ shr 8,P^,0);
        inc(P); // proceed to the next pixel
      end;
      inc(P,0);
    end;
  end;
end;

procedure CreateIconShadow(bmp : TBitmap32; ShadowColor, ShadowValue : integer);
var
   TempBmp,OBmp : TBitmap32;
begin
  OBmp := TBitmap32.Create;
  TempBmp := TBitmap32.Create;
  try
    OBmp.Width := bmp.Width;
    OBmp.Height := bmp.Height;
    OBmp.Clear(color32(0,0,0,0));
    bmp.DrawMode := dmBlend;
    bmp.CombineMode := cmMerge;
    bmp.DrawTo(OBmp);
    bmp.Clear(color32(0,0,0,0));

    GetAlphaBMP(OBmp,TempBmp);
    RemoveAlpha(OBmp);

    CreateDropShadow(OBmp,0,1,ShadowValue,ShadowColor);

    OBmp.DrawTo(bmp,0,0);
    TempBmp.DrawMode := dmBlend;
    TempBmp.CombineMode := cmMerge;
    TempBmp.DrawTo(bmp,0,0);
  finally
    TempBmp.Free;
    OBmp.Free;           
  end;
end;

function GetTextSize(Bmp : TBitmap32; pSList : TStringList) : TPoint;
var
  n : integer;
  w,h : integer;
  nw,nh : integer;
begin
  w := 0;
  h := 0;
  for n := 0 to pSList.Count - 1 do
  begin
    nw := Bmp.TextWidth(pSList[n]);
    nh := Bmp.TextHeight(pSList[n]);
    if nw > w then w := nw;
    h := h + nh;
  end;
  result := Point(w,h);
end;

function RenderTextC(Bmp : TBitmap32; Font : TDeskFont;
                     Text    : TStringList; Align   : integer;
                     Spacing : integer) : boolean;
var
  c : TColor;
  R,G,B : byte;
  c2 : TColor32;
  ShadowBmp : TBitmap32;
  TempBmp : TBitmap32;
  w,h : integer;
  p : TPoint;
  eh : integer;
  n : integer;
begin
  TempBmp := TBitmap32.Create;
  try
    Bmp.Font.Name  := Font.Name;
    Bmp.Font.Color := Font.Color;
    Bmp.Font.Size  := Font.Size;
    Bmp.Font.Style := [];
    if Font.Bold then      Bmp.Font.Style := Bmp.Font.Style + [fsBold];
    if Font.Italic then    Bmp.Font.Style := Bmp.Font.Style + [fsItalic];
    if Font.Underline then Bmp.Font.Style := Bmp.Font.Style + [fsUnderline];
    p := GetTextSize(Bmp,Text);
    w := p.x;
    h := p.Y;
    eh := Bmp.TextHeight('SHARPE-WQGgYyqQ') + Spacing;
    TempBmp.SetSize(w+20,h+20);
    TempBmp.Font.Assign(Bmp.Font);
    TempBmp.Clear(color32(0,0,0,0));
    TempBmp.DrawMode := dmBlend;
    TempBmp.CombineMode := cmMerge;

    if Font.Shadow then
    begin
      ShadowBmp := TBitmap32.Create;
      try
        ShadowBmp.DrawMode := dmBlend;
        ShadowBmp.CombineMode := cmMerge;
        ShadowBmp.SetSize(TempBmp.Width,TempBmp.Height);
        ShadowBmp.Clear(color32(0,0,0,0));
        ShadowBmp.Font.Assign(Bmp.Font);
        c := Font.ShadowColor;
        R := GetRValue(c);
        G := GetGValue(c);
        B := GetBValue(c);
        c2 := color32(R,G,B,Font.ShadowAlphaValue);
        for n := 0 to Text.Count - 1 do
        begin
          case TShadowType(Font.ShadowType) of
            stLeft    :
              case Align of
                -1 : ShadowBmp.RenderText(10 - 1,
                                          TempBmp.Height div 2 - h div 2 + 1 + eh * n,Text[n],0,c2);
               1 : ShadowBmp.RenderText(TempBmp.Width - TempBmp.TextWidth(Text[n]) - 10 - 1,
                                         TempBmp.Height div 2 - h div 2 + 1 + eh * n,Text[n],0,c2);
                else ShadowBmp.RenderText(TempBmp.Width div 2 - TempBmp.TextWidth(Text[n]) div 2 - 1,
                                          TempBmp.Height div 2 - h div 2 + 1 + eh * n,Text[n],0,c2);
              end;
            stRight :
              case Align of
                -1 : ShadowBmp.RenderText(10 + 1,
                                          TempBmp.Height div 2 - h div 2 + 1 + eh * n,Text[n],0,c2);
                1 : ShadowBmp.RenderText(TempBmp.Width - TempBmp.TextWidth(Text[n]) - 10 + 1,
                                         TempBmp.Height div 2 - h div 2 + 1 + eh * n,Text[n],0,c2);
                else ShadowBmp.RenderText(TempBmp.Width div 2 - TempBmp.TextWidth(Text[n]) div 2 + 1,
                                          TempBmp.Height div 2 - h div 2 + 1 + eh * n,Text[n],0,c2);
              end;
            else
            begin
              case Align of
                -1 : ShadowBmp.RenderText(10 + 1,
                                          TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
                1 : ShadowBmp.RenderText(TempBmp.Width - TempBmp.TextWidth(Text[n]) - 10,
                                         TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
                else ShadowBmp.RenderText(TempBmp.Width div 2 - TempBmp.TextWidth(Text[n]) div 2 ,
                                          TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
              end;
              fastblur(ShadowBmp,1,1);
              case Align of
                -1 : ShadowBmp.RenderText(10 + 1,
                                          TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
                1 : ShadowBmp.RenderText(TempBmp.Width - TempBmp.TextWidth(Text[n]) - 10,
                                         TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
                else ShadowBmp.RenderText(TempBmp.Width div 2 - TempBmp.TextWidth(Text[n]) div 2 ,
                                          TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
              end;
            end;
          end;
        end;
        fastblur(ShadowBmp,1,1);
        ShadowBmp.DrawTo(TempBmp,0,0);
        ShadowBmp.DrawTo(TempBmp,0,0);
        fastblur(ShadowBmp,1,1);
        ShadowBmp.DrawTo(TempBmp,0,0);
        ShadowBmp.DrawTo(TempBmp,0,0);
        BlendImageA(TempBmp,Font.ShadowColor,255);
      finally
        ShadowBmp.Free;
      end;
    end;
    c := Font.Color;
    R := GetRValue(c);
    G := GetGValue(c);
    B := GetBValue(c);
    c2 := color32(R,G,B,255);
    for n := 0 to Text.Count - 1 do
    begin
      case Align of
       -1 : TempBmp.RenderText(10 ,
                               TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
        1 : TempBmp.RenderText(TempBmp.Width - TempBmp.TextWidth(Text[n]) - 10,
                               TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
        else TempBmp.RenderText(TempBmp.Width div 2 - TempBmp.TextWidth(Text[n]) div 2,
                                TempBmp.Height div 2 - h div 2 + eh * n,Text[n],0,c2);
      end;
    end;
    if Font.TextAlpha then
      TempBmp.MasterAlpha := Font.Alpha
    else TempBmp.MasterAlpha := 255;
    Bmp.Assign(TempBmp);
    result := True;
  except
    result := False;
  end;
  TempBmp.Free;
end;

function RenderTextB(dst     : TBitmap32;
                    Font    : TDeskFont;
                    Text    : String;
                    Align   : integer;
                    Spacing : integer) : boolean;
var
  SList : TStringList;
begin
  SList := TStringList.Create;
  SList.Clear;
  SList.Add(Text);
  result := RenderTextC(dst,Font,SList,Align,spacing);
  SList.Free;
end;

function RenderTextNA(dst     : TBitmap32;
                      Font    : TDeskFont;
                      Text    : TStringList;
                      Align   : integer;
                      Spacing : integer;
                      BGColor : integer) : boolean;
var
  bmp : TBitmap32;
begin
  bmp := TBitmap32.Create;
  bmp.Clear(color32(0,0,0,0));
  result := RenderTextC(bmp,Font,Text,Align,Spacing);
  bmp.DrawMode := dmBlend;
  bmp.CombineMode := cmMerge;
  dst.SetSize(Bmp.Width,Bmp.height);
  dst.Clear(color32(BGColor));
  bmp.DrawTo(dst);
  bmp.Free;
end;

function RenderIcon(dst  : TBitmap32;
                    Icon : TDeskIcon;
                    SizeMod : TPoint): boolean;
var
  w,h : integer;
  x1,y1,x2,y2 : integer;
begin
  if dst = nil then
  begin
    RenderIcon := False;
    exit;
  end;
  w := round(Icon.Icon.Width * (Icon.Size / 100));
  h := round(Icon.Icon.Height * (Icon.Size / 100));
  w := w + abs(Icon.Xoffset) + SizeMod.X;
  h := h + abs(Icon.Yoffset) + SizeMod.Y;
  if Icon.Shadow then dst.SetSize(w+6,h+6)
     else dst.SetSize(w,h);
  dst.Clear(color32(0,0,0,0));
  TDraftResampler.Create(dst);
  x1 := Icon.Xoffset;
  y1 := Icon.Yoffset;
  if x1<0 then
  begin
    x1 := 0;
    x2 := Icon.XOffset;
  end else x2 := 0;
  if y1<0 then
  begin
    y1 := 0;
    y2 := Icon.Yoffset;
  end else y2 := 0;
  dst.Draw(Rect(x1,y1,w+x2-SizeMod.X,h+y2-SizeMod.Y),
           Rect(0,0,Icon.Icon.Width,Icon.Icon.Height),
                Icon.Icon);
  if Icon.Blend then
     BlendImageA(dst,Icon.BlendColor,Icon.BlendValue);
  if Icon.Shadow then
     CreateIconShadow(dst,Icon.ShadowColor,Icon.ShadowAlpha);
  dst.MasterAlpha := Icon.Alpha;


  RenderIcon := True;
end;

function RenderIconCaptionAligned(dst : TBitmap32;
                                  Icon : TBitmap32;
                                  Caption : TBitmap32;
                                  CaptionAlign : TTextAlign;
                                  IconOffset : TPoint;
                                  CaptionOffset : TPoint;
                                  IconHasShadow : boolean;
                                  CaptionHasShadow : boolean) : TAlignInfo;
var
  smod : integer;
begin
  result.IconLeft := 0;
  result.IconTop  := 0;
  result.CaptionLeft := 0;
  result.CaptionTop  := 0;

  {if IconHasShadow then smod := -3
     else if CaptionHasShadow then smod := -2
          else} smod := 0;

  Caption.DrawMode := dmBlend;
  Caption.CombineMode := cmMerge;
  Icon.DrawMode := dmBlend;
  Icon.CombineMode := cmMerge;
  if (CaptionAlign = taCenter) then
  begin
    dst.SetSize(Max(Caption.Width,Icon.Width),Max(Caption.Height,Icon.Height));
    dst.Clear(color32(0,0,0,0));
    result.IconLeft := dst.Width div 2 - Icon.Width div 2;
    result.IconTop  := dst.Height div 2 - Icon.Height div 2;
    result.CaptionLeft := dst.Width div 2 - Caption.Width div 2 + smod;
    result.CaptionTop  := dst.Height div 2 - Caption.Height div 2+ smod - 5;
  end else
  if (CaptionAlign = taTop) or (CaptionAlign = taBottom) then
  begin
    dst.SetSize(Max(Caption.Width,Icon.Width)+8+abs(IconOffset.X)+CaptionOffset.X,Caption.Height+Icon.Height+CaptionOffset.Y+IconOffset.Y);
    dst.Clear(color32(0,0,0,0));
    if CaptionAlign = taTop then
    begin
      result.IconLeft := dst.Width div 2 - Icon.Width div 2 + IconOffset.X;
      result.IconTop  := dst.Height - Icon.Height + IconOffset.Y;
      result.CaptionLeft := dst.Width div 2 - Caption.Width div 2 + smod;
      result.CaptionTop  := 5;
    end else
    begin
      result.IconLeft := dst.Width div 2 - Icon.Width div 2 + IconOffset.X;
      result.IconTop  := 0 + IconOffset.Y;
      result.CaptionLeft := dst.Width div 2 - Caption.Width div 2 + smod;
      result.CaptionTop  := dst.Height - Caption.Height - 5;    
    end;
  end else
  begin
    dst.SetSize(Caption.Width+Icon.Width+CaptionOffset.X+IconOffset.X+8,Max(Caption.Height,Icon.Height)+CaptionOffset.Y+IconOffset.Y);
    dst.Clear(color32(0,0,0,0));
    if CaptionAlign = taLeft then
    begin
      result.IconLeft := dst.Width - Icon.Width;
      result.IconTop  := dst.Height div 2 - Icon.Height div 2;
      result.CaptionLeft := 5;
      result.CaptionTop  := dst.Height div 2 - Caption.Height div 2 + smod;
    end else
    begin
      IconOffset.X := - IconOffset.X;
      result.IconLeft := 0;
      result.IconTop  := dst.Height div 2 - Icon.Height div 2;
      result.CaptionLeft := dst.Width - Caption.Width + smod - 5;
      result.CaptionTop  := dst.Height div 2 - Caption.Height div 2 + smod;
    end;
  end;
  dst.Draw(result.IconLeft,result.IconTop,Icon);
  dst.Draw(result.CaptionLeft,result.CaptionTop ,Caption);
end;


function RenderObject(dst            : TBitmap32;
                      Icon           : TDeskIcon;
                      Font           : TDeskFont;
                      Caption        : TDeskCaption;
                      SizeMod        : TPoint;
                      OffsetMod      : TPoint) : boolean;
var
  FontBitmap : TBitmap32;
  IconBitmap : TBitmap32;
  n : integer;
begin
  if dst = nil then
  begin
    RenderObject := False;
    exit;
  end;

  IconBitmap := TBitmap32.Create;
  IconBitmap.DrawMode := dmBlend;
  IconBitmap.CombineMode := cmMerge;
  RenderIcon(IconBitmap,Icon,point(0,0));

  if (Caption.Draw) and (Caption.Caption <> nil) then
  begin
    FontBitmap := TBitmap32.Create;
    FontBitmap.DrawMode := dmBlend;
    FontBitmap.CombineMode := cmMerge;
    case Caption.Align of
      taTop,taBottom: n := 0;
      taLeft: n := 1;
      taRight: n:= -1;
      else n := 0;
    end;
    if not RenderTextC(FontBitmap,Font,Caption.Caption,n,Caption.LineSpace) then
    begin
      FontBitmap.SetSize(64,64);
      FontBitmap.Clear(color32(0,0,0,0));
    end;

    RenderIconCaptionAligned(dst,
                             IconBitmap,
                             FontBitmap,
                             Caption.Align,
                             Point(Icon.Xoffset,Icon.Yoffset),
                             Point(Caption.Xoffset,Caption.Yoffset),
                             Icon.Shadow,
                             Font.Shadow);
    FontBitmap.Free;
  end
  else
  begin
    dst.SetSize(IconBitmap.Width,IconBitmap.Height);
    dst.Clear(color32(0,0,0,0));
    dst.Draw(0,0,IconBitmap);
  end;

  RenderObject := True;
  IconBitmap.Free;
end;


exports
 CreateDropShadow,
 releasebuffer,
 RenderTextC,
 RenderTextB,
 RenderTextNA,
 RenderObject,
 RenderIcon,
 RenderIconCaptionAligned,
 LoadIcon;

begin
end.
