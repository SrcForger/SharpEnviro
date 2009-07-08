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
  JclSimpleXML, GR32, GR32_PNG, JCLLocales,
  // SharpE Units
  SharpApi, SharpEBaseControls, SharpEScheme,
  SharpEButton, uSharpEMenu, uSharpEMenuWnd, uISharpBarModule,
  uSharpEMenuSettings, uSharpEMenuItem;

type
  TMainForm = class(TForm)
    btn: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure OnMenuItemClick(pItem : TSharpEMenuItem; pMenuWnd : TObject; var CanClose : boolean);
  protected
  private
    sShowIcon : boolean;
    sThreeLetterCode : Boolean;
    FButtonIcon : TBitmap32;
    FMenuIcon   : TBitmap32;
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : Boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure UpdateCurrentLayout;
  end;

implementation

{$R *.dfm}
{$R Icons.res}

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  sShowIcon := True;
  sThreeLetterCode := False;
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
      sShowIcon := BoolValue('ShowIcon',sShowIcon);
      sThreeLetterCode := BoolValue('ThreeLetterCode',sThreeLetterCode);
    end;
  XML.Free;
end;

procedure TMainForm.UpdateSize;
begin
  btn.Width := max(1,Width - 4);
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean = True);
var
  newWidth : integer;
begin
  self.Caption := 'Keyboard Layout' ;

  newWidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
  
  if (sShowIcon) and (btn.Glyph32 <> nil) then
    newWidth := newWidth + btn.GetIconWidth;
  newWidth := newWidth + btn.GetTextWidth;

  btn.Left := 2;

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

procedure TMainForm.OnMenuItemClick(pItem : TSharpEMenuItem; pMenuWnd : TObject; var CanClose : boolean);
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

    mn := TSharpEMenu.Create(mInterface.SkinInterface.SkinManager,ms);
    ms.Free;

    List := TJclKeyboardLayoutList.Create;
    List.Refresh;
    for n := 0 to List.Count - 1 do
    begin
      s := List[n].DisplayName;
      if sThreeLetterCode then
        s2 := List[n].LocaleInfo.AbbreviatedLangName
      else
        s2 := UpperCase(List[n].LocaleInfo.ISOAbbreviatedLangName);
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
    p.x := p.x + mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.X - mn.Background.Width div 2;
    if p.x < Monitor.Left then
       p.x := Monitor.Left;
    if p.x + mn.Background.Width  > Monitor.Left + Monitor.Width then
       p.x := Monitor.Left + Monitor.Width - mn.Background.Width;
    wnd.Left := p.x;
    if p.Y < Monitor.Top + Monitor.Height div 2 then
       wnd.Top := p.y + mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.Y
       else wnd.Top := p.y - Top - Height - mn.Background.Height - mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.Y;
    wnd.Show;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
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
  FButtonIcon.Free;
  FMenuIcon.Free;

  if SharpEMenuPopups <> nil then
     FreeAndNil(SharpEMenuPopups);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  UpdateCurrentLayout;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  btn.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateCurrentLayout;
var
  s : String;
  List : TJclKeyboardLayoutList;
begin
  List := TJclKeyboardLayoutList.Create;
  List.Refresh;
  if sThreeLetterCode then
    s := List.ActiveLayout.LocaleInfo.AbbreviatedLangName
  else
    s := UpperCase(List.ActiveLayout.LocaleInfo.ISOAbbreviatedLangName);
  List.Free;
  btn.Caption := '[' + s + ']';
  if sShowIcon then
  begin
    btn.Glyph32.Assign(FButtonIcon);
  end else
  begin
    btn.Glyph32.SetSize(0,0);
  end;
  RealignComponents(True);
end;

end.
