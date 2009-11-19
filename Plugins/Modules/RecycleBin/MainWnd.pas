{
Source Name: MainWnd
Description: Recycle Bin module main window
Copyright (C) Mathias Tillman <mathias@sharpenviro.com>

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
  Windows, Messages, SysUtils, Classes, Forms, Dialogs, CommCtrl,
  SharpIconUtils, GR32, uISharpBarModule, ISharpESkinComponents, JclShell,
  SharpApi, Menus, SharpEButton, ExtCtrls, SharpEBaseControls,
  ToolTipApi, Controls;


type

  TSHQUERYRBINFO = packed record
     cbSize : DWord;
     i64Size : Int64;
     i64NumItems : Int64;
  end;

  TMainForm = class(TForm)
    btnRecycle: TSharpEButton;
    mnuRecycle: TPopupMenu;
    Open1: TMenuItem;
    EmptyRecyclebin1: TMenuItem;
    recycleTimer: TTimer;
    Properties1: TMenuItem;
    Separator1: TMenuItem;

    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure recycleTimerOnTimer(Sender: TObject);
    procedure btnRecycleOnClick(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnRecycleOnDblClick(Sender: TObject);
    procedure btnRecycleOpen(Sender: TObject);
    procedure btnRecycleEmpty(Sender: TObject);
    procedure btnRecycleProperties(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    
  private
    FTipWnd : HWND;

    procedure WMNotify(var msg : TWMNotify); message WM_NOTIFY;
    
  public
    SHEmptyRecycleBin : function (hWnd: HWND; pszRootPath: PChar; dwFlags: DWORD): HResult; stdcall;
    SHQueryRecycleBin : function (pszRootPath: PChar; var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;

    IsEmpty : Boolean;

    mInterface : ISharpBarModule;
    function GetRecycleBinStatus: integer;
    procedure UpdateStatus;

    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure UpdateSize;
    procedure LoadIcons;
  end;


implementation

{$R *.dfm}

procedure TMainForm.WMNotify(var msg: TWMNotify);
begin
  if Msg.NMHdr.code = TTN_SHOW then
  begin
    SetWindowPos(Msg.NMHdr.hwndFrom, HWND_TOPMOST, 0, 0, 0, 0,SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE);
    Msg.result := 1;
    exit;
  end else Msg.result := 0;
end;

procedure TMainForm.LoadIcons;
var
  TempBmp : TBitmap32;
  Icon : string;
begin
  TempBmp := TBitmap32.Create;
  TempBmp.Clear(color32(0,0,0,0));

  Icon := 'icon.recyclebin.full';
  if IsEmpty then
    Icon := 'icon.recyclebin.empty';

  IconStringToIcon(Icon, '', TempBmp);
  TempBmp.SetSize(32, 32);

  btnRecycle.Glyph32.Assign(tempBmp);
  btnRecycle.UpdateSkin;

  TempBmp.Free;
end;

procedure TMainForm.LoadSettings;
begin
  if recycleTimer.Enabled then
    recycleTimer.OnTimer(recycleTimer);  
end;

procedure TMainForm.UpdateComponentSkins;
begin
  btnRecycle.SkinManager := mInterface.SkinInterface.SkinManager;
end;

procedure TMainForm.UpdateSize;
begin
  btnRecycle.Width := Width - 4;
  Repaint;
end;

procedure TMainForm.ReAlignComponents(Broadcast : boolean = True);
var
  newWidth : integer;
begin
  self.Caption := 'Recyclebin';

  btnRecycle.Left := 2;

  newWidth := mInterface.SkinInterface.SkinManager.Skin.Button.WidthMod;

  if (btnRecycle.Glyph32 <> nil) then
    newWidth := newWidth + btnRecycle.GetIconWidth;  

  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;

  if (newWidth <> Width) and (Broadcast) then
    mInterface.BarInterface.UpdateModuleSize
  else
    UpdateSize;
end;

procedure TMainForm.recycleTimerOnTimer(Sender: TObject);
begin
  UpdateStatus;
end;

procedure TMainForm.UpdateStatus;
var
  n : integer;
begin
  n := GetRecycleBinStatus;

  if n = 1 then
    ToolTipApi.UpdateToolTipText(FTipWnd, Self, 1, IntToStr(n) + ' item')
  else
    ToolTipApi.UpdateToolTipText(FTipWnd, Self, 1, IntToStr(n) + ' items');
end;

function TMainForm.GetRecycleBinStatus: integer;
var
  rbinfo : TSHQUERYRBINFO;
begin
  Result := 0;

  if @SHQueryRecycleBin = nil then
    exit;
    
  rbinfo.cbSize := sizeof(TSHQUERYRBINFO);
  rbinfo.i64Size := 0;
  rbinfo.i64NumItems := 0;
  if SHQueryRecycleBin(nil, rbinfo) = S_OK then
  begin
    Result := rbinfo.i64NumItems;

    if IsEmpty <> (rbinfo.i64NumItems <= 0) then
    begin
      IsEmpty := (rbinfo.i64NumItems <= 0);

      LoadIcons;
    end;
  end;
end;

procedure TMainForm.btnRecycleOnClick(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
  m : TMenuItem;
begin
  if Button = mbRight then
  begin
    // Get the cordinates on the screen where the popup should appear.
    p := ClientToScreen(Point(0, Self.Height));
    if p.Y > Monitor.Top + Monitor.Height div 2 then
      p.Y := p.Y - Self.Height;

    // Disable Empty Recycle Bin if it's empty
    m := mnuRecycle.Items[1];
    m.Enabled := not IsEmpty;

    // Show the menu
    mnuRecycle.Popup(p.X, p.Y);
  end;
end;

procedure TMainForm.btnRecycleOnDblClick(Sender: TObject);
begin
  SharpExecute('shell:RecycleBinFolder');
end;

procedure TMainForm.btnRecycleOpen(Sender: TObject);
begin
  SharpExecute('shell:RecycleBinFolder');
end;

procedure TMainForm.btnRecycleEmpty(Sender: TObject);
begin
  if @SHEmptyRecycleBin = nil then
    exit;
    
  SHEmptyRecycleBin(Application.Handle, nil, 0);
  UpdateStatus;
end;

procedure TMainForm.btnRecycleProperties(Sender: TObject);
begin
  DisplayPropDialog(Application.Handle, 'shell:RecycleBinFolder');
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  DllHandle : THandle;
begin
  DoubleBuffered := True;
  IsEmpty := False;

  DllHandle := LoadLibrary('shell32.dll');
  try
    if Dllhandle <> 0 then
    begin
      @SHEmptyRecycleBin := GetProcAddress(DllHandle, 'SHEmptyRecycleBinA');
      @SHQueryRecycleBin := GetProcAddress(DllHandle, 'SHQueryRecycleBinA');
    end;
  finally
    FreeLibrary(DllHandle);
  end;

  // Enable tool-tip
  FTipWnd := ToolTipApi.RegisterToolTip(self);
  ToolTipApi.EnableToolTip(FTipWnd);
  ToolTipApi.AddToolTip(FTipWnd,Self,1,
                        Rect(btnRecycle.Left, btnRecycle.Top,
                        btnRecycle.Left + btnRecycle.Width,
                        btnRecycle.Top + btnRecycle.Height),
                        '');

  UpdateStatus;
  LoadIcons;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  ToolTipApi.DeleteToolTip(FTipWnd,Self,1);
  if FTipWnd <> 0 then
     DestroyWindow(FTipWnd); 
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  Bmp : TBitmap32;
begin
  Bmp := TBitmap32.Create;
  Bmp.Assign(mInterface.Background);

  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

end.
