{
Source Name: uSplashForm.pas
Description: Main SharpSplash Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
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

unit uSplashForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  SharpApi,
  ExtCtrls,  
  GR32,
  GR32_Layers,
  GR32_Image,
  GR32_PNG,
  GR32_Blend;

type
  TSplashForm = class(TForm)
    Closetimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ClosetimerTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FTerminate : boolean;
    FPicture : TBitmap32;
    DC: HDC;
    Blend: TBlendFunction;
    FadeIn : integer;
    FadeOut : integer;
    ShowDelay : integer;
    procedure UpdateWndLayer;
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMNCHitTest(var Message: TWMNCHitTest);
  public
    procedure DrawWindow;
    constructor Create(AOwner: TComponent); reintroduce; override;
  end;


var
  SplashForm : TSplashForm;
  temp : TSplashForm; 

implementation

{$R *.dfm}



// has to be applied to the TBitmap32 before passing it to the API function
procedure PreMul(Bitmap: TBitmap32);
const w = Round($10000 * (1/255));
var
  p: PColor32;
  c: TColor32;
  i,a,r,g,b: integer;
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

constructor TSplashForm.Create(AOwner: TComponent);
var
  n : integer;
  FileName : String;
  b : boolean;
begin
  inherited Create(AOwner);
  FTerminate := False;

  try
    FileName := ParamStr(1);
    FadeIn := strtoint(ParamStr(2));
    ShowDelay := strtoint(ParamStr(3));
    CloseTimer.Interval := ShowDelay;
    FadeOut := strtoint(ParamStr(4));
  except
    FTerminate := True;
    Application.Terminate;
    exit;
  end;
  if length(FileName) = 0 then
  begin
    FTerminate := True;
    Application.Terminate;
    exit;
  end;

  try
    FPicture := TBitmap32.Create;
    LoadBitmap32FromPNG(FPicture,FileName,b);
  except
    FTerminate := True;
    Application.Terminate;
    exit;
  end;

  // FPicture.SaveToFile('X:\1.png');

  Width  := FPicture.Width;
  Height := FPicture.Height;
  left   := Screen.WorkAreaWidth div 2 - self.Width div 2;
  top    := Screen.WorkAreaHeight div 2 - self.Height div 2;
end;

procedure TSplashForm.WMPaint(var Msg: TWMPaint);
begin
  inherited;
  Application.ProcessMessages;
end;

procedure TSplashForm.WMNCHitTest(var Message: TWMNCHitTest);
begin
  if PtInRect(ClientRect, ScreenToClient(Point(Message.XPos, Message.YPos))) then
    Message.Result := HTClient;
end;

procedure TSplashForm.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
  Bmp : TBitmap32;
begin
  if FTerminate then exit;
  BmpSize.cx := Width;
  BmpSize.cy := Height;
  BmpTopLeft := Point(0, 0);
  TopLeft := BoundsRect.TopLeft;

  DC := GetDC(Handle);
  try
    if not Win32Check(LongBool(DC)) then
      RaiseLastWin32Error;

    Bmp := TBitmap32.Create;
    bmp.SetSize(FPicture.Width,FPicture.Height);
    Bmp.Clear(color32(0,0,0,0));
    FPicture.DrawMode := dmBlend;    
    Bmp.Draw(0,0,FPicture);
    //Bmp.Assign(FPicture);
    if not Win32Check(UpdateLayeredWindow(Handle, DC, @TopLeft, @BmpSize,
      Bmp.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA)) then
      RaiseLastWin32Error;
    Bmp.Free;
  finally
    ReleaseDC(Handle, DC);
  end;
end;

procedure TSplashForm.DrawWindow;
var
  SwapBMP, Swap2: TBitmap32;
  b: boolean;
  i:integer;
begin
 // Swap2 := TBitmap32.Create;  // try many drawto over a final png and see


//  SwapBMP := TBitmap32.Create;
//  SwapBMP.drawmode := dmBlend;
//  SwapBMP.LoadFromFile('C:\Icons\BlueIcons1\Blue Icon PNGs\Direct Connect.png');
//  GR32_PNG.LoadBitmap32FromPNG(SwapBMP,'C:\png.png',b);

//  PreMul(SwapBmp);

//  SwapBMP.MasterAlpha := 255;
//  SwapBMP.DrawTo(MBitmap,10,10);

  UpdateWndLayer; // aggiorna la finestra con l'immagine MBitmap

 // Swap2.Free;
//  SwapBMP.Free;
end;

procedure TSplashForm.FormCreate(Sender: TObject);
var
  b : boolean;
begin
  if FTerminate then exit;

  DC := 0;

  with Blend do
  begin
    BlendOp := AC_SRC_OVER;
    BlendFlags := 0;
    SourceConstantAlpha := 255;
    AlphaFormat := AC_SRC_ALPHA;
  end;

  if SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED) = 0 then ShowMessage('Errore in set trasparenza');
end;

procedure TSplashForm.FormActivate(Sender: TObject);
var
 n : real;
 ni : real;
begin
  n := 0;
  ni := (70*255)/FadeIn;
  repeat
    n := n + ni;
    if n>255 then n := 255;
    Blend.SourceConstantAlpha := round(n);
    DrawWindow;
    sleep(50);
  until n>=255;              
  CloseTimer.Enabled := True;
end;

{procedure TBackgroundForm.WMMove(var Msg : TMessage);
begin
  TForm(Owner).Left := self.Left+4;
  TForm(Owner).Top  := self.Top+2;
  TForm(Owner).BringToFront;
end;                        }


procedure TSplashForm.ClosetimerTimer(Sender: TObject);
begin
   CloseTimer.Enabled := False;
   Close;
end;

procedure TSplashForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
 n : real;
 ni : real;
begin
  n := 255;
  ni := (70*255)/FadeOut;
  repeat
    n := n - ni;
    if n<0 then n := 0;
    Blend.SourceConstantAlpha := round(n);
    DrawWindow;
    sleep(50);
  until n<=0;
end;

end.


