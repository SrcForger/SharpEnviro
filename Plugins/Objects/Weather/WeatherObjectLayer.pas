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
  gr32_png,gr32,pngimage,GR32_Image, GR32_Layers, GR32_BLEND,GR32_Transforms, GR32_Filters,
  JclSimpleXML, Forms, JCLShell,StrUtils,registry,
  SharpTypes,
  SharpDeskApi,
  SharpThemeApiEx,
  SharpGraphicsUtils,
  SharpESkinManager,
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

  TWeatherIcon = class
                   x,yn : integer;
                   iBitmap : TBitmap32;
                 end;

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
    FIconList       : array of TWeatherIcon;
    FLocked         : Boolean;
    FShadow         : Boolean;
    FShadowColor    : integer;
    FShadowAlpha    : integer;
    FObjectID       : integer;
    FSettings       : TXMLSettings;
    FWeatherParser  : TWeatherParser;
    FParentImage    : TImage32;
    FFontSettings   : TDeskFont;
    FWeatherSkinItems : TObjectList;

  protected
     procedure OnTimer(Sender: TObject);  
  public
     procedure DrawBitmap;
     procedure BuildOutput;
     procedure LoadWeatherSkin(filename : string);
     procedure RenderWeatherSkin;
     procedure ReplaceIcons(var pSList : TStringList);
     function  ReplaceDataInString(pString : String) : String;
     procedure ReplaceData(var pSList : TStringList);
     procedure ReplaceSpacer(var pSList : TStringList);
     procedure StartHL;
     procedure EndHL;
     function  GetSize(var pSList : TStringList) : TPoint;
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
    if (FSettings.UseThemeSettings) and (FSettings.Theme[DS_ICONALPHABLEND].BoolValue) then
       i := FSettings.Theme[DS_ICONALPHA].IntValue
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
  if Theme.Desktop.Animation.Alpha then
  begin
    if (FSettings.UseThemeSettings) and (FSettings.Theme[DS_ICONALPHABLEND].BoolValue) then
       i := FSettings.Theme[DS_ICONALPHA].IntValue
        else if FSettings.AlphaBlend then i := FSettings.AlphaValue
             else i := 255;
    i := i + round(((Theme.Desktop.Animation.AlphaValue/FAnimSteps)*FHLTimer.Tag));
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
  if Theme.Desktop.Animation.Brightness then
     LightenBitmap(Bitmap,round(FHLTimer.Tag*(Theme.Desktop.Animation.BrightnessValue/FAnimSteps)));
  if Theme.Desktop.Animation.Blend then
     BlendImageA(Bitmap,Theme.Desktop.Animation.BlendColor,round(FHLTimer.Tag*(Theme.Desktop.Animation.BlendValue/FAnimSteps)));
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
      SharpDeskApi.RenderText(Bmp,pItem.Font,pItem.data,0,0);
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
          LoadBitmap32FromPNG(pItem.Bitmap,IncludeTrailingBackslash(ExtractFileDir(filename))+pItem.data, a);
          pItem.Bitmap.Clear(color32(0,0,0,0));
        end;
        FWeatherSkinItems.Add(pItem);
      end;
    end;
  XML.Free;
end;

procedure TWeatherLayer.ReplaceIcons(var pSList : TStringList);
var
  b : boolean;
  n,k : integer;
  FileName : String;
  sb : String;
begin
  for n := 0 to High(FIconList) do
  begin
    DebugFree(FIconList[n].iBitmap);
    DebugFree(FIconList[n]);
  end;
  setlength(FIconList,0);

  for n := 0 to pSList.Count - 1 do
  begin
    k := pos('{#MOONICON#}',pSList[n]);
    while k > 0 do
    begin
      setlength(FIconList,length(FIconList)+1);
      FIconList[High(FIconList)] := TWeatherIcon.Create;
      with FIconList[High(FIconList)] do
      begin
        yn := n;
        sb := LeftStr(pSList[n],k-1);
        x  := Bitmap.TextWidth(sb);
        iBitmap := TBitmap32.Create;
        iBitmap.DrawMode := dmBlend;
        FileName := SharpApi.GetSharpeDirectory
                    + 'Icons\Weather\61x61\'
                    + inttostr(strtoint(FWeatherParser.wxml.CurrentCondition.Moon.IconCode)+1)
                    + '.png';                   
        if FileExists(FileName) then
        begin
          LoadBitmap32FromPNG(iBitmap,FileName,b);
        end else
        begin
          iBitmap.SetSize(32,32);
          iBitmap.Clear(color32(64,64,64,64));
        end;
        pSList[n] := StringReplace(pSList[n],'{#MOONICON#}','',[rfIgnoreCase]);
      end;
      k := pos('{#MOONICON#}',pSList[n]);
    end;

    k := pos('{#ICON#}',pSList[n]);
    while k > 0 do
    begin
      setlength(FIconList,length(FIconList)+1);
      FIconList[High(FIconList)] := TWeatherIcon.Create;
      with FIconList[High(FIconList)] do
      begin
        yn := n;
        sb := LeftStr(pSList[n],k-1);
        x  := Bitmap.TextWidth(sb);
        iBitmap := TBitmap32.Create;
        iBitmap.DrawMode := dmBlend;
        FileName := SharpApi.GetSharpeDirectory
                    + 'Icons\Weather\61x61\'
                    + inttostr(strtoint(FWeatherParser.wxml.CurrentCondition.IconCode))
                    + '.png';
        if FileExists(FileName) then
        begin
          LoadBitmap32FromPNG(iBitmap,FileName,b);
        end else
        begin
          iBitmap.SetSize(32,32);
          iBitmap.Clear(color32(64,64,64,64));
        end;
        pSList[n] := StringReplace(pSList[n],'{#ICON#}','                    ',[rfIgnoreCase]);
      end;
      k := pos('{#ICON#}',pSList[n]);
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
      if FSettings.DisplayIcon then
      begin
        FOutput.Add('{#ICON#}');
        IconSpacer := '                    ';
      end else IconSpacer := '';

      if FSettings.Location then
      begin
        if not FSettings.DetailedLocation then FOutput.Add(Icon + IconSpacer + 'Location : {#LOCATION#}')
           else FOutput.Add(IconSpacer + 'Location : {#LOCATION#}'+' ('+'{#LATITUE#},{#LONGITUDE#}'+')');
      end;
      if FSettings.Temperature then
         FOutput.Add(IconSpacer + 'Temperature : {#TEMPERATURE#}'+' °'+'{#UNITTEMP#}');
      if FSettings.Wind then
         FOutput.Add(IconSpacer +  'Wind : {#WINDSPEED#} {#UNITSPEED#}');
      if FSettings.Condition then
         FOutput.Add(IconSpacer +  'Condition : {#CONDITION#}');
    end;

    if FOutput.Count = 0 then
      FOutput.Add('No data selected');
    ReplaceIcons(FOutput);
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
  for n := 0 to High(FIconList) do
      if FIconList[n].x + FIconList[n].iBitmap.Width > w then
         w := FIconList[n].x + FIconList[n].iBitmap.Width; 
  result := Point(w,h);
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
 n : integer;
 eh : integer;
 size : TPoint;
 Bmp : Tbitmap32;
begin
  //Say to Image that we will update
  FParentImage.BeginUpdate;
  BeginUpdate;

  if FSettings.WeatherSkin <> '' then
  begin
    RenderWeatherSkin;
    if FSettings.ColorBlend then
       BlendImageA(Bitmap,FSettings.BlendColor,FSettings.BlendValue);
    w := Bitmap.Width;
    h := Bitmap.Height;
  end else
  begin
    Size := GetSize(FOutput);

    Bitmap.Clear(color32(0,0,0,0));

    bmp := TBitmap32.Create;
    bmp.DrawMode := dmBlend;
    bmp.CombineMode := cmMerge;
    try
      SharpDeskApi.RenderText(bmp,FFontSettings,FOutput,-1,FSettings.Spacing);
    except
      SharpApi.SendDebugMessageEx('Weather.dll','Failed to render output',clred,DMT_ERROR);
    end;

    w := Bmp.Width;
    h := Bmp.Height;
    eh := Bitmap.TextHeight('!"§$%&/()=?`°QWERTZUIOPÜASDFGHJJKLÖÄYXCVBNqp1234567890');
    eh := eh + FSettings.Spacing;
    for n := 0 to High(FIconList) do
        if FIconList[n].yn*eh + FIconList[n].iBitmap.Height > h then
           h := FIconList[n].yn*eh + FIconList[n].iBitmap.Height;
    Bitmap.SetSize(w,h);
    //bmp.MasterAlpha := 128;
    bmp.DrawTo(Bitmap,0,0);
    bmp.free;

    for n := 0 to High(FIconList) do
      with FIconList[n] do
           iBitmap.DrawTo(Bitmap, x, yn * eh);

    if ((FSettings.ColorBlend) and (not FSettings.UseThemeSettings))
       or ((FSettings.UseThemeSettings) and (GetCurrentTheme.Desktop.Animation.Blend)) then
       BlendImageA(Bitmap,FSettings.BlendColor,FSettings.BlendValue);
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

  if not HasVisiblePixel(Bitmap) then
  begin
    Bitmap.SetSize(32,32);
    Bitmap.Clear(color32(128,128,128,128));
  end;

   //
  FParentImage.EndUpdate;
  EndUpdate;
  Changed;
end;

procedure TWeatherLayer.LoadSettings;
begin
  if ObjectID=0 then exit;

  FOutput.Clear;
  FSettings.LoadSettings;
  FWeatherParser.Update(FSettings.WeatherLocation);  

  if FSettings.UseThemeSettings then
     FShadow := GetCurrentTheme.Desktop.Icon.IconShadow
     else FShadow := FSettings.TextShadow;
  FShadowAlpha := GetCurrentTheme.Desktop.Icon.IconShadowAlpha;
  FShadowColor := GetCurrentTheme.Desktop.Icon.IconShadowColor;

  if FSettings.UseThemeSettings then
  begin
    FSettings.BlendValue := GetCurrentTheme.Desktop.Icon.IconBlendAlpha;
    FSettings.BlendColor := GetCurrentTheme.Desktop.Icon.IconBlendColor;
  end else
  begin
    FSettings.BlendColor  := FSettings.BlendColor;
  end;

  if not (Fsettings.UseThemeSettings) then
  begin
    FFontSettings.Name      := FSettings.FontName;
    FFontSettings.Size      := FSettings.FontSize;
    FFontSettings.Color     := FSettings.FontColor;
    FFontSettings.Bold      := FSettings.FontBold;
    FFontSettings.Italic    := FSettings.FontItalic;
    FFontSettings.Underline := FSettings.FontUnderline;
    FFontSettings.AALevel   := 0;
    if FSettings.FontAlpha then
      FFontSettings.Alpha := FSettings.FontAlphaValue
    else
      FFontSettings.Alpha := 255;
    FFontSettings.ShadowColor := FSettings.FontShadowColor;
    FFontSettings.ShadowAlphaValue := FSettings.FontShadowValue;
    FFontSettings.Shadow    := FSettings.FontShadow;
  end else
  begin
    if FSettings.UseThemeSettings then
    begin
      FSettings.AlphaBlend    := GetCurrentTheme.Desktop.Icon.IconBlending;
      FSettings.AlphaValue    := GetCurrentTheme.Desktop.Icon.IconBlendAlpha;
    end;
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
    FFontSettings.ShadowAlphaValue := GetCurrentTheme.Desktop.Icon.IconShadowAlpha;
    if FSettings.UseThemeSettings then
      FFontSettings.Shadow := GetCurrentTheme.Desktop.Icon.TextShadow
    else
      FFontSettings.Shadow := FSettings.TextShadow;
  end;   

  if FSettings.AlphaBlend then
  begin
    Bitmap.MasterAlpha := FSettings.AlphaValue;
    if Bitmap.MasterAlpha < 16 then
      Bitmap.MasterAlpha := 16;
  end else
    Bitmap.MasterAlpha := 255;

  BuildOutput;

  DrawBitmap;
  if FHLTimer.Tag >= FAnimSteps then
     FHLTimer.OnTimer(FHLTimer);   
//  if FBlend then BlendImage(FPicture, FBlendColor,FBlendValue);
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
  LoadSettings;
end;

destructor TWeatherLayer.Destroy;
var
  n : integer;
begin
  DebugFree(FWeatherParser);
  DebugFree(FSettings);
  DebugFree(FOutput);
  DebugFree(FHLTimer);
  FWeatherSkinItems.Clear;
  DebugFree(FWeatherSkinItems);
  for n := 0 to High(FIconList) do
  begin
    DebugFree(FIconList[n].iBitmap);
    DebugFree(FIconList[n]);
  end;
  setlength(FIconList,0);  
  inherited;
end;

end.
