{
Source Name: MainWnd.pas
Description: Menu Module - Main Window
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
  SharpIconUtils;


type
  TMainForm = class(TForm)
    Background: TImage32;
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    btn: TSharpEButton;
    SharpESkinManager1: TSharpESkinManager;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth       : integer;
    sShowIcon    : boolean; 
    sShowLabel   : boolean;
    sIcon        : String; 
    sCaption     : String;
    FDCaption    : boolean;
    sSpecialSkin : boolean;
    sMenu        : String;
    FCustomSettings : TSharpECustomSkinSettings;
    FCustomBmpList  : TSkinBitmapList;
    ModuleSize  : TModuleSize;
    procedure WMUpdateBangs(var Msg : TMessage); message WM_SHARPEUPDATEACTIONS;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure UpdateIcon;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateCustomSkin;
    procedure SetWidth(new : integer);
  end;


implementation

uses SettingsWnd;

{$R *.dfm}

procedure TMainForm.WMUpdateBangs(var Msg : TMessage);
begin
  SharpApi.RegisterActionEx(PChar('!OpenMenu: '+sMenu),'Modules',self.Handle,1);
end;

procedure TMainForm.WMSharpEBang(var Msg : TMessage);
begin
  case msg.LParam of
    1: btn.OnMouseUp(btn,mbLeft,[],0,0);
  end;
end;

procedure TMainForm.UpdateIcon;
begin
  if sShowIcon then
  begin
    if not IconStringToIcon(sIcon,'',btn.Glyph32) then
       btn.Glyph32.SetSize(0,0)
  end else btn.Glyph32.SetSize(0,0);
  btn.Repaint;
end;

procedure TMainForm.UpdateCustomSkin;
begin
  if sSpecialSkin then
  begin
    FCustomSettings.LoadFromXML('');
    try
      if FCustomSettings.xml.Items.ItemNamed['menu'] <> nil then
      with FCustomSettings.xml.Items.ItemNamed['menu'].Items do
      begin
         if ItemNamed['button'] <> nil then
         begin
           // found custom skin!
           FDCaption := BoolValue('DisplayCaption',True);
           FCustomBmpList.Clear;
           if btn.CustomSkin = nil then
              btn.CustomSkin := TSharpEButtonSkin.Create(FCustomBmpList)
              else btn.CustomSkin.Clear;
           btn.CustomSkin.LoadFromXML(ItemNamed['button'],FCustomSettings.Path);
           exit;
         end;
       end;
    except
    end;
  end;

  FDCaption := True;
  FCustomBmpList.Clear;
  // nothing loaded - remove custom skin
  if btn.CustomSkin <> nil then
  begin
    btn.CustomSkin.Free;
    btn.CustomSkin := nil;
  end;
end;

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
begin
  sWidth       := 100;
  sShowLabel   := True;
  sCaption     := 'Menu';
  sShowIcon    := True;
  sIcon        := 'icon.mycomputer';
  sSpecialSkin := False;
  sMenu        := 'Menu.xml';
  FDCaption    := True;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sWidth       := IntValue('Width',sWidth);
    sShowLabel   := BoolValue('ShowLabel',sShowLabel);
    sShowIcon    := BoolValue('ShowIcon',sShowIcon);
    sIcon        := Value('Icon',sIcon); 
    sMenu        := Value('Menu',sMenu);
    sCaption     := Value('Caption',sCaption);
    sSpecialSkin := BoolValue('SpecialSkin',sSpecialSkin);
  end;

  SharpApi.RegisterActionEx(PChar('!OpenMenu: '+sMenu),'Modules',self.Handle,1);

  UpdateCustomSkin;
  UpdateIcon;
end;

procedure TMainForm.SetWidth(new : integer);
begin
  Width := Max(new,1);
  btn.Width := max(1,Width - 4);

  Background.Bitmap.BeginUpdate;
  Background.Bitmap.SetSize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background.Bitmap,self);
  Background.Bitmap.EndUpdate;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
  i : integer;
begin
  self.Caption := sCaption;
  if sWidth<20 then sWidth := 20;

  btn.Left := 2;

  if (sShowLabel) and (FDCaption) then
  begin
    btn.GlyphSpacing := 4;
    btn.Caption := sCaption
  end else
  begin
    btn.GlyphSpacing := 0;
    btn.Caption := '';
  end;

  if btn.CustomSkin <> nil then
  begin
    try
      i := strtoint(btn.CustomSkin.SkinDim.Width);
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
    SettingsForm.edit_icon.Text := sIcon;
    SettingsForm.cb_icon.Checked := sShowIcon;
    SettingsForm.cb_icon.OnClick(SettingsForm.cb_icon);
    SettingsForm.cb_labels.OnClick(SettingsForm.cb_labels);
    SettingsForm.cb_specialskin.Checked := sSpecialSkin;
    SettingsForm.UpdateIcon;
    SettingsForm.sMenu := sMenu;

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowLabel := SettingsForm.cb_labels.Checked;
      sCaption := SettingsForm.Edit_caption.Text;
      sWidth := SettingsForm.tb_size.Position;
      sSpecialSkin := SettingsForm.cb_specialskin.Checked;

      SharpApi.UnRegisterAction(PChar('!OpenMenu: '+sMenu));
      sMenu  := SettingsForm.sMenu;
      SharpApi.RegisterActionEx(PChar('!OpenMenu: '+sMenu),'Modules',self.Handle,1);

      sShowIcon := SettingsForm.cb_icon.Checked;
      sIcon := SettingsForm.edit_icon.Text;
      sSpecialSkin := SettingsForm.cb_specialskin.Checked;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
        Add('ShowLabel',sShowLabel);
        Add('ShowIcon',sShowIcon);
        Add('Icon',sIcon);
        Add('SpecialSkin',sSpecialSkin);
        Add('Menu',sMenu);
        Add('Caption',sCaption);
      end;
      UpdateIcon;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    UpdateCustomSkin;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ActionStr : String;
  p : TPoint;
begin
  if Button = mbLeft then
  begin
    p := ClientToScreen(Point(btn.Left,btn.Top));
    p.y := p.y + Height - btn.Top;
    ActionStr := SharpApi.GetSharpeDirectory;
    ActionStr := ActionStr + 'SharpMenu.exe';
    ActionStr := ActionStr + ' ' + inttostr(p.x) + ' ' + inttostr(p.y);
    ActionStr := ActionStr + ' ' + SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\';
    ActionStr := ActionStr + sMenu + '.xml';
    SharpApi.SharpExecute(ActionStr);
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

  SharpApi.UnRegisterAction(PChar('!OpenMenu: '+sMenu));
end;

end.
