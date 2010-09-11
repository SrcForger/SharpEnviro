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
  uWeatherParser;

type

  TWeatherSkinItem = class
                       x,y : integer;
                       itype : string;
                       data : String;
                       alpha : integer;
                       Bitmap : TBitmap32;
                       Font   : TDeskFont;
                       BlendA  : boolean;
                       BlendColorA : integer;
                       BlendValueA : integer;
                       BlendB  : boolean;
                       BlendColorB : integer;
                       BlendValueB : integer;
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

  protected
     procedure OnTimer(Sender: TObject);
     
  public
     procedure DrawBitmap;
     procedure BuildOutput;
     procedure LoadWeatherSkin(filename : string);
     procedure RenderWeatherSkin;
     function  ReplaceDataInString(pString : String) : String;
     procedure ReplaceData(var pSList : TStringList);
     procedure ReplaceSpacer(var pSList : TStringList);
     procedure StartHL;
     procedure EndHL;
     procedure LoadSettings;
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

destructor TWeatherSkinItem.Destroy;
begin
  if itype = 'image' then Bitmap.Free;
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
    Settings.WeatherLocation := NewL;
    Settings.SaveSettings(True);
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

procedure TWeatherLayer.RenderWeatherSkin;
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
    if pItem.itype = 'image' then
    begin
      if pItem.Bitmap.Width + pItem.x > mx then
         mx := pItem.Bitmap.Width + pItem.x;
      if pItem.Bitmap.Height + pItem.y > my then
         my := pItem.Bitmap.Height + pItem.y;
    end else
    begin
      if Bitmap.TextWidth(pItem.data) + pItem.x > mx then
         mx := Bitmap.TextWidth(pItem.data) + pItem.x;
      if Bitmap.TextHeight(pItem.data) + pItem.y > my then
         my := Bitmap.TextHeight(pItem.data) + pItem.y;
    end;
  end;
  Bitmap.SetSize(mx,my);
  Bitmap.Clear(color32(0,0,0,0));
  for n := 0 to FWeatherSkinItems.Count - 1 do
  begin
    pItem := TWeatherSkinItem(FWeatherSkinItems.Items[n]);
    if pItem.itype = 'image' then
    begin
      Bmp.Assign(pItem.Bitmap);
      Bmp.DrawMode := dmBlend;
      Bmp.CombineMode := cmMerge;
      if pItem.BlendA then
         BlendImageA(Bmp,pItem.BlendColorA,pItem.BlendValueA);
      if pItem.BlendB then
         BlendImageA(Bmp,pItem.BlendColorB,pItem.BlendValueB);
      Bmp.MasterAlpha := pItem.alpha;
      Bmp.DrawTo(Bitmap,pItem.x,pItem.y);
    end else
    begin
      SharpDeskApi.RenderText(Bmp,pItem.Font,pItem.data,taRight,0);
      Bmp.MasterAlpha := pItem.alpha;
      Bmp.DrawTo(Bitmap,pItem.x,pItem.y);
    end;
  end;
  Bmp.Free;

end;

function ParseColor(s : String; failurecolor : integer) : integer;
var
  Theme : ISharpETheme;
  SkinInterface : TSharpESkinInterface;
begin
  Theme := GetCurrentTheme;

  result := 0;

  SkinInterface := TSharpESkinInterface.Create(nil, ALL_SHARPE_SKINS);
  try
    s := StringReplace(s,'Throbberback',inttostr(SkinInterface.SkinManager.Scheme.GetColorByName('Throbberback')),[rfIgnoreCase]);
    s := StringReplace(s,'Throbberdark',inttostr(SkinInterface.SkinManager.Scheme.GetColorByName('Throbberdark')),[rfIgnoreCase]);
    s := StringReplace(s,'Throbberlight',inttostr(SkinInterface.SkinManager.Scheme.GetColorByName('Throbberlight')),[rfIgnoreCase]);
    s := StringReplace(s,'Throbbetext',inttostr(SkinInterface.SkinManager.Scheme.GetColorByName('ThrobberText')),[rfIgnoreCase]);
    s := StringReplace(s,'WorkAreaback',inttostr(SkinInterface.SkinManager.Scheme.GetColorByName('WorkAreaback')),[rfIgnoreCase]);
    s := StringReplace(s,'WorkAreadark',inttostr(SkinInterface.SkinManager.Scheme.GetColorByName('WorkAreadark')),[rfIgnoreCase]);
    s := StringReplace(s,'WorkArealight',inttostr(SkinInterface.SkinManager.Scheme.GetColorByName('WorkArealight')),[rfIgnoreCase]);
    s := StringReplace(s,'WorkAreatext',inttostr(SkinInterface.SkinManager.Scheme.GetColorByName('WorkAreaText')),[rfIgnoreCase]);
    try
      result := strtoint(s);
    except
      result := failurecolor;
    end;
  except
  end;
end;

procedure TWeatherLayer.LoadWeatherSkin(filename : string);
var
  XML : TJclSimpleXML;
  pItem : TWeatherSkinItem;
  n : integer;
  s : string;
  a : boolean;
begin
  FWeatherSkinItems.Clear;
  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(filename);
  except
    FSettings.CustomFormat := False;
    FSettings.WeatherSkin  := '';
    XML.Free;
    exit;
  end;
  
  for n := 0 to XML.Root.Items.Count - 1 do
    if XML.Root.Items.Item[n].Name = 'Item' then
    begin
      with XML.Root.Items.Item[n].Items do
      begin
        pItem := TWeatherSkinItem.Create;
        pItem.x := IntValue('x',0);
        pItem.y := IntValue('y',0);
        pItem.itype := lowercase(Value('type',''));
        pItem.data  := Value('data','');
        pItem.data := ReplaceDataInString(pItem.data);
        pItem.alpha := IntValue('alpha',255);

        s := Value('fontcolor',inttostr(FFontSettings.Color));
        pItem.Font.Color := ParseColor(s,FFontsettings.Color);

        s := Value('shadowcolor',inttostr(FFontSettings.ShadowColor));
        pItem.Font.ShadowColor := ParseColor(s,FFontsettings.Color);

        s := Value('blendcolorA',inttostr(FFontSettings.ShadowColor));
        pItem.BlendColorA := ParseColor(s,FFontsettings.Color);

        s := Value('blendcolorB',inttostr(FFontSettings.ShadowColor));
        pItem.BlendColorB := ParseColor(s,FFontsettings.Color);

        pItem.Font.Name             := Value('fontname',FFontSettings.Name);
        pItem.Font.Bold             := BoolValue('fontbold',FFontSettings.Bold);
        pItem.Font.Italic           := BoolValue('fontitalic',FFontSettings.Italic);
        pItem.Font.Underline        := BoolValue('fontunderline',FFontSettings.Underline);
        pItem.Font.AALevel          := IntValue('fontaa',FFontSettings.AALevel);
        pItem.Font.Alpha            := IntValue('fontalpha',FFontSettings.Alpha);
        pItem.Font.Size             := IntValue('fontsize',FFontSettings.Size);
        pItem.Font.ShadowAlphaValue := IntValue('shadowalphavalue',FFontSettings.ShadowAlphaValue);
        pItem.Font.Shadow           := BoolValue('fontshadow',FFontSettings.Shadow);
        pItem.BlendA                := BoolValue('blendA',False);
        pItem.BlendValueA           := IntValue('blendvalueA',255);
        pItem.BlendB                := BoolValue('blendB',False);
        pItem.BlendValueB           := IntValue('blendvalueB',255);
        if pItem.itype = 'image' then
        begin
          pItem.Bitmap := TBitmap32.Create;
          {$WARN SYMBOL_PLATFORM OFF} LoadBitmap32FromPNG(pItem.Bitmap,IncludeTrailingBackslash(ExtractFileDir(filename))+pItem.data, a); {$WARN SYMBOL_PLATFORM ON}
          pItem.Bitmap.Clear(color32(0,0,0,0));
        end;
        FWeatherSkinItems.Add(pItem);
      end;
    end;
  XML.Free;
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
      if FileExists(SharpApi.GetSharpeDirectory + 'Skins\Objects\Weather\' + FSettings.WeatherSkin + 'Skin.xml') then
         LoadWeatherSkin(SharpApi.GetSharpeDirectory + 'Skins\Objects\Weather\' + FSettings.WeatherSkin + 'Skin.xml')
      else
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

      if FSettings.DisplayCaption then
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

function TWeatherLayer.ReplaceDataInString(pString : String) : String;
var
  n : integer;
begin
  pString := StringReplace(pString,'{#FC_LASTUPDATE#}', FWeatherParser.wxml.Forecast.LastUpdated,[rfReplaceAll,rfIgnoreCase]);
  for n := 0 to High(FWeatherParser.wxml.Forecast.Days) do
  begin
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_CONDITION#}',      FWeatherParser.wxml.Forecast.Days[n].Day.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_DAYICON#}',        FWeatherParser.wxml.Forecast.Days[n].Day.IconCode,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_HUMIDITY#}',       FWeatherParser.wxml.Forecast.Days[n].Day.Humidity,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_PRECIPITATION#}',  FWeatherParser.wxml.Forecast.Days[n].Day.PercentChancePrecip,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_WIND_DIRDEG#}',    FWeatherParser.wxml.Forecast.Days[n].Day.Wind.DirAsDegr,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_WIND_DIRTEXT#}',   FWeatherParser.wxml.Forecast.Days[n].Day.Wind.DirAsTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_WIND_MAXSPEED#}',  FWeatherParser.wxml.Forecast.Days[n].Day.Wind.MaxWindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_WIND_SPEED#}',     FWeatherParser.wxml.Forecast.Days[n].Day.Wind.WindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_CONDITION#}',    FWeatherParser.wxml.Forecast.Days[n].Night.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_DAYICON#}',      FWeatherParser.wxml.Forecast.Days[n].Night.IconCode,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_HUMIDITY#}',     FWeatherParser.wxml.Forecast.Days[n].Night.Humidity,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_PRECIPITATION#}',FWeatherParser.wxml.Forecast.Days[n].Night.PercentChancePrecip,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_WIND_DIRDEG#}',  FWeatherParser.wxml.Forecast.Days[n].Night.Wind.DirAsDegr,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_WIND_DIRTEXT#}', FWeatherParser.wxml.Forecast.Days[n].Night.Wind.DirAsTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_WIND_MAXSPEED#}',FWeatherParser.wxml.Forecast.Days[n].Night.Wind.MaxWindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_WIND_SPEED#}',   FWeatherParser.wxml.Forecast.Days[n].Night.Wind.WindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAYTEXT#}',            FWeatherParser.wxml.Forecast.Days[n].DayText,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DATE#}',               FWeatherParser.wxml.Forecast.Days[n].Date,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_HIGHTEMP#}',           FWeatherParser.wxml.Forecast.Days[n].HighTemp,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_LOWTEMP#}',            FWeatherParser.wxml.Forecast.Days[n].LowTemp,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_TIMESUNSET#}',         FWeatherParser.wxml.Forecast.Days[n].TimeSunset,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_TIMESUNRISE#}',        FWeatherParser.wxml.Forecast.Days[n].TimeSunrise,[rfReplaceAll,rfIgnoreCase]);
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
//  pString := StringReplace(pString,'{#MOONICON#}',    FWeatherParser.wxml.CurrentCondition.Moon.IconCode,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#MOONTEXT#}',    FWeatherParser.wxml.CurrentCondition.Moon.MoonText,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#VISIBILITY#}',  FWeatherParser.wxml.CurrentCondition.Visibility,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#DEWPOINT#}',    FWeatherParser.wxml.CurrentCondition.Dewpoint,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#LASTUPDATE#}',  FWeatherParser.wxml.CurrentCondition.DateTimeLastUpdate,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#HUMIDITY#}',    FWeatherParser.wxml.CurrentCondition.Humidity,[rfReplaceAll,rfIgnoreCase]);
//  pString := StringReplace(pString,'{#ICON#}',        FWeatherParser.wxml.CurrentCondition.IconCode,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#CONDITION#}',   FWeatherParser.wxml.CurrentCondition.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
  pString := StringReplace(pString,'{#OBSSTATION#}',  FWeatherParser.wxml.CurrentCondition.ObservationStation,[rfReplaceAll,rfIgnoreCase]);
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
    RenderWeatherSkin;
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

  if FLocked then
  begin
    w := (Bitmap.Width) div 100;
    h := (Bitmap.Height) div 100;
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

  //Seems like it must be said sometimes
  Bitmap.DrawMode := dmBlend;

  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;

procedure TWeatherLayer.LoadSettings;
var
  bmp : TBitmap32;
  Filename : string;
begin
  if ObjectID = 0 then
    exit;

  FOutput.Clear;
  FSettings.LoadSettings;
  FWeatherParser.Update(FSettings.WeatherLocation);  

  FFontSettings.Name             := FSettings.Theme[DS_FONTNAME].Value;
  FFontSettings.Size             := FSettings.Theme[DS_TEXTSIZE].IntValue;
  FFontSettings.Color            := GetCurrentTheme.Scheme.SchemeCodeToColor(FSettings.Theme[DS_TEXTCOLOR].IntValue);
  FFontSettings.Bold             := FSettings.Theme[DS_TEXTBOLD].BoolValue;
  FFontSettings.Italic           := FSettings.Theme[DS_TEXTITALIC].BoolValue;
  FFontSettings.Underline        := FSettings.Theme[DS_TEXTUNDERLINE].BoolValue;
  FFontSettings.AALevel          := 0;
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
  FCaptionSettings.Draw := FSettings.DisplayCaption;
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

    Filename := SharpAPI.GetSharpeDirectory + 'Icons\Weather\Default\' + IntToStr(FSettings.Theme[DS_ICONSIZE].IntValue) + '\' + uWeatherParser.GetWeatherIcon(FWeatherParser.wxml.CurrentCondition.IconCode);
    if FileExists(Filename) then
      LoadPng(bmp, Filename);

    FIconSettings.Icon.SetSize(bmp.Width, bmp.Height);
    FIconSettings.Icon.Clear(color32(0,0,0,0));
    bmp.DrawTo(FIconSettings.Icon, Rect(0, 0, bmp.Width, bmp.Height));

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
  FParentImage := ParentImage;
  Alphahit := False;
  FObjectId := id;
  scaled := False;
  FWeatherParser := TWeatherParser.Create;
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
  inherited;
end;

end.
