{
Source Name: MainWnd
Description: CPU Monitor module main window
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
  Dialogs, StdCtrls, GR32, GR32_PNG, GR32_Image, SharpEBaseControls,
  ExtCtrls, SharpEProgressBar, JclSimpleXML, SharpApi, Menus, Math,
  cpuUsage, SharpECustomSkinSettings, uISharpBarModule;


type

  TMainForm = class(TForm)
    cpugraphcont: TImage32;
    pbar: TSharpEProgressBar;
    procedure FormPaint(Sender: TObject);
    procedure cpugraphcontDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  protected
  private
    sWidth          : integer;
    sDrawMode       : integer;
    sCPU            : integer;
    sBGColorStr     : String;
    sBGColor        : integer;
    sBorderColorStr : String;
    sBorderColor    : integer;
    sFGColorStr     : String;
    sFGColor        : integer;
    sUpdate         : integer;
    sFGAlpha        : integer;
    sBGAlpha        : integer;
    sBorderAlpha    : integer;
    oldvalue        : integer;
    FCustomSkinSettings: TSharpECustomSkinSettings;
  public
    cpuusage : TCPUUsage;
    cpugraph : TBitmap32;
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateGraph;
    procedure UpdateComponentSkins;
  end;


implementation

uses
  SharpESkinPart,
  uISharpETheme,
  SharpThemeApiEx;

{$R *.dfm}


procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  skin : String;
  fileloaded : boolean;
  Theme : ISharpETheme;
begin
  sWidth    := 100;
  sDrawMode := 1;
  sUpdate   := 500;
  sCpu      := 0;
  sFGColorStr     := 'clwhite';
  sBGColorStr     := '0';
  sBorderColorStr := 'clwhite';
  sFGAlpha     := 255;
  sBGAlpha     := 64;
  sBorderAlpha := 255;

  // Load Skin custom settings as default
  FCustomSkinSettings.LoadFromXML('');
  try
    with FCustomSkinSettings.xml.Items do
         if ItemNamed['cpumonitor'] <> nil then
            with ItemNamed['cpumonitor'].Items do
            begin
              sFGColorStr     := Value('fgcolor','clwhite');
              sBGColorStr     := Value('bgcolor','0');
              sBorderColorStr := Value('bordercolor','clwhite');
              sFGAlpha        := IntValue('fgalpha',255);
              sBGAlpha        := IntValue('bgalpha',255);
              sBorderAlpha    := IntValue('borderalpha',255);
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
      if ItemNamed['global'] <> nil then
        with ItemNamed['global'].Items do
         begin
           sWidth    := IntValue('Width',sWidth);
           sDrawMode := IntValue('DrawMode',sDrawMode);
           sCPU      := IntValue('CPU',sCpu);
           sUpdate   := IntValue('Update',sUpdate);
         end;

      Theme := GetCurrentTheme;
      skin := Theme.Skin.Name;
      skin := StringReplace(skin,' ','_',[rfReplaceAll]);   
      if ItemNamed['skin'] <> nil then
         if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
            with ItemNamed['skin'].Items.ItemNamed[skin].Items do
            begin
              sFGColorStr     := Value('FGColor',sFGColorStr);
              sBGColorStr     := Value('BGColor',sBGColorStr);
              sBorderColorStr := Value('BorderColor',sBorderColorStr);
              sFGAlpha        := Max(0,Min(255,IntValue('FGAlpha',sFGAlpha)));
              sBGAlpha        := Max(0,Min(255,IntValue('BGAlpha',sBGAlpha)));
              sBorderAlpha    := Max(0,Min(255,IntValue('BorderAlpha',sBorderAlpha)));
            end;
    end;
  XML.Free;
  sUpdate := Max(sUpdate,100);
  cpuUsage.UpdateTimer.Interval := sUpdate;
end;

function ColorToColor32(c : TColor; alpha : integer) : TColor32;
var
  R,G,B : integer;
begin
  R := GetRValue(c);
  G := GetGValue(c);
  B := GetBValue(c);
  result := Color32(R,G,B,alpha);
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
  c : TColor32;
begin
  self.Caption := inttostr(sCPU);

  if cpuUsage.UpdateTimer.Interval = 1001 then cpuUsage.UpdateTimer.Interval := sUpdate
     else sUpdate := cpuUsage.UpdateTimer.Interval;

  if Width < 10 then exit;
  newWidth := sWidth + 4;
  
  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize;

  sFGColor     := SharpESkinPart.ParseColor(sFGColorStr,mInterface.SkinInterface.SkinManager.Scheme);
  sBGColor     := SharpESkinPart.ParseColor(sBGColorStr,mInterface.SkinInterface.SkinManager.Scheme);
  sBorderColor := SharpESkinPart.ParseColor(sBorderColorStr,mInterface.SkinInterface.SkinManager.Scheme);    
  case sDrawMode of
    0,1: begin
           pbar.Visible := False;
           cpugraphcont.Visible := True;
           cpugraphcont.Left := 2;
           cpugraphcont.Width := Width - 4;
           cpugraphcont.Top   := 2;
           cpugraphcont.Height := Height - 4;
           if (cpugraphcont.Bitmap.Width <> Max(Width - 4,4)) or
              (cpugraphcont.Bitmap.Height <> Height -4) then
           begin
             cpugraphcont.Bitmap.SetSize(Max(Width - 4,4),Height -4);
             cpugraph.SetSize(cpugraphcont.Bitmap.Width-2,cpugraphcont.Bitmap.Height-2);
             cpugraph.Clear(color32(0,0,0,0));
             mInterface.Background.DrawTo(cpugraphcont.Bitmap,-2,-2);
             c := ColorToColor32(sBorderColor,sBorderAlpha);
             cpugraphcont.Bitmap.FrameRectS(0,0,cpugraph.Width,cpugraph.Height,c);
             c := ColorToColor32(sBGColor,sBGAlpha);
             cpugraph.FillRect(0,0,cpugraph.Width,cpugraph.Height,c);
           end;
         end;
    else
    begin
      pbar.Visible := True;
      cpugraphcont.Visible := False;
      pbar.Left :=  + 2;
      pbar.Top := 4;
      pbar.Width := Width - 4;
      pbar.Height := Height - 8;
    end;
  end;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  pbar.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateGraph;
var
  i : double;
  t : integer;
  c1,c2 : TColor32;
  bmp : TBitmap32;
begin
  bmp := TBitmap32.create;
  t := 0;
  try
    if cpuusage = nil then exit;

    i := cpuusage.GetCPUUsage(sCPU);
    t := round(i*cpugraph.Height);
    if t<0 then t := 0
       else if t>cpugraph.Height then t := cpugraph.Height;

    if oldvalue<0 then oldvalue := 0
       else if oldvalue>cpugraph.Height then oldvalue := cpugraph.Height;

    c1 := 0;
    c2 := 0;
    if (sDrawMode = 0) or (sDrawMode = 1) then
    begin
      c1 := ColorToColor32(sBGColor,sBGAlpha);
      c2 := ColorToColor32(sFGColor,sFGAlpha);
    end;

    bmp.SetSize(cpugraph.Width,cpugraph.Height);
    bmp.Clear(color32(0,0,0,0));
    case sDrawMode of
      0: begin
           cpugraph.DrawTo(bmp,Rect(0,0,cpugraph.Width-1,cpugraph.Height),Rect(1,0,cpugraph.Width,cpugraph.Height));
           cpugraph.Clear(color32(0,0,0,0));
           bmp.DrawTo(cpugraph);
           cpugraph.Line(cpugraph.Width-1,0,cpugraph.Width-1,cpugraph.Height,c1);
           cpugraph.Line(cpugraph.Width-1,cpugraph.Height-t,cpugraph.Width-1,cpugraph.Height,c2);
         end;
      1: begin
           cpugraph.DrawTo(bmp,Rect(0,0,cpugraph.Width-2,cpugraph.Height),Rect(2,0,cpugraph.Width,cpugraph.Height));
           cpugraph.Clear(color32(0,0,0,0));
           bmp.DrawTo(cpugraph);
           cpugraph.Line(cpugraph.Width-1,0,cpugraph.Width-1,cpugraph.Height,c1);
           cpugraph.Line(cpugraph.Width-2,0,cpugraph.Width-2,cpugraph.Height,c1);
           cpugraph.Line(cpugraph.Width-3,max(0,(cpugraph.Height-1)-oldvalue),cpugraph.Width-1,max(0,(cpugraph.Height-1)-t),c2);
         end;
      2,3: begin
             pbar.value := round(i*100);
           end;
    end;
    if (sDrawMode = 0) or (sDrawMode = 1) then
    begin
      cpugraphcont.Bitmap.BeginUpdate;
      cpugraphcont.Bitmap.Clear(color32(0,0,0,0));
      mInterface.Background.DrawTo(cpugraphcont.Bitmap,-cpugraphcont.left,-cpugraphcont.Top);
      c1 := ColorToColor32(sBorderColor,sBorderAlpha);
      cpugraphcont.Bitmap.FrameRectTS(0,0,cpugraphcont.Bitmap.Width,cpugraphcont.Bitmap.Height,c1);
      cpugraphcont.Bitmap.EndUpdate;
      cpugraph.DrawTo(cpugraphcont.Bitmap,1,1);
    end;
  except
  end;
  bmp.free;
  oldvalue := t;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  cpugraph := TBitmap32.Create;
  cpugraph.DrawMode := dmBlend;
  cpugraph.CombineMode := cmMerge;
  FCustomSkinSettings := TSharpECustomSkinSettings.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  cpugraph.Free;
  FreeAndNil(FCustomSkinSettings);
end;

procedure TMainForm.cpugraphcontDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('TaskMgr.exe');
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

begin
end.
