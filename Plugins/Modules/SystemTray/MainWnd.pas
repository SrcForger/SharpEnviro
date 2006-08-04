{
Source Name: MainWnd
Description: SystemTray Module - Main Window
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, GR32_Layers, TrayIconsManager,
  SharpEPanel,Math, GR32;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    lb_servicenotrunning: TLabel;
    sb_left: TSharpEButton;
    SharpESkinManager1: TSharpESkinManager;
    sb_right: TSharpEButton;
    procedure sb_rightClick(Sender: TObject);
    procedure sb_leftClick(Sender: TObject);
    procedure BackgroundMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer; Layer: TCustomLayer);
    procedure BackgroundMouseLeave(Sender: TObject);
    procedure BackgroundMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure BackgroundMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    BarWidth : integer;
    sShowBackground  : Boolean;
    sBackgroundColor : integer;
    sBackgroundAlpha : integer;
    sShowBorder      : Boolean;
    sBorderColor     : integer;
    sBorderAlpha     : integer;
    sColorBlend      : Boolean;
    sBlendColor      : integer;
    sBlendAlpha      : integer;
    cwidth           : integer;
    doubleclick      : boolean;
    refreshed        : boolean;
  public
    ModuleID : integer;
    Offset : integer;
    MaxWidth : integer;
    BarWnd : hWnd;
    FTrayClient : TTrayClient;
    procedure LoadSettings;
    procedure RepaintIcons;
    procedure ReAlignComponents(SendUpdate : boolean);
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

{$R *.dfm}

function Li2Double(x: LARGE_INTEGER): Double;
begin
  Result := x.HighPart * 4.294967296E9 + x.LowPart
end;

procedure TMainForm.LoadSettings;
var item : TJvSimpleXMLElem;
begin
  BarWidth := 100;
  Offset   := 0;
  sShowBackground  := False;
  sBackgroundColor := -6;
  sBackgroundAlpha := 255;
  sShowBorder      := True;
  sBorderColor     := -5;
  sBorderAlpha     := 255;
  sColorBlend      := False;
  sBlendColor      := -1;
  sBlendAlpha      := 255;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    BarWidth := IntValue('Width',100);
    sShowBackground  := BoolValue('ShowBackground',False);
    sBackgroundColor := IntValue('BackgroundColor',-6);
    sBackgroundAlpha := IntValue('BackgroundAlpha',255);
    sShowBorder      := BoolValue('ShowBorder',True);
    sBorderColor     := IntValue('BorderColor',-5);
    sBorderAlpha     := IntValue('BorderAlpha',255);
    sColorBlend      := BoolValue('ColorBlend',False);
    sBlendColor      := IntValue('BlendColor',-1);
    sBlendAlpha      := IntValue('BlendAlpha',255);
  end;               
end;

procedure TMainForm.ReAlignComponents(SendUpdate : boolean);
var
 owidth : integer;
 cs : TColorSchemeEx;
begin
  MaxWidth := uSharpBarApi.GetFreeBarSpace(BarWnd)+Width;

  owidth := Width;

  if lb_servicenotrunning.visible then
  begin
    Width := Min(lb_servicenotrunning.Canvas.TextWidth(lb_servicenotrunning.Caption) + 64,MaxWidth);
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
      cs := LoadColorSchemeEX;
      FTrayClient.cs := cs;
      FTrayClient.RenderIcons;
      Width := Min(FTrayClient.Bitmap.Width,MaxWidth);
      if FTrayClient.Bitmap.Width > Width then
      begin
        Width := MaxWidth;
        sb_left.Left := 0;
        sb_left.Top := Height div 2 - sb_left.Height div 2;
        sb_left.Height := Height;
        sb_right.Left := Width-sb_right.Width;
        sb_right.Top := Height div 2 - sb_right.Height div 2;
        sb_right.Height := Height;
        sb_left.Visible := True;
        sb_right.Visible := True;
        cWidth := Max(sb_right.Left - sb_left.Left - sb_left.Width,0);
      end else
      begin
        cwidth := Width;
        offset := 1;
        sb_left.Visible := False;
        sb_right.Visible := False;
      end;
    end else Width := Min(64,MaxWidth);
  end;

  if (owidth <> width) and (SendUpdate) then
  begin
     SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  end;
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  SettingsForm := TSettingsForm.Create(nil);
  SettingsForm.cb_dbg.Checked      := sShowBackground;
  SettingsForm.scb_dbg.ColorCode   := sBackgroundColor;
  SettingsForm.tb_dbg.Position     := sBackgroundAlpha;
  SettingsForm.cb_dbd.Checked      := sShowBorder;
  SettingsForm.scb_dbd.ColorCode   := sBorderColor;
  SettingsForm.tb_dbd.Position     := sBorderAlpha;
  SettingsForm.cb_blend.Checked    := sColorBlend;
  SettingsForm.scb_blend.ColorCode := sBlendColor;
  SettingsForm.tb_blend.Position   := sBlendAlpha;
  if SettingsForm.ShowModal = mrOk then
  begin
    sShowBackground := SettingsForm.cb_dbg.Checked;
    sBackgroundColor := SettingsForm.scb_dbg.ColorCode;
    sBackgroundAlpha := SettingsForm.tb_dbg.Position;
    sShowBorder := SettingsForm.cb_dbd.Checked;
    sBorderColor := SettingsForm.scb_dbd.ColorCode;
    sBorderAlpha := SettingsForm.tb_dbd.Position;
    sColorBlend := SettingsForm.cb_blend.Checked;
    sBlendColor := SettingsForm.scb_blend.ColorCode;
    sBlendAlpha := SettingsForm.tb_blend.Position;

    item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
    if item <> nil then with item.Items do
    begin
      clear;
      Add('ShowBackground',sShowBackground);
      Add('BackgroundColor',sBackgroundColor);
      Add('BackgroundAlpha',sBackgroundAlpha);
      Add('ShowBorder',sShowBorder);
      Add('BorderColor',sBorderColor);
      Add('BorderAlpha',sBorderAlpha);
      Add('ColorBlend',sColorBlend);
      Add('BlendColor',sBlendColor);
      Add('BlendAlpha',sBlendAlpha);
    end;
    uSharpBarAPI.SaveXMLFile(BarWnd);

    ReAlignComponents(true);
  end;
  SettingsForm.Free;
  SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;

procedure TMainForm.BackgroundMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  p : TPoint;
  b : boolean;
  modx : integer;
begin
  if doubleclick then
  begin
    doubleclick := False;
    exit;
  end;

  p := Background.ClientToScreen(point(x,y));
  if sb_left.Visible then
     modx := x // + offset - sb_left.Width - sb_left.Left
     else modx := x;

  b := False;
  case Button of
    mbRight:  b := FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_RBUTTONUP);
    mbMiddle: b := FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_MBUTTONUP);
    mbLeft:   b := FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_LBUTTONUP);
  end;
  if not b then Background.PopupMenu.Popup(p.x,p.y);
end;

procedure TMainForm.BackgroundMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
var
  p : TPoint;
  modx : integer;
begin
  p := Background.ClientToScreen(point(x,y));
  if sb_left.Visible then
     modx := x //+ offset - sb_left.Width - sb_left.Left
     else modx := x;

  if ssDouble in Shift then
  begin
    doubleclick := True;
    case Button of
      mbRight: FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_RBUTTONDBLCLK);
      mbMiddle: FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_MBUTTONDBLCLK);
      mbLeft: FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_LBUTTONDBLCLK);
    end;
  end else
  begin
    case Button of
      mbRight: FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_RBUTTONDOWN);
      mbMiddle: FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_MBUTTONDOWN);
      mbLeft: FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_LBUTTONDOWN);
    end;
  end;
end;

procedure TMainForm.BackgroundMouseLeave(Sender: TObject);
begin
  FTrayClient.StopTipTimer;
end;
procedure TMainForm.BackgroundMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer; Layer: TCustomLayer);
var
  p : TPoint;
  modx : integer;
begin
  if refreshed then
  begin
    refreshed := False;
    exit;
  end;
  p := Background.ClientToScreen(point(x,y));
  if sb_left.Visible then
     modx := x // + offset - sb_left.Width - sb_left.Left
     else modx := x;
  FTrayClient.PerformIconAction(modx,y,p.x,p.y,offset-1,WM_MOUSEMOVE);
end;

procedure TMainForm.sb_leftClick(Sender: TObject);
begin
  if offset >0 then
     offset := offset - 1;
  if offset < 0 then offset := 0;
  RepaintIcons;
end;

procedure TMainForm.sb_rightClick(Sender: TObject);
var
  icount : integer;
begin
  icount := (cwidth - 2*FTrayClient.TopSpacing - ((cwidth div FTrayClient.IconSize) - 1)* FTrayClient.IconSpacing) div FTrayClient.IconSize;
  offset := offset + 1;
  if offset > FTrayClient.Items.Count - icount then
     offset := FTrayClient.Items.Count - icount;
  RepaintIcons;
end;

procedure TMainForm.RepaintIcons;
var
  icount : integer;
  tempbmp : TBitmap32;
begin
 uSharpBarAPI.PaintBarBackGround(BarWnd,
                                 Background.Bitmap,
                                 self);
 if FTrayClient = nil then exit;
 FTrayClient.Bitmap.DrawMode := dmBlend;
 if FTrayClient.Bitmap.Width > Width then
 begin
   tempbmp := TBitmap32.Create;
   try
     icount := (cwidth - 2*FTrayClient.TopSpacing - ((cwidth div FTrayClient.IconSize) - 1)* FTrayClient.IconSpacing) div FTrayClient.IconSize;
     tempbmp.DrawMode := dmBlend;
     tempbmp.CombineMode := cmMerge;
     FTrayClient.SpecialRender(tempbmp,offset,offset+icount);
     tempbmp.DrawTo(Background.Bitmap,sb_left.Width + sb_left.Left,Height div 2 - FTrayClient.Bitmap.Height div 2);
     finally
       tempbmp.free;
     end;
   end else FTrayClient.Bitmap.DrawTo(Background.Bitmap,0,Height div 2 - FTrayClient.Bitmap.Height div 2);
end;

end.
