{
Source Name: MainWnd.pas
Description: Show Desktop Module - Main Window
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
  Dialogs, StdCtrls, Menus, Math, VWMFunctions,
  JclSimpleXML, GR32, GR32_PNG, Messages, CommCtrl,
  ToolTipApi,
  SharpApi,
  SharpEBaseControls,
  SharpEButton,
  SharpIconUtils,
  uISharpBarModule;


type

  TWndItem = record
    wnd : THandle;
    wasIconic : boolean;
  end;

  TMainForm = class(TForm)
    btn: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
  protected
  private
    sShowCaption : boolean;
    sCaption     : String;
    sIconShow    : String;
    sIconRestore : String;
    sShowIcon    : boolean;
    sCustomIcons : boolean;
    sAllMonitors : boolean;
    FIconShow    : TBitmap32;
    FIconRestore : TBitmap32;
    FDoShow      : boolean;
    FTipWnd      : hwnd;
    procedure WMNotify(var msg: TWMNotify); message WM_NOTIFY;
  public
    mInterface : ISharpBarModule;
    procedure LoadIcons;
    procedure UpdateIcon;
    procedure LoadSettings;
    procedure ReAlignComponents;
    procedure UpdateComponentSkins;
    procedure UpdateSize;
  end;

function SwitchToThisWindow(Wnd : hwnd; fAltTab : boolean) : boolean; stdcall; external 'user32.dll';  


implementation

uses
  uSharpXMLUtils;

{$R *.dfm}

procedure TMainForm.LoadIcons;
var
  ResStream : TResourceStream;
  TempBmp : TBitmap32;
  b : boolean;
  ResID : String;
  size : integer;
begin
  if mInterface = nil then
    exit;
  if mInterface.SkinInterface = nil then
    exit;

  if sShowIcon then
  begin
    if sCustomIcons then
    begin
      size := mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y;

      if not IconStringToIcon(sIconShow,sIconShow,FIconShow,size) then
        FIconShow.SetSize(0,0);
      if not IconStringToIcon(sIconRestore,sIconRestore,FIconRestore,size) then
        FIconRestore.SetSize(0,0);
    end else
    begin
      // Restore Icon
      TempBmp := TBitmap32.Create;
      if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 16 then
      begin
        TempBmp.SetSize(16,16);
        ResID := '16';
      end else
      begin
        TempBmp.SetSize(32,32);
        ResID := '32';
      end;

      TempBmp.Clear(color32(0,0,0,0));
      try
        ResStream := TResourceStream.Create(HInstance, 'Restore' + ResID, RT_RCDATA);
        try
          LoadBitmap32FromPng(TempBmp,ResStream,b);
          FIconRestore.Assign(TempBmp);
        finally
          ResStream.Free;
        end;
      except
      end;
      TempBmp.Free;

      // Show Icon
      TempBmp := TBitmap32.Create;
      if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 16 then
      begin
        TempBmp.SetSize(16,16);
        ResID := '16';
      end else
      if mInterface.SkinInterface.SkinManager.Skin.Button.Normal.Icon.Dimension.Y <= 22 then
      begin
        TempBmp.SetSize(22,22);
        ResID := '22';
      end else
      begin
        TempBmp.SetSize(32,32);
        ResID := '32';
      end;

      TempBmp.Clear(color32(0,0,0,0));
      try
        ResStream := TResourceStream.Create(HInstance, 'Show' + ResID, RT_RCDATA);
        try
          LoadBitmap32FromPng(TempBmp,ResStream,b);
          FIconShow.Assign(TempBmp);
        finally
          ResStream.Free;
        end;
      except
      end;
      TempBmp.Free;
    end;
  end else
  begin
    FIconShow.SetSize(0,0);
    FIconRestore.SetSize(0,0);
  end;
end;

procedure TMainForm.UpdateSize;
begin
  btn.Width := Width - 4;
  if btn.Visible then
  begin
    if btn.tag = 0 then
    begin
      ToolTipApi.AddToolTip(FTipWnd,self,1,btn.BoundsRect,'Show Desktop');
      btn.tag := 1;
    end else ToolTipApi.UpdateToolTipRect(FTipWnd,self,1,btn.BoundsRect);
  end else
  begin
    ToolTipApi.DeleteToolTip(FTipWnd,self,1);
    btn.tag := 0;
  end;
end;

procedure TMainForm.WMNotify(var msg: TWMNotify);
begin
  if Msg.NMHdr.code = TTN_SHOW then
  begin
    SetWindowPos(Msg.NMHdr.hwndFrom, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    Msg.result := 1;
    exit;
  end else Msg.result := 0;
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
begin
  sShowCaption := False;
  sCaption     := 'Show Desktop';
  sIconShow    := 'icon.system.computer';
  sIconRestore := 'icon.folder';
  sShowIcon    := True;
  sCustomIcons := False;
  sAllMonitors := False;

  FDoShow := True;

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,mInterface.BarInterface.GetModuleXMLFile(mInterface.ID),True) then
    with xml.Root.Items do
    begin
      sShowCaption := BoolValue('ShowCaption',sShowCaption);
      sCaption     := Value('Caption',sCaption);
      sShowIcon    := BoolValue('ShowIcon',sShowIcon);
      sIconShow    := Value('IconShow',sIconShow);
      sIconRestore := Value('IconRestore',sIconRestore);
      sCustomIcons := BoolValue('CustomIcons',sCustomIcons);
      sAllMonitors := BoolValue('AllMonitors',sAllMonitors);
    end;
  xml.Free;

  LoadIcons;
  UpdateIcon;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  btn.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateIcon;
begin
  if FDoShow then
  begin
    btn.Glyph32.Assign(FIconShow);
    ToolTipApi.UpdateToolTipText(FTipWnd,Self,1,'Show Desktop');
  end else
  begin
    btn.Glyph32.Assign(FIconRestore);
    ToolTipApi.UpdateToolTipText(FTipWnd,Self,1,'Restore Windows');
  end;
  btn.Repaint;
end;

procedure TMainForm.ReAlignComponents;
var
  newWidth : integer;
begin
  self.Caption := sCaption;
  btn.Left := 2;
  newWidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;

  if (sShowIcon) and (btn.Glyph32 <> nil) then
    newWidth := newWidth + btn.GetIconWidth;

  if (sShowCaption) then
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
    if FDoShow then
    begin
      PostMessage(FindWindow('Shell_TrayWnd', nil), WM_MINIMIZEALLWINDOWS, Screen.MonitorFromWindow(Handle).MonitorNum, integer(sAllMonitors));
      FDoShow := False;
    end else
    begin
      PostMessage(FindWindow('Shell_TrayWnd', nil), WM_RESTOREALLWINDOWS, Screen.MonitorFromWindow(Handle).MonitorNum, integer(sAllMonitors));
      FDoShow := True;
    end;
    UpdateIcon;
  end else if Button = mbRight then
  begin
    if not FDoShow then
    begin
      FDoShow := True;
      UpdateIcon;
    end;
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  FIconShow := TBitmap32.Create;
  FIconRestore := TBitmap32.Create;

  FDoShow := True;

  FTipWnd := ToolTipApi.RegisterToolTip(self);
  ToolTipApi.EnableToolTip(FTipWnd);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FIconShow.Free;
  FIconRestore.Free;

  if FTipWnd <> 0 then
  begin
    DestroyWindow(FTipWnd);
    ToolTipApi.DisableToolTip(FTipWnd);
  end;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

end.
