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

unit SharpAPI;

interface

uses
  Messages,
  Windows;

const
  WM_SHARPTRAYMESSAGE = WM_APP + 500;
  WM_SHARPCONSOLEMESSAGE = WM_APP + 502;
  WM_SHARPDESKMESSAGE = WM_APP + 504;
  WM_SHARPBARMESSAGE = WM_APP + 505;
  WM_SHARPEUPDATESETTINGS = WM_APP + 506;

  // WM_SHARPEUPDATESETTINGS Params
  SU_SKIN = 1;
  SU_SKINFILECHANGED = 2;
  SU_SCHEME = 3;
  SU_THEME = 4;
  SU_ICONSET = 5;
  SU_BACKGROUND = 6; // SHARPBAR
  SU_SERVICE = 7;
  SU_DESKTOPICON = 8;
  SU_SHARPDESK = 9;
  SU_SHARPMENU = 10;
  SU_SHARPBAR = 11;
  SU_CURSOR = 12;
  SU_WALLPAPER = 13;

  // Shell message
  WM_SHARPSHELLMESSAGE = WM_APP + 507;

  WM_SHARPEACTIONMESSAGE = WM_APP + 520;
  WM_SHARPEUPDATEACTIONS = WM_APP + 521;

  WM_WEATHERUPDATE = WM_APP + 540;

  WM_DISABLESHARPDESK      = WM_APP + 523;
  WM_ENABLESHARPDESK       = WM_APP + 524;
  WM_EDITCURRENTTHEME      = WM_APP + 525;
  WM_ADDDESKTOPOBJECT      = WM_APP + 526;
  WM_SHOWDESKTOPSETTINGS   = WM_APP + 528;
  WM_CLOSEDESK             = WM_APP + 531;
  WM_DESKEXPORTBACKGROUND  = WM_APP + 532;
  WM_FORCEOBJECTRELOAD     = WM_APP + 533;
  WM_DESKBACKGROUNDCHANGED = WM_APP + 534;

  WM_DESKCLOSING          = WM_APP + 537;

  WM_SHARPTERMINATE       = WM_APP + 550;

  // SharpBar (new Skin Stuff)
  WM_UPDATEBARWIDTH       = WM_APP + 601;
  WM_SHARPEPLUGINMESSAGE  = WM_APP + 602;
  WM_SKINCHANGED          = WM_APP + 603;
  WM_GETBARHEIGHT         = WM_APP + 604;
  WM_GETBACKGROUNDHANDLE  = WM_APP + 605;
  WM_GETXMLHANDLE         = WM_APP + 606;
  WM_SAVEXMLFILE          = WM_APP + 607;
  WM_GETFREEBARSPACE      = WM_APP + 608;
  WM_REGISTERSHELLHOOK    = WM_APP + 609;
  WM_UNREGISTERSHELLHOOK  = WM_APP + 610;
  WM_LOCKBARWINDOW        = WM_APP + 611;
  WM_UNLOCKBARWINDOW      = WM_APP + 612;
  WM_BARINSERTMODULE      = WM_APP + 613;
  WM_BARREPOSITION        = WM_APP + 614;

  // System Tray Service
  WM_REGISTERWITHTRAY     = WM_APP + 650;
  WM_UNREGISTERWITHTRAY   = WM_APP + 651;

  // Skin Service
  WM_ASKFORSYSTEMSKIN     = WM_APP + 700;
  WM_SYSTEMSKINUPDATE     = WM_APP + 701;

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
  
  // SharpCenter
  WM_SHARPCENTERMESSAGE = WM_APP + 660;
  SCM_SET_EDIT_STATE = 1000;
  SCM_SET_EDIT_CANCEL_STATE = 1001;
  SCM_SET_BUTTON_ENABLED = 1002;
  SCM_SET_BUTTON_DISABLED = 1003;
  SCM_SET_TAB_SELECTED = 1004;
  SCM_SET_SETTINGS_CHANGED = 1005;
  SCM_EVT_BTNCLICK = 1006;
  SCM_EVT_UPDATE_PREVIEW = 1007;
  SCM_EVT_UPDATE_SETTINGS = 1008;
  SCM_EVT_UPDATE_SIZE = 1009;

  SCU_SHARPDESK = 2001;
  SCU_SHARPCORE = 2002;
  SCU_SHARPBAR = 2003;
  SCU_SHARPMENU = 2004;
  SCU_SHARPTHEME = 2005;
  SCU_SERVICE = 2006;
  SCU_OBJECT = 2007;
  SCU_MODULE = 2008;

  SCB_MOVEUP = 3000;
  SCB_MOVEDOWN = 3001;
  SCB_IMPORT = 3002;
  SCB_EXPORT = 3003;
  SCB_CLEAR = 3004;
  SCB_DELETE = 3005;
  SCB_HELP = 3006;
  SCB_ADD_TAB = 3007;
  SCB_EDIT_TAB = 3008;
  SCB_DEL_TAB = 3009;
  SCB_CONFIGURE = 3010; // For editing the contents of a list

  SCC_LOAD_SETTING = '_loadsetting';
  SCC_CHANGE_FOLDER = '_changedir';
  SCC_UNLOAD_DLL = '_unloaddll';
  SCC_LOAD_DLL = '_loaddll';

  // Action Consts
  AC_REGISTER_ACTION = '_registeraction';
  AC_UNREGISTER_ACTION = '_unregisteraction';
  AC_UPDATE_ACTION = '_updateaction';
  AC_BUILD_ACTION_LIST = '_buildactionlist';
  AC_ACTION_EXISTS = '_exists';
  AC_EXECUTE_ACTION = '_execute';

  //showModes to use with sendTrayMessage
  smSLIDE = 1;
  smSHRINK = 2;

type
  TSCE_EDITMODE_ENUM = (sceAdd, sceEdit, sceDelete);
  TSCC_COMMAND_ENUM = (sccLoadSetting, sccChangeFolder, sccUnloadDll, sccLoadDll);

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

  TMsgData = record
    Command: string[255];
    Parameters: string[255];
  end;
  pMsgData = ^TMsgData;

  TBarRect = record
              R : TRect;
              wnd : hwnd;
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
function CenterMsg(ACommand: TSCC_COMMAND_ENUM; AParam, APluginID :PChar): hresult; external 'SharpAPI.dll' name 'CenterMsg';
function SharpCenterBroadCast(wpar: wparam; lpar: lparam): boolean; external 'SharpAPI.dll';


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

implementation

end.




