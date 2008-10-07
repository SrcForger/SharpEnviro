{
Source Name: MainWnd.pas
Description: Button Module - Main Window
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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

procedure TMainForm.UpdateSize;
begin
  btn.Width := Width - 4;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  sShowLabel   := True;
  sCaption     := 'Menu';
  sActionStr   := '!ShowMenu';
  sIcon        := 'icon.mycomputer';
  sShowIcon    := True;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sShowLabel   := BoolValue('ShowLabel',True);
      sCaption     := Value('Caption','SharpE');
      sActionStr   := Value('ActionStr','!ShowMenu');
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
  newWidth := 24;
  
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
    if UPPERCASE(sActionStr) = '!SHOWMENU' then SetForegroundWindow(FindWindow(nil,'SharpMenuWMForm'));
    SharpApi.SharpExecute(sActionStr);
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
