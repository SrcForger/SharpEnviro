{
Source Name: WeatherObjectLayer.pas
Description: Weather Object Layer class
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

unit WeatherObjectLayer;

interface
uses
  Windows, Types, StdCtrls, Classes, Controls, ExtCtrls, Dialogs,Math,
  Messages, JPeg, SharpApi, SysUtils, ShellApi, Graphics, Menus,
  gr32_png,gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND, GR32_Transforms, GR32_Filters,
  GR32_Resamplers,
  JclSimpleXML, Forms, JCLShell,StrUtils,registry,
  SharpTypes,
  SharpDeskApi,
  SharpThemeApiEx,
  SharpGraphicsUtils,
  SharpESkinManager,
  SharpIconUtils,
  Contnrs,
  uSharpESkinInterface,
  uISharpETheme,
  uSharpDeskTDeskSettings,
  uSharpDeskFunctions,
  uSharpDeskObjectSettings,
  uSharpDeskDebugging,
  WeatherObjectXMLSettings,
  uWeatherOptions,
  uWeatherParser;

type

  TWeatherSkinItemAlign = (waLeft,waCenter,waRight);

  TWeatherSkinItem = class
    x,y : integer;
    Width, Height : integer;
    DataType : string;
    Data : String;
    Size : integer;
    Alpha : integer;
    Bitmap : TBitmap32;
    Font   : TDeskFont;
    BlendA  : boolean;
    BlendColorA : integer;
    BlendValueA : integer;
    BlendB  : boolean;
    BlendColorB : integer;
    BlendValueB : integer;
    Align : TWeatherSkinItemAlign;
    constructor Create;
    destructor Destroy; override;
  end;

  TWeatherLayer = class(TBitmapLayer)
  private
    FOutput         : TStringList;
    FHLTimer        : TTimer;
    FHLTimerI       : integer;
    FAnimSteps      : integer;
    FLocked         : Boolean;
    FObjectID       : integer;
    FSettings       : TXMLSettings;
    FWeatherParser  : TWeatherParser;
    FParentImage    : TImage32;
    FFontSettings   : TDeskFont;
    FCaptionSettings : TDeskCaption;
    FIconSettings    : TDeskIcon;
    FWeatherSkinItems : TObjectList;
    FWeatherOptions : TWeatherOptions;
    FModX: integer;

  protected
     procedure OnTimer(Sender: TObject);
     
  public
     procedure DrawBitmap;
     procedure BuildOutput;
     function LoadWeatherSkin(skinName : string): boolean;
     procedure RenderWeatherSkin(outBmp : TBitmap32);
     function  ReplaceDataInString(pString : String) : String;
     procedure ReplaceData(var pSList : TStringList);
     procedure ReplaceSpacer(var pSList : TStringList);
     procedure StartHL;
     procedure EndHL;
     procedure LoadSettings(newLocation : string = '');
     procedure OnLocationClick(Sender : TObject);
     constructor Create(ParentImage : Timage32; Id : integer); reintroduce;
     destructor Destroy; override;
     property ObjectID: Integer read FObjectId write FObjectId;
     property Locked : boolean read FLocked write FLocked;
     property ParentImage : TImage32 read FParentImage write FParentImage;
     property WeatherParser : TWeatherParser read FWeatherparser;
  published
     property Settings : TXMLSettings read FSettings;
  end;

type
    pTBitmap32 = ^TBitmap32;


implementation

uses uSharpDeskManager,
     uSharpDeskDesktopObject,
     uSharpDeskObjectSet,
     uSharpDeskObjectSetItem;

constructor TWeatherSkinItem.Create;
begin
  inherited Create;

  Bitmap := nil;
end;

destructor TWeatherSkinItem.Destroy;
begin
  if Assigned(Bitmap) then
    Bitmap.Free;
  Bitmap := nil;
    
  inherited Destroy;
end;

procedure TWeatherLayer.OnLocationClick(Sender : TObject);
var
  ID : integer;
  XML : TJclSimpleXML;
  NewL : String;
begin
  if not (Sender is TMenuItem) then exit;
  ID := TMenuItem(Sender).Tag;

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
    if ID < XML.Root.Items.Count  then
       NewL := XML.Root.Items[ID].Properties.Value('LocationID','error');
  except
  end;
  XML.Free;
  if NewL <> 'error' then
  begin
    FSettings.WeatherLocation := NewL;
    FSettings.SaveSettings(True);
    LoadSettings;
  end;
end;

procedure TWeatherLayer.StartHL;
begin
  if (GetCurrentTheme.Desktop.Animation.UseAnimations) and (not FLocked) then
  begin
    FHLTimerI := 1;
    FHLTimer.Enabled := True;
  end else
  begin
    DrawBitmap;
    if (not FLocked) then SharpGraphicsUtils.LightenBitmap(Bitmap,50);
  end;
end;

procedure TWeatherLayer.EndHL;
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

procedure TWeatherLayer.OnTimer(Sender: TObject);
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

procedure TWeatherLayer.RenderWeatherSkin(outBmp : TBitmap32);
var
  n : integer;
  mx,my : integer;
  pItem : TWeatherSkinItem;
  Bmp : TBitmap32;
begin
  mx := 0;
  my := 0;
  Bmp := TBitmap32.Create;
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
  for n := 0 to FWeatherSkinItems.Count - 1 do
  begin
    pItem := TWeatherSkinItem(FWeatherSkinItems.Items[n]);
    if (Assigned(pItem.Bitmap)) and ((pItem.DataType = 'Image') or (pItem.DataType = 'WeatherImage')) then
    begin
      if pItem.Bitmap.Width + pItem.x > mx then
         mx := pItem.Bitmap.Width + pItem.x;
      if pItem.Bitmap.Height + pItem.y > my then
         my := pItem.Bitmap.Height + pItem.y;
    end else if (pItem.DataType = 'Text') then       
    begin
      if outBmp.TextWidth(pItem.data) + pItem.x > mx then
         mx := outBmp.TextWidth(pItem.data) + pItem.x;
      if outBmp.TextHeight(pItem.data) + pItem.y > my then
         my := outBmp.TextHeight(pItem.data) + pItem.y;
    end else if (pItem.DataType = 'Background') then
    begin
      if pItem.Width + pItem.x > mx then
        mx := pItem.Width + pItem.x;
      if pItem.Height + pItem.y > my then
        my := pItem.Height + pItem.y;
    end;
  end;
  outBmp.SetSize(mx + FModX,my);
  outBmp.Clear(color32(0,0,0,0));
  for n := 0 to FWeatherSkinItems.Count - 1 do
  begin
    pItem := TWeatherSkinItem(FWeatherSkinItems.Items[n]);
    if (Assigned(pItem.Bitmap)) and ((pItem.DataType = 'Image') or (pItem.DataType = 'WeatherImage')) then
    begin
      Bmp.Assign(pItem.Bitmap);
      Bmp.DrawMode := dmBlend;
      Bmp.CombineMode := cmMerge;
      if pItem.BlendA then
         BlendImageA(Bmp,pItem.BlendColorA,pItem.BlendValueA);
      if pItem.BlendB then
         BlendImageA(Bmp,pItem.BlendColorB,pItem.BlendValueB);
      Bmp.MasterAlpha := pItem.alpha;
    end else
    begin
      SharpDeskApi.RenderText(Bmp,pItem.Font,pItem.data,taRight,0);
      Bmp.MasterAlpha := pItem.alpha;
    end;

    case pItem.Align of
      waLeft: Bmp.DrawTo(outBmp,pItem.x,pItem.y);
      waCenter: Bmp.DrawTo(outBmp, pItem.x - Round(Bmp.Width div 2), pItem.y);
      waRight: Bmp.DrawTo(outBmp, pItem.x - Bmp.Width, pItem.y);
    end;
  end;
  Bmp.Free;

end;

function TWeatherLayer.LoadWeatherSkin(skinName : string): boolean;
var
  XML : TJclSimpleXML;
  pItem : TWeatherSkinItem;
  n : integer;
  s : string;
  a : boolean;
  skinDir : string;

  tempBmp: TBitmap32;
begin
  Result := True;

  FWeatherSkinItems.Clear;
  XML := TJclSimpleXML.Create;
  try
    skinDir := SharpAPI.GetSharpeDirectory + 'Skins\Objects\Weather\' + skinName + '\';
    XML.LoadFromFile(skinDir + 'Weather.xml');
  except
    FSettings.CustomFormat := False;
    FSettings.WeatherSkin  := '';
    XML.Free;

    Result := False;
    exit;
  end;

  for n := 0 to XML.Root.Items.Count - 1 do
    if XML.Root.Items.Item[n].Name <> 'Info' then
    begin
      with XML.Root.Items.Item[n].Items do
      begin
        pItem := TWeatherSkinItem.Create;
        pItem.x := MulDiv(IntValue('X',0), Screen.PixelsPerInch, 96);
        pItem.y := MulDiv(IntValue('Y',0), Screen.PixelsPerInch, 96);
        pItem.DataType := Value('DataType','');
        pItem.data  := Value('Data','');
        pItem.data := ReplaceDataInString(pItem.data);
        pItem.alpha := IntValue('Alpha',255);
        pItem.Size := MulDiv(IntValue('Size', 32), Screen.PixelsPerInch, 96);

        s := Value('FontColor',inttostr(FFontSettings.Color));
        pItem.Font.Color := GetCurrentTheme.Scheme.ParseColor(s);

        s := Value('ShadowColor',inttostr(FFontSettings.ShadowColor));
        pItem.Font.ShadowColor := GetCurrentTheme.Scheme.ParseColor(s);

        s := Value('BlendColorA',inttostr(FFontSettings.ShadowColor));
        pItem.BlendColorA := GetCurrentTheme.Scheme.ParseColor(s);

        s := Value('BlendColorB',inttostr(FFontSettings.ShadowColor));
        pItem.BlendColorB := GetCurrentTheme.Scheme.ParseColor(s);

        pItem.Font.Name             := Value('FontName',FFontSettings.Name);
        pItem.Font.Bold             := BoolValue('FontBold',FFontSettings.Bold);
        pItem.Font.Italic           := BoolValue('FontItalic',FFontSettings.Italic);
        pItem.Font.Underline        := BoolValue('FontUnderline',FFontSettings.Underline);
        pItem.Font.ClearType        := BoolValue('ClearType',FFontSettings.ClearType);
        pItem.Font.Alpha            := IntValue('FontAlpha',FFontSettings.Alpha);
        pItem.Font.Size             := MulDiv(IntValue('FontSize',FFontSettings.Size), Screen.PixelsPerInch, 96);
        pItem.Font.ShadowAlphaValue := IntValue('ShadowAlphaValue',FFontSettings.ShadowAlphaValue);
        pItem.Font.Shadow           := BoolValue('FontShadow',FFontSettings.Shadow);
        pItem.BlendA                := BoolValue('BlendA',False);
        pItem.BlendValueA           := IntValue('BlendValueA',255);
        pItem.BlendB                := BoolValue('BlendB',False);
        pItem.BlendValueB           := IntValue('BlendValueB',255);
        pItem.Align                 := TWeatherSkinItemAlign(IntValue('Align', Int64(waLeft)));
        pItem.Width                 := IntValue('Width', 0);
        pItem.Height                := IntValue('Height', 0);

        // Normal image
        if (pItem.DataType = 'Image') and (FileExists(skinDir + pItem.Data)) then
        begin
          pItem.Bitmap := TBitmap32.Create;
          try
            LoadBitmap32FromPNGDPI(pItem.Bitmap, skinDir + pItem.data, a);
          except
            pItem.Bitmap.Free;
            pItem.Bitmap := nil;
          end;
        end;

        // Weather icon
        if (pItem.DataType = 'WeatherImage') then
        begin
          pItem.Bitmap := TBitmap32.Create;
          if not LoadIconFromPNG(pItem.Bitmap, 'Weather\' + FWeatherOptions.IconSet, pItem.Data, pItem.Size) then
          begin
            FreeAndNil(pItem.Bitmap);
          end;
        end;

        FWeatherSkinItems.Add(pItem);
      end;
    end;
  XML.Free;


  FModX := 0;

  tempBmp := TBitmap32.Create;
  for n := 0 to FWeatherSkinItems.Count - 1 do
  begin
    pItem := TWeatherSkinItem(FWeatherSkinItems.Items[n]);
    if (Assigned(pItem.Bitmap)) and ((pItem.DataType = 'Image') or (pItem.DataType = 'WeatherImage')) then
    begin
      tempBmp.Assign(pItem.Bitmap);
      tempBmp.DrawMode := dmBlend;
      tempBmp.CombineMode := cmMerge;
      if pItem.BlendA then
         BlendImageA(tempBmp,pItem.BlendColorA,pItem.BlendValueA);
      if pItem.BlendB then
         BlendImageA(tempBmp,pItem.BlendColorB,pItem.BlendValueB);
      tempBmp.MasterAlpha := pItem.alpha;
    end else
    begin
      SharpDeskApi.RenderText(tempBmp,pItem.Font,pItem.data,taRight,0);
      tempBmp.MasterAlpha := pItem.alpha;
    end;

    case pItem.Align of
      waLeft:
      begin
        if pItem.x < FModX then
          FModX := (pItem.x);
      end;
      waCenter:
      begin
        if pItem.x - Round(tempBmp.Width div 2) < FModX then
          FModX := (pItem.x - Round(tempBmp.Width div 2));
      end;
      waRight:
      begin
        if pItem.x - tempBmp.Width < FModX then
          FModX := (pItem.x - tempBmp.Width);
      end;
    end;
  end;
  tempBmp.Free;

  FModX := -FModX;

  // X Modifier is higher than 0, apply it to all elements
  if FModX > 0 then
  begin
    for n := 0 to FWeatherSkinItems.Count - 1 do
    begin
      TWeatherSkinItem(FWeatherSkinItems.Items[n]).x := TWeatherSkinItem(FWeatherSkinItems.Items[n]).x + FModX;
    end;
  end;
end;

procedure TWeatherLayer.BuildOutput;
var
 IconSpacer : String;
 Icon       : String;
begin
  try
    FOutput.Clear;
    if FSettings.WeatherSkin <> '' then
    begin
      if not LoadWeatherSkin(FSettings.WeatherSkin) then
      begin
        FSettings.CustomFormat := False;
        FSettings.WeatherSkin := '';
      end;
    end else
    if FSettings.CustomFormat then
    begin
      FOutput.CommaText := FSettings.CustomData;
    end else
    begin
      IconSpacer := '';

      if FSettings.ShowCaption then
      begin
        if FSettings.Location then
        begin
          if not FSettings.DetailedLocation then
            FOutput.Add(Icon + IconSpacer + 'Location : {#LOCATION#}')
          else
            FOutput.Add(IconSpacer + 'Location : {#LOCATION#}'+' ('+'{#LATITUE#},{#LONGITUDE#}'+')');
        end;
        if FSettings.Temperature then
          FOutput.Add(IconSpacer + 'Temperature : {#TEMPERATURE#}'+' °'+'{#UNITTEMP#}');
        if FSettings.Wind then
          FOutput.Add(IconSpacer +  'Wind : {#WINDSPEED#} {#UNITSPEED#}');
        if FSettings.Condition then
          FOutput.Add(IconSpacer +  'Condition : {#CONDITION#}');
      end;
    end;

    if FOutput.Count = 0 then
      FOutput.Add('No data selected');
    ReplaceData(FOutput);
    ReplaceSpacer(FOutput);
  except
    SharpApi.SendDebugMessageEx('Weather.object','failed to build output',clred,DMT_ERROR);
  end;
end;

procedure TWeatherLayer.ReplaceSpacer(var pSList : TStringList);
var
  n , k : integer;
  sb,sa : String;
  maxpos : integer;
  maxwidth : integer;
begin
  maxwidth := 0;
  maxpos := 0;
  for n := 0 to pSList.Count - 1 do
      if length(pSList[n]) = 0 then
         pSList[n] := ' ';  
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

function GetAverageTemp(High, Low: String): string;
var
  iLow, iHigh: integer;
begin
  Result := '';
  if (TryStrToInt(High, iHigh)) and (TryStrToInt(Low, iLow)) then
    Result := IntToStr((iHigh + iLow) div 2);
end;

function TWeatherLayer.ReplaceDataInString(pString : String) : String;
var
  n : integer;
  d : string;
begin
  pString := StringReplace(pString,'{#FC_LASTUPDATE#}', FWeatherParser.wxml.Forecast.LastUpdated,[rfReplaceAll,rfIgnoreCase]);
  for n := 0 to High(FWeatherParser.wxml.Forecast.Days) do
  begin
    d := inttostr(n);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAY_CONDITION#}',      FWeatherParser.wxml.Forecast.Days[n].Day.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAY_DAYICON#}',        uWeatherParser.GetWeatherIcon(FWeatherParser.wxml.Forecast.Days[n].Day.IconCode),[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAY_HUMIDITY#}',       FWeatherParser.wxml.Forecast.Days[n].Day.Humidity,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAY_PRECIPITATION#}',  FWeatherParser.wxml.Forecast.Days[n].Day.PercentChancePrecip,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAY_WIND_DIRDEG#}',    FWeatherParser.wxml.Forecast.Days[n].Day.Wind.DirAsDegr,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAY_WIND_DIRTEXT#}',   FWeatherParser.wxml.Forecast.Days[n].Day.Wind.DirAsTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAY_WIND_MAXSPEED#}',  FWeatherParser.wxml.Forecast.Days[n].Day.Wind.MaxWindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAY_WIND_SPEED#}',     FWeatherParser.wxml.Forecast.Days[n].Day.Wind.WindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_NIGHT_CONDITION#}',    FWeatherParser.wxml.Forecast.Days[n].Night.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_NIGHT_DAYICON#}',      uWeatherParser.GetWeatherIcon(FWeatherParser.wxml.Forecast.Days[n].Night.IconCode),[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_NIGHT_HUMIDITY#}',     FWeatherParser.wxml.Forecast.Days[n].Night.Humidity,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_NIGHT_PRECIPITATION#}',FWeatherParser.wxml.Forecast.Days[n].Night.PercentChancePrecip,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_NIGHT_WIND_DIRDEG#}',  FWeatherParser.wxml.Forecast.Days[n].Night.Wind.DirAsDegr,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_NIGHT_WIND_DIRTEXT#}', FWeatherParser.wxml.Forecast.Days[n].Night.Wind.DirAsTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_NIGHT_WIND_MAXSPEED#}',FWeatherParser.wxml.Forecast.Days[n].Night.Wind.MaxWindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_NIGHT_WIND_SPEED#}',   FWeatherParser.wxml.Forecast.Days[n].Night.Wind.WindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DAYTEXT#}',            FWeatherParser.wxml.Forecast.Days[n].DayText,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_DATE#}',               FWeatherParser.wxml.Forecast.Days[n].Date,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_HIGHTEMP#}',           FWeatherParser.wxml.Forecast.Days[n].HighTemp,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_LOWTEMP#}',            FWeatherParser.wxml.Forecast.Days[n].LowTemp,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_TIMESUNSET#}',         FWeatherParser.wxml.Forecast.Days[n].TimeSunset,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+d+'_TIMESUNRISE#}',        FWeatherParser.wxml.Forecast.Days[n].TimeSunrise,[rfReplaceAll,rfIgnoreCase]);

    pString := StringReplace(pString,'{#FC_D'+d+'_TEMPERATURE#}',        GetAverageTemp(FWeatherParser.wxml.Forecast.Days[n].HighTemp, FWeatherParser.wxml.Forecast.Days[n].LowTemp),[rfReplaceAll,rfIgnoreCase]);

    if n = 0 then
      pString := StringReplace(pString,'{#FC_D'+d+'_DAYTEXT2#}',         'Today',[rfReplaceAll,rfIgnoreCase])
    else if n = 1 then
      pString := StringReplace(pString,'{#FC_D'+d+'_DAYTEXT2#}',         'Tomorrow',[rfReplaceAll,rfIgnoreCase])
    else
      pString := StringReplace(pString,'{#FC_D'+d+'_DAYTEXT2#}',         FWeatherParser.wxml.Forecast.Days[n].DayText,[rfReplaceAll,rfIgnoreCase]);
  end;

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
  pString := StringReplace(pString,'{#MOONICON#}',    uWeatherParser.GetWeatherIcon(FWeatherParser.wxml.CurrentCondition.Moon.IconCode),[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#MOONTEXT#}',    FWeatherParser.wxml.CurrentCondition.Moon.MoonText,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#VISIBILITY#}',  FWeatherParser.wxml.CurrentCondition.Visibility,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#DEWPOINT#}',    FWeatherParser.wxml.CurrentCondition.Dewpoint,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#LASTUPDATE#}',  FWeatherParser.wxml.CurrentCondition.DateTimeLastUpdate,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#HUMIDITY#}',    FWeatherParser.wxml.CurrentCondition.Humidity,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#ICON#}',        uWeatherParser.GetWeatherIcon(FWeatherParser.wxml.CurrentCondition.IconCode),[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#CONDITION#}',   FWeatherParser.wxml.CurrentCondition.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#OBSSTATION#}',  FWeatherParser.wxml.CurrentCondition.ObservationStation,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#DAYTEXT#}',     FWeatherParser.wxml.Forecast.Days[0].DayText,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#DAYTEXT2#}',    'Today',[rfReplaceAll,rfIgnoreCase]);
  result := pString;
end;

procedure TWeatherLayer.ReplaceData(var pSList : TStringList);
var
   n : integer;
begin
  for n := 0 to pSList.Count - 1 do
      pSList[n] := ReplaceDataInString(pSList[n]);
end;     

procedure TWeatherLayer.DrawBitmap;
var
  R : TFloatrect;
  w,h : integer;
  Bmp : Tbitmap32;
begin
  //Say to Image that we will update
  FParentImage.BeginUpdate;
  BeginUpdate;

  if FSettings.WeatherSkin <> '' then
  begin
    FCaptionSettings.Caption.Clear;

    RenderWeatherSkin(FIconSettings.Icon);
  end;

  Bmp := TBitmap32.Create;
  Bmp.DrawMode := dmBlend;
  Bmp.CombineMode := cmMerge;
  SharpDeskApi.RenderObject(Bmp,
                            FIconSettings,
                            FFontSettings,
                            FCaptionSettings,
                            Point(0,0),
                            Point(0,0));

  Bitmap.SetSize(Bmp.Width, Bmp.Height);
  Bitmap.Clear(color32(0,0,0,0));
  Bitmap.Draw(0,0,Bmp);

  Bmp.Free;

  w := Bitmap.Width;
  h := Bitmap.Height;
  
  R := getadjustedlocation;
  if (w <> (R.Right-R.left)) then   //dont move image if resize
    R.Left := R.left + round(((R.Right-R.left)- w)/2);
  if (h <> (R.Bottom-R.Top)) then   //dont move image if resize
    R.Top := R.Top + round(((R.Bottom-R.Top)-h)/2);
  R.Right := r.Left + w;
  R.Bottom := r.Top + h;
  location := R;

  //Seems like it must be said sometimes
  Bitmap.DrawMode := dmBlend;

  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;

procedure TWeatherLayer.LoadSettings(newLocation : string);
var
  bmp : TBitmap32;
  Filename : string;
begin
  if ObjectID = 0 then
    exit;

  // Load service settings
  FWeatherOptions.LoadSettings;

  FOutput.Clear;
  FSettings.LoadSettings;

  if newLocation <> '' then
    FSettings.WeatherLocation := newLocation;

  FWeatherParser.Update(FSettings.WeatherLocation);

  FFontSettings.Name             := FSettings.Theme[DS_FONTNAME].Value;
  FFontSettings.Size             := FSettings.Theme[DS_TEXTSIZE].IntValue;
  FFontSettings.Color            := GetCurrentTheme.Scheme.SchemeCodeToColor(FSettings.Theme[DS_TEXTCOLOR].IntValue);
  FFontSettings.Bold             := FSettings.Theme[DS_TEXTBOLD].BoolValue;
  FFontSettings.Italic           := FSettings.Theme[DS_TEXTITALIC].BoolValue;
  FFontSettings.Underline        := FSettings.Theme[DS_TEXTUNDERLINE].BoolValue;
  FFontSettings.ClearType        := FSettings.Theme[DS_TEXTCLEARTYPE].BoolValue;
  FFontSettings.ShadowColor      := GetCurrentTheme.Scheme.SchemeCodeToColor(FSettings.Theme[DS_TEXTSHADOWCOLOR].IntValue);
  FFontSettings.ShadowAlphaValue := FSettings.Theme[DS_TEXTSHADOWALPHA].IntValue;
  FFontSettings.Shadow           := FSettings.Theme[DS_TEXTSHADOW].BoolValue;
  FFontSettings.TextAlpha        := FSettings.Theme[DS_TEXTALPHA].BoolValue;
  FFontSettings.Alpha            := FSettings.Theme[DS_TEXTALPHAVALUE].IntValue;
  FFontSettings.ShadowType       := FSettings.Theme[DS_TEXTSHADOWTYPE].IntValue;
  FFontSettings.ShadowSize       := FSettings.Theme[DS_TEXTSHADOWSIZE].IntValue;

  BuildOutput;

  FCaptionSettings.Caption.Clear;
  FCaptionSettings.Caption.AddStrings(FOutput);

  //FCaptionSettings.Align := IntToTextAlign(FSettings.CaptionAlign);
  FCaptionSettings.Xoffset := 0;
  FCaptionSettings.Yoffset := 0;
  FCaptionSettings.Draw := FSettings.ShowCaption;
  FCaptionSettings.LineSpace := 0;
  FCaptionSettings.Align := taRight;

  FIconSettings.Size  := 100;

  FIconSettings.Alpha := 255;
  if FSettings.Theme[DS_ICONALPHABLEND].BoolValue then
    FIconSettings.Alpha := FSettings.Theme[DS_ICONALPHA].IntValue;
  FIconSettings.XOffset := 0;
  FIconSettings.YOffset := 0;

  FIconSettings.Blend       := FSettings.Theme[DS_ICONBLENDING].BoolValue;
  FIconSettings.BlendColor  := GetCurrentTheme.Scheme.SchemeCodeToColor(FSettings.Theme[DS_ICONBLENDCOLOR].IntValue);
  FIconSettings.BlendValue  := FSettings.Theme[DS_ICONBLENDALPHA].IntValue;
  FIconSettings.Shadow      := FSettings.Theme[DS_ICONSHADOW].BoolValue;
  FIconSettings.ShadowColor := GetCurrentTheme.Scheme.SchemeCodeToColor(FSettings.Theme[DS_ICONSHADOWCOLOR].IntValue);
  FIconSettings.ShadowAlpha := 255 - FSettings.Theme[DS_ICONSHADOWALPHA].IntValue;

  if FSettings.Theme[DS_ICONSIZE].IntValue <= 8 then
    FSettings.Theme[DS_ICONSIZE].IntValue := 61;

  if FIconSettings.Icon <> nil then
  begin
    bmp := TBitmap32.Create;
    bmp.DrawMode := dmBlend;

    Filename := SharpAPI.GetSharpeDirectory + 'Icons\Weather\' + FWeatherOptions.IconSet + '\' +
                IntToStr(GetNearestIconSize(FSettings.Theme[DS_ICONSIZE].IntValue)) + '\' +
                uWeatherParser.GetWeatherIcon(FWeatherParser.wxml.CurrentCondition.IconCode);
    if FileExists(Filename) then
      LoadPng(bmp, Filename);

    FIconSettings.Icon.SetSize(FSettings.Theme[DS_ICONSIZE].IntValue, FSettings.Theme[DS_ICONSIZE].IntValue);
    FIconSettings.Icon.Clear(color32(0,0,0,0));
    bmp.DrawTo(FIconSettings.Icon, Rect(0, 0, FIconSettings.Icon.Width, FIconSettings.Icon.Height));

    bmp.Free;
  end;

  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);   

  DrawBitmap;
end;

constructor TWeatherLayer.Create( ParentImage:Timage32; Id : integer);
begin
  Inherited Create(ParentImage.Layers);
  FHLTimer := TTimer.Create(nil);
  FHLTimer.Interval := 20;
  FHLTimer.Tag      := 0;
  FHLTimer.Enabled := False;
  FHLTimer.OnTimer := OnTimer;
  FAnimSteps      := 5;
  FOutput         := TStringList.Create;
  FWeatherSkinItems := TObjectList.Create;
  FWeatherSkinItems.OwnsObjects := True;
  FParentImage := ParentImage;
  Alphahit := False;
  FObjectId := id;
  scaled := False;
  FWeatherParser := TWeatherParser.Create;

  FWeatherOptions := TWeatherOptions.Create;

  FSettings := TXMLSettings.Create(FObjectId, nil, 'Weather');

  FCaptionSettings.Caption := TStringList.Create;
  FCaptionSettings.Caption.Clear;
  FIconSettings.Icon := TBitmap32.Create;

  LoadSettings;
end;

destructor TWeatherLayer.Destroy;
begin
  DebugFree(FCaptionSettings.Caption);
  DebugFree(FIconSettings.Icon);

  DebugFree(FWeatherParser);
  DebugFree(FSettings);
  DebugFree(FOutput);
  DebugFree(FHLTimer);
  FWeatherSkinItems.Clear;
  DebugFree(FWeatherSkinItems);
  FreeAndNil(FWeatherOptions);
  inherited;
end;

end.
