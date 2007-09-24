{
Source Name: MainWnd.pas
Description: Keyboard Layout Module - Main Window
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
  // Default Units
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, Math, Types,
  // Custom Units
  JvSimpleXML, GR32, GR32_PNG, JCLLocales,
  // SharpE Units
  SharpApi, uSharpBarAPI, SharpEBaseControls, SharpESkin, SharpEScheme,
  SharpESkinManager, SharpEButton, uSharpEMenu, uSharpEMenuWnd,
  uSharpEMenuSettings, uSharpEMenuItem;

type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    MenuSettingsItem: TMenuItem;
    SkinManager: TSharpESkinManager;
    btn: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MenuSettingsItemClick(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure OnMenuItemClick(pItem : TSharpEMenuItem; var CanClose : boolean);
  protected
  private
    sShowIcon : boolean;
    FButtonIcon : TBitmap32;
    FMenuIcon   : TBitmap32;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    Background : TBitmap32;
    procedure LoadSettings;
    procedure ReAlignComponents(BroadCast : boolean);
    procedure SetWidth(new : integer);
    procedure UpdateBackground(new : integer = -1);
    procedure UpdateCurrentLayout;
  end;

implementation

uses SettingsWnd;

{$R *.dfm}
{$R Icons.res}

procedure TMainForm.LoadSettings;
var
  XML : TJvSimpleXML;
  fileloaded : boolean;
begin
  sShowIcon := True;
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
      sShowIcon := BoolValue('ShowIcon',sShowIcon);
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

  // Update the Background Bitmap!
  UpdateBackground(new);

  // Background is updated, now resize the form
  Width := new;
  btn.Width := max(1,Width - 4);
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := 'Keyboard Layout' ;

  newWidth := btn.Width + 4;

  btn.Left := 2;

  self.Tag := NewWidth;
  self.Hint := inttostr(NewWidth);

  // Send a message to the bar that the module is requesting a width update
  if (BroadCast) and (newWidth <> Width) then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.MenuSettingsItemClick(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  XML : TJvSimpleXML;
begin
  try
    SettingsForm := TSettingsForm.Create(application.MainForm);
    SettingsForm.cb_dispicon.Checked := sShowIcon;

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowIcon := SettingsForm.cb_dispicon.Checked;

      XML := TJvSimpleXMl.Create(nil);
      XML.Root.Name := 'KeyboardLayoutModuleSettings';
      with XML.Root.Items do
      begin
        Add('ShowIcon',sShowIcon);
      end;
      XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
      XML.Free;
    end;
    UpdateCurrentLayout;

  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.OnMenuItemClick(pItem : TSharpEMenuItem; var CanClose : boolean);
var
  List : TJclKeyboardLayoutList;
  n : integer;
  k : integer;                                                             
begin
  List := TJclKeyboardLayoutList.Create;
  for n := 0 to List.Count - 1 do
    if CompareText(List.Items[n].DisplayName,pItem.PropList.GetString('DispName')) = 0 then
      begin
        k := 0;
        SystemParametersInfo(SPI_SETDEFAULTINPUTLANG, k, @List.Items[n].Layout, SPIF_SENDCHANGE or SPIF_UPDATEINIFILE);
        PostMessage(HWND_BROADCAST,WM_INPUTLANGCHANGEREQUEST,0,List.Items[n].Layout);
        break;
      end;
  List.Free;
  CanClose := True;
end;


procedure TMainForm.btnMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  mn : TSharpEMenu;
  s,s2 : string;
  ms : TSharpEMenuSettings;
  wnd : TSharpEMenuWnd;
  List : TJclKeyboardLayoutList;
  n : integer;
begin
  if Button = mbLeft then
  begin
    ms := TSharpEMenuSettings.Create;
    ms.LoadFromXML;
    ms.CacheIcons := False;

    mn := TSharpEMenu.Create(SkinManager,ms);
    ms.Free;

    List := TJclKeyboardLayoutList.Create;
    List.Refresh;
    for n := 0 to List.Count - 1 do
    begin
      s := List[n].DisplayName;
      s2 := s;
      setlength(s2,2);
      with TSharpEMenuItem(mn.AddCustomItem('[' + s2 + '] ' + s,'icon',FMenuIcon)) do
      begin
        PropList.Add('DispName',s);
        OnClick := OnMenuItemClick;
      end;
    end;
    List.Free;

    mn.RenderBackground(0,0);

    wnd := TSharpEMenuWnd.Create(self,mn);
    wnd.FreeMenu := True; // menu will free itself when closed

    p := ClientToScreen(Point(self.btn.Left + self.btn.Width div 2, self.Height + self.Top));
    p.x := p.x + SkinManager.Skin.MenuSkin.SkinDim.XAsInt - mn.Background.Width div 2;
    if p.x < Monitor.Left then
       p.x := Monitor.Left;
    if p.x + mn.Background.Width  > Monitor.Left + Monitor.Width then
       p.x := Monitor.Left + Monitor.Width - mn.Background.Width;
    wnd.Left := p.x;
    if p.Y < Monitor.Top + Monitor.Height div 2 then
       wnd.Top := p.y + SkinManager.Skin.MenuSkin.SkinDim.YAsInt
       else wnd.Top := p.y - Top - Height - mn.Background.Height - SkinManager.Skin.MenuSkin.SkinDim.YAsInt;
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

  FButtonIcon := TBitmap32.Create;
  FMenuIcon := TBitmap32.Create;


  TempBmp := TBitmap32.Create;
  TempBmp.SetSize(22,22);
  TempBmp.Clear(color32(0,0,0,0));

  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;

  try
    ResStream := TResourceStream.Create(HInstance, 'globe', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FButtonIcon.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;

  try
    ResStream := TResourceStream.Create(HInstance, 'item', RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      FMenuIcon.Assign(tempBmp);
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
  FButtonIcon.Free;
  FMenuIcon.Free;

  if SharpEMenuPopups <> nil then
     FreeAndNil(SharpEMenuPopups);  
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateCurrentLayout
end;

procedure TMainForm.UpdateCurrentLayout;
var
  s : String;
  List : TJclKeyboardLayoutList;
begin
  List := TJclKeyboardLayoutList.Create;
  List.Refresh;
  s := List.ActiveLayout.DisplayName;
  List.Free;  
  setlength(s,2);
  btn.Caption := '[' + s + ']';
  btn.Width := btn.GetTextWidth + 7;
  if sShowIcon then
  begin
    btn.Glyph32.Assign(FButtonIcon);
    btn.GlyphSpacing := 2;
    btn.Width := btn.Width + btn.Glyph32.Width + btn.GlyphSpacing + 2;
  end else
  begin
    btn.Glyph32.SetSize(0,0);
    btn.GlyphSpacing := 0;
  end;
  RealignComponents(True);
end;

end.
