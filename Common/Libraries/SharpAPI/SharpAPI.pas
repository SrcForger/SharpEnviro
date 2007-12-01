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

unit SharpAPI;

interface

uses
  Messages,
  Windows,
  gr32;

const
  WM_SHARPEUPDATESETTINGS = WM_APP + 506;
  WM_SHARPCONSOLEMESSAGE = WM_APP + 502;

  // Shell message
  WM_SHARPSHELLMESSAGE = WM_APP + 507;

  WM_SHARPEACTIONMESSAGE = WM_APP + 520;
  WM_SHARPEUPDATEACTIONS = WM_APP + 521;

  WM_WEATHERUPDATE = WM_APP + 540;

  WM_CLOSEDESK             = WM_APP + 531;
  WM_DESKEXPORTBACKGROUND  = WM_APP + 532;
  WM_BARCOMMAND            = WM_APP + 533;
  WM_DESKBACKGROUNDCHANGED = WM_APP + 534;
  WM_SHOWBAR               = WM_APP + 535;
  WM_HIDEBAR               = WM_APP + 536;

  WM_DESKCLOSING          = WM_APP + 537;

  WM_SHARPTERMINATE       = WM_APP + 550;

  // Shell Hooks
  WM_REGISTERSHELLHOOK      = WM_APP + 560;
  WM_UNREGISTERSHELLHOOK    = WM_APP + 561;
  WM_SHELLHOOKWINDOWCREATED = WM_APP + 562;  

  // SharpBar (new Skin Stuff)
  WM_UPDATEBARWIDTH       = WM_APP + 601;
  WM_SHARPEPLUGINMESSAGE  = WM_APP + 602;
  WM_SKINCHANGED          = WM_APP + 603;
  WM_GETBARHEIGHT         = WM_APP + 604;
  WM_GETBACKGROUNDHANDLE  = WM_APP + 605;
  WM_GETFREEBARSPACE      = WM_APP + 608;
  WM_LOCKBARWINDOW        = WM_APP + 611;
  WM_UNLOCKBARWINDOW      = WM_APP + 612;
  WM_BARINSERTMODULE      = WM_APP + 613;
  WM_BARREPOSITION        = WM_APP + 614;

  // VWM Functions
  WM_VWMSWITCHDESKTOP     = WM_APP + 620;
  WM_VWMDESKTOPCHANGED    = WM_APP + 621;
  WM_VWMGETDESKCOUNT      = WM_APP + 622;
  WM_VWMGETCURRENTDESK    = WM_APP + 623;
  WM_VWMUPDATESETTINGS    = WM_APP + 624;

  // System Tray Service
  WM_REGISTERWITHTRAY     = WM_APP + 650;
  WM_UNREGISTERWITHTRAY   = WM_APP + 651;

  // SharpCenter
  WM_SHARPCENTERMESSAGE = WM_APP + 660;

  // WM_BARCOMMAND messages param
  BC_ADD = 0;
  BC_DELETE = 1;
  BC_MOVEUP = 2;
  BC_MOVEDOWN = 3;

  // WM_BARCOMMAND message result
  BCR_ERROR = 0;
  BCR_SUCCESS = 1;

   //HRESULTS
  HR_NORECIEVERWINDOW = 2;
  HR_UNKNOWNERROR = 1;
  HR_OK = 0;

  // Service Results
  MR_STARTED = 1;
  MR_STOPPED = 0;
  MR_ERRORSTARTING = 2;
  MR_OK = 3;
  MR_INCOMPATIBLE = 4;
  MR_ERRORSTOPPING = 5;
  MR_FORCECONFIGDISABLE = 6;

  // Action Results
  MR_ACTIONSERVICE_NOT_AVAIL = 6;

  //Arguments used when sending messages
  ARG_MODULEUPDATE = 16;

  magicDWord: DWord = $49474541;

  //colors to use with senddebugmessage
  clERROR = 2;
  clSUCCESS = 1;
  clMESSAGE = 0;

  // message types to use with SendDebugMessageEx
  DMT_INFO = 0;
  DMT_STATUS = 1;
  DMT_WARN = 2;
  DMT_ERROR = 3;
  DMT_TRACE = 4;
  DMT_NONE = -1;

  // Action Consts
  AC_REGISTER_ACTION = '_registeraction';
  AC_UNREGISTER_ACTION = '_unregisteraction';
  AC_UPDATE_ACTION = '_updateaction';
  AC_BUILD_ACTION_LIST = '_buildactionlist';
  AC_ACTION_EXISTS = '_exists';
  AC_EXECUTE_ACTION = '_execute';
  AC_SERVICE_NAME = 'Actions';

  // SharpCenter consts
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
  SCM_EVT_UPDATE_SIZE = 11;

  SCC_LOAD_SETTING = '_loadsetting';
  SCC_CHANGE_FOLDER = '_changedir';
  SCC_UNLOAD_DLL = '_unloaddll';
  SCC_LOAD_DLL = '_loaddll';

type
  PSharpE_DataStruct = ^TSharpE_DataStruct;
  TSharpE_DataStruct = record
    Command: string[255];
    Parameter: string[255];
    Handle: Integer;
    LParam: Integer;
    RParam: Integer;

    // Optionals
    PluginID: string[255];
    Module: string[255];
    Msg: string[255];
  end;

  TTypeEnum = (tteComponent, tteService, tteModule, tteConfig);

  TMetaData = record
    Name: String[255];
    Description: String[255];
    Author: String[255];
    Version: String[255];
    DataType: TTypeEnum;
    ExtraData: String[255];
  end;

  TMsgData = record
    Command: string[255];
    Parameters: string[255];
  end;
  pMsgData = ^TMsgData;

  TBarRect = record
              R : TRect;
              wnd : hwnd;
             end;

  // SharpCenter types
  TSCC_COMMAND_ENUM = (sccLoadSetting, sccChangeFolder, sccUnloadDll, sccLoadDll);
  TSCB_BUTTON_ENUM = (scbMoveUp, scbMoveDown, scbImport, scbExport, scbClear,
    scbDelete, scbHelp, scbAddTab, scbEditTab, scbDeleteTab, scbConfigure);
  TSU_UPDATE_ENUM = (suSkin, suSkinFileChanged, suScheme, suTheme, suIconSet,
    suBackground, suService, suDesktopIcon, suSharpDesk, suSharpMenu,
    suSharpBar, suCursor, suWallpaper, suDeskArea, suSkinFont, suDesktopObject,
    suModule,suVWM,suCenter);
  TSCE_EDITMODE_ENUM = (sceAdd, sceEdit, sceDelete);
  TSC_MODE_ENUM = (scmLive, scmApply);

  TSU_UPDATES = set of TSU_UPDATE_ENUM;

  TSC_DEFAULT_FIELDS = record
    Author: string;
    Website: string;
  end;

function RegisterAction(ActionName: Pchar; WindowHandle: hwnd; LParamID: Cardinal) : hresult; external 'SharpAPI.dll' name 'RegisterAction';
function RegisterActionEx(ActionName: Pchar; GroupName:PChar; WindowHandle: hwnd; LParamID: Cardinal) : hresult; external 'SharpAPI.dll' name 'RegisterActionEx';

function UpdateAction(ActionName: Pchar; WindowHandle: hwnd; LParamID: Cardinal): hresult; external 'SharpAPI.dll';
function UpdateActionEx(ActionName, GroupName: Pchar; WindowHandle: hwnd; LParamID: Cardinal): hresult; external 'SharpAPI.dll';

function UnRegisterAction(ActionName: Pchar) : hresult; external 'SharpAPI.dll' name 'UnRegisterAction';

function GetSharpBarArea(Index : integer) : TBarRect; external 'SharpApi.dll' name 'GetSharpBarArea';
function GetSharpBarCount : integer; external 'SharpApi.dll' name 'GetSharpBarCount';

function GetSharpeDirectory: PChar; external 'SharpAPI.dll' name 'GetSharpeDirectory';
function GetSharpeUserSettingsPath: PChar; external 'SharpAPI.dll' name 'GetSharpeUserSettingsPath';
function GetSharpeGlobalSettingsPath: PChar; external 'SharpAPI.dll' name 'GetSharpeGlobalSettingsPath';
function GetCenterDirectory: PChar; external 'SharpAPI.dll' name 'GetCenterDirectory';

function ServiceMsg(ServiceName, Command: pChar): hresult; external 'SharpAPI.dll' name 'ServiceMsg';
function ServiceStart(ServiceName: pChar): hresult; external 'SharpAPI.dll' name 'ServiceStart';
function ServiceStop(ServiceName: pChar): hresult; external 'SharpAPI.dll' name 'ServiceStop';
function IsServiceStarted(ServiceName: pchar): hresult; external 'SharpAPI.dll' name 'IsServiceStarted';
function SendDebugMessage(app: string; msg: string; color: integer): hresult; external 'SharpAPI.dll';
function SendDebugMessageEx(module: pChar; msg: pChar; color: integer; MessageType: Integer): hresult; external 'SharpApi.dll';

function SendConsoleMessage(msg: string): hresult; external 'SharpAPI.dll';
function SharpExecute(data: string): hresult; external 'SharpAPI.dll';
function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam): integer; external 'SharpAPI.dll';

function SendMessageTo(WndName: string; msg: integer; wpar: wparam; lpar: lparam): boolean; external 'SharpAPI.dll';

function BarMsg(PluginName, Command: pChar): hresult; external 'SharpApi.dll';
// new for skin stuff
function SendPluginMessage(BarID, PluginID : integer; Command : pChar): hresult; external 'SharpApi.dll';

function FindComponent(Component : PChar) : hwnd; external 'SharpApi.dll' name 'FindComponent';
function IsComponentRunning(Component : PChar) : boolean; external 'SharpApi.dll' name 'IsComponentRunning';
function CloseComponent(Component : PChar) : boolean; external 'SharpApi.dll' name 'CloseComponent';
procedure TerminateComponent(Component : PChar); external 'SharpApi.dll' name 'TerminateComponent';
procedure StartComponent(Component : PChar); external 'SharpApi.dll' name 'StartComponent';

function RegisterShellHookReceiver(Wnd : hwnd) : boolean; external 'SharpApi.dll' name 'RegisterShellHookReceiver';
function UnRegisterShellHookReceiver(Wnd : hwnd) : boolean; external 'SharpApi.dll' name 'UnRegisterShellHookReceiver';

function GetVWMCount : integer; external 'SharpApi.dll' name 'GetVWMCount';
function GetCurrentVWM : integer; external 'SharpApi.dll' name 'GetCurrentVWM';
function SwitchToVWM(Index : integer) : boolean; external 'SharpApi.dll' name 'SwitchToVWM';

//meta data functions
function GetComponentMetaData(strFile: String; var MetaData: TMetaData; var Priority: Integer; var Delay: Integer) : Integer; external 'SharpApi.dll' name 'GetComponentMetaData';
function GetServiceMetaData(strFile: String; var MetaData: TMetaData; var Priority: Integer; var Delay: Integer) : Integer; external 'SharpApi.dll' name 'GetServiceMetaData';
function GetConfigMetaData(strFile: String; var MetaData: TMetaData; var ConfigMode: TSC_MODE_ENUM; var ConfigType: TSU_UPDATE_ENUM) : Integer; external 'SharpApi.dll' name 'GetConfigMetaData';
function GetModuleMetaData(strFile: String; Preview: TBitmap32; var MetaData: TMetaData; var HasPreview: Boolean) : Integer; external 'SharpApi.dll' name 'GetModuleMetaData';

implementation

end.




