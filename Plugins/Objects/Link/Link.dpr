{
Source Name: Link Object
Description: Desktop Object for linking files,folders,urls,...
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

library link;

uses
//  VCLFixPack,
  Forms,
  windows,
  graphics,
  sysUtils,
  menus,
  Contnrs,
  Classes,
  pngimage,
  pngimagelist,
  ExtCtrls,
  JvSimpleXML,
  controls,
  gr32,
  GR32_Image,
  GR32_Layers,
  GR32_Transforms,
  JclFileUtils,
  uSharpDeskFunctions,
  SharpApi,
  SharpDeskApi,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uLinkObjectLayer in 'uLinkObjectLayer.pas',
  LinkObjectXMLSettings in 'LinkObjectXMLSettings.pas',
  uSharpDeskObjectSettings in '..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas',
  SharpGraphicsUtils in '..\..\..\Common\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas';

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
              FLayer : TLinkLayer;
             public
              destructor Destroy; override;

              property ObjectID : integer read FObjectID write FObjectID;
              property FolderLayer : TLinkLayer read FLayer write FLayer;
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
  Layer.FolderLayer := TLinkLayer.create(Image, ObjectID);
  Layer.FolderLayer.Tag:=ObjectID;
  result := Layer.FolderLayer;
end;

function GetControlByHandle(AHandle: THandle): TWinControl; 
begin 
 Result := Pointer(GetProp( AHandle, 
                            PChar( Format( 'Delphi%8.8x', 
                                           [GetCurrentProcessID])))); 
end;

procedure SharpDeskMessage(pObjectID : integer; pLayer : TBitmapLayer; DeskMessage,P1,P2,P3 : integer);
var
   Menu2 : TPopupMenu;
   MenuItem : TMenuItem;
   bmp2 : TBitmap;
   n : integer;
   s : String;
   b : boolean;
   Layer : TLayer;
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
  if Layer = nil then exit;
  case DeskMessage of
    SDM_SETTINGS_UPDATE : Layer.FolderLayer.LoadSettings;
    SDM_DOUBLE_CLICK : Layer.FolderLayer.DoubleClick;
    SDM_REPAINT_LAYER : Layer.FolderLayer.LoadSettings;
    SDM_SELECT : begin
                   if P1 = 0 then Layer.FolderLayer.Locked := False
                      else Layer.FolderLayer.Locked := True;
                      Layer.FolderLayer.StartHL;
                   end;
    SDM_DESELECT : Layer.FolderLayer.EndHL;
    SDM_CLOSE_LAYER : begin
                        LayerList.Remove(Layer);
                      end;

    SDM_MENU_POPUP : begin
                       Bmp2 := TBitmap.Create;
                       Menu2 := Layer.FolderLayer.FParentImage.PopupMenu;

                       MenuItem := TMenuItem.Create(Menu2.Items);
                       MenuItem.Caption := 'Open';
                       MenuItem.ImageIndex := Menu2.Images.Count;
                       MenuItem.OnClick := Layer.FolderLayer.OnOpenClick;
                       Menu2.Items.Insert(0,MenuItem);
                       Bmp2.LoadFromResourceID(HInstance,100);
                       TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);

                       MenuItem := TMenuItem.Create(Menu2.Items);
                       MenuItem.Caption := 'Open With...';
                       MenuItem.ImageIndex := Menu2.Images.Count;
                       MenuItem.OnClick := Layer.FolderLayer.OnOpenWith;
                       Menu2.Items.Insert(1,MenuItem);
                       Bmp2.LoadFromResourceID(HInstance,103);
                       TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);
                       if (FileExists(Layer.FolderLayer.Settings.Target))
                          and (CompareText(ExtractFileExt(Layer.FolderLayer.Settings.Target),'.exe') = 0) then
                              MenuItem.Visible := True
                              else MenuItem.Visible := False;

                       {MenuItem := TMenuItem.Create(Menu2.Items);
                       MenuItem.Caption := 'Search';
                       MenuItem.ImageIndex := Menu2.Images.Count;
                       MenuItem.OnClick := Layer.FolderLayer.OnSearchClick;
                       MenuItem.Visible := False;
                       Menu2.Items.Insert(2,MenuItem);
                       Bmp2.LoadFromResourceID(HInstance,101);
                       TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);  }

                       s := Layer.FolderLayer.Settings.Target;
                       b := False;
                       if (s[1] = '\') and (s[2] = '\') then // Network Folder
                          b := True
                          else if FileExists(s) or isDirectory(s) then
                                  b := True;
                       if b then
                       begin
                         MenuItem := TMenuItem.Create(Menu2.Items);
                         MenuItem.Caption := 'File Properties';
                         MenuItem.ImageIndex := Menu2.Images.Count;
                         MenuItem.OnClick := Layer.FolderLayer.OnPropertiesClick;
                         Menu2.Items.Add(MenuItem);
                         Bmp2.LoadFromResourceID(HInstance,102);
                         TPngImageList(Menu2.Images).AddMasked(bmp2,clFuchsia);
                       end;

                       Bmp2.Free;
                     end;
     end;
end;



procedure InitSettings();
var
  XML : TJvSimpleXML;
  Settings: TLinkXMLSettings;
begin
  XML := TJvSimpleXML.Create(nil);
  try
    ForceDirectories(GetSharpeGlobalSettingsPath + 'SharpDesk\DragAndDrop\');
    XML.Root.Items.Clear;
    XML.Root.Name := 'Link.object';
    XML.Root.Items.Add('Settings');
    with XML.Root.Items.ItemNamed['Settings'].Items do
    begin
      Add('Object','Link.dll');
      Add('FileExt','*.*');
      Add('MaxLength',0);
    end;
    XML.Root.Items.Add('DefaultSettings');
    Settings := TLinkXMLSettings.Create(-1,XML.Root.Items.ItemNamed['DefaultSettings'],'Link');
    Settings.LoadSettings;
    Settings.Target := '{File}';
    Settings.Caption := '{FileName}';
    Settings.Icon := 'shell:icon';
    Settings.MLineCaption := False;
    Settings.SaveSettings(False);
    Settings.Free;
    XML.SaveToFile(GetSharpeGlobalSettingsPath + 'SharpDesk\DragAndDrop\Link().xml');
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

