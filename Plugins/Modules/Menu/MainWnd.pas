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
    procedure btnMouseEnter(Sender: TObject);
  protected
  private
    FLastMenuWnd : hwnd;
    sShowIcon    : boolean; 
    sShowLabel   : boolean;
    sIcon        : String; 
    sCaption     : String;
    sMenu        : String;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
    procedure WMShellHook(var msg : TMessage); message WM_SHARPSHELLMESSAGE;    

    procedure OpenMenu;
    procedure CheckMenu;
  public
    mInterface : ISharpBarModule;
    procedure UpdateIcon;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure UpdateBangs;
    procedure InitHook;
  end;


implementation

uses
  uSharpXMLUtils;


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
    1: OpenMenu;
  end;
end;

procedure TMainForm.WMShellHook(var msg: TMessage);
begin
  if (msg.wparam = HSHELL_WINDOWACTIVATED) or
    (msg.wparam = HSHELL_WINDOWACTIVATED + 32768) or
    (msg.wParam = HSHELL_WINDOWDESTROYED) or
    (msg.wparam = HSHeLL_WINDOWCREATED) then
    CheckMenu;
end;

procedure TMainForm.UpdateIcon;
var
  size : integer;
begin
  if sShowIcon then
  begin
    size := GetNearestIconSize(mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y);

    if not IconStringToIcon(sIcon,'',btn.Glyph32,size) then
       btn.Glyph32.SetSize(0,0)
  end else btn.Glyph32.SetSize(0,0);
  btn.Repaint;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
begin
  sShowLabel   := True;
  sCaption     := 'Menu';
  sShowIcon    := True;
  sIcon        := 'icon.mycomputer';
  sMenu        := 'Menu.xml';

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
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
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;


procedure TMainForm.OpenMenu;
var
  ActionStr, pdir : String;
  p : TPoint;
  R : TRect;
begin
  GetWindowRect(mInterface.BarInterface.BarWnd,R);
  p := ClientToScreen(Point(btn.Left + btn.Width div 2, self.Height + self.Top));
  p.x := p.x - btn.Width div 2;
  p.y := R.Top;
  if p.y > Monitor.Top + Monitor.Height div 2 then
  begin
    p.y := R.Top;
    pdir := '-1';
  end
  else
  begin
    p.y := R.Bottom;
    pdir := '1';
  end;
//    ActionStr := SharpApi.GetSharpeDirectory;
//    ActionStr := ActionStr + 'SharpMenu.exe';
//    ActionStr := ActionStr + ' ' + inttostr(p.x) + ' ' + inttostr(p.y);
  ActionStr := inttostr(p.x) + ' ' + inttostr(p.y) + ' ' + pdir;
  ActionStr := ActionStr + ' "' + SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\';
  ActionStr := ActionStr + sMenu + '.xml"';
  ShellApi.ShellExecute(Handle,'open',PChar(GetSharpEDirectory + 'SharpMenu.exe'),PChar(ActionStr),PChar(GetSharpEDirectory),SW_SHOWNORMAL);
  //SharpApi.SharpExecute(ActionStr);
end;

procedure TMainForm.btnMouseEnter(Sender: TObject);
var
  wnd : HWND;
  atm : Word;
  buf : PAnsiChar;
begin
  wnd := FindWindow('TSharpEMenuWnd', 'Menu');
  if wnd <> 0 then
  begin
    atm := SendMessage(wnd, WM_MENUID, 0, 0);

    buf := StrAlloc(256);
    GlobalGetAtomName(atm, buf, 256);
    GlobalDeleteAtom(atm);

    if buf <> sMenu then
    begin
      SendMessage(wnd, WM_SHARPTERMINATE, 0, 0);
      OpenMenu;
    end;
  end;
end;

procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    OpenMenu;
  end;
end;

procedure TMainForm.CheckMenu;
var
  wnd : HWND;
  atm : Word;
  buf : PAnsiChar;
begin
  wnd := FindWindow('TSharpEMenuWnd', 'Menu');
  if wnd <> 0 then
  begin
    if IsWindow(FLastMenuWnd) then
      wnd := FLastMenuWnd
    else
      FLastMenuWnd := 0;

    atm := SendMessage(wnd, WM_MENUID, 0, 0);

    buf := StrAlloc(256);
    GlobalGetAtomName(atm, buf, 256);
    GlobalDeleteAtom(atm);

    if buf = sMenu then
    begin
      FLastMenuWnd := wnd;
      btn.ForceHover := True;
    end else
      btn.ForceHover := False;
  end else
  begin
    btn.ForceHover := False;
    FLastMenuWnd := 0;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
  FLastMenuWnd := 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  UnRegisterShellHookReceiver(Handle);
  SharpApi.UnRegisterAction(PChar('!OpenMenu: '+sMenu));
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.InitHook;
begin
  SharpApi.RegisterShellHookReceiver(Handle)
end;

end.
