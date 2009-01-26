{
Source Name: uThemeWallpaper.pas
Description: TThemeWallpaper class implementing IThemeWallpaper Interface
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
unit uThemeWallpaper;

interface

uses
  uThemeInfo, uThemeConsts, uIThemeWallpaper, uIThemeScheme;

type
  TThemeWallpaper = class(TInterfacedObject, IThemeWallpaper)
  private
    FThemeInfo   : TThemeInfo;
    FWallpapers  : TThemeWallpaperItems;
    FMonitors    : TMonitorWallpapers;
    procedure SetDefaults;
  public
    LastUpdate : Int64;
    constructor Create(pThemeInfo : TThemeInfo); reintroduce;
    destructor Destroy; override;
    procedure ParseColors(pScheme : IThemeScheme);

    // IThemeWallpaperInterface
    function GetWallpapers : TThemeWallpaperItems; stdcall;
    property Wallpapers : TThemeWallpaperItems read GetWallpapers;

    function GetMonitors : TMonitorWallpapers; stdcall;
    property Monitors : TMonitorWallpapers read GetMonitors;

    function GetMonitorWallpaper(MonitorID: integer): TThemeWallpaperItem; stdcall;
    function GetMonitor(MonitorID : integer): TWallpaperMonitor; stdcall;
    procedure UpdateMonitor(pMonitor : TWallpaperMonitor); stdcall;
    procedure UpdateWallpaper(pWallpaper : TThemeWallpaperItem); stdcall;

    procedure SaveToFile; stdcall;
    procedure LoadFromFile; stdcall;    
  end;

implementation

uses
  SysUtils, DateUtils, IXmlBaseUnit;

constructor TThemeWallpaper.Create(pThemeInfo : TThemeInfo);
begin
  Inherited Create;

  FThemeInfo := pThemeInfo;

  LoadFromFile;
end;

destructor TThemeWallpaper.Destroy;
begin
  setlength(FMonitors,0);
  setlength(FWallpapers,0);

  inherited;
end;

function TThemeWallpaper.GetMonitor(MonitorID: integer): TWallpaperMonitor;
var
  n : integer;
begin
  for n := 0 to High(FMonitors) do
    if FMonitors[n].ID = MonitorID then
    begin
      result := FMonitors[n];
      exit;
    end;

  // return the default/primary monitor if not found
  result := FMonitors[0];
end;

function TThemeWallpaper.GetMonitors : TMonitorWallpapers;
begin
  result := FMonitors;
end;

function TThemeWallpaper.GetMonitorWallpaper(MonitorID: integer): TThemeWallpaperItem;
var
  n, i: integer;
begin
  for n := 0 to High(FMonitors) do
    if FMonitors[n].ID = MonitorID then
      for i := 0 to High(FWallpapers) do
        if CompareText(FWallpapers[i].Name, FMonitors[n].Name) = 0 then
        begin
          result := FWallpapers[i];
          exit;
        end;

  result := FWallpapers[0];
end;

function TThemeWallpaper.GetWallpapers : TThemeWallpaperItems;
begin
  result := FWallpapers;
end;

procedure TThemeWallpaper.LoadFromFile;
var
  XML : TInterfacedXmlBase;
  fileloaded : boolean;
  n : integer;
begin
  SetDefaults;

  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_WALLPAPER_FILE;
  if XML.Load then
  begin
    fileloaded := True;
    // Load Wallpaper list
    if XML.XmlRoot.Items.ItemNamed['Wallpapers'] <> nil then
      for n := 0 to XML.XmlRoot.Items.ItemNamed['Wallpapers'].Items.Count - 1 do
       with XML.XmlRoot.Items.ItemNamed['Wallpapers'].Items.Item[n].Items do
       begin
         if n <> 0 then // (There always is a default wallpaper at [0], overwrite this)
           setlength(FWallpapers, length(FWallpapers) + 1);
         with FWallpapers[High(FWallpapers)] do
         begin
           Name            := Value('Name', Name);
           Image           := Value('Image', Image);
           ColorStr        := Value('Color', ColorStr);
           Alpha           := IntValue('Alpha', Alpha);
           Size            := TThemeWallpaperSize(IntValue('Size', 0));
           ColorChange     := BoolValue('ColorChange', ColorChange);
           Hue             := IntValue('Hue', Hue);
           Saturation      := IntValue('Saturation', Saturation);
           Lightness       := IntValue('Lightness', Lightness);
           Gradient        := BoolValue('Gradient', Gradient);
           GradientType    := TThemeWallpaperGradientType(IntValue('GradientType', 0));
           GDStartColorStr := Value('GDStartColor', GDStartColorStr);
           GDStartAlpha    := IntValue('GDStartAlpha', GDStartAlpha);
           GDEndColorStr   := Value('GDEndColor', GDEndColorStr);
           GDEndAlpha      := IntValue('GDEndAlpha', GDEndAlpha);
           MirrorHoriz     := BoolValue('MirrorHoriz', MirrorHoriz);
           MirrorVert      := BoolValue('MirrorVert', MirrorVert);
         end;
       end;
    if XML.XmlRoot.Items.ItemNamed['Monitors'] <> nil then
      for n := 0 to XML.XmlRoot.Items.ItemNamed['Monitors'].Items.Count - 1 do
        with XML.XmlRoot.Items.ItemNamed['Monitors'].Items.Item[n].Items do
        begin
          if n <> 0 then  // (There always is a default monitor at [0], overwrite this)
            setlength(FMonitors, length(FMonitors) + 1);
          FMonitors[High(FMonitors)].Name := Value('Name', 'Default');
          FMonitors[High(FMonitors)].ID := IntValue('ID', -100);
        end;       
  end else fileloaded := False;
  XML.Free;

  if not fileloaded then
    SaveToFile;

  LastUpdate := DateTimeToUnix(Now());  
end;

procedure TThemeWallpaper.ParseColors(pScheme: IThemeScheme);
var
  n : integer;
begin
  for n := 0 to High(FWallpapers) do
    with FWallpapers[n] do
    begin
      Color        := pScheme.ParseColor(ColorStr);
      GDStartColor := pScheme.ParseColor(GDStartColorStr);
      GDEndColor   := pScheme.ParseColor(GDEndColorStr);
    end;
end;

procedure TThemeWallpaper.SaveToFile;
var
  XML : TInterfacedXmlBase;
  n : integer;
begin
  XML := TInterfacedXMLBase.Create;
  XML.XmlFilename := FThemeInfo.Directory + '\' + THEME_WALLPAPER_FILE;

  XML.XmlRoot.Name := 'SharpEThemeWallpapers';
  with XML.XmlRoot do
  begin
    with Items.Add('Wallpapers') do
    begin
      for n := 0 to High(FWallpapers) do
        with Items.Add('item').Items, FWallpapers[n] do
        begin
          Add('Name', Name);
          Add('Image', Image);
          Add('Color', ColorStr);
          Add('Alpha', Alpha);
          Add('Size', Integer(Size));
          Add('ColorChange', ColorChange);
          Add('Hue', Hue);
          Add('Saturation', Saturation);
          Add('Lightness', Lightness);
          Add('Gradient', Gradient);
          Add('GradientType', Integer(GradientType));
          Add('GDStartColor', GDStartColorStr);
          Add('GDStartAlpha', GDStartAlpha);
          Add('GDEndColor', GDEndColorStr);
          Add('GDEndAlpha', GDEndAlpha);
          Add('MirrorHoriz', MirrorHoriz);
          Add('MirrorVert', MirrorVert);
        end;
    end;

    with Items.Add('Monitors') do
    begin
      for n := 0 to High(FMonitors) do
        with Items.Add('item').Items, FMonitors[n] do
        begin
          Add('Name', Name);
          Add('ID', ID);
        end;
    end;
  end;
  XML.Save;

  XML.Free;
end;

procedure TThemeWallpaper.SetDefaults;
begin
  setlength(FWallpapers, 1);
  setlength(FMonitors, 1);
  FMonitors[0].Name := 'Default';
  FMonitors[0].ID := -100;
  with FWallpapers[0] do
  begin
    Name             := 'Default';
    Image           := '';
    Color           := 0;
    ColorStr        := '0';
    Alpha           := 255;
    Size            := twsScale;
    ColorChange     := False;
    Hue             := 0;
    Saturation      := 0;
    Lightness       := 0;
    Gradient        := False;
    GradientType    := twgtHoriz;
    GDStartColor    := 0;
    GDStartColorStr := '0';
    GDStartAlpha    := 0;
    GDEndColor      := 0;
    GDEndColorStr   := '0';
    GDEndAlpha      := 0;
    MirrorHoriz     := False;
    MirrorVert      := False;
  end;
end;

procedure TThemeWallpaper.UpdateMonitor(pMonitor : TWallpaperMonitor);
var
  n : integer;
begin
  for n := 0 to High(FMonitors) do
    if FMonitors[n].ID = pMonitor.ID then
    begin
      FMonitors[n].Name := pMonitor.Name;
      exit;
    end;

  SetLength(FMonitors,length(FMonitors)+1);
  FMonitors[High(FMonitors)] := pMonitor;
end;

procedure TThemeWallpaper.UpdateWallpaper(pWallpaper : TThemeWallpaperItem);
var
  n : integer;
begin
  for n := 0 to High(FWallpapers) do
    if CompareText(FWallpapers[n].Name,pWallpaper.Name) = 0 then
    begin
      FWallpapers[n] := pWallpaper;
      exit;
    end;

  SetLength(FWallpapers,length(FWallpapers)+1);
  FWallpapers[0] := pWallpaper;
end;

end.
