{
Source Name: DriveLayer
Description: Drive desktop object layer class
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
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

unit uDriveObjectLayer;

interface
uses
  Windows, StdCtrls, Forms,Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, SharpDeskApi, JclFileUtils, JclShell,
  DriveObjectXMLSettings,
  uSharpDeskDebugging,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskTDeskSettings,
  uSharpDeskFunctions,
  uSharpDeskDesktopPanel,
  GR32_Resamplers;
type
   TColorRec = packed record
                 b,g,r,a: Byte;
               end;
   TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
   PColorArray = ^TColorArray;
   TDriveType = (dtUnknown, dtNoDrive, dtFloppy, dtFixed, dtNetwork, dtCDROM,dtRAM);   

  TDriveLayer = class(TBitmapLayer)
  private
    FFontSettings    : TDeskFont;
    FIconSettings    : TDeskIcon;
    FCaptionSettings : TDeskCaption;
    FSettings        : TXMLSettings;
    FUpdateTimer     : TTimer;
    FHLTimer         : TTimer;
    FHLTimerI        : integer;
    FAnimSteps       : integer;
    FObjectID        : integer;
    FShadowAlpha     : integer;
    FShadowColor     : integer;
    FIconType        : integer;
    FIconShadowColor : integer;
    FIconShadow      : integer;
    FDiskFull        : integer;
    FDiskMax         : integer;
    FScale           : integer;
    FDriveType       : TDriveType;
//    FUseIconShadow   : Boolean;
    FLocked          : Boolean;
    FDeskPanel       : TDesktopPanel;
    FPicture         : TBitmap32;
    FMeterBmp        : TBitmap32;
    Fcs              : TColorScheme;
    FDeskSettings    : TDeskSettings;
    FThemeSettings   : TThemeSettings;
    FObjectSettings  : TObjectSettings;
  protected
     procedure OnTimer(Sender: TObject);
     procedure OnUpdateTimer(Sender : TObject);
     procedure doLoadImage(IconFile: string);
  public
     FParentImage : Timage32;
     procedure CreateIconShadow;
     procedure DrawBitmap;
     procedure DrawMeterBmp;
     procedure LoadSettings;
     procedure DoubleClick;
     procedure LoadDefaultImage;
     procedure OnOpenClick(Sender : TObject);
     procedure OnSearchClick(Sender : TObject);
     procedure OnPropertiesClick(Sender : TObject);
     procedure OnOpenWith(Sender : TObject);
     procedure StartHL;
     procedure EndHL;
     constructor Create( ParentImage:Timage32; Id : integer;
                         DeskSettings : TDeskSettings;
                         ThemeSettings : TThemeSettings;
                         ObjectSettings : TObjectSettings); reintroduce;
     destructor Destroy; override;
     property ObjectId: Integer read FObjectId write FObjectId;
     property Settings  : TXMLSettings read FSettings;
     property DiskFull  : integer read FDiskFull;
     property DiskMax   : integer read FDiskMax;
     property Locked    : boolean read FLocked    write FLocked;     
  private
  end;


const
     DESK_SETTINGS = 'Settings\SharpDesk\SharpDesk.xml';
     THEME_SETTINGS = 'Settings\SharpDesk\Themes.xml';
     OBJECT_SETTINGS = 'Settings\SharpDesk\Objects.xml';

implementation

function GetDiskCapacity(drive: char): integer;
var
  a: real;
  b: string;
  driveno: integer;
begin
     try
       driveno := Ord(UpCase(Drive)) - Ord('A') + 1;
       a := Disksize(driveno) / 1048576;
       if a = -1 then
       begin
            result := 0;
            exit;
       end;
       b := floattostrf(a, ffFixed, 10, 0);
       Result := StrToInt(b);
     except
       result:=0;
     end;
end;

function GetDiskFree(drive: char): integer;
var
  a: real;
  b: string;
  driveno: integer;
begin
     try
       driveno := Ord(UpCase(Drive)) - Ord('A') + 1;
       a := DiskFree(driveno) / 1048576;
       if a = -1 then
       begin
            result := 0;
            exit;
       end;
       b := floattostrf(a, ffFixed, 10, 0);
       Result := StrToInt(b);
     except
           result := 0;
           exit;
     end;
end;


function DriveConnected(DriveLetter : char) : Boolean;
var  hr : hresult;
   remotename : array[0..255] of char;
   cbRemoteName : cardinal;
begin
  cbRemoteName := Length(RemoteName);
  hr := WNetGetConnection(pChar(DriveLetter), RemoteName, cbRemoteName);
  if hr = NO_ERROR then result := true
  else result := false;
end;

function GetDiskIn(Drive: Char): Boolean;
var
  ErrorMode: word;
  DriveNumber: Integer;
begin
  {Meldung eines kritischen Systemfehlers vehindern}
  ErrorMode:=SetErrorMode(SEM_FailCriticalErrors);
  try
    DriveNumber:=Ord(Drive) - 64;
    if DiskSize(DriveNumber) = -1 then
      Result:=False
    else
      Result:=True;
  finally
    {ErrorMode auf den alten Wert setzen}
    SetErrorMode(ErrorMode);
  end;
end;

procedure TDriveLayer.OnOpenClick(Sender : TObject);
begin
  DoubleClick;
end;


procedure TDriveLayer.OnSearchClick(Sender : TObject);
//var
//   Shell: Variant;
begin
  //   Shell := CreateOLEObject('Shell.Application');
  //   Shell.FindFiles;
end;

procedure TDriveLayer.OnPropertiesClick(Sender : TObject);
begin
  DisplayPropDialog(Application.Handle,FSettings.Target+':\');
end;

procedure TDriveLayer.OnOpenWith(Sender : TObject);
begin
  ShellOpenAs(FSettings.Target+':\');
end;

procedure GetAlphaBMP(Bmp,Target : TBitmap32);
var
   P,P2: PColor32;
   X,Y,alpha : integer;
   pass : Array of Array of integer;
   tempBmp : TBitmap32;   
begin
     TempBmp := TBitmap32.Create;
     TempBmp.SetSize(Bmp.Width,Bmp.Height);
     TempBmp.Clear(color32(255,255,255,255));
     with Bmp do
     begin
          setlength(pass,width,height);
          P2 := TempBmp.PixelPtr[0,0];
          P := PixelPtr[0, 0];
          inc(P,(1-1)*width+0);
          inc(P2,(1-1)*width+0);
          for Y := 1 to Height do
          begin
               for X := 0 to Width- 1 do
               begin
                    alpha := (P^ shr 24);
                    if alpha = 255 then P2^ := color32(0,0,0,0)
                       else P2^ := color32(P^ shr 16,P^ shr 8,P^,alpha);
                    inc(P);
                    inc(P2);
               end;
               inc(P,0);
               inc(p2,0);
          end;
     end;
     Target.Assign(TempBmp);
     TempBmp.Free;
end;

procedure RemoveAlpha(Bmp : TBitmap32);
var
   P : PColor32;
   X,Y,alpha : integer;
begin
     with Bmp do
     begin
          P := PixelPtr[0, 0];
          inc(P,(1-1)*width+0);
          for Y := 1 to Height do
          begin
               for X := 0 to Width- 1 do
               begin
                    alpha := (P^ shr 24);
                    if (alpha<>255) and (alpha <>0) then
                        P^ := color32(P^ shr 16,P^ shr 8,P^,0);
                    inc(P); // proceed to the next pixel
               end;
               inc(P,0);
          end;
     end;
end;


procedure TDriveLayer.CreateIconShadow;
var
   TempBmp,OBmp : TBitmap32;
begin
  if FIconType=0 then exit;

  OBmp := TBitmap32.Create;
  TempBmp := TBitmap32.Create;
  OBmp.Width := FPicture.Width;
  OBmp.Height := FPicture.Height;
  OBmp.Clear(color32(0,0,0,0));
  FPicture.DrawMode := dmBlend;
  FPicture.CombineMode := cmMerge;
  FPicture.DrawTo(OBmp);
  FPicture.Clear(color32(0,0,0,0));

  GetAlphaBMP(OBmp,TempBmp);
  RemoveAlpha(OBmp);
  CreateDropShadow(OBmp,0,1,FIconShadow,FIconShadowColor);

  OBmp.DrawTo(FPicture,0,0);
  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;
  TempBmp.DrawTo(FPicture,0,0);
  TempBmp.Free;
  OBmp.Free;
end;


procedure TDriveLayer.StartHL;
begin
 // if FHLTimer.Enabled then exit;
  if FDeskSettings.Theme.DeskHoverAnimation then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    SharpDeskApi.LightenBitmap(Bitmap,50);
  end;
end;

procedure TDriveLayer.EndHL;
begin
//if FHLTimer.Enabled then exit;
  if FDeskSettings.Theme.DeskHoverAnimation then
  begin
    FHLTimerI := -1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
  end;
end;

procedure TDriveLayer.OnUpdateTimer(Sender : TObject);
begin
  if GetDiskIn(FSettings.Target[1]) then
  begin
    FDiskMax   := GetDiskCapacity(FSettings.Target[1]);
    FDiskFull  := FDiskMax-GetDiskFree(FSettings.Target[1]);
  end else
  begin
    FDiskMax := 1;
    FDiskFull := 1;
  end;
  DrawBitmap;
end;

procedure TDriveLayer.OnTimer(Sender: TObject);
var
  i : integer;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;
  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 0;
    FScale := 100;
    if (FSettings.UseThemeSettings) and (FDeskSettings.Theme.DeskUseAlphaBlend) then
       i := FDeskSettings.Theme.DeskAlphaBlend
        else if FSettings.AlphaBlend then i := FSettings.AlphaValue
             else i := 255;
    if i > 255 then i := 255
       else if i<32 then i := 32;
    Bitmap.MasterAlpha := i;
    DrawBitmap;
    FParentImage.EndUpdate;
    EndUpdate;
    Changed;
    exit;
  end;

  if FDeskSettings.Theme.AnimScale then
     FScale := round(100 + ((FDeskSettings.Theme.AnimScaleValue)/FAnimSteps)*FHLTimer.Tag);
  if FDeskSettings.Theme.AnimAlpha then
  begin
    if (FSettings.UseThemeSettings) and (FDeskSettings.Theme.DeskUseAlphaBlend) then
       i := FDeskSettings.Theme.DeskAlphaBlend
        else if FSettings.AlphaBlend then i := FSettings.AlphaValue
             else i := 255;
    i := i + round(((FDeskSettings.Theme.AnimAlphaValue/FAnimSteps)*FHLTimer.Tag));
    if i > 255 then i := 255
       else if i<32 then i := 32;
    Bitmap.MasterAlpha := i;
  end;
  if FHLTimer.Tag >= FAnimSteps then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := FAnimSteps;
  end;
  DrawBitmap;
  if FDeskSettings.Theme.AnimBB then
     SharpDeskApi.LightenBitmap(Bitmap,round(FHLTimer.Tag*(FDeskSettings.Theme.AnimBBValue/FAnimSteps)));
  if FDeskSettings.Theme.AnimBlend then
     SharpDeskApi.BlendImage(Bitmap,FDeskSettings.Theme.AnimBlendColor,round(FHLTimer.Tag*(FDeskSettings.Theme.AnimBlendValue/FAnimSteps)));
  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;


procedure TDriveLayer.DoubleClick;
begin
  SharpExecute(FSettings.Target+':\');
end;

procedure VGradient(Bmp : TBitmap32; color1,color2 : TColor; Rect : TRect);
var
   nR,nG,nB : real;
   sR,sG,sB : integer;
   eR,eG,eB : integer;
   y : integer;
begin
     sR := GetRValue(color1);
     sG := GetGValue(color1);
     sB := GetBValue(color1);
     eR := GetRValue(color2);
     eG := GetGValue(color2);
     eB := GetBValue(color2);
     nR:=(eR-sR)/(Rect.Bottom-Rect.Top);
     nG:=(eG-sG)/(Rect.Bottom-Rect.Top);
     nB:=(eB-sB)/(Rect.Bottom-Rect.Top);
     for y:=0 to Rect.Bottom-Rect.Top do
         Bmp.HorzLineS(Rect.Left,y+Rect.Top,Rect.Right,
                       color32(sr+round(nr*y),sg+round(ng*y),sb+round(nb*y),255));
end;


// ######################################


procedure HGradient(Bmp : TBitmap32; color1,color2 : TColor; Rect : TRect);
var
   nR,nG,nB : real;
   sR,sG,sB : integer;
   eR,eG,eB : integer;
   x : integer;
begin
     sR := GetRValue(color1);
     sG := GetGValue(color1);
     sB := GetBValue(color1);
     eR := GetRValue(color2);
     eG := GetGValue(color2);
     eB := GetBValue(color2);
     nR:=(eR-sR)/(Rect.Right-Rect.Left);
     nG:=(eG-sG)/(Rect.Right-Rect.Left);
     nB:=(eB-sB)/(Rect.Right-Rect.Left);
     for x:=0 to Rect.Right-Rect.Left do
         Bmp.VertLineS(x+Rect.Left,Rect.Top,Rect.Bottom,
                       color32(sr+round(nr*x),sg+round(ng*x),sb+round(nb*x),255));
end;


procedure TDriveLayer.DrawMeterBmp;
var
  I,CY,w : integer;
  Clr,LineColor : TColor32;
  sx,sy : integer;
begin
  if (FDiskMax = 0)
     or (FDiskFull > FDiskMax)
     or (FDiskFull < 0)
     or (FDriveType = dtFloppy)
     or (FMeterBmp.Width<=2)
     or (FMeterBmp.Height<=2) then
  begin
    FMeterBmp.Clear(color32(0,0,0,0));
    exit;
  end;
  with FMeterBmp do
  begin
    Clear(color32(0,0,0,0));
    if (FSettings.MeterAlign=0) or (FSettings.MeterAlign=2) then
    begin
      FMeterBmp.FillRectTS(0, 0, Width,Height,color32(FSettings.MBorder));
      try
        w := round((Width-2)*FDiskFull/FDiskMax);
        if w = 0 then w:=1;
        if w>1 then
          FillRectTS(1,1,w,Height div 2-1, color32(FSettings.MFGStart));
        if w<=Width-3 then
           FillRectTS(w,1,width-1,Height div 2-1, color32(FSettings.MBGStart));
        if w>1 then           
        VGradient(FMeterBmp,FSettings.MFGStart,FSettings.MFGEnd,Rect(1,Height div 2-1,w-1,Height-2));
        if w<=Width-3 then
          VGradient(FMeterBmp,FSettings.MBGStart,FSettings.MBGEnd,Rect(w,Height div 2-1,width-2,Height-2));
        LineS(w,1,w,Height-1,color32(FSettings.MFGEnd));        
      finally
      EMMS; // the low-level blending function was used EMMS is required
      end;
    end else
    begin
      FMeterBmp.FillRectTS(0, 0, Width,Height,color32(FSettings.MBorder));
      w := round((Height-2)*FDiskFull/FDiskMax);
      if w = 0 then w := 1;
      FillRectTS(1,1,Width div 2,Height - w, color32(FSettings.MBGStart));
      if w>1 then
        FillRectTS(1,Height - w,Width div 2,Height-1, color32(FSettings.MFGStart));
      HGradient(FMeterBmp,FSettings.MBGStart,FSettings.MBGEnd,Rect(Width div 2-1,1,Width-2,Height - w-1));
      if w>1 then
        HGradient(FMeterBmp,FSettings.MFGStart,FSettings.MFGEnd,Rect(Width div 2-1,Height - w,Width-2,Height-2));
      LineS(1,Height - w,width-1,Height - w,color32(FSettings.MFGEnd));        
      try
      finally
       EMMS; // the low-level blending function was used EMMS is required
      end;
    end;
  end;
end;

procedure TDriveLayer.DrawBitmap;
var
   R : TFloatrect;
   p : TPoint;
   w,h : integer;
   eh : integer;
   n : integer;
   PM : TPoint;
   MM : TPoint;
   x,y : integer;
   ix,iy : integer;
   FontBitmap : TBitmap32;
   IconBitmap : TBitmap32;
   LetterBitmap : TBitmap32;
   TopHeight    : integer;
   BottomHeight : integer;
   LeftWidth    : integer;
   RightWidth   : integer;
   SList : TStringList;
   TempBitmap : TBitmap32;
   cialign : TAlignInfo;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

 { TempBitmap := TBitmap32.Create;
  FontBitmap := TBitmap32.Create;
  FontBitmap.DrawMode := dmBlend;
  FontBitmap.CombineMode := cmMerge;
  TempBitmap.DrawMode := dmBlend;
  TempBitmap.CombineMode := cmMerge;
  SharpDeskApi.RenderObject(FontBitmap,
                            FIconSettings,
                            FFontSettings,
                            FCaptionSettings,
                            Point(0,0),
                            Point(0,0));
  w := FontBitmap.Width;
  h := FontBitmap.Height;

  if FSettings.DisplayMeter then
  begin
    case FSettings.MeterAlign of
     0,2 : h := h + 10;
     1,3 : w := w + 10;
    end;
    case fSettings.MeterAlign of
     0,2 : FMeterBmp.SetSize(w-FSettings.MLeftOffset+FSettings.MRightOffset,10-FSettings.MTopOffset+FSettings.MBottomOffset);
     1,3 : FMeterBmp.SetSize(10-FSettings.MLeftOffset+FSettings.MRightOffset,h-FSettings.MTopOffset+FSettings.MBottomOffset);
    end;
    DrawMeterBmp;
  end;
  
  if FSettings.DriveLetter then
  begin
    LetterBitmap := TBitmap32.Create;
    with LetterBitmap do
    begin
      if FSettings.DLAlpha then MasterAlpha := FSettings.DLAlphaValue
         else MasterAlpha := 255;
      Font.Color := FSettings.DLFontColor;
      Font.Name  := FSettings.DLFontName;
      Font.Size  := FSettings.DLFontSize;
      Font.Style := [];
      if FSettings.DLFontBold then
         Font.Style := Font.Style + [fsbold];
      if FSettings.DLFontItalic then
         Font.Style := Font.Style + [fsitalic];
      if FSettings.DLFontUnderline then
         Font.Style := Font.Style + [fsunderline];
      SetSize(TextHeight(FSettings.Target)+1,
              TextHeight(FSettings.Target)+1);
      Clear(color32(FSettings.LGBorder));
      VGradient(LetterBitmap,FSettings.LGStart,FSettings.LGEnd,
                Rect(1,1,Width-2,Height-2));
      RenderText(Width div 2 - TextWidth(FSettings.Target) div 2,
                 Height div 2 - TextHeight(FSettings.Target) div 2 ,
                 FSettings.Target,0,color32(Font.Color));
    end;
  end;

  TempBitmap.SetSize(w,h);
  TempBitmap.Clear(color32(0,0,0,0));
  case FSettings.MeterAlign of
   0,1 : begin
           FontBitmap.DrawTo(TempBitmap,10,10);   
           FMeterBmp.DrawTo(TempBitmap,w div 2 - 5 - FSettings.MLeftOffset,h div 2 - 5 - FSettings.MTopOffset);
         end;
  end;



//      case FSettings.MeterAlign of
//     0 : Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
//     1 : Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
//     2 : Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset+IconBitmap.Height-10,FMeterBmp);
//     3 : Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X+FSettings.MLeftOffset + IconBitmap.Width-10,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
//    end;


  case FSettings.BGType of
   1: begin
        w := TempBitmap.Width + FSettings.BGThicknessValue + 2;
        h := TempBitmap.Height + FSettings.BGThicknessValue + 2;
        Bitmap.SetSize(w,h);
        Bitmap.Clear(color32(0,0,0,0));
        Bitmap.FillRectS(Bitmap.Canvas.ClipRect,color32(GetRValue(FSettings.BGBorderColor),
                                                        GetGValue(FSettings.BGBorderColor),
                                                        GetBValue(FSettings.BGBorderColor),
                                                        FSettings.BGTransValue));
        Bitmap.FillRectS(Rect(FSettings.BGThicknessValue,
                              FSettings.BGThicknessValue,
                              Bitmap.Width-FSettings.BGThicknessValue,
                              Bitmap.Height-FSettings.BGThicknessValue),
                              color32(GetRValue(FSettings.BGColor),
                                      GetGValue(FSettings.BGColor),
                                      GetBValue(FSettings.BGColor),
                                      FSettings.BGTransValue));
        Bitmap.Draw(FSettings.BGThicknessValue + 1,FSettings.BGThicknessValue + 1,TempBitmap);
      end;
   2: begin
        FDeskPanel.SetCenterSize(TempBitmap.Width,TempBitmap.Height);
        FDeskPanel.Paint;
        if FSettings.BGTHBlend then
           SharpDeskApi.BlendImage(FDeskPanel.Bitmap,FSettings.BGTHBlendColor);
        if FSettings.BGTrans then
           FDeskPanel.Bitmap.MasterAlpha := FSettings.BGTransValue
           else FDeskPanel.Bitmap.MasterAlpha := 255;
        FDeskPanel.Bitmap.DrawMode := dmBlend;
        Bitmap.SetSize(FDeskPanel.Width,FDeskPanel.Height);
        Bitmap.Draw(0,0,FDeskPanel.Bitmap);
        Bitmap.Draw(FDeskPanel.TopHeight,FDeskPanel.LeftWidth,TempBitmap);
      end;
   else
   begin
     Bitmap.SetSize(TempBitmap.Width,TempBitmap.Height);
     Bitmap.Clear(color32(0,0,0,0));
     Bitmap.Draw(0,0,TempBitmap);
   end;
  end;

  TempBitmap.Free;  }

  IconBitmap := TBitmap32.Create;
  w := FPicture.Width;
  h := FPicture.Height;

  if FSettings.DisplayMeter then
  begin
    case FSettings.MeterAlign of
     0,2 : h := h + 10;
     1,3 : w := w + 10;
    end;
    case fSettings.MeterAlign of
     0,2 : FMeterBmp.SetSize(w-FSettings.MLeftOffset+FSettings.MRightOffset,10-FSettings.MTopOffset+FSettings.MBottomOffset);
     1,3 : FMeterBmp.SetSize(10-FSettings.MLeftOffset+FSettings.MRightOffset,h-FSettings.MTopOffset+FSettings.MBottomOffset);
    end;
    DrawMeterBmp;
  end;
//  IconBitmap.SetSize(w,h);
//  IconBitmap.Clear(color32(0,0,0,0));
  ix := FIconSettings.Xoffset;
  iy := FIconSettings.Yoffset;
  FIconSettings.Xoffset := 0;
  FIconSettings.Yoffset := 0;
  x := 0;
  y := 0;
  if FSettings.DisplayMeter then
  begin
    case FSettings.MeterAlign of
     0 : begin
           FIconSettings.Xoffset := -Min(FSettings.MLeftOffset,0);     
           FIconSettings.Yoffset := 10-Min(FSettings.MTopOffset,0);
           x := Max(FSettings.MRightOffset,0);
           y := 0;
         end;
     1 : begin
           FIconSettings.Xoffset := 10-Min(FSettings.MLeftOffset,0);
           FIconSettings.Yoffset := -Min(FSettings.MTopOffset,0);
           x := 0;
           y := Max(FSettings.MBottomOffset,0);;
         end;
     2 : begin
           FIconSettings.Xoffset := -Min(FSettings.MLeftOffset,0);
           FIconSettings.Yoffset := 0;
           x := Max(FSettings.MRightOffset,0);
           y := Max(FSettings.MBottomOffset,0);;
         end;
     3 : begin
           FIconSettings.Xoffset := 0;
           FIconSettings.Yoffset := -Min(FSettings.MTopOffset,0);
           x := Max(FSettings.MRightOffset,0);
           y := Max(FSettings.MBottomOffset,0);
         end;
    end;
    SharpDeskApi.RenderIcon(IconBitmap,FIconSettings,Point(x,y));
{    case FSettings.MeterAlign of
     0 : IconBitmap.Draw(0,10,FPicture);
     1 : IconBitmap.Draw(10,0,FPicture);
     2 : IconBitmap.Draw(0,0,FPicture);
     3 : IconBitmap.Draw(0,0,FPicture);
    end;}
  end else SharpDeskApi.RenderIcon(IconBitmap,FIconSettings,point(0,0));
  if FSettings.DisplayMeter then
  begin
    case FSettings.MeterAlign of
     0 : MM := Point(0,0);
     1 : MM := Point(10,0);
     2 : MM := Point(0,-10);
     3 : MM := Point(0,0);
    end;
  end else MM := Point(0,0);

  //Seems like it must be said sometimes
  IconBitmap.DrawMode := dmOpaque;

  LetterBitmap := TBitmap32.Create;
  if FSettings.DriveLetter then
  begin
    with LetterBitmap do
    begin
      LetterBitmap.DrawMode := dmBlend;
      LetterBitmap.CombineMode := cmMerge;
      if FSettings.DLAlpha then MasterAlpha := FSettings.DLAlphaValue
         else MasterAlpha := 255;
      Font.Color := FSettings.DLFontColor;
      Font.Name  := FSettings.DLFontName;
      Font.Size  := FSettings.DLFontSize;
      Font.Style := [];
      if FSettings.DLFontBold then
         Font.Style := Font.Style + [fsbold];
      if FSettings.DLFontItalic then
         Font.Style := Font.Style + [fsitalic];
      if FSettings.DLFontUnderline then
         Font.Style := Font.Style + [fsunderline];
      SetSize(TextHeight(FSettings.Target)+1,
              TextHeight(FSettings.Target)+1);
      Clear(color32(FSettings.LGBorder));
      VGradient(LetterBitmap,FSettings.LGStart,FSettings.LGEnd,
                Rect(1,1,Width-2,Height-2));
      RenderText(Width div 2 - TextWidth(FSettings.Target) div 2,
                 Height div 2 - TextHeight(FSettings.Target) div 2 ,
                 FSettings.Target,0,color32(Font.Color));
    end;
  end;

  if (FSettings.ShowCaption) or (FSettings.DiskData) then
  begin
    FontBitmap := TBitmap32.Create;
   // SList := TStringList.Create;
    //SList.Clear;
    FCaptionSettings.Caption.Clear;
    if FSettings.ShowCaption then
    begin
      if FSettings.MLineCaption then FCaptionSettings.Caption.CommaText := FSettings.Caption
         else FCaptionSettings.Caption.Add(FSettings.Caption);
    end;
    if FSettings.DiskData then FCaptionSettings.Caption.Add(inttostr(FDiskMax-FDiskFull)+' MB Free');
    case FCaptionSettings.Align of
      taTop,taBottom: n := 0;
      taLeft: n := 1;
      taRight: n:= -1;
      else n := 0;
    end;
    SharpDeskApi.RenderText(FontBitmap,FFontSettings,FCaptionSettings.Caption,n,0);

  {  FontBitmap.Font := Bitmap.Font;
    p := GetBitmapSize(FontBitmap,SList);
    p.x := p.x + 8;
    p.y := p.y + 4;
    eh := FontBitmap.TextHeight('!"§$%&/()=?`°QWERTZUIOPÜASDFGHJJKLÖÄYXCVBNqp1234567890');
    FontBitmap.SetSize(p.x,p.y);
    FontBitmap.Clear(color32(0,0,0,0));
    for n := 0 to SList.Count - 1 do
        FontBitmap.RenderText(FontBitmap.Width div 2 - FontBitmap.TextWidth(SList[n]) div 2 - 2,n*eh+2,SList[n],0,color32(FontBitmap.Font.Color));
    if FSettings.Shadow then createdropshadow(FontBitmap,0,1,FShadowAlpha,FShadowColor);
    SList.Free;}
  end else
  begin
    FontBitmap := TBitmap32.Create;
    FontBitmap.Font := Bitmap.Font;
    FontBitmap.SetSize(0,0);
  end;

  {PM.X := 0;
  PM.Y := 0;
  case FSettings.BGType of
   1: begin
        w := Max(IconBitmap.Width,FontBitmap.Width);
        h := IconBitmap.Height + FontBitmap.Height;
        TopHeight    := FSettings.BGThicknessValue+4;
        BottomHeight := FSettings.BGThicknessValue+4;
        LeftWidth    := FSettings.BGThicknessValue+4;
        RightWidth   := FSettings.BGThicknessValue+4;
        PM.X := 2;
        PM.Y := 2;
      end;
   2: begin
        w := Max(IconBitmap.Width,FontBitmap.Width)+8;
        h := IconBitmap.Height + FontBitmap.Height+8;
        FDeskPanel.SetCenterSize(w,h+FSettings.IconSpacingValue);
        FDeskPanel.Paint;
        if FSettings.BGTHBlend then
           SharpDeskApi.BlendImage(FDeskPanel.Bitmap,FSettings.BGTHBlendColor);
        if FSettings.BGTrans then
           FDeskPanel.Bitmap.MasterAlpha := FSettings.BGTransValue
           else FDeskPanel.Bitmap.MasterAlpha := 255;
        FDeskPanel.Bitmap.DrawMode := dmBlend;
        TopHeight    := FDeskPanel.TopHeight;
        BottomHeight := FDeskPanel.BottomHeight;
        LeftWidth    := FDeskPanel.LeftWidth;
        RightWidth   := FDeskPanel.RightWidth;
        PM.X := 2;
        PM.Y := 6;
      end;
   else begin
          w := Max(IconBitmap.Width,FontBitmap.Width);
          h := IconBitmap.Height + FontBitmap.Height;
          TopHeight    := 4;
          BottomHeight := 4;
          LeftWidth    := 4;
          RightWidth   := 4;
        end;
  end;
  w := w + LeftWidth + RightWidth;
  h := h + TopHeight + BottomHeight + FSettings.IconSpacingValue;   }

  if FSettings.DisplayMeter then
    case FSettings.MeterAlign of
     0 : IconBitmap.Draw(Max(FSettings.MLeftOffset,0),Max(FSettings.MTopOffset,0),FMeterBmp);
     1 : IconBitmap.Draw(Max(FSettings.MLeftOffset,0),Max(FSettings.MTopOffset,0),FMeterBmp);
     2 : IconBitmap.Draw(0 + Max(Fsettings.MLeftOffset,0),IconBitmap.Height - FMeterBmp.Height + Min(FSettings.MBottomOffset,0),FMeterBmp);
     3 : IconBitmap.Draw(IconBitmap.Width-FMeterBmp.Width + Min(Fsettings.MRightOffset,0) ,0 + Max(FSettings.MTopOffset,0),FMeterBmp);
    end;
  { case FSettings.MeterAlign of
     0 : IconBitmap.Draw(IconBitmap.Width div 2+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
     1 : IconBitmap.Draw(IconBitmap.Width div 2+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
     2 : IconBitmap.Draw(IconBitmap.Width div 2+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset+IconBitmap.Height-10,FMeterBmp);
     3 : IconBitmap.Draw(IconBitmap.Width div 2+FSettings.MLeftOffset + IconBitmap.Width-10,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
    end; }

  //Decide size
 // FIconSettings.Xoffset := 0;
 // FIconSettings.Yoffset := 0;
  TempBitmap := TBitmap32.Create;
  cialign := SharpDeskApi.RenderIconCaptionAligned(TempBitmap,IconBitmap,FontBitmap,FCaptionSettings.Align,Point(ix,iy),Point(FCaptionSettings.Xoffset,FCaptionSettings.Yoffset),FIconSettings.Shadow,FFontSettings.Shadow);
  TempBitmap.DrawMode := dmBlend;
  TempBitmap.CombineMode := cmMerge;

  case FSettings.BGType of
   1: begin
        w := TempBitmap.Width + FSettings.BGThicknessValue + 2;
        h := TempBitmap.Height + FSettings.BGThicknessValue + 2;
        Bitmap.SetSize(w,h);
        Bitmap.Clear(color32(0,0,0,0));
        Bitmap.FillRectS(Bitmap.Canvas.ClipRect,color32(GetRValue(FSettings.BGBorderColor),
                                                        GetGValue(FSettings.BGBorderColor),
                                                        GetBValue(FSettings.BGBorderColor),
                                                        FSettings.BGTransValue));
        Bitmap.FillRectS(Rect(FSettings.BGThicknessValue,
                              FSettings.BGThicknessValue,
                              Bitmap.Width-FSettings.BGThicknessValue,
                              Bitmap.Height-FSettings.BGThicknessValue),
                              color32(GetRValue(FSettings.BGColor),
                                      GetGValue(FSettings.BGColor),
                                      GetBValue(FSettings.BGColor),
                                      FSettings.BGTransValue));
        Bitmap.Draw(FSettings.BGThicknessValue + 1,FSettings.BGThicknessValue + 1,TempBitmap);
      end;
   2: begin
        FDeskPanel.SetCenterSize(TempBitmap.Width,TempBitmap.Height);
        FDeskPanel.Paint;
        if FSettings.BGTHBlend then
           SharpDeskApi.BlendImage(FDeskPanel.Bitmap,FSettings.BGTHBlendColor);
        if FSettings.BGTrans then
           FDeskPanel.Bitmap.MasterAlpha := FSettings.BGTransValue
           else FDeskPanel.Bitmap.MasterAlpha := 255;
        FDeskPanel.Bitmap.DrawMode := dmBlend;
        Bitmap.SetSize(FDeskPanel.Width,FDeskPanel.Height);
        Bitmap.Clear(color32(0,0,0,0));        
        Bitmap.Draw(0,0,FDeskPanel.Bitmap);
        Bitmap.Draw(FDeskPanel.TopHeight,FDeskPanel.LeftWidth,TempBitmap);
      end;
   else
   begin
     Bitmap.SetSize(TempBitmap.Width,TempBitmap.Height);
     Bitmap.Clear(color32(0,0,0,0));
     Bitmap.Draw(0,0,TempBitmap);
   end;
  end;
  //IconBitmap.Draw(round(FIconSettings.Xoffset),
  //                round(FIconSettings.Yoffset+(FIconSettings.Icon.Height*(FIconSettings.Size/100))-LetterBitmap.Height+FCaptionSettings.Yoffset),
  //                LetterBitmap);
  Bitmap.Draw(round(cialign.IconLeft + FIconSettings.Xoffset),
                    cialign.IconTop + round(FIconSettings.Yoffset+(FIconSettings.Icon.Height*(FIconSettings.Size/100))-LetterBitmap.Height+FCaptionSettings.Yoffset),
                    LetterBitmap);

  FIconSettings.Xoffset := ix;
  FIconSettings.Yoffset := iy;

  //Bitmap.SetSize(TempBitmap.Width,TempBitmap.Height);
  //Bitmap.Clear(color32(0,0,0,0));
  //TempBitmap.DrawTo(Bitmap);
  //Bitmap.Assign(IconBitmap);
//  changed;
//  FParentImage.EndUpdate;
//  exit;


{  Bitmap.SetSize(w,h);
  Bitmap.Clear(color32(0,0,0,0));

  //Draw image centered
  case FSettings.BGType of
   1 : begin
         Bitmap.FillRectS(Bitmap.Canvas.ClipRect,color32(GetRValue(FSettings.BGBorderColor),
                                                         GetGValue(FSettings.BGBorderColor),
                                                         GetBValue(FSettings.BGBorderColor),
                                                         FSettings.BGTransValue));
         Bitmap.FillRectS(Rect(FSettings.BGThicknessValue,
                               FSettings.BGThicknessValue,
                               Bitmap.Width-FSettings.BGThicknessValue,
                               Bitmap.Height-FSettings.BGThicknessValue),
                               color32(GetRValue(FSettings.BGColor),
                                       GetGValue(FSettings.BGColor),
                                       GetBValue(FSettings.BGColor),
                                       FSettings.BGTransValue));
       end;
   2 : begin
         Bitmap.Draw(0,0,FDeskPanel.Bitmap);
       end;
   else Bitmap.Clear(color32(0,0,0,0));
  end;

  IconBitmap.DrawMode := dmBlend;
  IconBitmap.CombineMode := cmMerge;
  FontBitmap.DrawMode := dmBlend;
  FontBitmap.CombineMode := cmMerge;
  if FSettings.DriveLetter then
  begin
    LetterBitmap.DrawMode := dmBlend;
    LetterBitmap.CombineMode := cmMerge;
  end;
  Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X + FSettings.IconOffsetValue, TopHeight + PM.Y,IconBitmap);
  if FSettings.DisplayMeter then
    case FSettings.MeterAlign of
     0 : Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
     1 : Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
     2 : Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X+FSettings.MLeftOffset,TopHeight+PM.Y+FSettings.MTopOffset+IconBitmap.Height-10,FMeterBmp);
     3 : Bitmap.Draw(w div 2 - IconBitmap.Width div 2+PM.X+FSettings.MLeftOffset + IconBitmap.Width-10,TopHeight+PM.Y+FSettings.MTopOffset,FMeterBmp);
    end;
  Bitmap.DrawMode := dmBlend;

  if (FSettings.ShowCaption) or (FSettings.DiskData) then
     Bitmap.Draw(w div 2 - FontBitmap.Width div 2+PM.X,TopHeight+PM.Y+IconBitmap.Height+FSettings.IconSpacingValue,FontBitmap);
  if FSettings.DriveLetter then
     Bitmap.Draw(Max(0,w div 2 - IconBitmap.Width div 2+PM.X-LetterBitmap.Width div 2)
                 +4
                 +FSettings.IconOffsetValue
                 +MM.X,
                 
                 TopHeight
                 +PM.Y
                 +IconBitmap.Height
                 +MM.Y
                 -LetterBitmap.Height
                 +FSettings.IconSpacingValue,LetterBitmap);
 }
  //Set the right size of the layer
  if FLocked then
  begin
    w := (Bitmap.Width*FScale) div 100;
    h := (Bitmap.Height*FScale) div 100;
    TDraftResampler.Create(Bitmap);
  end else
  begin
    w := Bitmap.Width;
    h := Bitmap.Height;
  end;
//  Bitmap.StretchFilter := sfLinear;
  R := getadjustedlocation;
  if (w <> (R.Right-R.left)) then   //dont move image if resize
    R.Left := R.left + round(((R.Right-R.left)- w)/2);
  if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
    R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
  R.Right := r.Left + w;
  R.Bottom := r.Top + h;
  location := R;

  FontBitmap.Free;
  IconBitmap.Free;
  TempBitmap.Free;
//  if FSettings.DriveLetter then
  LetterBitmap.Free;
  //Seems like it must be said sometimes
  Bitmap.DrawMode := dmBlend;

  FParentImage.EndUpdate;
  EndUpdate;
  changed;
end;



procedure TDriveLayer.LoadDefaultImage;
begin
     FIconType := 0;
     FPicture.SetSize(100,100);
     FPicture.Clear(color32(128,128,128,128));
end;

procedure TDriveLayer.doLoadImage(IconFile: string);
var
   FileExt : String;
   b : boolean;
begin
  b := False;
  if IsRootDirectory(IconFile) and (FIconType=1) then
  begin
    b:=extrShellIcon(FPicture,IconFile);
    if b then exit;
  end else
  begin
    if (FIconType=1) and (FileExists(IconFile)) then
    begin
      b:=extrIcon(FPicture,IconFile);
      if b then exit;
    end;
  end;

  if FileExists(IconFile) = True then
  begin
    FIconType := 0;
    FileExt := ExtractFileExt(IconFile);
    if (lowercase(FileExt) = '.ico') then
    begin
      FIconType := 1;
      b:=loadIco(FPicture,IconFile,strtoint(FSettings.Size))
    end
    else if (lowercase(FileExt) = '.png') then
    begin
      FIconType := 1;
      b:=loadPng(FPicture,IconFile)
    end
    else if (lowercase(FileExt) = '.exe') then b:=extrIcon(FPicture,IconFile)
         else b:=extrShellIcon(FPicture,IconFile);
  end;
  if not b then LoadDefaultImage;
end;



procedure TDriveLayer.LoadSettings;
var
   i : integer;
   alphablend : integer;
   IconList : TStringList;
   p : PChar;
   Bmp : TBitmap32;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;
  if length(FSettings.Target)>1 then FSettings.Target := FSettings.Target[1];

 if (FSettings.CustomFont) and not(Fsettings.UseThemeSettings) then
  begin
    FFontSettings.Name      := FSettings.FontName;
    FFontSettings.Size      := FSettings.FontSize;
    FFontSettings.Color     := CodeToColorEx(FSettings.FontColor,FDeskSettings.Theme.Scheme);
    FFontSettings.Bold      := FSettings.FontBold;
    FFontSettings.Italic    := FSettings.FontItalic;
    FFontSettings.Underline := FSettings.FontUnderline;
    FFontSettings.AALevel   := 0;
    if FSettings.FontAlpha then FFontSettings.Alpha := FSettings.FontAlphaValue
       else FFontSettings.Alpha := 255;
    FFontSettings.ShadowColor := CodeToColorEx(FSettings.FontShadowColor,FDeskSettings.Theme.Scheme);
    FFontSettings.ShadowAlphaValue := FSettings.FontShadowValue;
    FFontSettings.Shadow    := FSettings.FontShadow;
    FFontSettings.ShadowAlpha := True;
  end else
  begin
    FFontSettings.Name      := FDeskSettings.Theme.TextFont.Name;
    FFontSettings.Color     := CodeToColorEx(FDeskSettings.Theme.TextFont.Color,FDeskSettings.Theme.Scheme);
    FFontSettings.Bold      := fsBold in FDeskSettings.Theme.TextFont.Style;
    FFontSettings.Italic    := fsItalic in FDeskSettings.Theme.TextFont.Style;
    FFontSettings.Underline := fsUnderline in FDeskSettings.Theme.TextFont.Style;
    FFontSettings.AALevel   := 0;
    if FDeskSettings.Theme.DeskFontAlpha then FFontSettings.Alpha := FDeskSettings.Theme.DeskFontAlphaValue
       else FFontSettings.Alpha := 255;
    FFontSettings.Size      := FDeskSettings.Theme.TextFont.Size;
    FFontSettings.ShadowColor := CodeToColorEx(FDeskSettings.Theme.ShadowColor,FDeskSettings.Theme.Scheme);
    FFontSettings.ShadowAlphaValue := FDeskSettings.Theme.ShadowAlpha;
    FFontSettings.ShadowAlpha := True;
    if FSettings.UseThemeSettings then FFontSettings.Shadow := FDeskSettings.Theme.DeskTextShadow
       else FFontSettings.Shadow := FSettings.Shadow;
  end;


  FCaptionSettings.Caption.Clear;
  if FSettings.MLineCaption then FCaptionSettings.Caption.CommaText := FSettings.Caption
     else FCaptionSettings.Caption.Add(FSettings.Caption);
  FCaptionSettings.Align := IntToTextAlign(FSettings.CaptionAlign);
  FCaptionSettings.Xoffset := 0;
  FCaptionSettings.Yoffset := 0;
  if FSettings.IconSpacing then
     if (FCaptionSettings.Align = taLeft) or (FCaptionSettings.Align = taRight) then
         FCaptionSettings.Xoffset := FSettings.IconSpacingValue
     else FCaptionSettings.Yoffset := FSettings.IconSpacingValue;

  if FSettings.UseThemeSettings then FCaptionSettings.Draw := FDeskSettings.Theme.DeskDisplayCaption
     else FCaptionSettings.Draw := FSettings.ShowCaption;
  FCaptionSettings.LineSpace := 0;

  FIconSettings.Size  := 100;
  FIconSettings.Alpha := 255;
  FIconSettings.ShadowColor := CodeToColorEx(FDeskSettings.Theme.DeskIconShadowColor,FDeskSettings.Theme.Scheme);
  FIconSettings.ShadowAlpha := FDeskSettings.Theme.DeskIconShadow;
  FIconSettings.XOffset     := 0;
  FIconSettings.YOffset     := 0;
  if FSettings.IconOffset then FIconSettings.XOffset := FSettings.IconOffsetValue;;
  if FSettings.UseThemeSettings then
  begin
    FSettings.AlphaBlend      := FDeskSettings.Theme.DeskUseAlphaBlend;
    FSettings.AlphaValue      := FDeskSettings.Theme.DeskAlphaBlend;
    FIconSettings.Blend       := FDeskSettings.Theme.DeskUseColorBlend;
    FIconSettings.BlendColor  := CodeToColorEx(FDeskSettings.Theme.DeskColorBlendColor,FDeskSettings.Theme.Scheme);
    FIconSettings.BlendValue  := FDeskSettings.Theme.DeskColorBlend;
    FIconSettings.Shadow      := FDeskSettings.Theme.DeskUseIconShadow;
  end else
  begin
    FIconSettings.Blend       := FSettings.ColorBlend; 
    FIconSettings.BlendColor  := CodeToColorEx(FSettings.BlendColor,FDeskSettings.Theme.Scheme);
    FIconSettings.BlendValue  := FSettings.BlendValue;
    FIconSettings.Shadow      := FSettings.UseIconShadow;
  end;

  if length(FSettings.Size)=0 then FSettings.Size:='48';

  SharpDeskApi.LoadIcon(FIconSettings.Icon,FSettings.IconFile,FSettings.Target,FDeskSettings.Theme.IconSet,strtoint(FSettings.size));

  FShadowAlpha   := FDeskSettings.Theme.ShadowAlpha;
  FShadowColor   := FDeskSettings.Theme.ShadowColor;
  CodeToColorEx(FShadowColor,FDeskSettings.Theme.Scheme);

  if not FSettings.BGThickness then
     FSettings.BGThicknessValue := 0;

  if not FSettings.BGTrans then
     FSettings.BGTransValue := 255;

  if not FSettings.IconSpacing then
     FSettings.IconSpacingValue := 0;

  if not FSettings.IconOffset then
     FSettings.IconOffsetValue := 0;

  if FSettings.UseThemeSettings then
  begin
    FSettings.AlphaValue    := FDeskSettings.Theme.DeskAlphaBlend;
    FSettings.AlphaBlend    := FDeskSettings.Theme.DeskUseAlphaBlend;
    FSettings.ColorBlend    := FDeskSettings.Theme.DeskUseColorBlend;
    FSettings.BlendColor    := FDeskSettings.Theme.DeskColorBlendColor;
    FSettings.BlendValue    := FDeskSettings.Theme.DeskColorBlend;
    FSettings.UseIconShadow := FDeskSettings.Theme.DeskUseIconShadow;
    FSettings.Shadow        := FDeskSettings.Theme.DeskTextShadow;
    FSettings.ShowCaption   := FDeskSettings.Theme.DeskDisplayCaption;
  end;

  if length(FSettings.Size)=0 then FSettings.Size:='48';
  FIconShadowColor := FDeskSettings.Theme.DeskIconShadowColor;
  FIconShadow  := FDeskSettings.Theme.DeskIconShadow;
  CodeToColorEx(FIconShadowColor,FDeskSettings.Theme.Scheme);

  if FSettings.UseThemeSettings then
  begin
    if not FDeskSettings.Theme.DeskUseIconShadow then FIconShadow := 255;
  end else if FSettings.UseIconShadow = False then FIconShadow := 255;
  FIconType    := 0;
  if (FSettings.IconFile='-2') then
  begin
    {Shell Icon}
    FIconType := 1;
    FSettings.IconFile := FSettings.Target;
    doLoadImage(FSettings.IconFile+':\');
  end else
  {Custom Icon}
  if FileExists(FSettings.IconFile) then doLoadImage(FSettings.IconFile)
  else
  begin
    {SharpE Icon}
    IconList := TStringList.Create;
    try
      p := GetIconList(FDeskSettings.Theme.IconSet);
      IconList.CommaText := p;
      releasebuffer(p);
    except
    releasebuffer(p);
    IconList.Clear;
    end;
    i := IconList.IndexOfName(FSettings.IconFile);
    if (i<>-1) and (i<=IconList.Count-1) then
    begin
      if FileExists(ExtractFilePath(Application.ExeName)+'Icons\'+FDeskSettings.Theme.IconSet+'\'+IconList.Values[IconList.Names[i]]) then
         FSettings.IconFile := ExtractFilePath(Application.ExeName)+'Icons\'+FDeskSettings.Theme.IconSet+'\'+IconList.Values[IconList.Names[i]]
    end else if IconList.Count>0 then FSettings.IconFile := ExtractFilePath(Application.ExeName)+'Icons\'+FDeskSettings.Theme.IconSet+'\'+IconList.Values[IconList.Names[0]];
    IconList.Free;
    DoLoadImage(FSettings.IconFile);
  end;

  if FSettings.AlphaBlend then
  begin
    Bitmap.MasterAlpha := FSettings.AlphaValue;
    if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
  end else Bitmap.MasterAlpha := 255;

  Bitmap.Font.Name := FDeskSettings.Theme.TextFont.Name;
  Bitmap.Font.Size := FDeskSettings.Theme.TextFont.Size;
  Bitmap.Font.Style := FDeskSettings.Theme.TextFont.Style;
  Bitmap.Font.Color := FDeskSettings.Theme.TextFont.Color;
  FShadowColor := FDeskSettings.Theme.ShadowColor;
  FShadowAlpha := FDeskSettings.Theme.ShadowAlpha;

  if FSettings.BGType = 2 then
     FDeskPanel.LoadPanel(FSettings.BGSkin);

  { Bmp := TBitmap32.Create;
  Bmp.Assign(FPicture);
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
  FPicture.SetSize(Bmp.Width+4,Bmp.Height+4);
  FPicture.Clear(color32(0,0,0,0));
  Bmp.DrawTo(FPicture);
  Bmp.Free;  }

  if GetDiskIn(FSettings.Target[1]) then
  begin
    FDiskMax   := GetDiskCapacity(FSettings.Target[1]);
    FDiskFull  := FDiskMax-GetDiskFree(FSettings.Target[1]);
  end else
  begin
    FDiskMax := 1;
    FDiskFull := 1;
  end;

  FDriveType := TDriveType(GetDriveType(PChar(FSettings.Target + ':\')));
  if (FDriveType = dtFloppy) or (FDriveType = dtCDRom) then
     FSettings.DisplayMeter := False;

  FCs := LoadColorScheme;
  if FSettings.ColorBlend then BlendImage(FPicture,FSettings.BlendColor,FSettings.BlendValue);
  if (FSettings.UseIconShadow) and (FIconShadow<255) and (FIconType=1) then CreateIconShadow;
//  if FSettings.DisplayMeter and (FDriveType <> dtFloppy) then FUpdateTimer.Enabled:=True
//     else FUpdateTimer.Enabled := False;
  FUpdateTimer.Enabled := True;
  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);  
end;


constructor TDriveLayer.Create( ParentImage:Timage32; Id : integer;
                                 DeskSettings : TDeskSettings;
                                 ThemeSettings : TThemeSettings;
                                 ObjectSettings : TObjectSettings);
begin
  Inherited Create(ParentImage.Layers);
  FDeskSettings   := DeskSettings;
  FThemeSettings  := ThemeSettings;
  FObjectSettings := ObjectSettings;
  FParentImage := ParentImage;
  FPicture := TBitmap32.Create;
  FMeterBmp := TBitmap32.Create;
  FDeskPanel := TDesktopPanel.Create;
  Alphahit := False;
  FObjectId := id;
  FScale     := 100;
  scaled := false;
  FSettings := TXMLSettings.Create(FObjectID, nil);
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled  := False;  
  FHLTimer.OnTimer  := OnTimer;
  FAnimSteps        := 5;
  FUpdateTimer := TTImer.Create(nil);
  FUpdateTimer.Interval := 1000*30;
  FUpdateTimer.Enabled  := False;
  FUpdateTimer.OnTimer  := OnUpdateTimer;
  FCaptionSettings.Caption := TStringList.Create;
  FCaptionSettings.Caption.Clear;
  FIconSettings.Icon := TBitmap32.Create;   
  LoadSettings;
end;

destructor TDriveLayer.Destroy;
begin
  DebugFree(FSettings);
  DebugFree(FPicture);
  DebugFree(FDeskPanel);
  DebugFree(FCaptionSettings.Caption);
  DebugFree(FIconSettings.Icon);  
  FHLTimer.Enabled := False;
  DebugFree(FHLTimer);
  DebugFree(FMeterBmp);
  FUpdateTimer.Enabled := False;
  DebugFree(FUpdateTimer);
  inherited Destroy;
end;

end.
