{
Source Name: uSharpEMenuWnd.pas
Description: SharpE Menu Window Container
Copyright (C) Martin Kr�mer <MartinKraemer@gmx.net>

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
  GR32_Backends,
  GR32_Layers,
  GR32_Image,
  GR32_PNG,
  GR32_Blend,
  uSharpEMenu,
  Menus,
  AppEvnts;

type
  TSharpEMenuWnd = class(TForm)
    SubMenuTimer: TTimer;
    offsettimer: TTimer;
    ApplicationEvents1: TApplicationEvents;
    SubMenuCloseTimer: TTimer;
    HideTimer: TTimer;
    procedure ApplicationEvents1Message(var Msg: tagMSG; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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
    procedure FormShow(Sender: TObject);
    procedure SubMenuCloseTimerTimer(Sender: TObject);
    procedure HideTimerOnTimer(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
    procedure FormMouseEnter(Sender: TObject);
    procedure CreateParams(var Params: TCreateParams); override;
  private
    FMenu : TSharpEMenu;
    FParentMenu : TSharpeMenuWnd;
    FOffset : integer;
    FOwner : TObject;
    FSubMenu : TSharpEMenuWnd;
    FPicture : TBitmap32;
    FIsClosing : boolean;
    FIgnoreNextDeactivate : boolean;
    FIgnoreNextKillFocus : boolean;
    FRootMenu : boolean;
    FFreeMenuSub : boolean;
    FFreeMenu : boolean; // Set to True if the menu is a single menu without popups
                         // and if you want it to free itself OnDeactivate
    FIsVisible : boolean;
    FMenuID : string;
    FMouseLeave : boolean;

    DC: HDC;
    Blend: TBlendFunction;
    procedure UpdateWndLayer;
  protected
    procedure WMActivate(var Msg : TMessage); message WM_ACTIVATE;
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMKillFocus(var Msg: TMessage); message WM_KILLFOCUS;
    procedure WMNCHitTest(var Message: TWMNCHitTest);
    procedure WMSharpTerminate(var Msg : TMessage); message WM_SHARPTERMINATE;

    procedure WMMenuID(var Msg : TMessage); message WM_MENUID;
  public
    MuteXHandle : THandle;

    procedure DrawWindow;
    procedure PreMul(Bitmap: TBitmap32);
    procedure InitMenu(pMenu : TSharpEMenu; pRootMenu : boolean);
    procedure CloseAll;
    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent; pMenu : TSharpEMenu); reintroduce; overload;

    procedure SetMenuID(path : string);
    function GetHideTimeout: integer;
    procedure SetHideTimeout(n : integer);
    procedure EnableHideTimeout;
    procedure DisableHideTimeout;
  published
    property SharpEMenu : TSharpEMenu read FMenu;
    property SharpESubMenu : TSharpEMenuWnd read FSubMenu write FSubMenu;
    property ParentMenu : TsharpEMenuWnd read FParentMenu write FParentMenu;
    property Picture : TBitmap32 read FPicture;
    property cOwner : TObject read FOwner;
    property RootMenu : boolean read FRootMenu;
    property FreeMenu : boolean read FFreeMenu write FFreeMenu;
    property IgnoreNextDeactivate : boolean read FIgnoreNextDeactivate write FIgnoreNextDeactivate;
    property IgnoreNextKillFocus : boolean read FIgnoreNextKillFocus write FIgnoreNextKillFocus;
    property MenuID : string read FMenuID write SetMenuID;
    property HideTimeout : integer read GetHideTimeout write SetHideTimeout;
  end;

const
  SUBMENUTIMER_INTERVAL = 250;

implementation

{$R *.dfm}

uses uSharpEMenuItem;


// has to be applied to the TBitmap32 before passing it to the API function
procedure TSharpEMenuWnd.PreMul(Bitmap: TBitmap32);
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

  if FMenu.ParentMenuItem <> nil then
  begin
    TSharpEMenu(FMenu.ParentMenuItem.OwnerMenu).CheckAndAbortDynamicContentThread;
    if not FMenu.ParentMenuItem.isDynamicSubMenuInitialized then
      FMenu.RefreshDynamicContent;
  end else FMenu.RefreshDynamicContent;

  FMenu.RenderTo(FPicture,FOffset);
  PreMul(FPicture);

  Width  := FPicture.Width;
  Height := FPicture.Height;
  left   := Screen.WorkAreaWidth div 2 - self.Width div 2;
  top    := Screen.WorkAreaHeight div 2 - self.Height div 2;

  FMouseLeave := False;
  HideTimer.Enabled := False;
  if not pRootMenu then
    FMenu.InitializeDynamicSubMenus;  
end;

constructor TSharpEMenuWnd.Create(AOwner: TComponent);
begin
  Create(AOwner,nil);
  FParentMenu := nil;
  FIsVisible := False;  
end;


constructor TSharpEMenuWnd.Create(AOwner: TComponent; pMenu : TSharpEMenu);
begin
  inherited Create(AOwner);
  FIsClosing := False;
  FOwner := AOwner;
  FPicture := TBitmap32.Create;
  FParentMenu := nil;
  FIgnoreNextDeactivate := False;
  FIgnoreNextKillFocus := False;
  FFreeMenuSub := False;
  FIsVisible := False;  

  InitMenu(pMenu,False);
end;

procedure TSharpEMenuWnd.WMSharpTerminate(var Msg : TMessage);
begin
  FFreeMenuSub := False;
  FFreeMenuSub := False;
  Application.ProcessMessages;
  CloseAll;

  CloseHandle(MuteXHandle);
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

procedure TSharpEMenuWnd.WMMenuID(var Msg : TMessage);
begin
  Msg.Result := GlobalAddAtom(PAnsiChar(FMenuID));
end;

procedure TSharpEMenuWnd.SetMenuID(path : string);
begin
  FMenuID := ExtractFileName(path);
  SetLength(FMenuID, Length(FMenuID) - Length(ExtractFileExt(FMenuID)));
end;

function TSharpEMenuWnd.GetHideTimeout;
begin
  Result := HideTimer.Interval;
end;

procedure TSharpEMenuWnd.SetHideTimeout(n : integer);
begin
  HideTimer.Interval := n;
end;

procedure TSharpEMenuWnd.EnableHideTimeout;
begin
  FMouseLeave := True;
  HideTimer.Enabled := False;
end;

procedure TSharpEMenuWnd.DisableHideTimeout;
begin
  FMouseLeave := False;
  HideTimer.Enabled := False;
end;

procedure TSharpEMenuWnd.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
  Bmp : TBitmap32;
begin
  if (Height <> FPicture.Height) then
  begin
    if (FPicture.Height - FOffset < Height) then
       FOffset := Max(0,FPicture.Height - Monitor.Height);
    if (FPicture.Height <= Height) then
       Height := FPicture.Height
  end;

  if (Width <> FPicture.Width) then
  begin
    if ParentMenu <> nil then
    begin
      if ParentMenu.Left > Left then
         Left := ParentMenu.Left  - FPicture.Width;
    end;
    Width := FPicture.Width;
  end;

  BmpSize.cx := Width;
  BmpSize.cy := Height;
 // BmpTopLeft := Point(0, FOffset);
  BmpTopLEft := Point(0,0);
  TopLeft := BoundsRect.TopLeft;

  Bmp := TBitmap32.Create;
  Bmp.SetSize(Width,Height);
  FPicture.DrawTo(Bmp,0,-FOffset);

  DC := GetDC(Handle);
  try
    {$WARNINGS OFF}
    if not Win32Check(LongBool(DC)) then
      RaiseLastWin32Error;

    if not Win32Check(UpdateLayeredWindow(Handle, DC, @TopLeft, @BmpSize,
      Bmp.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA)) then
      RaiseLastWin32Error;
    {$WARNINGS ON}
    FIsVisible := True;
  finally
    ReleaseDC(Handle, DC);
    Bmp.Free;
  end;
end;

procedure TSharpEMenuWnd.DrawWindow;
begin
  UpdateWndLayer;
end;

procedure TSharpEMenuWnd.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do
  begin
    Params.WinClassName := 'TSharpEMenuWnd';
    ExStyle := WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW;
    Style := WS_POPUP or WS_CLIPSIBLINGS or WS_CLIPCHILDREN;
  end;
end;

procedure TSharpEMenuWnd.FormCreate(Sender: TObject);
begin
  SubMenuTimer.Interval := SUBMENUTIMER_INTERVAL;
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

  ShowWindow(Application.Handle, SW_HIDE);
end;

procedure TSharpEMenuWnd.FormActivate(Sender: TObject);
begin
  if FIsVisible then
  begin
    IgnoreNextKillFocus := False;
    exit;
  end;
    
  ShowWindow(Application.Handle, SW_HIDE);
  DrawWindow;
end;

procedure TSharpEMenuWnd.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  submenu : boolean;
  item : TSharpEMenuItem;
  CPos : TPoint;
begin
  if FIsClosing then exit;
  if FMenu = nil then exit;

  submenu := false;
  if FParentMenu <> nil then
  begin
    FParentMenu.SubMenuCloseTimer.Enabled := False;
    FParentMenu.SubMenuTimer.Enabled := False;
    FParentMenu.SharpEMenu.SelectItemByMenu(FMenu);
    FParentMenu.SharpEMenu.RenderTo(FParentMenu.Picture, FParentMenu.FOffset);
    PreMul(FParentMenu.Picture);
    FParentMenu.DrawWindow;
  end;
  if FSubMenu <> nil then
  begin
    item := FMenu.CurrentItem;
    if item <> nil then
    begin
      if item.SubMenu <> FSubMenu.SharpEMenu then
      begin
        SubMenuCloseTimer.Enabled := True;
      end else SubMenuCloseTimer.Enabled := False;
    end;
  end;
  if FMenu.PerformMouseMove(x,y+FOffset,submenu) then
  begin
    SubMenuTimer.Enabled := False;
    if submenu then
    begin
      if FSubMenu = nil then // no sub menu, open instantly
        SubMenuTimer.Interval := 25;
      SubMenuTimer.Enabled := True;
    end;
    FMenu.RenderTo(FPicture,FOffset);
    PreMul(FPicture);
    DrawWindow;
  end;

  CPos := Mouse.CursorPos;
  if (Y < 10) or (Y > Monitor.Height - 10 - Top) or (CPos.y < Monitor.Top + 10) then
     offsettimer.Enabled := True;
end;

procedure TSharpEMenuWnd.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if FIsClosing then exit;
  if FMenu = nil then exit;

  if FMenu.PerformMouseDown(self,Button, X,Y) then
  begin
    FMenu.RenderTo(FPicture,FOffset);
    PreMul(FPicture);
    DrawWindow;
  end;
end;

procedure TSharpEMenuWnd.FormMouseEnter(Sender: TObject);
begin
  if FMouseLeave and (HideTimer.Interval > 0) and (HideTimer.Enabled) then
    HideTimer.Enabled := False;

  if FSubMenu <> nil then
  begin
    if not FMouseLeave and FSubMenu.FMouseLeave then
    begin
      FSubMenu.DisableHideTimeout;
      EnableHideTimeout;
    end;
  end;
  if FParentMenu <> nil then
  begin
    if FParentMenu.FMouseLeave and not FMouseLeave then
    begin
      FParentMenu.DisableHideTimeout;
      HideTimer.Interval := FParentMenu.HideTimeout;
      EnableHideTimeout;
    end;
  end else if not FMouseLeave then
    EnableHideTimeout;
end;

procedure TSharpEMenuWnd.FormMouseLeave(Sender: TObject);
begin
  if FMouseLeave and (HideTimer.Interval > 0) then
    HideTimer.Enabled := True;
end;

procedure TSharpEMenuWnd.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  p : TPoint;
begin
  if FIsClosing then exit;
  if FMenu = nil then exit;

  DisableHideTimeout;

  p := ClientToScreen(point(X,Y));
  if FMenu.PerformMouseUp(self,Button, Shift, p.X,p.Y) then
  begin
    EnableHideTimeout;

    FMenu.RenderTo(FPicture,FOffset);
    PreMul(FPicture);
    DrawWindow;
  end;
end;

procedure TSharpEMenuWnd.CloseAll;
var
  pOwner : TObject;
  lm : TSharpEMenuWnd;
begin
  FIsClosing := True;
  // Find the Top Most menu and close everything!
  pOwner := FOwner;
  if FOwner is TSharpEMenuWnd then lm := TSharpEMenuWnd(FOwner)
     else lm := self;
  while (pOwner is TSharpEMenuWnd) and (pOwner <> nil) do
  begin
    if TSharpEMenuWnd(pOwner).cOwner is TSharpEMenuWnd then
       lm := TSharpEMenuWnd(TSharpEMenuWnd(pOwner).cOwner);
    pOwner := TSharpEMenuWnd(pOwner).cOwner;
  end;
  TSharpEMenuWnd(lm).Release;
end;

procedure TSharpEMenuWnd.HideTimerOnTimer(Sender: TObject);
begin
  FFreeMenuSub := False;
  FFreeMenuSub := False;
  Application.ProcessMessages;
  CloseAll;

  CloseHandle(MuteXHandle);
end;

procedure TSharpEMenuWnd.FormClick(Sender: TObject);
begin
  if FMenu = nil then
    exit;

  if FMenu.PerformClick(self) then
     CloseAll
  else SubMenuTimerTimer(nil);
end;

procedure TSharpEMenuWnd.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  
  if FMenu = nil then
    exit;

  FMenu.RenderTo(FPicture,Left,Top);
  PreMul(FPicture);
end;

procedure TSharpEMenuWnd.FormDestroy(Sender: TObject);
begin
  OffsetTimer.Enabled := False;
  SubMenuTimer.Enabled := False;

  if FMenu <> nil then
  begin
    FMenu.CheckAndAbortDynamicContentThread;
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
  if (FFreeMenu or (Tag = - 1)) and (SharpEMenuPopups <> nil) then
     FreeAndNil(SharpEMenuPopups);
  if FRootMenu or FreeMenu then
     SharpApi.UnRegisterShellHookReceiver(Handle);
  if FRootMenu then Application.Terminate;
end;

procedure TSharpEMenuWnd.SubMenuCloseTimerTimer(Sender: TObject);
begin
  SubMenuCloseTimer.Enabled := False;
  if FSubMenu <> nil then
  begin
    FSubMenu.FIgnoreNextDeactivate := True;
    FSubMenu.SharpEMenu.RecycleBitmaps;
    FSubMenu.Visible := False;
    FSubMenu.Release;
    FSubMenu := nil;
  end;
end;

procedure TSharpEMenuWnd.SubMenuTimerTimer(Sender: TObject);
var
  item : TSharpEMenuItem;
  t : integer;
begin
  if FIsClosing then exit;
  if FMenu = nil then exit;

  SubMenuTimer.Interval := SUBMENUTIMER_INTERVAL;
  SubMenuTimer.Enabled := False;
  item := FMenu.CurrentItem;
  if item <> nil then
  begin
    if FSubMenu <> nil then
    begin
      if (item.SubMenu = FSubMenu.SharpEMenu) then
        exit;
      FSubMenu.FIgnoreNextDeactivate := True;
      FSubMenu.SharpEMenu.RecycleBitmaps;
      FSubMenu.Visible := False;
      FSubMenu.Release;
      FSubMenu := nil;
    end;
    if item.SubMenu <> nil then
    begin
      SubMenuCloseTimer.Enabled := False;
      FSubMenu := TSharpEMenuWnd.Create(self,TSharpEMenu(item.submenu));
      FSubMenu.ParentMenu := self;
      t := Left + Width + FMenu.SkinManager.Skin.Menu.LocationOffset.X;
      if (t + FSubMenu.Width > Monitor.Left + Monitor.Width) then
         t := Left - FSubMenu.Width - FMenu.SkinManager.Skin.Menu.LocationOffset.Y;
      if (t < Monitor.Left) then t := 0;
      FSubMenu.Left := t;

      t := Top;
      if FMenu.ItemIndex <> 0 then
         t := t + FMenu.GetItemsHeight(Max(0,FMenu.Itemindex-1)) - FOffset;
      if (t + FSubMenu.Picture.Height) > (Monitor.Top + Monitor.Height) then
         t := Monitor.Top + Monitor.Height - FSubMenu.Picture.Height;

      if item.isWrapMenu then
         t := Top;

      if t < Monitor.Top then
      begin
        if FSubMenu.Picture.Height > Monitor.Height then
           FSubMenu.Height := Monitor.Height;
        t := 0;
      end;
      FSubMenu.top := t;
      FIgnoreNextDeactivate := True;
      FSubMenu.FFreeMenuSub := FFreeMenu;
      FSubMenu.Show;
     end;
  end;
end;

procedure TSharpEMenuWnd.offsettimerTimer(Sender: TObject);
var
  CPos : TPoint;
begin
  if FIsClosing then exit;
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
    if (CPos.Y >= Monitor.Top + Top) and (CPos.Y <= Monitor.Top + 5 + Top) and (FOffset >= 0) then
    begin
      FOffset := FOffset -15;
      if FOffset < 0 then FOffset := 0;
      
      if FMenu.ItemIndex <> -1 then
        FMenu.ItemIndex := -1;

      FMenu.RenderTo(FPicture,FOffset);
      PreMul(FPicture);
      DrawWindow;

      DrawWindow;
    end
    else
    if (CPos.Y >= Monitor.Top + Monitor.Height - 5)
        and (CPos.Y <= Monitor.Top + Monitor.Height)
        and (FOffset <= FPicture.Height - Monitor.Height + top) then
    begin
      FOffset := FOffset +15;
      if FOffset > FPicture.Height - Monitor.Height + top then
         FOffset := FPicture.Height - Monitor.Height + top;

      if FMenu.ItemIndex <> -1 then
        FMenu.ItemIndex := -1;

      FMenu.RenderTo(FPicture,FOffset);
      PreMul(FPicture);
      DrawWindow;

      DrawWindow;
    end else offsettimer.Enabled := False;
  end else offsettimer.Enabled := False;
end;

procedure TSharpEMenuWnd.FormDeactivate(Sender: TObject);
begin
  OffsetTimer.Enabled := False;
  SubMenuTimer.Enabled := False;

  if (not FIsVisible) then
    exit;  

  if FIgnoreNextDeactivate then
  begin
    FIgnoreNextDeactivate := False;
    exit;
  end;

  if (FFreeMenu) or (FFreeMenuSub) then
  begin
    FFreeMenu := False;
    FFreeMenuSub := False;
    if FParentMenu <> nil then
      FParentMenu.Release
    else
    begin
      Tag := -1;
      if FMenu <> nil then
         FreeAndNil(FMenu);
      Release;
    end;
  end;
end;


function GetWndClass(pHandle: hwnd): string;
var
  buf: array[0..254] of Char;
begin
  GetClassName(pHandle, buf, SizeOf(buf));
  result := buf;
end;

procedure TSharpEMenuWnd.WMActivate(var Msg: TMessage);
begin
  Msg.Result := 0;
  if (not FFreeMenu) and (not FFreeMenuSub) then
    exit;
  if (not FIsVisible) then
  begin
    FIgnoreNextKillFocus := True;
    ShowWindow(Application.Handle, SW_HIDE);    
    DrawWindow;
    exit;
  end;

  if msg.WParam = WA_INACTIVE then
  begin
{    s := '';
    if IsWindow(msg.LParam) then
      s := GetWndClass(msg.LParam);
  //  if (CompareText(s,'TSharpEMenuWnd') = 0) then// or (CompareText(s,'TSharpBarMainForm') = 0) then
    //  exit;
    if not (CompareText(s,'TSharpBarMainForm') = 0) then
      exit; }
    if not FFreeMenu then
      exit;
      
    FFreeMenu := False;
    Tag := -1;
    if FMenu <> nil then
       FreeAndNil(FMenu);
    Release;
  end;
end;

procedure TSharpEMenuWnd.WMKillFocus(var Msg: TMessage);
var
  wclass : String;
begin
  if (not FIsVisible) then
    exit;

  if FIgnoreNextKillFocus then
  begin
    FIgnoreNextKillFocus := False;
    Exit;
  end;
  
  if (FFreeMenu) then
  begin
    if Msg.WParam <> 0 then
    begin
      wclass := GetWndClass(Msg.Wparam);
      if CompareText(wclass,'TSharpEMenuWnd') = 0 then
        exit;
    end;

    FFreeMenu := False;
    Tag := -1;
    if FMenu <> nil then
       FreeAndNil(FMenu);
    Release;
  end;
end;

procedure TSharpEMenuWnd.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  n : integer;
begin
  if FMenu = nil then exit;

  if (Key = VK_RETURN) then
     FormClick(self)
  else
  if (Key = VK_ESCAPE) then
     CloseAll
  else
  if (Key = VK_UP) or (Key = VK_DOWN) or (Key = VK_HOME) or (Key = VK_END) then
  begin
    case Key of
      VK_UP : FMenu.ItemIndex := FMenu.PreviousVisibleIndex;
      VK_DOWN : FMenu.ItemIndex := FMenu.NextVisibleIndex;
      VK_HOME : begin
                  FOffset := 0;
                  FMenu.ItemIndex := -1;
                  FMenu.ItemIndex := FMenu.NextVisibleIndex;
                end;
      VK_END : begin
                 FMenu.ItemIndex := FMenu.Items.Count - 1;
                 FMenu.ItemIndex := FMenu.PreviousVisibleIndex;
                 FMenu.ItemIndex := FMenu.NextVisibleIndex;
               end;
    end;
    n := FMenu.GetItemsHeight(FMenu.ItemIndex);
    if n > Height + FOffset then
       FOffset := n - Height + FMenu.Background.Height - FMenu.NormalMenu.Height;
    if n < FOffset then
       FOffset := FOffset - FMenu.ItemsHeight[FMenu.ItemIndex];
    FMenu.RenderTo(FPicture,FOffset);
    PreMul(FPicture);
    DrawWindow;
  end else
  if (Key = VK_RIGHT) then
  begin
    SubMenuTimerTimer(SubMenuTimer);
    if FSubMenu <> nil then
    begin
      FSubMenu.SharpEMenu.ItemIndex := FSubMenu.SharpEMenu.NextVisibleIndex;
      FSubMenu.SharpEMenu.RenderTo(FSubMenu.Picture,FSubMenu.FOffset);
      FSubMenu.PreMul(FSubMenu.Picture);
      FSubMenu.DrawWindow;
    end;
  end else
  if (Key = VK_LEFT) then
  begin
    if FParentMenu <> nil then
    begin
      FParentMenu.SharpESubMenu := nil;
      FMenu.RecycleBitmaps;
      Release;
      FParentMenu.SetFocus;      
    end;
  end;
end;

procedure TSharpEMenuWnd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FIsClosing := True;
  if FMenu = nil then exit;
  FMenu.CheckAndAbortDynamicContentThread;
//  if not FMenu.isWrapMenu then
//     FMenu.UnWrapMenu(FMenu);  // Doesn't make sense, doesn't work, necessary at all?
end;

procedure TSharpEMenuWnd.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  o : integer;
begin
  if FParentMenu = nil then exit;
  if FMenu = nil then exit;
  if (FPicture.Height <= Height) and (FParentMenu.Picture.Height <= FParentMenu.Height) then exit;

  if ((Mouse.CursorPos.x < Left) or (Mouse.CursorPos.x > Left + Width))
     and (FParentMenu.Picture.Height > FParentMenu.Height) then
  begin
    FParentMenu.SharpESubMenu := nil;
    FParentMenu.FormMouseWheelDown(FParentMenu,Shift,MousePos,Handled);
    FMenu.RecycleBitmaps;
    Release;
    exit;
  end;

  o := FOffset;
  FOffset := FOffset + 50;
  if FOffset > FPicture.Height - Monitor.Height then
     FOffset := FPicture.Height - Monitor.Height;
  if o <> FOffset then
     DrawWindow;
end;

procedure TSharpEMenuWnd.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
  var
  o : integer;
begin
  if FParentMenu = nil then exit;
  if FMenu = nil then exit;
  if (FPicture.Height <= Height) and (FParentMenu.Picture.Height <= FParentMenu.Height) then exit;

  if ((Mouse.CursorPos.x < Left) or (Mouse.CursorPos.x > Left + Width))
     and (FParentMenu.Picture.Height > FParentMenu.Height) then
  begin
    FParentMenu.SharpESubMenu := nil;
    FParentMenu.FormMouseWheelUp(FParentMenu,Shift,MousePos,Handled);
    FMenu.RecycleBitmaps;
    Release;
    exit;
  end;

  o := FOffset;
  FOffset := FOffset - 50;
  if FOffset < 0 then
     FOffset := 0;
  if o <> FOffset then
     DrawWindow;
end;

procedure TSharpEMenuWnd.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  buf: array [0..254] of Char;
  cname : String;
begin
  Handled := False;
  if FIsClosing then exit;
  if msg.message = WM_SHARPSHELLMESSAGE then
  begin
    Handled := True;
    if (msg.lParam = Integer(Handle)) or (msg.lparam = Integer(Application.Handle)) then
      exit;
    if (not FIsVisible) then
      exit;

    GetClassName(GetForegroundWindow(), buf, SizeOf(buf));
    cname := buf;
    if CompareText(cname,'TSharpEMenuWnd') = 0 then exit;
//    if not IsWindow (msg.lParam) then exit;

    case msg.WParam of
      HSHELL_WINDOWACTIVATED : Close;
      HSHELL_WINDOWACTIVATED + 32768 : close;
    end;
  end;
end;

end.



