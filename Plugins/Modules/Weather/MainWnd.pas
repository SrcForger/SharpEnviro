{
Source Name: MainWnd
Description: Weather  module main window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpEBaseControls, SharpESkinManager,
  SharpEScheme, SharpESkin, ExtCtrls, GR32,
  JvSimpleXML, SharpApi, Menus, Math, SharpESkinLabel,
  uWeatherParser, GR32_Image;


type
  TMainForm = class(TForm)
    MenuPopup: TPopupMenu;
    Settings1: TMenuItem;
    SharpESkinManager1: TSharpESkinManager;
    UpdateTimer: TTimer;
    lb_bottom: TSharpESkinLabel;
    lb_top: TSharpESkinLabel;
    procedure FormPaint(Sender: TObject);
    procedure BackgroundDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
  protected
  private
    sShowIcon    : boolean;
    sShowLabels  : boolean;
    sLocation    : String;
    sTopLabel    : String;
    sBottomLabel : String;
    FIcon        : TBitmap32;
    FWeatherParser : TWeatherParser;
    Background   : TBitmap32;
    function ReplaceDataInString(pString : String) : String;
  public
    ModuleID : integer;
    BarWnd   : hWnd;
    procedure LoadSettings;
    procedure SetSize(NewWidth : integer);
    procedure ReAlignComponents(BroadCast : boolean);
    procedure UpdateBackground(new : integer = -1);
    property WeatherParser : TWeatherParser read FWeatherParser;
    property WeatherLocation : String read sLocation;
    property ShowIcon : boolean read sShowIcon;
  end;


implementation

uses SettingsWnd,
     GR32_PNG,
     uSharpBarAPI;

{$R *.dfm}

function TMainForm.ReplaceDataInString(pString : String) : String;
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

procedure TMainForm.LoadSettings;
var
  item : TJvSimpleXMLElem;
  XML : TJvSimpleXML;
begin
  sShowIcon    := True;
  sShowLabels  := True;
  sLocation    := '0';
  sTopLabel    := 'Temperature: {#TEMPERATURE#}°{#UNITTEMP#}';
  sBottomLabel := 'Condition: {#CONDITION#}';

  item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
  with item.Items do
  begin
    sShowIcon    := BoolValue('showicon',True);
    sShowLabels  := BoolValue('showlabels',True);
    sLocation    := Value('location',slocation);
    sTopLabel    := Value('toplabel',sTopLabel);
    sBottomLabel := Value('bottomlabel',sBottomLabel);
  end;

  if not DirectoryExists(GetSharpeUserSettingsPath + spath + 'Data\' + sLocation) then
  begin
    XML := TJvSimpleXML.Create(nil);
    try
      XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
      if XML.Root.Items.Count > 0 then
         sLocation := XML.Root.Items.Item[0].Properties.Value('LocationID');
    except
    end;
    XML.Free;
  end;
  FWeatherParser.Update(sLocation);
//  UpdateTimer.OnTimer(UpdateTimer);
end;

procedure TMainForm.UpdateBackground(new : integer = -1);
begin
  if (new <> -1) then
     Background.SetSize(new,Height)
     else if (Width <> Background.Width) then
              Background.Setsize(Width,Height);
  uSharpBarAPI.PaintBarBackGround(BarWnd,Background,self,Background.Width);
end;

procedure TMainForm.SetSize(NewWidth : integer);
begin
  NewWidth := Max(1,NewWidth);

  UpdateBackground(NewWidth);

  Width := NewWidth;
  Repaint;
end;

procedure TMainForm.ReAlignComponents(BroadCast : boolean);
var
  newWidth : integer;
  o1,o2,o3,o4 : integer;
  s : String;
  b : boolean;
begin
  self.Caption := 'Weather';
  o1 := 2;
  o2 := (Height - 2 - 4) div 2;
  o4 := 0;

  if (sShowIcon) and (FWeatherParser.CCValid) then
  begin
    s := SharpApi.GetSharpeGlobalSettingsPath
         + 'SharpDesk\Objects\Weather\Icons\64x64\'
         + inttostr(strtoint(FWeatherParser.wxml.CurrentCondition.IconCode))
         + '.png';
    if FileExists(s) then
    begin
      LoadBitmap32FromPNG(FIcon,s,b);
      o1 := o1 + Height - 4;
    end;
  end;

  if (sShowLabels) then
  begin
    lb_top.Caption := ReplaceDataInString(sTopLabel);
    lb_top.UpdateSkin;
    lb_top.Resize;
    lb_top.Visible := True;
    lb_top.left := o1;
    s := ReplaceDataInString(sBottomLabel);
    if length(trim(s))>0 then
    begin
      lb_top.LabelStyle := lsSmall;
      lb_top.Top := 1 + (o2 div 2) - (lb_top.Height div 2);
      lb_bottom.Caption := s;
      lb_bottom.UpdateSkin;
      lb_bottom.Resize;
      lb_bottom.Left := o1;
      lb_bottom.Top := Height - 3 - (o2 div 2) - (lb_bottom.Height div 2);
      lb_bottom.Visible := True;
      o3 := o1 + lb_top.Width + 2;
      o4 := o1 + lb_bottom.Width + 2;
    end else
    begin
      lb_top.LabelStyle := lsMedium;
      lb_top.Top := Height div 2 - (lb_top.Height div 2);
      lb_bottom.Visible := False;
      o3 := o1 + lb_top.Width + 2;
    end;
  end else
  begin
    o3 := 2;
    lb_top.Visible := False;
    lb_bottom.Visible := False;
  end;

  NewWidth := max(o1,max(o3,o4));
  Tag := newWidth;
  Hint := inttostr(NewWidth);
  if newWidth <> width then
     if BroadCast then SendMessage(self.ParentWindow,WM_UPDATEBARWIDTH,0,0);
end;


procedure TMainForm.Settings1Click(Sender: TObject);
var
  SettingsForm : TSettingsForm;
  item : TJvSimpleXMLElem;
begin
  try
    SettingsForm := TSettingsForm.Create(nil);
    SettingsForm.cb_showicon.Checked := sShowIcon;
    SettingsForm.cb_info.Checked := sShowLabels;
    SettingsForm.cb_info.OnClick(SettingsForm.cb_info);
    SettingsForm.edit_top.Text := sTopLabel;
    SettingsForm.edit_bottom.Text := sBottomLabel;
    SettingsForm.sLocation := sLocation;
    SettingsForm.BuildLocationList(sLocation); 

    if SettingsForm.ShowModal = mrOk then
    begin
      sShowIcon := SettingsForm.cb_showicon.Checked;
      sShowLabels := SettingsForm.cb_info.Checked;
      sTopLabel := SettingsForm.edit_top.Text;
      sBottomLabel := SettingsForm.edit_bottom.Text;
      sLocation := SettingsForm.sLocation;
      item := uSharpBarApi.GetModuleXMLItem(BarWnd, ModuleID);
      if item <> nil then with item.Items do
      begin
        clear;
        Add('showicon',sShowIcon);
        Add('showlabels',sShowLabels);
        Add('location',sLocation);
        Add('toplabel',sTopLabel);
        Add('bottomlabel',sBottomLabel);
      end;
      uSharpBarAPI.SaveXMLFile(BarWnd);
//      UpdateTimer.OnTimer(UpdateTimer);
    end;
    FWeatherParser.Update(sLocation);
    ReAlignComponents(True);
  finally
    FreeAndNil(SettingsForm);
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Background := TBitmap32.Create;
  FIcon := TBitmap32.Create;
  FIcon.DrawMode := dmBlend;
  FIcon.CombineMode := cmMerge;
  FWeatherParser := TWeatherParser.Create;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Background);
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
  Bmp := TBitmap32.Create;
  Bmp.Assign(Background);
  if showicon then
     FIcon.DrawTo(Bmp,Rect(1,1,Height-1,Height-1));
  Bmp.DrawTo(Canvas.Handle,0,0);
  Bmp.Free;
end;

end.
