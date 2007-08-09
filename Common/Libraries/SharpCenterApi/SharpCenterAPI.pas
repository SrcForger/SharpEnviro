{
Source Name: SharpAPI
Description: Header unir for SharpAPI.dll
Copyright (C) Lee Green (Pixol) <pixol@sharpe-shell.org>
              Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
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

unit SharpCenterAPI;

interface

uses
  Messages,
  Windows;

const
  SCM_SET_EDIT_STATE = 1;
  SCM_SET_EDIT_CANCEL_STATE = 2;
  SCM_SET_BUTTON_ENABLED = 3;
  SCM_SET_BUTTON_DISABLED = 4;
  SCM_SET_TAB_SELECTED = 5;
  SCM_SET_SETTINGS_CHANGED = 6;
  SCM_SET_LIVE_CONFIG = 7;
  SCM_SET_APPLY_CONFIG = 8;
  SCM_EVT_UPDATE_PREVIEW = 9;
  SCM_EVT_UPDATE_SETTINGS = 10;

const
  WM_SHARPCENTERMESSAGE = WM_APP + 660;

Type
  TSCC_COMMAND_ENUM = (sccLoadSetting, sccChangeFolder, sccUnloadDll, sccLoadDll);
  TSCB_BUTTON_ENUM = (scbMoveUp, scbMoveDown, scbImport, scbExport, scbClear,
    scbDelete, scbHelp, scbAddTab, scbEditTab, scbDeleteTab, scbConfigure);
  TSU_UPDATE_ENUM = (suSkin, suSkinFileChanged, suScheme, suTheme, suIconSet,
    suBackground, suService, suDesktopIcon, suSharpDesk, suSharpMenu,
      suSharpBar, suCursor, suWallpaper);
  TSCE_EDITMODE_ENUM = (sceAdd, sceEdit, sceDelete);
  TSC_MODE_ENUM = (scmLive, scmApply);

  TSU_UPDATES = set of TSU_UPDATE_ENUM;

  TSC_DEFAULT_FIELDS = record
    Author: string;
    Website: string;
  end;

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

function CenterUpdateSettings: boolean;
  external 'SharpCenterAPI.dll' name 'CenterUpdateSettings';

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




