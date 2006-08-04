{
Source Name: MainWnd.pas
Description: Button Module - Main Window
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
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    Button: TSharpEButton;
    SharpESkinManager1: TSharpESkinManager;
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth      : integer;
    sShowLabel  : boolean;
    sCaption    : String;
    sAction     : integer;
    sActionStr  : String;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure ReAlignComponents;
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

{$R *.dfm}

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sWidth     := 100;
  sShowLabel := True;
  sCaption   := 'Menu';
  sAction    := 1;
  sActionStr := '!ShowMenu';

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sWidth     := IntValue('Width',100);
    sShowLabel := BoolValue('ShowLabel',True);
    sCaption   := Value('Caption','SharpE');
    sAction    := IntValue('Action',1);
    sActionStr := Value('ActionStr','!ShowMenu');
  end;

  ReAlignComponents;
end;

procedure TMainForm.ReAlignComponents;
var
  FreeBarSpace : integer;
  newWidth : integer;
begin
  self.Caption := sCaption;
  if sWidth<20 then sWidth := 20;

  Button.Left := 4;
  Button.Height := Height;

  if sShowLabel then Button.Caption := sCaption
     else Button.Caption := '';

  FreeBarSpace := GetFreeBarSpace(BarWnd) + self.Width;
  if FreeBarSpace <0 then FreeBarSpace := 1;
  newWidth := sWidth + 8;
  if newWidth > FreeBarSpace then Width := FreeBarSpace
     else Width := newWidth;

  Button.Width := max(1,Width - 8);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.cb_labels.Checked  := sShowLabel;
    SettingsForm.edit_caption.Text := sCaption;
    SettingsForm.tb_size.Position   := sWidth;
    case sAction of
     1: SettingsForm.cb_sea.Checked := True
     else SettingsForm.cb_ea.Checked := True;
    end;
    SettingsForm.ActionStr := sActionStr;

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowLabel  := SettingsForm.cb_labels.Checked;
      sCaption    := SettingsForm.edit_caption.Text;
      sWidth      := SettingsForm.tb_size.Position;
      sActionStr  := SettingsForm.ActionStr;
      if SettingsForm.cb_sea.Checked then sAction := 1
         else sAction := 2;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
        Add('ShowLabel',sShowLabel);
        Add('Caption',sCaption);
        Add('Action',sAction);
        Add('ActionStr',sActionStr);
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

procedure TMainForm.ButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    if UPPERCASE(sActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(sActionStr);
  end;
end;

end.
