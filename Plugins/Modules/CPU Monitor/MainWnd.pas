{
Source Name: MainWnd
Description: CPU Monitor module main window
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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32, GR32_PNG, GR32_Image, SharpEBaseControls,
  SharpESkinManager, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Menus, Math,
  cpuUsage, SharpThemeApi, SharpECustomSkinSettings;


type

  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SkinManager: TSharpESkinManager;
    cpugraphcont: TImage32;
    pbar: TSharpEProgressBar;
    procedure FormPaint(Sender: TObject);
    procedure cpugraphcontDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth       : integer;
    sDrawMode    : integer;
    sCPU         : integer;
    sBGColor     : integer;
    sBorderColor : integer;
    sFGColor     : integer;
    sUpdate      : integer;
    sFGAlpha     : integer;
    sBGAlpha     : integer;
    sBorderAlpha : integer;
    oldvalue     : integer;
    FCustomSkinSettings: TSharpECustomSkinSettings;
  public
    ModuleID : integer;
    BarWnd   : hWnd;
    cpuusage : TCPUUsage;
    cpugraph : TBitmap32;
    background : TBitmap32;
    procedure SetSize(NewWidth : integer);
    procedure LoadSettings;
    procedure ReAlignComponents(broadcast : boolean);
    procedure UpdateGraph;
    procedure UpdateBackground(new : integer = -1);
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI,
     SharpESkinPart;

{$R *.dfm}


procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
  skin : String;
begin
  sWidth    := 100;
  sDrawMode := 0;
  sUpdate   := 500;
  sCpu      := 0;

  // Load Skin custom settings as default
  FCustomSkinSettings.LoadFromXML('');
  try
    with FCustomSkinSettings.xml.Items do
         if ItemNamed['cpumonitor'] <> nil then
            with ItemNamed['cpumonitor'].Items do
            begin
              sFGColor     := SharpESkinPart.SchemedStringToColor(Value('fgcolor','clwhite'),SkinManager.Scheme);
              sBGColor     := SharpESkinPart.SchemedStringToColor(Value('bgcolor','0'),SkinManager.Scheme);
              sBorderColor := SharpESkinPart.SchemedStringToColor(Value('bordercolor','clwhite'),SkinManager.Scheme);
              sFGAlpha     := IntValue('fgalpha',255);
              sBGAlpha     := IntValue('bgalpha',255);
              sBorderAlpha := IntValue('borderalpha',255);
            end;
  except
    sFGColor  := clwhite;
    sBGColor  := 0;
    sBorderColor := clwhite;
    sFGAlpha     := 255;
    sBGAlpha     := 255;
    sBorderAlpha := 255;
  end;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    if ItemNamed['global'] <> nil then
       with ItemNamed['global'].Items do
       begin
         sWidth    := IntValue('Width',100);
         sDrawMode := IntValue('DrawMode',0);
         sCPU      := IntValue('CPU',0);
         sUpdate   := IntValue('Update',250);
       end;

    skin := SharpThemeApi.GetSkinName;
    if ItemNamed['skin'] <> nil then
       if ItemNamed['skin'].Items.ItemNamed[skin] <> nil then
          with ItemNamed['skin'].Items.ItemNamed[skin].Items do
          begin
            sFGColor     := SchemeCodeToColor(IntValue('FGColor',sFGColor));
            sBGColor     := SchemeCodeToColor(IntValue('BGColor',sBGColor));
            sBorderColor := SchemeCodeToColor(IntValue('BorderColor',sBorderColor));
            sFGAlpha     := Max(0,Min(255,IntValue('FGAlpha',sFGAlpha)));
            sBGAlpha     := Max(0,Min(255,IntValue('BGAlpha',sBGAlpha)));
            sBorderAlpha := Max(0,Min(255,IntValue('BorderAlpha',sBorderAlpha)));
          end;
  end;
  sUpdate := Max(sUpdate,100);
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

procedure TMainForm.ReAlignComponents(Broadcast : boolean);
var
  newWidth : integer;
  c : TColor32;
begin
  self.Caption := inttostr(sCPU);

  if cpuUsage.UpdateTimer.Interval = 1001 then cpuUsage.UpdateTimer.Interval := sUpdate
     else sUpdate := cpuUsage.UpdateTimer.Interval;

  newWidth := sWidth + 4;
  Tag := NewWidth;
  Hint := inttostr(NewWidth);
  if newWidth <> Width then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);

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
             background.DrawTo(cpugraphcont.Bitmap,-2,-2);
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

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  NewWidth := Max(1,NewWidth);

  UpdateBackground(NewWidth);

  Width := NewWidth;
  ReAlignComponents(False);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
  skin : String;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.tb_size.Position := sWidth;
    SettingsForm.tb_update.Position := sUpdate;
    case sDrawMode of
      0: SettingsForm.rb_bar.checked := True;
      1: SettingsForm.rb_line.checked := True;
      else SettingsForm.rb_cu.checked := True;
    end;
    SettingsForm.scb_bg.color := sBGColor;
    SettingsForm.scb_fg.color := sFGColor;
    SettingsForm.scb_border.color := sBorderColor;
    SettingsForm.edit_cpu.Value := sCpu;
    SettingsForm.tb_fgalpha.Position := sFGAlpha;
    SettingsForm.tb_bgalpha.Position := sBGAlpha;
    SettingsForm.tb_borderalpha.Position := sBorderAlpha;

    if SettingsForm.ShowModal = mrOk then
    begin
      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      sWidth       := SettingsForm.tb_size.Position;
      sBGColor     := SettingsForm.scb_bg.color;
      sFGColor     := SettingsForm.scb_fg.color;
      sBorderColor := SettingsForm.scb_border.color;
      sUpdate      := SettingsForm.tb_update.Position;
      sCpu         := round(SettingsForm.edit_cpu.Value);
      sFGAlpha     := SettingsForm.tb_fgalpha.Position;
      sBGAlpha     := SettingsForm.tb_bgalpha.Position;
      sBorderAlpha := SettingsForm.tb_borderalpha.Position;
      if SettingsForm.rb_bar.Checked then sDrawMode := 0
         else if SettingsForm.rb_line.Checked then sDrawMode := 1
         else sDrawMode := 2;
      if item <> nil then
         with item.Items do
         begin
           if ItemNamed['global'] = nil then Add('global');
           with ItemNamed['global'].Items do
           begin
             Clear; 
             Add('Width',sWidth);
             Add('Update',sUpdate);
             Add('DrawMode',sDrawMode);
             Add('CPU',sCpu);
           end;

           skin := SharpThemeApi.GetSkinName;
           if ItemNamed['skin'] <> nil then
           begin
             if ItemNamed['skin'].Items.ItemNamed[skin] = nil then
                ItemNamed['skin'].Items.Add(skin);
           end else Add('skin').Items.Add(skin);
           with ItemNamed['skin'].Items.ItemNamed[skin].Items do
           begin
             Clear;
             Add('FGColor',ColorToSchemeCode(sFGColor));
             Add('BGColor',ColorToSchemeCode(sBGColor));
             Add('BorderColor',ColorToSchemeCode(sBordercolor));
             Add('FGAlpha',sFGAlpha);
             Add('BGAlpha',sBGAlpha);
             Add('BorderAlpha',sBorderAlpha);
           end;
         end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
      cpuUsage.UpdateTimer.Interval := sUpdate;
    end;
    ReAlignComponents(True);
  finally
    FreeAndNil(SettingsForm);
  end;
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
      background.DrawTo(cpugraphcont.Bitmap,-cpugraphcont.left,-cpugraphcont.Top);
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
  background := TBitmap32.Create;
  DoubleBuffered := True;
  cpugraph := TBitmap32.Create;
  cpugraph.DrawMode := dmBlend;
  cpugraph.CombineMode := cmMerge;
  FCustomSkinSettings := TSharpECustomSkinSettings.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  background.Free;
  cpugraph.Free;
  FreeAndNil(FCustomSkinSettings);
end;

procedure TMainForm.cpugraphcontDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('TaskMgr.exe');
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

end.
