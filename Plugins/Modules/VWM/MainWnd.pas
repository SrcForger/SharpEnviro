{
Source Name: MainWnd.pas
Description: SharpE VWM Module - Main Window
Copyright (C) Author <E-Mail>

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
  // Default Units
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Math,
  // Custom Units
  GR32, VWMFunctions,
  // SharpE API Units
  SharpApi, uSharpBarAPI;

type
  TMainForm = class(TForm)
    Timer1: TTimer;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  protected
  private
    sVWMSpacing : integer;
    sBackgroundColor : integer;
    sBackgroundAlpha : byte;
    sBorderColor : integer;
    sBorderAlpha : byte;
    sForegroundColor : integer;
    sForegroundAlpha : byte;
    sHighlightColor : integer;
    sHighlightAlpha : byte;
  public
    // visual components

    // vars and functions
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    Background : TBitmap32;
    VWM : TBitmap32;
    VWMWidth,VWMHeight : integer;
    VWMCount : integer;
    VWMIndex : integer;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure UpdateBackground(new : integer = -1);
    procedure DrawVWMToForm;
    procedure DrawVWM;
    procedure UpdateVWMSettings;
  end;

// Skin Manager!
// The SkinManager Component is the most important component of the Window
// It gives access to the current skin and scheme.
// If you are using any SharpE Skin Component then just drop it onto the Form
// and change it's SkinManager property to the SkinManager component


implementation

uses JclSimpleXML,
     SharpGraphicsUtils;

{$R *.dfm}

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  sBackgroundColor := clWhite;
  sBackgroundAlpha := 128;
  sBorderColor     := clBlack;
  sBorderAlpha     := 128;
  sForegroundColor := clBlack;
  sForegroundAlpha := 96;
  sVWMSpacing      := 1;
  sHighlightColor  := clNavy;
  sHighlightAlpha  := 128;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with XML.Root.Items do
    begin
      // Load your settings heare
      // Example: sWidth := IntValue('Width',sWidth);
    end;
  XML.Free;
end;

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

procedure TMainForm.UpdateVWMSettings;
begin
  VWMCount := GetVWMCount;
  VWMIndex := GetCurrentVWM;
  VWMHeight := Height - 2;
  VWMWidth := round(VWMHeight / Screen.PrimaryMonitor.Height * Screen.PrimaryMonitor.Width);
end;

procedure TMainForm.SetWidth(new : integer);
begin
  // The Module is receiving it's new size from the SharpBar!
  // Make sure the new width is not negative or zero
  new := Max(new,1);

  // Update the Background Bitmap!
  UpdateBackground(new);

  // Background is updated, now resize the form
  Width := new;

  // Align the Components
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  UpdateVWMSettings;
  DrawVWM;
  DrawVWMToForm;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  // The caption of the module is the description in the module manager!
  UpdateVWMSettings;
  self.Caption := 'VWM' ;

  newWidth := (VWMWidth + 2) * VWMCount + Max(0,(VWMCount - 1)) * sVWMSpacing;
  DrawVWM;

  self.Tag := NewWidth;
  self.Hint := inttostr(NewWidth);

  // Send a message to the bar that the module is requesting a width update
  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;

procedure TMainForm.DrawVWM;
var
  n,i : integer;
  VWMArea : TRect;
  wndlist : TWndArray;
  wndrect : TRect;
  scale : double;
  wndbmp : TBitmap32;
  index : integer;
  DstRect,SrcRect : TRect;
  c : TColor32;
  smod : integer;
  w : integer;
begin
  if VWMCount = 0 then
  begin
    VWM.SetSize(0,0);
    exit;
  end;

  VWM.SetSize((VWMWidth + 2) * VWMCount + Max(0,(VWMCount - 1)) * sVWMSpacing, VWMHeight + 2);
  VWM.Clear(color32(0,0,0,0));

  scale := VWMHeight / Screen.DesktopHeight;

  wndbmp := TBitmap32.Create;
  wndbmp.DrawMode := dmBlend;
  wndbmp.CombineMode := cmMerge;
  wndbmp.SetSize(VWMCount * VWMWidth + VWMSpacing * Max(0,VWMCount - 1),VWMHeight);
  wndbmp.Clear(color32(0,0,0,0));

  for n := 0 to VWMCount - 1 do
  begin
    VWMArea := VWMGetDeskArea(VWMIndex,n);
    wndlist := VWMGetWindowList(VWMArea);

    if n + 1 = VWMIndex then
      smod := 0
    else smod := (n+1) * VWMSpacing;

    for i := High(wndlist) downto 0 do
    begin
      GetWindowRect(wndlist[i],wndrect);
      w := wndRect.Right - wndRect.Left;
      wndrect.Left := round((wndrect.Left + Screen.DesktopLeft - smod) * scale);
      wndrect.Top := Max(0,round((wndrect.Top + Screen.DesktopTop) * scale));
      wndrect.Right := wndrect.Left + round(w * scale);
      wndrect.Bottom := Min(wndbmp.Height,round((wndrect.Bottom + Screen.DesktopTop) * scale));
      c := ColorToColor32Alpha(sBackgroundColor,sForegroundAlpha);
      if n + 1 = VWMIndex then
        c := LightenColor32(c,64);
      wndbmp.FillRect(wndrect.Left,wndrect.Top,wndrect.Right,wndrect.Bottom,c);
      c := ColorToColor32Alpha(sForegroundColor,sForegroundAlpha);
      if n + 1 = VWMIndex then
        c := LightenColor32(c,64);
      wndbmp.FillRect(wndrect.Left + 1 ,wndrect.Top + 1,wndrect.Right - 1,wndrect.Bottom - 1,c);
    end;
  end;

  for n := 0 to VWMCount - 1 do
  begin
    c := ColorToColor32Alpha(sBorderColor,sBorderAlpha);
    if n + 1 = VWMIndex then
      c := LightenColor32(c,32);
    VWM.FrameRectTS(n * (VWMWidth + 2) + n * sVWMSpacing,
                   0,
                   (n+1)*(VWMWidth + 2) + n * sVWMSpacing,
                   VWMHeight + 2,
                   c);
    DstRect.Left := n * (VWMWidth  + 2 ) + 1 + n * sVWMSpacing;
    DstRect.Top := 1;
    DstRect.Right := (n+1) * (VWMWidth + 2) - 1 + n * sVWMSpacing;
    DstRect.Bottom := VWMHeight + 2 - 1;

    c := ColorToColor32Alpha(sBackgroundColor,sBackgroundAlpha);
    if n + 1 = VWMIndex then
      c := ColorToColor32Alpha(sHighlightColor,sHighlightAlpha);
    VWM.FillRectTS(DstRect.Left,DstRect.Top,DstRect.Right,DstRect.Bottom,c);
    index := n + 1;
    if index = VWMIndex then
      index := 1
    else index := index + 1;
    SrcRect.Left := VWMWidth * (index - 1) ;//round((Screen.DesktopWidth * (index - 1) + Max(0,index - 2) * VWMSpacing) * scale);
    SrcRect.Right := VWMWidth * (index) ;//;round((Screen.DesktopWidth * (index)) * scale);
    SrcRect.Top := 0;
    SrcRect.Bottom := wndbmp.Height;
//    VWM.Draw(DstRect,SrcRect,wndbmp);
    wndbmp.DrawTo(VWM,DstRect.Left,DstRect.Top,SrcRect);

    {if n = VWMIndex then
    begin
      index := n + 1;
      SrcRect.Left := round((Screen.DesktopWidth * (index - 1) + Max(0,index - 2) * VWMSpacing) * scale);
      SrcRect.Right := round(SrcRect.Left + Screen.DesktopWidth*scale);
      SrcRect.Top := 0;
      SrcRect.Bottom := wndbmp.Height;
      VWM.Draw(DstRect,SrcRect,wndbmp);
    end;     }
  end;
  wndbmp.Free;  
end;

procedure TMainForm.DrawVWMToForm;
var
  tmp : TBitmap32;
begin
  tmp := TBitmap32.Create;
  tmp.assign(Background);
  VWM.DrawTo(tmp);
  tmp.DrawTo(Canvas.Handle,0,0);
  tmp.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  // Create all clases
  Background := TBitmap32.Create;
  VWM := TBitmap32.Create;
  VWM.SetSize(0,0);
  VWM.DrawMode := dmBlend;
  VWM.CombineMode := cmMerge;

  // Create all visual components
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  // Free all clasess
  Background.Free;
  VWM.Free;

  // Free all Components
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  DrawVWMToForm;
end;

begin
end.
