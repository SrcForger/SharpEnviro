{
Source Name: Recycle Object
Description: Desktop Object for RecylceBin usage 
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

library RecycleBin;
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
  uRecycleBinObjectLayer in 'uRecycleBinObjectLayer.pas',
  RecylceBinObjectSettingsWnd in 'RecylceBinObjectSettingsWnd.pas' {SettingsWnd},
  RecycleBinObjectXMLSettings in 'RecycleBinObjectXMLSettings.pas',
  mlinewnd in 'mlinewnd.pas' {mlineform},
  uSharpDeskObjectSettings in '..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas';

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
              FLayer : TRecycleBinLayer;
             public
              destructor Destroy; override;
             published
              property ObjectID : integer read FObjectID write FObjectID;
              property RecycleBinLayer : TRecycleBinLayer read FLayer write FLayer;
             end;

var
   LayerList : TLayerList;
   FirstStart : boolean = True;
   DLLHandle : THandle;
   SHEmptyRecycleBin : function (hwnd: HWND; pszRootPath: PChar; dwFlags: DWord): HResult; stdcall;
   SHQueryRecycleBin : function (pszrtootpath:pchar;QUERYRBINFO:pshqueryrbinfo):integer; stdcall;


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
  Layer.RecycleBinLayer := TRecycleBinLayer.create(Image, ObjectID);
  Layer.RecycleBinLayer.Tag:=ObjectID;
  Layer.RecycleBinLayer.SHEmptyRecycleBin := @SHEmptyRecycleBin;
  Layer.RecycleBinLayer.SHQueryRecycleBin := @SHQueryRecycleBin;
  result := Layer.RecycleBinLayer;
end;

function GetControlByHandle(AHandle: THandle): TWinControl; 
begin 
 Result := Pointer(GetProp( AHandle, 
                            PChar( Format( 'Delphi%8.8x', 
                                           [GetCurrentProcessID])))); 
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
    if Layer <> nil then Layer.RecycleBinLayer.EndHL;    
  end;

  if SettingsWnd=nil then SettingsWnd := TSettingsWnd.Create(nil);
  SettingsWnd.ParentWindow:=Handle;
  SettingsWnd.Left:=0;
  SettingsWnd.Top:=0;
  SettingsWnd.BorderStyle:=bsNone;
  SettingsWnd.ObjectID:=ObjectID;
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
   Menu,Menu2 : TPopupMenu;
   MenuItem : TMenuItem;
   bmp2 : TBitmap;
   n : integer;
   s : String;
   b : boolean;
   Layer : TLayer;
begin
  if FirstStart then exit;

  case DeskMessage of
    SDM_SHUTDOWN : begin
                     LayerList.Clear;
                     LayerList.Free;
                     LayerList := nil;
                     FirstStart := True;
                     try
                       FreeLibrary(Dllhandle);
                     finally
                       Dllhandle := 0;
                     end;
                    end;
  end;

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
    SDM_DOUBLE_CLICK : ;//Layer.RecycleBinLayer.DoubleClick;
    SDM_REPAINT_LAYER : Layer.RecycleBinLayer.LoadSettings;
    SDM_SELECT : begin
                   if P1 = 0 then Layer.RecycleBinLayer.Locked := False
                      else Layer.RecycleBinLayer.Locked := True;
                      Layer.RecycleBinLayer.StartHL;
                   end;
    SDM_DESELECT : Layer.RecycleBinLayer.EndHL;
    SDM_CLOSE_LAYER : begin
                        LayerList.Remove(Layer);
                        Layer := nil;
                      end;

    SDM_MENU_POPUP : begin
                       Bmp2 := TBitmap.Create;
                       Menu := TForm(Layer.RecycleBinLayer.FParentImage.Parent).PopupMenu;
                       Menu2 := Layer.RecycleBinLayer.FParentImage.PopupMenu;                       

                       MenuItem := TMenuItem.Create(Menu.Items);
                       MenuItem.Caption := 'Open';
                       MenuItem.ImageIndex := 0;
                       MenuItem.OnClick := Layer.RecycleBinLayer.OnOpenClick;
                       Menu.Items.Add(MenuItem);
                       Bmp2.LoadFromResourceID(HInstance,100);
                       Menu.Images.AddMasked(bmp2,clFuchsia);

                       MenuItem := TMenuItem.Create(Menu.Items);
                       MenuItem.Caption := 'Empty Recycle Bin';
                       MenuItem.ImageIndex := 1;
                       MenuItem.OnClick := Layer.RecycleBinLayer.OnEmptyBinClick;
                       Menu.Items.Add(MenuItem);
                       Bmp2.LoadFromResourceID(HInstance,103);
                       Menu.Images.AddMasked(Bmp2,clFuchsia);

                       MenuItem := TMenuItem.Create(Menu2.Items);
                       MenuItem.Caption := 'Properties';
                       MenuItem.ImageIndex := Menu2.Images.Count;
                       MenuItem.OnClick := Layer.RecycleBinLayer.OnPropertiesClick;
                       Menu2.Items.Add(MenuItem);
                       Bmp2.LoadFromResourceID(HInstance,102);
                       Menu2.Images.AddMasked(bmp2,clFuchsia);

                       Bmp2.Free;
                     end;
     end;
end;



procedure InitSettings();
begin
  try
    SharpApi.SendDebugMessage('RecycleBin.object','Loading shell32.dll',clblack);
    Dllhandle := LoadLibrary('shell32.dll');

    if Dllhandle <> 0 then
    begin
      SharpApi.SendDebugMessage('RecycleBin.object','SHEmptyRecycleBin := GetProcAddress(dllhandle, "SHEmptyRecycleBinA");',clblack);
      @SHEmptyRecycleBin := GetProcAddress(dllhandle, 'SHEmptyRecycleBinA');
      SharpApi.SendDebugMessage('RecycleBin.object','SHQueryRecycleBin := GetProcAddress(dllhandle, "SHQueryRecycleBinA");',clblack);
      @SHQueryRecycleBin := GetProcAddress(dllhandle, 'SHQueryRecycleBinA');
    end;

    if @SHEmptyRecycleBin = nil then
       SharpApi.SendDebugMessageEx('RecycleBin.object','Failed to get SHEmptyRecycleBin',clRed,DMT_ERROR);
    if @SHQueryRecycleBin = nil then
       SharpApi.SendDebugMessageEx('RecycleBin.object','Failed to get SHQueryRecycleBin',clRed,DMT_ERROR);
  except
    SharpApi.SendDebugMessageEx('RecycleBin.object','Failed to load shell32.dll',clRed,DMT_ERROR);
    try
      FreeLibrary(Dllhandle);
    finally
      Dllhandle := 0;
    end;
  end;
end;


Exports
  CloseSettingsWnd,
  CreateLayer,
  StartSettingsWnd,
  SharpDeskMessage,
  InitSettings;

begin
end.

