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
  SharpESkinManager, JvSimpleXML, SharpApi, Menus, GR32_Layers, Types,
  TrayIconsManager, Math, GR32, SharpECustomSkinSettings, SharpESkinLabel,
  ToolTipApi,Commctrl;


type
  TMainForm = class(TForm)
    SkinManager: TSharpESkinManager;
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
    sShowBackground  : Boolean;
    sBackgroundColor : integer;
    sBackgroundAlpha : integer;
    sShowBorder      : Boolean;
    sBorderColor     : integer;
    sBorderAlpha     : integer;
    sColorBlend      : Boolean;
    sBlendColor      : integer;
    sBlendAlpha      : integer;
    sIconAlpha       : integer;
    cwidth           : integer;
    doubleclick      : boolean;
    refreshed        : boolean;
    FCustomSkinSettings: TSharpECustomSkinSettings;
    procedure CMMOUSELEAVE(var msg : TMessage); message CM_MOUSELEAVE;
    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    FTrayClient : TTrayClient;
    Background : TBitmap32;
    Buffer     : TBitmap32;
    procedure LoadSettings;
    procedure RepaintIcons(pRepaint : boolean = True);
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(SendUpdate : boolean);
    procedure UpdateBackground(new : integer = -1);
  end;


implementation

uses uSharpBarAPI,
     SharpESkinPart,
     SharpThemeApi;

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

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
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
  Result := (Msg.NMHdr.code = TTN_NEEDTEXT);
  for n := 0 to FTrayClient.WndList.Count - 1 do
      if (TTrayWnd(FTrayClient.WndList.Items[n]).Wnd = self) and
         (TTrayWnd(FTrayClient.WndList.Items[n]).TipWnd = Msg.NMHdr.hwndFrom)
         then
         begin
           Result := Result and True;
           break;
         end;

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
           else szText[n] := FTrayClient.LastTipItem.FTip[n];
        hinst := 0;
      end;
  end;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJvSimpleXML;
  fileloaded : boolean;
  skin : String;
begin
  // Load Skin custom settings as default
  sShowBackground  := False;
  sBackgroundColor := 0;
  sBackgroundAlpha := 255;
  sShowBorder      := False;
  sBorderColor     := clwhite;
  sBorderAlpha     := 255;
  sColorBlend      := False;
  sBlendColor      := clwhite;
  sBlendAlpha      := 255;
  sIconAlpha       := 255;
  FCustomSkinSettings.LoadFromXML('');
  try
    with FCustomSkinSettings.xml.Items do
         if ItemNamed['systemtray'] <> nil then
            with ItemNamed['systemtray'].Items do
            begin
              sShowBackground  := BoolValue('showbackground',False);
              sBackgroundColor := SharpESkinPart.SchemedStringToColor(Value('backgroundcolor','0'),SkinManager.Scheme);
              sBackgroundAlpha := IntValue('backgroundalpha',255);
              sShowBorder      := BoolValue('showborder',False);
              sBorderColor     := SharpESkinPart.SchemedStringToColor(Value('bordercolor','clwhite'),SkinManager.Scheme);
              sBorderAlpha     := IntValue('borderalpha',255);
              sColorBlend      := BoolValue('colorblend',false);
              sBlendColor      := SharpESkinPart.SchemedStringToColor(Value('blendrcolor','clwhite'),SkinManager.Scheme);
              sBlendAlpha      := IntValue('blendalpha',0);
              sIconAlpha       := IntValue('iconalpha',255);
            end;
  except
  end;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      skin := SharpThemeApi.GetSkinName;
      if ItemNamed['skin'] <> nil then
         if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
            with ItemNamed['skin'].Items.ItemNamed[skin].Items do
            begin
              sShowBackground  := BoolValue('ShowBackground',sShowBackground);
              sBackgroundColor := IntValue('BackgroundColor',sBackgroundColor);
              sBackgroundAlpha := IntValue('BackgroundAlpha',sBackgroundAlpha);
              sShowBorder      := BoolValue('ShowBorder',sShowBorder);
              sBorderColor     := IntValue('BorderColor',sBorderColor);
              sBorderAlpha     := IntValue('BorderAlpha',sBorderAlpha);
              sColorBlend      := BoolValue('ColorBlend',sColorBlend);
              sBlendColor      := IntValue('BlendColor',sBlendColor);
              sBlendAlpha      := IntValue('BlendAlpha',sBlendAlpha);
              sIconAlpha       := IntValue('IconAlpha',sIconAlpha);
            end;
    end;
  XML.Free;
end;

procedure TMainForm.SetSize(NewWidth : integer);
var
  new : integer;
begin
  new := Max(1,NewWidth);

  UpdateBackground(new);

  Width := new;
  RepaintIcons;
end;

procedure TMainForm.ReAlignComponents(SendUpdate : boolean);
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

  Tag := newwidth;
  Hint := inttostr(newwidth);
  if (newwidth <> width) and (SendUpdate) then
  begin
     SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  end;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TMainForm.RepaintIcons(pRepaint : boolean = True);
begin
  Buffer.Assign(Background);
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
  Background := TBitmap32.Create;
  Buffer := TBitmap32.Create;
  Buffer.DrawMode := dmBlend;
  Buffer.CombineMode := cmMerge;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FCustomSkinSettings);
  Buffer.Free;
  Background.Free;
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
  b : boolean;
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

  b := False;
  case Button of
    mbRight:  b := FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_RBUTTONUP,self);
    mbMiddle: b := FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_MBUTTONUP,self);
    mbLeft:   b := FTrayClient.PerformIconAction(modx,y,p.x,p.y,0,WM_LBUTTONUP,self);
  end;
  if not b then PopupMenu.Popup(p.x,p.y);
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
