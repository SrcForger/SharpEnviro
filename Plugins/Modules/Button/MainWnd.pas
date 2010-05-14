{
Source Name: MainWnd.pas
Description: Button Module - Main Window
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
  Windows, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, Menus, Math,
  JclSimpleXML, GR32,
  SharpApi,
  SharpEBaseControls,
  SharpEButton,
  SharpIconUtils,
  uISharpBarModule;


type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    btn: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
  private
    sShowLabel   : boolean;
    sCaption     : String;
    sActionStr   : String;
    sActionStrR  : String;
    sIcon        : String;
    sShowIcon    : boolean; 
  public
    mInterface : ISharpBarModule;
    procedure UpdateIcon;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
  end;


implementation

uses
  uSharpXMlUtils;

{$R *.dfm}

procedure TMainForm.UpdateIcon;
var
  size : integer;
begin
  if sShowIcon then
  begin
    size := GetNearestIconSize(mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y);
    if not IconStringToIcon(sIcon,sActionStr,btn.Glyph32,size) then
       btn.Glyph32.SetSize(0,0)
  end else btn.Glyph32.SetSize(0,0);
  btn.Repaint;
end;

procedure TMainForm.UpdateSize;
begin
  btn.Width := Width - 4;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
begin
  sShowLabel   := True;
  sCaption     := 'SharpE';
  sActionStr   := '!OpenMenu: Menu';
  sActionStrR  := 'explorer';
  sIcon        := 'icon.mycomputer';
  sShowIcon    := True;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with xml.Root.Items do
    begin
      sShowLabel   := BoolValue('ShowLabel',sShowLabel);
      sCaption     := Value('Caption',sCaption);
      sActionStr   := Value('ActionStr',sActionStr);
      sActionStrR  := Value('ActionStrR',sActionStrR);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      sIcon        := Value('Icon',sIcon);
    end;
  xml.Free;

  UpdateIcon;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  btn.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
begin
  self.Caption := sCaption;
  btn.Left := 2;
  newWidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
  
  if (sShowIcon) and (btn.Glyph32 <> nil) then
    newWidth := newWidth + btn.GetIconWidth;

  if (sShowLabel) then
  begin
    btn.Caption := sCaption;
    newWidth := newWidth + btn.GetTextWidth;
  end else btn.Caption := '';

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize;
end;

procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
//    if UPPERCASE(sActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(sActionStr);
  end else if Button = mbRight then
  begin
    if length(trim(sActionStrR)) = 0 then
      SharpApi.SharpExecute(sActionStr)
    else SharpApi.SharpExecute(sActionStrR);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
