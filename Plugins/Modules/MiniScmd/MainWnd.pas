{
Source Name: MainWnd.pas
Description: MiniScmd Main Window
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
  Windows, Messages, SysUtils, Classes, Controls, Forms, Types,
  Dialogs, StdCtrls, GR32, GR32_PNG, SharpEBaseControls, SharpEButton,
  JvSimpleXML, SharpApi, Math, SharpEEdit, Menus,
  uISharpBarModule;


type
  TMainForm = class(TForm)
    edit: TSharpEEdit;
    btn_select: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure editKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btn_selectMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_selectMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btn_selectClick(Sender: TObject);
    procedure editKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
  private
    sWidth   : integer;
    sButton  : boolean;
    procedure LoadIcon;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
  public
    mInterface : ISharpBarModule;
    procedure UpdateBangs;    
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
  end;

var
  rightbutton : boolean;


implementation

uses SharpDialogs,
     uSystemFuncs;

{$R *.dfm}

procedure TMainForm.LoadIcon;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
  ResID : String;
begin
  if mInterface = nil then
    exit;
  if mInterface.SkinInterface = nil then
    exit;

  TempBmp := TBitmap32.Create;
  if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 16 then
  begin
    TempBmp.SetSize(16,16);
    ResID := 'miniscmdicon';
  end else
  begin
    TempBmp.SetSize(32,32);
    ResID := 'miniscmdicon32';
  end;

  TempBmp.Clear(color32(0,0,0,0));
  try
    ResStream := TResourceStream.Create(HInstance, ResID, RT_RCDATA);
    try
      LoadBitmap32FromPng(TempBmp,ResStream,b);
      btn_select.Glyph32.Assign(tempBmp);
    finally
      ResStream.Free;
    end;
  except
  end;
  TempBmp.Free;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJvSimpleXML;
  fileloaded : boolean;
begin
  UpdateBangs;

  sWidth     := 100;
  sButton    := True;
  rightbutton := False;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sWidth  := IntValue('Width',100);
      sButton := BoolValue('Button',True);
    end;
  XML.Free;
end;

procedure TMainForm.UpdateSize;
begin
  if sButton then
  begin
    btn_select.Width := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;
    LoadIcon;
    if btn_select.Glyph32 <> nil then
      btn_select.Width := btn_select.Width + btn_select.GetIconWidth;
    btn_select.Width := btn_select.Width - 4;
    btn_select.Left := Width - btn_select.Width - 2;
    btn_select.show;
    edit.Width := max(1,(Width - 6) - btn_select.width);
  end else
  begin
    edit.Width := max(1,(Width - 4));
    btn_select.Hide;
  end;
end;


procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
begin
  self.Caption := '';
  if sWidth<20 then sWidth := 20;

  edit.Left := 2;

  newWidth := sWidth + 4;
  Tag := newWidth;
  Hint := inttostr(newWidth);

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if newWidth <> Width then
    mInterface.BarInterface.UpdateModuleSize
  else UpdateSize;
end;

procedure TMainForm.editKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    SetFocus;
    if length(trim(edit.Text)) > 0 then
    begin
       SharpApi.SharpExecute(trim(edit.Text));
       edit.Text := '';
       edit.edit.text := '';
    end;
  end;
end;

procedure TMainForm.UpdateBangs;
begin
  SharpApi.RegisterActionEx(PChar('!FocusMiniScmd ('+inttostr(mInterface.ID)+')'),'Modules',self.Handle,1);
end;

procedure TMainForm.UpdateComponentSkins;
begin
  btn_select.SkinManager := mInterface.SkinInterface.SkinManager;
  edit.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.WMSharpEBang(var Msg : TMessage);
begin
  ForceForegroundWindow(mInterface.BarInterface.BarWnd);
  case msg.LParam of
    1: edit.SetFocus;
  end;
end;

procedure TMainForm.btn_selectClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,
                                 ClientToScreen(point(btn_select.Left,btn_select.Top + btn_select.height)));
  if length(trim(s))>0 then
  begin
    ForceForegroundWindow(mInterface.BarInterface.BarWnd);
    edit.SetFocus;
    edit.Text := s;
    edit.Edit.SelectAll;
    if not rightbutton then
    begin
      SharpApi.SharpExecute(trim(edit.Text));
      edit.Text := '';
      edit.Edit.Text := '';
    end;
  end;
end;

procedure TMainForm.btn_selectMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then rightbutton := True
     else rightbutton := False;
end;

procedure TMainForm.btn_selectMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then btn_select.OnClick(btn_select);
end;

procedure TMainForm.editKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ((SSALT in Shift) and (Key = VK_F4)) then
     Key := 0;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if mInterface <> nil then  
    mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
