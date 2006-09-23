unit TranComp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, GR32, JCLStrings;

type
  TCtrl = class(TWinControl);


type

  TZ9Edit = class(TEdit) 
  private 
    { Private declarations } 
    FAlignText: TAlignment; 
    FTransparent: Boolean; 
    FPainting: Boolean; 
    procedure SetAlignText(Value: TAlignment); 
    procedure SetTransparent(Value: Boolean); 
  protected 
    { Protected declarations } 
    procedure RepaintWindow;
    procedure CreateParams(var Params: TCreateParams); override; 
    procedure Change; override; 
    procedure SetParent(AParent: TWinControl); override; 
    procedure WMPaint(var Message: TWMPaint); message WM_PAINT; 
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT; 
    procedure WMEraseBkGnd(var Message: TWMEraseBkGnd); message WM_ERASEBKGND;
    procedure CNCtlColorEdit(var Message: TWMCtlColorEdit); message CN_CTLCOLOREDIT;
    procedure CNCtlColorStatic(var Message: TWMCtlColorStatic); message CN_CTLCOLORSTATIC; 
    procedure CMParentColorChanged(var Message: TMessage); message CM_PARENTCOLORCHANGED; 
    procedure WMSize(var Message: TWMSize); message WM_SIZE; 
    procedure WMMove(var Message: TWMMove); message WM_MOVE;
    procedure PaintParent(ACanvas: TCanvas);
  public 
    { Public declarations } 
    constructor Create(AOwner: TComponent); override; 
    destructor Destroy; override; 
  published 
    { Published declarations } 
    property Align; 
    property AlignText: TAlignment read FAlignText write SetAlignText default taLeftJustify; 
    property Transparent: Boolean read FTransparent write SetTransparent default false; 

  end;


procedure Register;

implementation

const
 BorderRec: array[TBorderStyle] of Integer = (1, -1);


procedure Register;
begin
  RegisterComponents('Transparent Components', [TZ9Edit]);
end;

function GetScreenClient(Control: TControl): TPoint;
var
 p: TPoint;
begin
 p := Control.ClientOrigin;
 ScreenToClient(Control.Parent.Handle, p);
 Result := p;
end;



type
  TParentControl = class(TWinControl);

constructor TZ9Edit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlignText := taLeftJustify;
  FTransparent := false;
  FPainting := false;
end;

destructor TZ9Edit.Destroy;
begin
  inherited Destroy;
end;



procedure TZ9Edit.SetAlignText(Value: TAlignment); 
begin
  if FAlignText <> Value then
  begin 
    FAlignText := Value; 
    RecreateWnd; 
    Invalidate; 
  end; 
end; 


procedure TZ9Edit.SetTransparent(Value: Boolean); 
begin
  if FTransparent <> Value then
  begin 
    FTransparent := Value; 
    Invalidate; 
  end; 
end; 

procedure TZ9Edit.WMEraseBkGnd(var Message: TWMEraseBkGnd); 
var 
  DC: hDC; 
  i: integer; 
  p: TPoint; 
  canvas : TCanvas;
  oh : THandle; 
begin
  if FTransparent and not(csDesigning in componentstate) then
  begin
    canvas := TCanvas.create; 
    try
      canvas.handle := message.dc;
      PaintParent(Canvas);
    finally
      canvas.free;
    end;
  end
  else
  begin
    canvas := TCanvas.create;
    try
      canvas.handle := message.dc;
      canvas.brush.color := Color;
      canvas.brush.style := bsSolid;
      canvas.fillrect(clientrect);
    finally 
      canvas.free; 
    end; 
  end; 
end; 

procedure TZ9Edit.WMPaint(var Message: TWMPaint); 
begin
  inherited;
  if FTransparent then
    if not FPainting then RepaintWindow;
end;

procedure TZ9Edit.WMNCPaint(var Message: TMessage);
begin
  inherited;
end; 

procedure TZ9Edit.CNCtlColorEdit(var Message: TWMCtlColorEdit);
begin
  inherited;
  if FTransparent then SetBkMode(Message.ChildDC, 1);
end;

procedure TZ9Edit.CNCtlColorStatic(var Message: TWMCtlColorStatic);
begin
  inherited;
  if FTransparent then SetBkMode(Message.ChildDC, 1);
end;

procedure TZ9Edit.CMParentColorChanged(var Message: TMessage);
begin
  inherited;
  if FTransparent then Invalidate; 
end; 

procedure TZ9Edit.WMSize(var Message: TWMSize); 
var 
  r : TRect;
begin
  inherited;
  r := ClientRect; 
  InvalidateRect(handle,@r,false); 
end; 


procedure TZ9Edit.WMMove(var Message: TWMMove); 
var 
  r : TRect; 
begin
  inherited;
  Invalidate; 
  r := ClientRect; 
  InvalidateRect(handle,@r,false); 
end; 

procedure TZ9Edit.RepaintWindow; 
var 
  DC: hDC; 
  TmpBitmap, Bitmap: hBitmap;
  canvas : TCanvas;
  tempdc : hDC;
begin
  if FTransparent then
  begin
    FPainting := true;
    HideCaret(Handle);
    tempdc := GetDC(Handle);
    DC := CreateCompatibleDC(tempdc);
    TmpBitmap := CreateCompatibleBitmap(tempdc, Succ(ClientWidth), Succ(ClientHeight));
    Bitmap := SelectObject(DC, TmpBitmap);
    PaintTo(DC, 0, 0);
    BitBlt(tempdc, BorderRec[BorderStyle] + BorderWidth, BorderRec[BorderStyle] + BorderWidth, ClientWidth, ClientHeight, DC, 1, 1, SRCCOPY);
    SelectObject(DC, Bitmap);
    DeleteDC(DC);     
    ReleaseDC(Handle, tempdc);
    DeleteObject(TmpBitmap);
    ShowCaret(Handle);
    FPainting := false;
  end;
end; 

procedure TZ9Edit.CreateParams(var Params: TCreateParams); 
const
  Alignments: array [TAlignment] of DWord = (ES_LEFT, ES_RIGHT, ES_CENTER); 
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or ES_AUTOHSCROLL;
end;

procedure TZ9Edit.Change;
begin
  RepaintWindow;
  inherited Change; 
end; 

procedure TZ9Edit.SetParent(AParent: TWinControl); 
begin
  inherited SetParent(AParent);
end; 

procedure TZ9Edit.PaintParent(ACanvas: TCanvas); 
var 
  I, Count, X, Y, SaveIndex: integer; 
  DC: cardinal; 
  R, SelfR, CtlR: TRect; 
  Control : TControl; 
begin
  Control := Self;
  if Control.Parent = nil then Exit; 
  Count := Control.Parent.ControlCount; 
  DC := ACanvas.Handle;

  SelfR := Bounds(Control.Left, Control.Top, Control.Width, Control.Height); 
  X := -Control.Left; Y := -Control.Top; 
  // Copy parent control image 
  SaveIndex := SaveDC(DC); 
  SetViewportOrgEx(DC, X, Y, nil); 
  IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth, Control.Parent.ClientHeight); 
  TParentControl(Control.Parent).Perform(WM_ERASEBKGND,DC,0); 
  TParentControl(Control.Parent).PaintWindow(DC); 
  RestoreDC(DC, SaveIndex); 

  //Copy images of graphic controls 
  for I := 0 to Count - 1 do begin 
    if (Control.Parent.Controls[I] <> nil) then 
    begin 
      if Control.Parent.Controls[I] = Control then break; 

      with Control.Parent.Controls[I] do 
      begin 
        CtlR := Bounds(Left, Top, Width, Height); 
        if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then 
        begin 
          SaveIndex := SaveDC(DC); 
          SetViewportOrgEx(DC, Left + X, Top + Y, nil); 
          IntersectClipRect(DC, 0, 0, Width, Height); 
          Perform(WM_ERASEBKGND,DC,0); 
          Perform(WM_PAINT, integer(DC), 0); 
          RestoreDC(DC, SaveIndex); 
        end; 
      end; 
    end; 
  end; 
end;


end.
