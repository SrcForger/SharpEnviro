{
Source Name: uSharpEMenuWnd.pas
Description: SharpE Menu Window Container
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

unit uSharpEMenuWnd;

interface

uses
  Windows,
  Messages,
  ShellApi,
  SysUtils,
  StrUtils,
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
  AppEvnts, JvComponentBase,
  DragDrop, DropSource, DragDropFile;

type
  TSharpEMenuWnd = class(TForm)
    SubMenuTimer: TTimer;
    offsettimer: TTimer;
    ApplicationEvents1: TApplicationEvents;
    SubMenuCloseTimer: TTimer;
    HideTimer: TTimer;
    ScrollMenuTimer: TTimer;
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
    procedure ScrollMenuTimerTimer(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    FMenu : TSharpEMenu;
    FParentMenu : TSharpeMenuWnd;
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
    FOldMousePos : TPoint;
                                      
    DC: HDC;
    Blend: TBlendFunction;
    FMenuScroll : integer;
    FDropFileSource: TDropFileSource;

    procedure UpdateWndLayer;
    procedure ScrollMenu(num: integer; noParent: boolean = false);
    procedure ScrollMenuOffset(num: integer; noParent: boolean = false);
    procedure ScrollMenuKey(key: char; noParent: boolean);

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
    if not FMenu.ParentMenuItem.isDynamicSubMenuInitialized then
      FMenu.RefreshDynamicContent;
  end else FMenu.RefreshDynamicContent;

  FMenu.RenderTo(FPicture);
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
  FMenuScroll := 0;

  FDropFileSource := TDropFileSource.Create(Self);

  InitMenu(pMenu,False);
end;

procedure TSharpEMenuWnd.WMSharpTerminate(var Msg : TMessage);
begin
  FMenuID := '-1';
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
  FPicture.DrawTo(Bmp);

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

  if (FOldMousePos.X = X) and (FOldMousePos.Y = Y) then
    exit;

  FOldMousePos := Point(X, Y);

  submenu := false;
  if FParentMenu <> nil then
  begin
    FParentMenu.SubMenuCloseTimer.Enabled := False;
    FParentMenu.SubMenuTimer.Enabled := False;
    FParentMenu.SharpEMenu.SelectItemByMenu(FMenu);
    FParentMenu.SharpEMenu.RenderTo(FParentMenu.Picture);
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
  if FMenu.PerformMouseMove(x,y,submenu) then
  begin
    SubMenuTimer.Enabled := False;
    if submenu then
    begin
      if FSubMenu = nil then // no sub menu, open instantly
        SubMenuTimer.Interval := 25;
      SubMenuTimer.Enabled := True;
    end;
    FMenu.RenderTo(FPicture);
    PreMul(FPicture);
    DrawWindow;
  end;

  CPos := Mouse.CursorPos;
  if ((CPos.Y < Top + 5) or (CPos.Y >= Top + Height - 5)) then
     offsettimer.Enabled := True;
end;

procedure TSharpEMenuWnd.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  dragPath : string;
begin
  if FIsClosing then exit;
  if FMenu = nil then exit;

  if (DragDetectPlus(TWinControl(Sender))) then
  begin
    // Delete anything from a previous drag.
    FDropFileSource.Files.Clear;

    dragPath := '';
    if not ((FMenu.CurrentItem.isDynamic) and (FMenu.CurrentItem.ItemType = mtSubMenu)) then
    begin
      dragPath := FMenu.CurrentItem.PropList.GetString('Action');
    end;

    if (dragPath <> '') then
    begin
      FDropFileSource.Files.Add(dragPath);
      // Start the drag operation.
      FDropFileSource.Execute;

      Close;
      exit;
    end;
  end;

  if FMenu.PerformMouseDown(self,Button, X,Y) then
  begin
    FMenu.RenderTo(FPicture);
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

    FMenu.RenderTo(FPicture);
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
  else
    SubMenuTimerTimer(nil);
end;

procedure TSharpEMenuWnd.FormShow(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_HIDE);
  
  if FMenu = nil then
    exit;

  FMenu.Position := Point(Left, Top);

  FMenu.RenderTo(FPicture,Left,Top);
  PreMul(FPicture);
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

  if (FFreeMenu or (Tag = - 1)) and (SharpEMenuPopups <> nil) then
     FreeAndNil(SharpEMenuPopups);
  if FRootMenu or FreeMenu then
     SharpApi.UnRegisterShellHookReceiver(Handle);

  FreeAndNil(FDropFileSource);

  if FRootMenu then
    Application.Terminate;
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
  t, m : integer;
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
      FSubMenu.SharpEMenu.Offset := 0;
      FSubMenu.SharpEMenu.ItemIndex := 0;
      
      FSubMenu.ParentMenu := self;
      t := Left + Width + FMenu.SkinManager.Skin.Menu.LocationOffset.X;
      if (t + FSubMenu.Width > Monitor.WorkareaRect.Right) then
         t := Left - FSubMenu.Width - FMenu.SkinManager.Skin.Menu.LocationOffset.Y;
      if (t < Monitor.WorkareaRect.Left) then
        t := Monitor.WorkareaRect.Left;
      FSubMenu.Left := t;

      m := FSubMenu.SharpEMenu.Background.Height;
      
      t := Top - FMenu.Offset;
      if FMenu.ItemIndex <> 0 then
         t := t + FMenu.GetItemsHeight(0, FMenu.ItemIndex - 1, false);
      if (t + m) > (Monitor.WorkareaRect.Bottom) then
         t := Monitor.WorkareaRect.Bottom - m;

      if t < Monitor.WorkareaRect.Top then
      begin
        if FSubMenu.Picture.Height > (Monitor.WorkareaRect.Bottom - Monitor.WorkareaRect.Top) then
           FSubMenu.Height := (Monitor.WorkareaRect.Bottom - Monitor.WorkareaRect.Top);
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
  WRc : TRect;
begin
  if FIsClosing then exit;
  if FMenu = nil then exit;

  // Reset sub menu timer!
  if SubMenuTimer.Enabled then
  begin
    SubMenuTimer.Enabled := False;
    SubMenuTimer.Enabled := True;
  end;

  WRc := Rect(Left, Top, Width, Height);

  CPos := Mouse.CursorPos;

  if (CPos.X >= WRc.Left) and (CPos.X < WRc.Left + WRc.Right) then
  begin
    if (CPos.Y >= WRc.Top) and
      (CPos.Y < WRc.Top + 5) then
    begin
      if FMenu.ItemIndex <> -1 then
        FMenu.ItemIndex := -1;

      ScrollMenuOffset(-FMenu.Settings.ScrollSpeed, true);
    end else if (CPos.Y >= WRc.Top + WRc.Bottom - 5) and
                (CPos.Y < WRc.Top + WRc.Bottom) then
    begin
      if FMenu.ItemIndex <> -1 then
        FMenu.ItemIndex := -1;

      ScrollMenuOffset(FMenu.Settings.ScrollSpeed, true);
    end else
      offsettimer.Enabled := False;
  end else
    offsettimer.Enabled := False;
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
    FMenuID := '-1';
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

    FMenuID := '-1';    
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
    FMenuID := '-1';
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
      VK_UP : ScrollMenuOffset(FMenu.Settings.ScrollSpeed, true);
      VK_DOWN : ScrollMenuOffset(-FMenu.Settings.ScrollSpeed, true);
      VK_HOME : begin
        FMenu.ItemIndex := -1;
        FMenu.ItemIndex := FMenu.NextVisibleIndex;
        ScrollMenu(0);
      end;
      VK_END : begin
        FMenu.ItemIndex := FMenu.Items.Count - 1;
        FMenu.ItemIndex := FMenu.PreviousVisibleIndex;
        FMenu.ItemIndex := FMenu.NextVisibleIndex;
        ScrollMenu(-1);
      end;
    end;
  end else
  if (Key = VK_RIGHT) then
  begin
    SubMenuTimerTimer(SubMenuTimer);
    if FSubMenu <> nil then
    begin
      FSubMenu.SharpEMenu.ItemIndex := FSubMenu.SharpEMenu.NextVisibleIndex;
      FSubMenu.SharpEMenu.RenderTo(FSubMenu.Picture);
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

procedure TSharpEMenuWnd.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['a'..'z'] + ['A'..'Z'] + ['0'..'9'] then
    ScrollMenuKey(Char(Key), false);
end;

procedure TSharpEMenuWnd.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FMenuID := '-1';
  FIsClosing := True;
  if FMenu = nil then exit;
//  if not FMenu.isWrapMenu then
//     FMenu.UnWrapMenu(FMenu);  // Doesn't make sense, doesn't work, necessary at all?
end;

procedure TSharpEMenuWnd.ScrollMenu(num: integer; noParent: boolean);
var
  startOffset, startOffsetMax : integer;
begin
  if FMenu = nil then
    exit;

  if (not noParent) and ((Mouse.CursorPos.x >= Left) and (Mouse.CursorPos.x < Left + Width)) then
      noParent := true;

  if not noParent then
    Visible := False;

  startOffset := 0;
  if num >= 0 then
    startOffset := num;

  if (FParentMenu <> nil) and (not noParent) then
    startOffsetMax := FParentMenu.SharpEMenu.GetMaxHeight
  else
    startOffsetMax := FMenu.GetMaxHeight;

  if num < 0 then
    startOffset := startOffsetMax;

  if startOffset > startOffsetMax then
    startOffset := startOffsetMax;
  if startOffset < 0 then
    startOffset := 0;

  if (FParentMenu <> nil) and (not noParent) then
  begin
    if (startOffset = FParentMenu.SharpEMenu.Offset) then
      exit;

    FParentMenu.SharpEMenu.Offset := startOffset;

    FParentMenu.SharpEMenu.RenderTo(FParentMenu.Picture);
    PreMul(FParentMenu.FPicture);
    FParentMenu.DrawWindow;
  end else
  begin
    if (startOffset = FMenu.Offset) then
      exit;

    FMenu.Offset := startOffset;

    FMenu.RenderTo(FPicture);
    PreMul(FPicture);
    DrawWindow;
  end;
end;

procedure TSharpEMenuWnd.ScrollMenuOffset(num: integer; noParent: boolean);
var
  scroll : integer;
begin
  if (not noParent) and ((Mouse.CursorPos.x >= Left) and (Mouse.CursorPos.x < Left + Width)) then
      noParent := true;

  if (FParentMenu <> nil) and (not noParent) then
    scroll := FParentMenu.SharpEMenu.Offset + num
  else
    scroll := FMenu.Offset + num;
    
  if scroll < 0 then
    scroll := 0;

  ScrollMenu(scroll, noParent);
end;

procedure TSharpEMenuWnd.ScrollMenuKey(key: char; noParent: boolean);
var
  n : integer;
  num, numMax : integer;
  cap : string;
begin
  if (not noParent) and ((Mouse.CursorPos.x >= Left) and (Mouse.CursorPos.x < Left + Width)) then
      noParent := true;

  if noParent then
    numMax := FMenu.Items.Count - 1
  else
    numMax := FParentMenu.SharpEMenu.Items.Count - 1;
      
  num := -1;
  for n := 0 to numMax do
  begin
    if noParent then
      cap := AnsiUpperCase(TSharpEMenuItem(FMenu.Items.Items[n]).Caption)
    else
      cap := AnsiUpperCase(TSharpEMenuItem(FParentMenu.SharpEMenu.Items.Items[n]).Caption);
      
    if Length(cap) <= 0 then
      continue;

    if (cap[1] = AnsiUpperCase(key)[1]) then
      break;

    if noParent then
      num := num + FMenu.ItemsHeight[n]
    else
      num := num + FParentMenu.SharpEMenu.ItemsHeight[n];
  end;

  if num >= 0 then
    ScrollMenu(num, noParent);
end;

procedure TSharpEMenuWnd.ScrollMenuTimerTimer(Sender: TObject);
begin
  ScrollMenuOffset(FMenuScroll);
  FMenuScroll := 0;
  ScrollMenuTimer.Enabled := False;
end;

procedure TSharpEMenuWnd.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ScrollMenuTimer.Enabled := False;
  FMenuScroll := FMenuScroll + FMenu.Settings.ScrollSpeed;
  ScrollMenuTimer.Enabled := True;
end;

procedure TSharpEMenuWnd.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  ScrollMenuTimer.Enabled := False;
  FMenuScroll := FMenuScroll - FMenu.Settings.ScrollSpeed;
  ScrollMenuTimer.Enabled := True;
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



