{
Source Name: SharpEForm
Description: SharpE component for SharpE
Copyright (C) Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

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
unit SharpEBar;

interface

uses
  Windows,
  Types,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  gr32,
  Math,
  SharpeDefault,
  SharpEBase,
  SharpEBaseControls,
  SharpESkinManager,
  SHarpEScheme,
  SharpESkin;

type
  TSharpEThrobber = class;
  TSharpEBarBackground = class;

  TSharpEBarHorizPos = (hpLeft, hpMiddle, hpRight, hpFull);
  TSharpEBarVertPos = (vpTop, vpBottom);
  TThrobberMouseEvent = procedure(Sender: TObject; X, Y: Integer) of object;

  TSharpEBar = class(TCustomSharpEComponent)
  private
    form: TForm;
    hproc: TFarproc;
    fproc: TFarproc;
    evtTrack: tagTRACKMOUSEEVENT;
    FirstUpdate: boolean;
    FThrobberPosX: string;
    FThrobberPosY: string;
    FOrigWidth: integer;

    FSkinSeed: integer;
    FSkin: TBitmap32;
    FBuffer: TBitmap32;
    FThrobber: TSharpEThrobber;
    FonMouseDown: TMouseEvent;
    FonMouseUp: TMouseEvent;
    FonMouseMove: TMouseMoveEvent;
    FOldOnPaint: TNotifyEvent;
    FOnResetSize: TNotifyEvent;
    FOnPositionUpdate: TNotifyEvent;
    FBackGround: TSharpEBarBackground;
    FAutoPosition: boolean;
    FHorizPos: TSharpEBarHorizPos;
    FVertPos: TSharpEBarVertPos;
    FPrimaryMon: boolean;
    FMonitorIndex: integer;
    FAutoStart: boolean;
    FShowThrobber: Boolean;
    FDisableHideThrobber: Boolean;
    FDisableHideBar     : Boolean;
    FSpecialHideForm    : Boolean;

    procedure PC_NoAlpha(F: TColor32; var B: TColor32; M: TColor32);
    procedure FormPaint(Sender: TObject);
    procedure SetBitmapSizes;
    procedure SetAutoPosition(Value: boolean);
    procedure SetHorizPos(Value: TSharpEBarHorizPos);
    procedure SetVertPos(Value: TSharpEBarVertPos);
    procedure SetPrimaryMonitor(Value: boolean);
    procedure SetMonitorIndex(Value: integer);
    procedure SetAutoStart(Value: boolean);
    procedure SetShowThrobber(Value: boolean);
    function GetSpecialHideForm : boolean;
  protected
    procedure DrawDefaultSkin(Scheme: TSharpEScheme); virtual;
    procedure DrawManagedSkin(Scheme: TSharpEScheme); virtual;
    procedure WndProc(var msg: TMessage);
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateRuntime(AOwner: TComponent; SkinManager : TSharpESkinManager);
    destructor Destroy; override;
    procedure UpdateSkin; override;
    procedure UpdatePosition;
    property aform: TForm read form;
    property abackground: TSharpEBarBackground read FBackGround;
    property Throbber: TSharpEThrobber read FThrobber write FThrobber;
    property ThrobberPosX: string read FThrobberPosX;
    property ThrobberPosY: string read FThrobberPosY;
    property Skin: TBitmap32 read FSkin;
  published
    property SkinManager;
    property AutoPosition: Boolean read FAutoPosition write SetAutoPosition;
    property HorizPos: TSharpEBarHorizPos read FHorizPos write SetHorizPos;
    property VertPos: TSharpEBarVertPos read FVertPos write SetVertPos;
    property PrimaryMonitor: Boolean read FPrimaryMon write SetPrimaryMonitor;
    property MonitorIndex: integer read FMonitorIndex write SetMonitorIndex;
    property AutoStart: Boolean read FAutoStart write SetAutoStart;
    property ShowThrobber: Boolean read FShowThrobber write SetShowThrobber;
    property DisableHideBar: Boolean read FDisableHideBar write FDisableHideBar;
    property SpecialHideForm : Boolean read GetSpecialHideForm;
    property onThrobberMouseDown: TMouseEvent read FonMouseDown write FonMouseDown;
    property onThrobberMouseUp: TMouseEvent read FonMouseUp write FonMouseUp;
    property onThrobberMouseMove: TMouseMoveEvent read FonMouseMove write FonMouseMove;
    property onResetSize: TNotifyEvent read FonResetsize write FonResetSize;
    property onPositionUpdate: TNotifyEvent read FOnPositionUpdate write FOnPositionUpdate;
  end;

  TSharpEBarBackground = class
  private
    fproc: TFarProc;
    FBmp: TBitmap32;
    st: string;
    owner: TComponent;
    Blend: TBlendFunction;
    WindowHandle: hWnd;
  protected
    procedure UpdateSkin(skinbmp: TBitmap32);
    procedure UpdateWndLayer;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure WndProc(var msg: TMessage);
    procedure UpdateSize;
    procedure SetZOrder;
    property handle: hwnd read WindowHandle;
  end;

  TSharpEThrobber = class(TCustomSharpEGraphicControl)
  private
    FPar: TSharpEBar;
  protected
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure SMouseEnter; override;
    procedure SMouseLeave; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); override;
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
begin
  inherited;
  if msg.Msg = WM_ACTIVATE then
  begin
    SetZOrder;
  end;
  msg.Result := DefWindowProc(windowHandle, msg.Msg, msg.wParam, msg.lParam);
  st := inttostr(msg.result);
end;

constructor TSharpEBarBackground.Create(AOwner: TComponent);
var WindowClass: TWndClassEx;
begin
  owner := AOwner;
  FBmp := TBitmap32.create;
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
        WS_EX_TOOLWINDOW,
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
    MessageBox(0, 'Problem when creating Window', 'SharpEBarBackGroundWindow',
      MB_OK)
  end;
end;

destructor TSharpEBarBackground.Destroy;
begin
  DestroyWindow(WindowHandle);
  Windows.UnregisterClass(PChar('SharpEBarBackGround'),hInstance);
  FBmp.free;
  inherited;
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
      0, 0, 0, 0,
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

constructor TSharpEBar.CreateRuntime(AOwner: TComponent; SkinManager : TSharpESkinManager);
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
  FSkin.Free;
  FBuffer.Free;
  FBackGround.Free;
  inherited;
end;

procedure TSharpEBar.UpdatePosition;
var
  Mon: TMonitor;
  x, y: integer;
begin
  if (not FAutoPosition) or (csDesigning in ComponentState) then
    exit;

  FMonitorIndex := abs(FMonitorIndex);
  try
    if (FMonitorIndex > (Screen.MonitorCount - 1)) or (FPrimaryMon) then
      Mon := Screen.PrimaryMonitor
    else
      Mon := Screen.Monitors[FMonitorIndex];
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

  case FHorizPos of
    hpLeft: x := Mon.Left;
    hpMiddle: x := Mon.Left + Mon.Width div 2 - form.Width div 2;
    hpRight: x := Mon.Left + Mon.Width - form.Width;
    hpFull:
      begin
        x := Mon.Left;
        FOrigWidth := Form.Width;
        form.Width := Mon.Width;
      end;
  else
    x := Mon.Left;
  end;

  if x <> Form.Left then
    form.Left := x;
  if y <> Form.Top then
    Form.Top := y;

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
      DrawManagedSkin(FManager.Scheme)
    else
      DrawDefaultSkin(DefaultSharpEScheme);
    FormPaint(nil);
  end
  else
  begin
    if (Owner is TForm) then
    begin
      if Assigned(FManager) then
        (Owner as TForm).Color := FManager.Scheme.WorkAreaback
      else
        (Owner as TForm).Color := DefaultSharpEScheme.WorkAreaback;
    end;
  end;
  if Assigned(FThrobber) then
    FThrobber.Repaint;

  if Assigned(FOnPositionUpdate) then
     FOnPositionUpdate(self); 
end;

function TSharpEBar.GetSpecialHideForm : Boolean;
begin
  if not Assigned(FManager) then
     result := False
  else result := FManager.Skin.BarSkin.SpecialHideForm;
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
    UpdatePosition;
  end;
end;

procedure TSharpEBar.PC_NoAlpha(F: TColor32; var B: TColor32; M: TColor32);
begin
  if (F shr 24) = 255 then
    B := F;
end;

procedure TSharpEBar.SetBitmapSizes;
begin
  if (FBuffer.Height <> form.height) or (FBuffer.Width <> form.width) then
  begin
    FBuffer.setsize(max(form.width,4), max(form.height,4));
    FSkin.setsize(max(form.width,4), max(form.height,4));
  end;
end;

procedure TSharpEBar.DrawDefaultSkin(Scheme: TSharpEScheme);
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
    DefaultSharpESkinText.AssignFontTo(FSkin.Font,Scheme);
    DrawMode := dmBlend;
    r := Rect(0, 0, Width, Height);
    if true then
    begin
      FrameRectS(0, 0, Width, Height, color32(clblack));
      Inc(r.Left); Inc(r.Top); Dec(r.Bottom); Dec(r.Right);
    end;
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.WorkAreaDark), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.WorkAreaLight), 255));
    end;
    FillRect(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1,
      setalpha(color32(Scheme.WorkAreaBack), 255));
  end;
  FSkin.DrawTo(FBuffer);
  FBackGround.UpdateSkin(FBuffer);
end;

procedure TSharpEBar.DrawManagedSkin(Scheme: TSharpEScheme);
var
  r, CompRect: TRect;
  fsmod: TPoint; // used for left/right cut off - offsets defined by skin
  sbmod: TPoint; // used for shadow cut off - offsets defined by skin
  Bmp: TBitmap32;
begin
  if not assigned(FManager) then
  begin
    DrawDefaultSkin(Scheme);
    exit;
  end;

  FManager.Skin.BarSkin.CheckValid;

  if (FManager.Skin.BarSkin.Valid) then
  begin
    try
      fsmod.X := strtoint(FManager.Skin.BarSkin.FSMod.X);
      fsmod.Y := strtoint(FManager.Skin.BarSkin.FSMod.Y);
    except
      fsmod := Point(0, 0);
    end;
    try
      sbmod.X := strtoint(FManager.Skin.BarSkin.SBMod.X);
      sbmod.Y := strtoint(FManager.Skin.BarSkin.SBMod.Y);
    except
      fsmod := Point(0, 0);
    end;
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

    r := FManager.Skin.BarSkin.GetAutoDim(Rect(0, 0, form.width + fsmod.X +
      fsmod.Y, form.height - sbmod.Y));
    if (r.Right <> form.width + fsmod.X + fsmod.Y) or (r.Bottom <> form.height +
      SBMod.Y) then
    begin
      form.width := max(r.Right - fsmod.X - fsmod.Y,4);
      form.height := max(r.Bottom - sbmod.Y,4);
      Exit;
    end;

    if (FManager.Skin.BarSkin.DefaultSkin) then
    begin
      DrawDefaultSkin(Scheme);
      exit;
    end;

    CompRect := Rect(0, 0, form.width + fsmod.X + fsmod.Y, form.height);
    if FManager.Skin.BarSkin.Valid then
    begin
      FSkin.Clear(Color32(0, 0, 0, 0));
      Bmp := TBitmap32.Create;
      Bmp.Clear(color32(0, 0, 0, 0));
      Bmp.SetSize(FSkin.Width + fsmod.X + fsmod.Y, FSkin.Height);
      if (not FManager.Skin.BarSkin.BarBottom.Empty) and
         (FVertPos = vpBottom) then FManager.Skin.BarSkin.BarBottom.draw(Bmp, FManager.Scheme)
         else
         begin
           FManager.Skin.BarSkin.Bar.Draw(Bmp, FManager.Scheme);
           if (FManager.Skin.BarSkin.EnableVFlip) and (FVertPos = vpBottom) then
              Bmp.FlipVert();
         end;
      Bmp.DrawTo(FSkin, 0, 0, Rect(fsmod.X, 0, bmp.width - fsmod.y,
        bmp.height));
      Bmp.free;
      FSkin.OnPixelCombine := PC_noAlpha;
      FSkin.DrawMode := dmCustom;
      FSkin.drawto(FBuffer, 0, 0);
      FSkin.DrawMode := dmBlend;
      FSkin.CombineMode := cmMerge;
      FBackGround.UpdateSkin(FSkin);
    end;
  end
  else
    DrawDefaultSkin(Scheme);
end;

procedure TSharpEBar.FormPaint(Sender: TObject);
begin
  FBuffer.DrawTo(form.canvas.handle, 0, 0);
  if @FOldOnPaint <> nil then
    FOldOnPaint(Sender);
end;

procedure TSharpEBar.WndProc(var msg: TMessage);
begin
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
          ShowWindow(FBackGround.Handle, sw_ShowNormal);
        end
        else
        begin
          ShowWindow(FBackGround.Handle, SW_HIDE);
        end;
      end;
    WM_ACTIVATE:
      begin
        if LOWORD(msg.WParam) = WA_INACTIVE then
        begin
          Throbber.FButtonDown := false;
        end
        else
        begin
          FBackGround.SetZOrder;
        end;
      end;
    WM_MOUSELEAVE:
      begin
        Throbber.SMouseLeave;
      end;
    WM_LBUTTONDOWN,
      WM_RBUTTONDOWN:
      begin
                     { if msg.Msg = WM_LBUTTONDOWN then
                      begin
                        if GET_X_LPARAM(msg.lParam) = 1 then
                           form.Top := form.Top - form.Height - 1;
                      end;     }

        if Throbber.FButtonDown then
        begin
          Throbber.FButtonOver := False;
          Throbber.FButtonDown := False;
          Throbber.UpdateSkin;
        end;
      end;
  end;
  msg.result := CallWindowProc(hproc, form.Handle, msg.msg, msg.wparam,
    msg.lparam);
end;

procedure TSharpEBar.UpdateSkin;
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

      // Save the non modified values
      if FSkinSeed <> FManager.Skin.BarSkin.Seed then
      begin
        FThrobberPosX := FManager.Skin.BarSkin.ThDim.X;
        FThrobberPosY := FManager.Skin.BarSkin.ThDim.Y;
      end;
    end;
    if Assigned(FManager) then
    begin
      if FSkinSeed <> FManager.Skin.BarSkin.Seed then
         FSkinSeed := FManager.Skin.BarSkin.Seed;
    end;
    SetBitmapSizes;
    FBuffer.Clear(Color32(255, 0, 254, 0));
    if Assigned(FManager) then
      DrawManagedSkin(FManager.Scheme)
    else
      DrawDefaultSkin(DefaultSharpEScheme);
    FormPaint(nil);
    if Assigned(FThrobber) then
      FThrobber.UpdateSkin;
  end
  else
  begin
    if (Owner is TForm) then
    begin
      if Assigned(FManager) then
        (Owner as TForm).Color := FManager.Scheme.WorkAreaback
      else
        (Owner as TForm).Color := DefaultSharpEScheme.WorkAreaback;
    end;
  end;

  UpdatePosition;
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

procedure TSharpEThrobber.DrawDefaultSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
var
  r: TRect;
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    DefaultSharpESkinText.AssignFontTo(bmp.Font,Scheme);
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
        setalpha(color32(Scheme.ThrobberLight), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.ThrobberDark), 255));
    end
    else
    begin
      FrameRectS(r.Left, r.Top, r.Right, r.Bottom,
        setalpha(color32(Scheme.Throbberdark), 255));
      FrameRectS(r.Left, r.Top, r.Right - 1, r.Bottom - 1,
        setalpha(color32(Scheme.ThrobberLight), 255));
    end;
    FillRect(r.Left + 1, r.Top + 1, r.Right - 1, r.Bottom - 1,
      setalpha(color32(Scheme.ThrobberBack), 255));
  end;
end;

procedure TSharpEThrobber.DrawManagedSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
var
  r, CompRect: TRect;
begin
  if not Assigned(FManager) then
  begin
    DrawDefaultSkin(bmp, Scheme);
    exit;
  end;

  if not Visible then
    exit;
  if (FManager.Skin.BarSkin.Valid) then
  begin
    case FPar.HorizPos of
      hpLeft, hpFull: FManager.Skin.BarSkin.ThDim.SetLocation(FPar.ThrobberPosX
        +
          '-' + FManager.Skin.BarSkin.FSMod.X, FPar.ThrobberPosY);
      hpMiddle: FManager.Skin.BarSkin.ThDim.SetLocation(FPar.ThrobberPosX,
          FPar.ThrobberPosY);
      hpRight: FManager.Skin.BarSkin.ThDim.SetLocation(FPar.ThrobberPosX,
          FPar.ThrobberPosY);
    end;
  end;
  CompRect := Rect(0, 0, Parent.Width, Parent.Height);
  if (FManager.Skin.BarSkin.Valid) then
  begin
    if FAutoSize then
    begin
      r := FManager.Skin.BarSkin.GetThrobberDim(CompRect);
      if ((r.Right - r.Left) <> width) or ((r.Bottom - r.Top) <> height) then
      begin
        width := r.Right - r.Left;
        height := r.Bottom - r.Top;
        Exit;
      end;
      if (r.Left <> Left) or (r.Top <> Top) then
      begin
        Left := r.Left;
        Top := r.Top;
        Exit;
      end;
    end;
    FSkin.Clear(Color32(0, 0, 0, 0));
    if FButtonDown then
    begin
      if not (FManager.Skin.BarSkin.ThDown.Empty) then
        FManager.Skin.BarSkin.ThDown.Draw(bmp, Scheme)
      else
        DrawDefaultSkin(bmp, Scheme);
    end
    else
      if FButtonOver then
      begin
        if not (FManager.Skin.BarSkin.ThHover.Empty) then
          FManager.Skin.BarSkin.ThHover.Draw(bmp, Scheme)
        else
          DrawDefaultSkin(bmp, Scheme);
      end
      else
        if not (FManager.Skin.BarSkin.ThNormal.Empty) then
        begin
          FManager.Skin.BarSkin.ThNormal.Draw(bmp, Scheme);
        end
        else
          DrawDefaultSkin(bmp, Scheme);
  end
  else
    DrawDefaultSkin(bmp, Scheme);
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
