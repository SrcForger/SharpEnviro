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
  WeatherObjectLayer in 'WeatherObjectLayer.pas',
  pngimage,
  jvsimplexml,
  gr32,
  GR32_Image,
  GR32_Layers,
  GR32_Transforms,
  GR32_Resamplers,
  PngImageList,
  WeatherObjectXMLSettings in 'WeatherObjectXMLSettings.pas',
  uSharpDeskTDeskSettings,
  uSharpDeskFunctions,
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpDeskApi in '..\..\..\Common\Libraries\SharpDeskApi\SharpDeskApi.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  uSharpDeskDesktopPanel in '..\..\SharpDesk\Units\uSharpDeskDesktopPanel.pas',
  uSharpDeskDesktopPanelList in '..\..\SharpDesk\Units\uSharpDeskDesktopPanelList.pas',
  uWeatherParser in 'uWeatherParser.pas';

{$R *.RES}
{$R icons.RES}


type
    TLayerList = class (TObjectList)
                 private
                 public
                 end;

    TLayer = class
             private
              FObjectID : integer;
              FLayer : TWeatherLayer;
             public
              destructor Destroy; override;

              property ObjectID : integer read FObjectID write FObjectID;
              property WeatherLayer : TWeatherLayer read FLayer write FLayer;
             end;

var
  LayerList : TLayerList;
  FirstStart : boolean = True;

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
  Layer.WeatherLayer := TWeatherLayer.create(Image, ObjectID);
  Layer.WeatherLayer.Tag:=ObjectID;
  result := Layer.WeatherLayer;
end;

procedure SharpDeskMessage(pObjectID : integer; pLayer : TBitmapLayer; DeskMessage,P1,P2,P3 : integer);
var
   Menu2 : TPopupMenu;
   MenuItem, MenuItem2 : TMenuItem;
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
                       Menu2 := Layer.WeatherLayer.ParentImage.PopupMenu;

                       MenuItem := TMenuItem.Create(Menu2.Items);
                       MenuItem.Caption := 'Location';
                       MenuItem.ImageIndex := 0;
                       //MenuItem.OnClick := Layer.WeatherLayer.OnOpenClick;
                       Menu2.Items.Add(MenuItem);

                       Bmp2.LoadFromResourceID(HInstance,100);
                       TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);
                       Bmp2.LoadFromResourceID(HInstance,101);
                       TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);
                       Bmp2.LoadFromResourceID(HInstance,102);
                       TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);

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

procedure InitSettings;
begin

end;


Exports
  CreateLayer,
  SharpDeskMessage,
  InitSettings;

begin
end.

