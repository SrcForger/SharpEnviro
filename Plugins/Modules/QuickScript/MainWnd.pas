{
Source Name: MainWnd.pas
Description: QuickScript Module - Main Window
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
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, GR32_PNG, Types,
  JvSimpleXML,
  SharpApi,
  uSharpBarAPI,
  SharpEBaseControls,
  SharpESkinManager,
  SharpEButton,
  SharpECustomSkinSettings,
  uSharpEMenu,
  uSharpEMenuWnd,
  uSharpEMenuSettings,
  GR32, Menus, Math, ImgList, PngImageList;


type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    PngImageList1: TPngImageList;
    Button: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sCaption : Boolean;
    sIcon    : Boolean;
    FIcon    : TBitmap32;
    FMenuIcon1 : TBitmap32;
    FMenuIcon2 : TBitmap32;
    Background : TBitmap32;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure OnScriptClick(Sender : TObject);
    procedure OnNewScriptClick(Sender : TObject);
    procedure UpdateBackground(new : integer = -1);
  end;


implementation

uses SettingsWnd;

{$R *.dfm}
{$R icons.res}

procedure TMainForm.LoadSettings;
var
  XML : TJvSimpleXML;
  fileloaded : boolean;
begin
  sCaption := True;
  sIcon    := True;

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
      sCaption := BoolValue('Caption',True);
      sIcon    := BoolValue('Icon',True);
    end;
  XML.Free;
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
  Button.Width := max(1,Width - 4);
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  Button.Left := 2;
  newWidth := 24;
  if (sIcon) and (Button.Glyph32 <> nil) then
  begin
    Button.Glyph32.Assign(FIcon);
    newWidth := newWidth + Button.GetIconWidth;
  end else Button.Glyph32.SetSize(0,0);

  if (sCaption) then
  begin
    Button.Caption := ' Scripts ';
    newWidth := newWidth + Button.GetTextWidth;
  end else Button.Caption := '';

  Tag := NewWidth;
  Hint := inttostR(NewWidth);
  if newWidth <> Width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0)
        else Button.Width := max(1,Width - 4);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  XML : TJvSimpleXML;
begin
  try
    SettingsForm := TSettingsForm.Create(application.MainForm);
    SettingsForm.rb_caption.Checked := (sCaption and (not sIcon));
    SettingsForm.rb_icon.Checked    := (sIcon and (not sCaption));
    SettingsForm.rb_cai.Checked     := (sCaption and sIcon);

    if SettingsForm.ShowModal = mrOk then
    begin
      sCaption := (SettingsForm.rb_caption.Checked or SettingsForm.rb_cai.Checked);
      sIcon    := (SettingsForm.rb_icon.Checked or SettingsForm.rb_cai.Checked);

      XML := TJvSimpleXML.Create(nil);
      XML.Root.Name := 'QuickScriptModuleSettings';
      with XML.Root.Items do
      begin
        Add('Caption',sCaption);
        Add('Icon',sIcon);
      end;
      XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
      XML.Free;
    end;
    ReAlignComponents(True);

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.OnScriptClick(Sender : TObject);
var
  filename, Dir : String;
begin
  if not (Sender is TMenuItem) then exit;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
  filename := dir + TMenuItem(Sender).Hint;
  if FileExists(FileName) then SharpApi.SharpExecute(FileName);
end;

procedure TMainForm.OnNewScriptClick(Sender : TObject);
begin
  SharpApi.SharpExecute('_nohist,SharpScript.exe -newgenericscript');
end;

procedure TMainForm.ButtonMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  sr : TSearchRec;
  Dir : String;
  s : string;
  p : TPoint;
  mn : TSharpEMenu;
  ms : TSharpEMenuSettings;
  wnd : TSharpEMenuWnd;
begin
  if Button = mbLeft then
  begin
    ms := TSharpEMenuSettings.Create;
    ms.LoadFromXML;

    mn := TSharpEMenu.Create(SharpESkinManager1,ms);
    ms.Free;

    mn.AddLinkItem('Create New Script','_nohist,{#SharpEDir#}SharpScript.exe -newgenericscript','customicon:edititem',FMenuIcon1,false);
    mn.AddSeparatorItem(False);

    Dir := SharpApi.GetSharpeUserSettingsPath + 'Scripts\';
    if FindFirst(Dir + '*.sescript',FAAnyFile,sr) = 0 then
    repeat
      s := sr.Name;
      setlength(s, length(s)-length('.sescript'));
      mn.AddLinkItem(s,Dir + sr.name,'customicon:scriptitem',FMenuIcon2,False);
    until FindNext(sr) <> 0;
    FindClose(sr);
    mn.RenderBackground(0,0);

    wnd := TSharpEMenuWnd.Create(self,mn);
    wnd.FreeMenu := True; // menu will free itself when closed

    p := ClientToScreen(Point(self.Button.Left + self.Button.Width div 2, self.Height + self.Top));
    p.x := p.x + SharpESkinManager1.Skin.MenuSkin.SkinDim.XAsInt - mn.Background.Width div 2;
    if p.x < Monitor.Left then
       p.x := Monitor.Left;
    if p.x + mn.Background.Width  > Monitor.Left + Monitor.Width then
       p.x := Monitor.Left + Monitor.Width - mn.Background.Width;
    wnd.Left := p.x;
    if p.Y < Monitor.Top + Monitor.Height div 2 then
       wnd.Top := p.y + SharpESkinManager1.Skin.MenuSkin.SkinDim.YAsInt
       else wnd.Top := p.y - Top - Height - mn.Background.Height - SharpESkinManager1.Skin.MenuSkin.SkinDim.YAsInt;
    wnd.Show;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
  Background := TBitmap32.Create;
  DoubleBuffered := True;

  FIcon := TBitmap32.Create;
  FIcon.Assign(Button.Glyph32);
  FMenuIcon1 := TBitmap32.Create;
  FMenuIcon2 := TBitmap32.Create;

  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(22,22);
  TempBmp.Clear(color32(0,0,0,0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, 'edit', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FMenuIcon1.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'file', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FMenuIcon2.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  TempBmp.Free;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Background.Free;
  FIcon.Free;
  FMenuIcon1.Free;
  FMenuIcon2.Free;

  if SharpEMenuPopups <> nil then
     FreeAndNil(SharpEMenuPopups);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

end.
