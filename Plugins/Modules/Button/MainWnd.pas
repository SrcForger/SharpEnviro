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
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, Menus, Math,
  JvSimpleXML, GR32,
  SharpApi,
  uSharpBarAPI,
  SharpEBaseControls,
  SharpESkinManager,
  SharpEButton,
  SharpECustomSkinSettings,
  SharpIconUtils,
  SharpEBitmapList,
  SharpESkin;


type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    btn: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sWidth       : integer;
    sShowLabel   : boolean;
    sCaption     : String;
    FDCaption    : boolean;
    sActionStr   : String;
    sIcon        : String;
    sShowIcon    : boolean; 
    sSpecialSkin : boolean;
    FCustomSettings : TSharpECustomSkinSettings;
    FCustomBmpList  : TSkinBitmapList;
    ModuleSize  : TModuleSize;
    Background : TBitmap32;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure UpdateIcon;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateCustomSkin;
    procedure UpdateBackground(new : integer = -1);
    procedure SetWidth(new : integer);
  end;


implementation

uses SettingsWnd;

{$R *.dfm}

procedure TMainForm.UpdateIcon;
begin
  if sShowIcon then
  begin
    if not IconStringToIcon(sIcon,sActionStr,btn.Glyph32) then
       btn.Glyph32.SetSize(0,0)
  end else btn.Glyph32.SetSize(0,0);
  btn.Repaint;
end;

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
                 if btn.CustomSkin = nil then
                    btn.CustomSkin := TSharpEButtonSkin.Create(FCustomBmpList)
                    else btn.CustomSkin.Clear;
                 btn.CustomSkin.LoadFromXML(Item[n].Items.ItemNamed['skin'].Items.ItemNamed['button'],FCustomSettings.Path);
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
  sActionStr   := '!ShowMenu';
  sSpecialSkin := False;
  FDCaption    := True;
  sIcon        := 'icon.mycomputer';
  sShowIcon    := True; 

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sWidth       := IntValue('Width',100);
    sShowLabel   := BoolValue('ShowLabel',True);
    sCaption     := Value('Caption','SharpE');
    sActionStr   := Value('ActionStr','!ShowMenu');
    sSpecialSkin := BoolValue('SpecialSkin',False);
    sShowIcon    := BoolValue('ShowIcon',sShowIcon);
    sIcon        := Value('Icon',sIcon); 
  end;

  UpdateCustomSkin;
  UpdateIcon;
end;

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

procedure TMainForm.SetWidth(new : integer);
begin
  new := Max(new,1);

  UpdateBackground(new);

  Width := new;
  btn.Width := max(1,Width - 4);
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
    SettingsForm.ActionStr := sActionStr;
    SettingsForm.edit_action.Text := sActionStr;
    SettingsForm.edit_icon.Text := sIcon;
    SettingsForm.cb_icon.Checked := sShowIcon;
    SettingsForm.cb_icon.OnClick(SettingsForm.cb_icon);
    SettingsForm.cb_labels.OnClick(SettingsForm.cb_labels);
    SettingsForm.UpdateIcon;

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowLabel := SettingsForm.cb_labels.Checked;
      sCaption := SettingsForm.Edit_caption.Text;
      sWidth := SettingsForm.tb_size.Position;
      sSpecialSkin := SettingsForm.cb_specialskin.Checked;
      sActionStr  := SettingsForm.ActionStr;
      sSpecialSkin := SettingsForm.cb_specialskin.Checked;
      sShowIcon := SettingsForm.cb_icon.Checked;
      sIcon := SettingsForm.edit_icon.Text;

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
        Add('ShowLabel',sShowLabel);
        Add('Caption',sCaption);
        Add('ActionStr',sActionStr);
        Add('SpecialSkin',sSpecialSkin);
        Add('ShowIcon',sShowIcon);
        Add('Icon',sIcon);
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
begin
  if Button = mbLeft then
  begin
    if UPPERCASE(sActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(sActionStr);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Background := TBitmap32.Create;
  FCustomSettings := TSharpECustomSkinSettings.Create;
  FCustomBmpList  := TSkinBitmapList.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Background);
  FCustomSettings.Free;
  FCustomBmpList.Clear;
  FCustomBmpList.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

end.
