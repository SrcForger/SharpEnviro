{
Source Name: uSharpCenterDllMethods
Description: Plugin Interface for the SharpCenter Settings
Copyright (C) Pixol - pixol@sharpe-shell.org

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

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
  uSharpCenterPluginTabList;

type
  TSetting = record
    Filename: string;
    Dllhandle: Thandle;

    Open: function(const APluginID:Pchar; AOwner: hwnd): hwnd;
    Close: procedure(ASave: Boolean);

    OpenEdit: function(AOwner:Hwnd; AEditMode:TSCE_EDITMODE):Hwnd;
    CloseEdit: function(AEditMode:TSCE_EDITMODE; AApply:Boolean): boolean;

    ClickBtn: procedure (AButtonID: Integer; AText: String);
    ClickTab: procedure (ATab: TPluginTabItem);
    AddTabs: procedure(var ATabs:TPluginTabItemList);

    UpdatePreview: procedure (var AImage32:TImage32);

    SetDisplayText: procedure (const APluginID:Pchar; var ADisplayText:PChar);
    SetStatusText: procedure (var AStatusText: PChar);
    SetSettingType: function(): Integer;
    SetBtnState : function(AButtonID: Integer): Boolean;

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
    if plugin.dllhandle <> 0 then
      FreeLibrary(plugin.dllhandle);

    plugin.Open := nil;
    plugin.Close := nil;

    plugin.OpenEdit := nil;
    plugin.CloseEdit := nil;

    plugin.ClickBtn := nil;
    plugin.ClickTab := nil;
    plugin.AddTabs := nil;

    plugin.UpdatePreview := nil;

    plugin.SetDisplayText := nil;
    plugin.SetStatusText := nil;
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
  try
    result.filename := filename;
    SendDebugMessageEx('SharpCenter',Pchar('Loading SettingDll: ' + filename),clBlack,DMT_Info);

    result.dllhandle := LoadLibrary(filename);
    if result.dllhandle <> 0 then begin

      @result.Open := GetProcAddress(result.Dllhandle, 'Open');
      @result.Close := GetProcAddress(result.Dllhandle, 'Close');
      @result.OpenEdit := GetProcAddress(result.Dllhandle, 'OpenEdit');
      @result.CloseEdit := GetProcAddress(result.Dllhandle, 'CloseEdit');

      @result.ClickBtn := GetProcAddress(result.Dllhandle, 'ClickBtn');
      @result.ClickTab := GetProcAddress(result.Dllhandle, 'ClickTab');
      @result.AddTabs := GetProcAddress(result.Dllhandle, 'AddTabs');

      @result.UpdatePreview := GetProcAddress(result.Dllhandle, 'UpdatePreview');

      @result.SetDisplayText := GetProcAddress(result.Dllhandle,'SetDisplayText');
      @result.SetStatusText := GetProcAddress(result.Dllhandle,'SetStatusText');
      @result.GetCenterScheme := GetProcAddress(result.Dllhandle, 'GetCenterScheme');
      @result.SetSettingType := GetProcAddress(result.Dllhandle, 'SetSettingType');
      @result.SetBtnState := GetProcAddress(result.Dllhandle, 'SetBtnState');

      if (@result.Open = nil) then begin
        freelibrary(result.dllhandle);
        result.dllhandle := 0;
        SendDebugMessageEx('SharpCenter','Unable to load SettingDll, Open proc missing',clRed,DMT_ERROR);
      end;
    end;
  except
    result.dllhandle := 0;
    SendDebugMessageEx('SharpCenter','Loading SettingDll Failed',clRed,DMT_ERROR);
  end;
end;


end.





