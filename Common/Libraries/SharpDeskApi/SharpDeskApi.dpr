{Source Name: SharpDeskApi
Copyright (C) Malx <Malx@sharpe-shell.org>
              Martin Krämer <MartinKraemer@gmx.net>

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


library SharpDeskApi;

uses
  Windows,
  CommCtrl,
  Dialogs,
  Forms,
  ShellApi,
  Graphics,
  JPeg,
  pngimage,
  SysUtils,
  gr32,
  GR32_System,
  GR32_Image,
  GR32_Layers,
  GR32_BLEND,
  GR32_PNG,
  GR32_Transforms,
  GR32_Filters,
  GR32_Resamplers,
  JvSimpleXML,
  JclFileUtils,
  JclShell,
  Math,
  Classes,
  SharpAPI in '..\SharpAPI\SharpAPI.pas';

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


function LoadIcon(bmp : TBitmap32; Icon,Target,IconSet : String; Size : integer) : boolean; forward;


procedure BlendImageA(bmp : Tbitmap32; color : TColor; alpha:integer);
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

procedure BlendImageB(Bmp : TBitmap32; Color : TColor);
begin
     BlendImageA(Bmp,Color,255);
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

// Align: -1=Left; 0=Center; 1=Right
function RenderText(dst     : TBitmap32;
                    Font    : TDeskFont;
                    Text    : TStringList;
                    Align   : integer;
                    Spacing : integer) : boolean;
var
  p : TPoint;
  n : integer;
  eh : integer;
begin
  if (dst = nil) or (Text = nil) then
  begin
    RenderText := False;
    exit;
  end;

  if not Font.ShadowAlpha then Font.ShadowAlphaValue := 0;

  dst.Font.Name  := Font.Name;
  dst.Font.Color := Font.Color;
  dst.Font.Size  := Font.Size;
  dst.Font.Style := [];
  if Font.Bold then      dst.Font.Style := dst.Font.Style + [fsBold];
  if Font.Italic then    dst.Font.Style := dst.Font.Style + [fsItalic];
  if Font.Underline then dst.Font.Style := dst.Font.Style + [fsUnderline];
  p := GetTextSize(dst,Text);
  p.y := p.y + Text.Count * Spacing;
  eh := dst.TextHeight('SHARPE-WQGgYyqQ') + Spacing;
  dst.SetSize(p.x+Font.Size,p.y+4);
  dst.Clear(color32(0,0,0,0));
  for n := 0 to Text.Count - 1 do
  begin
    case Align of
     -1 : dst.RenderText(4,n*eh,Text[n],Font.AALevel,color32(Font.Color));
      1 : dst.RenderText(dst.Width-4-dst.TextWidth(Text[n]),n*eh,Text[n],Font.AALevel,color32(Font.Color));
      else dst.RenderText(dst.Width div 2 - dst.TextWidth(Text[n]) div 2,n*eh,Text[n],Font.AALevel,color32(Font.Color));
    end;
  end;

  if Font.Shadow then
     CreateDropShadow(dst,0,1,Font.ShadowAlphaValue,Font.ShadowColor);

  if Font.ShadowAlpha then dst.MasterAlpha := Font.Alpha
     else dst.MasterAlpha := 255;
  RenderText := True;
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
  RenderText(dst,Font,SList,Align,spacing);
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
  result := RenderText(bmp,Font,Text,Align,Spacing);
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

  if IconHasShadow then smod := -3
     else if CaptionHasShadow then smod := -2
          else smod := 0;

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
    result.CaptionTop  := dst.Height div 2 - Caption.Height div 2+ smod;
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
      result.CaptionTop  := 0;
    end else
    begin
      result.IconLeft := dst.Width div 2 - Icon.Width div 2 + IconOffset.X;
      result.IconTop  := 0 + IconOffset.Y;
      result.CaptionLeft := dst.Width div 2 - Caption.Width div 2 + smod;
      result.CaptionTop  := dst.Height - Caption.Height;    
    end;
  end else
  begin
    dst.SetSize(Caption.Width+Icon.Width+CaptionOffset.X+IconOffset.X+8,Max(Caption.Height,Icon.Height)+CaptionOffset.Y+IconOffset.Y);
    dst.Clear(color32(0,0,0,0));
    if CaptionAlign = taLeft then
    begin
      result.IconLeft := dst.Width - Icon.Width;
      result.IconTop  := dst.Height div 2 - Icon.Height div 2;
      result.CaptionLeft := 0;
      result.CaptionTop  := dst.Height div 2 - Caption.Height div 2 + smod;
    end else
    begin
      IconOffset.X := - IconOffset.X;
      result.IconLeft := 0;
      result.IconTop  := dst.Height div 2 - Icon.Height div 2;
      result.CaptionLeft := dst.Width - Caption.Width + smod;
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
  p : TPoint;
  n,i : integer;
  w,h : integer;
  smod : integer;
begin
  if dst = nil then
  begin
    RenderObject := False;
    exit;
  end;
  smod := 0;
  if (Caption.Draw) and (Caption.Caption<>nil) then
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
    if Font.Shadow then smod := -2;     
    if not RenderText(FontBitmap,Font,Caption.Caption,n,Caption.LineSpace) then
    begin
      FontBitmap.SetSize(64,64);
      FontBitmap.Clear(color32(0,0,0,0));
    end;
  end;

  IconBitmap := TBitmap32.Create;
  IconBitmap.DrawMode := dmBlend;
  IconBitmap.CombineMode := cmMerge;
  if Icon.Shadow then smod := -3;
  RenderIcon(IconBitmap,Icon,point(0,0));

  if Caption.Draw then
  begin
    RenderIconCaptionAligned(dst,
                             IconBitmap,
                             FontBitmap,
                             Caption.Align,
                             Point(Icon.Xoffset,Icon.Yoffset),
                             Point(Caption.Xoffset,Caption.Yoffset),
                             Icon.Shadow,
                             Font.Shadow);
  end else
  begin
    dst.SetSize(IconBitmap.Width,IconBitmap.Height);
    dst.Clear(color32(0,0,0,0));
    dst.Draw(0,0,IconBitmap);
  end;

  IconBitmap.Free;
  if Caption.Draw then FreeAndNil(FontBitmap);
  RenderObject := True;
end;




function GetIconList(IconSet : widestring) : PChar;
var
   SList : TStringList;
   XML : TJvSimpleXML;
   n : integer;
begin
     SList := TStringList.create;
     SList.Clear;
     try
        XML := TJvSimpleXML.Create(nil);
        if FileExists(ExtractFilePath(Application.ExeName)+'Icons\'+IconSet+'\IconSet.xml') then
        begin
             XML.LoadFromFile(ExtractFilePath(Application.ExeName)+'Icons\'+IconSet+'\IconSet.xml');
             for n:=0 to XML.Root.Items.ItemNamed['Icons'].Items.Count-1 do
                 with XML.Root.Items.ItemNamed['Icons'].Items.Item[n].Items do
                      SList.Add(Value('name','error')+'='+Value('file','error'));
        end;
        Result := AllocMem(Length(SList.CommaText) + 1);
        StrPCopy(Result, SList.CommaText);
     finally
            XML.Free;
            SList.Free;
     end;
end;


function LoadJpg(Bmp : TBitmap32; IconFile : string) : boolean;
var
   JPegImage  : TJPEGImage;
begin
     if not FileExists(IconFile) then
     begin
          result := False;
          Bmp.SetSize(100,100);
          Bmp.Clear(color32(128,128,128,128));
          exit;
     end;

     JPegImage := TJPEGImage.Create;
     try
        JPegImage.LoadFromFile(IconFile);
        Bmp.SetSize(JPegImage.Width,JPegImage.Height);
        Bmp.Assign(JpegImage);
        JPegImage.Free;
        result := True;        
     except
           result := False;
           JPegImage.Free;
           Bmp.SetSize(100,100);
           Bmp.Clear(color32(128,128,128,128));
     end;
end;


function LoadPng(out Bmp : TBitmap32; IconFile:string) : boolean;
var
   ADIB : TBitmap32;
   i, j: integer;
   P: PColor32;
   A: PByte;
   ABmp: TBitmap;
   APng: TPngObject;
   Canvas: TCanvas;
   b : boolean;
begin
  if not FileExists(IconFile) then
  begin
    result := False;
    Bmp.SetSize(100,100);
    Bmp.Clear(color32(128,128,128,128));
    exit;
  end;

  GR32_PNG.LoadBitmap32FromPNG(Bmp,IconFile,b);
  result := true;
  exit;


     result := False;
     APng := TPngObject.Create;
     ABmp := TBitmap.Create;
     ADib := TBitmap32.Create;
     try
        // Load and assign to the a bitmap
        APng.LoadFromfile(IconFile);
        APng.AssignTo(ABmp);

        // We now *draw* the bitmap to our bitmap.. this will clear alpha in places
        // where drawn.. so we can use it later
        ADib.SetSize(APng.Width, APng.Height);
        ADib.Clear(clBlack32);
        Canvas := TCanvas.Create;
        try
           Canvas.Handle := ADib.Handle;
           Canvas.Draw(0,0,ABmp);
        finally
               Canvas.Free;
        end;

     // Flip the alpha channel
     P := @ADib.Bits[0];
     for i := 0 to ADib.Width * ADib.Height - 1 do
     begin
       P^ := P^ XOR $FF000000;
       inc(P);
     end;

     // The previous doesn't handle bitwise alpha info, so we do that here
     for i := 0 to APng.Height - 1 do
     begin
          A := PByte(APng.AlphaScanLine[i]);
          if assigned(A) then
          begin
               P := @ADib.Bits[i * ADib.Width];
               for j := 0 to APng.Width - 1 do
               begin
                    P^ := SetAlpha(P^, A^);
                    inc(P); inc(A);
               end;
          end else break;
     end;

     finally
            result := True;
            APng.Free;
            ABmp.Free;
            Bmp := ADib;
            Bmp.DrawMode := dmBlend;
     end;
end;

procedure IconToImage(Bmp : TBitmap32; const icon : hicon);
var
   w,h,i    : Integer;
   p        : PColorArray;
   p2       : pColor32;
   bmi      : BITMAPINFO;
   AlphaBmp : Tbitmap32;
   tempbmp  : Tbitmap;
   info     : Ticoninfo;
   dc       : hdc;
   alphaUsed : boolean;
begin
     Alphabmp := nil;
     tempbmp := Tbitmap.Create;
//     dc := createcompatibledc(0);
     try
        //get info about icon
        GetIconInfo(icon,info);
        tempbmp.handle := info.hbmColor;
        ///////////////////////////////////////////////////////
        // Here comes a ugly step were it tries to paint it as
        // a 32 bit icon and check if it is successful.
        // If failed it will paint it as an icon with fewer colors.
        // No way of deciding bitcount in the beginning has been
        // found reliable , try if you want too.   /Malx
        ///////////////////////////////////////////////////////
        AlphaUsed := false;
        if true then
        begin //32-bit icon with alpha
              w := tempbmp.Width;
              h := tempbmp.Height;
              Bmp.setsize(w,h);
              with bmi.bmiHeader do
              begin
                   biSize := SizeOf(bmi.bmiHeader);
                   biWidth := w;
                   biHeight := -h;
                   biPlanes := 1;
                   biBitCount := 32;
                   biCompression := BI_RGB;
                   biSizeImage := 0;
                   biXPelsPerMeter := 1; //dont care
                   biYPelsPerMeter := 1; //dont care
                   biClrUsed := 0;
                   biClrImportant := 0;
              end;
              GetMem(p,w*h*SizeOf(TColorRec));
              GetDIBits(tempbmp.Canvas.Handle,tempbmp.Handle,0,h,p,bmi,DIB_RGB_COLORS);
              P2 := Bmp.PixelPtr[0, 0];
              for i := 0 to w*h-1 do
              begin
                   if (p[i].a > 0) then alphaused := true;
                   P2^ := color32(p[i].r,p[i].g,p[i].b,p[i].a);
                   Inc(P2);// proceed to the next pixel
              end;
              FreeMem(p);
        end;
        if not(alphaused) then
        begin // 24,16,8,4,2 bit icons
              Bmp.Assign(tempbmp);
              AlphaBmp := Tbitmap32.Create;
              tempbmp.handle := info.hbmMask;
              AlphaBmp.Assign(tempbmp);
              Invert(AlphaBmp,AlphaBmp);
              Intensitytoalpha(Bmp,AlphaBmp);
        end;
     finally
//            DeleteDC(dc);
            AlphaBmp.free;
            DeleteObject(info.hbmMask);
            DeleteObject(info.hbmColor);             
            tempbmp.free;
     end;
end;

function LoadIco(Bmp : TBitmap32; IconFile : string; Size : integer) : boolean;
var
  icon : Hicon;
begin
  try
    icon := loadimage(0,pchar(IconFile),IMAGE_ICON,Size,Size,LR_DEFAULTSIZE or LR_LOADFROMFILE);
    if icon <> 0 then
    begin
      IconToImage(Bmp, icon);
      destroyicon(icon);
      result := True;
    end else
    begin
      result := False;
      Bmp.SetSize(100,100);
      Bmp.Clear(color32(128,128,128,128));
    end;
  except
    result := False;
    Bmp.SetSize(100,100);
    Bmp.Clear(color32(128,128,128,128));
  end;
end;

function LoadBmp(Bmp : TBitmap32; IconFile : string) : boolean;
var
   B : TBitmap;
begin
     if not FileExists(IconFile) then
     begin
          result := False;
          Bmp.SetSize(100,100);
          Bmp.Clear(color32(128,128,128,128));
          exit;
     end;

     try
        B:=TBitmap.Create;
        B.LoadFromFile(IconFile);
        Bmp.SetSize(B.Width,B.Height);
        B.Free;
        Bmp.LoadFromFile(IconFile);
        Bmp.DrawMode := dmBlend;
        result := True;
     except
           result := False;
           Bmp.SetSize(100,100);
           Bmp.Clear(color32(128,128,128,128));
     end;
end;


function extrIcon(Bmp : TBitmap32; FileName : string) : boolean;
var
  icon : Hicon;
begin
     if not FileExists(FileName) then
     begin
       result := False;
       Bmp.SetSize(100,100);
       Bmp.Clear(color32(128,128,128,128));
       exit;
     end;

     try
        icon := ExtractIcon(hInstance,PChar(FileName), 0);
        if icon <> 0 then
        begin
             IconToImage(Bmp,icon);
             destroyicon(icon);
             result := True;
             exit;
        end;
        result := False;
        Bmp.SetSize(100,100);
        Bmp.Clear(color32(128,128,128,128));
     except
           result := False;
           Bmp.SetSize(100,100);
           Bmp.Clear(color32(128,128,128,128));
     end;
end;

function extrShellIcon(Bmp : TBitmap32; FileName, IconSet : string) : boolean;
var
  icon : Hicon;
  FileInfo : SHFILEINFO;
  ImageListHandle : THandle;
  b : boolean;
  ResStream: TResourceStream;
  tempBmp : TBitmap32;
begin
  ImageListHandle := SHGetFileInfo( pChar(FileName), 0, FileInfo, sizeof( SHFILEINFO ),
                                    SHGFI_ICON or SHGFI_SHELLICONSIZE);
  if FileInfo.hicon <> 0 then
  begin
    IconToImage(Bmp,FileInfo.hicon);
    DestroyIcon(FileInfo.hIcon);
    ImageList_Destroy(ImageListHandle);
    result := True;
    exit;
  end;
  result := False;
  DestroyIcon(FileInfo.hIcon);
  ImageList_Destroy(ImageListHandle);

  LoadIcon(bmp,'icon.application','icon.application',IconSet,48);
  try
    ResStream := TResourceStream.Create(HInstance, 'Fail_Image', RT_RCDATA);
  except
    exit;
  end;
  
  try
    TempBmp := TBitmap32.Create;
    LoadBitmap32FromPNG(TempBmp,ResStream,b);
    TempBmp.DrawMode := dmBlend;
    TempBmp.CombineMode := cmMerge;
    TempBmp.DrawTo(Bmp,Bmp.Width-TempBmp.Width, Bmp.Height-TempBmp.Height);
  finally
    TempBmp.Free;
    ResStream.Free;
  end;
end;

function DoLoadImage(Bmp : TBitmap32; Image, IconSet : String; Size : integer) : boolean;
var
  ext : String;
  b : boolean;
begin
  Ext := ExtractFileExt(Image);
  
  if lowercase(Ext) = '.exe' then b := extrShellIcon(Bmp,Image, IconSet)
  else if lowercase(Ext) = '.ico' then b := loadIco(Bmp,Image,Size)
  else if lowercase(Ext) = '.png' then b := loadPng(Bmp,Image)
  else b := False;

  if b = False then image := '-3';

  {no data about what image to load
  and SharpE Icon list is empty - so not even default icon available}
  if Image = '-3' then
  begin
    Bmp.SetSize(64,64);
    Bmp.Clear(color32(128,128,128,128));
  end;
end;

function LoadIcon(bmp : TBitmap32; Icon,Target,IconSet : String; Size : integer) : boolean;
var
  IconList : TStringList;
  p : PChar;
  i : integer;
begin
  if Icon = '-2' then extrShellIcon(Bmp,Target, IconSet)
  else if FileExists(Icon) then DoLoadImage(Bmp,Icon, IconSet, Size)
  else
  //else if Icon = '-2' then
  begin
   {SharpE Icon}
   IconList := TStringList.Create;
   try
     p := GetIconList(IconSet);
     IconList.CommaText := p;
   finally
     releasebuffer(p);
   end;
   i := IconList.IndexOfName(Icon);
   if (i<>-1) and (i<=IconList.Count-1) then
   begin
     if FileExists(SharpApi.GetSharpeDirectory+'Icons\'+ IconSet +'\'+IconList.Values[IconList.Names[i]]) then
        Icon := SharpApi.GetSharpeDirectory+'Icons\'+ IconSet +'\'+IconList.Values[IconList.Names[i]];
   end else if IconList.Count>0 then Icon := SharpApi.GetSharpeDirectory+'Icons\'+ IconSet +'\'+IconList.Values[IconList.Names[i]]
            else Icon := '-3';
   IconList.Free;
   DoLoadImage(Bmp,Icon,IconSet,Size);
  end;
end;


procedure LightenBitmapA(Bmp : TBitmap32; Amount :integer);
var
  P: PColor32;
  I : integer;
begin
  with Bmp do
  begin
    P := PixelPtr[0, 0];
    for I := 0 to Width * Height - 1 do
    begin
      P^ := lighten(P^,amount);
      Inc(P); // proceed to the next pixel
    end;
  end;
end;


procedure LightenBitmapB(Bmp : TBitmap32; Amount :integer; Rect : TRect);
var
  P: PColor32;
  X,Y : integer;
  pass : Array of Array of integer;
begin
     with Bmp do
     begin
          setlength(pass,width,height);
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



exports
 LoadJpg,
 LoadIco,
 LoadBmp,
 LoadPng,
 IconToImage,
 BlendImageA,
 BlendImageB,
 LightenBitmapA,
 LightenBitmapB,
 CreateDropShadow,
 releasebuffer,
 GetIconList,
 extrIcon,
 extrShellIcon,
 RenderText,
 RenderTextB,
 RenderTextNA,
 RenderObject,
 RenderIcon,
 RenderIconCaptionAligned,
 LoadIcon;

begin
end.

finalization

