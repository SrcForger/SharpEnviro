{
Source Name: uSharpEMenuWnd.pas
Description: SharpE Menu Window Container
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.net

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

unit uSharpEMenuWnd;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Math,
  Dialogs,
  StdCtrls,
  SharpApi,
  ExtCtrls,
  Types,
  GR32,
  GR32_Layers,
  GR32_Image,
  GR32_PNG,
  GR32_Blend,
  uSharpEMenu;

type
  TSharpEMenuWnd = class(TForm)
    SubMenuTimer: TTimer;
    offsettimer: TTimer;
    procedure FormDeactivate(Sender: TObject);
    procedure offsettimerTimer(Sender: TObject);
    procedure SubMenuTimerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FMenu : TSharpEMenu;
    FOffset : integer;
    FOwner : TObject;
    FSubMenu : TSharpEMenuWnd;
    FPicture : TBitmap32;
    FRootMenu : boolean;
    FFreeMenu : boolean; // Set to True if the menu is a single menu without popups
                         // and if you want it to free itself OnDeactivate
    DC: HDC;
    Blend: TBlendFunction;
    procedure UpdateWndLayer;
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMKillFocus(var Msg: TMessage); message WM_KILLFOCUS;
    procedure WMNCHitTest(var Message: TWMNCHitTest);
  public
    procedure DrawWindow;
    procedure InitMenu(pMenu : TSharpEMenu; pRootMenu : boolean);
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; pMenu : TSharpEMenu); reintroduce; overload;
    property SharpEMenu : TSharpEMenu read FMenu;
    property Picture : TBitmap32 read FPicture;
    property cOwner : TObject read FOwner;
    property RootMenu : boolean read FRootMenu;
    property FreeMenu : boolean read FFreeMenu write FFreeMenu;
  end;


implementation

{$R *.dfm}

uses uSharpEMenuItem;



// has to be applied to the TBitmap32 before passing it to the API function
procedure PreMul(Bitmap: TBitmap32);
const w = Round($10000 * (1/255));
var
  p: PColor32;
  c: TColor32;
  i,a: integer;
  r,g,b : byte;
begin
  p:= Bitmap.PixelPtr[0,0];
  for i:= 0 to Bitmap.Width * Bitmap.Height - 1 do begin
    c:= p^;
    a:= (c shr 24) * w ;
    r:= c shr 16 and $FF; r:= r * a shr 16;
    g:= c shr 8 and $FF; g:= g * a shr 16;
    b:= c and $FF; b:= b * a shr 16;
    p^:= (c and $FF000000) or r shl 16 or g shl 8 or b;
    inc(p);
  end;
end;

procedure TSharpEMenuWnd.InitMenu(pMenu : TSharpEMenu; pRootMenu : boolean);
begin
  if pMenu = nil then exit;
  FRootMenu := pRootMenu;
  FMenu := pMenu;

  FMenu.RefreshDynamicContent;
  FMenu.RenderBackground;

  FMenu.RenderTo(FPicture);
  PreMul(FPicture);

  Width  := FPicture.Width;
  Height := FPicture.Height;
  left   := Screen.WorkAreaWidth div 2 - self.Width div 2;
  top    := Screen.WorkAreaHeight div 2 - self.Height div 2;
end;

constructor TSharpEMenuWnd.Create(AOwner: TComponent);
begin
  Create(AOwner,nil);
end;


constructor TSharpEMenuWnd.Create(AOwner: TComponent; pMenu : TSharpEMenu);
begin
  inherited Create(AOwner);
  FOwner := AOwner;
  FPicture := TBitmap32.Create;

  InitMenu(pMenu,False);
end;

procedure TSharpEMenuWnd.WMPaint(var Msg: TWMPaint);
begin
  inherited;
  Application.ProcessMessages;
end;

procedure TSharpEMenuWnd.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if PtInRect(ClientRect, ScreenToClient(Point(Message.XPos, Message.YPos))) then
    Message.Result := HTClient;
end;

procedure TSharpEMenuWnd.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
begin
  BmpSize.cx := Width;
  BmpSize.cy := Height;
  BmpTopLeft := Point(0, FOffset);
  TopLeft := BoundsRect.TopLeft;

  DC := GetDC(Handle);
  try
    {$WARNINGS OFF}
    if not Win32Check(LongBool(DC)) then
      RaiseLastWin32Error;

     if not Win32Check(UpdateLayeredWindow(Handle, DC, @TopLeft, @BmpSize,
      FPicture.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA)) then
      RaiseLastWin32Error;
    {$WARNINGS ON}
  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure TSharpEMenuWnd.DrawWindow;
begin
  UpdateWndLayer;
end;

procedure TSharpEMenuWnd.FormCreate(Sender: TObject);
begin
  ShowWindow( Application.Handle, SW_HIDE );
  SetWindowLong( Application.Handle, GWL_EXSTYLE,
                 GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
  ShowWindow( Application.Handle, SW_SHOW );

  FOffset := 0;
  FRootMenu := False;
  FFreeMenu := False;
  if FPicture = nil then FPicture := TBitmap32.Create;

  DC := 0;

  with Blend do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := 255;
    AlphaFormat := AC_SRC_ALPHA;
  end;

  if SetWindowLong(Handle, GWL_EXSTYLE,
       GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_TOOLWINDOW
                                          or WS_EX_TOPMOST) = 0 then
  begin
    ShowMessage('Operation System is not supporting LayeredWindows!');
    Application.Terminate;
  end;
end;

procedure TSharpEMenuWnd.FormActivate(Sender: TObject);
begin
  DrawWindow;
end;

procedure TSharpEMenuWnd.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  submenu : boolean;
begin
  if FMenu = nil then exit;

  submenu := false;
  if FMenu.PerformMouseMove(x,y+FOffset,submenu) then
  begin
    if FSubMenu <> nil then
    begin
      FSubMenu.SharpEMenu.RecycleBitmaps;
      FSubMenu.Release;
      FSubMenu := nil;
    end;
    SubMenuTimer.Enabled := False;
    if submenu then
       SubMenuTimer.Enabled := True;
    FMenu.RenderTo(FPicture);
    PreMul(FPicture);
    DrawWindow;
  end;

  if (Y < 10) or (Y > Monitor.Height - 10) then
     offsettimer.Enabled := True;
end;

procedure TSharpEMenuWnd.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMenu = nil then exit;

  if FMenu.PerformMouseDown then
  begin
    FMenu.RenderTo(FPicture);
    PreMul(FPicture);
    DrawWindow;
  end;
end;

procedure TSharpEMenuWnd.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FMenu = nil then exit;

  if FMenu.PerformMouseUp then
  begin
    FMenu.RenderTo(FPicture);
    PreMul(FPicture);
    DrawWindow;
  end;
end;

procedure TSharpEMenuWnd.FormClick(Sender: TObject);
var
  pOwner : TObject;
  lm : TSharpEMenuWnd;
begin
  if FMenu = nil then exit;

  if FMenu.PerformClick then
  begin
    // Find the Top Most menu and close everything!
    pOwner := FOwner;
    if FOwner is TSharpEMenuWnd then lm := TSharpEMenuWnd(FOwner)
       else lm := self;
    while pOwner is TSharpEMenuWnd do
    begin
      if TSharpEMenuWnd(pOwner).cOwner is TSharpEMenuWnd then
         lm := TSharpEMenuWnd(TSharpEMenuWnd(pOwner).cOwner);
      pOwner := TSharpEMenuWnd(pOwner).cOwner;
    end;
    TSharpEMenuWnd(lm).Release;
  end;
end;

procedure TSharpEMenuWnd.FormDestroy(Sender: TObject);
begin
  OffsetTimer.Enabled := False;
  SubMenuTimer.Enabled := False;

  if FMenu <> nil then
  begin
    FMenu.ItemIndex := -1;
    FMenu.RecycleBitmaps;
    if FSubMenu <> nil then
    begin
      FSubMenu.Release;
      FSubMenu := nil;
    end;
    if FFreeMenu then
       FreeAndNil(FMenu);
  end;
  FPicture.Free;
  if FRootMenu then Application.Terminate;
end;

procedure TSharpEMenuWnd.SubMenuTimerTimer(Sender: TObject);
var
  item : TSharpEMenuItem;
  t : integer;
begin
  if FMenu = nil then exit;

  SubMenuTimer.Enabled := False;
  item := FMenu.CurrentItem;
  if item <> nil then
  begin
    if FSubMenu <> nil then
    begin
      FSubMenu.SharpEMenu.RecycleBitmaps;
      FSubMenu.Release;
      FSubMenu := nil;
    end;
    if item.SubMenu <> nil then
    begin
      FSubMenu := TSharpEMenuWnd.Create(self,TSharpEMenu(item.submenu));
      t := Left + Width;
      if (t + FSubMenu.Width > Monitor.Left + Monitor.Width) then
         t := Left - FSubMenu.Width;
      if (t < Monitor.Left) then t := 0;
      FSubMenu.Left := t;

      t := Top;
      if FMenu.ItemIndex <> 0 then
         t := t + FMenu.GetItemsHeight(Max(0,FMenu.Itemindex-1)) - FOffset;
      if (t + FSubMenu.Picture.Height) > (Monitor.Top + Monitor.Height) then
         t := Monitor.Top + Monitor.Height - FSubMenu.Picture.Height;
      if t < Monitor.Top then
      begin
        if FSubMenu.Picture.Height > Monitor.Height then
           FSubMenu.Height := Monitor.Height;
        t := 0;
      end;
      FSubMenu.top := t;
      FSubMenu.show;
     end;
  end;
end;

procedure TSharpEMenuWnd.offsettimerTimer(Sender: TObject);
var
  CPos : TPoint;
begin
  if FMenu = nil then exit;

  // Reset sub menu timer!
  if SubMenuTimer.Enabled then
  begin
    SubMenuTimer.Enabled := False;
    SubMenuTimer.Enabled := True;
  end;

  CPos := Mouse.CursorPos;
  if (CPos.X > Left) and (CPos.X < Left + Width) then
  begin
    if (CPos.Y >= Monitor.Top) and (CPos.Y <= Monitor.Top + 5) and (FOffset >= 0) then
    begin
      if FMenu.ItemIndex <> -1 then
      begin
        FMenu.ItemIndex := -1;
        FMenu.RenderTo(FPicture);
        PreMul(FPicture);
        DrawWindow;
      end;

      FOffset := FOffset -15;
      if FOffset < 0 then FOffset := 0;
      DrawWindow;
    end
    else
    if (CPos.Y >= Monitor.Top + Monitor.Height - 5)
        and (CPos.Y <= Monitor.Top + Monitor.Height)
        and (FOffset <= FPicture.Height - Monitor.Height) then
    begin
      if FMenu.ItemIndex <> -1 then
      begin
        FMenu.ItemIndex := -1;
        FMenu.RenderTo(FPicture);
        PreMul(FPicture);
        DrawWindow;
      end;

      FOffset := FOffset +15;
      if FOffset > FPicture.Height - Monitor.Height then
         FOffset := FPicture.Height - Monitor.Height;
      DrawWindow;
    end else offsettimer.Enabled := False;
  end else offsettimer.Enabled := False;
end;

procedure TSharpEMenuWnd.FormDeactivate(Sender: TObject);
begin
  OffsetTimer.Enabled := False;
  SubMenuTimer.Enabled := False;

  if (FFreeMenu) then
  begin
    FFreeMenu := False;
    if FMenu <> nil then
       FreeAndNil(FMenu);
    Release;
  end;
end;

procedure TSharpEMenuWnd.WMKillFocus(var Msg: TMessage);
begin
  if (FFreeMenu) then
  begin
    FFreeMenu := False;
    if FMenu <> nil then
       FreeAndNil(FMenu);
    Release;
  end;
end;

end.


