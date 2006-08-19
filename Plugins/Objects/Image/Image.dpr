{
Source Name: Image Object
Description: Image desktop object Libary
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
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

library Image;
uses
  Forms,
  windows,
  graphics,
  Contnrs,
  Dialogs,
  sysUtils,
  menus,
  ImageObjectSettingsWnd in 'ImageObjectSettingsWnd.pas' {SettingsWnd},
  uImageObjectLayer in 'uImageObjectLayer.pas',
  pngimage,
  jvsimplexml,
  gr32,
  GR32_Image,
  GR32_Layers,
  GR32_Transforms,
  ImageObjectXMLSettings in 'ImageObjectXMLSettings.pas',
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
  uSharpDeskDesktopPanelList in '..\..\SharpDesk\Units\uSharpDeskDesktopPanelList.pas';

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
                 published
                 end;

    TLayer = class
             private
              FObjectID : integer;
              FLayer : TImageLayer;
             public
              destructor Destroy; override;
             published
              property ObjectID : integer read FObjectID write FObjectID;
              property ImageLayer : TImageLayer read FLayer write FLayer;
             end;

var
  LayerList : TLayerList;
  DeskSettings   : TDeskSettings;
  ObjectSettings : TObjectSettings;
  ThemeSettings  : TThemeSettings;
  FirstStart : boolean = True;
  SettingsWnd : TSettingsWnd;


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
  Layer.ImageLayer := TImageLayer.create(Image, ObjectID, DeskSettings,ThemeSettings,ObjectSettings);
  Layer.ImageLayer.Tag:=ObjectID;
  result := Layer.ImageLayer;
end;

function StartSettingsWnd(ObjectID : integer; Handle : hwnd) : hwnd;
begin
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
   Menu : TPopupMenu;
   MenuItem : TMenuItem;
   MenuItem2 : TMenuItem;   
   bmp : TBitmap;
   n : integer;
   Layer : TLayer;
   b : boolean;
   i : integer;
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
                      Layer := nil;
                      SharpApi.SendDebugMessageEx('Image.Object',PChar('Object removed'),0,DMT_INFO);
                    end;
  SDM_SHUTDOWN : begin
                   LayerList.Clear;
                   LayerList.Free;
                   LayerList := nil;
                   FirstStart := True;
                 end;
   SDM_MENU_POPUP : begin
                      Bmp := TBitmap.Create;
                      Menu := TForm(Layer.ImageLayer.ParentImage.Parent).PopupMenu;

                      MenuItem := TMenuItem.Create(Menu.Items);
                      MenuItem.Caption := 'Open';
                      MenuItem.ImageIndex := 0;
                      MenuItem.OnClick := Layer.ImageLayer.OnOpenClick;
                      Menu.Items.Add(MenuItem);
                      Bmp.LoadFromResourceID(HInstance,103);
                      Menu.Images.AddMasked(bmp,clFuchsia);

                      MenuItem := TMenuItem.Create(Menu.Items);
                      MenuItem.Caption := 'Properties';
                      MenuItem.ImageIndex := 1;
                      MenuItem.OnClick := Layer.ImageLayer.OnPropertiesClick;
                      Menu.Items.Add(MenuItem);
                      Bmp.LoadFromResourceID(HInstance,102);
                      Menu.Images.AddMasked(bmp,clFuchsia);

                      MenuItem := TMenuItem.Create(Menu.Items);
                      MenuItem.Caption := 'Size';
                      MenuItem.ImageIndex := 2;
                      Menu.Items.Add(MenuItem);
                      Bmp.LoadFromResourceID(HInstance,100);
                      Menu.Images.AddMasked(bmp,clFuchsia);

                      Bmp.LoadFromResourceID(HInstance,101);
                      Menu.Images.AddMasked(bmp,clFuchsia);
                      Bmp.LoadFromResourceID(HInstance,104);
                      Menu.Images.AddMasked(bmp,clFuchsia);

                      b := False;
                      for i:=1 to 8 do
                      begin
                        MenuItem2 := TMenuItem.Create(MenuItem);
                        MenuItem2.Caption := inttostr(i*25)+'%';
                        if i*25 = layer.ImageLayer.Size then
                        begin
                          MenuItem2.ImageIndex := 4;
                          b := True;
                        end else MenuItem2.ImageIndex := 3;
                        MenuItem2.Tag := i*25;
                        MenuItem2.OnClick := Layer.ImageLayer.SizeOnClick;
                        MenuItem.Add(MenuItem2);
                      end;

                      if not b then
                      begin
                        MenuItem2 := TMenuItem.Create(MenuItem);
                        MenuItem2.Caption := 'Custom Size : ' + inttostr(Layer.ImageLayer.Size);
                        MenuItem2.ImageIndex := 4;
                        MenuItem2.Tag := Layer.ImageLayer.Size;
                        MenuItem.Add(MenuItem2);
                      end;
                      Bmp.Free;
                    end;                     
     end;
end;

procedure GetSettings( pDeskSettings   : TDeskSettings;
                       pThemeSettings  : TThemeSettings;
                       pObjectSettings : TObjectSettings);
var
  XML : TJvSimpleXML;
  n : integer;
  Ext : String;
  Settings : TXMLSettings;          
begin
  DeskSettings   := pDeskSettings;
  ThemeSettings  := pThemeSettings;
  ObjectSettings := pObjectSettings;

  XML := TJvSimpleXML.Create(nil);
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
    try
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
      Settings := TXMLSettings.Create(-1,XML.Root.Items.ItemNamed['DefaultSettings']);
      Settings.LoadSettings;
      Settings.IconFile := '{File}';
      Settings.SaveSettings(False);
      Settings.Free;
      XML.SaveToFile(GetSharpeGlobalSettingsPath + 'SharpDesk\DragAndDrop\Image('+Ext+').xml');
    finally
    end;
  end;
  XML.Free;  
end;


Exports
  CloseSettingsWnd,
  CreateLayer,
  StartSettingsWnd,
  SharpDeskMessage,
  GetSettings;

begin
end.

