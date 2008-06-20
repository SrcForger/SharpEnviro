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
  JvSimpleXML, GR32,
  SharpApi,
  uSharpBarAPI,
  SharpEBaseControls,
  SharpESkinManager,
  SharpEButton,
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
    ModuleSize  : TModuleSize;
    Background : TBitmap32;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    procedure UpdateIcon;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateBackground(new : integer = -1);
    procedure SetWidth(new : integer);
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

procedure TMainForm.LoadSettings;
var
  XML : TJvSimpleXML;
  fileloaded : boolean;
begin
  sWidth       := 100;
  sShowLabel   := True;
  sCaption     := 'Menu';
  sActionStr   := '!ShowMenu';
  sSpecialSkin := False;
  FDCaption    := True;
  sIcon        := 'icon.mycomputer';
  sShowIcon    := True;

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
      sWidth       := IntValue('Width',100);
      sShowLabel   := BoolValue('ShowLabel',True);
      sCaption     := Value('Caption','SharpE');
      sActionStr   := Value('ActionStr','!ShowMenu');
      sSpecialSkin := BoolValue('SpecialSkin',False);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      sIcon        := Value('Icon',sIcon);
    end;
  xml.Free;

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
//    self.Tag := PInteger(PModuleSize(@ModuleSize));
//    self.Tag := @PInteger(ModuleSize);
  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
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
  Background := TBitmap32.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Background);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

end.
