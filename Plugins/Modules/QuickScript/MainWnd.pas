{
Source Name: MainWnd.pas
Description: QuickScript Module - Main Window
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
  Dialogs, StdCtrls, GR32_Image, GR32_PNG, ImgList, PngImageList,
  JvSimpleXML,
  Jclsysinfo,
  SharpApi,
  uSharpBarAPI,
  SharpEBaseControls,
  SharpESkin,
  SharpEScheme,
  SharpESkinManager,
  SharpEButton,
  SharpECustomSkinSettings,
  SharpEBitmapList,
  uSharpEMenu,
  uSharpEMenuWnd,
  GR32, Menus, Math;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    Button: TSharpEButton;
    SharpESkinManager1: TSharpESkinManager;
    PngImageList1: TPngImageList;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth   : integer;
    sCaption : boolean;
    sIcon    : boolean;
    FIcon    : TBitmap32;
    FMenuIcon1 : TBitmap32;
    FMenuIcon2 : TBitmap32;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure OnScriptClick(Sender : TObject);
    procedure OnNewScriptClick(Sender : TObject);
  end;


implementation

uses SettingsWnd;

{$R *.dfm}
{$R glyphs.res}

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sWidth   := 100;
  sCaption := True;
  sIcon    := True;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sWidth   := IntValue('Width',100);
    sCaption := BoolValue('Caption',True);
    sIcon    := BoolValue('Icon',True); 
  end;
end;

procedure TMainForm.SetWidth(new : integer);
begin
  Width := Max(new,1);
  Button.Width := max(1,Width - 4);

  Background.Bitmap.BeginUpdate;
  Background.Bitmap.SetSize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background.Bitmap,self);
  Background.Bitmap.EndUpdate;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  if sWidth<20 then sWidth := 20;

  Button.Left := 2;

  if (sCaption) then Button.Caption := 'Scripts'
     else Button.Caption := '';
  if (sIcon) then Button.Glyph32.Assign(FIcon)
     else Button.Glyph32.SetSize(0,0);

  newWidth := sWidth + 4;

  self.Tag := NewWidth;
  self.Hint := inttostr(NewWidth);
  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.cb_caption.Checked := sCaption;
    SettingsForm.cb_icon.Checked    := sIcon;
    SettingsForm.tb_size.Position   := sWidth;

    if SettingsForm.ShowModal = mrOk then
    begin
      sCaption := SettingsForm.cb_caption.checked;
      sIcon    := SettingsForm.cb_icon.Checked;
      sWidth   := SettingsForm.tb_size.Position;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
        Add('Caption',sCaption);
        Add('Icon',sIcon);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.OnScriptClick(Sender : TObject);
var
  filename, Dir : String;
begin
  if not (Sender is TMenuItem) then exit;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
  filename := dir + TMenuItem(Sender).Hint;
  if FileExists(FileName) then SharpApi.SharpExecute(FileName);
end;

procedure TMainForm.OnNewScriptClick(Sender : TObject);
begin
  SharpApi.SharpExecute('_nohist,SharpScript.exe -newgenericscript');
end;

procedure TMainForm.ButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sr : TSearchRec;
  Dir : String;
  menu : TMenuItem;
  s : string;
  p : TPoint;
  mn : TSharpEMenu;
  wnd : TSharpEMenuWnd;
begin
  if Button = mbLeft then
  begin
    mn := TSharpEMenu.Create(SharpESkinManager1);
    mn.AddLinkItem('Create New Script','_nohist,{#SharpEDir#}SharpScript.exe -newgenericscript','customicon:edititem',FMenuIcon1,false);
    mn.AddSeparatorItem(False);

    Dir := SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
    if FindFirst(Dir + '*.sescript',FAAnyFile,sr) = 0 then
    repeat
      s := sr.Name;
      setlength(s, length(s)-length('.sescript'));
      mn.AddLinkItem(s,Dir + sr.name,'customicon:scriptitem',FMenuIcon2,False);
    until FindNext(sr) <> 0;
    FindClose(sr);

    wnd := TSharpEMenuWnd.Create(self,mn);
    wnd.FreeMenu := True; // menu will free itself when closed

    p := ClientToScreen(Point(self.Button.Left, self.Height + self.Top));
    wnd.Left := p.x;
    if p.Y < Monitor.Top + Monitor.Height div 2 then
       wnd.Top := p.y
       else wnd.Top := p.y;
    wnd.Show;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
  FIcon := TBitmap32.Create;
  FIcon.Assign(Button.Glyph32);
  FMenuIcon1 := TBitmap32.Create;
  FMenuIcon2 := TBitmap32.Create;

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(22,22);
  TempBmp.Clear(color32(0,0,0,0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, 'edit', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FMenuIcon1.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'file', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FMenuIcon2.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FIcon.Free;
  FMenuIcon1.Free;
  FMenuIcon2.Free;
end;

end.
