{
Source Name: SharpNotify.pas
Description: Notification/Popup unit
Copyright (C) Martin Kr�mer (MartinKraemer@gmx.net)

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

unit SharpNotify;

interface

uses
  Classes,
  Windows,
  Messages,
  Contnrs,
  Math,
  Types,  
  Graphics,  
  GR32,
  GR32_PNG,
  StrUtils,
  ExtCtrls,
  SysUtils,
  SharpESkinManager,
  SharpESkinPart,
  SharpESkin,
  SharpThemeApi,
  SharpGraphicsUtils;

type
  TSharpNotifyClickEventProc = procedure(wnd : hwnd; ID : Cardinal; Data : TObject; Msg : integer) of object;
  TSharpNotifyShowEventProc = procedure(wnd : hwnd; ID : Cardinal; Data : TObject) of object;
  TSharpNotifyIcon = (niError,niWarning,niInfo);
  TSharpNotifyEdge = (neTopLeft,neTopCenter,neBottomLeft,neBottomCenter);
  TSharpNotifyEvent = object
    OnClick : TSharpNotifyClickEventProc;
    OnShow : TSharpNotifyShowEventProc;
    OnTimeout : TSharpNotifyShowEventProc;
  end;

var
  SharpNotifyEvent : TSharpNotifyEvent;

{$R SharpNotifyIcons.res}

procedure CraeteNotifyText(pID : Cardinal; pData : TObject; px,py : integer; pCaption : WideString;
                           pEdge : TSharpNotifyEdge; pSM : TSharpESkinManager; pTimeout : integer;
                           pAreaRect : TRect; Replace: boolean);
procedure CreateNotifyWindow(pID : Cardinal; pData : TObject; px,py : integer; pCaption : WideString;
                             pIcon : TSharpNotifyIcon; pEdge : TSharpNotifyEdge; pSM : TSharpESkinManager;
                             pTimeout : integer; pAreaRect : TRect);

implementation

type
  TSharpNotifyTimerEvent = object
                             procedure OnTimer(Sender : TObject);
                           end;
  TNotifyItem = class
    private
      FWnd : hwnd;
      FBitmap : TBitmap32;
      FID : Cardinal;
      FSkinManager : TSharpESkinManager;
      FStartTime : Int64;
      FTimeout : integer;
      FBlend: TBlendFunction;
      FX,FY : integer;
      FXMod,FYMod : integer;
      FActive : boolean;
      FData : TObject;
      FEdge : TSharpNotifyEdge;
      FAreaRect : TRect;
      procedure RenderText(pCaption : WideString);
      procedure Render(pCaption : WideString; pIcon : TSharpNotifyIcon); overload;
      procedure Render(pCaption : WideString; pIcon : TBitmap32); overload;
      procedure RenderSpecial;
      procedure CreateWindow;
      procedure UpdateWndLayer;
    public
      procedure Show;
      constructor Create(pID : Cardinal; pData : TObject; px,py : integer; pCaption : WideString; pIcon : TSharpNotifyIcon; pEdge: TSharpNotifyEdge; pSM : TSharpESkinManager; pTimeout : integer; pAreaRect : TRect);
      constructor CreateText(pID : Cardinal; pData : TObject; px,py : integer; pCaption : WideString; pEdge: TSharpNotifyEdge; pSM : TSharpESkinManager; pTimeout : integer; pAreaRect : TRect);      
      destructor Destroy; override;
  end;

function SharpENotifyWndClassProc(hWnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall; forward;

var
  SharpNotifyWindows : TObjectList;

  SharpNotifyTimer : TTimer;
  SharpNotifyTimerEvent : TSharpNotifyTimerEvent;

  SharpENotifyClassRegistered : boolean;
  SharpENotifyWndClass: TWndClass = (
    style: 0;
    lpfnWndProc: @SharpENotifyWndClassProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 1;
    lpszMenuName: nil;
    lpszClassName: 'SharpENotifyWnd');


function SharpENotifyWndClassProc(hWnd : hwnd; Msg, wParam, lParam: Integer): Integer; stdcall;
var
  n,i : integer;
  item : TNotifyItem;
  id : Cardinal;
begin
  if (Msg = WM_LBUTTONUP) or (Msg = WM_RBUTTONUP) then
  begin
    for n := SharpNotifyWindows.Count - 1 downto 0 do
    begin
      item := TNotifyItem(SharpNotifyWindows.Items[n]);
      if item.FWnd = hWnd then
      begin
        SharpNotifyWindows.Extract(item);
        if Assigned(SharpNotifyEvent.OnClick) then
          SharpNotifyEvent.OnClick(hwnd,item.FID,item.FData,Msg);
        id := item.FID;
        item.Free;
        for i := 0 to SharpNotifyWindows.Count - 1 do
        begin
          item := TNotifyItem(SharpNotifyWindows.Items[i]);
          if (id = item.FID) and (not item.FActive) then
          begin
            item.Show;
            if assigned(SharpNotifyEvent.OnShow) then
              SharpNotifyEvent.OnShow(item.FWnd,item.FID,item.FData);
            break;
          end;
        end;
      end;
    end;
  end;
    
  Result := DefWindowProc(hWnd, Msg, wParam, lParam);
end;

procedure CraeteNotifyText(pID : Cardinal; pData : TObject; px,py : integer; pCaption : WideString;
                           pEdge : TSharpNotifyEdge; pSM : TSharpESkinManager; pTimeout : integer;
                           pAreaRect : TRect; Replace: boolean);
var
  item,listitem : TNotifyItem;
  idrunning : boolean;
  n : integer;
begin
  item := TNotifyItem.CreateText(pID,pData,px,py,pCaption,pEdge,pSM,pTimeout,pAreaRect);
  SharpNotifyWindows.Add(item);
  idrunning := False;
  for n := 0 to SharpNotifyWindows.Count - 1 do
  begin
    listitem := TNotifyItem(SharpNotifyWindows.Items[n]);
    if (listitem.FID = item.FID) and (listitem.FActive) then
    begin
      idrunning := True;
      break;
    end;
  end;
  if idrunning and replace then
  begin
    SharpNotifyWindows.Extract(listitem);
    if assigned(SharpNotifyEvent.OnTimeout) then
      SharpNotifyEvent.OnTimeout(listitem.FWnd,listitem.FID,listitem.FData);
    listitem.Free;
    idrunning := False;
  end;
  if not idrunning then
  begin
    item.Show;
    if assigned(SharpNotifyEvent.OnShow) then
     SharpNotifyEvent.OnShow(item.FWnd,item.FID,item.FData);
  end;

  if not SharpNotifyTimer.Enabled then
    SharpNotifyTimer.Enabled := True;
end;

procedure CreateNotifyWindow(pID : Cardinal; pData : TObject; px,py : integer; pCaption : WideString;
                             pIcon : TSharpNotifyIcon; pEdge : TSharpNotifyEdge; pSM : TSharpESkinManager;
                             pTimeout : integer; pAreaRect : TRect);
var
  item,listitem : TNotifyItem;
  idrunning : boolean;
  n : integer;
begin
  item := TNotifyItem.Create(pID,pData,px,py,pCaption,pIcon,pEdge,pSM,pTimeout,pAreaRect);
  SharpNotifyWindows.Add(item);
  idrunning := False;
  for n := 0 to SharpNotifyWindows.Count - 1 do
  begin
    listitem := TNotifyItem(SharpNotifyWindows.Items[n]);
    if (listitem.FID = item.FID) and (listitem.FActive) then
    begin
      idrunning := True;
      break;
    end;
  end;
  if not idrunning then
  begin
    item.Show;
    if assigned(SharpNotifyEvent.OnShow) then
     SharpNotifyEvent.OnShow(item.FWnd,item.FID,item.FData);
  end;

  if not SharpNotifyTimer.Enabled then
    SharpNotifyTimer.Enabled := True;
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

procedure TSharpNotifyTimerEvent.OnTimer(Sender: TObject);
var
  currenttick : integer;
  item : TNotifyItem;
  id : Cardinal;
  n,i : integer;
begin
  currenttick := GetTickCount;
  if SharpNotifyWindows.Count > 0 then
  for n := SharpNotifyWindows.Count - 1 downto 0 do
  begin
    item := TNotifyItem(SharpNotifyWindows.Items[n]);
    if (currenttick - item.FStartTime > item.FTimeout) and (item.FActive) then
    begin
      SharpNotifyWindows.Extract(item);
      id := item.FID;
      if assigned(SharpNotifyEvent.OnTimeout) then
        SharpNotifyEvent.OnTimeout(item.FWnd,item.FID,item.FData);
      item.Free;
      for i := 0 to SharpNotifyWindows.Count - 1 do
      begin
        item := TNotifyItem(SharpNotifyWindows.Items[i]);
        if (id = item.FID) and (not item.FActive) then
        begin
          item.Show;
          if assigned(SharpNotifyEvent.OnShow) then
            SharpNotifyEvent.OnShow(item.FWnd,item.FID,item.FData);
          break;
        end;
      end;
    end;
  end;

  if SharpNotifyWindows.Count = 0 then
    SharpNotifyTimer.Enabled := False;
end;


{ TNotifyItem }

constructor TNotifyItem.Create(pID : Cardinal; pData : TObject; px, py: integer; pCaption: WideString;
  pIcon: TSharpNotifyIcon; pEdge: TSharpNotifyEdge; pSM : TSharpESkinManager; pTimeout : integer;
  pAreaRect : TRect);
begin
  inherited Create;

  FID := pID;
  FData := pData;
  FSkinManager := pSM;
  FTimeout := pTimeout;
  FX := pX;
  FY := pY;
  FBitmap := TBitmap32.Create;
  FBitmap.CombineMode := cmMerge;
  FBitmap.DrawMode := dmBlend;
  FActive := False;
  FEdge := pEdge;
  FAreaRect := pAreaRect;

  Render(pCaption,pIcon);  
end;

constructor TNotifyItem.CreateText(pID: Cardinal; pData: TObject; px,
  py: integer; pCaption: WideString; pEdge: TSharpNotifyEdge;
  pSM: TSharpESkinManager; pTimeout: integer; pAreaRect: TRect);
begin
  inherited Create;

  FID := pID;
  FData := pData;
  FSkinManager := pSM;
  FTimeout := pTimeout;
  FX := pX;
  FY := pY;
  FBitmap := TBitmap32.Create;
  FBitmap.CombineMode := cmMerge;
  FBitmap.DrawMode := dmBlend;
  FActive := False;
  FEdge := pEdge;
  FAreaRect := pAreaRect;

  RenderText(pCaption);
end;

procedure TNotifyItem.CreateWindow;
begin
  with FBlend do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := 255;
    AlphaFormat := AC_SRC_ALPHA;
  end;

  case FEdge of
    neTopLeft:    FY := FY + FYMod;
    neTopCenter: begin
      FX := FX - FBitmap.Width div 2;
      FY := FY + FYMod;
    end;
    neBottomLeft: FY := FY - FBitmap.Height - FYMod;
    neBottomCenter: begin
      FX := FX - FBitmap.Width div 2;
      FY := FY - FBitmap.Height - FYMod;
    end;
  end;

  if FX + FBitmap.Width > FAreaRect.Right then
    FX := FAreaRect.Right - FBitmap.Width
  else if FX < FAreaRect.Left then
    FX := FAreaRect.Left;
  if FY + FBitmap.Height > FAreaRect.Bottom then
    FY := FAreaRect.Bottom - FBitmap.Height
  else if FY < FAreaRect.Top then
    FY := FAreaRect.Top;

  RenderSpecial;
  FWnd := CreateWindowEx(WS_EX_LAYERED or WS_EX_TOPMOST or WS_EX_TOOLWINDOW,
                         SharpENotifyWndClass.lpszClassName, 'SharpENotifyWnd',
                         WS_POPUP,
                         FX, FY, FBitmap.Width, FBitmap.Height, 0, 0, hInstance, nil);
  if FWnd <> 0 then
  begin
    UpdateWndLayer;
    ShowWindow(FWnd,SW_SHOW);
    SetWindowPos(FWnd,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
  end;
end;

procedure TNotifyItem.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
  Bmp : TBitmap32;
  DC: HDC;
begin
  BmpSize.cx := FBitmap.Width;
  BmpSize.cy := FBitmap.Height;
  BmpTopLeft := Point(0, 0);
  TopLeft := Point(FX,FY);

  DC := GetDC(FWnd);
  Bmp := TBitmap32.Create;
  try
    {$WARNINGS OFF}
    if not Win32Check(LongBool(DC)) then
      RaiseLastWin32Error;

    bmp.SetSize(FBitmap.Width,FBitmap.Height);
    Bmp.Clear(color32(0,0,0,0));
    FBitmap.DrawMode := dmBlend;
    Bmp.Draw(0,0,FBitmap);
    if not Win32Check(UpdateLayeredWindow(FWnd, DC, @TopLeft, @BmpSize,
      Bmp.Handle, @BmpTopLeft, clNone, @FBlend, ULW_ALPHA)) then
      RaiseLastWin32Error;
    {$WARNINGS ON}
  finally
    Bmp.Free;
    ReleaseDC(FWnd, DC);
  end;
end;

destructor TNotifyItem.Destroy;
begin
  if FWnd <> 0 then
    DestroyWindow(FWnd);
  FBitmap.Free;
  inherited Destroy;
end;

procedure TNotifyItem.Render(pCaption : WideString; pIcon : TSharpNotifyIcon);
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
  loadStr : String;
begin
  case pIcon of
    niError: loadStr := 'sn_error';
    niWarning: loadStr := 'sn_warning';
    niInfo: loadStr := 'sn_info';
  end;

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(32,32);
  TempBmp.Clear(color32(0,0,0,0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, loadStr, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
    finally
      ResStream.Free;
    end;
  except
  end;

  Render(pCaption, TempBmp);

  TempBmp.Free;
end;

procedure TNotifyItem.Render(pCaption : WideString; pIcon : TBitmap32);
var
  TestString : WideString;
  NS : TSharpENotifySkin;
  CompRect,IconRect,TextRect : TRect;
  TextPos,IconPos : TPoint;
  s,cs : WideString;
  cw : single;
  ch : integer;
  y : integer;
  w,h : integer;
  tdim : TPoint;
  Text,Icon : TBitmap32;
  i,k : integer;
  mw : integer;
begin
  FBitmap.SetSize(1,1);
  FBitmap.Clear(color32(0,0,0,0));
  FXMod := 0;
  FYMod := 0;

  if FSkinManager = nil then
    exit;
  if not (scNotify in FSkinManager.ComponentSkins) then
    exit;

  TestString := 'WAangb412GHU';

  NS := FSkinManager.Skin.NotifySkin;
  NS.Background.SkinText.AssignFontTo(FBitmap.Font,FSkinManager.Scheme);
  w := NS.SkinDim.WidthAsInt;
  h := NS.SkinDim.HeightAsInt;

  FXMod := FSkinManager.Skin.NotifySkin.SkinDim.XAsInt;
  FYMod := FSkinManager.Skin.NotifySkin.SkinDim.YAsInt;

  cw := FBitmap.TextWidthW(TestString) / length(TestString);
  ch := FBitmap.TextHeightW(TestString);
  s := pCaption;
  tDim := NS.Background.SkinText.GetDim(Rect(0,0,w,h));
  Text := TBitmap32.Create;
  NS.Background.SkinText.AssignFontTo(Text.Font,FSkinManager.Scheme);  
  Text.DrawMode := dmBlend;
  Text.CombineMode := cmMerge;
  Text.SetSize(tdim.x,512);
  Text.Clear(color32(0,0,0,0));
  y := 0;
  mw := 0;
  while length(s) > 0 do
  begin
    i := Max(pos(#13,s),pos(#10,s));
    if (cw * length(s) > tdim.x) or (i<>0) then
    begin
      if i <> 0 then
      begin
        cs := Copy(s,1,i-1);
        s := Copy(s,i+1,length(s)-i);
      end else
      begin
        cs := Copy(s,1,round(tdim.x/cw));
        k := Pos(' ',cs);
        i := k;
        if (k <> 0) and (k <> length(cs)) then
        begin
          while i <> 0 do
          begin
            k := i;
            i := PosEx(' ',cs,i+1);
          end;
          cs := Copy(s,1,k);
          s := Copy(s,length(cs)+1,length(s)-length(cs));
        end else s := Copy(s,length(cs),length(s)-length(cs));
      end;
    end else
    begin
      cs := s;
      s := Copy(s,length(cs),length(s)-length(cs));      
    end;
    NS.Background.SkinText.RenderToW(Text,0,y,cs,FSkinManager.Scheme);
    mw := max(mw,Text.TextWidthW(cs));
    y := y + ch + 2;
  end;

  Icon := TBitmap32.Create;
  Icon.DrawMode := dmBlend;
  Icon.CombineMode := cmMerge;
  Icon.SetSize(NS.Background.SkinIcon.Size.XAsInt,NS.Background.SkinIcon.Size.YAsInt);
  Icon.Clear(color32(0,0,0,0));

  NS.Background.SkinIcon.RenderTo(Icon,pIcon,0,0);

  h := max(Icon.Height,y) + NS.CATBOffset.XAsInt + NS.CATBOffset.YAsInt;
  if mw < Text.Width then
    w := w - (Text.Width - mw);
  FBitmap.SetSize(w,h);
  FBitmap.Clear(color32(0,0,0,0));
  NS.Background.draw(FBitmap,FSkinManager.Scheme);

  CompRect := Rect(0,0,w,h);
  TextRect := Rect(0,0,Text.Width,y);
  IconRect := Rect(0,0,Icon.Width,Icon.Height);
  TextPos := NS.Background.SkinText.GetXY(TextRect, CompRect, IconRect);
  IconPos := NS.Background.SkinIcon.GetXY(TextRect, CompRect);
  Text.DrawTo(FBitmap,TextPos.x,Textpos.Y);
  Icon.DrawTo(FBitmap,IconPos.x,IconPos.Y);
end;

procedure TNotifyItem.RenderSpecial;
const
  CAPTUREBLT = $40000000;
var
  dc : hdc;
  temp : TBitmap32;
begin
  if FSkinManager.Skin.BarSkin <> nil then
    if FSkinManager.Skin.BarSkin.GlassEffect then
  begin
    temp := TBitmap32.Create;
    temp.Assign(FBitmap);
    temp.DrawMode := dmBlend;
    temp.CombineMode := cmMerge;
    FBitmap.Clear(color32(0,0,0,0));
    dc := GetWindowDC(GetDesktopWindow);
    try
      BitBlt(FBitmap.Canvas.Handle,
             0,
             0,
             FBitmap.Width,
             FBitmap.Height,
             dc,
             FX,
             FY,
             SRCCOPY or CAPTUREBLT);
      if SharpThemeApi.GetSkinGEBlend then
        BlendImageC(FBitmap,GetSkinGEBlendColor,GetSkinGEBlendAlpha);
      fastblur(FBitmap,GetSkinGEBlurRadius,GetSkinGEBlurIterations);
      if GetSkinGELighten then
         lightenBitmap(FBitmap,GetSkinGELightenAmount);
      FBitmap.ResetAlpha(255);
      ReplaceTransparentAreas(FBitmap,temp,Color32(0,0,0,0));
      temp.DrawTo(FBitmap,0,0);
    finally
      ReleaseDC(GetDesktopWindow, dc);
    end;
  end;
  Premul(FBitmap); 
end;

procedure TNotifyItem.RenderText(pCaption: WideString);
var
  w,h : integer;
begin
  FBitmap.SetSize(1,1);
  FBitmap.Clear(color32(0,0,0,0));
  FXMod := 0;
  FYMod := 0;
  if (FSkinManager = nil) or (length(pCaption) = 0) then
    exit;
  FSkinManager.Skin.OCDText.AssignFontTo(FBitmap.Font,FSkinManager.Scheme);
  w := FBitmap.TextWidthW(pCaption) + 10;
  h := FBitmap.TextHeightW(pCaption) + 10;
  FBitmap.SetSize(w,h);
  FBitmap.Clear(color32(0,0,0,0));
  FSkinManager.Skin.OCDText.RenderToW(FBitmap,5,5,pCaption,FSkinManager.Scheme);
end;

procedure TNotifyItem.Show;
begin
  CreateWindow;
  FActive := True;  
  FStartTime := GetTickCount;
end;

initialization
  SharpNotifyTimer :=  TTimer.Create(nil);
  SharpNotifyTimer.Enabled := False;
  SharpNotifyTimer.Interval := 100;
  SharpNotifyTimer.OnTimer := SharpNotifyTimerEvent.OnTimer;

  SharpNotifyEvent.OnClick := nil;
  SharpNotifyEvent.OnShow := nil;
  SharpNotifyEvent.OnTimeout := nil;

  SharpENotifyWndClass.hInstance := hInstance;  
  SharpENotifyClassRegistered :=  (Windows.RegisterClass(SharpENotifyWndClass) <> 0);

  SharpNotifyWindows := TObjectList.Create(True);

finalization
  SharpNotifyEvent.OnClick := nil;
  SharpNotifyEvent.OnShow := nil;
  SharpNotifyEvent.OnTimeout := nil;

  SharpNotifyTimer.Enabled := False;
  SharpNotifyTimer.Free;

  SharpNotifyWindows.Free;

  if SharpENotifyClassRegistered then
    Windows.UnregisterClass('SharpENotifyWndClass',hinstance);

end.