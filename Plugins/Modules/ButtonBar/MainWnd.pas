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
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Math, GR32,
  JvSimpleXML,
  SharpApi,
  uSharpBarAPI,
  SharpEBaseControls,
  SharpESkin,
  SharpEScheme,
  SharpESkinManager,
  SharpEButton,
  SharpIconUtils;


type
  TButtonRecord = record
                    btn: TSharpEButton;
                    target: String;
                    icon: String;
                    caption: String;
                  end;

  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
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
    FButtonSpacing : integer;
    sShowIcon    : boolean;
    FButtonList  : array of TButtonRecord;
    Background   : TBitmap32;
    procedure ClearButtons;
    procedure AddButton(pTarget,pIcon,pCaption : String);
    procedure UpdateButtons;
  public
    ModuleID : integer;
    BarWnd : hWnd;
    procedure RefreshIcons;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure UpdateBackground(new : integer = -1);
  end;


implementation

uses SettingsWnd;

{$R *.dfm}

procedure TMainForm.ClearButtons;
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
      FButtonList[n].btn.Free;
  setlength(FButtonList,0);
end;

procedure TMainForm.AddButton(pTarget,pIcon,pCaption : String);
begin
  setlength(FButtonList,length(FButtonList)+1);
  with FButtonList[High(FButtonList)] do
  begin
    btn := TSharpEButton.Create(self);
    btn.Visible := False;
    btn.AutoPosition := True;
    btn.AutoSize := True;
    btn.GlyphResize := True;
    btn.Hint := pTarget;
    btn.Width := sWidth;
    btn.Parent := self;
    btn.OnMouseUp := btnMouseUp;
    btn.SkinManager := SharpESkinManager1;

    caption := pCaption;
    target := pTarget;
    icon := pIcon;

    if sShowLabel then
    begin
      btn.Caption := pCaption;
      btn.GlyphSpacing := 4;
    end else
    begin
      btn.Caption := '';
      btn.GlyphSpacing := 0;
    end;

    if sShowIcon then
    begin
      if not IconStringToIcon(pIcon,pTarget,btn.Glyph32) then
         btn.Glyph32.SetSize(0,0)
    end else btn.Glyph32.SetSize(0,0);
  end;
end;

procedure TMainForm.RefreshIcons;
var
  n : integer;
begin
  if not sShowIcon then exit;

  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
           if not IconStringToIcon(Icon,Target,btn.Glyph32) then
              btn.Glyph32.SetSize(0,0)
end;

procedure TMainForm.UpdateButtons;
var
  n : integer;
begin
  for n := 0 to High(FButtonList) do
      with FButtonList[n] do
      begin
        btn.Width := sWidth;
        btn.Left := FButtonSpacing + n*FButtonSpacing + n*sWidth;
        if btn.Left + btn.Width < Width then
           btn.Visible := True
           else btn.Visible := False;
      end;
end;

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
  n : integer;
begin
  ClearButtons;

  sWidth       := 25;
  sShowLabel   := False;
  sShowIcon    := True;
  FButtonSpacing := 2;

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  if item <> nil then with item.Items do
  begin
    sWidth       := IntValue('Width',100);
    sShowLabel   := BoolValue('ShowLabel',True);
    sShowIcon    := BoolValue('ShowIcon',sShowIcon);
    if ItemNamed['Buttons'] <> nil then
    with ItemNamed['Buttons'].Items do
         for n := 0 to Count - 1 do
             AddButton(Item[n].Items.Value('Target','C:\'),
                       Item[n].Items.Value('Icon','shell:icon'),
                       Item[n].Items.Value('Caption','C:\'));
  end;
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

  UpdateButtons;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := 'ButtonBar';
  if sWidth<20 then sWidth := 20;

  newWidth := FButtonSpacing + High(FButtonList)*FButtonSpacing + length(FButtonList)*sWidth + FButtonSpacing;

  self.Tag := NewWidth;
  self.Hint := inttostr(NewWidth);

  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0)
     else UpdateButtons;
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
  n : integer;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.cb_labels.Checked  := sShowLabel;
    SettingsForm.cb_icon.Checked := sShowIcon;
    SettingsForm.tb_size.Position   := sWidth;
    for n := 0 to High(FButtonList) do
        with FButtonList[n] do
             SettingsForm.AddButton(Target,Caption,Icon);

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowLabel := SettingsForm.cb_labels.Checked;
      sWidth := SettingsForm.tb_size.Position;
      sShowIcon := SettingsForm.cb_icon.Checked;

      ClearButtons;
      for n := 0 to SettingsForm.buttons.Items.Count - 1 do
          with SettingsForm.buttons.Items.Item[n] do
               AddButton(SubItems[0],SubItems[1],Caption);

      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('Width',sWidth);
        Add('ShowLabel',sShowLabel);
        Add('ShowIcon',sShowIcon);
        with Add('Buttons').Items do
        begin
          for n := 0 to High(FButtonList) do
          with FButtonList[n] do
               with Add('item').Items do
               begin
                 Add('Target',Target);
                 Add('Icon',Icon);
                 Add('Caption',Caption);
               end;
        end;
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ActionStr : String;
begin
  if Button = mbLeft then
  begin
    ActionStr := TSharpEButton(Sender).Hint;
    if UPPERCASE(ActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(ActionStr);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Background := TBitmap32.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Background.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if Background <> nil then
     Background.DrawTo(Canvas.Handle,0,0);
end;

end.
