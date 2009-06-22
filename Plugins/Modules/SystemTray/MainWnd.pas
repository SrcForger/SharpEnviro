{
Source Name: MainWnd
Description: SystemTray Module - Main Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, SharpEBaseControls, SharpEButton,
  JclSimpleXML, SharpApi, Menus, GR32_Layers, Types,
  TrayIconsManager, Math, GR32, SharpECustomSkinSettings, SharpESkinLabel,
  ToolTipApi,Commctrl, uISharpBarModule;


type
  TMainForm = class(TForm)
    lb_servicenotrunning: TSharpESkinLabel;
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
  private
    sShowBackground     : Boolean;
    sBackgroundColor    : integer;
    sBackgroundColorStr : String;
    sBackgroundAlpha    : integer;
    sShowBorder         : Boolean;
    sBorderColor        : integer;
    sBorderColorStr     : String;
    sBorderAlpha        : integer;
    sColorBlend         : Boolean;
    sBlendColor         : integer;
    sBlendColorStr      : String;
    sBlendAlpha         : integer;
    sIconAlpha          : integer;
    cwidth              : integer;
    doubleclick         : boolean;
    refreshed           : boolean;
    FCustomSkinSettings : TSharpECustomSkinSettings;
    procedure CMMOUSELEAVE(var msg : TMessage); message CM_MOUSELEAVE;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
  public
    FTrayClient : TTrayClient;
    Buffer     : TBitmap32;
    mInterface : ISharpBarModule;
    procedure RepaintIcons(pRepaint : boolean = True);
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
  end;


implementation

uses SharpESkinPart,
     SharpThemeApiEx;

type
  TTrayWnd = class
             public
               Wnd : TMainForm;
               TipWnd : hwnd;
             end;

{$R *.dfm}

function Li2Double(x: LARGE_INTEGER): Double;
begin
  Result := x.HighPart * 4.294967296E9 + x.LowPart
end;

procedure TMainForm.UpdateComponentSkins;
begin
  lb_servicenotrunning.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.CMMOUSELEAVE(var msg : TMessage);
begin
  FTrayClient.StopTipTimer;
  FTrayClient.CloseVistaInfoTip;
end;

procedure TMainForm.WMNotify(var msg : TWMNotify);
var
  result : boolean;
  n : integer;
  s : String;
  ws : WideString;
begin
  if Msg.NMHdr.code = TTN_SHOW then
  begin
    SetWindowPos(Msg.NMHdr.hwndFrom, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    msg.result := 1;
    exit;
  end;

  Result := (Msg.NMHdr.code = TTN_NEEDTEXT);
  if (FTrayClient.TipForm = self) and (FTrayClient.TipWnd = Msg.NMHdr.hwndFrom) then
    Result := Result and True;

  if result then msg.result := 1
     else msg.result := 0;

  if result then
  begin
    SendMessage(Msg.NMHdr.hwndFrom, TTM_SETMAXTIPWIDTH, 0, 512);

    if FTrayClient.LastTipItem = nil then exit;

    if Msg.NMHdr.code = TTN_NEEDTEXTA then
    begin
      with PNMTTDispInfoA(Msg.NMHdr)^ do
      begin
        s := FTrayClient.LastTipItem.FTip;
        if length(s) > 80 then
           lpszText := PAnsiChar(s)
           else for n := 0 to length(s)-1 do
                szText[n] := Char(FTrayClient.LastTipItem.FTip[n]);
        hinst := 0;
      end;
    end
    else
      with PNMTTDispInfoW(Msg.NMHdr)^ do
      begin
        ws := FTrayClient.LastTipItem.FTip;
        if length(ws) > 80 then
           lpszText := PWideChar(ws)
           else for n := 0 to length(s)-1 do
            szText[n] := FTrayClient.LastTipItem.FTip[n];
        hinst := 0;
      end;
  end;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
  skin : String;
begin
  // Load Skin custom settings as default
  sShowBackground     := False;
  sBackgroundColor    := 0;
  sBackgroundColorStr := '0';
  sBackgroundAlpha    := 255;
  sShowBorder         := False;
  sBorderColor        := clwhite;
  sBorderColorStr     := 'clwhite';
  sBorderAlpha        := 255;
  sColorBlend         := False;
  sBlendColor         := clwhite;
  sBlendColorStr      := 'clwhite';
  sBlendAlpha         := 255;
  sIconAlpha          := 255;
  FCustomSkinSettings.LoadFromXML('');
  try
    with FCustomSkinSettings.xml.Items do
         if ItemNamed['systemtray'] <> nil then
            with ItemNamed['systemtray'].Items do
            begin
              sShowBackground     := BoolValue('showbackground',False);
              sBackgroundColorStr := Value('backgroundcolor','0');
              sBackgroundAlpha    := IntValue('backgroundalpha',255);
              sShowBorder         := BoolValue('showborder',False);
              sBorderColorStr     := Value('bordercolor','clwhite');
              sBorderAlpha        := IntValue('borderalpha',255);
              sColorBlend         := BoolValue('colorblend',false);
              sBlendColorStr      := Value('blendrcolor','clwhite');
              sBlendAlpha         := IntValue('blendalpha',0);
              sIconAlpha          := IntValue('iconalpha',255);
            end;
  except
  end;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      skin := GetCurrentTheme.Skin.Name;
      skin := StringReplace(skin,' ','_',[rfReplaceAll]);   
      if ItemNamed['skin'] <> nil then
         if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
            with ItemNamed['skin'].Items.ItemNamed[skin].Items do
            begin
              sShowBackground     := BoolValue('ShowBackground',sShowBackground);
              sBackgroundColorStr := Value('BackgroundColor',sBackgroundColorStr);
              sBackgroundAlpha    := IntValue('BackgroundAlpha',sBackgroundAlpha);
              sShowBorder         := BoolValue('ShowBorder',sShowBorder);
              sBorderColorStr     := Value('BorderColor',sBorderColorStr);
              sBorderAlpha        := IntValue('BorderAlpha',sBorderAlpha);
              sColorBlend         := BoolValue('ColorBlend',sColorBlend);
              sBlendColorStr      := Value('BlendColor',sBlendColorStr);
              sBlendAlpha         := IntValue('BlendAlpha',sBlendAlpha);
              sIconAlpha          := IntValue('IconAlpha',sIconAlpha);
            end;
    end;
  XML.Free;
end;

procedure TMainForm.ReAlignComponents;
var
 newwidth : integer;
begin
  if lb_servicenotrunning.visible then
  begin
    lb_servicenotrunning.UpdateSkin;
    lb_servicenotrunning.UpdateAutoPosition;
    newWidth := lb_servicenotrunning.TextWidth+8;
    lb_servicenotrunning.Left := 2;
  end else
  begin
    if FTrayClient <> nil then
    begin
      sBackGroundColor := SharpESkinPart.ParseColor(sBackGroundColorStr,mInterface.SkinInterface.SkinManager.Scheme);
      sBorderColor     := SharpESkinPart.ParseColor(sBorderColorStr,mInterface.SkinInterface.SkinManager.Scheme);
      sBlendColor      := SharpESkinPart.ParseColor(sBlendColorStr,mInterface.SkinInterface.SkinManager.Scheme);

      FTrayClient.TopOffset       := (Height - FTrayClient.IconSize) div 2;
      FTrayClient.BackGroundColor := sBackGroundColor;
      FTrayClient.DrawBackground  := sShowBackground;
      FTrayClient.BackgroundAlpha := sBackgroundAlpha;
      FTrayClient.BorderColor     := sBorderColor;
      FTrayClient.DrawBorder      := sShowBorder;
      FTrayClient.BorderAlpha     := sBorderAlpha;
      FTrayClient.ColorBlend      := sColorBlend;
      FTrayClient.BlendColor      := sBlendColor;
      FTrayClient.BlendAlpha      := sBlendAlpha;
      FTrayClient.IconAlpha       := sIconAlpha;
      FTrayClient.RenderIcons;
      NewWidth := FTrayClient.Bitmap.Width;
      begin
        cwidth := Width;
      end;
    end else NewWidth := 64;
  end;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TMainForm.RepaintIcons(pRepaint : boolean = True); 
begin
  Buffer.Assign(mInterface.Background);
  if FTrayClient = nil then exit;
  FTrayClient.Bitmap.DrawMode := dmBlend;
  FTrayClient.Bitmap.DrawTo(Buffer,0,Height div 2 - FTrayClient.Bitmap.Height div 2);
  if pRepaint then
     Repaint;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  FCustomSkinSettings := TSharpECustomSkinSettings.Create;
  Buffer := TBitmap32.Create;
  Buffer.DrawMode := dmBlend;
  Buffer.CombineMode := cmMerge;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCustomSkinSettings);
  Buffer.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Buffer.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  modx : integer;
begin
  if lb_servicenotrunning.Visible then
    exit;

  p := ClientToScreen(point(x,y));
  modx := x;

  if ssDouble in Shift then
  begin
    doubleclick := True;
    case Button of
      mbRight: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_RBUTTONDBLCLK,self);
      mbMiddle: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_MBUTTONDBLCLK,self);
      mbLeft: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_LBUTTONDBLCLK,self);
    end;
  end else
  begin
    case Button of
      mbRight: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_RBUTTONDOWN,self);
      mbMiddle: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_MBUTTONDOWN,self);
      mbLeft: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_LBUTTONDOWN,self);
    end;
  end;
end;

procedure TMainForm.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  modx : integer;
begin
  if lb_servicenotrunning.Visible then
    exit;

  if doubleclick then
  begin
    doubleclick := False;
    exit;
  end;

  p := ClientToScreen(point(x,y));
  modx := x;

  case Button of
    mbRight:  FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_RBUTTONUP,self);
    mbMiddle: FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_MBUTTONUP,self);
    mbLeft:   FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_LBUTTONUP,self);
  end;
end;

procedure TMainForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  p : TPoint;
  modx : integer;
begin
  if lb_servicenotrunning.Visible then
    exit;

  if refreshed then
  begin
    refreshed := False;
    exit;
  end;
  p := ClientToScreen(point(x,y));
  modx := x;
  FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_MOUSEMOVE,self);
end;

end.
