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
  JclSimpleXML, GR32,
  SharpApi,
  SharpEBaseControls,
  SharpEButton,
  SharpIconUtils,
  uISharpBarModule,
  ShellApi;


type
  TMainForm = class(TForm)
    btn: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
  private
    sShowIcon    : boolean; 
    sShowLabel   : boolean;
    sIcon        : String; 
    sCaption     : String;
    sMenu        : String;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
  public
    mInterface : ISharpBarModule;
    procedure UpdateIcon;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure UpdateBangs;    
  end;


implementation


{$R *.dfm}

procedure TMainForm.UpdateBangs;
begin
  SharpApi.RegisterActionEx(PChar('!OpenMenu: '+sMenu),'Modules',self.Handle,1);
end;

procedure TMainForm.UpdateComponentSkins;
begin
  btn.SkinManager := mInterface.SkinInterface.SkinManager;
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

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  sShowLabel   := True;
  sCaption     := 'Menu';
  sShowIcon    := True;
  sIcon        := 'icon.mycomputer';
  sMenu        := 'Menu.xml';

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
      sShowLabel   := BoolValue('ShowLabel',sShowLabel);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      sIcon        := Value('Icon',sIcon);
      sMenu        := Value('Menu',sMenu);
      sCaption     := Value('Caption',sCaption);
    end;
  XML.Free;

  UpdateBangs;
  UpdateIcon;
end;

procedure TMainForm.UpdateSize;
begin
  btn.Width := max(1,Width - 4);
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
begin
  self.Caption := sCaption;
  btn.Left := 2;
  newWidth := mInterface.SkinInterface.SkinManager.Skin.ButtonSkin.WidthMod;
  
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
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
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
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  SharpApi.UnRegisterAction(PChar('!OpenMenu: '+sMenu));
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
