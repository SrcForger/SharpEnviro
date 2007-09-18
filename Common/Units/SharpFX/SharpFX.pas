{
Source Name: SharpFX
Description: Fast graphical methods
Copyright (C) Malx (Malx@techie.com)

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

unit SharpFX;

interface
uses
   Windows, Graphics,classes;

type pBitmap = ^Tbitmap;
     pLongInt = ^Longint;
     TAngle = 0..359;

var
  SinTable1,
  CosTable1,
  SinTable2,
  CosTable2       : Array[0..High(TAngle)] of integer;

procedure AlphaBlend(pBmap : pBitmap;color : Tcolor;alpha : Byte); overload;
procedure AlphaBlend(pBmap: pBitmap;pBmap2: pBitmap;alpha: Byte);overload;
procedure ChangeColor(pBmap : pBitmap;Color1a,Color1b,color2a,color2b,color3a,color3b:Tcolor);
procedure CreateDropShadow(pBmap : pBitmap;skipcolor : Tcolor;startx,starty:integer);
procedure MakeGlobe(pBmap : pBitmap;skipcolor : Tcolor);
procedure RotoZoom(pBmap: pBitmap;pBmap2: pBitmap;skipcolor : Tcolor;FscaleX,FscaleY,angle : integer);
procedure RotoZoom2(pBmap: pBitmap;pBmap2: pBitmap;skipcolor : Tcolor;FscaleX,FscaleY,angle : integer);
procedure DrawIconFx(dc:hdc;xLeft,yTop,w,h:integer;icon: hicon;backcolor :Tcolor;throbbercolor :Tcolor;BlendT : boolean;BlendTNr :integer;BlendB:Boolean;BlendBNr:Integer);
procedure ApplyBitmapFX(pBmap : pBitmap;backcolor :Tcolor;throbbercolor :Tcolor; BlendT : boolean;BlendTNr :integer;BlendB:Boolean;BlendBNr:Integer);
procedure ApplyBitmapFX2(pBmp : TBitmap;DC : HDC; dcx,dcy : integer; backcolor :Tcolor;throbbercolor :Tcolor; BlendT : boolean;BlendTNr :integer;BlendB:Boolean;BlendBNr:Integer);
procedure ApplyBitmapFX3(Bmap : HBitmap;backcolor :Tcolor;throbbercolor :Tcolor; BlendT : boolean;BlendTNr :integer;BlendB:Boolean;BlendBNr:Integer);
function Lighter(Color:TColor; Percent:Byte):TColor;
function Darker(Color:TColor; Percent:Byte):TColor;

implementation


procedure ApplyBitmapFX2(pBmp : TBitmap;DC : HDC; dcx,dcy : integer; backcolor :Tcolor;throbbercolor :Tcolor; BlendT : boolean;BlendTNr :integer;BlendB:Boolean;BlendBNr:Integer);
var bmp : Tbitmap;
    i,j,k : integer;
    CB,CR,CG:Byte;
    gCB,gCR,gCG:Byte;
    nyCB,nyCR,nyCG : byte;
    CB1,CG1,CR1 : byte;
    tCB,tCR,tCG : integer;
    bCB,bCR,bCG : integer;
    P32:Pointer;
    Y:Integer;
    P:PLongInt;
    P2 : pChar;
    sum,sum2 : real;
    change : integer;
    t1,t2,t3 : integer;
    Canvas : TCanvas;
begin
  if not(BlendT) and not(BlendB) then
     exit;
//  bmp := pBmap^;
  bmp := TBitmap.Create;
  bmp.Width:=pBmp.Width;
  bmp.Height:=pBmp.Height;
  bmp.PixelFormat:=pf32bit;
  bmp.Canvas.Draw(0,0,pbmp);

  CR1:=GetBValue(colortorgb(backcolor));
  CG1:=GetGValue(colortorgb(backcolor));
  CB1:=GetRValue(colortorgb(backcolor));
  CR:=GetBValue(colortorgb(throbbercolor));
  CG:=GetGValue(colortorgb(throbbercolor));
  CB:=GetRValue(colortorgb(throbbercolor));
  sum := (CB+CR+CG)/3;
  BlendBNr := integer(BlendB)*BlendBNr;
  BlendTNr := integer(BlendT)*BlendTNr;
  if ( BlendBNr + BlendTNr) > 255 then begin
    t1 := 0;
    t2 := round(BlendBNr*255/(BlendBNr+BlendTNr));
    t3 := round(BlendTNr*255/(BlendBNr+BlendTNr));
  end
  else begin
    t1 := 255-BlendBNr-BlendTNr;
    t2 := BlendBNr;
    t3 := BlendTNr;
  end;

  bmp.HandleType:=bmDIB;
  bmp.PixelFormat:=pf32bit;
  for Y := 0 to bmp.Height-1 do begin
    i:=-1;
    while i+1<bmp.Width do begin
      Inc(i);
      P32:=bmp.ScanLine[Y];
      P:=PLongInt(P32);
      Inc(PChar(P),i*SizeOf(LongInt));
      gCB:=GetBValue(P^);
      gCG:=GetGValue(P^);
      gCR:=GetRValue(P^);
      if (gCB <> CB1) or (gCR <> CR1) or (gCG <> CG1) then begin

        //First make it follow background
        sum2 := (gCB+gCR+gCG)/3;
        change := round(sum2-sum);
        tCB := CB + change;
        tCG := CG + change;
        tCR := CR + change;
        bCB := CB1 + change;
        bCG := CG1 + change;
        bCR := CR1 + change;


        //Blend in throbber color
        tCB := Round((t1*gCB+t2*bCB+t3*tCB)/255);
        tCG := Round((t1*gCG+t2*bCG+t3*tCG)/255);
        tCR := Round((t1*gCR+t2*bCR+t3*tCR)/255);

        if tCB > 255 then nyCB := 255
        else if tCB < 0 then nyCB := 0
        else nyCB := tCB;
        if tCR > 255 then nyCR := 255
        else if tCR < 0 then nyCR := 0
        else nyCR := tCR;
        if tCG > 255 then nyCG := 255
        else if tCG < 0 then nyCG := 0
        else nyCG := tCG;
        P^ := nyCR;
        P2 := pChar(P);
        P2[1] := char(nyCG);
        P2[2] := char(nyCB);
      end;
    end;
  end;

  canvas := Tcanvas.Create;
  canvas.Handle := dc;
  canvas.Draw(dcx,dcy,bmp);
  canvas.Free;
  Bmp.Free;

end;


procedure ApplyBitmapFX3(Bmap : HBitmap;backcolor :Tcolor;throbbercolor :Tcolor; BlendT : boolean;BlendTNr :integer;BlendB:Boolean;BlendBNr:Integer);
var bmp : Tbitmap;
    i,j,k : integer;
    CB,CR,CG:Byte;
    gCB,gCR,gCG:Byte;
    nyCB,nyCR,nyCG : byte;
    CB1,CG1,CR1 : byte;
    tCB,tCR,tCG : integer;
    bCB,bCR,bCG : integer;
    P32:Pointer;
    Y:Integer;
    P:PLongInt;
    P2 : pChar;
    sum,sum2 : real;
    change : integer;
    t1,t2,t3 : integer;
begin
  if not(BlendT) and not(BlendB) then
     exit;

  bmp := TBitmap.Create;
  bmp.Handle := Bmap;

  CR1:=GetBValue(colortorgb(backcolor));
  CG1:=GetGValue(colortorgb(backcolor));
  CB1:=GetRValue(colortorgb(backcolor));
  CR:=GetBValue(colortorgb(throbbercolor));
  CG:=GetGValue(colortorgb(throbbercolor));
  CB:=GetRValue(colortorgb(throbbercolor));
  sum := (CB+CR+CG)/3;
  BlendBNr := integer(BlendB)*BlendBNr;
  BlendTNr := integer(BlendT)*BlendTNr;
  if ( BlendBNr + BlendTNr) > 255 then begin
    t1 := 0;
    t2 := round(BlendBNr*255/(BlendBNr+BlendTNr));
    t3 := round(BlendTNr*255/(BlendBNr+BlendTNr));
  end
  else begin
    t1 := 255-BlendBNr-BlendTNr;
    t2 := BlendBNr;
    t3 := BlendTNr;
  end;

  bmp.HandleType:=bmDIB;
  bmp.PixelFormat:=pf32bit;
  for Y := 0 to bmp.Height-1 do begin
    i:=-1;
    while i+1<bmp.Width do begin
      Inc(i);
      P32:=bmp.ScanLine[Y];
      P:=PLongInt(P32);
      Inc(PChar(P),i*SizeOf(LongInt));
      gCB:=GetBValue(P^);
      gCG:=GetGValue(P^);
      gCR:=GetRValue(P^);
      if (gCB <> CB1) or (gCR <> CR1) or (gCG <> CG1) then begin

        //First make it follow background
        sum2 := (gCB+gCR+gCG)/3;
        change := round(sum2-sum);
        tCB := CB + change;
        tCG := CG + change;
        tCR := CR + change;
        bCB := CB1 + change;
        bCG := CG1 + change;
        bCR := CR1 + change;


        //Blend in throbber color
        tCB := Round((t1*gCB+t2*bCB+t3*tCB)/255);
        tCG := Round((t1*gCG+t2*bCG+t3*tCG)/255);
        tCR := Round((t1*gCR+t2*bCR+t3*tCR)/255);

        if tCB > 255 then nyCB := 255
        else if tCB < 0 then nyCB := 0
        else nyCB := tCB;
        if tCR > 255 then nyCR := 255
        else if tCR < 0 then nyCR := 0
        else nyCR := tCR;
        if tCG > 255 then nyCG := 255
        else if tCG < 0 then nyCG := 0
        else nyCG := tCG;
        P^ := nyCR;
        P2 := pChar(P);
        P2[1] := char(nyCG);
        P2[2] := char(nyCB);
      end;
    end;
  end;
  bmp.ReleaseHandle;
  bmp.Free;
end;


procedure ApplyBitmapFX(pBmap : pBitmap;backcolor :Tcolor;throbbercolor :Tcolor; BlendT : boolean;BlendTNr :integer;BlendB:Boolean;BlendBNr:Integer);
var bmp : Tbitmap;
    i,j,k : integer;
    CB,CR,CG:Byte;
    gCB,gCR,gCG:Byte;
    nyCB,nyCR,nyCG : byte;
    CB1,CG1,CR1 : byte;
    tCB,tCR,tCG : integer;
    bCB,bCR,bCG : integer;
    P32:Pointer;
    Y:Integer;
    P:PLongInt;
    P2 : pChar;
    sum,sum2 : real;
    change : integer;
    t1,t2,t3 : integer;
begin
  if not(BlendT) and not(BlendB) then
     exit;
      
  bmp := pBmap^;

  CR1:=GetBValue(colortorgb(backcolor));
  CG1:=GetGValue(colortorgb(backcolor));
  CB1:=GetRValue(colortorgb(backcolor));
  CR:=GetBValue(colortorgb(throbbercolor));
  CG:=GetGValue(colortorgb(throbbercolor));
  CB:=GetRValue(colortorgb(throbbercolor));
  sum := (CB+CR+CG)/3;
  BlendBNr := integer(BlendB)*BlendBNr;
  BlendTNr := integer(BlendT)*BlendTNr;
  if ( BlendBNr + BlendTNr) > 255 then begin
    t1 := 0;
    t2 := round(BlendBNr*255/(BlendBNr+BlendTNr));
    t3 := round(BlendTNr*255/(BlendBNr+BlendTNr));
  end
  else begin
    t1 := 255-BlendBNr-BlendTNr;
    t2 := BlendBNr;
    t3 := BlendTNr;
  end;

  bmp.HandleType:=bmDIB;
  bmp.PixelFormat:=pf32bit;
  for Y := 0 to bmp.Height-1 do begin
    i:=-1;
    while i+1<bmp.Width do begin
      Inc(i);
      P32:=bmp.ScanLine[Y];
      P:=PLongInt(P32);
      Inc(PChar(P),i*SizeOf(LongInt));
      gCB:=GetBValue(P^);
      gCG:=GetGValue(P^);
      gCR:=GetRValue(P^);
      if (gCB <> CB1) or (gCR <> CR1) or (gCG <> CG1) then begin

        //First make it follow background
        sum2 := (gCB+gCR+gCG)/3;
        change := round(sum2-sum);
        tCB := CB + change;
        tCG := CG + change;
        tCR := CR + change;
        bCB := CB1 + change;
        bCG := CG1 + change;
        bCR := CR1 + change;


        //Blend in throbber color
        tCB := Round((t1*gCB+t2*bCB+t3*tCB)/255);
        tCG := Round((t1*gCG+t2*bCG+t3*tCG)/255);
        tCR := Round((t1*gCR+t2*bCR+t3*tCR)/255);

        if tCB > 255 then nyCB := 255
        else if tCB < 0 then nyCB := 0
        else nyCB := tCB;
        if tCR > 255 then nyCR := 255
        else if tCR < 0 then nyCR := 0
        else nyCR := tCR;
        if tCG > 255 then nyCG := 255
        else if tCG < 0 then nyCG := 0
        else nyCG := tCG;
        P^ := nyCR;
        P2 := pChar(P);
        P2[1] := char(nyCG);
        P2[2] := char(nyCB);
      end;
    end;
  end;
end;


function Darker(Color:TColor; Percent:Byte):TColor;
var
  r,g,b :Byte;
begin
  Color:=ColorToRGB(Color);
  r:=GetRValue(Color);
  g:=GetGValue(Color);
  b:=GetBValue(Color);
  r:=r-muldiv(r,Percent,100);
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
  r:=r+muldiv(255-r,Percent,100);
  g:=g+muldiv(255-g,Percent,100);
  b:=b+muldiv(255-b,Percent,100);
  result:=RGB(r,g,b);
end;

procedure DrawIconFx(dc:hdc;xLeft,yTop,w,h:integer;icon: hicon;backcolor :Tcolor;throbbercolor :Tcolor; BlendT : boolean;BlendTNr :integer;BlendB:Boolean;BlendBNr:Integer);
var bmp : Tbitmap;
    i,j,k : integer;
    CB,CR,CG:Byte;
    gCB,gCR,gCG:Byte;
    nyCB,nyCR,nyCG : byte;
    CB1,CG1,CR1 : byte;
    tCB,tCR,tCG : integer;
    bCB,bCR,bCG : integer;
    P32:Pointer;
    Y:Integer;
    P:PLongInt;
    P2 : pChar;
    sum,sum2 : real;
    change : integer;
    skipcolor : Tcolor;
    canvas : Tcanvas;
    t1,t2,t3 : integer;
    brush : TBrush;
begin
  if not(BlendT) and not(BlendB) then begin
    brush := TBrush.Create;
    brush.Color := backcolor;
    DrawIconEx(dc,xLeft, yTop,icon, w,h ,0,brush.Handle,DI_NORMAL);
    brush.Free;
    exit;
  end;
  bmp := Tbitmap.create;
  bmp.height := w;
  bmp.width := h;
  bmp.HandleType := bmDIB;
  bmp.PixelFormat := pf32bit;
  bmp.Canvas.Brush.Color := backcolor;
  bmp.Canvas.FillRect(rect(0,0,w,h));
  DrawIconEx(bmp.Canvas.Handle,0, 0,icon, w,h ,0,bmp.Canvas.Brush.handle,DI_NORMAL);
 // DrawIcon(bmp.Canvas.Handle,0,0,icon);
  CR1:=GetBValue(colortorgb(backcolor));
  CG1:=GetGValue(colortorgb(backcolor));
  CB1:=GetRValue(colortorgb(backcolor));
  CR:=GetBValue(colortorgb(throbbercolor));
  CG:=GetGValue(colortorgb(throbbercolor));
  CB:=GetRValue(colortorgb(throbbercolor));
  sum := (CB+CR+CG)/3;
  BlendBNr := integer(BlendB)*BlendBNr;
  BlendTNr := integer(BlendT)*BlendTNr;
  if ( BlendBNr + BlendTNr) > 255 then begin
    t1 := 0;
    t2 := round(BlendBNr*255/(BlendBNr+BlendTNr));
    t3 := round(BlendTNr*255/(BlendBNr+BlendTNr));
  end
  else begin
    t1 := 255-BlendBNr-BlendTNr;
    t2 := BlendBNr;
    t3 := BlendTNr;
  end;

  bmp.HandleType:=bmDIB;
  bmp.PixelFormat:=pf32bit;
  for Y := 0 to bmp.Height-1 do begin
    i:=-1;
    while i+1<bmp.Width do begin
      Inc(i);
      P32:=bmp.ScanLine[Y];
      P:=PLongInt(P32);
      Inc(PChar(P),i*SizeOf(LongInt));
      gCB:=GetBValue(P^);
      gCG:=GetGValue(P^);
      gCR:=GetRValue(P^);
      if (gCB <> CB1) or (gCR <> CR1) or (gCG <> CG1) then begin

        //First make it follow background
        sum2 := (gCB+gCR+gCG)/3;
        change := round(sum2-sum);
        tCB := CB + change;
        tCG := CG + change;
        tCR := CR + change;
        bCB := CB1 + change;
        bCG := CG1 + change;
        bCR := CR1 + change;


        //Blend in throbber color
        tCB := Round((t1*gCB+t2*bCB+t3*tCB)/255);
        tCG := Round((t1*gCG+t2*bCG+t3*tCG)/255);
        tCR := Round((t1*gCR+t2*bCR+t3*tCR)/255);

        if tCB > 255 then nyCB := 255
        else if tCB < 0 then nyCB := 0
        else nyCB := tCB;
        if tCR > 255 then nyCR := 255
        else if tCR < 0 then nyCR := 0
        else nyCR := tCR;
        if tCG > 255 then nyCG := 255
        else if tCG < 0 then nyCG := 0
        else nyCG := tCG;
        P^ := nyCR;
        P2 := pChar(P);
        P2[1] := char(nyCG);
        P2[2] := char(nyCB);
      end;
    end;
  end;
  canvas := Tcanvas.Create;
  canvas.Handle := dc;
  //createdropshadow(@bmp,backcolor,0,0);
  canvas.Draw(xLeft,yTop,bmp);
  canvas.Free;
  bmp.free;
end;




procedure ChangeColor(pBmap : pBitmap;Color1a,Color1b,color2a,color2b,color3a,color3b:Tcolor);
var
  sourcedata,destdata : pointer;
  NoPixels, NoLines   : Integer;
begin
  pBmap^.HandleType:=bmDIB;
  pBmap^.PixelFormat:=pf32bit;

  NoLines  := pBMap^.Height;
  NoPixels := pBMap^.Width;
  sourcedata := pBmap^.ScanLine[pBmap^.height-1];
  destdata := sourcedata;
asm
          push ESI
          push EBX
          push EDI

          mov  EDX, Color1a
          bswap EDX
          ror EDX,8
          mov  Color1a, EDX

          mov  EDX, Color2a
          bswap EDX
          ror EDX,8
          mov  Color2a, EDX

          mov  EDX, clGreen
          bswap EDX
          ror EDX,8
          mov  Color3a, EDX

          mov  EDX, Color1b
          bswap EDX
          ror EDX,8
          mov  Color1b, EDX

          mov  EDX, Color2b
          bswap EDX
          ror EDX,8
          mov  Color2b, EDX

          mov  EDX, Color3b
          bswap EDX
          ror EDX,8
          mov  Color3b, EDX

          mov  ESI, Sourcedata
          mov  EDI, Destdata


          xor  EDX, EDX

  @VLoop:
          mov  ECX, NoPixels
  @HLoop:
          lodsd
          and  EAX, $00ffffff

          cmp  EAX, Color1a
          je   @color1Pixel

          cmp  EAX, Color2a
          je   @color2Pixel

          cmp  EAX, Color3a
          je   @color3Pixel

          stosd

          Jmp  @NextPixel

  @color1Pixel:
          mov   EAX,color1b
          stosd
          Jmp  @NextPixel
  @color2Pixel:
          mov   EAX,color2b
          stosd
          Jmp  @NextPixel
  @color3Pixel:
          mov   EAX,color3b
          stosd
  @NextPixel:
          dec  ECX
          jnz  @HLoop

          dec  NoLines
          jnz  @VLoop
  @TheEnd:
          pop  EBX
          pop  ESI
          pop  EDI
  end;
end;


procedure Alphablend(pBmap: pBitmap;pBmap2: pBitmap;alpha: Byte);overload;
var
  TransColor          : TColor;
  sourcedata,destdata : pointer;
  NoPixels, NoLines   : Integer;
begin
  pBmap^.HandleType:=bmDIB;
  pBmap^.PixelFormat:=pf32bit;
  pBmap2^.HandleType:=bmDIB;
  pBmap2^.PixelFormat:=pf32bit;
  if pBMap^.height > pBMap2^.Height then
    NoLines  := pBMap^.Height
  else
    NoLines  := pBMap2^.Height;
  if pBMap^.Width > pBMap2^.Width then
    NoPixels  := pBMap^.Width
  else
    NoPixels  := pBMap2^.Width;
  sourcedata := pBmap2^.ScanLine[pBmap2^.height-1];
  destdata := pBmap^.ScanLine[pBmap^.height-1];
asm
          push EDI
          push ESI
          push EBX

          mov  EDX, TransColor
          and  EDX, $00ffffff
          mov  TransColor, EDX

          mov  bh,  alpha
          mov  bl,  alpha

          mov  ESI, Sourcedata
          mov  EDI, DestData

          xor  EDX, EDX

          not  bh
  @VLoop:
          mov  ECX, NoPixels
  @HLoop:
      //    Mov  EAX, [EDI]
       //   and  EAX, $00ffffff
      //    cmp  EAX, TransColor
       //   je   @SkipPixel

          //Green
          xor  Ah,Ah
          LodSB
          Mul  Bl
          Mov  DX, AX
          Xor  AX, AX
          Mov  Al, [EDI]
          mul  Bh
          add  Ax, Dx
          mov  Al, Ah
          Inc  Al
          StoSB
          //Blue
          xor  Ah,Ah
          LodSB
          Mul  Bl
          Mov  DX, AX
          Xor  AX, AX
          Mov  Al, [EDI]
          mul  Bh
          add  Ax, Dx
          mov  Al, Ah
          Inc  Al
          StoSB
          //Red
          xor  Ah,Ah
          LodSB
          Mul  Bl
          Mov  DX, AX
          Xor  AX, AX
          Mov  Al, [EDI]
          mul  Bh
          add  Ax, Dx
          mov  Al, Ah
          Inc  Al
          StoSB
          Inc  ESI
          Inc  EDI

          Jmp  @NextPixel

  @SkipPixel:
          //Next pixel
          lea EDI,[EDI+4]
          lea ESI,[ESI+4]

  @NextPixel:
          dec  ECX
          jnz  @HLoop

          dec  NoLines
          jnz  @VLoop
  @TheEnd:
          pop  EBX
          pop  ESI
          pop  EDI
  end;
end;

procedure Alphablend(pBmap: pBitmap;color : TColor;alpha: Byte);overload;
var
  sourcedata,destdata : pointer;
  NoPixels, NoLines   : Integer;
  CR,CG,CB            : byte;
begin
  pBmap^.HandleType:=bmDIB;
  pBmap^.PixelFormat:=pf32bit;
  NoLines  := pBMap^.Height;
  NoPixels  := pBMap^.Width;
  CR := GetRvalue(color);
  CG := GetBvalue(color);
  CB := GetGValue(color);
  sourcedata := pBmap^.ScanLine[pBmap^.height-1];
  destdata := sourcedata;
asm
          push EDI
          push ESI
          push EBX

       
          mov  bh,  alpha
          mov  bl,  alpha

          mov  ESI, Sourcedata
          mov  EDI, DestData

          xor  EDX, EDX

          not  bh
  @VLoop:
          mov  ECX, NoPixels
  @HLoop:
      //    Mov  EAX, [EDI]
       //   and  EAX, $00ffffff
      //    cmp  EAX, TransColor
       //   je   @SkipPixel

          //Green
          xor  Ah,Ah
          LodSB
          Mul  Bl
          Mov  DX, AX
          Xor  AX, AX
          Mov  Al, CG
          mul  Bh
          add  Ax, Dx
          mov  Al, Ah
          Inc  Al
          StoSB
          //Blue
          xor  Ah,Ah
          LodSB
          Mul  Bl
          Mov  DX, AX
          Xor  AX, AX
          Mov  Al, CB
          mul  Bh
          add  Ax, Dx
          mov  Al, Ah
          Inc  Al
          StoSB
          //Red
          xor  Ah,Ah
          LodSB
          Mul  Bl
          Mov  DX, AX
          Xor  AX, AX
          Mov  Al, CR
          mul  Bh
          add  Ax, Dx
          mov  Al, Ah
          Inc  Al
          StoSB

          Inc  ESI
          Inc  EDI

          Jmp  @NextPixel

  @SkipPixel:
          //Next pixel
          lea EDI,[EDI+4]
          lea ESI,[ESI+4]

  @NextPixel:
          dec  ECX
          jnz  @HLoop

          dec  NoLines
          jnz  @VLoop
  @TheEnd:
          pop  EBX
          pop  ESI
          pop  EDI
  end;
end;


procedure RotoZoom(pBmap: pBitmap;pBmap2: pBitmap;skipcolor : Tcolor;FscaleX,FscaleY,angle : integer);
var
  Source,Dest          : PChar;
  DDX,DDY,D2X,D2Y,I,J  : Integer;
  Xpos,YPos,SLineSize  : Integer;
  NegHalfSWidth,
  HalfSWidth,
  NegHalfSHeight,
  HalfSHeight          : Integer;
  DestWidth, DestHeight: Integer;
  ScaleX, ScaleY       : Real;
  DestTransCol         : TColor;
  bitmap,bitmap2       : Tbitmap;
  width,height         : integer;
begin
  DestTransCol := skipcolor;
  bitmap  := pBmap^;
  bitmap.HandleType:=bmDIB;
  bitmap.PixelFormat:=pf32bit;
  bitmap2  := pBmap2^;
  bitmap2.HandleType:=bmDIB;
  bitmap2.PixelFormat:=pf32bit;
  width := bitmap.width;
  height := bitmap.height;

  Source := bitmap.ScanLine[height-1];
  Dest := bitmap2.ScanLine[height-1];
  SLineSize := Width *4;

  NegHalfSWidth := -(Width div 2);
  NegHalfSHeight := -(Height div 2);
  HalfSWidth := Width div 2;
  HalfSHeight := Height div 2;


  DestWidth := bitmap2.Width;
  DestHeight := bitmap2.Height;

  ScaleX := FScaleX / 100;
  ScaleY := FScaleY / 100;

  if Width * ScaleX = 0 then exit;
  if Height * ScaleY = 0 then exit;

  DDX := Round(((CosTable1[Angle]) * Width) / (Width * ScaleX));
  DDY := Round(((SinTable1[Angle]) * Height) / (Height * ScaleY));

  D2X := Round(((CosTable2[Angle]) * Width) / (Width * ScaleX));
  D2Y := Round(((SinTable2[Angle]) * Height) / (Height * ScaleY));

  I := ((-DDX) * (DestWidth div 2)) - (D2X * (DestHeight div 2));
  J := ((-DDY) * (DestWidth div 2)) - (D2Y * (DestHeight div 2));

  Source := Source + (HalfSHeight * SLineSize) +  (HalfSWidth*4);

  asm
          push EDI
          push ESI
          push EBX

          mov  EDI, Dest
          mov  ESI, Source

          mov  ECX, DestHeight// for VLoop := 0 to D.Height -1 do begin
  @VLoop:
          mov  EAX, I
          mov  EBX, J
          mov  XPos, EAX      // XPos := I
          mov  YPos, EBX      // YPos := J

          push ECX
          mov  ECX, DestWidth //for HLoop:=0 to D.Width -1 do begin

  @HLoop:
          //Calculate offset using int(YPos)
          Mov  EAX, YPos
          test EAX, EAX
          jns  @ActualYGTZero
          lea  EAX, [EAX+$000000ff]

  @ActualYGTZero:
          sar  EAX, $08       // ActualY := YPos div 256;

          cmp  EAX, HalfSHeight
          Jge  @SkipPixel     // If ActualY > (S.Height div 2) then skip

          mov  EBX, NegHalfSHeight
//          neg  EBX
          cmp  EAX, EBX
          jle  @SkipPixel     // If ActualY < -(S.Height div 2) then skip

          mov  EBX, SLineSize
          imul EBX
          mov  EDX, EAX       // Offset := (ActualY * SLineSize)

          //Calculate offset using ActualX
          mov  EAX, XPos
          test EAX, EAX
          jns  @ActualXGTZero
          lea  EAX, [EAX+$000000ff]

  @ActualXGTZero:
          sar  EAX, $08       // ActualX := XPos div 256;

          cmp  EAX, HalfSWidth
          Jge  @SkipPixel     //if ActualX > (S.Width div 2) then skip

          mov  EBX, NegHalfSWidth
//          neg  EBX
          cmp  EAX, EBX
          Jle  @SkipPixel

          lea  EAX, [EAX*4+EDX]  //EAX := EAX * 4; {4 bytes per pixel}

          mov  EAX, [ESI +EAX]
          mov  [EDI], EAX

          jmp  @NextPixel

  @SkipPixel:
          mov  EAX, DestTransCol
          mov  [EDI], EAX

  @NextPixel:
          lea  EDI, [EDI+4]
          mov  EAX, ddx
          mov  EBX, ddy
          add  XPos, EAX      //XPos := XPos + DDX;
          add  YPos, EBX      //Ypos := YPos + DDY;
          dec  ECX
          jnz  @HLoop         //end; //for HLoop

  @NextLine:
          pop  ECX
          mov  EAX, D2X
          mov  EBX, D2Y
          add  I, EAX         //I := I + D2X;
          add  J, EBX         //J := J + D2Y;

          dec  ECX
          jnz  @Vloop         //end; //for VLoop

  @TheEnd:
          pop  EBX
          pop  ESI
          pop  EDI
  end;
end;

procedure RotoZoom2(pBmap: pBitmap;pBmap2: pBitmap;skipcolor : Tcolor;FscaleX,FscaleY,angle : integer);
var
  Source,Dest          : PChar;
  DDX,DDY,D2X,D2Y,I,J  : Integer;
  Xpos,YPos,SLineSize  : Integer;
  NegHalfSWidth,
  HalfSWidth,
  NegHalfSHeight,
  HalfSHeight          : Integer;
  DestWidth, DestHeight: Integer;
  ScaleX, ScaleY       : Real;
  DestTransCol         : TColor;
  bitmap,bitmap2       : Tbitmap;
  width,height         : integer;
begin
  DestTransCol := skipcolor;
  bitmap  := pBmap^;
  bitmap.HandleType:=bmDIB;
  bitmap.PixelFormat:=pf32bit;
  bitmap2  := pBmap2^;
  bitmap2.HandleType:=bmDIB;
  bitmap2.PixelFormat:=pf32bit;
  width := bitmap.width;
  height := bitmap.height;

  Source := bitmap.ScanLine[height-1];
  Dest := bitmap2.ScanLine[height-1];
  SLineSize := Width *4;

  NegHalfSWidth := -(Width div 2);
  NegHalfSHeight := -(Height div 2);
  HalfSWidth := Width div 2;
  HalfSHeight := Height div 2;


  DestWidth := bitmap2.Width;
  DestHeight := bitmap2.Height;

  ScaleX := FScaleX / 100;
  ScaleY := FScaleY / 100;

  if Width * ScaleX = 0 then exit;
  if Height * ScaleY = 0 then exit;

  DDX := Round((256 * Width) / (Width * ScaleX));
  DDY := 0;
  D2Y := Round((256* Height) / (Height * ScaleY));
  D2X := 0;
  I := -DDX * (DestWidth div 2);
  J := -D2Y * (DestHeight div 2);

  Source := Source + (HalfSHeight * SLineSize) +  (HalfSWidth*4);

  asm
          push EDI
          push ESI
          push EBX

          mov  EDI, Dest
          mov  ESI, Source

          mov  ECX, DestHeight// for VLoop := 0 to D.Height -1 do begin
  @VLoop:
          mov  EAX, I
          mov  EBX, J
          mov  XPos, EAX      // XPos := I
          mov  YPos, EBX      // YPos := J

          push ECX
          mov  ECX, DestWidth //for HLoop:=0 to D.Width -1 do begin

  @HLoop:
          //Calculate offset using int(YPos)
          Mov  EAX, YPos
          test EAX, EAX
          jns  @ActualYGTZero
          lea  EAX, [EAX+$000000ff]

  @ActualYGTZero:
          sar  EAX, $08       // ActualY := YPos div 256;

          cmp  EAX, HalfSHeight
          Jge  @SkipPixel     // If ActualY > (S.Height div 2) then skip

          mov  EBX, NegHalfSHeight
//          neg  EBX
          cmp  EAX, EBX
          jle  @SkipPixel     // If ActualY < -(S.Height div 2) then skip

          mov  EBX, SLineSize
          imul EBX
          mov  EDX, EAX       // Offset := (ActualY * SLineSize)

          //Calculate offset using ActualX
          mov  EAX, XPos
          test EAX, EAX
          jns  @ActualXGTZero
          lea  EAX, [EAX+$000000ff]

  @ActualXGTZero:
          sar  EAX, $08       // ActualX := XPos div 256;

          cmp  EAX, HalfSWidth
          Jge  @SkipPixel     //if ActualX > (S.Width div 2) then skip

          mov  EBX, NegHalfSWidth
//          neg  EBX
          cmp  EAX, EBX
          Jle  @SkipPixel

          lea  EAX, [EAX*4+EDX]  //EAX := EAX * 4; {4 bytes per pixel}

          mov  EAX, [ESI +EAX]
          mov  [EDI], EAX

          jmp  @NextPixel

  @SkipPixel:
          mov  EAX, DestTransCol
          mov  [EDI], EAX

  @NextPixel:
          lea  EDI, [EDI+4]
          mov  EAX, ddx
          mov  EBX, ddy
          add  XPos, EAX      //XPos := XPos + DDX;
          add  YPos, EBX      //Ypos := YPos + DDY;
          dec  ECX
          jnz  @HLoop         //end; //for HLoop

  @NextLine:
          pop  ECX
          mov  EAX, D2X
          mov  EBX, D2Y
          add  I, EAX         //I := I + D2X;
          add  J, EBX         //J := J + D2Y;

          dec  ECX
          jnz  @Vloop         //end; //for VLoop

  @TheEnd:
          pop  EBX
          pop  ESI
          pop  EDI
  end;
end;



procedure createdropshadow(pBmap : pBitmap;skipcolor : Tcolor;startx,starty:integer);
var bitmap : Tbitmap;
    i      : integer;
    CB,CR,CG:Byte;
    nyCB,nyCR,nyCG : byte;
    P32:Pointer;
    Y:Integer;
    P:PLongInt;
    P2 : pChar;
    pass : Array of Array of integer;
begin
  bitmap := pBmap^;
  setlength(pass,bitmap.height,bitmap.width);
  bitmap.HandleType:=bmDIB;
  bitmap.PixelFormat:=pf32bit;
  nyCR := GetBValue(colortoRGB(skipcolor));
  nyCG := GetGValue(colortoRGB(skipcolor));
  nyCB := GetRValue(colortoRGB(skipcolor));
  for Y := 0 to bitmap.Height-1 do begin
    i:=-1;
    P32:=bitmap.ScanLine[Y];
    while i+1<bitmap.Width do begin
      Inc(i);
      pass[y,i] := 0;
      P:=PLongInt(P32);
      Inc(PChar(P),i*SizeOf(LongInt));
      CB:=GetBValue(P^);
      CG:=GetGValue(P^);
      CR:=GetRValue(P^);
      if (CB <> NyCB) or (CG <> NyCG) or (CR <> NyCR)  then begin
        pass[y,i] := 140;
      end else if ((i >= startx) or (Y >= starty)) and ((i > 0) and (Y > 0)) then begin
        pass[y,i] := round((pass[y,i-1] + pass[y-1,i])/2) - 15;
        if pass[y,i] > 139 then pass[y,i] := 139;
        if pass[y,i] < 0 then pass[y,i] := 0;
        if (i > 2) and (y > 2) then begin
          if (pass[y,i] > 0) then begin
            if pass[y,i] < CB then
              CB := round(CB - Pass[y,i]);
            if CB > NyCb then CB := NyCB;
            if pass[y,i] < CG then
              CG := round(CG -Pass[y,i]);
            if CG > NyCG then CG := NyCG;
            if pass[y,i] < CR then
              CR := round(CR -Pass[y,i]);
            if CR > NyCR then CR := NyCR;
          end;
        end;
      end
      else pass[y,i] := 0;
      P^ := CR;
      P2 := pChar(P);
      P2[1] := char(CG);
      P2[2] := char(CB);
    end;
  end;
end;

procedure makeglobe(pBmap : pBitmap;skipcolor : Tcolor);
var bitmap : Tbitmap;
    i,j,k : integer;
    CB,CR,CG:Byte;
    gCB,gCR,gCG:Byte;
    nyCB,nyCR,nyCG : byte;
    P32:Pointer;
    Y:Integer;
    P:PLongInt;
    P2 : pChar;
begin
  j := 18;
  k := 4;
  CR:=GetBValue(colortorgb(skipcolor));
  CG:=GetGValue(colortorgb(skipcolor));
  CB:=GetRValue(colortorgb(skipcolor));
  bitmap := pBmap^;
  bitmap.HandleType:=bmDIB;
  bitmap.PixelFormat:=pf32bit;
  for Y := 0 to bitmap.Height-1 do begin
    i:=-1;
    while i+1<bitmap.Width do begin
      Inc(i);
      P32:=bitmap.ScanLine[Y];
      P:=PLongInt(P32);
      Inc(PChar(P),i*SizeOf(LongInt));
      gCB:=GetBValue(P^);
      gCG:=GetGValue(P^);
      gCR:=GetRValue(P^);
      if (gCB <> CB) or (gCR <> CR) or (gCG <> CG) then begin
        nyCB := gCB + (i+Y-j)*k;
        if (i+Y < j) and (nyCB > gCB) then nyCB := 255;
        if (i+Y > j) and (nyCB < gCB) then nyCB := 0;
        nyCG := gCG + (i+Y-j)*k;
        if (i+Y < j) and (nyCG > gCG) then nyCG := 255;
        if (i+Y > j) and (nyCG < gCG) then nyCG := 0;
        nyCR := gCR + (i+Y-j)*k;
        if (i+Y < j) and (nyCR > gCR) then nyCR := 255;
        if (i+Y > j) and (nyCR < gCR) then nyCR := 0;
        P^ := nyCR;
        P2 := pChar(P);
        P2[1] := char(nyCG);
        P2[2] := char(nyCB);
      end;
    end;
  end;
end;

var
  X                 : TAngle;
  Angle             : Real;

initialization
  X:=0;
  for X:=lo(X) to High(X) do begin
    Angle := X * pi/((High(X)+1) div 2);
    SinTable1[X] := Round(Sin(Angle)*256);
    CosTable1[X] := Round(Cos(Angle)*256);
    SinTable2[X] := Round(Sin(Angle + (pi/2))*256);
    CosTable2[X] := Round(Cos(Angle + (pi/2))*256);
 end;

end.
