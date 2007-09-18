{
Source Name: Weather Object
Description: Weather desktop object Libary
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

library Weather;
uses
  Forms,
  windows,
  graphics,
  Contnrs,
  Dialogs,
  sysUtils,
  Classes,
  menus,
  WeatherObjectSettingsWnd in 'WeatherObjectSettingsWnd.pas' {SettingsWnd},
  WeatherObjectLayer in 'WeatherObjectLayer.pas',
  pngimage,
  jvsimplexml,
  gr32,
  GR32_Image,
  GR32_Layers,
  GR32_Transforms,
  GR32_Resamplers,
  WeatherObjectXMLSettings in 'WeatherObjectXMLSettings.pas',
  uSharpDeskTDeskSettings,
  uSharpDeskTObjectSettings,
  uSharpDeskTThemeSettings,
  uSharpDeskFunctions,
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpDeskApi in '..\..\..\Common\Libraries\SharpDeskApi\SharpDeskApi.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  uSharpeColorBox in '..\..\..\Common\Delphi Components\SharpEColorBox\uSharpeColorBox.pas',
  uSharpEFontSelector in '..\..\..\Common\Delphi Components\SharpEFontSelector\uSharpEFontSelector.pas',
  uSharpDeskDesktopPanel in '..\..\SharpDesk\Units\uSharpDeskDesktopPanel.pas',
  uSharpDeskDesktopPanelList in '..\..\SharpDesk\Units\uSharpDeskDesktopPanelList.pas',
  uWeatherParser in 'uWeatherParser.pas',
  HTTPGet in '..\..\..\Common\3rd party\HTTPGet\HTTPGet.pas';

{$R *.RES}
{$R icons.RES}


type
    TLayerList = class (TObjectList)
                 private
                 public
                 published
                 end;

    TLayer = class
             private
              FObjectID : integer;
              FLayer : TWeatherLayer;
             public
              destructor Destroy; override;
             published
              property ObjectID : integer read FObjectID write FObjectID;
              property WeatherLayer : TWeatherLayer read FLayer write FLayer;
             end;

var
  LayerList : TLayerList;
  DeskSettings   : TDeskSettings;
  ObjectSettings : TObjectSettings;
  ThemeSettings  : TThemeSettings;
  FirstStart : boolean = True;
  SettingsWnd : TSettingsWnd;
  LastSettingsTick,LastSettingsPanel : integer;


destructor TLayer.Destroy;
begin
  if FLayer <> nil then
  begin
    FLayer.Free;
    FLayer := nil;
  end;
  Inherited Destroy;
end;


function CreateLayer(Image: TImage32; ObjectID : integer) : TBitmapLayer;
var
   Layer : TLayer;
begin
  if FirstStart then
  begin
    FirstStart := False;
    LayerList := TLayerList.Create;
  end;
  LayerList.Add(TLayer.Create);
  Layer := TLayer(LayerList.Items[LayerList.Count-1]);
  Layer.ObjectID := ObjectID;
  Layer.WeatherLayer := TWeatherLayer.create(Image, ObjectID, DeskSettings,ThemeSettings,ObjectSettings);
  Layer.WeatherLayer.Tag:=ObjectID;
  result := Layer.WeatherLayer;
end;

function StartSettingsWnd(ObjectID : integer; Handle : hwnd) : hwnd;
var
   n : integer;
   Layer : TLayer;
begin
  if not FirstStart then
  begin
    Layer := nil;
    for n := 0 to LayerList.Count - 1 do
    begin
      if TLayer(LayerList.Items[n]).ObjectID = ObjectID then
      begin
        Layer := TLayer(LayerList.Items[n]);
        break;
      end;
    end;
    if Layer <> nil then Layer.WeatherLayer.EndHL;    
  end;
    
  if SettingsWnd = nil then SettingsWnd := TSettingsWnd.Create(nil);
  SettingsWnd.ParentWindow:=Handle;
  SettingsWnd.Left:=2;
  SettingsWnd.Top:=2;
  SettingsWnd.BorderStyle:=bsNone;
  SettingsWnd.ObjectID:=ObjectID;
  SettingsWnd.DeskSettings := DeskSettings;
  SettingsWnd.ObjectSettings := ObjectSettings;
  SettingsWnd.ThemeSettings := ThemeSettings;
  SettingsWnd.LoadSettings;
  if (not FirstStart) and (GetTickCount-LastSettingsTick<2000) then
      SettingsWnd.PageControl1.ActivePageIndex:=LastSettingsPanel;
  SettingsWnd.Show;
  result:=SettingsWnd.Handle;
end;

function CloseSettingsWnd(ObjectID : integer; SaveSettings : boolean) : boolean;
begin
  try
    if (SaveSettings) and (ObjectID<>0) then
    begin
      SettingsWnd.ObjectID:=ObjectID;
      SettingsWnd.SaveSettings;
      LastSettingsTick := GetTickCount;
      LastSettingsPanel := SettingsWnd.PageControl1.ActivePageIndex;
    end;
    SettingsWnd.Close;
    SettingsWnd.Free;
    SettingsWnd:=nil;
    result:=True;
  except
    result:=False;
  end;
end;


procedure SharpDeskMessage(pObjectID : integer; pLayer : TBitmapLayer; DeskMessage,P1,P2,P3 : integer);
var
   Menu,Menu2 : TPopupMenu;
   MenuItem,MenuItem2 : TMenuItem;
   bmp2 : TBitmap;
   n : integer;
   Layer : TLayer;
   XML : TJvSimpleXML;
begin
  if FirstStart then exit;
  Layer := nil;
  for n := 0 to LayerList.Count - 1 do
  begin
    if TLayer(LayerList.Items[n]).ObjectID = pObjectID then
    begin
      Layer := TLayer(LayerList.Items[n]);
      break;
    end;
  end;
  if Layer = nil then exit;

  case DeskMessage of
    SDM_SELECT : begin
                   if P1 = 0 then Layer.WeatherLayer.Locked := False
                      else Layer.WeatherLayer.Locked := True;
                      Layer.WeatherLayer.StartHL;
                   end;
    SDM_DESELECT : Layer.WeatherLayer.EndHL;
  SDM_REPAINT_LAYER : Layer.WeatherLayer.LoadSettings;
  SDM_CLOSE_LAYER : begin
                      SharpApi.SendDebugMessageEx('Weather.Object',PChar('Removing : ' + inttostr(Layer.ObjectID)),0,DMT_INFO);
                      LayerList.Remove(Layer);
                      SharpApi.SendDebugMessageEx('Weather.Object',PChar('Freeing : ' + inttostr(Layer.ObjectID)),0,DMT_INFO);
                      Layer := nil;
                      SharpApi.SendDebugMessageEx('Weather.Object',PChar('Object removed'),0,DMT_INFO);
                    end;
  SDM_SHUTDOWN : begin
                   LayerList.Clear;
                   LayerList.Free;
                   LayerList := nil;
                   FirstStart := True;
                 end;
  SDM_WEATHER_UPDATE : begin
                         try
                           if Layer.WeatherLayer.WeatherParser <> nil then
                              Layer.WeatherLayer.WeatherParser.Update(Layer.WeatherLayer.Settings.WeatherLocation);
                              Layer.WeatherLayer.BuildOutput;
                         except
                           SharpApi.SendDebugMessageEx('Weather.object','Failed to update Weather Parser',clred,DMT_ERROR);
                         end;                              
                         Layer.WeatherLayer.DrawBitmap;
                       end;
    SDM_MENU_POPUP : begin
                       Bmp2 := TBitmap.Create;
                       Menu := TForm(Layer.WeatherLayer.ParentImage.Parent).PopupMenu;
                       Menu2 := Layer.WeatherLayer.ParentImage.PopupMenu;

                       MenuItem := TMenuItem.Create(Menu.Items);
                       MenuItem.Caption := 'Location';
                       MenuItem.ImageIndex := 0;
                       //MenuItem.OnClick := Layer.WeatherLayer.OnOpenClick;
                       Menu.Items.Add(MenuItem);

                       Bmp2.LoadFromResourceID(HInstance,100);
                       Menu.Images.AddMasked(bmp2,clFuchsia);
                       Bmp2.LoadFromResourceID(HInstance,101);
                       Menu.Images.AddMasked(bmp2,clFuchsia);
                       Bmp2.LoadFromResourceID(HInstance,102);
                       Menu.Images.AddMasked(bmp2,clFuchsia);

                       XML := TJvSimpleXML.Create(nil);
                       try
                         XML.LoadFromFile(GetSharpEUserSettingsPath+'SharpCore\Services\Weather\weatherlist.xml');
                         for n := 0 to XML.Root.Items.Count - 1 do
                         begin
                           MenuItem2 := TMenuItem.Create(MenuItem);
                           MenuItem2.Caption := XML.Root.Items.Item[n].Properties.Value('Location','error loading location data');
                           if XML.Root.Items.Item[n].Properties.Value('LocationID') = Layer.WeatherLayer.Settings.WeatherLocation then
                              MenuItem2.ImageIndex := 2
                           else MenuItem2.ImageIndex := 1;
                           MenuItem2.Tag := n;
                           MenuItem2.OnClick := Layer.WeatherLayer.OnLocationClick;
                           MenuItem.Add(MenuItem2);
                         end;
                       except
                         MenuItem.Clear;
                       end;
                       XML.Free;

                       Bmp2.Free;
                     end;
  end;
end;

function RenderTooltip(pObjectID : integer; pBitmap : TBitmap32) : boolean;
var
  n : integer;
  Layer : TLayer;
  w,h : integer;
  eh : integer;
  P : TPoint;
  FileName : String;
  L : TFloatRect;
  color1,color2 : TColor32;
  SList : TStringList;
  Icon : TBitmap32;
  b : boolean;
begin
  if FirstStart then exit;
  Layer := nil;
  for n := 0 to LayerList.Count - 1 do
  begin
    if TLayer(LayerList.Items[n]).ObjectID = pObjectID then
    begin
      Layer := TLayer(LayerList.Items[n]);
      break;
    end;
  end;
  if Layer = nil then exit;

  SList := TStringList.Create;
  SList.Clear;
  with Layer.WeatherLayer.WeatherParser.wxml.Forecast do
  begin
    for n := 1 to 5 do
    begin
      SList.Add('       ' + Days[n].DayText +': ' +Days[n].LowTemp + '°'+Layer.WeatherLayer.WeatherParser.wxml.HeadLoc.UnitOfTemp+ ' / '
                +Days[n].HighTemp + '°'+Layer.WeatherLayer.WeatherParser.wxml.HeadLoc.UnitOfTemp+' ');
    end;
  end;

  with pBitmap do
  begin
    if DeskSettings<>nil then
    begin
      Color1 := color32(DeskSettings.Theme.Scheme.WorkArealight);
      Color2 := color32(DeskSettings.Theme.Scheme.WorkAreadark);
    end else
    begin
      Color1 := color32(clsilver);
      Color2 := color32(clBlack);
    end;
    BeginUpdate;

    MasterAlpha := 255;
    Font.Name := 'Arial';
    Font.Color := clBlack;
    Font.Style := [];
    Font.Size := 8;
    p := GetBitmapSize(pBitmap,SList);
    w := p.x + 8;
    h := p.y + 4;

    eh := TextHeight('!"§$%&/()=?`°QWERTZUIOPÜASDFGHJJKLÖÄYXCVBNqp1234567890');
    eh := 22;
    h := 5*eh + 8;
    SetSize(w,h);
    Clear(color32(0,0,0,0));

    FillRectTS(rect(3,0,w-3,h-1),color1);
    LineT(1,2,1,h-2,color1);
    LineT(2,1,2,h-1,color1);
    LineT(w-2,2,w-2,h-2,color1);
    LineT(w-3,1,w-3,h-1,color1);

    LineT(2,0,w-2,0,color2);
    LineT(2,h-1,w-2,h-1,color2);
    LineT(0,2,0,h-2,color2);
    LineT(w-1,2,w-1,h-2,color2);
    Pixel[1,1] := color2;
    Pixel[w-2,1] := color2;
    Pixel[1,h-2] := color2;
    Pixel[w-2,h-2] := color2;

    for n := 0 to SList.Count - 1 do
    begin
      FileName := SharpApi.GetSharpeDirectory
                  + 'Icons\Weather\64x64\'
                  + Layer.WeatherLayer.WeatherParser.wxml.Forecast.Days[n].Day.IconCode
                  + '.png';
      if FileExists(FileName) then
      begin
        try
          Icon := TBitmap32.Create;
          TLinearResampler.Create(Icon);
          Icon.DrawMode := dmBlend;
          Icon.CombineMode := cmMerge;
          LoadBitmap32FromPNG(Icon,FileName,b);
          Icon.DrawTo(pBitmap,Rect(2,n*eh+5,20+2,n*eh+5+20));
        finally
          Icon.Free
        end;
      end;
      RenderText(4,n*eh+2+6,SList[n],0,color32(Font.Color));
    end;
    EndUpdate;
    Changed;
  end;

  SList.Free;
end;

procedure GetSettings( pDeskSettings   : TDeskSettings;
                       pThemeSettings  : TThemeSettings;
                       pObjectSettings : TObjectSettings);
begin
  DeskSettings   := pDeskSettings;
  ThemeSettings  := pThemeSettings;
  ObjectSettings := pObjectSettings;
end;


Exports
  CloseSettingsWnd,
  CreateLayer,
  StartSettingsWnd,
  SharpDeskMessage,
  GetSettings,
  RenderTooltip;

begin
end.

