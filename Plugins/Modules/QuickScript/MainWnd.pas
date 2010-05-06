{
Source Name: MainWnd.pas
Description: QuickScript Module - Main Window
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
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, GR32_PNG, Types,
  JclSimpleXML,
  SharpApi,
  SharpEBaseControls,
  SharpEButton,
  uSharpEMenu,
  uSharpEMenuWnd,
  uSharpEMenuSettings,
  uISharpBarModule,
  GR32, Menus, Math, ImgList, PngImageList;


type
  TMainForm = class(TForm)
    PngImageList1: TPngImageList;
    Button: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  protected
  private
    sCaption : Boolean;
    sIcon    : Boolean;
    FIcon    : TBitmap32;
    FMenuIcon1 : TBitmap32;
    FMenuIcon2 : TBitmap32;
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;  
    procedure OnScriptClick(Sender : TObject);
    procedure OnNewScriptClick(Sender : TObject);
  end;


implementation

{$R *.dfm}
{$R icons.res}

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  sCaption := True;
  sIcon    := True;

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
      sCaption := BoolValue('Caption',True);
      sIcon    := BoolValue('Icon',True);
    end;
  XML.Free;
end;


procedure TMainForm.UpdateComponentSkins;
begin
  Button.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSize;
begin
  Button.Width := max(1,Width - 4);
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
begin
  Button.Left := 2;
  newWidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
  if (sIcon) and (Button.Glyph32 <> nil) then
  begin
    Button.Glyph32.Assign(FIcon);
    newWidth := newWidth + Button.GetIconWidth;
  end else Button.Glyph32.SetSize(0,0);

  if (sCaption) then
  begin
    Button.Caption := 'Scripts';
    newWidth := newWidth + Button.GetTextWidth;
  end else Button.Caption := '';

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
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
  R : TRect;
begin
  if Button = mbLeft then
  begin
    ms := TSharpEMenuSettings.Create;
    ms.LoadFromXML;
    ms.MultiThreading := False;

    mn := TSharpEMenu.Create(mInterface.SkinInterface.SkinManager,ms);
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

    GetWindowRect(mInterface.BarInterface.BarWnd,R);
    p := ClientToScreen(Point(self.Button.Left + self.Button.Width div 2, self.Height + self.Top));
    p.y := R.Top;
    p.x := p.x + mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.X - mn.Background.Width div 2;
    if p.x < Monitor.Left then
      p.x := Monitor.Left;
    if p.x + mn.Background.Width  > Monitor.Left + Monitor.Width then
      p.x := Monitor.Left + Monitor.Width - mn.Background.Width;
    wnd.Left := p.x;
    if p.Y < Monitor.Top + Monitor.Height div 2 then
      wnd.Top := R.Bottom + mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.Y
    else begin
      wnd.Top := R.Top - wnd.Picture.Height - mInterface.SkinInterface.SkinManager.Skin.Menu.LocationOffset.Y;
    end;
    wnd.show;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
begin
  DoubleBuffered := True;

  FIcon := TBitmap32.Create;
  FIcon.SetSize(Button.Glyph32.Width,Button.Glyph32.Height);
  FIcon.Clear(color32(0,0,0,0));
  FIcon.Draw(0,0,Button.Glyph32);
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
  FIcon.Free;
  FMenuIcon1.Free;
  FMenuIcon2.Free;

  if SharpEMenuPopups <> nil then
     FreeAndNil(SharpEMenuPopups);
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
