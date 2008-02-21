{
Source Name: MainWnd.pas
Description: Menu Module - Main Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpenviro.com

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}

unit MainWnd;

interface

uses
  Messages, Windows, SysUtils, Classes, Controls, Forms, Types,
  Dialogs, StdCtrls, Menus, Math,
  JvSimpleXML, GR32,
  SharpApi,
  uSharpBarAPI,
  SharpEBaseControls,
  SharpESkin,
  SharpEScheme,
  SharpESkinManager,
  SharpEButton,
  SharpECustomSkinSettings,
  SharpEBitmapList,
  SharpIconUtils,
  ShellApi;


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
    Background : TBitmap32;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    procedure UpdateBangs;
    procedure UpdateIcon;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateCustomSkin;
    procedure SetWidth(new : integer);
    procedure UpdateBackground(new : integer = -1);
  end;


implementation

uses SettingsWnd;

{$R *.dfm}

procedure TMainForm.UpdateBangs;
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
  XML : TJvSimpleXML;
  fileloaded : boolean;
begin
  sWidth       := 100;
  sShowLabel   := True;
  sCaption     := 'Menu';
  sShowIcon    := True;
  sIcon        := 'icon.mycomputer';
  sSpecialSkin := False;
  sMenu        := 'Menu.xml';
  FDCaption    := True;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sWidth       := IntValue('Width',sWidth);
      sShowLabel   := BoolValue('ShowLabel',sShowLabel);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      sIcon        := Value('Icon',sIcon);
      sMenu        := Value('Menu',sMenu);
      sCaption     := Value('Caption',sCaption);
      sSpecialSkin := BoolValue('SpecialSkin',sSpecialSkin);
    end;
  XML.Free;

  UpdateBangs;

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
    btn.Caption := sCaption
  else
    btn.Caption := '';

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
  XML : TJvSimpleXML;
begin
  try
    SettingsForm := TSettingsForm.Create(application.MainForm);
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

      XML := TJvSimpleXMl.Create(nil);
      XML.Root.Name := 'MenuModuleSettings';
      with XML.Root.Items do
      begin
        Add('Width',sWidth);
        Add('ShowLabel',sShowLabel);
        Add('ShowIcon',sShowIcon);
        Add('Icon',sIcon);
        Add('SpecialSkin',sSpecialSkin);
        Add('Menu',sMenu);
        Add('Caption',sCaption);
      end;
      UpdateIcon;
      XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
      XML.Free;
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
  ActionStr, pdir : String;
  p : TPoint;
begin
  if Button = mbLeft then
  begin
    p := ClientToScreen(Point(btn.Left,btn.Top));
    if p.y > Monitor.Top + Monitor.Height div 2 then
    begin
      p.y := p.y;
      pdir := '-1';
    end
    else
    begin
      p.y := p.y + Height - btn.Top;
      pdir := '1';
    end;
//    ActionStr := SharpApi.GetSharpeDirectory;
//    ActionStr := ActionStr + 'SharpMenu.exe';
//    ActionStr := ActionStr + ' ' + inttostr(p.x) + ' ' + inttostr(p.y);
    ActionStr := inttostr(p.x) + ' ' + inttostr(p.y) + ' ' + pdir;
    ActionStr := ActionStr + ' "' + SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\';
    ActionStr := ActionStr + sMenu + '.xml"';
    ShellApi.ShellExecute(Handle,'open',PChar(GetSharpEDirectory + 'SharpMenu.exe'),PChar(ActionStr),GetSharpEDirectory,SW_SHOWNORMAL);
    //SharpApi.SharpExecute(ActionStr);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  Background := TBitmap32.Create;
  FCustomSettings := TSharpECustomSkinSettings.Create;
  FCustomBmpList  := TSkinBitmapList.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Background.Free;
  FCustomSettings.Free;
  FCustomBmpList.Clear;
  FCustomBmpList.Free;

  SharpApi.UnRegisterAction(PChar('!OpenMenu: '+sMenu));
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

end.
