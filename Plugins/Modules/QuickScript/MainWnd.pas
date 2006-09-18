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
  Dialogs, StdCtrls, GR32_Image, ExtCtrls, Menus, Math,
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
  GR32, ImgList, PngImageList;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    Button: TSharpEButton;
    SharpESkinManager1: TSharpESkinManager;
    scriptpopup: TPopupMenu;
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
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure OnScriptClick(Sender : TObject);
  end;


implementation

uses SettingsWnd;

{$R *.dfm}

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
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
  i : integer;
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
    SettingsForm.Free;
    SettingsForm := nil;
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

procedure TMainForm.ButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sr : TSearchRec;
  Dir : String;
  menu : TMenuItem;
  s : string;
  p : TPoint;
begin
  if Button = mbLeft then
  begin
    scriptpopup.Items.Clear;
    Dir := SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
    if FindFirst(Dir + '*.sescript',FAAnyFile,sr) = 0 then
    repeat
      menu := TMenuItem.Create(scriptpopup);
      menu.ImageIndex := 0;
      menu.OnClick := OnScriptClick;
      s := sr.Name;
      menu.hint := sr.Name;
      setlength(s, length(s)-length('.sescript'));
      menu.Caption := s;
      scriptpopup.Items.Add(menu);
    until FindNext(sr) <> 0;
    FindClose(sr);

    p := ClientToScreen(Point(self.Button.Left, self.Button.Top));
    if p.Y < Monitor.Top + Monitor.Height div 2 then
       scriptpopup.Popup(p.x,p.y + self.Button.Height)
       else scriptpopup.Popup(p.x,p.y);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FIcon := TBitmap32.CreatE;
  FIcon.Assign(Button.Glyph32);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FIcon.Free;
end;

end.
