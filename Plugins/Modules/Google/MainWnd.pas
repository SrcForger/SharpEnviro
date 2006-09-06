{
Source Name: MainWnd.pas
Description: Google Main Window
Copyright (C) Viper <tom_viper@msn.com>

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
  StdCtrls, Math, Menus, GR32_Image, SharpEBaseControls, SharpEButton,
  SharpESkinManager, SharpEScheme, SharpESkin, ExtCtrls,
  JvSimpleXML, SharpApi, SharpEEdit;

type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    edit: TSharpEEdit;
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);

    procedure editKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth : integer;

    procedure EditEnter(Sender: TObject);
    procedure EditExit(Sender: TObject);

    procedure WMUpdateBangs(var Msg : TMessage); message WM_SHARPEUPDATEACTIONS;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
  public
    BangCommand_Append: string;

    ModuleID : integer;
    BarWnd : hWnd;

    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure RegisterBangs;
    procedure SetSize(NewWidth : integer);
    procedure UnRegisterBangs;
  end;


implementation

uses SettingsWnd,
     uSharpBarAPI;

{$R *.dfm}

{$REGION ' Form Events and Procedures '}
procedure TMainForm.FormCreate(Sender: TObject);
begin
  Edit.Edit.OnEnter := EditEnter;
  Edit.Edit.OnExit := EditExit;
end;
procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//
end;
procedure TMainForm.FormDestroy(Sender: TObject);
begin
//
end;
procedure TMainForm.WMUpdateBangs(var Msg : TMessage);
begin
  RegisterBangs;
end;
procedure TMainForm.WMSharpEBang(var Msg : TMessage);
begin
  case msg.LParam of
    0: edit.SetFocus;
  end;
end;
{$ENDREGION}

{$REGION ' Configuration Procedures '}
procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sWidth := 150;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if (item <> nil) then with item.Items do
   begin
    sWidth := IntValue('Width',150);
   end;

//  ReAlignComponents(False);
end;
procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  SettingsForm := TSettingsForm.Create(nil);
  try
    SettingsForm.tb_size.Position := sWidth;

    if (SettingsForm.ShowModal = mrOk) then
    begin
      sWidth := SettingsForm.tb_size.Position;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if (item <> nil) then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
//    SettingsForm := nil;
    SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
  end;
end;
{$ENDREGION}

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  if (sWidth < 20) then sWidth := 20;

  edit.Left := 2;

  newWidth := (sWidth + 4);

  if (newWidth <> Width) then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;
procedure TMainForm.SetSize(NewWidth : integer);
begin
  Width := NewWidth;
  edit.Width := max(1,NewWidth - 4);
end;

{$REGION ' Bang Procedures '}
procedure TMainForm.RegisterBangs;
begin
  SharpApi.RegisterActionEx(PChar('!FocusGoogleCmd' + BangCommand_Append),'Modules',Handle,0);
end;
procedure TMainForm.UnRegisterBangs;
begin
  SharpApi.UnRegisterAction(PChar('!FocusGoogleCmd' + BangCommand_Append));
end;
{$ENDREGION}

{$REGION ' Edit Procedures '}
procedure TMainForm.EditEnter(Sender: TObject);
begin
  if (lowercase(Edit.Edit.Text) = 'google') then
   begin
//    Edit.Text := '';
    Edit.Edit.Text := '';
   end;
end;
procedure TMainForm.EditExit(Sender: TObject);
begin
  if (Length(Edit.Edit.Text) = 0) then
   begin
//    Edit.Text := '';
    Edit.Edit.Text := 'Google';
   end;
end;
procedure TMainForm.editKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    SetFocus;
    SharpApi.SharpExecute('http://www.google.com/search?&q=' + edit.Edit.Text);
  end;
end;
{$ENDREGION}
end.
