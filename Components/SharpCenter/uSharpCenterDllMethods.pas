{
Source Name: uSharpCenterDllMethods
Description: Plugin Interface for the SharpCenter Settings
Copyright (C) Pixol - pixol@sharpe-shell.org

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
unit uSharpCenterDllMethods;

interface
uses
  Windows,
  dialogs,
  shellapi,
  graphics,
  PngSpeedButton,
  Classes,
  sharpapi,
  Tabs,
  GR32_Image,
  GR32,
  uSharpCenterPluginTabList,
  SharpCenterApi;

type
  TSetting = record
    Filename: string;
    Dllhandle: Thandle;

    Open: function(const APluginID:Pchar; AOwner: hwnd): hwnd;
    Close: procedure;
    Save: procedure;

    OpenEdit: function(AOwner:Hwnd; AEditMode:TSCE_EDITMODE_ENUM):Hwnd;
    CloseEdit: function(AEditMode:TSCE_EDITMODE_ENUM; AApply:Boolean): boolean;

    ClickBtn: procedure (AButton: TSCB_BUTTON_ENUM; AText: String);
    ClickTab: procedure (ATab: TPluginTabItem);
    AddTabs: procedure(var ATabs:TPluginTabItemList);

    UpdatePreview: procedure (var ABmp:TBitmap32);

    SetText: procedure (const APluginID:string; var AName:string;
      var AStatus: string; var ATitle: string; var ADescription: string);

    SetSettingType: function(): TSU_UPDATE_ENUM;
    SetBtnState : function(AButton: TSCB_BUTTON_ENUM): Boolean;

    GetCenterScheme: procedure (var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
  end;
  PSetting = ^TSetting;

  // functions to use for loading Plugins
function LoadPlugin(filename: Pchar): TSetting;
function UnloadPlugin(plugin: PSetting): hresult;

implementation

function UnloadPlugin(plugin: PSetting): hresult;
begin
  result := 0;
  try
    plugin.Open := nil;
    plugin.Close := nil;
    plugin.Save := nil;

    plugin.OpenEdit := nil;
    plugin.CloseEdit := nil;

    plugin.ClickBtn := nil;
    plugin.ClickTab := nil;
    plugin.AddTabs := nil;

    plugin.UpdatePreview := nil;

    plugin.SetText := nil;
    plugin.SetSettingType := nil;
    plugin.GetCenterScheme := nil;
    plugin.SetBtnState := nil;

    plugin.DllHandle := 0;
    FreeLibrary(plugin.dllhandle);
    result := 1;
  except
    SendDebugMessageEx('SharpCenter','UnloadDll failed',clRed,DMT_ERROR);
  end;
end;

function LoadPlugin(filename: Pchar): TSetting;
begin
    result.filename := filename;
    result.dllhandle := LoadLibrary(filename);
    if result.dllhandle <> 0 then begin

      @result.Open := GetProcAddress(result.Dllhandle, 'Open');
      @result.Close := GetProcAddress(result.Dllhandle, 'Close');
      @result.Save := GetProcAddress(result.Dllhandle, 'Save');

      @result.OpenEdit := GetProcAddress(result.Dllhandle, 'OpenEdit');
      @result.CloseEdit := GetProcAddress(result.Dllhandle, 'CloseEdit');

      @result.ClickBtn := GetProcAddress(result.Dllhandle, 'ClickBtn');
      @result.ClickTab := GetProcAddress(result.Dllhandle, 'ClickTab');
      @result.AddTabs := GetProcAddress(result.Dllhandle, 'AddTabs');

      @result.UpdatePreview := GetProcAddress(result.Dllhandle, 'UpdatePreview');

      @result.SetText := GetProcAddress(result.Dllhandle,'SetText');
      @result.GetCenterScheme := GetProcAddress(result.Dllhandle, 'GetCenterScheme');
      @result.SetSettingType := GetProcAddress(result.Dllhandle, 'SetSettingType');
      @result.SetBtnState := GetProcAddress(result.Dllhandle, 'SetBtnState');

      if (@result.Open = nil) then begin
        freelibrary(result.dllhandle);
        result.dllhandle := 0;
        SendDebugMessageEx('SharpCenter','Unable to load SettingDll, Open proc missing',clRed,DMT_ERROR);
      end;
    end;

end;


end.





