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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32, GR32_PNG, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math, SharpEEdit, SharpELabel,
  adCpuUsage;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    ClockTimer: TTimer;
    pbar: TSharpEProgressBar;
    cpugraph: TImage32;
    bshape: TShape;
    procedure ClockTimerTimer(Sender: TObject);
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
    oldvalue     : integer;
  public
    ModuleID : integer;
    BarWnd   : hWnd;
    procedure LoadSettings(realign : boolean);
    procedure ReAlignComponents;
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI,
     uSharpDeskFunctions;

{$R *.dfm}


procedure TMainForm.LoadSettings(realign : boolean);
var
  item : TJvSimpleXMLElem;
  cs : TColorSchemeEx;
begin
  sWidth    := 100;
  sDrawMode := 0;
  sCpu      := 0;
  sFGColor  := SharpESkinManager1.Scheme.Throbberback;
  sBGColor  := SharpESkinManager1.Scheme.WorkAreaback;
  sBorderColor := clBlack;
  sUpdate      := 500;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    cs := SharpApi.LoadColorSchemeEx;
    sWidth    := IntValue('Width',100);
    sDrawMode := IntValue('DrawMode',0);
    sCPU      := IntValue('CPU',0);
    sFGColor  := CodeToColorEx(IntValue('FGColor',SharpESkinManager1.Scheme.Throbberback),cs);
    sBGColor  := CodeToColorEx(IntValue('BGColor',SharpESkinManager1.Scheme.WorkAreaback),cs);
    sBorderColor := CodeToColorEx(IntValue('BorderColor',clBlack),cs);
    sUpdate   := IntValue('Update',250);
  end;
  sUpdate := Max(sUpdate,100);

  if realign then ReAlignComponents;
end;

procedure TMainForm.ReAlignComponents;
var
  FreeBarSpace : integer;
  newWidth : integer;
begin
  self.Caption := inttostr(sCPU);

  ClockTimer.Interval := sUpdate;
  bshape.Pen.Color := sBorderColor;
  FreeBarSpace := GetFreeBarSpace(BarWnd) + self.Width;
  if FreeBarSpace <0 then FreeBarSpace := 1;
  newWidth := sWidth + 4;
  if newWidth > FreeBarSpace then Width := FreeBarSpace
     else Width := newWidth;

  case sDrawMode of
    0,1: begin
           pbar.Visible := False;
           bshape.Visible := True;
           cpugraph.Visible := True;
           cpugraph.Left := 2;
           cpugraph.Width := Width - 4;
           cpugraph.Top   := 2;
           cpugraph.Height := Height - 4;
           if (cpugraph.Bitmap.Width <> Max(Width - 4,4)) or
              (cpugraph.Bitmap.Height <> Height -4) then
           begin
             cpugraph.Bitmap.SetSize(Max(Width - 4,4),Height -4);
             cpugraph.Bitmap.Clear(color32(sBGColor));
           end;
           bshape.Left := cpugraph.Left - 1;
           bshape.Top := cpugraph.Top - 1;
           bshape.Width := cpugraph.width + 2;
           bshape.Height := cpugraph.Height + 2;
         end;
    else
    begin
      pbar.Visible := True;
      bshape.Visible := False;
      cpugraph.Visible := False;
      pbar.Left :=  + 2;
      pbar.Top := 4;
      pbar.Width := Width - 4;
      pbar.Height := Height - 8;
    end;
  end;
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
  n : integer;
  cs : TColorSchemeEx;
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

    if SettingsForm.ShowModal = mrOk then
    begin
      cs := SharpApi.LoadColorSchemeEx;
      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      sWidth       := SettingsForm.tb_size.Position;
      sBGColor     := SettingsForm.scb_bg.color;
      sFGColor     := SettingsForm.scb_fg.color;
      sBorderColor := SettingsForm.scb_border.color;
      sUpdate      := SettingsForm.tb_update.Position;
      sCpu         := round(SettingsForm.edit_cpu.Value);
      if SettingsForm.rb_bar.Checked then sDrawMode := 0
         else if SettingsForm.rb_line.Checked then sDrawMode := 1
         else sDrawMode := 2;
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
        Add('Update',sUpdate);
        Add('DrawMode',sDrawMode);
        Add('CPU',sCpu);
        Add('FGColor',ColorToCodeEx(sFGColor,cs));
        Add('BGColor',ColorToCodeEx(sBGColor,cs));
        Add('BorderColor',ColorToCodeEx(sBordercolor,cs));
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    ReAlignComponents;

  finally
    SettingsForm.Free;
    SettingsForm := nil;
    SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  end;
end;

procedure TMainForm.ClockTimerTimer(Sender: TObject);
var
  i : double;
  t : integer;
  bmp : TBitmap32;
begin
  try
    CollectCPUData; // Get the data for all processors

    bmp := cpugraph.Bitmap;
    i := GetCPUUsage(0);
    t := round(i*bmp.Height);
    if t<0 then t := 0
       else if t>bmp.Height then t := bmp.Height;

    if oldvalue<0 then oldvalue := 0
       else if oldvalue>bmp.Height then oldvalue := bmp.Height;

    case sDrawMode of
      0: begin
           bmp.DrawTo(bmp,Rect(0,0,bmp.Width-1,bmp.Height),Rect(1,0,bmp.Width,bmp.Height));
           bmp.Line(bmp.Width-1,0,bmp.Width-1,bmp.Height,color32(sBGColor));
           bmp.Line(bmp.Width-1,bmp.Height-t,bmp.Width-1,bmp.Height,color32(sFGColor));
         end;
      1: begin
           bmp.DrawTo(bmp,Rect(0,0,bmp.Width-2,bmp.Height),Rect(2,0,bmp.Width,bmp.Height));
           bmp.Line(bmp.Width-1,0,bmp.Width-1,bmp.Height,color32(sBGColor));
           bmp.Line(bmp.Width-2,0,bmp.Width-2,bmp.Height,color32(sBGColor));
           bmp.Line(bmp.Width-3,max(0,(bmp.Height-1)-oldvalue),bmp.Width-1,max(0,(bmp.Height-1)-t),color32(sFGColor));
         end;
      2,3: begin
             pbar.value := round(i*100);
           end;
    end;
  except
  end;
  oldvalue := t;
end;

end.
