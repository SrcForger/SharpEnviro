{
Source Name: Text Object
Description: Desktop Object for displaying text
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

library Text;
uses
//  VCLFixPack,
  Forms,
  windows,
  graphics,
  Dialogs,
  sysUtils,
  menus,
  Contnrs,
  Classes,
  pngimage,
  JvSimpleXML,
  gr32,
  GR32_Image,
  GR32_Layers,
  GR32_Transforms,
  PngImageList,
  uTextObjectLayer in 'uTextObjectLayer.pas',
  uSharpDeskFunctions,
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpDeskApi in '..\..\..\Common\Libraries\SharpDeskApi\SharpDeskApi.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  TextObjectXMLSettings in 'TextObjectXMLSettings.pas',
  uSharpDeskDesktopPanel in '..\..\SharpDesk\Units\uSharpDeskDesktopPanel.pas',
  BasicHTMLRenderer in 'BasicHTMLRenderer.pas';

{$R *.RES}
{$R icons.res}
// {$EXTENSION obj}

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
     SDM_MENU_CLICK = 11;
     SDM_SELECT = 12;
     SDM_DESELECT = 13;
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
              FLayer : TTextLayer;
             public
              destructor Destroy; override;

              property ObjectID : integer read FObjectID write FObjectID;
              property TextLayer : TTextLayer read FLayer write FLayer;
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
  Layer.TextLayer := TTextLayer.create(Image, ObjectID);
  Layer.TextLayer.Tag:=ObjectID;
  result := Layer.TextLayer;
end;

procedure SharpDeskMessage(pObjectID : integer; pLayer : TBitmapLayer; DeskMessage,P1,P2,P3 : integer);
var
   Menu : TPopupMenu;
   MenuItem : TMenuItem;
   bmp : TBitmap;
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
    SDM_DOUBLE_CLICK : Layer.TextLayer.DoubleClick;
    SDM_REPAINT_LAYER : Layer.TextLayer.LoadSettings;
    SDM_MOUSE_ENTER,SDM_SELECT : //if Layer.TextLayer.Highlight <> True then
                                // begin
                                   Layer.TextLayer.StartHL;
//                                   Layer.TextLayer.Highlight := True;
  //                                 Layer.TextLayer.drawBitmap;
                                 //end;
    SDM_MOUSE_LEAVE,SDM_DESELECT : Layer.TextLayer.EndHL;
//    if Layer.TextLayer.Highlight <> False then
  //                                 begin
    //                                 Layer.TextLayer.EndHL;
//                                     Layer.TextLayer.Highlight := False;
//                                     Layer.TextLayer.drawBitmap;
      //                             end;
    SDM_CLOSE_LAYER : begin
                        SharpApi.SendDebugMessageEx('Link.Object',PChar('Removing : ' + inttostr(Layer.ObjectID)),0,DMT_INFO);
                        LayerList.Remove(Layer);
                        SharpApi.SendDebugMessageEx('Link.Object',PChar('Freeing : ' + inttostr(Layer.ObjectID)),0,DMT_INFO);
                        Layer := nil;
                        SharpApi.SendDebugMessageEx('Link.Object',PChar('Object removed'),0,DMT_INFO);                        
                      end;
    SDM_SHUTDOWN : begin
                     LayerList.Clear;
                     LayerList.Free;
                     LayerList := nil;
                     FirstStart := True;
                   end;

    SDM_MENU_POPUP : begin
                       Bmp := TBitmap.Create;
                       Menu := Layer.TextLayer.ParentImage.PopupMenu;

                       MenuItem := TMenuItem.Create(Menu.Items);
                       MenuItem.Caption := 'Open';
                       MenuItem.ImageIndex := 0;
                       MenuItem.OnClick := Layer.TextLayer.OnOpenClick;
                       Menu.Items.Add(MenuItem);
                       Bmp.LoadFromResourceID(HInstance,100);
                       TPngImageList(Menu.Images).AddMasked(bmp,clFuchsia);

                       Bmp.Free;
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

