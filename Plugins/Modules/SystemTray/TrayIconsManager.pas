{
Source Name: TrayIconsManager
Description: Icon messaging and handling class
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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
     SharpThemeApi,
     GR32_Filters,
     GR32_Resamplers,
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

    TTrayChangeEvent = (tceIcon,tceTip,tceVersion);
    TTrayChangeEvents = Set of TTrayChangeEvent;

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
                   FTipIndex : integer;
                 public
                   FTip : ArrayWideChar128;
                   FInfo : ArrayWideChar256;
                   FInfoTitle : ArrayWideChar64;
                   function AssignFromNIDv6(NIDv6 : TNotifyIconDataV7) : TTrayChangeEvents;
                   constructor Create(NIDv6 : TNotifyIconDataV7); reintroduce;
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
                   property TipIndex : integer read FTipIndex write FTipIndex;
                 end;
  {$ENDREGION}
  {$REGION 'TTrayClient Class'}

  TTrayClient = class
                 private
                   FMsgWnd: TMsgWnd;
                   FWndList : TObjectList;
                   FBalloonWnd : TBalloonForm;
                   FV4Popup : TTrayItem;
                   FIconSize : integer;
                   FIconSpacing : integer;
                   FTopSpacing  : integer;
                   FItems : TObjectList;
                   FBitmap : TBitmap32;
                   FWinVersion : Cardinal;
                   FTipTimer : TTimer;
                   FLastTipItem : TTrayItem;
                   FTipPoint : TPoint;
                   FTipGPoint : TPoint;
                   FIconAlpha       : integer;
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
                   procedure FOnTipTimer(Sender : TObject);
                   procedure NewRepaintHash;
                 public
                   function  GetTrayIconIndex(pWnd : THandle; UID : Cardinal) : integer;
                   function  GetTrayIcon(pWnd : THandle; UID : Cardinal) : TTrayItem;
                   procedure AddOrModifyTrayIcon(NIDv6 : TNotifyIconDataV7);
                   procedure AddTrayIcon(NIDv6 : TNotifyIconDataV7);
                   procedure ModifyTrayIcon(NIDv6 : TNotifyIconDataV7);
                   procedure DeleteTrayIcon(NIDv6 : TNotifyIconDataV7);
                   procedure DeleteTrayIconByIndex(index : integer);
                   procedure RenderIcons;
                   procedure SpecialRender(target : TBitmap32; si, ei : integer);
                   function PerformIconAction(x,y,gx,gy,imod : integer; msg : uint; parent : TForm) : boolean;
                   procedure StartTipTimer(x,y,gx,gy : integer);
                   procedure StopTipTimer;
                   procedure CloseVistaInfoTip;
                   function  GetIconPos(item : TTrayItem) : TPoint;
                   function  IconExists(item : TTrayItem) : Boolean;
                   procedure RegisterWithTray;
                   procedure ClearTrayIcons;
                   procedure SetBorderColor(Value : TColor32);
                   procedure SetBackgroundColor(Value : TColor32);
                   procedure SetBlendColor(Value : integer);
                   procedure SetBorderAlpha(Value : integer);
                   procedure SetBackgroundAlpha(Value : integer);
                   procedure SetBlendAlpha(Value : integer);
                   procedure SetIconAlpha(Value : integer);
                   procedure PositionTrayWindow(x,y : integer; parent : TForm);
                   procedure AddWindow(wnd : TObject);
                   procedure RemoveWindow(wnd : TObject);
                   function GetFreeTipIndex : integer;
                   constructor Create; reintroduce;
                   destructor  Destroy; override;
                 published
                   property Items : TObjectList read FItems;
                   property Bitmap : TBitmap32 read FBitmap;
                   property IconAlpha : integer read FIconAlpha write SetIconAlpha;
                   property IconSize : integer read FIconSize write FIconSize;
                   property IconSpacing : integer read FIconSpacing write FIconSpacing;
                   property TopSpacing  : integer read FTopSpacing write FTopSpacing;
                   property ColorBlend     : boolean read FColorBlend write FColorBlend;
                   property BlendColor     : integer read FBlendColor write SetBlendColor;
                   property BlendAlpha     : integer read FBlendAlpha write SetBlendAlpha;
                   property DrawBackground : boolean read FDrawBackground write FDrawBackground;
                   property DrawBorder     : boolean read FDrawBorder write FDrawBorder;
                   property BackGroundColor : TColor32 read FBackGroundColor write SetBackgroundColor;
                   property BorderColor    : TColor32 read FBorderColor     write SetBorderColor;
                   property BackgroundAlpha : integer read FBackgroundAlpha write SetBackgroundAlpha;
                   property BorderAlpha    : integer read FBorderAlpha      write SetBorderAlpha;
                   property RepaintHash    : integer read FRepaintHash      write FRepaintHash;
                   property ScreenPos      : TPoint  read FScreenPos        write FScreenPos;
                   property LastMessage    : Int64   read FLastMessage;
                   property LastTipItem    : TTrayItem read FLastTipItem;
                   property TipGPoint      : TPoint read FTipGPoint;
                   property WndList        : TObjectList read FWndList;
                 end;
  {$ENDREGION}
{$ENDREGION}

function AllowSetForegroundWindow(ProcessID : DWORD) : boolean; stdcall; external 'user32.dll' name 'AllowSetForegroundWindow';

{$R *.dfm}

implementation

uses ToolTipApi,MainWnd;


type

  TTrayWnd = class
             public
               Wnd : TMainForm;
               TipWnd : hwnd;
             end;


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
  Icondata: TNotifyIconDataV7;
  data: pCopyDataStruct;
begin
  if isClosing then exit;
  try
    Data := pCopyDataStruct(Msg.LParam);
    if (Data.dwData = 1) or (Data.dwData = 2) then
    begin
      TrayCmd := Data.dwData;
      Icondata := pNotifyIconDataV7(Data.lpdata)^;
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

constructor TTrayItem.Create(NIDv6 : TNotifyIconDataV7);
begin
  FBitmap := TBitmap32.Create;
  FBitmap.SetSize(16,16);
  TLinearResampler.Create(FBitmap);
  AssignFromNIDv6(NIDv6);
  Inherited Create;
end;

destructor TTrayItem.Destroy;
begin
  FBitmap.Free;
  Inherited Destroy;
end;

// return value = True if icon changed
function TTrayItem.AssignFromNIDv6(NIDv6 : TNotifyIconDataV7) : TTrayChangeEvents;
var
  oTip : String;
  oVersion : integer;
begin
  result := [];
  if NIDv6.uCallbackMessage <> 0 then
     FCallbackMessage := NIDv6.uCallbackMessage;
  FUID := NIDv6.UID;
  FWnd := NIDv6.Wnd;

  oTip := FTip;
  FTip := NIDv6.szTip;
  if CompareText(oTip,FTip) <> 0 then
     result := result + [tceTip];

  FInfo := NIDv6.szInfo;
  FInfoTitle := NIDv6.szInfoTitle;
  FBTimeOut := NIDv6.Union.uTimeOut;

  oVersion := NIDv6.Union.uVersion;
  FBInfoFlags := NIDv6.Union.uVersion;
  if oVersion <> FBInfoFlags then
     result := result + [tceVersion];

  FFlags := NIDv6.uFlags;

  if NIDv6.Icon <> FIcon then
  begin
    FIcon := NIDv6.Icon;
    FBitmap.Clear(color32(0,0,0,0));
    IconToImage(FBitmap,NIDv6.icon);
    result := result + [tceIcon];
  end;
end;
{$ENDREGION}
{$REGION 'TTrayClient'}

constructor TTrayClient.Create;
begin
  inherited Create;
  Randomize;
  NewRepaintHash;
  FWndList := TObjectList.Create(True);
  FWndList.Clear;
  FColorBlend := False;
  FIconAlpha  := 255;
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
  FLastTipItem := nil;
  FBackGroundColor := Color32(128,128,128,128);
  FBorderColor     := Color32(0,0,0,128);

  FBalloonWnd := TBalloonForm.Create(nil);
  FBalloonWnd.TrayManager := self;


  FMsgWnd := TMsgWnd.Create(nil);
  FMsgWnd.FTrayClient := self;
end;

procedure TTrayClient.AddWindow(wnd : TObject);
var
  item : TTrayWnd;
  item2 : TTrayItem;
  n : integer;
begin
  item := TTrayWnd.Create;
  item.Wnd := TMainForm(wnd);
  item.TipWnd := ToolTipApi.RegisterToolTip(TMainForm(wnd));
  FWndList.Add(item);
  for n := 0 to FItems.Count - 1 do
  begin
    item2 := TTrayItem(FItems.Items[n]);
    ToolTipApi.AddToolTipByCallback(item.TipWnd,
                                    item.Wnd,
                                    item2.TipIndex,
                                    Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
  end;
end;

procedure TTrayClient.RemoveWindow(wnd : TObject);
var
  n,i : integer;
begin
  for n := 0 to FWndList.Count - 1 do
      if TTrayWnd(FWndList.Items[n]).wnd = wnd then
      begin
        for i := 0 to FItems.Count - 1 do
            ToolTipApi.DeleteToolTip(TTrayWnd(FWndList.Items[n]).TipWnd,
                                     TTrayWnd(FWndList.Items[n]).Wnd,     
                                     TTrayItem(FItems).TipIndex);
        DestroyWindow(TTrayWnd(FWndList.Items[n]).TipWnd);
        FWndList.Delete(n);
        exit;
      end; 
end;

procedure TTrayClient.SetIconAlpha(Value : integer);
begin
  if Value <> FIconAlpha then
  begin
    FIconAlpha := min(255,max(0,Value));
  end;
end;

procedure TTrayClient.SetBorderColor(Value : TColor32);
begin
  if Value <> FBorderColor then
  begin
    FBorderColor := ColorToColor32Alpha(SchemeCodeToColor(Value),FBorderAlpha);
  end;
end;

procedure TTrayClient.SetBackgroundColor(Value : TColor32);
begin
  if Value <> FBackgroundColor then
  begin
    FBackgroundColor := ColorToColor32Alpha(SchemeCodeToColor(Value),FBackgroundAlpha);
  end;
end;

procedure TTrayClient.SetBorderAlpha(Value : integer);
begin
  if Value <> FBorderAlpha then
  begin
    FBorderAlpha := Value;
    FBorderColor := ColorToColor32Alpha(SchemeCodeToColor(WinColor(FBorderColor)),FBorderAlpha);
  end;
end;

procedure TTrayClient.SetBackgroundAlpha(Value : integer);
begin
  if Value <> FBackgroundAlpha then
  begin
    FBackgroundAlpha := Value;
    FBackgroundColor := ColorToColor32Alpha(SchemeCodeToColor(WinColor(FBackgroundColor)),FBackgroundAlpha);
  end;
end;

procedure TTrayClient.SetBlendColor(Value : integer);
begin
  if Value <> FBlendColor then
  begin
    FBlendColor := SchemeCodeToColor(Value);
  end;
end;

procedure TTrayClient.SetBlendAlpha(Value : integer);
begin
  if Value <> FBlendAlpha then
  begin
    FBlendAlpha := Value;
  end;
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
  FWndList.Free;
  FMsgWnd.Free;
  if FBalloonWnd.Visible then FBalloonWnd.Close;
  FBalloonWnd.Free;
  FItems.Free;
  FBitmap.Free;
  FTipTimer.Enabled := False;
  FTipTimer.Free;
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
  wp : wparam;
  lp : lparam;
begin

  // Vista Popup?
  if (FV4Popup <> nil) then
  begin
    FLastTipItem := nil;
    FTipTimer.Enabled := False;

    wp := MakeLParam(FTipGPoint.x,FTipGPoint.y);
    lp := MakeLParam(NIN_POPUPOPEN,FV4Popup.uID);
    SendMessage(FV4Popup.Wnd,FV4Popup.CallbackMessage,wp,lp);

    exit;
  end;
end;

procedure TTrayClient.StartTipTimer(x,y,gx,gy : integer);
begin
  if (FTipPoint.X <> x) or (FTipPoint.Y <> y) then
  begin
    FTipTimer.Enabled := False;
    FTipTimer.Enabled := True;
    FTipPoint := Point(x,y);
    FTipGPoint := Point(gx,gy);
  end;
end;

procedure TTrayClient.CloseVistaInfoTip;
var
  wp : wparam;
  lp : lparam;
  n : integer;
begin
  if (FV4Popup <> nil) then
  begin
    wp := MakeWParam(0,0);
    lp := MakeLParam(NIN_POPUPCLOSE,FV4Popup.uID);
    SendMessage(FV4Popup.Wnd,FV4Popup.CallbackMessage,wp,lp);
    FV4Popup := nil;
    for n := 0 to FWndList.Count - 1 do
        ToolTipApi.EnableToolTip(TTrayWnd(FWndList.Items[n]).TipWnd);
  end;
end;

procedure TTrayClient.StopTipTimer;
begin
  FTipTimer.Enabled := False;
  FLastTipItem := nil;
end;

function TTrayClient.GetFreeTipIndex : integer;
var
  b : boolean;
  n : integer;
  i : integer;
begin
  i := -1;
  repeat
    i := i + 1;
    b := True;
    for n := 0 to FItems.Count - 1 do
        if TTrayItem(FItems.Items[n]).TipIndex = i then
        begin
          b := False;
          break;
        end;
  until b;
  result := i;
end;

procedure TTrayClient.AddTrayIcon(NIDv6 : TNotifyIconDataV7);
var
  tempItem : TTrayItem;
  i,n : integer;
begin
  tempItem := TTrayItem.Create(NIDv6);
  tempItem.Owner := self;
  tempItem.TipIndex := GetFreeTipIndex;
  FItems.Add(TempItem);
  n := FItems.Count - 1;
  for i := 0 to FWndList.Count - 1 do
      ToolTipApi.AddToolTipByCallback(TTrayWnd(FWndList.Items[i]).TipWnd,
                                      TTrayWnd(FWndList.Items[i]).Wnd,
                                      tempItem.TipIndex,
                                      Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));

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

procedure TTrayClient.AddOrModifyTrayIcon(NIDv6 : TNotifyIconDataV7);
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

procedure TTrayClient.ModifyTrayIcon(NIDv6 : TNotifyIconDataV7);
var
  tempItem : TTrayItem;
  rs : TTrayChangeEvents;
  k : integer;
begin
  tempItem := GetTrayIcon(NIDv6.wnd,NIDv6.UID);
  if tempItem <> nil then
  begin
    rs := TempItem.AssignFromNIDv6(NIDv6);
    if tceIcon in rs then RenderIcons;
    if tceTip in rs then
       for k := 0 to FWndList.Count - 1 do
           ToolTipApi.UpdateToolTipTextByCallback(TTrayWnd(FWndList.Items[k]).TipWnd,
                                                  TTrayWnd(FWndList.Items[k]).Wnd,
                                                  tempItem.TipIndex);
  end;
end;

procedure TTrayClient.DeleteTrayIcon(NIDv6 : TNotifyIconDataV7);
var
  n : integer;
begin
  n := GetTrayIconIndex(NIDv6.Wnd,NIDv6.UID);
  if (n <> -1) and (n < FItems.Count) then
     DeleteTrayIconByIndex(n);
end;

procedure TTrayClient.DeleteTrayIconByIndex(index : integer);
var
  i,k : integer;
  temp : TTrayItem;
begin
  if index > FItems.Count - 1 then exit;

  temp := TTrayItem(FItems.Items[index]);
  if index < FItems.Count - 1 then
     for k := 0 to FWndList.Count - 1 do
     begin
       ToolTipApi.DeleteToolTip(TTrayWnd(FWndList.Items[k]).TipWnd,
                                TTrayWnd(FWndList.Items[k]).Wnd,
                                temp.TipIndex);

       for i := index + 1 to FItems.Count - 1 do
           ToolTipApi.UpdateToolTipRect(TTrayWnd(FWndList.Items[k]).TipWnd,
                                        TTrayWnd(FWndList.Items[k]).Wnd,
                                        TTrayItem(FItems.Items[i]).TipIndex,
                                        Rect(FTopSpacing+(i-1)*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+(i-1)*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
    end;
  FItems.Extract(temp);
  FreeAndNil(Temp);
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
      FBitmap.FillRect(0,0,FBitmap.Width,FBitmap.Height,FBorderColor);
      FBitmap.FillRect(1,1,FBitmap.Width-1,FBitmap.Height-1,Color32(0,0,0,0));
    end;
    if FDrawBackground then FBitmap.FillRect(1,1,FBitmap.Width-1,FBitmap.Height-1,FBackgroundColor);
    for n := 0 to FItems.Count - 1 do
    begin
      tempItem := TTrayItem(FItems.Items[n]);
      tempItem.Bitmap.DrawMode := dmBlend;
      tempItem.Bitmap.MasterAlpha := FIconAlpha;
      if FColorBlend then
      begin
        tempBmp.SetSize(tempItem.Bitmap.Width,tempItem.Bitmap.Height);
        tempBmp.Clear(color32(0,0,0,0));
        tempItem.Bitmap.MasterAlpha := 255;
        tempItem.Bitmap.DrawTo(tempBmp);
        BlendImageA(tempBmp,FBlendColor,FBlendAlpha);
        tempBmp.MasterAlpha := FIconAlpha;
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
      target.FillRect(0,0,target.Width,target.Height,FBorderColor);
      target.FillRect(1,1,target.Width-1,target.Height-1,Color32(0,0,0,0));
    end;
    if FDrawBackground then target.FillRect(1,1,target.Width-1,target.Height-1,FBackgroundColor);
    for n := 0 to abs(ei-si)-1 do
    begin
      if si+n < FItems.Count then
      begin
        tempItem := TTrayItem(FItems.Items[si+n]);
        tempItem.Bitmap.DrawMode := dmBlend;
        tempItem.Bitmap.MasterAlpha := FIconAlpha;
        if FColorBlend then
        begin
          tempBmp.SetSize(tempItem.Bitmap.Width,tempItem.Bitmap.Height);
          tempBmp.Clear(color32(0,0,0,0));
          tempItem.Bitmap.MasterAlpha := 255;
          tempItem.Bitmap.DrawTo(tempBmp);
          BlendImageA(tempBmp,FBlendColor,FBlendAlpha);
          tempBmp.MasterAlpha := FIconAlpha;
          tempBmp.DrawTo(target,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
        end else tempItem.Bitmap.DrawTo(target,Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing));
      end;
    end;
    NewRepaintHash;
  finally
    tempBmp.Free;
  end;
end;

procedure TTrayClient.PositionTrayWindow(x,y : integer; parent : TForm);
var
  wnd : hwnd;
  wnd2 : hwnd;
  p : TPoint;
begin
  p := parent.ClientToScreen(Point(x,y));

  wnd := FindWindow('Shell_TrayWnd',nil);
  if wnd <> 0 then
  begin
    SetWindowPos(wnd,parent.Handle,p.x,p.y,0,0,SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW);
    if IsWindowVisible(wnd) then
       ShowWindow(wnd,SW_HIDE);

    wnd2 := FindWindowEx(wnd,0,'TrayNotifyWnd',nil);
    if wnd2 <> 0 then
    begin
      SetWindowPos(wnd2,wnd,0,0,parent.Width,parent.Height,SWP_NOZORDER or SWP_NOACTIVATE or SWP_HIDEWINDOW);
      if IsWindowVisible(wnd2) then
         ShowWindow(wnd2,SW_HIDE);
    end;
  end;
end;

function TTrayClient.PerformIconAction(x,y,gx,gy,imod : integer; msg : uint; parent : TForm) : boolean;
var
  n : integer;
  tempItem : TTrayItem;
  PID: DWORD;
  ix,iy : DWORD;
  lp : lparam;
  wp : wparam;
  i : integer;
begin
  result := false;
  for n := 0 to FItems.Count - 1 do
  begin
    if PointInRect(Point(x,y),Rect(FTopSpacing+n*(FIconSize + FIconSpacing),FTopSpacing,FTopSpacing+n*(FIconSize + FIconSpacing)+FIconSize,FIconSize+FTopSpacing)) then
    if n + imod < FItems.Count then
    begin
      tempItem := TTrayItem(FItems.Items[n+imod]);

      // Check if there was a tray icon which displayed a new Vista tooltip
      if (TempItem <> FV4Popup) and (FV4Popup <> nil) then
          CloseVistaInfoTip;

      if not iswindow(tempItem.Wnd) then
      begin
        DeleteTrayIconByIndex(n+imod);
        StopTipTimer;
        exit;
      end;
      result := true;

      GetWindowThreadProcessId(tempItem.Wnd, @PID);
      AllowSetForegroundWindow(PID);

{      SharpApi.SendDebugMessage('Module: SystemTray',PChar('Wnd:' + inttostr(tempItem.Wnd)
                                + ' | CallBack:' + inttostr(tempItem.CallbackMessage)
                                + ' | uID:' + inttostr(tempItem.uID)
                                + ' | uVersion:' + inttostr(tempItem.BInfoFlags)
                                + ' | Title:' + tempItem.FTip),0);}

      // reposition the tray window (some stupid shell services are using
      // it for positioning)
      PositionTrayWindow(x,0,parent);

      FLastTipItem := tempItem;
      if (tempItem.BInfoFlags >= 4) then
      begin
        // NotifyIcon Version > 4
        ix := gx;
        iy := gy;
        wp := MakeWParam(ix,iy);

        // Stop the tip timer on any other message
        if (msg <> WM_MOUSEMOVE) then
        begin
          StopTipTimer;
          CloseVistaInfoTip;
        end;

        lp := MakeLParam(msg,tempItem.uID);
        case msg of
          WM_MOUSEMOVE: begin
                          // Tooltip check
                          if not ((tempItem.Flags and NIF_SHOWTIP) = NIF_SHOWTIP) then
                          begin
                            FV4Popup := tempItem;
                            StartTipTimer(x,y,gx,gy);
                            for i := 0 to FWndList.Count - 1 do
                                ToolTipApi.DisableToolTip(TTrayWnd(FWndList.Items[i]).TipWnd);
                          end;
                        end;
          WM_RBUTTONUP: begin
                          lp := MakeLParam(WM_RBUTTONUP,tempItem.uID);
                          SendMessage(tempItem.Wnd,tempItem.CallbackMessage,wp,lp);
                          lp := MakeLParam(WM_CONTEXTMENU,tempItem.uID);
                        end;
        end;
        SendMessage(tempItem.Wnd,tempItem.CallbackMessage,wp,lp);
      end else
      begin
        // NotifyIcon Version < 4
        if msg = WM_RBUTTONUP then
           PostMessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID,WM_CONTEXTMENU);
        PostMessage(tempItem.Wnd,tempItem.CallbackMessage,tempItem.uID,msg);
      end;
    end;
  end;
end;
{$ENDREGION}

end.
