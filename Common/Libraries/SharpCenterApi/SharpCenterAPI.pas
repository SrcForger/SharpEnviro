{
Source Name: SharpAPI
Description: Header unir for SharpAPI.dll
Copyright (C) Lee Green (Pixol) <pixol@sharpe-shell.org>
              Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

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

unit SharpCenterAPI;

interface

uses
  Messages,
  SharpApi,
  Windows;


function BroadcastGlobalUpdateMessage(AUpdateType:TSU_UPDATE_ENUM;
  APluginID: Integer=-1) : boolean;
    external 'SharpCenterAPI.dll' name 'BroadcastGlobalUpdateMessage';

function BroadcastCenterMessage(wpar: wparam; lpar: lparam): boolean;
  external 'SharpCenterAPI.dll' name 'BroadcastCenterMessage';

function CenterCommand(ACommand: TSCC_COMMAND_ENUM; AParam, APluginID :PChar): hresult;
  external 'SharpCenterAPI.dll' name 'CenterCommand';

function CenterDefineEditState(AEditing: Boolean): boolean;
  external 'SharpCenterAPI.dll' name 'CenterDefineEditState';

function CenterDefineButtonState(AButton: TSCB_BUTTON_ENUM; AEnabled: Boolean): boolean;
  external 'SharpCenterAPI.dll' name 'CenterDefineButtonState';

function CenterDefineSettingsChanged: boolean;
  external 'SharpCenterAPI.dll' name 'CenterDefineSettingsChanged';

function CenterDefineConfigurationMode(AConfigMode:TSC_MODE_ENUM) : boolean;
  external 'SharpCenterAPI.dll' name 'CenterDefineConfigurationMode';

function CenterSelectEditTab(AEditTab: TSCB_BUTTON_ENUM): boolean;
  external 'SharpCenterAPI.dll' name 'CenterSelectEditTab';

function CenterUpdatePreview: boolean;
  external 'SharpCenterAPI.dll' name 'CenterUpdatePreview';

function CenterUpdateSize: boolean;
  external 'SharpCenterAPI.dll' name 'CenterUpdateSize';

function CenterUpdateTabs: boolean;
  external 'SharpCenterAPI.dll' name 'CenterUpdateTabs';

function CenterUpdateConfigText: boolean;
  external 'SharpCenterAPI.dll' name 'CenterUpdateConfigText';

function CenterUpdateSettings: boolean;
  external 'SharpCenterAPI.dll' name 'CenterUpdateSettings';

procedure CenterUpdateConfigFull;
  external 'SharpCenterAPI.dll' name 'CenterUpdateConfigFull';

function CenterCommandAsText(ACommand: TSCC_COMMAND_ENUM): string;
  external 'SharpCenterAPI.dll' name 'CenterCommandAsText';

function CenterCommandAsEnum(ACommand: string): TSCC_COMMAND_ENUM;
  external 'SharpCenterAPI.dll' name 'CenterCommandAsEnum';

procedure CenterReadDefaults(var AFields: TSC_DEFAULT_FIELDS);
  external 'SharpCenterAPI.dll' name 'CenterReadDefaults';

procedure CenterWriteDefaults(var AFields: TSC_DEFAULT_FIELDS);
  external 'SharpCenterAPI.dll' name 'CenterWriteDefaults';

implementation

end.




