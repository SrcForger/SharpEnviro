{
Source Name: SharpEBar.pas
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpEBar;

interface

uses
  Windows,
  Types,
  Messages,
  SysUtils,
  Classes,
  Controls,
  Forms,
  Graphics,
  Dialogs,
  StdCtrls,
  GR32,
  GR32_Backends,
  Math,
  MonitorList,
  SharpeDefault,
  ISharpESkinComponents,
  SharpGraphicsUtils,
  SharpEBase,
  SharpEBaseControls,
  SharpApi;

type
  TSharpEThrobber = class;
  TSharpEBarBackground = class;

  TSharpEBarHorizPos = (hpLeft, hpMiddle, hpRight, hpFull);
  TSharpEBarVertPos = (vpTop, vpBottom);
  TThrobberMouseEvent = procedure(Sender: TObject; X, Y: Integer) of object;
  TBackgroundPaintEvent = procedure(Sender: TObject; Target: TBitmap32; x : integer) of object;
  TBarPositionEvent = procedure(Sender : TObject; var X, Y : Integer) of object;

  TSharpEBar = class(TCustomSharpEComponent)
  private
    form: TForm;
    hproc: TFarproc;
    fproc: TFarproc;
    evtTrack: tagTRACKMOUSEEVENT;
    FirstUpdate: boolean;
    FOrigWidth: integer;

    FOnBackgroundPaint: TBackgroundPaintEvent;

    FSkinSeed: integer;
    FSkin: TBitmap32;
    FBuffer: TBitmap32;
    FThrobber: TSharpEThrobber;
    FonMouseDown: TMouseEvent;
    FonMouseUp: TMouseEvent;
    FonMouseMove: TMouseMoveEvent;
    FOldOnPaint: TNotifyEvent;
    FOnResetSize: TNotifyEvent;
    FOnPositionUpdate: TBarPositionEvent;
    FBackGround: TSharpEBarBackground;
    FAutoPosition: boolean;
    FHorizPos: TSharpEBarHorizPos;
    FVertPos: TSharpEBarVertPos;
    FFixedWidth: integer;
    FFixedWidthEnabled: boolean;
    FPrimaryMon: boolean;
    FMonitorIndex: integer;
    FAutoStart: boolean;
    FAlwaysOnTop : boolean;
    FForceAlwaysOnTop : boolean;
    FShowThrobber: Boolean;
    FDisableHideThrobber: Boolean;
    FDisableHideBar     : Boolean;
    FStartHidden : Boolean;
    FAutoHide : Boolean;
    FAutoHideTime : integer;

    procedure PC_NoAlpha(F: TColor32; var B: TColor32; M: TColor32);
    procedure FormPaint(Sender: TObject);
    procedure SetBitmapSizes(NewWidth : integer = - 1);
    procedure SetAutoPosition(Value: boolean);
    procedure SetHorizPos(Value: TSharpEBarHorizPos);
    procedure SetVertPos(Value: TSharpEBarVertPos);
    procedure SetPrimaryMonitor(Value: boolean);
    procedure SetMonitorIndex(Value: integer);
    procedure SetAutoStart(Value: boolean);
    procedure SetShowThrobber(Value: boolean);
    procedure SetAlwaysOnTop(Value: boolean);
    procedure SetForceAlwaysOnTop(Value: boolean);
    procedure SetFixedWidth(Value : integer);
    procedure SetFixedWidthEnabled(Value : boolean);
    function GetSpecialHideForm : boolean;
  protected
    procedure DrawDefaultSkin(Scheme: ISharpEScheme); virtual;
    procedure DrawManagedSkin(Scheme: ISharpEScheme; NewWidth : integer = -1; NewLeft : integer = -1); virtual;
    procedure WndProc(var msg: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateRuntime(AOwner: TComponent; SkinManager : ISharpESkinManager);
    destructor Destroy; override;
    procedure UpdateSkin(NewWidth : integer = -1); reintroduce;
    procedure UpdatePosition(NewWidth : integer = -1);
    procedure UpdateAlwaysOnTop;
    property aform: TForm read form;
    property abackground: TSharpEBarBackground read FBackGround;
    property Throbber: TSharpEThrobber read FThrobber write FThrobber;
    property Skin: TBitmap32 read FSkin;
    property Seed: integer read FSkinSeed write FSkinSeed;
  published
    property SkinManager;
    property AutoPosition: Boolean read FAutoPosition write SetAutoPosition;
    property HorizPos: TSharpEBarHorizPos read FHorizPos write SetHorizPos;
    property VertPos: TSharpEBarVertPos read FVertPos write SetVertPos;
    property PrimaryMonitor: Boolean read FPrimaryMon write SetPrimaryMonitor;
    property MonitorIndex: integer read FMonitorIndex write SetMonitorIndex;
    property AutoStart: Boolean read FAutoStart write SetAutoStart;
    property AlwaysOnTop: Boolean read FAlwaysOnTop write SetAlwaysOnTop;
    property ForceAlwaysOnTop: Boolean read FForceAlwaysOnTop write SetForceAlwaysOnTop;
    property FixedWidthEnabled: Boolean read FFixedWidthEnabled write SetFixedWidthEnabled;
    property FixedWidth: integer read FFixedWidth write SetFixedWidth;
    property AutoHide: boolean read FAutoHide write FAutoHide;
    property AutoHideTime: integer read FAutoHideTime write FAutoHideTime;

    property ShowThrobber: Boolean read FShowThrobber write SetShowThrobber;
    property DisableHideBar: Boolean read FDisableHideBar write FDisableHideBar;
    property StartHidden: Boolean read FStartHidden write FStartHidden;
    property SpecialHideForm : Boolean read GetSpecialHideForm;
    property onThrobberMouseDown: TMouseEvent read FonMouseDown write FonMouseDown;
    property onThrobberMouseUp: TMouseEvent read FonMouseUp write FonMouseUp;
    property onThrobberMouseMove: TMouseMoveEvent read FonMouseMove write FonMouseMove;
    property onResetSize: TNotifyEvent read FonResetsize write FonResetSize;
    property onPositionUpdate: TBarPositionEvent read FOnPositionUpdate write FOnPositionUpdate;
    property OnBackgroundPaint: TBackgroundPaintEvent read FOnBackgroundPaint write FOnBackgroundPaint;
  end;

  TSharpEBarBackground = class
  private
    fproc: TFarProc;
    FBmp: TBitmap32;
    owner: TComponent;
    Blend: TBlendFunction;
    WindowHandle: hWnd;
    FAlpha  : byte;
  protected
    procedure UpdateSkin(skinbmp: TBitmap32);
    procedure UpdateWndLayer;
    procedure SetAlpha(Value : Byte);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure WndProc(var msg: TMessage);
    procedure UpdateSize;
    procedure SetZOrder;
    property handle: hwnd read WindowHandle;
    property Alpha : byte read FAlpha write SetAlpha;
    property Skin : TBitmap32 read FBmp;
  end;

  TSharpEThrobber = class(TCustomSharpEGraphicControl)
  private
    FPar: TSharpEBar;
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme); override;
  published
    property Skin : TBitmap32 read FSkin;
  end;

procedure PreMul(var Bitmap: TBitmap32);
function IntToHorizPos(i: integer): TSharpEBarHorizPos;
function IntToVertPos(i: integer): TSharpEBarVertPos;
function HorizPosToInt(hpos: TSharpEBarHorizPos): integer;
function VertPosToInt(vpos: TSharpEBarVertPos): integer;

implementation

function IntToHorizPos(i: integer): TSharpEBarHorizPos;
begin
  case i of
    0: result := hpLeft;
    1: result := hpMiddle;
    2: result := hpRight;
    3: result := hpFull;
  else
    result := hpLeft;
  end;
end;

function IntToVertPos(i: integer): TSharpEBarVertPos;
begin
  case i of
    0: result := vpTop;
    1: result := vpBottom;
  else
    result := vpTop;
  end;
end;

function HorizPosToInt(hpos: TSharpEBarHorizPos): integer;
begin
  case hpos of
    hpLeft: result := 0;
    hpMiddle: result := 1;
    hpRight: result := 2;
    hpFull: result := 3;
  else
    result := 1;
  end;
end;

function VertPosToInt(vpos: TSharpEBarVertPos): integer;
begin
  case vpos of
    vpTop: result := 0;
    vpBottom: result := 1;
  else
    result := 0;
  end;
end;

function PlainWinProc(hWnd: THandle; nMsg: UINT;
  wParam, lParam: Cardinal): Cardinal; export; stdcall;
begin
  Result := DefWindowProc(hWnd, nMsg, wParam, lParam);
end;

procedure TSharpEBarBackground.WndProc(var msg: TMessage);
var
  wpos : PWindowPos;
begin
  inherited;

  if msg.Msg = WM_WINDOWPOSCHANGING then
  begin
    wpos := PWINDOWPOS(msg.LParam);
    if ((wpos.flags and SWP_NOZORDER) = 0) and (wpos.x <> -1) and (wpos.y <> -2)
      and (wpos.cx <> -3) and (wpos.cy <> -4) then
      wpos.flags := wpos.flags or SWP_NOZORDER;
    // I know the -1, -2, -3, -4 stuff is Evil, just necessary to tell if a Z-Order
    // Change is send by bar or any third party app/event! Get over it :P
    msg.result := DefWindowProc(windowHandle, msg.Msg, msg.wParam, msg.lParam);
  end else
  if (msg.Msg = WM_ACTIVATE) or (msg.Msg = WM_ACTIVATEAPP) then
  begin
   // if msg.WParam <> 0 then
    begin
      msg.result := 0;
      SetZOrder;
    end// else msg.Result := DefWindowProc(windowHandle, msg.Msg, msg.wParam, msg.lParam);
  end else msg.Result := DefWindowProc(windowHandle, msg.Msg, msg.wParam, msg.lParam);
end;

constructor TSharpEBarBackground.Create(AOwner: TComponent);
var WindowClass: TWndClassEx;
begin
  owner := AOwner;
  FBmp := TBitmap32.create;
  FAlpha := 255;
  with Blend do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := $FF;
    AlphaFormat := AC_SRC_ALPHA;
  end;

  try
    fproc := Classes.MakeObjectInstance(WndProc);
   // initialize the window class structure
    WindowClass.cbSize := sizeOf(TWndClassEx);
    WindowClass.lpszClassName := 'SharpEBarBackGround';
    WindowClass.style := cs_VRedraw or cs_HRedraw or cs_DBLCLKS;
    WindowClass.hInstance := HInstance;
    WindowClass.lpfnWndProc := @PlainWinProc;
    WindowClass.cbClsExtra := 0;
    WindowClass.cbWndExtra := 0;
    WindowClass.hIcon := LoadIcon(hInstance,
      MakeIntResource('MAINICON'));
    WindowClass.hIconSm := LoadIcon(hInstance,
      MakeIntResource('MAINICON'));
    WindowClass.hCursor := LoadCursor(0, idc_Arrow); ;
    WindowClass.hbrBackground := GetStockObject(white_Brush);
    WindowClass.lpszMenuName := nil;
    // register the class
    if RegisterClassEx(WindowClass) = 0 then
      MessageBox(0, 'Invalid class registration', 'IconWindow', MB_OK)
    else
    begin
      WindowHandle := CreateWindowEx(WS_EX_LAYERED or WS_EX_TRANSPARENT or
        WS_EX_TOOLWINDOW or WS_EX_NOACTIVATE,
        WindowClass.lpszClassName, // class name
        'SharpEBarBackGroundWindow', // title
        WS_POPUP, // styles
        (Owner as TSharpEBar).aform.left, (Owner as TSharpEBar).aform.Top,
          // position
        (Owner as TSharpEBar).aform.width, (Owner as TSharpEBar).aform.Height,
          // size
        0, // parent window
        0, // menu
        HInstance, // instance handle
        nil); // initial parameters
      if WindowHandle = 0 then
        MessageBox(0, 'Window not created', 'SharpEBarBackGround', MB_OK)
      else
      begin
        //ShowWindow(WindowHandle, sw_shownormal);
      //   hproc := TFarProc(GetWindowLong(form.handle,GWL_WNDPROC));
      //  fproc := Classes.MakeObjectInstance(WndProc);
        SetWindowlong(Windowhandle, GWL_WNDPROC, longword(fproc));

      end;
    end;
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpBar','Error when creating SharpEBarBackGroundWindow',clred,DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpBar',E.Message,clred,DMT_ERROR);
    end;
  end;
end;

destructor TSharpEBarBackground.Destroy;
begin
  try
    DestroyWindow(WindowHandle);
    Windows.UnregisterClass(PChar('SharpEBarBackGround'),hInstance);
  except
    on E: Exception do
    begin
      SharpApi.SendDebugMessageEx('SharpBar','Error on destroying SharpEBarBackGroundWindow',0,DMT_ERROR);
      SharpApi.SendDebugMessageEx('SharpBar',E.Message,clred,DMT_ERROR);
    end;
  end;
  FBmp.free;
  inherited;
end;

procedure TSharpEBarBackground.SetAlpha(Value : byte);
begin
  if Value <> FAlpha then
  begin
    FAlpha := Value;
    UpdateWndLayer;
  end;
end;

procedure TSharpEBarBackground.UpdateSkin(skinbmp: TBitmap32);
begin
  FBmp.Assign(skinbmp);
  PreMul(FBmp);
  UpdateSize;
  UpdateWndLayer;
end;

procedure TSharpEBarBackground.UpdateSize;
begin
  if Owner <> nil then
    SetWindowPos(WindowHandle, 0, (Owner as TSharpEBar).aform.left,
      (Owner as TSharpEBar).aform.top, FBmp.width, FBmp.height,
      SWP_NOZORDER or SWP_NOACTIVATE);
end;

procedure TSharpEBarBackground.SetZOrder;
begin
  if Owner <> nil then
    SetWindowPos(WindowHandle, (Owner as TSharpEBar).aform.handle,
      -1, -2, -3, -4,
      SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE);
end;

procedure TSharpEBarBackground.UpdateWndLayer;
var
  BmpTopLeft: TPoint;
  BmpSize: TSize;
  dc: hdc;
begin
  if (FBmp.Width <=0) or (FBmp.Height <=0) then exit;
  BmpSize.cx := FBmp.Width;
  BmpSize.cy := FBmp.Height;
  BmpTopLeft := Point(0, 0);
  DC := GetDC(WindowHandle);
  Blend.SourceConstantAlpha := FAlpha;
  try
    if not LongBool(DC) then
      RaiseLastOSError;
    if not UpdateLayeredWindow(WindowHandle, DC, nil, @BmpSize,
      FBmp.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA) then
      RaiseLastOSError;
  finally
    ReleaseDC(WindowHandle, DC);
  end;
end;

constructor TSharpEBar.CreateRuntime(AOwner: TComponent; SkinManager : ISharpESkinManager);
begin
  FManager := SkinManager;
  Create(AOwner);
end;

constructor TSharpEBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSkin := TBitmap32.Create;
  FBuffer := TBitmap32.Create;
// FSkin.DrawMode := dmCustom;
  FSkin.DrawMode := dmBlend;
  FSkin.CombineMode := cmMerge;
  FSkinSeed := -1;

  FFixedWidth := 50; // percent of screen width
  FFixedWidthEnabled := False;
  FAutoPosition := False;
  FHorizPos := hpMiddle;
  FVertPos := vpTop;
  FPrimaryMon := True;
  FAutoStart := True;
  FMonitorIndex := 0;
  FShowThrobber := True;
  FDisableHideThrobber := False;
  FDisableHideBar  := False;

  if not (csDesigning in ComponentState) then
  begin
    form := AOwner as TForm;
    form.BorderStyle := bsNone;
    Form.Height := 32;

    hproc := TFarProc(GetWindowLong(form.handle, GWL_WNDPROC));
    fproc := Classes.MakeObjectInstance(WndProc);
    SetWindowlong(form.handle, GWL_WNDPROC, longword(fproc));

    with evtTrack do
    begin
      cbSize := sizeOf(tagTRACKMOUSEEVENT);
      dwFlags := TME_LEAVE;
      hwndTrack := application.Handle;
      dwHoverTime := HOVER_DEFAULT;
    end;

    FOldOnPaint := form.OnPaint;
    form.OnPaint := FormPaint;
    SetWindowLong(form.Handle, GWL_EXSTYLE, GetWindowLong(form.Handle,
      GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_TOOLWINDOW);
    SetLayeredWindowAttributes(form.Handle, RGB(255, 0, 254), 255, LWA_COLORKEY);
    FThrobber := TSharpEThrobber.Create(self);
    FThrobber.Parent := form;
    FThrobber.Left := 0;
    FThrobber.Top := 0;
    FThrobber.Visible := true;
    FBackGround := TSharpEBarBackground.Create(self);
  end;
  FirstUpdate := True;
end;

destructor TSharpEBar.Destroy;
begin
  //Do not free FThrobber, form owns it and is responsible for that
  if (csDesigning in ComponentState) and (Owner is TForm) then
    (Owner as TForm).Color := clBtnFace;
  //if not Application.Terminated then
  SetWindowlong(form.handle, GWL_WNDPROC, longword(hproc));
  FSkin.Free;
  FBuffer.Free;
  FBackGround.Free;
  inherited;
end;


procedure TSharpEBar.UpdateAlwaysOnTop;
begin
  if (FAlwaysOnTop) then
  begin
    SetWindowPos(aform.handle, HWND_TOPMOST, 0, 0, 0, 0,
                 SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
    abackground.SetZOrder;                 
  end else
  begin
    if (GetWindowLong(aform.handle, GWL_EXSTYLE) and WS_EX_TOOLWINDOW) = WS_EX_TOOLWINDOW then
    begin
      SetWindowPos(aform.handle, HWND_NOTOPMOST, 0, 0, 0, 0,
                   SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
      abackground.SetZOrder;
    end;
  end;
end;

procedure TSharpEBar.UpdatePosition(NewWidth : integer = -1);
var
  Mon: TMonitorItem;
  x, y: integer;
  u : boolean;
begin
  if (not FAutoPosition) or (csDesigning in ComponentState) then
    exit;

  // Form.Monitor is calling TCustomForm.GetMonitor which makes sure that the TScreen Rect is updated
  Form.Monitor;

  FMonitorIndex := abs(FMonitorIndex);
  try
    if (FMonitorIndex > (MonList.MonitorCount - 1)) or (FPrimaryMon) then
      Mon := MonList.PrimaryMonitor
    else
      Mon := MonList.Monitors[FMonitorIndex];
  except
    exit;
  end;

  if Mon = nil then exit;

  case FVertPos of
    vpTop: y := Mon.Top;
    vpBottom: y := Mon.Top + Mon.Height - form.Height;
  else
    y := Mon.Top;
  end;

  NewWidth := Max(NewWidth,Form.Width);

  case FHorizPos of
    hpLeft: x := Mon.Left;
    hpMiddle: x := Mon.Left + Mon.Width div 2 - NewWidth div 2;
    hpRight: x := Mon.Left + Mon.Width - NewWidth;
    hpFull:
      begin
        x := Mon.Left;
        FOrigWidth := NewWidth;
        Form.Width := Mon.Width;
      end;
  else
    x := Mon.Left;
  end;

  if not (csDesigning in ComponentState) then
  begin
    if Assigned(FThrobber) then
    begin
      if FThrobber.SkinManager <> FManager then
        FThrobber.SkinManager := FManager;
    end;
    SetBitmapSizes;
    FBuffer.Clear(Color32(255, 0, 254, 0));
    if Assigned(FManager) then
      DrawManagedSkin(FManager.Scheme,NewWidth,x)
    else
      DrawDefaultSkin(DefaultSharpEScheme);
  end
  else
  begin
    if (Owner is TForm) then
    begin
      (Owner as TForm).Color := DefaultSharpEScheme.GetColorByName('WorkAreaback');
    end;
  end;

  u := FManager.BarBottom;
  if y > Mon.Top + Mon.Height div 2 then
    FManager.BarBottom := True
  else FManager.BarBottom := False;
  if FManager.BarBottom <> u then
    SkinManager.Skin.UpdateDynamicProperties(SkinManager.Scheme);

  if Assigned(FOnPositionUpdate) then
     FOnPositionUpdate(self,x,y);

  u := (x <> Form.Left) or (y <> Form.Top);
  if x <> Form.Left then
    form.Left := x;
  if y <> Form.Top then
    Form.Top := y;

  if u then
  begin
    FormPaint(nil);
    RedrawWindow(form.Handle, nil, 0, RDW_ERASE or RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN);
    Application.ProcessMessages;
  end;

  if Assigned(FThrobber) then
     if FThrobber.Visible then
        FThrobber.Repaint;

end;

function TSharpEBar.GetSpecialHideForm : Boolean;
begin
  if not Assigned(FManager) then
     result := False
  else result := FManager.Skin.Bar.SpecialHideForm;
end;

procedure TSharpEBar.SetShowThrobber(Value: boolean);
begin
  if Value <> FShowThrobber then
  begin
    FShowThrobber := Value;
    FThrobber.Visible := Value;
    UpdateSkin;
  end;
end;

procedure TSharpEBar.SetAutoStart(Value: boolean);
begin
  if Value <> FAutoStart then
  begin
    FAutoStart := Value;
  end;
end;

procedure TSharpEBar.SetPrimaryMonitor(Value: boolean);
begin
  if Value <> FPrimaryMon then
  begin
    FPrimaryMon := Value;
    UpdatePosition;
  end;
end;

procedure TSharpEBar.SetMonitorIndex(Value: integer);
begin
  if Value <> FMonitorIndex then
  begin
    FMonitorIndex := Value;
    UpdatePosition;
  end;
end;

procedure TSharpEBar.SetAlwaysOnTop(Value: boolean);
begin
  if Value <> FAlwaysOnTop then
  begin
    FAlwaysOnTop := Value;
    UpdateAlwaysOnTop;
  end;
end;

procedure TSharpEBar.SetForceAlwaysOnTop(Value: boolean);
begin
  if not FAlwaysOnTop then
    exit;

  if Value <> FForceAlwaysOnTop then
  begin
    FForceAlwaysOnTop := Value;
    UpdateAlwaysOnTop;
  end;
end;

procedure TSharpEBar.SetAutoPosition(Value: boolean);
begin
  FAutoPosition := True;
  UpdatePosition;
  exit;

  if Value <> FAutoPosition then
  begin
    FAutoPosition := Value;
    UpdatePosition;
  end;
end;

procedure TSharpEBar.SetHorizPos(Value: TSharpEBarHorizPos);
var
  rs: boolean;
begin
  if Value <> FHorizPos then
  begin
    if (FHorizPos = hpFull) or (Value = hpFull) then
      rs := True
    else
      rs := false;
    FHorizPos := Value;
    UpdatePosition;
    if (rs) and (Assigned(FOnResetSize)) then
      FOnResetSize(self);
  end;
end;

procedure TSharpEBar.SetVertPos(Value: TSharpEBarVertPos);
begin
  if Value <> FVertPos then
  begin
    FVertPos := Value;
    if assigned(FManager) then
    begin
      if (FManager.Skin.Bar.Valid)
          and ((not FManager.Skin.Bar.BarBottom.Empty) or (FManager.Skin.Bar.EnableVFlip))
          and (Value = vpBottom) then
      begin
        FManager.Skin.Bar.SetBarBottom;
      end else
      begin
        FManager.Skin.Bar.SetBarTop;
      end;
    end;
    UpdatePosition;
  end;
end;

procedure TSharpEBar.PC_NoAlpha(F: TColor32; var B: TColor32; M: TColor32);
begin
  if (F shr 24) = 255 then
    B := F;
end;

procedure TSharpEBar.SetBitmapSizes(NewWidth : integer = - 1);
begin
  NewWidth := Max(form.Width,NewWidth);
  if (FBuffer.Height <> form.height) or (FBuffer.Width <> NewWidth) then
  begin
    FBuffer.setsize(max(NewWidth,4), max(form.height,4));
    FSkin.setsize(max(NewWidth,4), max(form.height,4));
  end;
end;

procedure TSharpEBar.SetFixedWidth(Value: integer);
begin
  if Value <> FFixedWidth then
  begin
    FFixedWidth := Value;
    if FFixedWidthEnabled then   
      UpdatePosition;
  end;
end;

procedure TSharpEBar.SetFixedWidthEnabled(Value: boolean);
begin
  if Value <> FFixedWidthEnabled then
  begin
    FFixedWidthEnabled := Value;
    UpdatePosition;
  end;
end;

procedure TSharpEBar.DrawDefaultSkin(Scheme: ISharpEScheme);
var
  r: TRect;
begin
  with FSkin do
  begin
    Throbber.Left := 4;
    Throbber.Top := 3;
    Throbber.Width := 10;
    Throbber.Height := 13;
    Clear(color32(0, 0, 0, 0));
    SharpEDefault.AssignDefaultFontTo(FSkin.Font);
    DrawMode := dmBlend;
    r := Rect(0, 0, Width, Height);
    if true then
    begin
      FrameRectS(0, 0, Width, Height, color32(clblack));
      Inc(r.Left); Inc(r.Top); Dec(r.Bottom); Dec(r.Right);
    end;
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('WorkAreaDark')), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('WorkAreaLight')), 255));
    end;
    FillRect(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1,
      setalpha(color32(Scheme.GetColorByName('WorkAreaBack')), 255));
  end;
  FSkin.DrawTo(FBuffer);
  FBackGround.UpdateSkin(FBuffer);
end;

procedure TSharpEBar.DrawManagedSkin(Scheme: ISharpEScheme; NewWidth : integer = -1; NewLeft : integer = - 1);
var
  r, CompRect: TRect;
  fsmod: TPoint; // used for left/right cut off - offsets defined by skin
  sbmod: TPoint; // used for shadow cut off - offsets defined by skin
  Bmp,Bmp2: TBitmap32;
begin
  if not assigned(FManager) then
  begin
    DrawDefaultSkin(DefaultSharpEScheme);
    exit;
  end;

  FManager.Skin.Bar.CheckValid;

  if (FManager.Skin.Bar.Valid) then
  begin
    if ((not FManager.Skin.Bar.BarBottom.Empty) or (FManager.Skin.Bar.EnableVFlip))
      and (FVertPos = vpBottom) then
    begin
      FManager.Skin.Bar.SetBarBottom;
    end else
    begin
      FManager.Skin.Bar.SetBarTop;
    end;

    fsmod.X := FManager.Skin.Bar.FSMod.X;
    fsmod.Y := FManager.Skin.Bar.FSMod.Y;
    sbmod.X := FManager.Skin.Bar.SBMod.X;
    sbmod.Y := FManager.Skin.Bar.SBMod.Y;
    
    case FVertPos of
      vpTop: sbmod.Y := 0;
    end;
    case FHorizPos of
      hpLeft: fsmod.Y := 0;
      hpMiddle:
        begin
          fsmod.X := 0;
          fsmod.Y := 0;
        end;
      hpRight: fsmod.X := 0;
    end;

    NewWidth := Max(NewWidth,form.Width);
    if NewLeft = -1 then
       NewLeft := Form.Left;
    r := FManager.Skin.Bar.GetAutoDim(Rect(0, 0, NewWidth + fsmod.X +
      fsmod.Y, form.height - sbmod.Y));
    if ((r.Right <> NewWidth + fsmod.X + fsmod.Y) or (r.Bottom <> form.height + SBMod.Y))
       and ((NewWidth < 0) or (NewWidth = form.Width))  then
    begin
      form.width := max(r.Right - fsmod.X - fsmod.Y,4);
      form.height := max(r.Bottom - sbmod.Y,4);
      Exit;
    end;

    if (FManager.Skin.Bar.DefaultSkin) then
    begin
      DrawDefaultSkin(DefaultSharpEScheme);
      exit;
    end;

    CompRect := Rect(0, 0, NewWidth + fsmod.X + fsmod.Y, form.height);
    if FManager.Skin.Bar.Valid then
    begin
      FSkin.Clear(Color32(0, 0, 0, 0));

      if Assigned(FOnBackgroundPaint) then
         FOnBackgroundPaint(self,FSkin,NewLeft);

      // Draw Border Alpha Bitmap
      Bmp2 := TBitmap32.Create;
      Bmp := TBitmap32.Create;
      Bmp.Clear(color32(0, 0, 0, 0));
      Bmp.SetSize(FSkin.Width + fsmod.X + fsmod.Y, FSkin.Height);
      Bmp2.SetSize(FSkin.Width + fsmod.X + fsmod.Y, FSkin.Height);
      if (not FManager.Skin.Bar.BarBottomBorder.Empty) and
         (FVertPos = vpBottom) then FManager.Skin.Bar.BarBottomBorder.DrawTo(Bmp, FManager.Scheme)
         else
         begin
           if (not FManager.Skin.Bar.BarBorder.Empty) then
           begin
             FManager.Skin.Bar.BarBorder.DrawTo(Bmp, FManager.Scheme);
             if (FManager.Skin.Bar.EnableVFlip) and (FVertPos = vpBottom) then
                Bmp.FlipVert();
           end else Bmp.Clear(color32(255,255,255,255));
         end;
      Bmp.DrawTo(Bmp2, 0, 0, Rect(fsmod.X, 0, bmp.width - fsmod.y, bmp.height));
      Bmp.free;

      ReplaceTransparentAreas(FSkin,Bmp2,Color32(0,0,0,0));

      // Draw Background
      Bmp := TBitmap32.Create;
      Bmp.CombineMode := cmMerge;
      Bmp.DrawMode := dmBlend;
      Bmp.Clear(color32(0, 0, 0, 0));
      Bmp.SetSize(FSkin.Width + fsmod.X + fsmod.Y, FSkin.Height);
      if (not FManager.Skin.Bar.BarBottom.Empty) and
         (FVertPos = vpBottom) then FManager.Skin.Bar.BarBottom.DrawTo(Bmp, FManager.Scheme)
         else
         begin
           FManager.Skin.Bar.Bar.DrawTo(Bmp, FManager.Scheme);
           if (FManager.Skin.Bar.EnableVFlip) and (FVertPos = vpBottom) then
              Bmp.FlipVert();
         end;
      Bmp.DrawTo(FSkin, 0, 0, Rect(fsmod.X, 0, bmp.width - fsmod.y, bmp.height));
      Bmp.Free;

      FSkin.OnPixelCombine := PC_noAlpha;
      FSkin.DrawMode := dmCustom;
      FSkin.drawto(FBuffer, 0, 0);
      FSkin.DrawMode := dmBlend;
      FSkin.CombineMode := cmMerge;
      FBackGround.UpdateSkin(FSkin);

      ReplaceTransparentAreas(FSkin,Bmp2,Color32(255,0,254,0));
      Bmp2.Free;
    end;
  end
  else
    DrawDefaultSkin(DefaultSharpEScheme);
end;

procedure TSharpEBar.FormPaint(Sender: TObject);
begin
  FBuffer.DrawTo(form.canvas.handle, 0, 0);
  if @FOldOnPaint <> nil then
    FOldOnPaint(Sender);
end;

procedure TSharpEBar.WndProc(var msg: TMessage);
var
  rchanged : boolean;
begin
  rchanged := False;
  case msg.Msg of
    WM_MOVE:
      begin
        FBackGround.UpdateSize;
      end;
    WM_SIZE:
      begin
        UpdateSkin;
      end;
    WM_SHOWWINDOW:
      begin
        if msg.WParam > 0 then
        begin
//          ShowWindow(FBackGround.Handle, sw_ShowNormal);
          SetWindowPos(aBackground.handle,
                       aform.handle,
                       -1, -2, -3, -4,
                       SWP_NOMOVE or SWP_NOSIZE or SWP_NOACTIVATE or SWP_SHOWWINDOW);
          UpdateAlwaysOnTop;
        end
        else
        begin
          ShowWindow(FBackGround.Handle, SW_HIDE);
        end;
      end;
    WM_ACTIVATE:
      begin
        msg.result := 0;
        rchanged := True;
        if LOWORD(msg.WParam) = WA_INACTIVE then
          Throbber.FButtonDown := false;
//        else FBackGround.SetZOrder;
      end;
    WM_ACTIVATEAPP:
      begin
        msg.result := 0;
        rchanged := True;
//        UpdateAlwaysOnTop
//        if msg.WParam = 0 then
  //       SetWindowPos(aform.handle, HWND_NOTOPMOST, 0, 0, 0, 0,
    //                  SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
      end;
    WM_MOUSELEAVE:
      begin
        Throbber.SMouseLeave;
      end;
    WM_LBUTTONDOWN,
      WM_RBUTTONDOWN:
      begin
        if Throbber.FButtonDown then
        begin
          Throbber.FButtonOver := False;
          Throbber.FButtonDown := False;
          Throbber.UpdateSkin;
        end;
      end;
  end;
  if not rchanged then
    msg.result := CallWindowProc(hproc, form.Handle, msg.msg, msg.wparam, msg.lparam);
end;

procedure TSharpEBar.UpdateSkin(NewWidth : integer = -1);
begin
  if (csDestroying in Owner.ComponentState) or
    (csLoading in Owner.ComponentState) then
    exit;

  if not (csDesigning in ComponentState) then
  begin
    if (Assigned(FThrobber)) and (Assigned(FManager)) then
    begin
      if FThrobber.SkinManager <> FManager then
        FThrobber.SkinManager := FManager;
    end;
    if Assigned(FManager) then
    begin
      if FSkinSeed <> FManager.Skin.Bar.Seed then
         FSkinSeed := FManager.Skin.Bar.Seed;
    end;
    SetBitmapSizes(NewWidth);
    FBuffer.Clear(Color32(255, 0, 254, 0));
    if Assigned(FManager) then
      DrawManagedSkin(FManager.Scheme,NewWidth)
    else
      DrawDefaultSkin(DefaultSharpEScheme);
    FormPaint(nil);
    if Assigned(FThrobber)  then
       if FThrobber.Visible then
          FThrobber.UpdateSkin;
  end
  else
  begin
    if (Owner is TForm) then
    begin
     (Owner as TForm).Color := DefaultSharpEScheme.GetColorByName('WorkAreaback');
    end;
  end;
end;

// ########################

constructor TSharpEThrobber.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPar := AOwner as TSharpEBar;
end;

procedure TSharpEThrobber.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if not Visible then
    exit;
  inherited;
  if Assigned(FPar.onThrobberMouseMove) then
    FPar.onThrobberMouseMove(FPar, Shift, X, Y);
end;

procedure TSharpEThrobber.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if not Visible then
    exit;
  inherited;
  UpdateSkin;
  if Assigned(FPar.onThrobberMouseDown) then
    FPar.onThrobberMouseDown(FPar, Button, Shift, X, Y);
end;

procedure TSharpEThrobber.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if not Visible then
    exit;
  inherited;
  UpdateSkin;
  if Assigned(FPar.onThrobberMouseUp) then
    FPar.onThrobberMouseUp(FPar, Button, Shift, X, Y);
end;

procedure TSharpEThrobber.SMouseEnter;
begin
  if not Visible then
    exit;
  UpdateSkin;
end;

procedure TSharpEThrobber.SMouseLeave;
begin
  if not Visible then
    exit;
  FButtonOver := false;
  UpdateSkin;
end;

procedure TSharpEThrobber.DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r: TRect;
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    SharpEDefault.AssignDefaultFontTo(Font);
    DrawMode := dmBlend;
    r := Rect(0, 0, Width, Height);
    if true then
    begin
      FrameRectS(0, 0, Width, Height, color32(clblack));
      Inc(r.Left); Inc(r.Top); Dec(r.Bottom); Dec(r.Right);
    end;
    if FButtonDown then
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('ThrobberLight')), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('ThrobberDark')), 255));
    end
    else
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.GetColorByName('Throbberdark')), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.GetColorByName('ThrobberLight')), 255));
    end;
    FillRect(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1,
      setalpha(color32(Scheme.GetColorByName('ThrobberBack')), 255));
  end;
end;

procedure TSharpEThrobber.DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
var
  r, CompRect: TRect;
  e : boolean;
  fsmod : TPoint;
begin
  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
    exit;
  end;

  if not Visible then
    exit;

  CompRect := Rect(0, 0, Parent.Width, Parent.Height);
  if (FManager.Skin.Bar.Valid) then
  begin
    if FAutoSize then
    begin
      e := False;
      if ((not FManager.Skin.Bar.BarBottom.Empty) or (FManager.Skin.Bar.EnableVFlip))
        and (FPar.VertPos = vpBottom) then
        r := FManager.Skin.Bar.GetThrobberBottomDim(CompRect)
      else r := FManager.Skin.Bar.GetThrobberDim(CompRect);

      if ((r.Right - r.Left) <> width) or ((r.Bottom - r.Top) <> height) then
      begin
        width := r.Right - r.Left;
        height := r.Bottom - r.Top;
        e := True;
      end;

      fsmod.X := FManager.Skin.Bar.FSMod.X;
      fsmod.Y := FManager.Skin.Bar.FSMod.Y;

      case FPar.FHorizPos of
        hpLeft: fsmod.Y := 0;
        hpMiddle:
          begin
            fsmod.X := 0;
            fsmod.Y := 0;
          end;
        hpRight: fsmod.X := 0;
      end;
      
      if (r.Left - fsmod.X <> Left) or (r.Top <> Top) then
      begin
        Left := r.Left - fsmod.X;
        Top := r.Top;
        e := True;
      end;
      if e then exit;
    end;
    FSkin.SetSize(Width,Height);
    FSkin.Clear(Color32(0, 0, 0, 0));
    if FButtonDown then
    begin
      if not (FManager.Skin.Bar.ThDown.Empty) then
        FManager.Skin.Bar.ThDown.DrawTo(bmp, Scheme)
      else DrawDefaultSkin(bmp, DefaultSharpEScheme);
    end
    else
      if FButtonOver then
      begin
        if not (FManager.Skin.Bar.ThHover.Empty) then
          FManager.Skin.Bar.ThHover.DrawTo(bmp, Scheme)
        else DrawDefaultSkin(bmp, DefaultSharpEScheme);
      end else
        if not (FManager.Skin.Bar.ThNormal.Empty) then
        begin
          FManager.Skin.Bar.ThNormal.DrawTo(bmp, Scheme);
        end else DrawDefaultSkin(bmp, DefaultSharpEScheme);
      Bmp.DrawTo(FSkin);
  end
  else
    DrawDefaultSkin(bmp, DefaultSharpEScheme);
end;

procedure PreMul(var Bitmap: TBitmap32);
const w = Round($10000 * (1 / 255));
var
  p: PColor32;
  c: TColor32;
  i, a: integer;
  r, g, b: byte;
begin
  p := Bitmap.PixelPtr[0, 0];
  for i := 0 to Bitmap.Width * Bitmap.Height - 1 do
  begin
    c := p^;
    a := (c shr 24) * w;
    r := c shr 16 and $FF; r := r * a shr 16;
    g := c shr 8 and $FF; g := g * a shr 16;
    b := c and $FF; b := b * a shr 16;
    p^ := (c and $FF000000) or r shl 16 or g shl 8 or b;
    inc(p);
  end;
end;

end.
