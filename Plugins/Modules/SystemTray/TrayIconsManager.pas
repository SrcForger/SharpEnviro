{
Source Name: TrayIconsManager
Description: Icon messaging and handling class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit TrayIconsManager;

interface

uses Windows, Dialogs, SysUtils,
     Forms, Controls, Messages, Types, Graphics, Contnrs, ExtCtrls,
     GR32,
     SharpApi,
     TipWnd,
     GR32_Filters,
     WinVer,
     declaration,
     BalloonWindow,
     DateUtils,
     Math;

type
    TColorRec = packed record
                  b,g,r,a: Byte;
                end;
    TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
    PColorArray = ^TColorArray;
    THSLColor = record
     Hue,
     Saturation,
     Lightness : Integer;
    end;
 {$REGION '### Classes ###'}
  {$REGION 'TMsgWnd class'}

    TMsgWnd = class(TForm)
      procedure FormDestroy(Sender: TObject);
      procedure CreateParams(var Params: TCreateParams); override;
      procedure FormCreate(Sender: TObject);
    private
      procedure IncomingTrayMsg(var Msg: TMessage); message WM_COPYDATA;
    public
      FTrayClient : TObject;
      isClosing : boolean;
      procedure RegisterWithTray;
    end;
  {$ENDREGION}
  {$REGION 'TTrayItem Class'}

  TTrayItem    = class
                 private
                   FUID : Cardinal;
                   FWnd : Thandle;
                   FCallbackMessage : UINT;
                   FBitmap : TBitmap32;
                   FIcon   : hIcon;
                   FFlags  : Cardinal;
                   FBTimeOut : Cardinal;
                   FBInfoFlags : DWORD;
                   FOwner : TObject;
                 public
                   FTip : ArrayWideChar128;
                   FInfo : ArrayWideChar256;
                   FInfoTitle : ArrayWideChar64;
                   function AssignFromNIDv6(NIDv6 : TNotifyIconDataV6) : boolean;
                   constructor Create(NIDv6 : TNotifyIconDataV6); reintroduce;
                   destructor Destroy; override;
                 published
                   property UID : Cardinal read FUID;
                   property Wnd : THandle read FWnd;
                   property Bitmap : TBitmap32 read FBitmap;
                   property Icon   : hIcon read FIcon;
                   property CallbackMessage : UINT read FCallbackMessage;
                   property Flags : Cardinal read FFlags;
                   property BTimeout : Cardinal read FBTimeout;
                   property BInfoFlags : DWORD read FBInfoFlags;
                   property Owner : TObject read FOwner write FOwner;
                 end;
  {$ENDREGION}
  {$REGION 'TTrayClient Class'}

  TTrayClient = class
                 private
                   FMsgWnd: TMsgWnd;
                   FBalloonWnd : TBalloonForm;
                   FIconSize : integer;
                   FIconSpacing : integer;
                   FTopSpacing  : integer;
                   FItems : TObjectList;
                   FBitmap : TBitmap32;
                   FWinVersion : Cardinal;
                   FTipTimer : TTimer;
                   FTipWnd   : TTipForm;
                   FLastTipItem : TTrayItem;
                   FTipPoint : TPoint;
                   FTipGPoint : TPoint;
                   FColorBlend      : boolean;
                   FBlendColor      : integer;
                   FBlendAlpha      : integer;
                   FBackGroundColor : TColor32;
                   FBorderColor     : TColor32;
                   FDrawBackground  : boolean;
                   FDrawBorder      : boolean;
                   FBackgroundAlpha : integer;
                   FBorderAlpha     : integer;
                   FRepaintHash     : integer;
                   FScreenPos       : TPoint;
                   FLastMessage     : Int64;
                   FCS : TColorSchemeEx;
                   procedure FOnTipTimer(Sender : TObject);
                   procedure NewRepaintHash;
                 public
                   function  GetTrayIconIndex(pWnd : THandle; UID : Cardinal) : integer;
                   function  GetTrayIcon(pWnd : THandle; UID : Cardinal) : TTrayItem;
                   procedure AddOrModifyTrayIcon(NIDv6 : TNotifyIconDataV6);
                   procedure AddTrayIcon(NIDv6 : TNotifyIconDataV6);
                   procedure ModifyTrayIcon(NIDv6 : TNotifyIconDataV6);
                   procedure DeleteTrayIcon(NIDv6 : TNotifyIconDataV6);
                   procedure DeleteTrayIconByIndex(index : integer);
                   procedure RenderIcons;
                   procedure SpecialRender(target : TBitmap32; si, ei : integer);
                   function PerformIconAction(x,y,gx,gy,imod : integer; msg : uint) : boolean;
                   procedure StartTipTimer(x,y,gx,gy : integer);
                   procedure StopTipTimer;
                   function  GetIconPos(item : TTrayItem) : TPoint;
                   function  IconExists(item : TTrayItem) : Boolean;
                   procedure RegisterWithTray;
                   procedure ClearTrayIcons;
                   constructor Create; reintroduce;
                   destructor  Destroy; override;
                 published
                   property Items : TObjectList read FItems;
                   property Bitmap : TBitmap32 read FBitmap;
                   property IconSize : integer read FIconSize write FIconSize;
                   property IconSpacing : integer read FIconSpacing write FIconSpacing;
                   property TopSpacing  : integer read FTopSpacing write FTopSpacing;
                   property ColorBlend     : boolean read FColorBlend write FColorBlend;
                   property BlendColor     : integer read FBlendColor write FBlendColor;
                   property BlendAlpha     : integer read FBlendAlpha write FBlendAlpha;
                   property DrawBackground : boolean read FDrawBackground write FDrawBackground;
                   property DrawBorder     : boolean read FDrawBorder write FDrawBorder;
                   property BackGroundColor : TColor32 read FBackGroundColor write FBackgroundColor;
                   property BorderColor    : TColor32 read FBorderColor     write FBorderColor;
                   property BackgroundAlpha : integer read FBackgroundAlpha write FBackgroundAlpha;
                   property BorderAlpha    : integer read FBorderAlpha      write FBorderAlpha;
                   property RepaintHash    : integer read FRepaintHash      write FRepaintHash;
                   property ScreenPos      : TPoint  read FScreenPos        write FScreenPos;
                   property LastMessage    : Int64   read FLastMessage;
                   property CS : TColorSchemeEx read FCS write FCS;
                 end;
  {$ENDREGION}
{$ENDREGION}

{$R *.dfm}

implementation

{$REGION 'Tool functions'}
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
          if wincolor(new_rgb) = wincolor(color32(172,75,53)) then begin
            bmp.canvas.TextOut(0,0,inttostr(new_hsl.Hue))
          end;
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

function CodeToColor(ColorCode : integer; ColorScheme: TColorScheme) : integer;
begin
  case ColorCode of
   -1 : result := ColorScheme.Throbberback;
   -2 : result := ColorScheme.Throbberdark;
   -3 : result := ColorScheme.Throbberlight;
   -4 : result := ColorScheme.WorkAreaback;
   -5 : result := ColorScheme.WorkAreadark;
   -6 : result := ColorScheme.WorkArealight;
   else result := ColorCode;
  end;
end;

function CodeToColorEx(ColorCode : integer; ColorScheme: TColorSchemeEX) : integer;
begin
  case ColorCode of
   -1 : result := ColorScheme.Throbberback;
   -2 : result := ColorScheme.Throbberdark;
   -3 : result := ColorScheme.Throbberlight;
   -4 : result := ColorScheme.WorkAreaback;
   -5 : result := ColorScheme.WorkAreadark;
   -6 : result := ColorScheme.WorkArealight;
   -7 : result := ColorScheme.ThrobberText;
   -8 : result := ColorScheme.WorkAreaText;
   else result := ColorCode;
  end;
end;

function ColorToCodeEx(Color : integer; ColorScheme: TColorSchemeEX) : integer;
begin
  if      Color = ColorScheme.Throbberback  then result := -1
  else if Color = ColorScheme.Throbberdark  then result := -2
  else if Color = ColorScheme.Throbberlight then result := -3
  else if Color = ColorScheme.ThrobberText  then result := -7
  else if Color = ColorScheme.WorkAreaback  then result := -4
  else if Color = ColorScheme.WorkAreadark  then result := -5
  else if Color = ColorScheme.WorkArealight then result := -6
  else if Color = ColorScheme.WorkAreaText  then result := -8
  else result := Color;
end;

function ColorToCode(Color : integer; ColorScheme: TColorScheme) : integer;
begin
  if      Color = ColorScheme.Throbberback  then result := -1
  else if Color = ColorScheme.Throbberdark  then result := -2
  else if Color = ColorScheme.Throbberlight then result := -3
  else if Color = ColorScheme.WorkAreaback  then result := -4
  else if Color = ColorScheme.WorkAreadark  then result := -5
  else if Color = ColorScheme.WorkArealight then result := -6
  else result := Color;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

function GetCurrentMonitor : integer;
var
  n : integer;
  CPos : TPoint;
begin
  CPos := Mouse.Cursorpos;
  for n := 0 to Screen.MonitorCount - 1 do
      if PointInRect(CPos,Screen.Monitors[n].BoundsRect) then
      begin
        result := n;
        exit;
      end;
  // something went wrong and the cursor isn't in any monitor
  result := 0;
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
{$ENDREGION}
{$REGION 'TMsgWnd'}

procedure TMsgWnd.RegisterWithTray;
begin
  PostMessage(FindWindow('Shell_TrayWnd',nil),WM_REGISTERWITHTRAY,handle,0);
end;

procedure TMsgWnd.CreateParams(var Params: TCreateParams);
begin
  try
    inherited CreateParams(Params);
    with Params do
    begin
      Params.WinClassName := 'SharpETrayModuleMsgWnd';
      ExStyle := WS_EX_TOOLWINDOW or WS_EX_TOPMOST;
      Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
    end;
  except
    on E: Exception do
   //   SendTrayErrorMessage('Problem creating MainWindow', E);
  end;
end;

procedure TMsgWnd.IncomingTrayMsg(var Msg: TMessage);
var
  TrayCmd: integer;
  Icondata: TNotifyIconDataV6;
  data: pCopyDataStruct;
begin
  if isClosing then exit;
  try
    Data := pCopyDataStruct(Msg.LParam);
    if (Data.dwData = 1) or (Data.dwData = 2) then
    begin
      TrayCmd := Data.dwData;
      Icondata := pNotifyIconDataV6(Data.lpdata)^;
      case TrayCmd of
        1 : begin
              TTrayClient(FTrayClient).AddOrModifyTrayIcon(IconData);
            end;

        2 : begin
              TTrayClient(FTrayClient).DeleteTrayIcon(IconData);
            end;
        end;
      //important to return value <> 0
      msg.Result := 5;
    end
    else
      msg.Result := DefWindowProc(Handle, Msg.Msg, Msg.WParam, Msg.LParam);
  except
    msg.Result := DefWindowProc(Handle, Msg.Msg, Msg.WParam, Msg.LParam);
  end;
end;

procedure TMsgWnd.FormCreate(Sender: TObject);
begin
  isClosing := False;
  left := -200;
  top := -200;
  Width := 1;
  Height := 1;
  PostMessage(FindWindow('Shell_TrayWnd',nil),WM_REGISTERWITHTRAY,handle,0);
end;

procedure TMsgWnd.FormDestroy(Sender: TObject);
begin
  isClosing := True;
  PostMessage(FindWindow('Shell_TrayWnd',nil),WM_UNREGISTERWITHTRAY,handle,0);
end;
{$ENDREGION}
{$REGION 'TTrayItem'}

constructor TTrayItem.Create(NIDv6 : TNotifyIconDataV6);
begin
  FBitmap := TBitmap32.Create;
  FBitmap.SetSize(16,16);
  AssignFromNIDv6(NIDv6);
  Inherited Create;
end;

destructor TTrayItem.Destroy;
begin
  FBitmap.Free;
  Inherited Destroy;
end;

// return value = True if icon changed
function TTrayItem.AssignFromNIDv6(NIDv6 : TNotifyIconDataV6) : boolean;
begin
  if NIDv6.uCallbackMessage <> 0 then
     FCallbackMessage := NIDv6.uCallbackMessage;
  FUID := NIDv6.UID;
  FWnd := NIDv6.Wnd;
  FTip := NIDv6.szTip;
  FInfo := NIDv6.szInfo;
  FInfoTitle := NIDv6.szInfoTitle;
  FBTimeOut := NIDv6.Union.uTimeOut;
  FBInfoFlags := NIDv6.Union.uVersion;
  FFlags := NIDv6.uFlags;

  if NIDv6.Icon <> FIcon then
  begin
    FIcon := NIDv6.Icon;
    FBitmap.Clear(color32(0,0,0,0));
    IconToImage(FBitmap,NIDv6.icon);
    result := True;
  end else result := False;
end;
{$ENDREGION}
{$REGION 'TTrayClient'}

constructor TTrayClient.Create;
begin
  inherited Create;
  Randomize;
  NewRepaintHash;
  FColorBlend := False;
  FBlendAlpha := 255;
  FBlendColor := 0;
  FDrawBackground := True;
  FDrawBorder := True;
  FBackgroundAlpha := 255;
  FBorderAlpha := 255;
  FIconSize := 16;
  FIconSpacing := 1;
  FTopSpacing  := 2;
  FLastMessage := DateTimeToUnix(now);
  FItems := TObjectList.Create;
  FItems.Clear;
  FBitmap := Tbitmap32.Create;
  FWinVersion := GetWinVer;
  FTipTimer := TTimer.Create(nil);
  FTipTimer.Interval := 500;
  FTipTimer.Enabled := False;
  FTipTimer.OnTimer := FOnTipTimer;
  FTipWnd := TTipForm.Create(nil);
  FTipWnd.Visible := False;
  FLastTipItem := nil;
  FBackGroundColor := Color32(128,128,128,128);
  FBorderColor     := Color32(0,0,0,128);

  FBalloonWnd := TBalloonForm.Create(nil);
  FBalloonWnd.TrayManager := self;

  FMsgWnd := TMsgWnd.Create(nil);
  FMsgWnd.FTrayClient := self;
end;

procedure TTrayClient.NewRepaintHash;
var
  n : integer;
begin
  repeat
    n := random(10000000);
  until n <> FRepaintHash;
  FRepaintHash := n;
end;

destructor TTrayClient.Destroy;
begin
  FMsgWnd.Free;
  FBalloonWnd.Free;
  FItems.Free;
  FBitmap.Free;
  FTipTimer.Enabled := False;
  FTipTimer.Free;
  FTipWnd.Free;
  inherited Destroy;
end;

function TTrayClient.IconExists(item : TTrayItem) : Boolean;
var
  n : integer;
begin
  for n := 0 to Fitems.Count -1 do
      if TTrayItem(Fitems.Items[n]) = item then
      begin
        result := true;
        exit;
      end;
  result := false;
end;

function TTrayClient.GetIconPos(item : TTrayItem) : TPoint;
var
  n : integer;
  x,y : integer;
begin
  x := FIconSize div 2;
  y := FIconSize div 2;
  for n := 0 to Fitems.Count -1 do
  begin
    if TTrayItem(Fitems.Items[n]) = item then
    begin
      result := Point(x,y);
      exit;
    end;
    x := x + FIconSize + FIconSpacing;
  end;
end;

procedure TTrayClient.ClearTrayIcons;
begin
  FItems.Clear;
  RenderIcons;
end;

procedure TTrayClient.RegisterWithTray;
begin
  if FMsgWnd = nil then exit;
  FMsgWnd.RegisterWithTray;
  FLastMessage := DateTimeToUnix(now);
end;

procedure TTrayClient.FOnTipTimer(Sender : TObject);
var
  tempItem : TTrayItem;
  n : integer;
  mon : TMonitor;
begin
  for n := 0 to FItems.Count - 1 do
  begin
    If PointInRect(Point(FTipPoint.x,FTipPoint.y),Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing)) then
    begin
      tempItem := TTrayItem(FItems.Items[n]);
      if TempItem.FTip = '' then
      begin
        StopTipTimer;
        exit;
      end;
      if FlastTipItem <> tempItem then
      begin
        FLastTipItem := tempItem;
        FTipWnd.InfoLabel.Caption := tempItem.FTip;
        FTipWnd.Width := FTipWnd.InfoLabel.Width +8; // FTipWnd.InfoLabel.Canvas.TextWidth(tempItem.Title)+16;
        FTipWnd.Height := FTipWnd.InfoLabel.Height + 6;
        FTipWnd.Top := FTipGPoint.Y - FTipWnd.Height - 1;
        FTipWnd.Left := FTipGPoint.X+2;
        mon := Screen.Monitors[GetCurrentMonitor];
        if FTipWnd.Left + FTipWnd.Width > mon.Left + mon.Width then
           FTipWnd.Left := mon.Left + mon.Width - FTipWnd.Width;
        if FTipWnd.Top < mon.top then
           FTipWnd.top := mon.top;
      end;
    end;
  end;

  if not FTipWnd.Visible then
     FTipWnd.Show;
end;

procedure TTrayClient.StartTipTimer(x,y,gx,gy : integer);
begin
  if FTipWnd.Visible then
  begin
    FTipPoint := Point(x,y);
    FTipGPoint := Point(gx,gy);
    FOnTipTimer(nil);
    exit;
  end;
  if (FTipPoint.X <> x) or (FTipPoint.Y <> y) then
  begin
    FTipTimer.Enabled := False;
    FTipTimer.Enabled := True;
    FTipPoint := Point(x,y);
    FTipGPoint := Point(gx,gy);
  end;
end;

procedure TTrayClient.StopTipTimer;
begin
 FTipTimer.Enabled := False;
 FTipWnd.Hide;
 FLastTipItem := nil;
end;

procedure TTrayClient.AddTrayIcon(NIDv6 : TNotifyIconDataV6);
var
  tempItem : TTrayItem;
begin
  tempItem := TTrayItem.Create(NIDv6);
  tempItem.Owner := self;
  FItems.Add(TempItem);
  RenderIcons;
end;

function  TTrayClient.GetTrayIcon(pWnd : THandle; UID : Cardinal) : TTrayItem;
var
  n : integer;
begin
  for n := 0 to FItems.Count -1 do
      if (TTrayItem(FItems.Items[n]).Wnd = pWnd) and (TTrayItem(FItems.Items[n]).UID = UID) then
      begin
        result := TTrayItem(Fitems.Items[n]);
        exit;
      end;
  result := nil;
end;

function  TTrayClient.GetTrayIconIndex(pWnd : THandle; UID : Cardinal) : integer;
var
  n : integer;
begin
  for n := 0 to FItems.Count -1 do
      if (TTrayItem(FItems.Items[n]).Wnd = pWnd) and (TTrayItem(FItems.Items[n]).UID = UID) then
      begin
        result := n;
        exit;
      end;
  result := -1;
end;

procedure TTrayClient.AddOrModifyTrayIcon(NIDv6 : TNotifyIconDataV6);
var
  item : TTrayItem;
begin
  FlastMessage := DateTimeToUnix(now);
  if GetTrayIconIndex(NIDv6.wnd,NIDv6.UID) = -1 then AddTrayIcon(NIDv6)
     else ModifyTrayIcon(NIDv6);
  if (NIDv6.uFlags and NIF_INFO) = NIF_INFO then
  begin
    item := GetTrayIcon(NIDv6.Wnd,NIDv6.UID);
    if item <> nil then
       if (length(trim(item.FInfo))>0)
          or (length(trim(item.FInfoTitle))>0) then FBalloonWnd.AddBallonTip(item);
  end;
end;

procedure TTrayClient.ModifyTrayIcon(NIDv6 : TNotifyIconDataV6);
var
  tempItem : TTrayItem;
begin
  tempItem := GetTrayIcon(NIDv6.wnd,NIDv6.UID);
  if tempItem <> nil then
  begin
    if TempItem.AssignFromNIDv6(NIDv6) then RenderIcons;
    if FTipWnd.Visible then
    begin
      if TempItem = FlastTipItem then
      begin
        FlastTipItem := nil;
        FOnTipTimer(nil);
      end;
    end;
  end;
end;

procedure TTrayClient.DeleteTrayIcon(NIDv6 : TNotifyIconDataV6);
var
  n : integer;
  temp : TTrayItem;
begin
  n := GetTrayIconIndex(NIDv6.Wnd,NIDv6.UID);
  if n <> -1 then
  begin
    temp := TTrayItem(FItems.Items[n]);
    FItems.Extract(temp);
    FreeAndNil(Temp);
    RenderIcons;
  end;
end;

procedure TTrayClient.DeleteTrayIconByIndex(index : integer);
begin
  if index > FItems.Count - 1 then exit;
  Fitems.Delete(index);
  RenderIcons;
end;

procedure TTrayClient.RenderIcons;
var
  n : integer;
  tempItem : TTrayItem;
  w, h : integer;
  tempBmp : TBitmap32;
begin
  for n := FItems.Count -1 downto 0 do
  begin
    tempItem := TTrayItem(FItems.Items[n]);
    if not iswindow(tempItem.Wnd) then
       DeleteTrayIconByIndex(n);
  end;

  tempBmp := TBitmap32.Create;
  tempBmp.DrawMode := dmBlend;
  tempBmp.CombineMode := cmMerge;
  try
    w := FItems.Count * (FIconSize + FIconSpacing)+2*FTopSpacing;
    h := FIconSize + 2*FTopSpacing;
    FBitmap.SetSize(w,h);
    FBitmap.Clear(color32(0,0,0,0));
    if FDrawBorder then
    begin
      FBitmap.FillRect(0,0,FBitmap.Width,FBitmap.Height,ColorToColor32Alpha(CodeToColorEx(FBorderColor,FCS),FBorderAlpha));
      FBitmap.FillRect(1,1,FBitmap.Width-1,FBitmap.Height-1,Color32(0,0,0,0));
    end;
    if FDrawBackground then FBitmap.FillRect(1,1,FBitmap.Width-1,FBitmap.Height-1,ColorToColor32Alpha(CodeToColorEx(FBackgroundColor,FCS),FBackgroundAlpha));
    for n := 0 to FItems.Count - 1 do
    begin
      tempItem := TTrayItem(FItems.Items[n]);
      tempItem.Bitmap.DrawMode := dmBlend;
      if FColorBlend then
      begin
        tempBmp.SetSize(tempItem.Bitmap.Width,tempItem.Bitmap.Height);
        tempBmp.Clear(color32(0,0,0,0));
        tempItem.Bitmap.DrawTo(tempBmp);
        BlendImageA(tempBmp,CodeToColorEx(FBlendColor,FCS),FBlendAlpha);
        tempBmp.DrawTo(FBitmap,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
      end else tempItem.Bitmap.DrawTo(FBitmap,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
    end;
    NewRepaintHash;
  finally
    tempBmp.Free;
  end;
end;

procedure TTrayClient.SpecialRender(target : TBitmap32; si, ei : integer);
var
  n : integer;
  tempItem : TTrayItem;
  w, h : integer;
  tempBmp : TBitmap32;
begin
  tempBmp := TBitmap32.Create;
  tempBmp.DrawMode := dmBlend;
  tempBmp.CombineMode := cmMerge;
  try
    w := abs(ei-si) * (FIconSize + FIconSpacing) + 2*FTopSpacing;
    h := FIconSize + 2*FTopSpacing;
    target.SetSize(w,h);
    target.Clear(color32(0,0,0,0));
    if FDrawBorder then
    begin
      target.FillRect(0,0,target.Width,target.Height,ColorToColor32Alpha(CodeToColorEx(FBorderColor,FCS),FBorderAlpha));
      target.FillRect(1,1,target.Width-1,target.Height-1,Color32(0,0,0,0));
    end;
    if FDrawBackground then target.FillRect(1,1,target.Width-1,target.Height-1,ColorToColor32Alpha(CodeToColorEx(FBackgroundColor,FCS),FBackgroundAlpha));
    for n := 0 to abs(ei-si)-1 do
    begin
      if si+n < FItems.Count then
      begin
        tempItem := TTrayItem(FItems.Items[si+n]);
        tempItem.Bitmap.DrawMode := dmBlend;
        if FColorBlend then
        begin
          tempBmp.SetSize(tempItem.Bitmap.Width,tempItem.Bitmap.Height);
          tempBmp.Clear(color32(0,0,0,0));
          tempItem.Bitmap.DrawTo(tempBmp);
          BlendImageA(tempBmp,CodeToColorEx(FBlendColor,FCS),FBlendAlpha);
          tempBmp.DrawTo(target,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
        end else tempItem.Bitmap.DrawTo(target,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
      end;
    end;
    NewRepaintHash;
  finally
    tempBmp.Free;
  end;
end;

function TTrayClient.PerformIconAction(x,y,gx,gy,imod : integer; msg : uint) : boolean;
var
  n : integer;
  tempItem : TTrayItem;
begin
  result := false;
  for n := 0 to FItems.Count - 1 do
  begin
    if PointInRect(Point(x,y),Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing)) then
    if n + imod < FItems.Count then
    begin
      tempItem := TTrayItem(FItems.Items[n+imod]);
      if not iswindow(tempItem.Wnd) then
      begin
        DeleteTrayIconByIndex(n+imod);
        StopTipTimer;
        exit;
      end;
      result := true;
      case Msg of
        WM_MOUSEMOVE:
        begin
          StartTipTimer(x,y,gx,gy);
          postmessage(tempItem.Wnd, tempItem.CallbackMessage,tempItem.uID, Msg);
        end;
        WM_LBUTTONUP :
        begin
          StopTipTimer;
          SetForegroundWindow(tempItem.Wnd);
          postmessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID, WM_LBUTTONDOWN);
          postmessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID, WM_LBUTTONUP);
        end;
        WM_RBUTTONUP :
        begin
          StopTipTimer;
          SetForegroundWindow(tempItem.Wnd);
          postmessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID,WM_CONTEXTMENU);
          postmessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID, WM_RBUTTONDOWN);
          postmessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID, WM_RBUTTONUP);
        end;
        WM_LBUTTONDBLCLK :
        begin
          StopTipTimer;
          SetForegroundWindow(tempItem.wnd);
          postmessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID,WM_LBUTTONDBLCLK);
        end;
        else if (Msg <> WM_RBUTTONDOWN) then
        begin
          StopTipTimer;
          postmessage(tempItem.Wnd, tempItem.CallbackMessage,tempItem.uID, Msg);
        end;
      end;
      exit;
    end;
  end;
  StopTipTimer;
end;
{$ENDREGION}

end.
