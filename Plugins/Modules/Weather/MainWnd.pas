{
Source Name: MainWnd
Description: Weather  module main window
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpEBaseControls,
  SharpEScheme, SharpTypes, ExtCtrls, GR32,
  JclSimpleXML, SharpApi, Menus, Math, SharpESkinLabel,
  uWeatherParser, GR32_Image, uISharpBarModule, SharpNotify, ISharpESkinComponents;


type
  TMainForm = class(TForm)
    lb_bottom: TSharpESkinLabel;
    lb_top: TSharpESkinLabel;
    procedure FormPaint(Sender: TObject);
    procedure BackgroundDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MouseEnter(Sender: TObject);
    procedure MouseLeave(Sender: TObject);
  protected
  private
    bShowIcon    : boolean;
    bShowLabels  : boolean;
    sLocation    : String;
    sTopLabel    : String;
    sBottomLabel : String;
    bHovering : Boolean;
    FIcon        : TBitmap32;
    FWeatherParser : TWeatherParser;
    function ReplaceDataInString(pString : String) : String;
  public
    mInterface : ISharpBarModule;
    procedure LoadSettings;
    procedure ReAlignComponents(Broadcast : boolean = True);
    procedure UpdateComponentSkins;
    procedure ShowWeatherNotification;
    property WeatherParser : TWeatherParser read FWeatherParser;
    property WeatherLocation : String read sLocation;
    property ShowIcon : boolean read bShowIcon;
  end;


implementation

uses GR32_PNG;

const
  TemperatureTitle = 'Temperature : ';
  FeelsLikeTitle = 'Feels Like : ';
  ConditionTitle = 'Condition : ';
  UVIndexTitle = 'UV Index : ';
  WindTitle = 'Wind : ';
  HumidityTitle = 'Humidity : ';
  PressureTitle = 'Pressure : ';
  DewPointTitle = 'Dew Point : ';
  VisibilityTitle = 'Visibility : ';
  
{$R *.dfm}

function TMainForm.ReplaceDataInString(pString : String) : String;
var
  n : integer;
begin
  with FWeatherParser.wxml do
  begin
    pString := StringReplace(pString,'{#FC_LASTUPDATE#}', Forecast.LastUpdated,[rfReplaceAll,rfIgnoreCase]);
    for n := 0 to High(Forecast.Days) do
    begin
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_CONDITION#}',      Forecast.Days[n].Day.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_DAYICON#}',        Forecast.Days[n].Day.IconCode,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_HUMIDITY#}',       Forecast.Days[n].Day.Humidity,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_PRECIPITATION#}',  Forecast.Days[n].Day.PercentChancePrecip,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_WIND_DIRDEG#}',    Forecast.Days[n].Day.Wind.DirAsDegr,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_WIND_DIRTEXT#}',   Forecast.Days[n].Day.Wind.DirAsTxt,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_WIND_MAXSPEED#}',  Forecast.Days[n].Day.Wind.MaxWindSpd,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAY_WIND_SPEED#}',     Forecast.Days[n].Day.Wind.WindSpd,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_CONDITION#}',    Forecast.Days[n].Night.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_DAYICON#}',      Forecast.Days[n].Night.IconCode,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_HUMIDITY#}',     Forecast.Days[n].Night.Humidity,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_PRECIPITATION#}',Forecast.Days[n].Night.PercentChancePrecip,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_WIND_DIRDEG#}',  Forecast.Days[n].Night.Wind.DirAsDegr,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_WIND_DIRTEXT#}', Forecast.Days[n].Night.Wind.DirAsTxt,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_WIND_MAXSPEED#}',Forecast.Days[n].Night.Wind.MaxWindSpd,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_NIGHT_WIND_SPEED#}',   Forecast.Days[n].Night.Wind.WindSpd,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DAYTEXT#}',            Forecast.Days[n].DayText,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_DATE#}',               Forecast.Days[n].Date,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_HIGHTEMP#}',           Forecast.Days[n].HighTemp,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_LOWTEMP#}',            Forecast.Days[n].LowTemp,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_TIMESUNSET#}',         Forecast.Days[n].TimeSunset,[rfReplaceAll,rfIgnoreCase]);
      pString := StringReplace(pString,'{#FC_D'+inttostr(n)+'_TIMESUNRISE#}',        Forecast.Days[n].TimeSunrise,[rfReplaceAll,rfIgnoreCase]);
    end;

    pString := StringReplace(pString,'{#LATITUE#}',     HeadLoc.Latitude,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#LONGITUDE#}',   HeadLoc.Longitude,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#LOCATION#}',    HeadLoc.LocationName,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#GMTOFFSET#}',   HeadLoc.GmtOffsett,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#TIMESUNSET#}',  HeadLoc.TimeSunset,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#TIMESUNRISE#}', HeadLoc.TimeSunrise,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#UNITTEMP#}',    HeadLoc.UnitOfTemp,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#UNITDIST#}',    HeadLoc.UnitOfDist,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#UNITSPEED#}',   HeadLoc.UnitOfSpeed,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#UNITPRESS#}',   HeadLoc.UnitOfPress,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#UNITPRECIP#}',  HeadLoc.UnitOfPrecip,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#TEMPERATURE#}', CurrentCondition.Temperature,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#TEMPFEELLIKE#}',CurrentCondition.FeelsLikeTemp,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#WINDSPEED#}',   CurrentCondition.Wind.WindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#MAXWINDSPEED#}',CurrentCondition.Wind.MaxWindSpd,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#WINDDIRTEXT#}', CurrentCondition.Wind.DirAsTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#WINDDIRDEGR#}', CurrentCondition.Wind.DirAsDegr,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#BAROMPRESS#}',  CurrentCondition.BaromPressure.CurrentPressure,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#BAROMPRESSRF#}',CurrentCondition.BaromPressure.RaiseOrFallAsTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#UV#}',          CurrentCondition.UV.Value,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#UVTEXT#}',      CurrentCondition.UV.ValueAsTxt,[rfReplaceAll,rfIgnoreCase]);
//    pString := StringReplace(pString,'{#MOONICON#}',    CurrentCondition.Moon.IconCode,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#MOONTEXT#}',    CurrentCondition.Moon.MoonText,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#VISIBILITY#}',  CurrentCondition.Visibility,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#DEWPOINT#}',    CurrentCondition.Dewpoint,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#LASTUPDATE#}',  CurrentCondition.DateTimeLastUpdate,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#HUMIDITY#}',    CurrentCondition.Humidity,[rfReplaceAll,rfIgnoreCase]);
//    pString := StringReplace(pString,'{#ICON#}',        CurrentCondition.IconCode,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#CONDITION#}',   CurrentCondition.ConditionTxt,[rfReplaceAll,rfIgnoreCase]);
    pString := StringReplace(pString,'{#OBSSTATION#}',  CurrentCondition.ObservationStation,[rfReplaceAll,rfIgnoreCase]);
  end;
  result := pString;
end;

procedure TMainForm.UpdateComponentSkins;
begin
  lb_top.SkinManager := mInterface.SkinInterface.SkinManager;
  lb_bottom.SkinManager := mInterface.SkinInterface.SkinManager;  
end;

procedure TMainForm.LoadSettings;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
begin
  bShowIcon    := True;
  bShowLabels  := True;
  sTopLabel    := 'Temperature: {#TEMPERATURE#}°{#UNITTEMP#}';
  sBottomLabel := 'Condition: {#CONDITION#}';
  sLocation    := '0';

  XML := TJclSimpleXML.Create;
  try
    XML.LoadFromFile(mInterface.BarInterface.GetModuleXMLFile(mInterface.ID));
    fileloaded := True;
  except
    fileloaded := False;
  end;
  if fileloaded then
    with xml.Root.Items do
    begin
      bShowIcon    := BoolValue('showicon',True);
      bShowLabels  := BoolValue('showlabels',True);
      sLocation    := Value('location',slocation);
      sTopLabel    := Value('toplabel',sTopLabel);
      sBottomLabel := Value('bottomlabel',sBottomLabel);
    end;
  XML.Free;

  if not DirectoryExists(GetSharpeUserSettingsPath + spath + 'Data\' + sLocation) then
  begin
    XML := TJclSimpleXML.Create;
    try
      XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
      if XML.Root.Items.Count > 0 then
         sLocation := XML.Root.Items.Item[0].Properties.Value('LocationID');
    except
    end;
    XML.Free;
  end;
  FWeatherParser.Update(sLocation);
end;

procedure TMainForm.MouseEnter(Sender: TObject);
begin
  // If the mouse has just entered over the form or one
  // of the controls then display the notification only
  // if the cursor was not already over the form or controls.
  // It is set to true or false in the mouseleave because
  // we don't want to display it more than once when you move
  // to a control on the form.
  if not bHovering then
    ShowWeatherNotification;
end;

procedure TMainForm.MouseLeave(Sender: TObject);
var
  cursorPos : TPoint;
  clientPos : TPoint;
begin
  // Get the cursor position and see if it is over the form
  // by checking it against the forms boundries.
  GetCursorPosSecure(cursorPos);
  clientPos := Self.ScreenToClient(cursorPos);

  bHovering := PtInRect(BoundsRect, clientPos);
end;

procedure TMainForm.ReAlignComponents(Broadcast : boolean = True);
var
  newWidth : integer;
  iIconWidth, iTopWidth, iBottomWidth : integer;
  s : String;
  i : integer;
  sicon : String;
  b : boolean;
  bTopLabel : boolean;
  bBottomLabel : boolean;
begin
  self.Caption := 'Weather';
  iIconWidth := 2;
  iTopWidth	:= 0;
  iBottomWidth := 0;

  if (bShowIcon) and (FWeatherParser.CCValid) then
  begin
    if TryStrToInt(FWeatherParser.wxml.CurrentCondition.IconCode,i) then
    begin
      sicon := inttostr(i);
    end else sicon := 'na';

    s := SharpApi.GetSharpeDirectory
         + 'Icons\Weather\61x61\'
         + sicon
         + '.png';

    //if not FileExists(s) then
    //  s := SharpApi.GetSharpeDirectory + 'Icons\Weather\64x64\na.png';

    if FileExists(s) then
    begin
      LoadBitmap32FromPNG(FIcon,s,b);
      // Get the icons width and add a spacer.
      // The icon is drawn as a square based on the bar height in FormPaint
      iIconWidth := Height + 2;
    end;
  end;

  if (bShowLabels) then
  begin
    bTopLabel := (length(trim(sTopLabel)) > 0);
    bBottomLabel := (length(trim(sBottomLabel)) > 0);

    if (bTopLabel) then
    begin
    lb_top.Caption := ReplaceDataInString(sTopLabel);
    lb_top.UpdateSkin;
    lb_top.Resize;
    lb_top.Visible := True;
    lb_top.left := iIconWidth;
    lb_top.LabelStyle := lsMedium;
    // Center the label in case the bottom label is not displayed
    lb_top.AutoPos := apCenter;
    end;

    if (bBottomLabel) then
    begin
      lb_bottom.Caption := ReplaceDataInString(sBottomLabel);
      lb_bottom.UpdateSkin;
      lb_bottom.Resize;
      lb_bottom.Visible := True;
      lb_bottom.Left := iIconWidth;
      lb_bottom.LabelStyle := lsMedium;
      // Center the label in case the top label is not diplayed
      lb_bottom.AutoPos := apCenter;
    end;

    if bTopLabel and bBottomLabel then
    begin
      // Change both the top and bottom labels to account for each other.
      lb_top.LabelStyle := lsSmall;
      lb_top.AutoPos := apTop;
      lb_bottom.LabelStyle := lsSmall;
      lb_bottom.AutoPos := apBottom;
    end;

    // Get the width of the icon and the top label and add a spacer
    iTopWidth	:= iIconWidth + lb_top.Width + 2;

    // Get the width of the icon and the bottom label and add a spacer
    iBottomWidth := iIconWidth + lb_bottom.Width + 2;

    if not bBottomLabel then
    begin
      iBottomWidth := 0;
      lb_bottom.Visible := False;
    end;

    if not bTopLabel then
    begin
      iTopWidth := 0;
      lb_top.Visible := False;
    end;
  end;

  NewWidth := max(iIconWidth,max(iTopWidth,iBottomWidth));
  mInterface.MinSize := NewWidth;
  mInterface.MaxSize := NewWidth;
  if (newWidth <> Width) and (Broadcast) then
    mInterface.BarInterface.UpdateModuleSize
  else Repaint;
end;

procedure TMainForm.ShowWeatherNotification;
var
  NS : ISharpENotifySkin;
  SkinText : ISharpEskinText;
  x, y : Integer;
  edge : TSharpNotifyEdge;
  timeout : Integer;
  p : TPoint;
  BmpToDisplay : TBitmap32;
  BmpText : TBitmap32;
  BmpIcon : TBitmap32;
  iconPath : String;
  alphaChannelAvailable : Boolean;
  textHeight, textMaxTitleWidth, textMaxValueWidth : Integer;
  spacer : Integer;
  formattedValue : String;
begin

  // Get the cordinates on the screen where the notification window should appear.
  p := Self.ClientToScreen(Point(0, Self.Height));
  x := p.X;
  if p.Y > Monitor.Top + Monitor.Height div 2 then
  begin
    edge := neBottomLeft;
    y := p.Y - Self.Height;
  end else
  begin
    edge := neTopLeft;
    y := p.Y;
  end;

  textMaxTitleWidth := 0;
  textMaxValueWidth := 0;
  // The space between sections.
  spacer := 5;
  timeout := 10000;
  iconPath := SharpApi.GetSharpeDirectory + 'Icons\Weather\93x93\' + WeatherParser.wxml.CurrentCondition.IconCode + '.png';

  BmpToDisplay := TBitmap32.Create;
  BmpToDisplay.DrawMode := dmBlend;
  BmpToDisplay.CombineMode := cmMerge;

  NS := mInterface.SkinInterface.SkinManager.Skin.Notify;
  SkinText := NS.Background.CreateThemedSkinText;
  SkinText.AssignFontTo(BmpToDisplay.Font, mInterface.SkinInterface.SkinManager.Scheme);

  // Create a bitmap for the current condition icon.
  BmpIcon := TBitmap32.Create;
  BmpIcon.DrawMode := dmBlend;
  BmpIcon.CombineMode := cmMerge;
  BmpIcon.SetSize(96, 96);

  if FileExists(iconPath) then
    LoadBitmap32FromPNG(BmpIcon, iconPath, alphaChannelAvailable);

  // Create a bitmap for the current condition text.
  BmpText := TBitmap32.Create;
  SkinText.AssignFontTo(BmpText.Font, mInterface.SkinInterface.SkinManager.Scheme);
  BmpText.DrawMode := dmBlend;
  BmpText.CombineMode := cmMerge;

  textHeight := BmpText.TextHeight('H');

  // Set the size after we determine at least the height,
  // we'll determine the final width as we render text below.
  // We set the width a little wide because we don't know the width yet.
  BmpText.SetSize(512, textHeight * 9);

  // Find the longest text width so we can center everything on the ':'.
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(TemperatureTitle));
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(FeelsLikeTitle));
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(ConditionTitle));
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(UVIndexTitle));
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(WindTitle));
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(HumidityTitle));
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(PressureTitle));
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(DewPointTitle));
  textMaxTitleWidth := Max(textMaxTitleWidth, BmpText.TextWidth(VisibilityTitle));

  // Render the text to a bitmap using the skin manager.
  with WeatherParser.wxml do
  begin
    formattedValue := CurrentCondition.Temperature + '°' + HeadLoc.UnitOfTemp;
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(TemperatureTitle), 0, TemperatureTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    formattedValue := CurrentCondition.FeelsLikeTemp + '°' + HeadLoc.UnitOfTemp;
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(FeelsLikeTitle), textHeight * 1, FeelsLikeTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    formattedValue := CurrentCondition.ConditionTxt;
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(ConditionTitle), textHeight * 2, ConditionTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    formattedValue := CurrentCondition.UV.Value + ' ' + CurrentCondition.UV.ValueAsTxt;
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(UVIndexTitle), textHeight * 3, UVIndexTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    formattedValue := 'From ' + CurrentCondition.Wind.DirAsTxt + ' at ' + CurrentCondition.Wind.WindSpd + ' ' + HeadLoc.UnitOfSpeed;
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(WindTitle), textHeight * 4, WindTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    formattedValue := CurrentCondition.Humidity + '%';
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(HumidityTitle), textHeight * 5, HumidityTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    formattedValue := CurrentCondition.BaromPressure.CurrentPressure + ' ' + CurrentCondition.BaromPressure.RaiseOrFallAsTxt;
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(PressureTitle), textHeight * 6, PressureTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    formattedValue := CurrentCondition.Dewpoint + '°' + HeadLoc.UnitOfTemp;
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(DewPointTitle), textHeight * 7, DewPointTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    formattedValue := CurrentCondition.Visibility + ' ' + HeadLoc.UnitOfDist;
    textMaxValueWidth := Max(textMaxValueWidth, BmpText.TextWidth(formattedValue));
    SkinText.RenderToW(BmpText, textMaxTitleWidth - BmpText.TextWidth(VisibilityTitle), textHeight * 8, VisibilityTitle + formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

    // we'll render this after we render the icon and text bitmaps.
    formattedValue := 'Last updated from ' + CurrentCondition.ObservationStation + ' at ' + CurrentCondition.DateTimeLastUpdate;
  end;

  // Set the width to the sum of both bitmaps and the height to the greater of the two.
  BmpToDisplay.SetSize(
    Max(BmpIcon.Width + spacer + textMaxTitleWidth + textMaxValueWidth, BmpToDisplay.TextWidth(formattedValue)),
    Max(BmpIcon.Height + textHeight, BmpText.Height + textHeight));

  // Draw the icon bitmap onto the bitmap we will eventually display.
  BmpIcon.DrawTo(BmpToDisplay, 0, 0);

  // Draw the text bitmap onto the bitmap we will eventually display.
  BmpText.DrawTo(BmpToDisplay, BmpIcon.Width + spacer, 0);

  // Render the last updated datetime to the bottom of the bitmap (below the greater heither for the icon or text).
  SkinText.RenderToW(BmpToDisplay, 0, Max(BmpIcon.Height, BmpText.Height), formattedValue, mInterface.SkinInterface.SkinManager.Scheme);

  SharpNotify.CreateNotifyWindowBitmap(
    0,
    nil,
    x,
    y,
    BmpToDisplay,
    edge,
    mInterface.SkinInterface.SkinManager,
    timeout,
    Monitor.BoundsRect);

    BmpText.Free;
    BmpIcon.Free;
    BmpToDisplay.Free;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  DoubleBuffered := True;

  bShowIcon    := True;
  bShowLabels  := True;
  sTopLabel    := 'Temperature: {#TEMPERATURE#}°{#UNITTEMP#}';
  sBottomLabel := 'Condition: {#CONDITION#}';  
  bHovering := False;
  
  FIcon := TBitmap32.Create;
  FIcon.DrawMode := dmBlend;
  FIcon.CombineMode := cmMerge;
  FWeatherParser := TWeatherParser.Create;

  lb_top.OnMouseEnter := OnMouseEnter;
  lb_top.OnMouseLeave := OnMouseLeave;
  lb_bottom.OnMouseEnter := OnMouseEnter;
  lb_bottom.OnMouseLeave := OnMouseLeave;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FIcon);
  FreeAndNil(FWeatherParser);
end;

procedure TMainForm.BackgroundDblClick(Sender: TObject);
begin
  SharpApi.SharpExecute('http://www.weather.com/weather/local/'+slocation);
end;

procedure TMainForm.FormPaint(Sender: TObject);
var
  Bmp : TBitmap32;
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
  Bmp := TBitmap32.Create;
  Bmp.Assign(mInterface.Background);
  if showicon then
     FIcon.DrawTo(Bmp,Rect(1,1,Height-1,Height-1));
  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

end.
