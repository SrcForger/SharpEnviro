{
Source Name: MainWnd.pas
Description: Notes Module - Main Window
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, GR32_Image, GR32, GR32_PNG, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls, SharpEProgressBar,
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    Button: TSharpEButton;
    SharpESkinManager1: TSharpESkinManager;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sCaption     : Boolean;
    sIcon        : Boolean;
    sAlwaysOnTop : Boolean;
    sLeft        : integer;
    sTop         : integer;
    sWidth       : integer;
    sHeight      : integer;
    procedure LoadIcon;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    sLineWrap    : Boolean;
    procedure LoadSettings;
    procedure SaveSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(Broadcast : boolean);
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI, NotesWnd;

{$R *.dfm}
{$R glyphs.res}

procedure TMainForm.LoadIcon;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(32,32);
  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, 'buttonicon', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      Button.Glyph32.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;
  TempBmp.Free;
end;

procedure TMainForm.SaveSettings;
var
  item : TJvSimpleXMLElem;
begin
  if NotesForm <> nil then
  begin
    sLeft := NotesForm.Left;
    sTop  := NotesForm.Top;
    sWidth := NotesForm.Width;
    sHeight := NotesForm.Height;
  end;
  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    clear;
    Add('Caption',sCaption);
    Add('Icon',sIcon);
    Add('AlwaysOnTop',sAlwaysOnTop);
    Add('Left',sLeft);
    Add('Top',sTop);
    Add('Height',sHeight);
    Add('Width',sWidth);
    Add('LineWrap',sLineWrap);
  end;
  uSharpBarAPI.SaveXMLFile(BarWnd);
end;

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
  Mon : TMonitor;
begin
  sCaption     := True;
  sIcon        := True;
  sAlwaysOnTop := True;
  sLineWrap    := True;

  Mon := screen.MonitorFromWindow(Handle);
  sWidth  := 512;
  sHeight := 300;
  sLeft   := Mon.Left + Mon.Width div 2 - sWidth div 2;
  sTop    := Mon.Top + Mon.Height div 2 - sHeight div 2;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sCaption     := BoolValue('Caption',True);
    sIcon        := BoolValue('Icon',True);
    sAlwaysOnTop := BoolValue('AlwaysOnTop',True);
    sLeft        := IntValue('Left',sLeft);
    sTop         := IntValue('Top',sTop);
    sHeight      := Max(64,IntValue('Height',sHeight));
    sWidth       := Max(64,IntValue('Width',sWidth));
    sLineWrap    := BoolValue('LineWrap',False);
  end;
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
  Button.Width := max(1,Width - 4);
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
begin
  Button.Left := 2;
  newWidth := 24;
  if (sIcon) and (Button.Glyph32 <> nil) then
  begin
    LoadIcon;
    newWidth := newWidth + Button.GetIconWidth;
  end else Button.Glyph32.SetSize(0,0);

  if (sCaption) then
  begin
    Button.Caption := ' Notes ';
    newWidth := newWidth + Button.GetTextWidth;
  end else Button.Caption := '';

  Tag := NewWidth;
  Hint := inttostR(NewWidth);
  if newWidth <> Width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0)
        else Button.Width := max(1,Width - 4);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.rb_caption.Checked := (sCaption and (not sIcon));
    SettingsForm.rb_icon.Checked    := (sIcon and (not sCaption));
    SettingsForm.rb_cai.Checked     := (sCaption and sIcon);
    SettingsForm.cb_aot.Checked     := sAlwaysOnTop;

    if SettingsForm.ShowModal = mrOk then
    begin
      sAlwaysOnTop := SettingsForm.cb_aot.Checked;
      sCaption := (SettingsForm.rb_caption.Checked or SettingsForm.rb_cai.Checked);
      sIcon    := (SettingsForm.rb_icon.Checked or SettingsForm.rb_cai.Checked);
      SaveSettings;
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

function PointInRect(P : TPoint; Rect : TRect) : boolean;
begin
  if (P.X>=Rect.Left) and (P.X<=Rect.Right)
     and (P.Y>=Rect.Top) and (P.Y<=Rect.Bottom) then PointInRect:=True
     else PointInRect:=False;
end;

procedure TMainForm.ButtonClick(Sender: TObject);
var
  n : integer;
  b : boolean;
  Mon : TMonitor;
begin
  if NotesForm = nil then NotesForm := TNotesForm.Create(self);

  if NotesForm.Visible then
  begin
    NotesForm.Close;
    exit;
  end;

  // check if the window is in any visible monitor
  b := False;
  for n := 0 to Screen.MonitorCount-1 do
      if ((PointInRect(Point(sLeft,sTop),Screen.Monitors[n].BoundsRect))
         or (PointInRecT(Point(sLeft+sWidth,sTop+sHeight), Screen.Monitors[n].BoundsRect))) then
             b := True;
  if not b then
  begin
    Mon := screen.MonitorFromWindow(Handle);
    sLeft   := Mon.Left + Mon.Width div 2 - sWidth div 2;
    sTop    := Mon.Top + Mon.Height div 2 - sHeight div 2;
  end;

  NotesForm.Left   := sLeft;
  NotesForm.Top    := sTop;
  NotesForm.Width  := sWidth;
  NotesForm.Height := sHeight;
  NotesForm.btn_linewrap.Down := sLineWrap;
  NotesForm.btn_linewrap.OnClick(NotesForm.btn_linewrap);
  NotesForm.Show;
//  if sAlwaysOnTop then SetWindowPos(NotesForm.handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE)
   //  else SetWindowPos(NotesForm.handle, HWND_TOP, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  NotesForm := nil;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  if NotesForm <> nil then FreeAndNil(NotesForm);
end;

end.
