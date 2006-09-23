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
  SharpEBitmapList;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    Button: TSharpEButton;
    SharpESkinManager1: TSharpESkinManager;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth       : integer;
    sShowLabel   : boolean;
    sCaption     : String;
    FDCaption    : boolean;
    sAction      : integer;
    sActionStr   : String;
    sSpecialSkin : boolean;
    FCustomSettings : TSharpECustomSkinSettings;
    FCustomBmpList  : TSkinBitmapList;
    ModuleSize  : TModuleSize;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateCustomSkin;
    procedure SetWidth(new : integer);
  end;


implementation

uses SettingsWnd;

{$R *.dfm}

procedure TMainForm.UpdateCustomSkin;
var
  n : integer;
begin
  if sSpecialSkin then
  begin
    FCustomSettings.LoadFromXML('');
    try
      if FCustomSettings.xml.Items.ItemNamed['button'] <> nil then
      with FCustomSettings.xml.Items.ItemNamed['button'].Items do
      begin
        for n := 0 to Count -1 do
        begin
          if UPPERCASE(Item[n].Items.Value('ActionStr','-1')) = UPPERCASE(sActionStr) then
          begin
            if Item[n].Items.ItemNamed['skin'] <> nil then
               if Item[n].Items.ItemNamed['skin'].Items.ItemNamed['button'] <> nil then
               begin
                 // found custom skin!
                 FDCaption := Item[n].Items.BoolValue('DisplayCaption',True);
                 FCustomBmpList.Clear;
                 if Button.CustomSkin = nil then
                    Button.CustomSkin := TSharpEButtonSkin.Create(FCustomBmpList)
                    else Button.CustomSkin.Clear;
                 Button.CustomSkin.LoadFromXML(Item[n].Items.ItemNamed['skin'].Items.ItemNamed['button'],FCustomSettings.Path);
                 exit;
               end;
          end;
        end;
      end;
    except
    end;
  end;

  FDCaption := True;
  FCustomBmpList.Clear;
  // nothing loaded - remove custom skin
  if Button.CustomSkin <> nil then
  begin
    Button.CustomSkin.Free;
    Button.CustomSkin := nil;
  end;
end;

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sWidth       := 100;
  sShowLabel   := True;
  sCaption     := 'Menu';
  sAction      := 1;
  sActionStr   := '!ShowMenu';
  sSpecialSkin := True;
  FDCaption    := True;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sWidth       := IntValue('Width',100);
    sShowLabel   := BoolValue('ShowLabel',True);
    sCaption     := Value('Caption','SharpE');
    sAction      := IntValue('Action',1);
    sActionStr   := Value('ActionStr','!ShowMenu');
    sSpecialSkin := BoolValue('SpecialSkin',True);
  end;

  UpdateCustomSkin;
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
  self.Caption := sCaption;
  if sWidth<20 then sWidth := 20;

  Button.Left := 2;

  if (sShowLabel) and (FDCaption) then Button.Caption := sCaption
     else Button.Caption := '';

  if Button.CustomSkin <> nil then
  begin
    try
      i := strtoint(Button.CustomSkin.SkinDim.Width);
      NewWidth := i + 4;
    except
      newWidth := sWidth + 8;
    end;
  end else newWidth := sWidth + 8;

  ModuleSize.Min := NewWidth;
  ModuleSize.Width := NewWidth;
  ModuleSize.Priority := 0;
  self.Tag := NewWidth;
  self.Hint := inttostr(NewWidth);
//    self.Tag := PInteger(PModuleSize(@ModuleSize));
//    self.Tag := @PInteger(ModuleSize);
  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
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
    SettingsForm.cb_specialskin.Checked := sSpecialSkin;
    case sAction of
     1: SettingsForm.cb_sea.Checked := True;
     3: SettingsForm.cb_script.Checked := True;
     else SettingsForm.cb_ea.Checked := True;
    end;
    SettingsForm.ActionStr := sActionStr;

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowLabel  := SettingsForm.cb_labels.Checked;
      sCaption    := SettingsForm.edit_caption.Text;
      sWidth      := SettingsForm.tb_size.Position;
      sActionStr  := SettingsForm.ActionStr;
      sSpecialSkin := SettingsForm.cb_specialskin.Checked;
      if SettingsForm.cb_sea.Checked then sAction := 1
         else if SettingsForm.cb_script.Checked then sAction := 3
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
        Add('SpecialSkin',sSpecialSkin);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    UpdateCustomSkin;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
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

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FCustomSettings := TSharpECustomSkinSettings.Create;
  FCustomBmpList  := TSkinBitmapList.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FCustomSettings.Free;
  FCustomBmpList.Clear;
  FCustomBmpList.Free;
end;

end.
