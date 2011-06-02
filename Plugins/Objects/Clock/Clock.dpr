{
Source Name: Clock
Description: Clock desktop object
Copyright (C) Delusional <Delusional@Lowdimension.net>
              Martin Kr�mer <MartinKraemer@gmx.net>

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

library Clock;
uses
  ShareMem,
  Forms,
  windows,
  graphics,
  Contnrs,
  Dialogs,
  sysUtils,
  uClockObjectLayer in 'uClockObjectLayer.pas',
  gr32,
  pngimage,
  GR32_Image,
  GR32_Layers,
  GR32_Transforms,
  uSharpDeskTDeskSettings,
  uSharpDeskFunctions,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpDeskApi in '..\..\..\Common\Libraries\SharpDeskApi\SharpDeskApi.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  SharpeColorPicker in '..\..\..\Common\Delphi Components\SharpeColorPicker\SharpeColorPicker.pas',
  SharpEFontSelector in '..\..\..\Common\Delphi Components\SharpEFontSelector\SharpEFontSelector.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  ClockObjectXMLSettings in 'ClockObjectXMLSettings.pas';

{$R 'VersionInfo.res'}
{$R *.RES}

const
     SDM_DEBUG = 0;           // Perform some Debug Action
     SDM_CLICK = 1;           // Click             | P1=Mouse.X | P2=Mouse.Y
     SDM_DOUBLE_CLICK = 2;    // Double Click      | P1=Mouse.X | P2=Mouse.Y
     SDM_MOUSE_ENTER = 3;     // On Mouse Enter    | P1=Mouse.X | P2=Mouse.Y
     SDM_MOUSE_LEAVE = 4;     // On Mouse Leave    | P1=Mouse.X | P2=Mouse.Y
     SDM_MOUSE_MOVE = 5;      // On Mouse Move;    | P1=Mouse.X | P2=Mouse.Y
     SDM_MOUSE_UP = 6;        // On Mouse Up;      | P1=Mouse.X | P2=Mouse.Y | P3=Button
     SDM_MOUSE_DOWN = 7;      // On Mouse Down;    | P1=Mouse.X | P2=Mouse.Y | P3=Button
     SDM_CLOSE_LAYER = 8;     // Close the Layer
     SDM_SHUTDOWN = 9;        // Shutdown whole Object and Close all Plugins
     SDM_REPAINT_LAYER = 10;  // Repaint the Layer
     SDM_MENU_CLICK = 11;  // Repaint the Layer
     SDM_SELECT = 12;  // Repaint the Layer
     SDM_DESELECT = 13;  // Repaint the Layer
     SDM_MOVE_LAYER = 14;
     SDM_MENU_POPUP = 15;
     SDM_UPDATE_LAYER = 16;

type
    TLayerList = class (TObjectList)
                 private
                 public
                 end;

    TLayer = class
             private
              FObjectID : integer;
              FLayer : TClockLayer;
             public
              destructor Destroy; override;

              property ObjectID : integer read FObjectID write FObjectID;
              property ClockLayer : TClockLayer read FLayer write FLayer;
             end;

var
  LayerList : TLayerList;
  DeskSettings   : TDeskSettings;
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
  Layer.ClockLayer := TClockLayer.create(Image, ObjectID, DeskSettings);
  Layer.ClockLayer.Tag:=ObjectID;
  result := Layer.ClockLayer;
end;

procedure SharpDeskMessage(pObjectID : integer; pLayer : TBitmapLayer; DeskMessage,P1,P2,P3 : integer);
var
   n : integer;
   Layer : TLayer;
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
                   if P1 = 0 then Layer.ClockLayer.Locked := False
                      else Layer.ClockLayer.Locked := True;
                      Layer.ClockLayer.StartHL;
                   end;
    SDM_DESELECT : Layer.ClockLayer.EndHL;
    SDM_SETTINGS_UPDATE :
      Layer.ClockLayer.LoadSettings;
   SDM_REPAINT_LAYER : Layer.ClockLayer.LoadSettings;
   SDM_CLOSE_LAYER : begin
                      SharpApi.SendDebugMessageEx('Clock.Object',PChar('Removing : ' + inttostr(Layer.ObjectID)),0,DMT_INFO);
                      LayerList.Remove(Layer);
                      SharpApi.SendDebugMessageEx('Clock.Object',PChar('Freeing : ' + inttostr(Layer.ObjectID)),0,DMT_INFO);
                      SharpApi.SendDebugMessageEx('Clock.Object',PChar('Object removed'),0,DMT_INFO);
                    end;
  SDM_SHUTDOWN : begin
                   LayerList.Clear;
                   LayerList.Free;
                   LayerList := nil;
                   FirstStart := True;
                 end;
  end;
end;

procedure InitSettings;
begin
  
end;

function GetMetaData(Preview : TBitmap32) : TMetaData;
begin
  with result do
  begin
    Name := 'Clock';
    Author := 'James Brumbaugh <James@SharpEnviro.com> and Martin Kr�mer <Martin@SharpEnviro.com>';
    Description := 'Displays a skinned analog or digital clock on your desktop. Different skins are available.';
    ExtraData := 'preview: False';
    DataType := tteModule;
  end;
end;


exports
  CreateLayer,
  SharpDeskMessage,
  InitSettings,
  GetMetaData;

begin
end.

