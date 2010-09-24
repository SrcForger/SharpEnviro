{
Source Name: uClockObjectLayer.pas
Description: Clock desktop object layer
Copyright (C) Delusional <Delusional@Lowdimension.net>
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

unit uClockObjectLayer;

interface
uses
  Windows, StdCtrls, Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils, ShellApi, Graphics, StrUtils,
  gr32,
  pngimage,
  GR32_Image,
  GR32_Layers,
  GR32_BLEND,
  GR32_Transforms,
  GR32_Filters,
  GR32_Resamplers,
  GR32_Backends,
  DateUtils, Forms,
  SharpThemeApiEx,
  SharpGraphicsUtils,
  uISharpETheme,
  uSharpDeskDebugging,
  uSharpDeskTDeskSettings,
  uSharpDeskObjectSettings,
  ClockObjectXMLSettings,
  uSharpXMLUtils,
  SharpDeskApi, GR32_PNG, JclSimpleXML;

type
  TColorRec = packed record
                 b,g,r,a: Byte;
               end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

  TClockSkinTextAlign = (caLeft,caCenter,caRight);

  TClockText = record
    FontName : string;
    FontSize : integer;
    FontColor : TColor;
    FontAlpha : integer;
    FontStyle : string;

    XMod : integer;
    YMod : integer;
    Caption : string;
    ClearType : boolean;
    Align : TClockSkinTextAlign;

    Overlay : boolean;
  end;

  TClockTexts = array of TClockText;

  TClockLayer = class(TBitmapLayer)
  private
    FHLTimer        : TTimer;
    FHLTimerI       : integer;
    FAnimSteps      : integer;
    FLocked      : boolean;
    FHighlight   : boolean;
    FShadowAlpha : integer;
    FShadowColor : integer;
    FObjectId    : integer;
    FParentImage : TImage32;
    FClockBack   : TBitmap32;
    FClockOverlay   : TBitmap32;
    FHArrow      : TBitmap32;
    FMArrow      : TBitmap32;
    FSArrow      : TBitmap32;
    FHArrowRot   : TBitmap32;
    FMArrowRot   : TBitmap32;
    FPicture     : TBitmap32;
    FDeskSettings   : TDeskSettings;
    FSettings : TClockXMLSettings;

    FClockTexts : TClockTexts;

    FLastHour, FLastMinute, FLastSecond : integer;

    fTimer : TTimer;
    strTime, strDate : string;

    FAffineTrans: TAffineTransformation;

  protected
    procedure LoadSkin;

    procedure fTimer1TimerNormal(Sender: TObject);

    procedure OnTimer(Sender: TObject);

    procedure RotateBitmap(Src, Dst : TBitmap32; Alpha: Single);
     
  public
    constructor Create( ParentImage:Timage32; Id : integer;
                         DeskSettings : TDeskSettings); reintroduce;
    destructor Destroy; override;

    procedure StartHL;
    procedure EndHL;

    procedure DrawClock;
    procedure DrawBitmap;
    procedure LoadSettings;

    property ObjectId: Integer read FObjectId write FObjectId;
    property Highlight : boolean read FHighlight write FHighlight;
    property Locked : boolean read FLocked write FLocked;
  end;

implementation


procedure TClockLayer.RotateBitmap(Src, Dst : TBitmap32; Alpha: Single);
var
  SrcR: Integer;
  SrcB: Integer;
  Scale: Single;
begin
  SrcR := Src.Width - 1;
  SrcB := Src.Height - 1;

  FAffineTrans.SrcRect := FloatRect(0, 0, SrcR + 1, SrcB + 1);

  FAffineTrans.Clear;

  FAffineTrans.Translate(-SrcR / 2, -SrcB / 2);
  FAffineTrans.Rotate(0, 0, Alpha);

  scale := 1;

  FAffineTrans.Scale(Scale, Scale);

  FAffineTrans.Translate(SrcR / 2, SrcB / 2);

  Dst.BeginUpdate;
  Transform(Dst, Src, FAffineTrans);
  Dst.EndUpdate;
end;

function FormatCaption(str : string) : string;
var
  tmp1, tmp2 : string;
  n, e : integer;
begin
  n := 1;

  while n < Length(str) do
  begin
    if PosEx('{', str, n) <= 0 then
      break;

    n := PosEx('{', str, n);
    e := PosEx('}', str, n + 1);
    if e <= 0 then
      break;

    tmp1 := Copy(str, n + 1, e - n - 1);
    DateTimeToString(tmp2, tmp1, Now);

    Delete(str, n, e - n + 1);
    Insert(tmp2, str, n);
  end;

  Result := str;
end;

procedure TClockLayer.StartHL;
begin
  if (GetCurrentTheme.Desktop.Animation.UseAnimations) and (not FLocked) then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    if (not FLocked) then
      SharpGraphicsUtils.LightenBitmap(Bitmap,50);
  end;
end;

procedure TClockLayer.EndHL;
begin
  if (GetCurrentTheme.Desktop.Animation.UseAnimations) and (not FLocked) then
  begin
    FHLTimerI := -1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
  end;
end;

procedure TClockLayer.OnTimer(Sender: TObject);
var
  i : integer;

  Theme : ISharpETheme;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

  Theme := GetCurrentTheme;

  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
  
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 0;

    i := 255;

    Bitmap.MasterAlpha := i;

    DrawBitmap;

    FParentImage.EndUpdate;
    EndUpdate;
    Changed;
    exit;
  end;

  if Theme.Desktop.Animation.Alpha then
  begin
    i := 255;
    i := i + round(((Theme.Desktop.Animation.AlphaValue / FAnimSteps) * FHLTimer.Tag));
    if i > 255 then
      i := 255
    else if i < 32 then
      i := 32;
      
    Bitmap.MasterAlpha := i;
  end;

  if FHLTimer.Tag >= FAnimSteps then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := FAnimSteps;
  end;
  
  DrawBitmap;
  
  if Theme.Desktop.Animation.Brightness then
     LightenBitmap(Bitmap,round(FHLTimer.Tag*(Theme.Desktop.Animation.BrightnessValue/FAnimSteps)));
  if Theme.Desktop.Animation.Blend then
     BlendImageA(Bitmap,
                 Theme.Desktop.Animation.BlendColor,
                 round(FHLTimer.Tag*(Theme.Desktop.Animation.BlendValue/FAnimSteps)));

  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;

procedure TClockLayer.LoadSkin;
var
  SkinDir : String;

  b : boolean;
  i, n, n1 : integer;

  XML: TJclSimpleXML;

  SkinStr : string;
begin
  SetLength(FClockTexts, 0);

  SkinDir := ExtractFileDir(Application.ExeName) + '\Skins\Objects\Clock\' + FSettings.Skin + '\';
  if (FSettings.DrawText) and (not FileExists(SkinDir + 'Clock.xml')) then
  begin
    FSettings.DrawText := False;
  end;

  FClockBack.SetSize(0,0);
  FClockOverlay.SetSize(0,0);
  FHArrow.SetSize(0,0);
  FMArrow.SetSize(0,0);
  FSArrow.SetSize(0,0);

  XML := TJclSimpleXML.Create;
  if LoadXMLFromSharedFile(XML,SkinDir + 'Clock.xml',False) then
  begin
    for n := 0 to XML.Root.Items.Count - 1 do
    begin
      if XML.Root.Items.Item[n].Name = 'ClockSkin' then
      begin
        if XML.Root.Items.Item[n].Items.ItemNamed['Info'] <> nil then
        begin
          if (XML.Root.Items.Item[n].Items.ItemNamed['Info'].Items.Value('Category') <> FSettings.SkinCategory) or
            (XML.Root.Items.Item[n].Items.ItemNamed['Info'].Items.Value('Filter') <> FSettings.SkinFilter) then
            continue;
        end;

        // Skin
        if XML.Root.Items.Item[n].Items.ItemNamed['Skin'] <> nil then
        begin
          with XML.Root.Items.Item[n].Items.ItemNamed['Skin'].Items do
          begin
            SkinStr := Value('Background','');
            if (SkinStr <> '') and (FileExists(SkinDir + SkinStr)) then
              LoadBitmap32FromPNG(FClockBack, SkinDir + SkinStr, b);

            SkinStr := Value('Overlay','');
            if (SkinStr <> '') and (FileExists(SkinDir + SkinStr)) then
              LoadBitmap32FromPNG(FClockOverlay, SkinDir + SkinStr, b);

            SkinStr := Value('HandHour','');
            if (SkinStr <> '') and (FileExists(SkinDir + SkinStr)) then
              LoadBitmap32FromPNG(FHArrow, SkinDir + SkinStr, b);

            SkinStr := Value('HandMinute','');
            if (SkinStr <> '') and (FileExists(SkinDir + SkinStr)) then
              LoadBitmap32FromPNG(FMArrow, SkinDir + SkinStr, b);

            SkinStr := Value('HandSecond','');
            if (SkinStr <> '') and (FileExists(SkinDir + SkinStr)) then
              LoadBitmap32FromPNG(FSArrow, SkinDir + SkinStr, b);

            if (IntValue('Width') > -1) and (IntValue('Height') > -1) then
            begin
              FClockBack.SetSize(IntValue('Width'), IntValue('Height')); 
              FClockBack.Clear(Color32(0,0,0,0));
            end;
          end;
        end;

        if FSettings.DrawText then
        begin
          for i := 0 to XML.Root.Items.Item[n].Items.Count - 1 do
            if XML.Root.Items.Item[n].Items[i].Name = 'Text' then
            begin
              n1 := Length(FClockTexts);
              SetLength(FClockTexts, Length(FClockTexts) + 1);

              with XML.Root.Items.Item[n].Items[i].Items do
              begin
                FClockTexts[n1].FontName := Value('FontName','Arial');
                FClockTexts[n1].FontSize := IntValue('FontSize',8);
                FClockTexts[n1].FontColor := GetCurrentTheme.Scheme.ParseColor(Value('FontColor','RGB(0,0,0)'));
                FClockTexts[n1].FontAlpha := IntValue('FontAlpha',0);
                FClockTexts[n1].FontStyle := Value('FontStyle', '');

                FClockTexts[n1].XMod := IntValue('XMod', 0);
                FClockTexts[n1].YMod := IntValue('YMod', 0);
                FClockTexts[n1].Caption := Value('Caption', 'none');
                FClockTexts[n1].ClearType := BoolValue('ClearType', true);
                FClockTexts[n1].Align := TClockSkinTextAlign(IntValue('Align', Int64(caLeft)));
              end;
            end;
        end;
      end;
    end;
  end else
    SharpApi.SendDebugMessageEx('Clock.Object','Failed to Load Settings from' + SkinDir + 'Skin.xml',0,DMT_ERROR);

  DebugFree(XML);
end;

procedure TClockLayer.DrawClock;
var
  n, x : integer;
  formattedCaption : string;
  TempBmp : TBitmap32;
  AALevel : integer;
begin
  FClockBack.DrawMode := dmBlend;
  FClockBack.CombineMode := cmMerge;
  FClockOverlay.DrawMode := dmBlend;
  FClockOverlay.CombineMode := cmMerge;
  FHArrow.DrawMode := dmBlend;
  FHArrow.CombineMode := cmMerge;
  FMArrow.DrawMode := dmBlend;
  FMArrow.CombineMode := cmMerge;
  FSArrow.DrawMode := dmBlend;
  FSArrow.CombineMode := cmMerge;

  FPicture.SetSize(FClockBack.Width,FClockBack.Height);
  FPicture.Clear(color32(0,0,0,0));

  //Draw background
  if FClockBack.Width <> 0 then
    FClockBack.DrawTo(FPicture);

  // Draw texts
  for n := 0 to Length(FClockTexts) - 1 do
  begin
    if FClockTexts[n].Overlay then
      continue;

    FPicture.Font.Name := FClockTexts[n].FontName;
    FPicture.Font.Size := FClockTexts[n].FontSize;

    FPicture.Font.Style := [];
    if AnsiContainsText(FClockTexts[n].FontStyle, 'Bold') then
      FPicture.Font.Style := FPicture.Font.Style + [fsBold];
    if AnsiContainsText(FClockTexts[n].FontStyle, 'Italic') then
      FPicture.Font.Style := FPicture.Font.Style + [fsItalic];
    if AnsiContainsText(FClockTexts[n].FontStyle, 'Underline') then
      FPicture.Font.Style := FPicture.Font.Style + [fsUnderline];
    if AnsiContainsText(FClockTexts[n].FontStyle, 'Strikeout') then
      FPicture.Font.Style := FPicture.Font.Style + [fsStrikeout];

    AALevel := 0;
    if FClockTexts[n].ClearType then
      AALevel := -2;

    formattedCaption := FormatCaption(FClockTexts[n].Caption);
    x := 0;
    
    case FClockTexts[n].Align of
      caLeft: x := FClockTexts[n].XMod;
      caCenter: x := FClockTexts[n].XMod - Round(FPicture.TextWidth(formattedCaption) div 2);
      caRight: x := FClockTexts[n].XMod - FPicture.TextWidth(formattedCaption);
    end;

    FPicture.RenderText(x, FClockTexts[n].YMod, formattedCaption, AALevel, color32(GetRValue(FClockTexts[n].FontColor), GetGValue(FClockTexts[n].FontColor), GetBValue(FClockTexts[n].FontColor), FClockTexts[n].FontAlpha));
  end;

  TempBmp := TBitmap32.Create;
  TempBmp.DrawMode := dmBlend;
  TempBmp.CombineMode := cmMerge;
  TempBmp.SetSize(FClockBack.Width,FClockBack.Height);

  if FHArrow.Width > 0 then
  begin
    TempBmp.Clear(color32(0,0,0,0));

    if (FLastHour <> HourOf(Now)) then
    begin
      FHArrowRot.Clear(color32(0,0,0,0));
      FHArrowRot.SetSize(FClockBack.Width,FClockBack.Height);
      RotateBitmap(FHArrow,FHArrowRot,-HourOf(Now)*30-MinuteOf(Now)*0.5);
    end;
    FHArrowRot.DrawTo(FPicture, (FClockBack.Width - FHArrow.Width) div 2, (FClockBack.Height - FHArrow.Height) div 2);
  end;

  if FMArrow.Width > 0 then
  begin
    TempBmp.Clear(color32(0,0,0,0));

    if (FLastMinute <> MinuteOf(Now)) then
    begin
      FMArrowRot.Clear(color32(0,0,0,0));
      FMArrowRot.SetSize(FClockBack.Width,FClockBack.Height);
      RotateBitmap(FMArrow,FMArrowRot,-MinuteOf(Now)*6);
    end;
    FMArrowRot.DrawTo(FPicture, (FClockBack.Width - FMArrow.Width) div 2, (FClockBack.Height - FMArrow.Height) div 2);
  end;

  if FSArrow.Width > 0 then
  begin
    TempBmp.Clear(color32(0,0,0,0));
    RotateBitmap(FSArrow,TempBmp,-SecondOf(Now)*6);
    TempBmp.DrawTo(FPicture, (FClockBack.Width - FSArrow.Width) div 2, (FClockBack.Height - FSArrow.Height) div 2);
  end;
  TempBmp.Free;

  if (FSettings.DrawOverlay) and (FClockOverlay.Width > 0) then
    FClockOverlay.DrawTo(FPicture);

  // Draw overlay texts
  for n := 0 to Length(FClockTexts) - 1 do
  begin
    if not FClockTexts[n].Overlay then
      continue;

    FPicture.Font.Name := FClockTexts[n].FontName;
    FPicture.Font.Size := FClockTexts[n].FontSize;

    FPicture.Font.Style := [];
    if AnsiContainsText(FClockTexts[n].FontStyle, 'Bold') then
      FPicture.Font.Style := FPicture.Font.Style + [fsBold];
    if AnsiContainsText(FClockTexts[n].FontStyle, 'Italic') then
      FPicture.Font.Style := FPicture.Font.Style + [fsItalic];
    if AnsiContainsText(FClockTexts[n].FontStyle, 'Underline') then
      FPicture.Font.Style := FPicture.Font.Style + [fsUnderline];
    if AnsiContainsText(FClockTexts[n].FontStyle, 'Strikeout') then
      FPicture.Font.Style := FPicture.Font.Style + [fsStrikeout];

    AALevel := 0;
    if FClockTexts[n].ClearType then
      AALevel := -2;

    FPicture.RenderText(FClockTexts[n].XMod, FClockTexts[n].YMod, FClockTexts[n].Caption, AALevel, color32(GetRValue(FClockTexts[n].FontColor), GetGValue(FClockTexts[n].FontColor), GetBValue(FClockTexts[n].FontColor), FClockTexts[n].FontAlpha));
  end;

  FLastHour := HourOf(Now);
  FLastMinute := MinuteOf(Now);
  FLastSecond := SecondOf(Now);
end;

procedure TClockLayer.DrawBitmap;
var
   R : TFloatrect;
   w, h : integer;
begin
  DateTimeToString(strTime, 'hh:mm', Now);

  //Say to Image that we will update
  FParentImage.BeginUpdate;
  BeginUpdate;

  //Draw image centered
  Bitmap.Clear(color32(0,0,0,0));

  if FSettings.Skin <> '' then
  begin
    Bitmap.SetSize(FPicture.Width,FPicture.Height);
    Bitmap.Clear(color32(0,0,0,0));
    if (FLastHour <> HourOf(Now)) or (FLastMinute <> MinuteOf(Now)) or (FLastSecond <> SecondOf(Now)) then
      DrawClock;   

    Bitmap.Draw(0,0,FPicture);
  end else
  begin
    if not FSettings.Shadow then
      Bitmap.RenderText(0, 0, strTime, 2, color32(FSettings.Color))
    else
    begin
      Bitmap.RenderText(0, 0, strTime, 0 , color32(FSettings.Color));
      createdropshadow(Bitmap,0,1,FShadowAlpha,0);
    end;
  end;

  Bitmap.DrawMode := dmBlend;
  //if (FHighlight) and (not FLocked) then LightenBitmap(Bitmap,50);

  w := Bitmap.Width;
  h := Bitmap.Height;
  R := getAdjustedLocation;
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
  ITheme : ISharpETheme;
  w,h : integer;
begin
  if ObjectID = 0 then
    exit;

  fTimer.Enabled := False;

  FLastHour := -1;
  FLastMinute := -1;
  FLastSecond := -1;

  FSettings.LoadSettings;

  ITheme := GetCurrentTheme;
  with FSettings do
  begin
    Bitmap.MasterAlpha := 255;

    with Bitmap.Font do
    begin
      Name := BitmapName;
      Size := BitmapSize;
    end;
  end;

  FShadowColor := ITheme.Scheme.SchemeCodeToColor(FSettings.Theme[DS_TEXTSHADOWCOLOR].IntValue);
  FShadowAlpha := FSettings.Theme[DS_TEXTSHADOWALPHA].IntValue;
  if FShadowAlpha < 32 then
    FShadowAlpha := 32;

  { Get the initial time }
  DateTimeToString(strDate, 'dddd d mmmm, yyyy', Date);
  DateTimeToString(strTime, 'hh:mm', Now);

  { Start timer off with seconds to next minute. Set to 60000 on first tick }
  fTimer.Interval := 1000; //;(60 - SecondOfTheMinute(Now));

  { Decide size }
  if FSettings.Skin = '' then
  begin
    w := Bitmap.textwidth('00:00') + 2;        // 00:00 likely to be wide
    h := Bitmap.textHeight('1234567890') + 4;  // use all numbers!
    Bitmap.SetSize(w+4, h+4);
  end;

  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);   

  LoadSkin;

  fTimer1TimerNormal(Self);
  fTimer.Enabled := True;
  fTimer1TimerNormal(Self);  
end;

constructor TClockLayer.Create( ParentImage:Timage32; Id : integer;
                                 DeskSettings : TDeskSettings);
begin
  Inherited Create(ParentImage.Layers);

  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled := False;
  FHLTimer.OnTimer := OnTimer;
  FAnimSteps      := 5;

  FDeskSettings   := DeskSettings;
  FParentImage := ParentImage;
  FHighlight := False;
  Alphahit := False;
  FObjectId := id;
  scaled := false;
  FClockBack := TBitmap32.Create;
  FClockOverlay := TBitmap32.Create;
  FHArrow := TBitmap32.Create;
  FMArrow := TBitmap32.Create;
  FSArrow := TBitmap32.Create;
  TLinearResampler.Create(FHArrow);
  TLinearResampler.Create(FMArrow);
  TLinearResampler.Create(FSArrow);  
//  TKernelResampler.Create(FHArrow).Kernel := TMitchellKernel.Create;
//  TKernelResampler.Create(FMArrow).Kernel := TMitchellKernel.Create;
//  TKernelResampler.Create(FSArrow).Kernel := TMitchellKernel.Create;

  // for storing the rotated minute and hour arrows
  FHArrowRot := TBitmap32.Create;
  FMArrowRot := TBitmap32.Create;
  FHArrowRot.DrawMode := dmBlend;
  FHArrowRot.CombineMode := cmMerge;
  FMArrowRot.DrawMode := dmBlend;
  FMArrowRot.CombineMode := cmMerge;

  FAffineTrans := TAffineTransformation.Create;

  FPicture := TBitmap32.Create;
  FPicture.DrawMode := dmBlend;
  FPicture.CombineMode := cmMerge;
  fTimer := TTimer.Create(nil);
  fTimer.Interval := 1000;
  fTimer.OnTimer := fTimer1TimerNormal;

  DateTimeToString(strDate, 'dddd d mmmm, yyyy', Date);
  DateTimeToString(strTime, 'hh:mm', Now);

  FSettings := TClockXMLSettings.Create(FObjectID, nil, 'Clock');

  SetLength(FClockTexts, 0);

  LoadSettings;

  DrawBitmap;
end;

destructor TClockLayer.Destroy;
begin
  fTimer.Enabled:=False;
  fTimer.Destroy;
  DebugFree(FPicture);
  DebugFree(FClockBack);
  DebugFree(FClockOverlay);
  DebugFree(FHArrow);
  DebugFree(FMArrow);
  DebugFree(FSArrow);
  DebugFree(FHArrowRot);
  DebugFree(FMArrowRot);
  DebugFree(FHLTimer);
  DebugFree(FAffineTrans);

  inherited;
end;

procedure TClockLayer.fTimer1TimerNormal(Sender: TObject);
begin
  DateTimeToString(strDate, 'dddd d mmmm, yyyy', Date);
  DateTimeToString(strTime, 'hh:mm', Now);

  if (FHLTimer.Tag >= 1) and (not FHLTimer.Enabled) then
    FHLTimer.OnTimer(nil)
  else if (FHLTimer. Tag <= 0) and (not FHLTimer.Enabled) then
    DrawBitmap;
end;

end.
