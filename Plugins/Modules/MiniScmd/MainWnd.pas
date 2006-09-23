{
Source Name: MainWnd.pas
Description: MiniScmd Main Window
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
  JvSimpleXML, SharpApi, Jclsysinfo, Menus, Math, SharpEEdit;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    edit: TSharpEEdit;
    procedure editKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth      : integer;
    procedure WMUpdateBangs(var Msg : TMessage); message WM_SHARPEUPDATEACTIONS;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

{$R *.dfm}

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  SharpApi.RegisterActionEx(PChar('!FocusMiniScmd ('+inttostr(ModuleID)+')'),'Modules',self.Handle,1);

  sWidth     := 100;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sWidth     := IntValue('Width',100);
  end;
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
  edit.Width := max(1,NewWidth - 4);
end;


procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := '';
  if sWidth<20 then sWidth := 20;

  edit.Left := 2;

  newWidth := sWidth + 4;
  Tag := newWidth;
  Hint := inttostr(newWidth);
  if newWidth <> Width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.tb_size.Position   := sWidth;

    if SettingsForm.ShowModal = mrOk then
    begin
      sWidth      := SettingsForm.tb_size.Position;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.editKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    SetFocus;
    SharpApi.SharpExecute(trim(edit.Edit.Text));
    edit.Text := '';
    edit.Edit.Text := '';
  end;
end;

procedure TMainForm.WMUpdateBangs(var Msg : TMessage);
begin
  SharpApi.RegisterActionEx(PChar('!FocusMiniScmd ('+inttostr(ModuleID)+')'),'Modules',self.Handle,1);
end;

procedure TMainForm.WMSharpEBang(var Msg : TMessage);
begin
  case msg.LParam of
    1: edit.SetFocus;
  end;
end;

end.
