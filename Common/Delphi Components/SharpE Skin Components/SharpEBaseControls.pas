{
Source Name: SharpEBaseControls.pas
Description: Base Skin Component classes
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

unit SharpEBaseControls;

interface
uses Windows,
  Graphics,
  Messages,
  Forms,
  Classes,
  GR32,
  Controls,
  SharpEDefault,
  ISharpESkinComponents,
  StdCtrls,
  SysUtils;

type
  TCustomSharpEGraphicControl = class(TGraphicControl)
  private
    FMouseEventRegistered: Boolean;
    FOnMouseLeave: TNotifyEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseMove: TMouseMoveEvent;

    procedure CMTextChanged(var msg: TMessage); message CM_TEXTCHANGED;
    procedure CMMouseEnter(var Message: TMessage); message CM_MOUSEENTER;
    procedure CMMouseLeave(var Message: TMessage); message CM_MOUSELEAVE;
    procedure CMLostFocus(var Message: TMessage); message CM_LOSTFOCUS;
    procedure WMMouseMove(var Message: TMessage); message WM_MOUSEMOVE;
    function GetFormWnd(comp: TComponent): hwnd;

  protected
    FButtonDown: boolean;
    FButtonOver: boolean;
    FManager: ISharpESkinManager;
    FSkin: TBitmap32;
    FBuffer: TBitmap32;
    FBackground: TBitmap32;
    FAutoSize: boolean;
    FSpecialBackground : TBitmap32;

    procedure Paint; override;
    procedure Loaded; override;
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme); virtual;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure DrawSkin;
    procedure SMouseEnter; virtual;
    procedure SMouseLeave; virtual;
    procedure DrawToCanvas;
    procedure SetBitmapSizes;
    procedure SetManager(value: ISharpESkinManager); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetAutoSize(value: Boolean); override;
    procedure UpdateSkin; overload; virtual;
    procedure UpdateSkin(pManager: ISharpESkinManager); overload;
    property SkinManager: ISharpESkinManager read FManager write SetManager;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property SpecialBackground : TBitmap32 read FSpecialBackground write FSpecialBackground;
  end;

  TCustomSharpEComponent = class(TComponent)
  protected
    FManager: ISharpESkinManager;

    procedure Loaded; override;
    procedure SetManager(value: ISharpESkinManager); virtual;
  public
    procedure UpdateSkin; overload; virtual;
    procedure UpdateSkin(pManager: ISharpESkinManager); overload;
    property SkinManager: ISharpESkinManager read FManager write SetManager;
  end;
  
  TCustomSharpEControl = class(TCustomControl)
  protected
    FManager: ISharpESkinManager;
    FSpecialBackground: TBitmap32;

    procedure Loaded; override;
    procedure SetManager(value: ISharpESkinManager); virtual;
  public
    procedure UpdateSkin; overload; virtual;
    procedure UpdateSkin(pManager: ISharpESkinManager); overload;
    property SkinManager: ISharpESkinManager read FManager write SetManager;
    property SpecialBackground : TBitmap32 read FSpecialBackground write FSpecialBackground;
  end;

implementation

procedure TCustomSharpEComponent.Loaded;
begin
  inherited;
  UpdateSkin;
end;

procedure TCustomSharpEComponent.UpdateSkin(pManager: ISharpESkinManager);
begin
  if FManager = pManager then
    UpdateSkin;
end;

procedure TCustomSharpEComponent.SetManager(value: ISharpESkinManager);
begin
  if FManager <> value then
  begin
    FManager := Value;
    UpdateSkin;
  end;
end;

procedure TCustomSharpEComponent.UpdateSkin;
begin
end;

procedure TCustomSharpEControl.Loaded;
begin
  inherited;
  UpdateSkin;
end;

procedure TCustomSharpEControl.UpdateSkin(pManager: ISharpESkinManager);
begin
  if FManager = pManager then
    UpdateSkin;
end;

procedure TCustomSharpEControl.SetManager(value: ISharpESkinManager);
begin
  if FManager <> value then
  begin
    FManager := Value;
    UpdateSkin;
  end;
end;

procedure TCustomSharpEControl.UpdateSkin;
begin
end;


constructor TCustomSharpEGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(Aowner);
  SetParentComponent(AOwner);
  FAutoSize := true;
  FSkin := TBitmap32.Create;
  FSkin.DrawMode := dmBlend;
  FBackGround := TBitmap32.Create;
  FBuffer := TBitmap32.Create;
  FMouseEventRegistered := false;
  SetBitmapSizes;
end;

destructor TCustomSharpEGraphicControl.Destroy;
begin
  inherited;
  FSkin.Free;
  FBackground.Free;
  FBuffer.Free;
end;

procedure TCustomSharpEGraphicControl.DrawDefaultSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    FrameRectS(0, 0, Width, Height, setalpha(color32(clblack), 200));
    FrameRectS(1, 1, Width - 1, Height - 1, setalpha(color32(clblack), 200));
    FrameRectS(1, 1, Width - 2, Height - 2, setalpha(color32(clwhite), 200));
    FillRect(2, 2, Width - 2, Height - 2, setalpha(color32(clsilver), 200));
  end;
end;

procedure TCustomSharpEGraphicControl.DrawManagedSkin(bmp: TBitmap32; Scheme: ISharpEScheme);
begin
  DrawDefaultSkin(bmp, Scheme);
end;

procedure TCustomSharpEGraphicControl.SetManager(value: ISharpESkinManager);
begin
  FManager := value;

  UpdateSkin;
end;

procedure TCustomSharpEGraphicControl.UpdateSkin(pManager: ISharpESkinManager);
begin
  if FManager = pManager then
    UpdateSkin;
end;

procedure TCustomSharpEGraphicControl.SetAutoSize(value: Boolean);
begin
  FAutoSize := value;
  if FAutoSize then
    UpdateSkin;
end;

procedure TCustomSharpEGraphicControl.Loaded;
begin
  inherited;
  UpdateSkin;
end;

procedure TCustomSharpEGraphicControl.CMTextChanged(var msg: TMessage);
begin
  UpdateSkin;
end;

procedure TCustomSharpEGraphicControl.MouseDown(Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  inherited;
  FButtonDown := true;
end;

procedure TCustomSharpEGraphicControl.MouseUp(Button: TMouseButton; Shift:
  TShiftState; X, Y: Integer);
begin
  inherited;
  FButtonDown := false;
end;

procedure TCustomSharpEGraphicControl.MouseMove(Shift: TShiftState; X, Y: integer);
begin
  inherited;
end;

procedure TCustomSharpEGraphicControl.SMouseEnter;
begin
end;

procedure TCustomSharpEGraphicControl.SMouseLeave;
begin
end;

function TCustomSharpEGraphicControl.GetFormWnd(comp: TComponent): hwnd;
var temp: TComponent;
begin
  temp := comp;
  while temp.Owner <> nil do
  begin
    temp := temp.Owner;
    if temp is TForm then
    begin
      result := (temp as Tform).handle;
      exit;
    end;
  end;
  result := 0;
end;

procedure TCustomSharpEGraphicControl.WMMouseMove(var Message: TMessage);
var
  tme: TTRACKMOUSEEVENT;
  TrackMouseEvent_: function(var EventTrack: TTrackMouseEvent): BOOL; stdcall;
  wnd: hwnd;
  Shift : TShiftState;
begin
  if not FMouseEventRegistered then
  begin
    wnd := GetFormWnd(self);
    FMouseEventRegistered := true;
    tme.cbSize := sizeof(TTRACKMOUSEEVENT);
    tme.dwFlags := TME_LEAVE;
    tme.dwHoverTime := 10;
    tme.hwndTrack := wnd;
    @TrackMouseEvent_ := @TrackMouseEvent;
    TrackMouseEvent_(tme);
  end;
  if Assigned(OnMouseMove) then
  begin
    shift := [];
    if (message.WParam and MK_CONTROL)=MK_CONTROL then shift := shift + [ssCtrl];
    if (message.WParam and MK_LBUTTON)=MK_LBUTTON then shift := shift + [ssLeft];
    if (message.WParam and MK_MBUTTON)=MK_MBUTTON then shift := shift + [ssMiddle];
    if (message.WParam and MK_RBUTTON)=MK_RBUTTON then shift := shift + [ssRight];
    if (message.WParam and MK_SHIFT)=MK_SHIFT then shift := shift + [ssShift];
    OnMouseMove(self, Shift,  message.LParamLo,  message.LParamHi);
  end;
  inherited;
end;

procedure TCustomSharpEGraphicControl.CMMouseEnter(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
  FButtonOver := true;
  SMouseEnter;
end;

procedure TCustomSharpEGraphicControl.CMLostFocus(var Message: TMessage);
begin
  FButtonDown := false;
  CMMouseLeave(Message);
end;

procedure TCustomSharpEGraphicControl.CMMouseLeave(var Message: TMessage);
begin
  inherited;
  if Assigned(FOnMouseLeave) then
    FOnMouseLeave(Self);
  FMouseEventRegistered := false;
  FButtonOver := false;
  FButtonDown := false;
  SMouseLeave;
end;

procedure TCustomSharpEGraphicControl.DrawSkin;
begin
  try
    if Assigned(FManager) then
      DrawManagedSkin(FSkin, FManager.Scheme)
    else
      DrawDefaultSkin(FSkin, DefaultSharpEScheme);
  except
  end;
end;

procedure TCustomSharpEGraphicControl.DrawToCanvas;
begin
  FBuffer.Clear(Color32(0,0,0,0));
  FBackground.drawto(FBuffer, 0, 0);
  FSkin.drawto(FBuffer, 0, 0);
  FBuffer.DrawTo(canvas.handle, 0, 0);
end;

procedure TCustomSharpEGraphicControl.UpdateSkin;
begin
  if (csDestroying in Owner.ComponentState) or
    (csLoading in Owner.ComponentState) then
    exit;
  DrawSkin;
  if Visible then
    DrawToCanvas;
end;

procedure TCustomSharpEGraphicControl.SetBitmapSizes;
begin
  if (FBuffer.Height <> height) or (FBuffer.Width <> width) then
  begin
    FBuffer.setsize(width, height);
    FSkin.setsize(width, height);
    FBackground.setsize(width, height);
  end;
end;

procedure TCustomSharpEGraphicControl.Paint;
begin
  SetBitmapSizes;
  //Get background from window canvas
  FBackground.Clear(Color32(0,0,0,0));
  if FSpecialBackground = nil then
  begin
    Windows.BitBlt(FBackground.Canvas.Handle, 0, 0,
      FBackground.Width, FBackground.Height,
      Canvas.Handle, 0, 0, SRCCOPY);
  end else
  begin
    FBackground.Draw(0,0,Rect(Left,Top,Left+Width,Top+Height),FSpecialBackground);
  end;

  DrawSkin;
  DrawToCanvas;
end;

end.