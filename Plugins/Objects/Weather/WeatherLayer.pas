{
Source Name: WeatherLayer.pas
Description: Weather Layer class
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

unit WeatherLayer;

interface
uses
  Windows, StdCtrls, Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils,SettingsWndUnit, ShellApi, Graphics,
  gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JvSimpleXML, Forms, JCLShell,StrUtils,
  SharpDeskApi,
  uSharpDeskTDeskSettings,
  uSharpDeskTThemeSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskDebugging,
  XMLSettings,
  uWeatherParser;

type

  TWeatherLayer = class(TBitmapLayer)
  private
    FOutput         : TStringList;
    FLocked         : Boolean;
    FShadow         : Boolean;
    FShadowColor    : integer;
    FShadowAlpha    : integer;
    FObjectID       : integer;
    FSettings       : TXMLSettings;
    FDeskSettings   : TDeskSettings;
    FThemeSettings  : TThemeSettings;
    FObjectSettings : TObjectSettings;
    FWeatherParser  : TWeatherParser;
    FParentImage : TImage32;
    FHighlight   : boolean;

    procedure doLoadImage(var Bmp : TBitmap32; IconFile: string);
    procedure LoadDefaultImage(var bmp : TBitmap32);
  protected
  public
     procedure DrawBitmap;
     procedure BuildOutput;
     function  ReplaceDataInString(pString : String) : String;
     procedure ReplaceData(var pSList : TStringList);
     procedure ReplaceSpacer(var pSList : TStringList);
     function  GetSize(var pSList : TStringList) : TPoint;
     procedure LoadSettings;
     constructor Create(ParentImage : Timage32; Id : integer;
                        DeskSettings : TDeskSettings;
                        ThemeSettings : TThemeSettings;
                        ObjectSettings : TObjectSettings); reintroduce;
     destructor Destroy; override;
     property ObjectID: Integer read FObjectId write FObjectId;
     property Locked : boolean read FLocked write FLocked;
     property ParentImage : TImage32 read FParentImage write FParentImage;
     property Highlight : boolean read FHighlight write FHighlight;
     property WeatherParser : TWeatherParser read FWeatherparser;
  end;

type
    pTBitmap32 = ^TBitmap32;


implementation

uses uSharpDeskManager,
     uSharpDeskDesktopObject,
     uSharpDeskObjectSet,
     uSharpDeskObjectSetItem;

procedure TWeatherLayer.BuildOutput;
begin
  try
    FOutput.Clear;
    if FSettings.CustomFormat then
    begin
      FOutput.CommaText := FSettings.CustomData;
    end else
    begin
      if FSettings.Location then
      begin
        if not FSettings.DetailedLocation then FOutput.Add('Location : {#LOCATION#}')
           else FOutput.Add('Location : {#LOCATION#}'+' ('+'{#LATITUE#},{#LONGITUDE#}'+')');
      end;
      if FSettings.Temperature then
         FOutput.Add('Temperature : {#TEMPERATURE#}'+' °'+'{#UNITTEMP#}');
      if FSettings.Wind then
         FOutput.Add('Wind : {#WINDSPEED#} {#UNITSPEED#}');
      if FSettings.Condition then
         FOutput.Add('Condition : {#CONDITION#}');
    end;

    if FOutput.Count = 0 then FOutput.Add('No data selected');
    ReplaceData(FOutput);
    ReplaceSpacer(FOutput);
  except
    SharpApi.SendDebugMessageEx('Weather.object','failed to build output',clred,DMT_ERROR);
  end;
end;

procedure TWeatherLayer.ReplaceSpacer(var pSList : TStringList);
var
  n , i , k : integer;
  sb,sa : String;
  maxpos : integer;
  maxwidth : integer;
begin
  maxpos := 0;
  for n := 0 to pSList.Count - 1 do
      if Pos('{#}',pSList[n]) > maxpos then
      begin
        maxpos := Pos('{#}',pSList[n]);
        sb := LeftStr(pSList[n],maxpos - 1);
        maxwidth := Bitmap.TextWidth(sb);        
      end;
  for n := 0 to pSList.Count - 1 do
  begin
    k := Pos('{#}',pSList[n]);
    if k <= 0 then pSList[n] := pSList[n]
    else if k < maxpos then
         begin
           sb := LeftStr(pSList[n],k-1);
           sa := RightStr(pSList[n],length(pSList[n])-k-2);
           while Bitmap.TextWidth(sb)< maxwidth do
                 sb := sb + ' ';
           pSList[n] := sb + sa;
         end else pSList[n] := StringReplace(pSList[n],'{#}','',[rfIgnoreCase]);
  end;

  maxpos := 0;
  for n := 0 to pSList.Count - 1 do
      if Pos('{#}',pSList[n]) > maxpos then
         maxpos := Pos('{#}',pSList[n]);
  if maxpos > 0 then ReplaceSpacer(pSList);
end;

function TWeatherLayer.GetSize(var pSList : TStringList) : TPoint;
var
  n : integer;
  w,h : integer;
  nw,nh : integer;
begin
  w := 0;
  h := 0;
  for n := 0 to pSList.Count - 1 do
  begin
    nw := Bitmap.TextWidth(pSList[n]);
    nh := Bitmap.TextHeight(pSList[n]);
    if nw > w then w := nw;
    h := h + nh;
  end;
  result := Point(w,h);
end;

function TWeatherLayer.ReplaceDataInString(pString : String) : String;
begin
  pString := StringReplace(pString,'{#LATITUE#}',     FWeatherParser.wxml.HeadLoc.Latitude,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#LONGITUDE#}',   FWeatherParser.wxml.HeadLoc.Longitude,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#LOCATION#}',    FWeatherParser.wxml.HeadLoc.LocationName,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#GMTOFFSET#}',   FWeatherParser.wxml.HeadLoc.GmtOffsett,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#TIMESUNSET#}',  FWeatherParser.wxml.HeadLoc.TimeSunset,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#TIMESUNRISE#}', FWeatherParser.wxml.HeadLoc.TimeSunrise,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#UNITTEMP#}',    FWeatherParser.wxml.HeadLoc.UnitOfTemp,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#UNITDIST#}',    FWeatherParser.wxml.HeadLoc.UnitOfDist,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#UNITSPEED#}',   FWeatherParser.wxml.HeadLoc.UnitOfSpeed,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#UNITPRESS#}',   FWeatherParser.wxml.HeadLoc.UnitOfPress,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#UNITPRECIP#}',  FWeatherParser.wxml.HeadLoc.UnitOfPrecip,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#TEMPERATURE#}', FWeatherParser.wxml.CurrentCondition.Temperature,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#TEMPFEELLIKE#}',FWeatherParser.wxml.CurrentCondition.FeelsLikeTemp,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#WINDSPEED#}',   FWeatherParser.wxml.CurrentCondition.Wind.WindSpd,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#MAXWINDSPEED#}',FWeatherParser.wxml.CurrentCondition.Wind.MaxWindSpd,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#WINDDIRTEXT#}', FWeatherParser.wxml.CurrentCondition.Wind.DirAsTxt,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#WINDDIRDEGR#}', FWeatherParser.wxml.CurrentCondition.Wind.DirAsDegr,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#BAROMPRESS#}',  FWeatherParser.wxml.CurrentCondition.BaromPressure.CurrentPressure,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#BAROMPRESSRF#}',FWeatherParser.wxml.CurrentCondition.BaromPressure.RaiseOrFallAsTxt,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#UV#}',          FWeatherParser.wxml.CurrentCondition.UV.Value,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#UVTEXT#}',      FWeatherParser.wxml.CurrentCondition.UV.ValueAsTxt,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#MOONICON#}',    FWeatherParser.wxml.CurrentCondition.Moon.IconCode,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#MOONTEXT#}',    FWeatherParser.wxml.CurrentCondition.Moon.MoonText,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#VISIBILITY#}',  FWeatherParser.wxml.CurrentCondition.Visibility,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#DEWPOINT#}',    FWeatherParser.wxml.CurrentCondition.Dewpoint,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#LASTUPDATE#}',  FWeatherParser.wxml.CurrentCondition.DateTimeLastUpdate,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#HUMIDITY#}',    FWeatherParser.wxml.CurrentCondition.Humidity,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#ICON#}',        FWeatherParser.wxml.CurrentCondition.IconCode,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#CONDITION#}',   FWeatherParser.wxml.CurrentCondition.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#OBSSTATION#}',  FWeatherParser.wxml.CurrentCondition.ObservationStation,[rfReplaceAll,rfIgnoreCase]);
  result := pString;
end;

procedure TWeatherLayer.ReplaceData(var pSList : TStringList);
var
   n : integer;
   s : String;
begin
  for n := 0 to pSList.Count - 1 do
      pSList[n] := ReplaceDataInString(pSList[n]);
end;     

procedure TWeatherLayer.DrawBitmap;
var
 R : TFloatrect;
 w,h : integer;
 n : integer;
 eh : integer;
 size : TPoint;
begin
  //Say to Image that we will update
  FParentImage.BeginUpdate;

  //Seems like it must be said sometimes

  //Decide size
//  w := FPicture.Width;
//  h := FPicture.Height;
  Size := GetSize(FOutput);
  w := Size.X + 16;
  h := Size.Y + 16 + FSettings.Spacing * (FOutput.Count - 1);
  Bitmap.SetSize(w,h);

  //Draw image centered
  Bitmap.Clear(color32(0,0,0,0));
  eh := Bitmap.TextHeight('!"§$%&/()=?`°QWERTZUIOPÜASDFGHJJKLÖÄYXCVBNqp1234567890');
  eh := eh + FSettings.Spacing;

  try
    for n := 0 to FOutput.Count - 1 do
        Bitmap.RenderText(4,n*eh,FOutput[n],0,color32(Bitmap.Font.Color));
  except
    SharpApi.SendDebugMessageEx('Weather.object','Failed to render output',clred,DMT_ERROR);
  end;

  try
    if FShadow then
       CreateDropShadow(Bitmap,0,1,FShadowAlpha,FShadowColor);
  except
    SharpApi.SendDebugMessageEx('Weather.object','Failed to draw drop shadow',clred,DMT_ERROR);
  end;

  try
    if (FHighlight) and not (FLocked) then
       SharpDeskApi.LightenBitmap(Bitmap,50);
  except
    SharpApi.SendDebugMessageEx('Weather.object','failed to highlight object',clred,DMT_ERROR);  
  end;

  //Set the right size of the layer
  R := getadjustedlocation;
  if (w <> (R.Right-R.left)) then   //dont move image if resize
    R.Left := R.left + round(((R.Right-R.left)- w)/2);
  if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
    R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
  if R.Left > Screen.DesktopWidth then
     R.Left := Screen.DesktopWidth-w;
  if R.Top > Screen.DesktopHeight then
     R.Top := Screen.DesktopHeight-h;
  if R.Left < 0 then R.Left := 0;
  if R.Top <0 then R.Top := 0;
  R.Right := r.Left + w;
  R.Bottom := r.Top + h;
  location := R;

  //Seems like it must be said sometimes
  Bitmap.DrawMode := dmBlend;

   //
  FParentImage.EndUpdate;
  Changed;
end;



procedure TWeatherLayer.LoadDefaultImage(var bmp : TBitmap32);
begin
  try
    bmp.SetSize(128,128);
    bmp.Clear(color32(128,128,128,128));
  finally
  end;

end;


procedure TWeatherLayer.doLoadImage(var Bmp : TBitmap32; IconFile: string);
var
   FileExt : String;
begin
  if FileExists(IconFile) = True then
  begin
       FileExt := ExtractFileExt(IconFile);
       if (lowercase(FileExt) = '.jpeg') or (lowercase(FileExt) = '.jpg') then loadjpg(bmp,IconFile)
          else if (lowercase(FileExt) = '.ico') then loadIco(bmp,IconFile,32)
               else if (lowercase(FileExt) = '.png') then loadPng(bmp,IconFile)
                    else if (lowercase(FileExt) = '.bmp') then LoadBmp(bmp,IconFile)
                        else Bitmap.Clear(color32(130,130,130,0)); 
  end
  else LoadDefaultImage(bmp);
end;



procedure TWeatherLayer.LoadSettings;
begin
  if ObjectID=0 then exit;

  FOutput.Clear;
  FSettings.LoadSettings;
  FWeatherParser.Update;  

  if FSettings.UseThemeSettings then
     FShadow := FDeskSettings.Theme.DeskTextShadow
     else FShadow := FSettings.TextShadow;
  FShadowAlpha := FDeskSettings.Theme.ShadowAlpha;
  FShadowColor := FDeskSettings.Theme.ShadowColor;

  Bitmap.Font.Name  := FSettings.FontName;
  Bitmap.Font.Size  := FSettings.FontSize;
  Bitmap.Font.Color := FSettings.FontColor;
  Bitmap.Font.Style := [];
  if FSettings.fsBold then
     Bitmap.Font.Style := Bitmap.Font.Style + [fsBold];
  if FSettings.fsItalic then
     Bitmap.Font.Style := Bitmap.Font.Style + [fsItalic];

  if FSettings.AlphaBlend then
  begin
    Bitmap.MasterAlpha := FSettings.AlphaValue;
    if Bitmap.MasterAlpha<16 then Bitmap.MasterAlpha:=16;
  end else Bitmap.MasterAlpha := 255;

  BuildOutput;

  DrawBitmap;
//  if FBlend then BlendImage(FPicture, FBlendColor,FBlendValue);
end;



constructor TWeatherLayer.Create( ParentImage:Timage32; Id : integer;
                                DeskSettings : TDeskSettings;
                                ThemeSettings : TThemeSettings;
                                ObjectSettings : TObjectSettings);
begin
  Inherited Create(ParentImage.Layers);
  FDeskSettings   := DeskSettings;
  FThemeSettings  := ThemeSettings;
  FObjectSettings := ObjectSettings;
  FOutput         := TStringList.Create;
  FParentImage := ParentImage;
  FHighlight := False;
  Alphahit := False;
  FObjectId := id;
  scaled := False;
  FWeatherParser := TWeatherParser.Create;
  try
    FWeatherParser.Update;
  except
    SharpApi.SendDebugMessageEx('Weather.object','Failed to update Weather Parser',clred,DMT_ERROR);
  end;
  FSettings := TXMLSettings.Create(FObjectSettings.XML,DeskSettings);
  FSettings.SetSettingsRoot(FObjectSettings.XML.Root.Items.ItemNamed['ObjectSettings'].Items.ItemNamed[inttostr(ObjectID)]);
  LoadSettings;
end;

destructor TWeatherLayer.Destroy;
begin
  DebugFree(FWeatherParser);
  DebugFree(FSettings);
  DebugFree(FOutput);
  inherited;
end;

end.
