{
Source Name: uClockObjectLayer.pas
Description: Clock desktop object layer
Copyright (C) Delusional <Delusional@Lowdimension.net>
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpE-shell.net

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

unit uClockObjectLayer;

interface
uses
  Windows, StdCtrls, Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils, ShellApi, Graphics,
  gr32,
  pngimage,
  GR32_Image,
  GR32_Layers,
  GR32_BLEND,
  GR32_Transforms,
  GR32_Filters,
  GR32_Resamplers,
  DateUtils, Forms,
  uSharpDeskDebugging,
  uSharpDeskTDeskSettings,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskSharpETheme,
  ClockObjectSettingsWnd,
  SharpDeskApi, GR32_PNG, JvSimpleXML;

type
  TColorRec = packed record
                 b,g,r,a: Byte;
               end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

  TClockLayer = class(TBitmapLayer)
  private
    FDrawGlass   : boolean;
    FDrawSpecial : boolean;
    FShadow      : boolean;
    FLocked      : boolean;
    FSkinType    : boolean;
    FHighlight   : boolean;
    FLastHour    : integer;
    FLastMinute  : integer;
    FShadowAlpha : integer;
    FShadowColor : integer;
    FColor       : TColor;
    FObjectId    : integer;
    FParentImage : TImage32;
    FClockBack   : TBitmap32;
    FClockGlas   : TBitmap32;
    FHArrow      : TBitmap32;
    FMArrow      : TBitmap32;
    FPicture     : TBitmap32;
    FAnalogSkin  : String;
    FXML         : TJvSimpleXML;
    FDeskSettings   : TDeskSettings;
    FThemeSettings  : TThemeSettings;
    FObjectSettings : TObjectSettings;    

    fTimer : TTimer;
    strTime, strDate : string;

  protected
     procedure fTimer1TimerFirst(Sender: TObject);
     procedure fTimer1TimerNormal(Sender: TObject);
  public
     procedure DrawClock;
//     procedure createdropshadow(startx,starty,sAlpha:integer);  
     procedure DrawBitmap;
     procedure LoadSettings;
     constructor Create( ParentImage:Timage32; Id : integer;
                         DeskSettings : TDeskSettings;
                         ThemeSettings : TThemeSettings;
                         ObjectSettings : TObjectSettings); reintroduce;
     destructor Destroy; override;
     property ObjectId: Integer read FObjectId write FObjectId;
     property Highlight : boolean read FHighlight write FHighlight;
     property Locked : boolean read FLocked write FLocked;
  end;


var
  SettingsWnd : TSettingsWnd;

implementation


procedure RotateBitmap(Src,Dst : TBitmap32; Alpha: Single);
var
  SrcR: Integer;
  SrcB: Integer;
  T: TAffineTransformation;
  Sx, Sy, Scale: Single;
begin
  SrcR := Src.Width - 1;
  SrcB := Src.Height - 1;
  TKernelResampler.Create(Src).Kernel := TMitchellKernel.Create;
  T := TAffineTransformation.Create;
  T.SrcRect := FloatRect(0, 0, SrcR + 1, SrcB + 1);
  try
    T.Clear;

    T.Translate(-SrcR / 2, -SrcB / 2);
    T.Rotate(0, 0, Alpha);
    Alpha := Alpha * 3.14159265358979 / 180;

    Sx := Abs(SrcR * Cos(Alpha)) + Abs(SrcB * Sin(Alpha));
    Sy := Abs(SrcR * Sin(Alpha)) + Abs(SrcB * Cos(Alpha));

    scale := 1;

    T.Scale(Scale, Scale);

    T.Translate(SrcR / 2, SrcB / 2);

    Dst.BeginUpdate;
    Transform(Dst, Src, T);
    Dst.EndUpdate;
  finally
    T.Free;
  end;
end;

{procedure TClockLayer.createdropshadow(startx,starty,sAlpha:integer);
var
  P: PColor32;
  X,Y,alpha : integer;
     pass : Array of Array of integer;

begin
  with Bitmap do begin
    setlength(pass,width,height);

    P := PixelPtr[0, 0];
    inc(P,(starty-1)*width+startx);
    for Y := starty to Height - 1 do begin
         for X := startx to Width- 1 do begin
             alpha := (P^ shr 24);
             if (alpha <> 0) then
                pass[X,Y] := sAlpha
             else if (X>1) and (Y>1) then begin
                pass[X,Y] := round((pass[X-1,Y] + pass[X,Y-1])/2) - 20;
                if pass[X,Y] > sAlpha-1 then pass[X,Y] := sAlpha;
                if pass[X,Y] < 0 then pass[X,Y] := 0;
                P^ := color32(GetRValue(FShadowColor),GetGValue(FShadowColor),GetBValue(FShadowColor),pass[X,Y]);
             end;
           inc(P); // proceed to the next pixel
         end;
         inc(P,startx);
      end
  end;
end;            }

procedure TClockLayer.DrawClock;
var
   dir : String;
   b : boolean;
   Day,Month,Year : string;
   n : integer;
   FCaption : String;
   XMod,YMod : integer;
   AALevel : integer;
   FAlpha : integer;
   TempBmp : TBitmap32;
begin
     dir := ExtractFileDir(Application.ExeName)+'\Objects\Clock\watchfaces\'+FAnalogSkin+'\';
     if not FileExists(dir+'skin.xml') then
     begin
          FSkinType := False;
          exit;
     end;
     FXML.Free;
     FXML := TJvSimpleXML.Create(nil);
     FXML.LoadFromFile(dir+'skin.xml');

     FClockBack.DrawMode := dmBlend;
     FClockBack.CombineMode := cmMerge;
     FClockGlas.DrawMode := dmBlend;
     FClockGlas.CombineMode := cmMerge;
     FHArrow.DrawMode := dmBlend;
     FHArrow.CombineMode := cmMerge;
     FMArrow.DrawMode := dmBlend;
     FMArrow.CombineMode := cmMerge;

     LoadBitmap32FromPNG(FClockBack,dir+'watch_face.png',b);
     LoadBitmap32FromPNG(FClockGlas,dir+'watch_glass.png',b);
     LoadBitmap32FromPNG(FHArrow,dir+'hand_hour.png',b);
     LoadBitmap32FromPNG(FMArrow,dir+'hand_minute.png',b);

     FPicture.SetSize(FClockBack.Width,FClockBack.Height);
     FPicture.Clear(color32(0,0,0,0));

     FClockBack.DrawTo(FPicture);

     if FDrawSpecial then
     begin
          try
             Day := inttostr(DayOf(Now));
             if length(Day) = 1 then Day := '0'+Day;
             Month := inttostr(MonthOf(Now));
             if length(Month) = 1 then Month := '0'+Month;
             Year := inttostr(YearOf(Now));
             for n:=0 to FXML.Root.Items.ItemNamed['text'].Items.Count -1 do
                 with FXML.Root.Items.ItemNamed['text'].Items.Item[n].Items do
                 begin
                      FPicture.Font.Name := Value('FontName','Arial');
                      FPicture.Font.Size := IntValue('FontSize',8);
                      FColor := IntValue('FontColor',0);
                      FAlpha := IntValue('FontAlpha',0);
                      if BoolValue('FontBold',False) then FPicture.Font.Style := [fsBold]
                         else FPicture.Font.Style := [];
                      XMod := IntValue('XMod',0);
                      YMod := IntValue('YMod',0);
                      FCaption := Value('Caption','none');
                      AALevel := IntValue('FontAALevel',0);
                      FCaption := StringReplace(FCaption,'{Day}',Day,[rfReplaceAll, rfIgnoreCase]);
                      FCaption := StringReplace(FCaption,'{Month}',Month,[rfReplaceAll, rfIgnoreCase]);
                      FCaption := StringReplace(FCaption,'{Year}',Year,[rfReplaceAll, rfIgnoreCase]);
                      FCaption := StringReplace(FCaption,'{Month2}',FormatDateTime('mmm',now),[rfReplaceAll, rfIgnoreCase]);
                      FPicture.RenderText(XMod,YMod,FCaption,AALevel,color32(GetRValue(FColor),GetGValue(FColor),GetBValue(FColor),FAlpha));
                 end;
          except
          end;
     end;

     TempBmp := TBitmap32.Create;
     TempBmp.DrawMode := dmBlend;
     TempBmp.CombineMode := cmMerge;
     TempBmp.SetSize(FClockBack.Width,FClockBack.Height);

     TempBmp.Clear(color32(0,0,0,0));
     RotateBitmap(FHArrow,TempBmp,-HourOf(Now)*30-MinuteOf(Now)*0.5);
     TempBmp.DrawTo(FPicture);

     TempBmp.Clear(color32(0,0,0,0));
     RotateBitmap(FMArrow,TempBmp,-MinuteOf(Now)*6);
     TempBmp.DrawTo(FPicture);

     TempBmp.Free;

     FLastHour := HourOf(Now);
     FLastMinute := MinuteOf(Now);
end;

procedure TClockLayer.DrawBitmap;
var
   R : TFloatrect;
   w, h : integer;
begin
    DateTimeToString(strTime, 'hh:mm', Now());

    //Say to Image that we will update
    FParentImage.BeginUpdate;
    BeginUpdate;

    //Draw image centered
    Bitmap.Clear(color32(0,0,0,0));

    if FSkinType then
    begin
         Bitmap.SetSize(FPicture.Width,FPicture.Height);
         Bitmap.Clear(color32(0,0,0,0));
         if (FLastHour<>HourOf(Now)) or (FLastMinute<>MinuteOf(Now)) then
            DrawClock;
         Bitmap.Draw(0,0,FPicture);
         if FDrawGlass then Bitmap.Draw(0,0,FClockGlas);
    end
    else
    begin
         if not FShadow then Bitmap.RenderText(0, 0, strTime, 2, color32(FColor))
            else
            begin
              Bitmap.RenderText(0, 0, strTime, 0 , color32(FColor));
              createdropshadow(Bitmap,0,1,FShadowAlpha,0);
            end;
    end;

    Bitmap.DrawMode := dmBlend;
    if (FHighlight) and (not FLocked) then LightenBitmap(Bitmap,50);

    w := Bitmap.Width;
    h := Bitmap.Height;
    R := getAdjustedLocation();
    if (w <> (R.Right-R.left)) then   //dont move image if resize
       R.Left := R.left + round(((R.Right-R.left)- w)/2);
    if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
       R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
    R.Right := r.Left + w;
    R.Bottom := r.Top + h;
    location := R;

    FParentImage.EndUpdate;
    EndUpdate;

    Changed;
end;


procedure TClockLayer.LoadSettings;
var
   sTheme : String;
   alphablend : boolean;
   w,h : integer;
   sxml : TJvSimpleXML;
   sfile : String;
begin
  FLastHour:=-1;
  FLastMinute:=-1;
  if ObjectID=0 then exit;

  sxml := TJvSimpleXML.Create(nil);
  sfile := SharpApi.GetSharpeUserSettingsPath + 'SharpDesk\Objects\Clock\'+ inttostr(ObjectID) + '.xml';

  try
    sxml.LoadFromFile(sfile);
    with sxml.Root.Items do
    begin
      AlphaBlend := BoolValue('AlphaBlend',False);
      if AlphaBlend then Bitmap.MasterAlpha := IntValue('AlphaValue',255)
         else Bitmap.MasterAlpha := 255;
      FColor := StringToColor(Value('FontColor','0'));
      FShadow := BoolValue('DrawShadow',false);
      FSkinType := BoolValue('ClockType',False);
      FAnalogSkin := Value('AnalogSkin','');
      FDrawSpecial := BoolValue('DrawSpecial',True);
      FDrawGlass := BoolValue('DrawGlass',True);

      if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
      with Bitmap.Font do
      begin
        Name := Value('FontName','Arial');
        Size := IntValue('FontSize',32);
      end;
     end;
  finally
    sxml.Free;
  end;

     FShadowColor := FDeskSettings.Theme.ShadowColor;
     FShadowAlpha := FDeskSettings.Theme.ShadowAlpha;
     if FShadowAlpha<32 then FShadowAlpha:=32;

    { Get the initial time }
    fTimer1TimerNormal(Self);

    { Start timer off with seconds to next minute. Set to 60000 on first tick }
    fTimer.Interval := (60 - SecondOfTheMinute(Now())) * 1000;

    { Decide size }
    if not FSkinType then
    begin
         w := Bitmap.textwidth('00:00') + 2;        // 00:00 likely to be wide
         h := Bitmap.textHeight('1234567890') + 4;  // use all numbers!
         Bitmap.SetSize(w+4, h+4);
    end;

    { Refresh the drawn version }
    DrawBitmap();
 end;

constructor TClockLayer.Create( ParentImage:Timage32; Id : integer;
                                 DeskSettings : TDeskSettings;
                                 ThemeSettings : TThemeSettings;
                                 ObjectSettings : TObjectSettings);
begin
  Inherited Create(ParentImage.Layers);
  FDeskSettings   := DeskSettings;
  FThemeSettings  := ThemeSettings;
  FObjectSettings := ObjectSettings;
  FParentImage := ParentImage;
  FHighlight := False;
  Alphahit := False;
  FObjectId := id;
  scaled := false;
  FClockBack := TBitmap32.Create;
  FClockGlas := TBitmap32.Create;
  FHArrow := TBitmap32.Create;
  FMArrow := TBitmap32.Create;

  FPicture := TBitmap32.Create;
  FPicture.DrawMode := dmBlend;
  FPicture.CombineMode := cmMerge;
  FXML := TJvSimpleXML.Create(nil);
  fTimer := TTimer.Create(nil);
  fTimer.OnTimer := fTimer1TimerFirst;

  LoadSettings();
end;

destructor TClockLayer.Destroy;
begin
  fTimer.Enabled:=False;
  fTimer.Destroy;
  DebugFree(FXML);
  DebugFree(FPicture);
  DebugFree(FClockBack);
  DebugFree(FClockGlas);
  DebugFree(FHArrow);
  DebugFree(FMArrow);

  inherited;
end;


procedure TClockLayer.fTimer1TimerFirst(Sender: TObject);
begin
    fTimer.Interval := 60000;
    fTimer.OnTimer := fTimer1TimerNormal;

    DateTimeToString(strDate, 'dddd d mmmm, yyyy', Date());

    //if (bShowDate) then
    //    DateTimeToString(strTime, 'hh:mm, dd/mm/yy', Now())
    //else
        DateTimeToString(strTime, 'hh:mm', Now());

    DrawBitmap();
end;

procedure TClockLayer.fTimer1TimerNormal(Sender: TObject);
begin
    DateTimeToString(strDate, 'dddd d mmmm, yyyy', Date());

    //if (bShowDate) then
    //    DateTimeToString(strTime, 'hh:mm, dd/mm/yy', Now())
    //else
        DateTimeToString(strTime, 'hh:mm', Now());

    DrawBitmap();
end;

end.
