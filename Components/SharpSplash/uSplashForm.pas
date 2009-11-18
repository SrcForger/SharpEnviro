{
Source Name: uSplashForm.pas
Description: Main SharpSplash Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>
              Aleksandar Milanovic (viking) <aleksandar.milanovic@hotmail.com>

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

unit uSplashForm;

interface

uses
  Windows,
  Messages,
  Types,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  SharpApi,
  SharpThemeApiEx,
  uISharpETheme,
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
    procedure FormDestroy(Sender: TObject);
  private
    FPicture : TBitmap32;
    DC: HDC;
    Blend: TBlendFunction;
    FadeIn : integer;
    FadeOut : integer;
    ShowDelay : integer;
    ShowSplash : boolean;
    procedure UpdateWndLayer;
  protected
  public
    procedure DrawWindow;
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
  i,a: integer;
  r,g,b: byte;
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

procedure TSplashForm.UpdateWndLayer;
var
  TopLeft, BmpTopLeft: TPoint;
  BmpSize: TSize;
  Bmp : TBitmap32;
begin
  if not ShowSplash then
    exit;

  BmpSize.cx := Width;
  BmpSize.cy := Height;
  BmpTopLeft := Point(0, 0);
  TopLeft := BoundsRect.TopLeft;

  DC := GetDC(Handle);
  Bmp := TBitmap32.Create;
  try
    {$WARNINGS OFF}
    if not Win32Check(LongBool(DC)) then
      RaiseLastWin32Error;

    bmp.SetSize(FPicture.Width,FPicture.Height);
    Bmp.Clear(color32(0,0,0,0));
    FPicture.DrawMode := dmBlend;
    Bmp.Draw(0,0,FPicture);
    if not Win32Check(UpdateLayeredWindow(Handle, DC, @TopLeft, @BmpSize,
      Bmp.Handle, @BmpTopLeft, clNone, @Blend, ULW_ALPHA)) then
      RaiseLastWin32Error;
    {$WARNINGS ON}
  finally
    Bmp.Free;
    ReleaseDC(Handle, DC);
  end;
end;

procedure TSplashForm.DrawWindow;
begin
  UpdateWndLayer;
end;

procedure TSplashForm.FormCreate(Sender: TObject);
var
  FullFileName, PassedFileName : string;
  b : boolean;
  Theme : ISharpETheme;
begin
  FPicture := TBitmap32.Create;
  ShowSplash := True;

  Theme := GetCurrentTheme;
  
  ServiceDone('SharpSplash');
  // set defaults if no params passed
  PassedFileName := ParamStr(1);
  FadeIn := StrToIntDef(ParamStr(2), 3000);
  ShowDelay := StrToIntDef(ParamStr(3), 5000);
  FadeOut := StrToIntDef(ParamStr(4), 3000);

  CloseTimer.Interval := ShowDelay;

  // find splash image
  FullFileName := Theme.Info.Directory + '\' + PassedFileName;
  if not FileExists(FullFileName) then
  begin
    FullFileName := GetSharpeDirectory + PassedFileName;
    if not FileExists(FullFileName) then
    begin
      FullFileName := PassedFileName;
      if not FileExists(FullFileName) then
        FullFileName := GetSharpeDirectory + 'Splash.png';
    end;
  end;

  // set terminate flag if picture could not be loaded
  try
    LoadBitmap32FromPNG(FPicture, FullFileName, b);
  except
    ShowSplash := False;
  end;

  if ShowSplash then
  begin
    PreMul(FPicture);
    Width  := FPicture.Width;
    Height := FPicture.Height;
    left   := Screen.WorkAreaWidth div 2 - self.Width div 2;
    top    := Screen.WorkAreaHeight div 2 - self.Height div 2;

    DC := 0;

    with Blend do
    begin
      BlendOp := AC_SRC_OVER;
      BlendFlags := 0;
      SourceConstantAlpha := 255;
      AlphaFormat := AC_SRC_ALPHA;
    end;

    if SetWindowLong(Handle, GWL_EXSTYLE, GetWindowLong(Handle, GWL_EXSTYLE) or WS_EX_LAYERED or WS_EX_TOOLWINDOW) = 0 then
      SendDebugMessage('SharpSplash', 'Error setting window style.', 0);
  end;
end;

procedure TSplashForm.FormDestroy(Sender: TObject);
begin
  FPicture.Free;
end;

procedure TSplashForm.FormActivate(Sender: TObject);
var
 n : real;
 ni : real;
begin
  if ShowSplash then
  begin
    n := 0;
    ni := (70*255)/FadeIn;
    repeat
      n := n + ni;
      if n > 255 then
        n := 255;

      Blend.SourceConstantAlpha := round(n);
      DrawWindow;
      sleep(50);
    until n >= 255;

    CloseTimer.Enabled := True;
  end else
    Close;
end;

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
  if ShowSplash then
  begin
    n := 255;
    ni := (70*255)/FadeOut;
    repeat
      n := n - ni;
      if n < 0 then
        n := 0;
        
      Blend.SourceConstantAlpha := round(n);
      DrawWindow;
      sleep(50);
    until n <= 0;
  end;
end;

end.


