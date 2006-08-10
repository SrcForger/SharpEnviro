unit SharpEBaseControls;

interface
uses Windows,
  Graphics,
  Messages,
  Forms,
  Classes,
  GR32,
  GR32_Image,
  SharpEScheme,
  Controls,
  SharpESkinManager,
  SharpEDefault,
  STdCtrls,
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
    FManager: TSharpESkinManager;
    FSkin: TBitmap32;
    FBuffer: TBitmap32;
    FBackground: TBitmap32;
    FAutoSize: boolean;

    procedure Paint; override;
    procedure Loaded; override;
    procedure DrawDefaultSkin(bmp: TBitmap32; Scheme: TSharpEScheme); virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
      override;
    procedure MouseMove(Shift: TShiftState; X, Y: integer); override;
    procedure DrawSkin;
    procedure SMouseEnter; virtual;
    procedure SMouseLeave; virtual;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure DrawToCanvas;
    procedure SetBitmapSizes;
    procedure SetManager(value: TSharpESkinManager); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetAutoSize(value: Boolean); override;
    procedure UpdateSkin; overload; virtual;
    procedure UpdateSkin(sender: TComponent); overload;
    procedure DrawManagedSkin(bmp: TBitmap32; Scheme: TSharpEScheme); virtual;
    property SkinManager: TSharpESkinManager read FManager write SetManager;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseLeave: TNotifyEvent read FOnMouseLeave write FOnMouseLeave;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
  end;

  TCustomSharpEComponent = class(TComponent)
  protected
    FManager: TSharpESkinManager;

    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure Loaded; override;
    procedure SetManager(value: TSharpESkinManager); virtual;
  public
    procedure UpdateSkin; overload; virtual;
    procedure UpdateSkin(sender: TComponent); overload;
    property SkinManager: TSharpESkinManager read FManager write SetManager;
  end;
  
  TCustomSharpEControl = class(TCustomControl)
  protected
    FManager: TSharpESkinManager;

    procedure Notification(AComponent: TComponent; Operation: TOperation);
      override;
    procedure Loaded; override;
    procedure SetManager(value: TSharpESkinManager); virtual;
  public
    procedure UpdateSkin; overload; virtual;
    procedure UpdateSkin(sender: TComponent); overload;
    property SkinManager: TSharpESkinManager read FManager write SetManager;
  end;

implementation
uses Consts,
  RTLConsts,
  ActnList;

procedure TCustomSharpEComponent.Loaded;
begin
  inherited;
  UpdateSkin;
end;

procedure TCustomSharpEComponent.UpdateSkin(sender: TComponent);
begin
  if FManager = sender then
    UpdateSkin;
end;

procedure TCustomSharpEComponent.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FManager) then
    begin
      FManager := nil;
      UpdateSkin;
    end;
  end
  else
    if (Operation = opInsert) then
    begin
      if (AComponent is TSharpESkinManager) and (csDesigning in ComponentState)
        then
      begin
        if FManager = nil then
        begin
          FManager := AComponent as TSharpESkinManager;
          UpdateSkin;
        end;
      end;
    end;
end;

procedure TCustomSharpEComponent.SetManager(value: TSharpESkinManager);
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

procedure TCustomSharpEControl.UpdateSkin(sender: TComponent);
begin
  if FManager = sender then
    UpdateSkin;
end;

procedure TCustomSharpEControl.Notification(AComponent: TComponent; Operation:
  TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FManager) then
    begin
      FManager := nil;
      UpdateSkin;
    end;
  end
  else
    if (Operation = opInsert) then
    begin
      if (AComponent is TSharpESkinManager) and (csDesigning in ComponentState)
        then
      begin
        if FManager = nil then
        begin
          FManager := AComponent as TSharpESkinManager;
          UpdateSkin;
        end;
      end;
    end;
end;

procedure TCustomSharpEControl.SetManager(value: TSharpESkinManager);
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

procedure TCustomSharpEGraphicControl.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then
  begin
    if (AComponent = FManager) then
    begin
      FManager := nil;
      UpdateSkin;
      Invalidate;
    end;
  end
  else
    if (Operation = opInsert) then
    begin
      if (AComponent is TSharpESkinManager) and (csDesigning in ComponentState)
        then
      begin
        if FManager = nil then
        begin
          FManager := AComponent as TSharpESkinManager;
          UpdateSkin;
          Invalidate;
        end;
      end;
    end;
end;

procedure TCustomSharpEGraphicControl.DrawDefaultSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
begin
  with bmp do
  begin
    Clear(color32(0, 0, 0, 0));
    FrameRectS(0, 0, Width, Height, setalpha(color32(clblack), 200));
    FrameRectS(1, 1, Width - 1, Height - 1,
      setalpha(color32(Scheme.WorkAreadark), 200));
    FrameRectS(1, 1, Width - 2, Height - 2,
      setalpha(color32(Scheme.WorkAreaLight), 200));
    FillRect(2, 2, Width - 2, Height - 2, setalpha(color32(Scheme.WorkAreaBack),
      200));
  end;
end;

procedure TCustomSharpEGraphicControl.DrawManagedSkin(bmp: TBitmap32; Scheme:
  TSharpEScheme);
begin
  DrawDefaultSkin(bmp, Scheme);
end;

procedure TCustomSharpEGraphicControl.SetManager(value: TSharpESkinManager);
begin
  FManager := value;
  if Assigned(FManager) then
    FManager.FreeNotification(self);

  UpdateSkin;
end;

procedure TCustomSharpEGraphicControl.UpdateSkin(sender: TComponent);
begin
  if FManager = sender then
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
  Windows.BitBlt(FBackground.Canvas.Handle, 0, 0,
    FBackground.Width, FBackground.Height,
    Canvas.Handle, 0, 0, SRCCOPY);

  DrawSkin;
  DrawToCanvas;
end;

end.