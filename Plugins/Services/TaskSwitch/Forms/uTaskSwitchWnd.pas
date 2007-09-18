{
Source Name: uTaskSwitchWnd.pas
Description: SharpE Task Switch Window Container
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

unit uTaskSwitchWnd;

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
  AppEvnts;

type
  TTaskSwitchWnd = class(TForm)
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    FOwner : TObject;
    FPicture : TBitmap32;
    DC: HDC;
    Blend: TBlendFunction;
    procedure UpdateWndLayer;
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMNCHitTest(var Message: TWMNCHitTest);
  public
    Hook : HHOOK;
    procedure DrawWindow;
    procedure PreMul(Bitmap: TBitmap32);
    constructor Create(AOwner: TComponent; BOwner : TObject); reintroduce;
  published
    property cOwner : TObject read FOwner;
    property Picture : TBitmap32 read FPicture;
  end;


implementation

{$R *.dfm}

uses
  uTaskSwitchGUI;

// has to be applied to the TBitmap32 before passing it to the API function
procedure TTaskSwitchWnd.PreMul(Bitmap: TBitmap32);
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


constructor TTaskSwitchWnd.Create(AOwner: TComponent; BOwner : TObject);
begin
  inherited Create(AOwner);
  
  FOwner := BOwner;
  FPicture := TBitmap32.Create;
end;

procedure TTaskSwitchWnd.WMPaint(var Msg: TWMPaint);
begin
  inherited;
  Application.ProcessMessages;
end;

procedure TTaskSwitchWnd.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if PtInRect(ClientRect, ScreenToClient(Point(Message.XPos, Message.YPos))) then
    Message.Result := HTClient;
end;

procedure TTaskSwitchWnd.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
begin
  if (Height <> FPicture.Height) then
    Height := FPicture.Height;

  if (Width <> FPicture.Width) then
    Width := FPicture.Width;

  BmpSize.cx := Width;
  BmpSize.cy := Height;
  BmpTopLeft := Point(0, 0);
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

procedure TTaskSwitchWnd.DrawWindow;
begin
  UpdateWndLayer;
end;

procedure TTaskSwitchWnd.FormCreate(Sender: TObject);
begin
  ShowWindow( Application.Handle, SW_HIDE );
  SetWindowLong( Application.Handle, GWL_EXSTYLE,
                 GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
  ShowWindow( Application.Handle, SW_SHOW );

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

procedure TTaskSwitchWnd.FormActivate(Sender: TObject);
begin
  DrawWindow;
end;

procedure TTaskSwitchWnd.FormDestroy(Sender: TObject);
begin
  FPicture.Free;
end;




end.


