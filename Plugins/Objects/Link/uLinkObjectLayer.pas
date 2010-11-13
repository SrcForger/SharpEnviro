{
Source Name: uLinkObjectLayer.pas
Description: Link object layer class
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

unit uLinkObjectLayer;

interface
uses
  Windows, StdCtrls, Forms, Classes, ExtCtrls, Math,
  Messages, SharpApi, SysUtils, ShellApi, Graphics,
  gr32,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, SharpDeskApi, JclShell, Types,
  LinkObjectXMLSettings,
  uSharpDeskDebugging,
  uSharpDeskFunctions,
  uSharpDeskObjectSettings,
  SharpThemeApiEx,
  uISharpETheme,
  uThemeConsts,
  SharpIconUtils,
  SharpGraphicsUtils,
  GR32_Resamplers;
type
   TColorRec = packed record
                 b,g,r,a: Byte;
               end;
  TColorArray = array[0..MaxInt div SizeOf(TColorRec)-1] of TColorRec;
  PColorArray = ^TColorArray;

  TLinkLayer = class(TBitmapLayer)
  private
  protected
     FFontSettings    : TDeskFont;
     FIconSettings    : TDeskIcon;
     FCaptionSettings : TDeskCaption;
     FSettings        : TLinkXMLSettings;
     FHLTimer         : TTimer;
     FHLTimerI        : integer;
     FAnimSteps       : integer;
     FObjectID        : integer;
     FScale           : integer;
     FLocked          : Boolean;
     procedure OnTimer(Sender: TObject);
  public
     FParentImage : Timage32;
     procedure DrawBitmap;
     procedure LoadSettings;
     procedure DoubleClick;
     procedure OnOpenClick(Sender : TObject);
     procedure OnSearchClick(Sender : TObject);
     procedure OnPropertiesClick(Sender : TObject);
     procedure OnOpenWith(Sender : TObject);
     procedure StartHL;
     procedure EndHL;
     constructor Create( ParentImage:Timage32; Id : integer); reintroduce;
     destructor Destroy; override;
     property ObjectId  : Integer read FObjectId  write FObjectId;
     property Locked    : boolean read FLocked    write FLocked;
     property Settings  : TLinkXMLSettings read FSettings;
  private
  end;

implementation


procedure TLinkLayer.OnOpenClick(Sender : TObject);
begin
  DoubleClick;
end;

procedure TLinkLayer.OnSearchClick(Sender : TObject);
//var
//   Shell: Variant;
begin
  //   Shell := CreateOLEObject('Shell.Application');
  //   Shell.FindFiles;
end;

procedure TLinkLayer.OnPropertiesClick(Sender : TObject);
begin
  DisplayPropDialog(Application.Handle,FSettings.Target);
end;

procedure TLinkLayer.OnOpenWith(Sender : TObject);
begin
  ShellOpenAs(FSettings.Target);
end;

procedure TLinkLayer.StartHL;
begin
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

procedure TLinkLayer.EndHL;
begin
  if GetCurrentTheme.Desktop.Animation.UseAnimations then
  begin
    FHLTimerI := -1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
  end;
end;

procedure TLinkLayer.OnTimer(Sender: TObject);
var
  i : integer;
  Theme : ISharpETheme;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;
  FHLTimer.Tag := FHLTimer.Tag + FHLTimerI;
  if FHLTimer.Tag <= 0 then
  begin
    FHLTimer.Enabled := False;
    FHLTimer.Tag := 0;
    FScale := 100;

    i := 255;
    Bitmap.MasterAlpha := i;
    
    DrawBitmap;
    FParentImage.EndUpdate;
    EndUpdate;
    Changed;
    exit;
  end;

  Theme := GetCurrentTheme;
  if Theme.Desktop.Animation.Scale then
    FScale := round(100 + ((Theme.Desktop.Animation.ScaleValue)/FAnimSteps)*FHLTimer.Tag);
  if Theme.Desktop.Animation.Alpha then
  begin
    FScale := 100;

    i := 255;
    i := i + round(((Theme.Desktop.Animation.AlphaValue/FAnimSteps)*FHLTimer.Tag));
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


procedure TLinkLayer.DoubleClick;
begin
  SharpExecute(FSettings.Target);
end;

procedure TLinkLayer.DrawBitmap;
var
   R : TFloatrect;
   w,h : integer;
   TempBitmap : TBitmap32;
begin
  FParentImage.BeginUpdate;
  BeginUpdate;

  TempBitmap := TBitmap32.Create;
  TempBitmap.DrawMode := dmBlend;
  TempBitmap.CombineMode := cmMerge;
  SharpDeskApi.RenderObject(TempBitmap,
                            FIconSettings,
                            FFontSettings,
                            FCaptionSettings,
                            Point(0,0),
                            Point(0,0));

  Bitmap.SetSize(TempBitmap.Width,TempBitmap.Height);
  Bitmap.Clear(color32(0,0,0,0));
  Bitmap.Draw(0,0,TempBitmap);

  TempBitmap.Free;

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
  R := getadjustedlocation;
  if (w <> (R.Right-R.left)) then   //dont move image if resize
    R.Left := R.left + round(((R.Right-R.left)- w)/2);
  if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
    R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
  R.Right := r.Left + w;
  R.Bottom := r.Top + h;
  location := R;

  Bitmap.DrawMode := dmBlend;

  FParentImage.EndUpdate;
  EndUpdate;
  changed;
end;




procedure TLinkLayer.LoadSettings;
var
  bmp : TBitmap32;
  ITheme : ISharpETheme;
begin
  if ObjectID=0 then exit;

  FSettings.LoadSettings;

  ITheme := GetCurrentTheme;
  with FSettings do
  begin
    FFontSettings.Name      := Theme[DS_FONTNAME].Value;
    FFontSettings.Size      := Theme[DS_TEXTSIZE].IntValue;
    FFontSettings.Color     := ITheme.Scheme.SchemeCodeToColor(Theme[DS_TEXTCOLOR].IntValue);
    FFontSettings.Bold      := Theme[DS_TEXTBOLD].BoolValue;
    FFontSettings.Italic    := Theme[DS_TEXTITALIC].BoolValue;
    FFontSettings.Underline := Theme[DS_TEXTUNDERLINE].BoolValue;
    FFontSettings.ClearType   := Theme[DS_TEXTCLEARTYPE].BoolValue;
    FFontSettings.ShadowColor      := ITheme.Scheme.SchemeCodeToColor(Theme[DS_TEXTSHADOWCOLOR].IntValue);
    FFontSettings.ShadowAlphaValue := Theme[DS_TEXTSHADOWALPHA].IntValue;
    FFontSettings.Shadow           := Theme[DS_TEXTSHADOW].BoolValue;
    FFontSettings.TextAlpha        := Theme[DS_TEXTALPHA].BoolValue;
    FFontSettings.Alpha            := Theme[DS_TEXTALPHAVALUE].IntValue;
    FFontSettings.ShadowType       := Theme[DS_TEXTSHADOWTYPE].IntValue;
    FFontSettings.ShadowSize       := Theme[DS_TEXTSHADOWSIZE].IntValue;

    FCaptionSettings.Caption.Clear;
    FCaptionSettings.Caption.Delimiter := ' ';
    if FSettings.MLineCaption then FCaptionSettings.Caption.DelimitedText := FSettings.Caption
       else FCaptionSettings.Caption.Add(FSettings.Caption);
    FCaptionSettings.Align := IntToTextAlign(FSettings.CaptionAlign);
    FCaptionSettings.Xoffset := 0;
    FCaptionSettings.Yoffset := 0;
   // if FSettings.IconSpacing then
    //   if (FCaptionSettings.Align = taLeft) or (FCaptionSettings.Align = taRight) then
    //       FCaptionSettings.Xoffset := 0
   //    else FCaptionSettings.Yoffset := 0;
    FCaptionSettings.Draw := ShowCaption;
    FCaptionSettings.LineSpace := 0;

    FIconSettings.Size        := 100;
    FIconSettings.Alpha := 255;
    if FSettings.Theme[DS_ICONALPHABLEND].BoolValue then
      FIconSettings.Alpha := Theme[DS_ICONALPHA].IntValue;
    FIconSettings.XOffset     := 0;
    FIconSettings.YOffset     := 0;
    //if FSettings.IconOffset then FIconSettings.XOffset := FSettings.IconOffsetValue;;

    FIconSettings.Blend       := Theme[DS_ICONBLENDING].BoolValue;
    FIconSettings.BlendColor  := ITheme.Scheme.SchemeCodeToColor(Theme[DS_ICONBLENDCOLOR].IntValue);
    FIconSettings.BlendValue  := Theme[DS_ICONBLENDALPHA].IntValue;
    FIconSettings.Shadow      := Theme[DS_ICONSHADOW].BoolValue;
    FIconSettings.ShadowColor := ITheme.Scheme.SchemeCodeToColor(Theme[DS_ICONSHADOWCOLOR].IntValue);
    FIconSettings.ShadowAlpha := 255-Theme[DS_ICONSHADOWALPHA].IntValue;

    if Theme[DS_ICONSIZE].IntValue <= 8 then
       Theme[DS_ICONSIZE].IntValue:= 48;

    if FIconSettings.Icon <> nil then
    begin
      bmp := TBitmap32.Create;
      TLinearResampler.Create(Bmp);
      IconStringToIcon(FSettings.Icon,FSettings.Target,Bmp,GetNearestIconSize(Theme[DS_ICONSIZE].IntValue));
      bmp.DrawMode := dmBlend;
      bmp.CombineMode := cmMerge;
      FIconSettings.Icon.SetSize(Theme[DS_ICONSIZE].IntValue,Theme[DS_ICONSIZE].IntValue);
      FIconSettings.Icon.Clear(color32(0,0,0,0));
      bmp.DrawTo(FIconSettings.Icon,Rect(0,0,FIconSettings.Icon.Width,FIconSettings.Icon.Height));
      bmp.Free;
    end;

    Bitmap.MasterAlpha := 255;
  end;

  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);
end;

constructor TLinkLayer.Create( ParentImage:Timage32; Id : integer);
begin
  Inherited Create(ParentImage.Layers);
  FParentImage := ParentImage;
  Alphahit := False;
  FObjectId := id;
  scaled := false;
  FSettings := TLinkXMLSettings.Create(FObjectId,nil,'Link');
  FSettings.Caption := 'Link';
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled := False;
  FHLTimer.OnTimer := OnTimer;
  FAnimSteps       := 5;
  FScale           := 100;
  FCaptionSettings.Caption := TStringList.Create;
  FCaptionSettings.Caption.Clear;
  FIconSettings.Icon := TBitmap32.Create;
  LoadSettings;
end;

destructor TLinkLayer.Destroy;
begin
  DebugFree(FCaptionSettings.Caption);
  DebugFree(FIconSettings.Icon);
  DebugFree(FSettings);
  if FHlTimer <> nil then
     FHLTimer.Enabled := False;
  DebugFree(FHLTimer);
  inherited Destroy;
end;

end.
