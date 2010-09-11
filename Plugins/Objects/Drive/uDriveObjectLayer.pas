{
Source Name: DriveLayer
Description: Drive desktop object layer class
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

unit uDriveObjectLayer;

interface
uses
  Windows, Types, StdCtrls, Forms,Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils,ShellApi, Graphics,
  gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters, GR32_Backends,
  JclSimpleXML, SharpDeskApi, JclFileUtils, JclShell,
  SharpThemeApiEx,
  SharpGraphicsUtils,
  SharpIconUtils,
  DriveObjectXMLSettings,
  uSharpDeskDebugging,
  uSharpDeskTDeskSettings,
  uSharpDeskFunctions,
  uSharpDeskDesktopPanel,
  uSharpDeskObjectSettings,
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
     constructor Create( ParentImage:Timage32; Id : integer); reintroduce;
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
  if GetCurrentTheme.Desktop.Animation.UseAnimations then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    LightenBitmap(Bitmap,50);
  end;
end;

procedure TDriveLayer.EndHL;
begin
//if FHLTimer.Enabled then exit;
  if GetCurrentTheme.Desktop.Animation.UseAnimations then
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
    if FSettings.Theme[DS_ICONALPHABLEND].BoolValue then
       i := FSettings.Theme[DS_ICONALPHA].IntValue
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

  if GetCurrentTheme.Desktop.Animation.Alpha then
  begin
    if FSettings.Theme[DS_ICONALPHABLEND].BoolValue then
       i := FSettings.Theme[DS_ICONALPHA].IntValue
       else i := 255;
    i := i + round(((GetCurrentTheme.Desktop.Animation.AlphaValue/FAnimSteps)*FHLTimer.Tag));
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

  if GetCurrentTheme.Desktop.Animation.Brightness then
     LightenBitmap(Bitmap,round(FHLTimer.Tag*(GetCurrentTheme.Desktop.Animation.BrightnessValue/FAnimSteps)));
  if GetCurrentTheme.Desktop.Animation.Blend then
     BlendImageA(Bitmap,GetCurrentTheme.Desktop.Animation.BlendColor,round(FHLTimer.Tag*(GetCurrentTheme.Desktop.Animation.BlendValue/FAnimSteps)));

  FParentImage.EndUpdate;

  EndUpdate;
  Changed;
end;


procedure TDriveLayer.DoubleClick;
begin
  SharpExecute(FSettings.Target + ':\');
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
  w : integer;
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

   SpaceFree : integer;
   SpacePrefix : string;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

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
  end else
    SharpDeskApi.RenderIcon(IconBitmap,FIconSettings,point(0,0));
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
  IconBitmap.DrawMode := dmBlend;
  IconBitmap.CombineMode := cmMerge;

  LetterBitmap := TBitmap32.Create;
  if FSettings.DriveLetter then
  begin
    with LetterBitmap do
    begin
      LetterBitmap.DrawMode := dmBlend;
      LetterBitmap.CombineMode := cmMerge;
      if FSettings.DLAlpha then
        MasterAlpha := FSettings.DLAlphaValue
      else
        MasterAlpha := 255;
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

    if FSettings.DiskData then
    begin
      SpaceFree := FDiskMax - FDiskFull;

      if SpaceFree >= (1024 * 1024) then
      begin
        SpaceFree := SpaceFree div (1024 * 1024);
        SpacePrefix := 'TB';
      end else if SpaceFree > (1024) then
      begin
        SpaceFree := SpaceFree div (1024);
        SpacePrefix := 'GB';
      end else
      begin
        SpacePrefix := 'MB';
      end;

      FCaptionSettings.Caption.Add(inttostr(SpaceFree) + ' ' + SpacePrefix + ' Free');
    end;

    SharpDeskApi.RenderText(FontBitmap,FFontSettings,FCaptionSettings.Caption,FCaptionSettings.Align,0);

  end else
  begin
    FontBitmap := TBitmap32.Create;
    FontBitmap.Font := Bitmap.Font;
    FontBitmap.SetSize(0,0);
  end;

  if FSettings.DisplayMeter then
    case FSettings.MeterAlign of
     0 : IconBitmap.Draw(Max(FSettings.MLeftOffset,0),Max(FSettings.MTopOffset,0),FMeterBmp);
     1 : IconBitmap.Draw(Max(FSettings.MLeftOffset,0),Max(FSettings.MTopOffset,0),FMeterBmp);
     2 : IconBitmap.Draw(0 + Max(Fsettings.MLeftOffset,0),IconBitmap.Height - FMeterBmp.Height + Min(FSettings.MBottomOffset,0),FMeterBmp);
     3 : IconBitmap.Draw(IconBitmap.Width-FMeterBmp.Width + Min(Fsettings.MRightOffset,0) ,0 + Max(FSettings.MTopOffset,0),FMeterBmp);
    end;

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
           BlendImageA(FDeskPanel.Bitmap, FSettings.BGTHBlendColor, 255);
        if FSettings.BGTrans then
           FDeskPanel.Bitmap.MasterAlpha := FSettings.BGTransValue
        else
          FDeskPanel.Bitmap.MasterAlpha := 255;

        FDeskPanel.Bitmap.DrawMode := dmBlend;
        FDeskPanel.Bitmap.CombineMode := cmMerge;
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

  Bitmap.Draw(round(cialign.IconLeft + FIconSettings.Xoffset),
                    cialign.IconTop + round(FIconSettings.Yoffset+(FIconSettings.Icon.Height*(FIconSettings.Size/100))-LetterBitmap.Height+FCaptionSettings.Yoffset),
                    LetterBitmap);

  FIconSettings.Xoffset := ix;
  FIconSettings.Yoffset := iy;

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
   b : integer;
begin
  b := 0;
  if (FIconType = 1) and IsRootDirectory(IconFile) then
  begin
    b := extrShellIcon(FPicture,IconFile);
    if (b <> 0) then
      exit;
  end else
  begin
    if (FIconType = 1) and (FileExists(IconFile)) then
    begin
      b := integer(LoadIco(FPicture, IconFile, 64));
      if (b <> 0) then
        exit;
    end;
  end;

  if FileExists(IconFile) = True then
  begin
    FIconType := 0;
    FileExt := ExtractFileExt(IconFile);
    if (lowercase(FileExt) = '.ico') then
    begin
      FIconType := 1;
      b := integer(loadIco(FPicture, IconFile, strtoint(FSettings.Size)))
    end
    else if (lowercase(FileExt) = '.png') then
    begin
      FIconType := 1;
      b := integer(loadPng(FPicture,IconFile))
    end
    else if (lowercase(FileExt) = '.exe') then
      b := integer(loadIco(FPicture, IconFile, 64))
    else
      b := integer(extrShellIcon(FPicture,IconFile));
  end;
  
  if b = 0 then
    LoadDefaultImage;
end;



procedure TDriveLayer.LoadSettings;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;
  if length(FSettings.Target)>1 then FSettings.Target := FSettings.Target[1];

 if (FSettings.CustomFont) and not(Fsettings.UseThemeSettings) then
  begin
    FFontSettings.Name      := FSettings.FontName;
    FFontSettings.Size      := FSettings.FontSize;
    FFontSettings.Color     := FSettings.FontColor;
    FFontSettings.Bold      := FSettings.FontBold;
    FFontSettings.Italic    := FSettings.FontItalic;
    FFontSettings.Underline := FSettings.FontUnderline;
    FFontSettings.AALevel   := 0;
    if FSettings.FontAlpha then FFontSettings.Alpha := FSettings.FontAlphaValue
       else FFontSettings.Alpha := 255;
    FFontSettings.ShadowColor := FSettings.FontShadowColor;
    FFontSettings.ShadowAlphaValue := FSettings.FontShadowValue;
    FFontSettings.Shadow    := FSettings.FontShadow;
  end else
  begin
    FFontSettings.Name      := GetCurrentTheme.Desktop.Icon.FontName;
    FFontSettings.Color     := GetCurrentTheme.Desktop.Icon.TextColor;
    FFontSettings.Bold      := GetCurrentTheme.Desktop.Icon.TextBold;
    FFontSettings.Italic    := GetCurrentTheme.Desktop.Icon.TextItalic;
    FFontSettings.Underline := GetCurrentTheme.Desktop.Icon.TextUnderline;
    FFontSettings.AALevel   := 0;
    if GetCurrentTheme.Desktop.Icon.TextAlpha then
      FFontSettings.Alpha := GetCurrentTheme.Desktop.Icon.TextAlphaValue
    else
      FFontSettings.Alpha := 255;

    FFontSettings.Size      := GetCurrentTheme.Desktop.Icon.TextSize;
    FFontSettings.ShadowColor := GetCurrentTheme.Desktop.Icon.TextShadowColor;
    FFontSettings.ShadowAlphaValue := GetCurrentTheme.Desktop.Icon.TextShadowAlpha;
    if FSettings.UseThemeSettings then
      FFontSettings.Shadow := GetCurrentTheme.Desktop.Icon.TextShadow
    else
      FFontSettings.Shadow := FSettings.Shadow;
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

  if FSettings.UseThemeSettings then
    FCaptionSettings.Draw := GetCurrentTheme.Desktop.Icon.DisplayText
  else
    FCaptionSettings.Draw := FSettings.ShowCaption;
  FCaptionSettings.LineSpace := 0;

  FIconSettings.Size  := 100;
  FIconSettings.Alpha := 255;
  FIconSettings.ShadowColor := GetCurrentTheme.Desktop.Icon.TextShadowColor;
  FIconSettings.ShadowAlpha := GetCurrentTheme.Desktop.Icon.TextShadowAlpha;
  FIconSettings.XOffset     := 0;
  FIconSettings.YOffset     := 0;
  if FSettings.IconOffset then FIconSettings.XOffset := FSettings.IconOffsetValue;;
  if FSettings.UseThemeSettings then
  begin
    FSettings.AlphaBlend      := GetCurrentTheme.Desktop.Icon.IconAlphaBlend;
    FSettings.AlphaValue      := GetCurrentTheme.Desktop.Icon.IconAlpha;
    FIconSettings.Blend       := GetCurrentTheme.Desktop.Icon.IconBlending;
    FIconSettings.BlendColor  := GetCurrentTheme.Desktop.Icon.IconBlendColor;
    FIconSettings.BlendValue  := GetCurrentTheme.Desktop.Icon.IconBlendAlpha;
    FIconSettings.Shadow      := GetCurrentTheme.Desktop.Icon.IconShadow;
  end else
  begin
    FIconSettings.Blend       := FSettings.ColorBlend; 
    FIconSettings.BlendColor  := FSettings.BlendColor;
    FIconSettings.BlendValue  := FSettings.BlendValue;
    FIconSettings.Shadow      := FSettings.UseIconShadow;
  end;

  if length(FSettings.Size)=0 then FSettings.Size:='48';

  IconStringToIcon(FSettings.IconFile, FSettings.Target, FIconSettings.Icon);

  FShadowAlpha   := GetCurrentTheme.Desktop.Icon.IconShadowAlpha;
  FShadowColor   := GetCurrentTheme.Desktop.Icon.IconShadowColor;

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
    FSettings.AlphaValue    := GetCurrentTheme.Desktop.Icon.IconAlpha;
    FSettings.AlphaBlend    := GetCurrentTheme.Desktop.Icon.IconAlphaBlend;
    FSettings.ColorBlend    := GetCurrentTheme.Desktop.Icon.IconBlending;
    FSettings.BlendColor    := GetCurrentTheme.Desktop.Icon.IconBlendColor;
    FSettings.BlendValue    := GetCurrentTheme.Desktop.Icon.IconBlendAlpha;
    FSettings.UseIconShadow := GetCurrentTheme.Desktop.Icon.IconShadow;
    FSettings.Shadow        := GetCurrentTheme.Desktop.Icon.IconShadow;
    FSettings.ShowCaption   := GetCurrentTheme.Desktop.Icon.DisplayText;
  end;

  if length(FSettings.Size) = 0 then
    FSettings.Size := '48';
  FIconShadowColor := GetCurrentTheme.Desktop.Icon.IconShadowColor;
  FIconShadow  := GetCurrentTheme.Desktop.Icon.IconShadowAlpha;

  if FSettings.UseThemeSettings then
  begin
    if not GetCurrentTheme.Desktop.Icon.IconShadow then
      FIconShadow := 255;
  end else if FSettings.UseIconShadow = False then
    FIconShadow := 255;
    
  FIconType := 0;
  if (FSettings.IconFile = '-2') then
  begin
    {Shell Icon}
    FIconType := 1;
    FSettings.IconFile := FSettings.Target;
    doLoadImage(FSettings.IconFile+':\');
  end else
  {Custom Icon}
  if FileExists(FSettings.IconFile) then
    doLoadImage(FSettings.IconFile)
  else
  begin
    {SharpE Icon}
    IconStringToIcon(FSettings.IconFile, FSettings.Target, FPicture);
  end;

  if FSettings.AlphaBlend then
  begin
    Bitmap.MasterAlpha := FSettings.AlphaValue;
    if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
  end else Bitmap.MasterAlpha := 255;

  Bitmap.Font.Name := GetCurrentTheme.Desktop.Icon.FontName;
  Bitmap.Font.Size := GetCurrentTheme.Desktop.Icon.TextSize;

  if GetCurrentTheme.Desktop.Icon.TextBold then
    Bitmap.Font.Style := Bitmap.Font.Style + [fsBold];
  if GetCurrentTheme.Desktop.Icon.TextItalic then
    Bitmap.Font.Style := Bitmap.Font.Style + [fsItalic];
  if GetCurrentTheme.Desktop.Icon.TextUnderline then
    Bitmap.Font.Style := Bitmap.Font.Style + [fsUnderline];

  Bitmap.Font.Color := GetCurrentTheme.Desktop.Icon.TextColor;
  FShadowColor := GetCurrentTheme.Desktop.Icon.IconShadowColor;
  FShadowAlpha := GetCurrentTheme.Desktop.Icon.IconShadowAlpha;

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

  if FSettings.ColorBlend then
    BlendImageA(FPicture, FSettings.BlendColor, FSettings.BlendValue);

  if (FSettings.UseIconShadow) and (FIconShadow < 255) and (FIconType = 1) then
    CreateIconShadow;

  FUpdateTimer.Enabled := True;
  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);  
end;


constructor TDriveLayer.Create( ParentImage:Timage32; Id : integer);
begin
  Inherited Create(ParentImage.Layers);
  FParentImage := ParentImage;
  FPicture := TBitmap32.Create;
  FMeterBmp := TBitmap32.Create;
  FDeskPanel := TDesktopPanel.Create;
  Alphahit := False;
  FObjectId := id;
  FScale     := 100;
  scaled := false;
  FSettings := TXMLSettings.Create(FObjectId,nil,'Drive');
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
