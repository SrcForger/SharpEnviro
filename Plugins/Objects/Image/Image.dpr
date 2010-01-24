{
Source Name: Image Object
Description: Image desktop object Libary
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

library Image;
uses
  windows,
  graphics,
  Contnrs,
  sysUtils,
  menus,
  uImageObjectLayer in 'uImageObjectLayer.pas',
  pngimage,
  jvsimplexml,
  pngimagelist,
  gr32,
  GR32_Image,
  GR32_Layers,
  ImageObjectXMLSettings in 'ImageObjectXMLSettings.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpDeskApi in '..\..\..\Common\Libraries\SharpDeskApi\SharpDeskApi.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  SharpGraphicsUtils in '..\..\..\Common\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  uSharpDeskObjectSettings in '..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpImageUtils in '..\..\..\Common\Units\SharpImageUtils\SharpImageUtils.pas';

{$R *.RES}
{$R icons.res}

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
              FLayer : TImageLayer;
             public
              destructor Destroy; override;

              property ObjectID : integer read FObjectID write FObjectID;
              property ImageLayer : TImageLayer read FLayer write FLayer;
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
  Layer.ImageLayer := TImageLayer.create(Image, ObjectID);
 
  Layer.ImageLayer.Tag:=ObjectID;
  result := Layer.ImageLayer;
end;

procedure SharpDeskMessage(pObjectID : integer; pLayer : TBitmapLayer; DeskMessage,P1,P2,P3 : integer);
var
   Menu2 : TPopupMenu;
   MenuItem,MenuItem2 : TMenuItem;
   bmp2 : TBitmap;
   n : integer;
   Layer : TLayer;
   b : boolean;
   i : integer;
begin
  if FirstStart then exit;
  Layer := nil;

  case DeskMessage of
    SDM_SHUTDOWN : begin
                     LayerList.Clear;
                     LayerList.Free;
                     LayerList := nil;
                     FirstStart := True;
                     exit;
                    end;
  end;

  for n := 0 to LayerList.Count - 1 do
  begin
    if TLayer(LayerList.Items[n]).ObjectID = pObjectID then
    begin
      Layer := TLayer(LayerList.Items[n]);
      break;
    end;
  end;
  if (Layer = nil) then exit;

  case DeskMessage of
    SDM_SETTINGS_UPDATE : Layer.ImageLayer.LoadSettings;
    SDM_SELECT : begin
                   if P1 = 0 then Layer.ImageLayer.Locked := False
                      else Layer.ImageLayer.Locked := True;
                      Layer.ImageLayer.StartHL;
                   end;
    SDM_DESELECT : Layer.ImageLayer.EndHL;
    SDM_REPAINT_LAYER : Layer.ImageLayer.LoadSettings;
    SDM_CLOSE_LAYER : begin
                        SharpApi.SendDebugMessageEx('Image.Object',PChar('Removing : ' + inttostr(Layer.ObjectID)),0,DMT_INFO);
                        LayerList.Remove(Layer);
                        SharpApi.SendDebugMessageEx('Image.Object',PChar('Freeing : ' + inttostr(Layer.ObjectID)),0,DMT_INFO);
                        SharpApi.SendDebugMessageEx('Image.Object',PChar('Object removed'),0,DMT_INFO);
                      end;
     SDM_MENU_POPUP : begin
                        Bmp2 := TBitmap.Create;
                        Menu2 := Layer.ImageLayer.ParentImage.PopupMenu;

                        MenuItem := TMenuItem.Create(Menu2.Items);
                        MenuItem.Caption := 'Open';
                        MenuItem.ImageIndex := Menu2.Images.Count;
                        MenuItem.OnClick := Layer.ImageLayer.OnOpenClick;
                        Menu2.Items.Insert(0,MenuItem);
                        Bmp2.LoadFromResourceID(HInstance,103);
                        TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);

                        MenuItem := TMenuItem.Create(Menu2.Items);
                        MenuItem.Caption := 'Properties';
                        MenuItem.ImageIndex := Menu2.Images.Count;
                        MenuItem.OnClick := Layer.ImageLayer.OnPropertiesClick;
                        Menu2.Items.Insert(1,MenuItem);
                        Bmp2.LoadFromResourceID(HInstance,102);
                        TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);

                        MenuItem := TMenuItem.Create(Menu2.Items);
                        MenuItem.Caption := 'Size';
                        MenuItem.ImageIndex := Menu2.Images.Count;
                        Menu2.Items.Insert(2,MenuItem);
                        Bmp2.LoadFromResourceID(HInstance,100);
                        TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);

                        Bmp2.LoadFromResourceID(HInstance,101);
                        TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);
                        Bmp2.LoadFromResourceID(HInstance,104);
                        TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);

                        b := False;
                        for i:=1 to 8 do
                        begin
                          MenuItem2 := TMenuItem.Create(MenuItem);
                          MenuItem2.Caption := inttostr(i*25)+'%';
                          if i*25 = layer.ImageLayer.Size then
                          begin
                            MenuItem2.ImageIndex := Menu2.Images.Count-1;
                            b := True;
                          end else MenuItem2.ImageIndex := Menu2.Images.Count-2;
                          MenuItem2.Tag := i*25;
                          MenuItem2.OnClick := Layer.ImageLayer.SizeOnClick;
                          MenuItem.Add(MenuItem2);
                        end;

                        if not b then
                        begin
                          MenuItem2 := TMenuItem.Create(MenuItem);
                          MenuItem2.Caption := 'Custom Size : ' + inttostr(Layer.ImageLayer.Size);
                          MenuItem2.ImageIndex := Menu2.Images.Count - 1;
                          MenuItem2.Tag := Layer.ImageLayer.Size;
                          MenuItem.Add(MenuItem2);
                        end;
                        Bmp2.Free;
                    end;
     end;
end;

procedure InitSettings();
var
  XML : TJvSimpleXML;
  n : integer;
  Ext : String;
  Settings : TImageXMLSettings;          
begin
  XML := TJvSimpleXML.Create(nil);
  try
    ForceDirectories(GetSharpeGlobalSettingsPath + 'SharpDesk\DragAndDrop\');  
    for n := 0 to 4 do
    begin
      case n of
        0 : ext := 'bmp';
        1 : ext := 'jpg';
        2 : ext := 'jpeg';
        3 : ext := 'png';
        4 : ext := 'ico';
      end;

      XML.Root.Items.Clear;
      XML.Root.Name := 'Image.object';
      XML.Root.Items.Add('Settings');
      with XML.Root.Items.ItemNamed['Settings'].Items do
      begin
        Add('Object','Image.object');
        Add('FileExt','.'+Ext);
        Add('MaxLength',0);
      end;
      XML.Root.Items.Add('DefaultSettings');
      Settings := TImageXMLSettings.Create(-1,XML.Root.Items.ItemNamed['DefaultSettings'],'Image');
      Settings.LoadSettings;
      Settings.Path := '{File}';
      Settings.SaveSettings(False);
      Settings.Free;
      XML.SaveToFile(GetSharpeGlobalSettingsPath + 'SharpDesk\DragAndDrop\Image('+Ext+').xml');
    end;
  finally
    XML.Free;
  end;
end;


Exports
  CreateLayer,
  SharpDeskMessage,
  InitSettings;

begin
end.

