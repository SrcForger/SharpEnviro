{
Source Name: uTaskPreviewWnd.pas
Description: Task Item Preview Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uTaskPreviewWnd;

interface

uses
  Windows, Classes, Messages, Types, SysUtils, DwmApi, GR32, ISharpESkinComponents;

type

  TTaskPreviewClickEvent = procedure(Sender : TObject) of object;
  TTaskPreviewWnd = class
    private
      FX,FY : integer;
      FWnd : hwnd;
      FTaskWnd : hwnd;
      FBitmap : TBitmap32;
      FSpecialBG : TBitmap32;
      FSkinManager : ISharpESkinManager;
      FBlend : TBlendFunction;
      FHover : boolean;
      FAllowHover : boolean;
      FCaption : String;
      FOnPreviewClick : TTaskPreviewClickEvent;
      FLockKey : integer;

      fproc: TFarproc;

      // dwm properties
      FdwmThumbID : Cardinal;
      FdwmThumbProps : DWM_THUMBNAIL_PROPERTIES;

      procedure RenderImage;
      procedure RenderSpecial;
      procedure UpdateWndLayer;
      procedure WndProc(var msg: TMessage);
    public
      constructor Create(pTaskWnd : hwnd; pPopupDown : boolean; pX,pY : integer;
                         pSize : integer; pSkinManager : ISharpESkinManager;
                         pCaption : WideString; pAnimate : boolean; pAllowHover : boolean); reintroduce;
      destructor Destroy; override;
      procedure HideWindow(pAnimate : boolean);

      property TaskWnd : hwnd read FTaskWnd;
      property Wnd : hwnd read FWnd;
      property AllowHover : boolean read FAllowHover;
      property OnPreviewClick : TTaskPreviewClickEvent read FOnPreviewClick write FOnPreviewClick;
      property LockKey : integer read FLockKey write FLockKey;
  end;

function PlainWinProc(hWnd : hwnd; Msg, wParam, lParam: Integer): Cardinal; export; stdcall; forward;
function SwitchToThisWindow(Wnd : hwnd; fAltTab : boolean) : boolean; stdcall; external 'user32.dll';

implementation

uses
  SharpThemeApiEx,uISharpETheme,uThemeConsts,GR32Utils,Graphics,SharpGraphicsUtils;

var
  SharpETaskPreviewClassRegistered : boolean;
  SharpETaskPreviewWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @PlainWinProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 1;
    lpszMenuName: nil;
    lpszClassName: 'SharpETaskPreviewWnd');

function PlainWinProc(hWnd : hwnd; Msg, wParam, lParam: Integer): Cardinal; export; stdcall;
begin
  Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

procedure TTaskPreviewWnd.WndProc(var msg: TMessage);
var
  tme: TTRACKMOUSEEVENT;
  Locked : boolean;
  TrackMouseEvent_: function(var EventTrack: TTrackMouseEvent): BOOL; stdcall;
begin
  if Msg.Msg = WM_MOUSEMOVE then
  begin
    if AllowHover then
    begin
      tme.cbSize := sizeof(TTRACKMOUSEEVENT);
      tme.dwFlags := TME_HOVER or TME_LEAVE;
      tme.dwHoverTime := 10;
      tme.hwndTrack := FWnd;
      @TrackMouseEvent_:= @TrackMouseEvent; // nur eine Pointerzuweisung!!!
      TrackMouseEvent_(tme);
      if not FHover then
      begin
        FHover := True;
        RenderImage;
        RenderSpecial;
        UpdateWndLayer;
      end;
    end;
  end else if Msg.Msg = WM_MOUSELEAVE then
  begin
    if AllowHover then
    begin
      if FHover then
      begin
        FHover := False;
        RenderImage;
        RenderSpecial;
        UpdateWndLayer;
      end;
    end;
  end else if Msg.Msg = WM_LBUTTONUP then
  begin
    if AllowHover then
    begin
      SwitchToThisWindow(FTaskWnd,True);
      HideWindow(False);
      case FLockKey of
        0: Locked := ((Msg.Wparam and MK_CONTROL) = MK_CONTROL)
        else Locked := ((Msg.Wparam and MK_SHIFT) = MK_SHIFT)
      end;
      if not Locked then
      begin
        if Assigned(FOnPreviewClick) then
          FOnPreviewClick(self);
      end;
    end;
  end else if Msg.Msg = WM_MBUTTONUP then
  begin
    if AllowHover then
    begin
      PostMessage(FTaskWnd, WM_CLOSE, 0, 0);
      PostThreadMessage(GetWindowThreadProcessID(FTaskWnd, nil), WM_QUIT, 0, 0);
      case FLockKey of
        0: Locked := ((Msg.Wparam and MK_CONTROL) = MK_CONTROL)
        else Locked := ((Msg.Wparam and MK_SHIFT) = MK_SHIFT)
      end;
      if not Locked then
      begin
        HideWindow(True);
        if Assigned(FOnPreviewClick) then
          FOnPreviewClick(self);
      end else HideWindow(False);
    end;
  end;
  
  msg.Result:= DefWindowProc(FWnd, Msg.Msg, Msg.WParam, Msg.LParam);
end;

procedure PreMul(Bitmap: TBitmap32);
const
  w = Round($10000 * (1/255));
var
  p: PColor32;
  c: TColor32;
  i,a: integer;
  r,g,b: byte;
begin
  p:= Bitmap.PixelPtr[0,0];
  for i:= 0 to Bitmap.Width * Bitmap.Height - 1 do begin
    c:= p^;
    a:= (c shr 24) * w ;
    r:= c shr 16 and $FF; r:= r * a shr 16;
    g:= c shr 8 and $FF; g:= g * a shr 16;
    b:= c and $FF; b:= b * a shr 16;
    p^:= (c and $FF000000) or r shl 16 or g shl 8 or b;
    inc(p);
  end;
end;

{ TTaskPreviewWnd }

function FixCaption(bmp : TBitmap32; Caption : WideString; MaxWidth : integer) : WideString;
var
  n : integer;
  count : integer;
  s : WideString;
begin
  if bmp.TextWidthW(Caption) <= MaxWidth then result := Caption
  else
  begin
    count := length(Caption);
    s := '';
    n := 0;
    repeat
      n := n + 1;
      s := s + Caption[n];
    until (bmp.TextWidthW(s) > MaxWidth) or (n >= count);
    if length(s)>=4 then
    begin
      setlength(s,length(s)-4);
      s := s + '...';
    end else s := '';
    result := s;
  end;
end;

constructor TTaskPreviewWnd.Create(pTaskWnd : hwnd; pPopupDown : boolean; pX,pY : integer;
                                   pSize : integer; pSkinManager : ISharpESkinManager;
                                   pCaption : WideString; pAnimate : boolean; pAllowHover : boolean);
var
  TPS : ISharpETaskPreviewSkin;
  xmod,ymod : integer;
  dst : TRect;
  hr : hresult;
  size : TSize;
  w,h : integer;
begin
  inherited Create;

  FSkinManager := pSkinManager;
  FTaskWnd := pTaskWnd;
  FHover := False;
  FCaption := pCaption;
  FAllowHover := pAllowHover;
  FLockKey := 1; // Shift;

  // set dwm thumnail properties
  with FdwmThumbProps do
  begin
    dwFlags := DWM_TNP_RECTDESTINATION or DWM_TNP_VISIBLE or DWM_TNP_SOURCECLIENTAREAONLY;
    fSourceClientAreaOnly := False;
    fVisible := True;
    opacity := 255;
  end;

  fproc := Classes.MakeObjectInstance(WndProc);
  FWnd := CreateWindowEx(WS_EX_LAYERED or WS_EX_TOPMOST or WS_EX_TOOLWINDOW,
                         SharpETaskPReviewWndClass.lpszClassName, 'SharpETaskPreviewWnd',
                         WS_POPUP,
                         0, 0, 100, 100, 0, 0, hInstance, nil);

  // Init Thumbnail API                         
  if FWnd <> 0 then
  begin
    SetWindowlong(FWnd, GWL_WNDPROC, longword(fproc));
    hr := dwmapi.DwmRegisterThumbnail(FWnd,pTaskWnd,FdwmThumbID);
    if SUCCEEDED(hr) then
    begin
      TPS := FSkinManager.Skin.TaskPreview;

      // size properly
      DwmQueryThumbnailSourceSize(FdwmThumbID,@Size);
      w := pSize;
      h := round(Size.cy * (w - TPS.CALROffset.X - TPS.CALROffset.Y) / Size.cx)
           + TPS.CATBOffset.X + TPS.CATBOffset.Y;

      if (w > 1024) or (h > 1024) then
      begin
        w := 256;
        h := 256;
      end;

      // Render Notify Skin as background/Border of the window
      XMod := TPS.Location.X;
      YMod := TPS.Location.Y;
      FBitmap := TBitmap32.Create;
      FBitmap.SetSize(w,h);
      FBitmap.Clear(color32(0,0,0,0));

      RenderImage;      

      // Create and setup window
      with FBlend do
      begin
        BlendOp := AC_SRC_OVER;
        BlendFlags := 0;
        SourceConstantAlpha := 255;
        AlphaFormat := AC_SRC_ALPHA;
      end;

      FX := px + xmod;
      if pPopupDown then
        FY := py + ymod
      else FY := py - ymod - FBitmap.Height;

      RenderSpecial;
      UpdateWndLayer;

      dst.Left := TPS.CALROffset.X;
      dst.Top := TPS.CATBOffset.X;
      dst.Right := FBitmap.Width - TPS.CALROffset.Y;
      dst.Bottom := FBitmap.Height - TPS.CATBOffset.Y;

      SetWindowPos(FWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
      if pAnimate then
        AnimateWindow(FWnd,100,AW_CENTER);
      ShowWindow(FWnd,SW_SHOW);

      FdwmThumbProps.rcDestination := dst;
      DwmUpdateThumbnailProperties(FdwmThumbID,FdwmThumbProps);      
    end else FdwmThumbID := 0;
  end;
end;

destructor TTaskPreviewWnd.Destroy;
begin
  if FdwmThumbID > 0 then
    DwmUnregisterThumbnail(FdwmThumbID);
  if FWnd <> 0 then
    DestroyWindow(FWnd);
  FBitmap.Free;
  if FSpecialBG <> nil then
    FSpecialBG.Free;

  inherited Destroy;
end;

procedure TTaskPreviewWnd.HideWindow(pAnimate: boolean);
begin
  if FdwmThumbID > 0 then
  begin
    DwmUnregisterThumbnail(FdwmThumbID);
    FdwmThumbID := 0;
  end;
  if pAnimate then
    AnimateWindow(FWnd,100,AW_CENTER or AW_HIDE);
  ShowWindow(FWnd,SW_HIDE);
end;

procedure TTaskPreviewWnd.RenderImage;
var
  TPS : ISharpETaskPreviewSkin;
  SkinText : ISharpEskinText;
  mw : integer;
  Caption : String;
  TextRect : TRect;
  TextPos : TPoint;
begin
  TPS := FSkinManager.Skin.TaskPreview;
  FBitmap.Clear(color32(0,0,0,0));
  if FHover then
    TPS.Hover.DrawTo(FBitmap, FSkinManager.Scheme)
  else TPS.Background.DrawTo(FBitmap, FSkinManager.Scheme);

  if FHover then
    SkinText := TPS.Hover.CreateThemedSkinText
  else SkinText := TPS.Background.CreateThemedSkinText;
  if SkinText.DrawText then
  begin
    SkinText.AssignFontTo(FBitmap.Font,FSkinManager.Scheme);
    mw := SkinText.GetDim(Rect(0,0,FBitmap.Width,FBitmap.Height)).x;
    Caption := FixCaption(FBitmap,FCaption,mw);
    TextRect := Rect(0, 0, FBitmap.TextWidthW(Caption), FBitmap.TextHeightW(Caption));
    TextPos := SkinText.GetXY(TextRect, Rect(0,0,FBitmap.Width,FBitmap.Height), rect(0,0,0,0));
    if length(trim(Caption)) > 0 then
      SkinText.RenderToW(FBitmap,TextPos.X,TextPos.Y,Caption,FSkinManager.Scheme);
  end;

  SkinText := nil;
end;

procedure TTaskPreviewWnd.RenderSpecial;
const
  CAPTUREBLT = $40000000;
var
  dc : hdc;
  temp : TBitmap32;
  Theme : ISharpETheme;
begin
  if FSkinManager.Skin.Bar <> nil then
    if FSkinManager.Skin.Bar.GlassEffect then
  begin
    temp := TBitmap32.Create;
    SaveAssign(FBitmap, temp);
    temp.DrawMode := dmBlend;
    temp.CombineMode := cmMerge;
    FBitmap.Clear(color32(0,0,0,0));
    dc := GetWindowDC(GetDesktopWindow);
    try
      if FSpecialBG = nil then
      begin
        FSpecialBG := TBitmap32.Create;
        FSpecialBG.SetSize(FBitmap.Width,FBitmap.Height);
        BitBlt(FSpecialBG.Canvas.Handle,
               0,
               0,
               FBitmap.Width,
               FBitmap.Height,
               dc,
               FX,
               FY,
               SRCCOPY or CAPTUREBLT);
      end;
      Theme := GetCurrentTheme;
      SaveAssign(FSpecialBG,FBitmap);
      FBitmap.ResetAlpha;
      if Theme.Skin.GlassEffect.Blend then
        BlendImageC(FBitmap,Theme.Skin.GlassEffect.BlendColor,Theme.Skin.GlassEffect.BlendAlpha);
      fastblur(FBitmap,Theme.Skin.GlassEffect.BlurRadius,Theme.Skin.GlassEffect.BlurIterations);
      if Theme.Skin.GlassEffect.Lighten then
         lightenBitmap(FBitmap,Theme.Skin.GlassEffect.LightenAmount);
      FBitmap.ResetAlpha(255);
      ReplaceTransparentAreas(FBitmap,temp,Color32(0,0,0,0));
      temp.DrawTo(FBitmap,0,0);
    finally
      temp.Free;
      ReleaseDC(GetDesktopWindow, dc);
    end;
  end;
  Premul(FBitmap);
end;

procedure TTaskPreviewWnd.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
  DC: HDC;
begin
  BmpSize.cx := FBitmap.Width;
  BmpSize.cy := FBitmap.Height;
  BmpTopLeft := Point(0, 0);
  TopLeft := Point(FX,FY);

  DC := GetDC(FWnd);
  if DC <> 0 then
  begin
    try
      UpdateLayeredWindow(FWnd, DC, @TopLeft, @BmpSize,
                          FBitmap.Handle, @BmpTopLeft, clNone, @FBlend, ULW_ALPHA);
    except
    end;
    ReleaseDC(FWnd, DC);
  end;
end;

initialization
  SharpETaskPreviewWndClass.hInstance := hInstance;
  SharpETaskPreviewClassRegistered :=  (Windows.RegisterClass(SharpETaskPreviewWndClass) <> 0);

finalization
  if SharpETaskPreviewClassRegistered then
    Windows.UnregisterClass('SharpETaskPreviewWnd',hinstance);

end.
