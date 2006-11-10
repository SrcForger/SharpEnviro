{
Source Name: uSharpCenterDllMethods
Description: Plugin Interface for the SharpCenter Configs
Copyright (C) lee@sharpe-shell.org

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
  uSharpCenterSectionList;

type
  TConfigDll = record
    filename: string;
    Dllhandle: Thandle;
    Open: function(const APluginID:Pchar; owner: hwnd): hwnd;
    Close: function(owner: hwnd; SaveSettings: Boolean): boolean;
    ConfigDllType: function:Integer;

    BtnMoveUp: procedure(var AButton: TPngSpeedButton);
    BtnMoveDown: procedure(var AButton: TPngSpeedButton);
    BtnAdd: procedure(var AButton: TPngSpeedButton);
    BtnEdit: procedure(var AButton: TPngSpeedButton);
    BtnDelete: procedure(var AButton: TPngSpeedButton);
    BtnImport: procedure(var AButton: TPngSpeedButton);
    BtnExport: procedure(var AButton: TPngSpeedButton);
    BtnClear: procedure(var AButton: TPngSpeedButton);

    ChangeSection: procedure(const ASection:TSectionObject);
    AddSections: procedure(var AList: TSectionObjectList; var AItemHeight: Integer);
    GetDisplayName: procedure (const APluginID:Pchar; var ADisplayName:PChar);

    Help: procedure;
  end;
  PConfigDll = ^TConfigDll;

  // functions to use for loading Plugins
function LoadConfigDll(filename: Pchar): TConfigDll;
function UnloadConfigDll(plugin: PConfigDll): hresult;

implementation

function UnloadConfigDll(plugin: PConfigDll): hresult;
begin
  result := 0;
  try
    if plugin.dllhandle <> 0 then
      FreeLibrary(plugin.dllhandle);
    plugin.Open := nil;
    plugin.Close := nil;
    plugin.Help := nil;
    plugin.ConfigDllType := nil;
    plugin.GetDisplayName := nil;

    plugin.BtnMoveUp := nil;
    plugin.BtnMoveDown := nil;
    plugin.BtnAdd := nil;
    plugin.BtnEdit := nil;
    plugin.BtnDelete := nil;
    plugin.BtnImport := nil;
    plugin.BtnExport := nil;
    plugin.BtnClear := nil;

    plugin.ChangeSection := nil;
    plugin.AddSections := nil;

    plugin.DllHandle := 0;


    FreeLibrary(plugin.dllhandle);
    result := 1;
  except
    SendDebugMessageEx('SharpCenter','UnloadDll failed',clRed,DMT_ERROR);
  end;
end;

function LoadConfigDll(filename: Pchar): TConfigDll;
begin
  try
    result.filename := filename;
    SendDebugMessageEx('SharpCenter',Pchar('Loading ConfigDll: ' + filename),clBlack,DMT_Info);

    result.dllhandle := LoadLibrary(filename);
    if result.dllhandle <> 0 then begin
      @result.Open := GetProcAddress(result.dllhandle, 'Open');
      @result.Close := GetProcAddress(result.Dllhandle, 'Close');
      @result.Help := GetProcAddress(result.Dllhandle, 'Help');
      @result.ConfigDllType := GetProcAddress(result.Dllhandle, 'ConfigDllType');
      @result.GetDisplayName := GetProcAddress(result.Dllhandle, 'GetDisplayName');

      @result.BtnMoveUp := GetProcAddress(result.Dllhandle, 'BtnMoveUp');
      @result.BtnMoveDown := GetProcAddress(result.Dllhandle, 'BtnMoveDown');
      @result.BtnAdd := GetProcAddress(result.Dllhandle, 'BtnAdd');
      @result.BtnEdit := GetProcAddress(result.Dllhandle, 'BtnEdit');
      @result.BtnDelete := GetProcAddress(result.Dllhandle, 'BtnDelete');
      @result.BtnImport := GetProcAddress(result.Dllhandle, 'BtnImport');
      @result.BtnExport := GetProcAddress(result.Dllhandle, 'BtnExport');
      @result.BtnClear := GetProcAddress(result.Dllhandle, 'BtnClear');

      @result.ChangeSection := GetProcAddress(result.Dllhandle, 'ChangeSection');
      @result.AddSections := GetProcAddress(result.Dllhandle, 'AddSections');

      if (@result.Open = nil) then begin
        freelibrary(result.dllhandle);
        result.dllhandle := 0;
        SendDebugMessageEx('SharpCenter','Unable to load ConfigDll, Open proc missing',clRed,DMT_ERROR);
      end;
    end;
  except
    result.dllhandle := 0;
    SendDebugMessageEx('SharpCenter','Loading ConfigDll Failed',clRed,DMT_ERROR);
  end;
end;


end.





