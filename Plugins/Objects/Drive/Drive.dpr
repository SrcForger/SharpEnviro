{
Source Name: Drive Object
Description: Desktop Object for linking system drives
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

library Drive;
uses
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
  uDriveObjectLayer in 'uDriveObjectLayer.pas',
  DriveObjectSettingsWnd in 'DriveObjectSettingsWnd.pas' {SettingsWnd},
  DriveObjectXMLSettings in 'DriveObjectXMLSettings.pas',
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
  mlinewnd in 'mlinewnd.pas' {mlineform};

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
                 published
                 end;

    TLayer = class
             private
              FObjectID : integer;
              FLayer : TDriveLayer;
             public
              destructor Destroy; override;
             published
              property ObjectID : integer read FObjectID write FObjectID;
              property DriveLayer : TDriveLayer read FLayer write FLayer;
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
  Layer.DriveLayer := TDriveLayer.create(Image, ObjectID, DeskSettings,ThemeSettings,ObjectSettings);
  Layer.DriveLayer.Tag:=ObjectID;
  result := Layer.DriveLayer;
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
    if Layer <> nil then Layer.DriveLayer.EndHL;    
  end;

  if SettingsWnd=nil then SettingsWnd := TSettingsWnd.Create(nil);
  SettingsWnd.ParentWindow:=Handle;
  SettingsWnd.Left:=0;
  SettingsWnd.Top:=0;
  SettingsWnd.BorderStyle:=bsNone;
  SettingsWnd.ObjectID:=ObjectID;
  SettingsWnd.DeskSettings   := DeskSettings;
  SettingsWnd.ObjectSettings := ObjectSettings;
  Settingswnd.ThemeSettings  := ThemeSettings;
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
      SettingsWnd.SaveSettings(True);
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
    SDM_DOUBLE_CLICK : Layer.DriveLayer.DoubleClick;
    SDM_REPAINT_LAYER : Layer.DriveLayer.LoadSettings;
    SDM_SELECT : begin
                   if P1 = 0 then Layer.DriveLayer.Locked := False
                      else Layer.DriveLayer.Locked := True;
                      Layer.DriveLayer.StartHL;
                   end;
    SDM_DESELECT : Layer.DriveLayer.EndHL;
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
                       Menu := TForm(Layer.DriveLayer.FParentImage.Parent).PopupMenu;
                       Menu2 := Layer.DriveLayer.FParentImage.PopupMenu;                       

                       MenuItem := TMenuItem.Create(Menu.Items);
                       MenuItem.Caption := 'Open';
                       MenuItem.ImageIndex := 0;
                       MenuItem.OnClick := Layer.DriveLayer.OnOpenClick;
                       Menu.Items.Add(MenuItem);
                       Bmp.LoadFromResourceID(HInstance,100);
                       Menu.Images.AddMasked(bmp,clFuchsia);

                       MenuItem := TMenuItem.Create(Menu.Items);
                       MenuItem.Caption := 'Open With...';
                       MenuItem.ImageIndex := 1;
                       MenuItem.OnClick := Layer.DriveLayer.OnOpenWith;
                       Menu.Items.Add(MenuItem);
                       Bmp.LoadFromResourceID(HInstance,103);
                       Menu.Images.AddMasked(bmp,clFuchsia);
                       if (FileExists(Layer.DriveLayer.Settings.Target))
                          and (LOWERCASE(ExtractFileExt(Layer.DriveLayer.Settings.Target))<>'.exe') then
                              MenuItem.Visible := True
                              else MenuItem.Visible := False;

                       MenuItem := TMenuItem.Create(Menu.Items);
                       MenuItem.Caption := 'Search';
                       MenuItem.ImageIndex := 2;
                       MenuItem.OnClick := Layer.DriveLayer.OnSearchClick;
                       MenuItem.Visible := False;
                       Menu.Items.Add(MenuItem);
                       Bmp.LoadFromResourceID(HInstance,101);
                       Menu.Images.AddMasked(bmp,clFuchsia);

                       MenuItem := TMenuItem.Create(Menu2.Items);
                       MenuItem.Caption := 'Properties';
                       MenuItem.ImageIndex := Menu2.Images.Count;
                       MenuItem.OnClick := Layer.DriveLayer.OnPropertiesClick;
                       Menu2.Items.Add(MenuItem);
                       Bmp.LoadFromResourceID(HInstance,102);
                       Menu2.Images.AddMasked(bmp,clFuchsia);

                       Bmp.Free;
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
  color1,color2 : TColor32;
  SList : TStringList;
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
  SList.Add('Drive : ' + Layer.DriveLayer.Settings.Target + ':\');
  SList.Add('Label : ' + Layer.DriveLayer.Settings.Caption);  
  SList.Add('Disk Size : ' + inttostr(Layer.DriveLayer.DiskMax)+' MB');
  SList.Add('Free Disk Space : ' + inttostr(Layer.DriveLayer.DiskMax-Layer.DriveLayer.Diskfull)+' MB');  

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
        RenderText(4,n*eh+2,SList[n],0,color32(Font.Color));
    EndUpdate;
    Changed;    
  end;

  SList.Free;
end;



procedure GetSettings( pDeskSettings   : TDeskSettings;
                       pThemeSettings  : TThemeSettings;
                       pObjectSettings : TObjectSettings);
var
  XML : TJvSimpleXML;
  Settings : TXMLSettings;
begin
  DeskSettings   := pDeskSettings;
  ThemeSettings  := pThemeSettings;
  ObjectSettings := pObjectSettings;

  XML := TJvSimpleXML.Create(nil);
  try
    ForceDirectories(GetSharpeGlobalSettingsPath + 'SharpDesk\DragAndDrop\');
    XML.Root.Items.Clear;
    XML.Root.Name := 'Drive.object';
    XML.Root.Items.Add('Settings');
    with XML.Root.Items.ItemNamed['Settings'].Items do
    begin
      Add('Object','Drive.object');
      Add('FileExt','');
      Add('MaxLength',3);
    end;
    XML.Root.Items.Add('DefaultSettings');
    Settings := TXMLSettings.Create(-1,XML.Root.Items.ItemNamed['DefaultSettings']);
    Settings.LoadSettings;
    Settings.Target := '{File}';
    Settings.Caption := '[{File}]';
    Settings.SaveSettings(False);
    Settings.Free;
    XML.SaveToFile(GetSharpeGlobalSettingsPath + 'SharpDesk\DragAndDrop\Drive().xml');
  finally
    XML.Free;
  end;
end;


Exports
  CloseSettingsWnd,
  CreateLayer,
  StartSettingsWnd,
  SharpDeskMessage,
  RenderTooltip,
  GetSettings;

begin
end.

