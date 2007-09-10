{
Source Name: MainWnd.pas
Description: MiniScmd Main Window
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
  Dialogs, StdCtrls, GR32, SharpEBaseControls, SharpEButton,
  SharpESkinManager, JvSimpleXML, SharpApi, Math, SharpEEdit, Menus;


type
  TMainForm = class(TForm)
    SharpESkinManager1: TSharpESkinManager;
    edit: TSharpEEdit;
    btn_select: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
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
    Background : TBitmap32;
    procedure WMSharpEBang(var Msg : TMessage);  message WM_SHARPEACTIONMESSAGE;
  public
    ModuleID : integer;
    BarID : integer;
    BarWnd : hWnd;
    procedure UpdateBangs;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateBackground(new : integer = -1);
  end;

var
  rightbutton : boolean;


implementation

uses uSharpBarAPI,
     SharpDialogs;

{$R *.dfm}

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
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(BarID, ModuleID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      sWidth     := IntValue('Width',100);
      sButton    := BoolValue('Button',True);
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

procedure TMainForm.SetSize(NewWidth : integer);
var
  new : integer;
begin
  new := Max(NewWidth,1);

  UpdateBackground(new);

  Width := new;

  if sButton then
  begin
    btn_select.Width := btn_select.Height;
    btn_select.Left := Width - btn_select.Width - 2;
    btn_select.show;
    edit.Width := max(1,(Width - 6) - btn_select.width);
  end else
  begin
    edit.Width := max(1,(Width - 4));
    btn_select.Hide;
  end;
end;


procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
begin
  self.Caption := '';
  if sWidth<20 then sWidth := 20;

  edit.Left := 2;

  newWidth := sWidth + 4;
  Tag := newWidth;
  Hint := inttostr(newWidth);
  if newWidth <> Width then
  begin
    if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0)
  end else SetSize(Width);
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
  SharpApi.RegisterActionEx(PChar('!FocusMiniScmd ('+inttostr(ModuleID)+')'),'Modules',self.Handle,1);
end;

function ForceForegroundWindow(hwnd: THandle): Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;

begin
  if IsIconic(hwnd) then
    ShowWindow(hwnd, SW_RESTORE);

  if GetForegroundWindow = hwnd then
    Result := True
  else begin
    // Windows 98/2000 doesn't want to foreground a window when some other
    // window has keyboard focus

    if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or
      ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and
      ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and
      (Win32MinorVersion > 0)))) then begin
      // Code from Karl E. Peterson, www.mvps.org/vb/sample.htm
      // Converted to Delphi by Ray Lischner
      // Published in The Delphi Magazine 55, page 16

      Result := False;
      ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID := GetWindowThreadPRocessId(hwnd, nil);
      if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then begin
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hwnd);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result := (GetForegroundWindow = hwnd);
      end;
      if not Result then begin
        // Code by Daniel P. Stasinski
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0),
          SPIF_SENDCHANGE);
        BringWindowToTop(hwnd); // IE 5.5 related hack
        SetForegroundWindow(hWnd);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
      end;
    end
    else begin
      BringWindowToTop(hwnd); // IE 5.5 related hack
      SetForegroundWindow(hwnd);
    end;

    Result := (GetForegroundWindow = hwnd);
  end;
end; { ForceForegroundWindow }

procedure TMainForm.WMSharpEBang(var Msg : TMessage);
begin
  ForceForegroundWindow(BarWnd);
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
    ForceForegroundWindow(BarWnd);
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
  Background := TBitmap32.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Background.Free;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  if Background <> nil then
     Background.DrawTo(Canvas.Handle,0,0);
end;

end.
