{
Source Name: SharpApi.dpr
Description: API commands for SharpE
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

library SharpAPI;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  ShareMem,
  windows,
  messages,
  Forms,
  SysUtils,
  shellAPI,
  jclfileutils,
  jclsysinfo,
  jclstrings,
  classes,
  strutils,
  registry,
  gr32,
  types,
  {$IFDEF DEBUG}DebugDialog in '..\..\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  SimpleForms in '..\..\Units\SimpleUnits\SimpleForms.pas',
  uSystemFuncs in '..\..\Units\SystemFuncs\uSystemFuncs.pas',
  SharpTypes in '..\..\Units\SharpTypes\SharpTypes.pas';

{$R 'VersionInfo.res'}
{$R *.RES}

const
  WM_SHARPEUPDATESETTINGS = WM_APP + 506;
  WM_SHARPCONSOLEMESSAGE = WM_APP + 502;

  // Shell message
  WM_SHARPSHELLMESSAGE = WM_APP + 507;

  WM_SHARPEACTIONMESSAGE = WM_APP + 520;
  WM_SHARPEUPDATEACTIONS = WM_APP + 521;

  WM_WEATHERUPDATE = WM_APP + 540;

  WM_DISABLESHARPDESK      = WM_APP + 523;
  WM_ENABLESHARPDESK       = WM_APP + 524;
  WM_EDITCURRENTTHEME      = WM_APP + 525;
  WM_CLOSEDESK             = WM_APP + 531;
  WM_DESKEXPORTBACKGROUND  = WM_APP + 532;
  WM_FORCEOBJECTRELOAD     = WM_APP + 533;
  WM_DESKBACKGROUNDCHANGED = WM_APP + 534;
  WM_SHOWBAR               = WM_APP + 535;
  WM_HIDEBAR               = WM_APP + 536;

  WM_DESKCLOSING          = WM_APP + 537;

  WM_SHARPELINKLAUNCH     = WM_APP + 540;

  WM_SHARPTERMINATE       = WM_APP + 550;
  WM_SHARPEINITIALIZED    = WM_APP + 551;

  // Shell Hooks
  WM_REGISTERSHELLHOOK      = WM_APP + 560;
  WM_UNREGISTERSHELLHOOK    = WM_APP + 561;
  WM_SHELLHOOKWINDOWCREATED = WM_APP + 562;
  WM_REQUESTWNDLIST         = WM_APP + 563;    

  // SharpBar (new Skin Stuff)
  WM_UPDATEBARWIDTH       = WM_APP + 601;
  WM_SHARPEPLUGINMESSAGE  = WM_APP + 602;
  WM_SKINCHANGED          = WM_APP + 603;
  WM_GETBARHEIGHT         = WM_APP + 604;
  WM_GETBACKGROUNDHANDLE  = WM_APP + 605;
  WM_GETXMLHANDLE         = WM_APP + 606;
  WM_SAVEXMLFILE          = WM_APP + 607;
  WM_GETFREEBARSPACE      = WM_APP + 608;
  WM_LOCKBARWINDOW        = WM_APP + 611;
  WM_UNLOCKBARWINDOW      = WM_APP + 612;
  WM_BARINSERTMODULE      = WM_APP + 613;
  WM_BARREPOSITION        = WM_APP + 614;

  // VWM Functions
  WM_VWMSWITCHDESKTOP      = WM_APP + 620;
  WM_VWMDESKTOPCHANGED     = WM_APP + 621;
  WM_VWMGETDESKCOUNT       = WM_APP + 622;
  WM_VWMGETCURRENTDESK     = WM_APP + 623;
  WM_VWMUPDATESETTINGS     = WM_APP + 624;
  WM_VWMGETMOVETOOLWINDOWS = WM_APP + 625;

  // System Tray Service
  WM_REGISTERWITHTRAY     = WM_APP + 650;
  WM_UNREGISTERWITHTRAY   = WM_APP + 651;

  // SharpCenter
  WM_SHARPCENTERMESSAGE = WM_APP + 660;

  // Explorer
  //WM_SHARPSTARTEXPLORER = WM_APP + 661;

  HR_NORECIEVERWINDOW = 2;
  HR_UNKNOWNERROR = 1;
  HR_OK = 0;
  ARG_MODULEUPDATE = 16;

  // Service Results
  MR_STARTED = 1;
  MR_STOPPED = 0;
  MR_ERRORSTARTING = 2;
  MR_OK = 3;
  MR_INCOMPATIBLE = 4;
  MR_ERRORSTOPPING = 5;

  // Action Results
  MR_ACTIONSERVICE_NOT_AVAIL = 6;

  // message types to use with SendDebugMessageEx
  DMT_INFO = 0;
  DMT_STATUS = 1;
  DMT_WARN = 2;
  DMT_ERROR = 3;
  DMT_TRACE = 4;
  DMT_NONE = -1;

  REGPATH = 'Software\SharpEnviro\';
  APPDATASUBDIR = 'SharpEnviro';
  CENTERDIR = 'Center';
  CENTERCONEXT = '.xml';
  DEFAULTSETTINGSDIR = '#Default#';
  DEFAULTSETTINGSDIRGLOBAL = '#DefaultGlobal#';

  // SharpCenter constants
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
  SCM_EVT_UPDATE_TABS = 12;
  SCM_EVT_UPDATE_CONFIG_TEXT = 13;

  SCC_LOAD_SETTING = '_loadsetting';
  SCC_CHANGE_FOLDER = '_changedir';
  SCC_UNLOAD_DLL = '_unloaddll';
  SCC_LOAD_DLL = '_loaddll';

  SEND_MESSAGE_TIMEOUT = 1000;

type
  TColor = -$7FFFFFFF - 1..$7FFFFFFF;

  TColorSchemeEx = record
    Throbberback: Tcolor;
    Throbberdark: Tcolor;
    Throbberlight: Tcolor;
    ThrobberText: Tcolor;
    WorkAreaback: Tcolor;
    WorkAreadark: Tcolor;
    WorkArealight: Tcolor;
    WorkAreaText: Tcolor;
  end;

  TColorScheme = record
    Throbberback: Tcolor;
    Throbberdark: Tcolor;
    Throbberlight: Tcolor;
    WorkAreaback: Tcolor;
    WorkAreadark: Tcolor;
    WorkArealight: Tcolor;
  end;

  PManagerCmd = ^TManagerCmd;
  TManagerCmd = record
    Command: String[255];
    Parameters: String[255];
  end;

  PHelpMsg = ^THelpMsg;
  THelpMsg = record
    Parameter: String[255];
  end;

  PActionCmd = ^TActionCmd;
  TActionCmd = record
    Command: String[255];
    hwndid: Integer;
    lparam: Integer;
  end;

  PSharpE_DataStruct = ^TSharpE_DataStruct;
  TSharpE_DataStruct = record
    Command: String[255];
    Parameter: String[255];
    Handle: Integer;
    LParam: Integer;
    RParam: Integer;

    // Optionals
    PluginID: String[255];
    Module: String[255];
    Msg: String[255];
  end;

const
    AC_REGISTER_ACTION = '_registeraction';
    AC_UNREGISTER_ACTION = '_unregisteraction';
    AC_UPDATE_ACTION = '_updateaction';
    AC_BUILD_ACTION_LIST = '_buildactionlist';
    AC_ACTION_EXISTS = '_exists';
    AC_EXECUTE_ACTION = '_execute';
    AC_SERVICE_NAME = 'Actions';

    //stuff for components, since apparently loadlibrary hates us
    IDS_NAME = 666;
    IDS_DESCRIPTION = 667;
    IDS_AUTHOR = 668;
    IDS_VERSION = 669;
    IDS_EXTRADATA = 670;

type
  TBarRect = record
              R : TRect;
              wnd : hwnd;
             end;

  TPluginData = record
    Name: String[255];
    Status: String[255];
    Description: String[255];
  end;

  TMetaTypeEnum = (tteComponent, tteService, tteModule, tteConfig);

  TMetaData = record
    Name: String[255];
    Description: String[255];
    Author: String[255];
    DataType: TMetaTypeEnum;
    ExtraData: String[255];
  end;

  TExtraMetaData = record
    Priority: Integer;
    Delay: Integer;
    RunOnce: Boolean;
    Startup: Boolean;
  end;

  // SharpCenter types
  TSCC_COMMAND_ENUM = (sccLoadSetting, sccChangeFolder, sccUnloadDll, sccLoadDll);
  TSCB_BUTTON_ENUM = (scbMoveUp, scbMoveDown, scbImport, scbExport, scbClear,
    scbDelete, scbHelp, scbAddTab, scbEditTab, scbDeleteTab, scbConfigure);
  TSU_UPDATE_ENUM = (suSkin, suSkinFileChanged, suScheme, suTheme, suIconSet,
    suBackground, suService, suDesktopIcon, suSharpDesk, suSharpMenu,
    suSharpBar, suCursor, suWallpaper, suDeskArea, suSkinFont, suDesktopObject,
    suModule,suVWM, suCenter, suTaskFilter);
  TSCE_EDITMODE_ENUM = (sceAdd, sceEdit, sceDelete);
  TSC_MODE_ENUM = (scmLive, scmApply);

  TSU_UPDATES = set of TSU_UPDATE_ENUM;

  TSC_DEFAULT_FIELDS = record
    Author: string;
    Website: string;
  end;

var
  // Global Vars
  UseAppData : boolean = True;

  // temp stuff
  i: integer;
  wpara: wparam;
  mess: integer;
  messwnd : hwnd;
  lpara: lparam;
  stemp: string;
  bsm: boolean;
  bsmtimeout: boolean;

  currentVersion: String;

function AllowSetForegroundWindow(ProcessID : DWORD) : boolean; stdcall; external 'user32.dll' name 'AllowSetForegroundWindow';

function GetSharpeDirectory: String; forward;
function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam; pSendMessage: boolean = False; pTimeout: boolean = False): integer; forward;

{ HELPER FUNCTIONS }

function ReadRegString(const RootKey: HKEY; const Key, Name: string): string;
var
  Size: DWORD;
  RK: DWORD;
  S: string;
  R: Longint;
  H: HKEY;
begin
  Result := '';
  RK := 0;
  Size := 0;

  R := RegOpenKeyEx(RootKey, PChar(Key), 0, KEY_READ, H);
  if R = ERROR_SUCCESS then
  begin
    R := RegQueryValueEx(H, PChar(Name), nil, @RK, nil, @Size);
    if R = ERROR_SUCCESS then
       if RK in [REG_SZ, REG_EXPAND_SZ] then
       begin
         SetLength(S, Size);
         RegQueryValueEx(H, PChar(Name), nil, @RK, PByte(S), @Size);
         SetLength(S, StrLen(PChar(S)));
         Result := S;
       end;
    RegCloseKey(H);
  end;
end;

function CopyDir(const fromDir, toDir : String) : Boolean;
var
  fos : TSHFileOPStruct;
begin
  ZeroMemory(@fos, SizeOf(fos));
  with fos do
  begin
    wFunc  := FO_COPY;
    fFlags := FOF_FILESONLY;
    pFrom  := PChar(fromDir + #0);
    pTo    := PChar(toDir);
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
  end;
  result := (0 = SHFileOperation(fos));
end;

procedure RenameDir(DirFrom, DirTo : string);
var
  shellinfo : TShFileOpStruct;
begin
  with shellinfo do
  begin
    wnd    := 0;
    wFunc  := FO_RENAME;
    pFrom  := PChar(DirFrom);
    pTo    := PChar(DirTo);
    fFlags := FOF_FILESONLY or FOF_ALLOWUNDO or FOF_SILENT or FOF_NOCONFIRMATION;
  end;
  SHFileOperation(shellinfo);
end;

procedure DeleteDir(Dir : string);
var
  shellinfo : TShFileOpStruct;
begin
  with shellinfo do
  begin
    wnd    := 0;
    wFunc  := FO_DELETE;
    pFrom  := PChar(Dir);
    pTo    := nil;
    fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
  end;
  SHFileOperation(shellinfo);
end;

{EXPORTED FUNTIONS}

function ShellInitialized : boolean;
var
  wnd : hwnd;
begin
  wnd := FindWindow('TSharpCoreMainWnd',nil);
  if wnd <> 0 then
    result := (SendMessage(wnd,WM_SHARPEINITIALIZED,0,0) = 1)
  else result := False;
end;

function GetCurrentVWM : integer;
var
  wnd : hwnd;
begin
  wnd := FindWindow('SharpE_VWM',nil);
  if wnd <> 0 then
    result := SendMessage(wnd,WM_VWMGETCURRENTDESK,0,0)
  else result := 1;
end;

function GetVWMCount : integer;
var
  wnd : hwnd;
begin
  wnd := FindWindow('SharpE_VWM',nil);
  if wnd <> 0 then
    result := SendMessage(wnd,WM_VWMGETDESKCOUNT,0,0)
  else result := 0;
end;

function GetVWMMoveToolWindows : boolean;
var
  wnd : hwnd;
begin
  wnd := FindWindow('SharpE_VWM',nil);
  if wnd <> 0 then
    result := (SendMessage(wnd,WM_VWMGETMOVETOOLWINDOWS,0,0) <> 0)
  else result := True;
end;

function SwitchToVWM(Index : integer; ExceptWnd : hwnd = 0) : boolean;
var
  wnd : hwnd;
begin
  wnd := FindWindow('SharpE_VWM',nil);
  if wnd <> 0 then
    result := (SendMessage(wnd,WM_VWMSWITCHDESKTOP,ExceptWnd,Index) <> 0)
  else result := False;
end;

function GetCenterDirectory: String;
var
  SharpEDir: string;
begin
  SharpEDir := GetSharpEDirectory;
  stemp := IncludeTrailingBackslash(SharpEDir) +
    IncludeTrailingBackslash(CenterDir);
  result := stemp;
end;

function GetCenterConfigExt: String;
begin
  Result := CenterConExt;
end;

function ServiceStart(ServiceName: String): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName;
    msg.Command := '_servicestart';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow(nil, 'SharpCore');
    if wnd <> 0 then
    begin
      sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function ServiceStop(ServiceName: String): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName;
    msg.Command := '_servicestop';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow(nil, 'SharpCore');
    if wnd <> 0 then
    begin
      sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function ServiceMsg(ServiceName, Command: String): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName + '.' + Command;
    msg.Command := '_servicemsg';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow('TSharpCoreMainWnd', nil);
    if wnd <> 0 then
    begin
      result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function ServiceDone(ServiceName: String): hresult;
var
  mhnd: THandle;
begin
  try
    mhnd := CreateMutex(nil, False, PChar('started_' + ServiceName));
    if mhnd <> 0 then
      Result := mhnd
    else
      Result := HR_UNKNOWNERROR;
  except
    Result := HR_UNKNOWNERROR;
  end;
end;

function BarMsg(PluginName, Command: String): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := Command;
    msg.Command := PluginName;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow(nil, 'SharpBar');
    if wnd <> 0 then
    begin
      result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function IsServiceStarted(ServiceName: String): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
  tmp: Byte;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName;
    msg.Command := '_isstarted';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow('TSharpCoreMainWnd', nil);
    if wnd <> 0 then
    begin
      tmp := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      if tmp = MR_STARTED then
        result := MR_STARTED
      else
        result := MR_STOPPED;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function IsServiceDone(ServiceName: String): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := ServiceName;
    msg.Command := '_isservicedone';
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow('TSharpCoreMainWnd', nil);
    if wnd <> 0 then
    begin
      result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

//////////////////////////////////////////////////
// Sends a message to SharpConsole
//////////////////////////////////////////////////

function SendConsoleMessage(msg: String): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  data: string;
begin
  try
    data := ' ||' + msg;
    with cds do
    begin
      dwData := 0;
      cbData := Length(data) + 1;
      lpData := PChar(data);
    end;

    wnd := FindWindow('TSharpConsoleWnd', nil);
    if wnd <> 0 then
    begin
      SendMessage(wnd, WM_SHARPCONSOLEMESSAGE, 0, cardinal(@cds));
      Result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

//////////////////////////////////////////////////
// Sends a message to SharpConsole  (With colors)
//////////////////////////////////////////////////

function SendDebugMessage(module: String; msg: String; color: integer): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  data: string;
begin
  try
    if module <> '' then
      module := module + ': '
    else
      module := ':';

    msg := '<B><FONT COLOR=$B06C48>' + module + '</FONT></B>' + msg;

    data := module + '||' + msg;
    with cds do
    begin
      dwData := 0;
      cbData := Length(data) + 1;
      lpData := PChar(data);
    end;

    wnd := FindWindow('TSharpConsoleWnd', nil);
    if wnd <> 0 then
    begin
      SendMessage(wnd, WM_COPYDATA, 0, cardinal(@cds));
      Result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
    ;
  end;
end;

procedure SendDebugServiceMessage(module: String; msg: String; MessageType: integer);
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  data: string;
begin
  data := module + '||' + msg;
  with cds do
  begin
    dwData := 0;
    cbData := Length(data) + 1;
    lpData := PChar(data);
  end;

  wnd := FindWindow('TSharpEDebugWnd', nil);
  if wnd <> 0 then
    SendMessage(wnd, WM_COPYDATA, MessageType, cardinal(@cds));
end;

function SendDebugMessageEx(module: String; msg: String; Color: TColor;
  MessageType: integer): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  data: string;
begin
  if (MessageType = DMT_Error) then
    SendDebugServiceMessage(module,msg,messagetype);

  try
    if module <> '' then
      module := module + ': '
    else
      module := ':';

    msg := '' + module + '</FONT></B>' + msg;

    data := module + '||' + msg;
    with cds do
    begin
      dwData := 0;
      cbData := Length(data) + 1;
      lpData := PChar(data);
    end;

    wnd := FindWindow('TSharpConsoleWnd', nil);
    if wnd <> 0 then
    begin
      SendMessage(wnd, WM_COPYDATA, MessageType, cardinal(@cds));
      Result := HR_OK;
    end else result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function SharpExecute(data: String): hresult;
var
  iElevate: Integer;
  iHistory: Integer;
  sTemp: String;
  wnd : hWnd;
  PID : DWORD;
begin
//  Result := HR_OK;

  try
    if IsServiceStarted('exec') = MR_STARTED then
    begin
      wnd := FindWindow('TSharpCoreMainWnd', nil);
      if wnd <> 0 then
      begin
        GetWindowThreadProcessId(wnd, @PID);
        AllowSetForegroundWindow(PID);
      end;
      result := ServiceMsg('exec', data)
    end else
    begin
      sTemp := data;
      iElevate := Pos('_elevate,',sTemp);
      if iElevate > 0 then Delete(sTemp, iElevate, 9);
      iHistory := Pos('_nohist,',sTemp);
      if iHistory > 0 then Delete(sTemp, iHistory, 8);
      sTemp := Trim(sTemp);
      result := ShellExecute(0, nil, PChar(sTemp), '', PChar(ExtractFilePath(sTemp)), SW_SHOWNORMAL);
    end;
  except
    result := HR_UNKNOWNERROR;
  end;

end;

function RegisterAction(ActionName: String; WindowHandle: hwnd; LParamID: Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted(AC_SERVICE_NAME) = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to register the Action
    Result := ServiceMsg(AC_SERVICE_NAME,
      Format('%s,%s,Undefined,%d,%d',
      [AC_REGISTER_ACTION, ActionName, WindowHandle, LParamID]));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function RegisterActionEx(ActionName: String; GroupName: String; WindowHandle:
  hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted(AC_SERVICE_NAME) = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to register the Action
    Result := ServiceMsg(AC_SERVICE_NAME, Format('%s,%s,%s,%d,%d',
      [AC_REGISTER_ACTION, ActionName, GroupName, WindowHandle, LParamID]));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UnRegisterAction(ActionName: String): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted(AC_SERVICE_NAME) = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to unregister the Action
    Result := ServiceMsg(AC_SERVICE_NAME, Format('%s,%s',
      [AC_UNREGISTER_ACTION, ActionName]));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UpdateAction(ActionName: String; WindowHandle: hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted(AC_SERVICE_NAME) = MR_STOPPED then
    begin
      Result := MR_ACTIONSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to update the Action
    Result := ServiceMsg(AC_SERVICE_NAME,
      Format('%s,%s,Undefined,%d,%d',
      [AC_UPDATE_ACTION, ActionName, WindowHandle, LParamID]));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UpdateActionEx(ActionName, GroupName: String; WindowHandle: hwnd;
  LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted(AC_SERVICE_NAME) = MR_STOPPED then
    begin
      Result := MR_ACTIONSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to update the Action
    Result := ServiceMsg(AC_SERVICE_NAME, Format('%s,%s,%s,%d,%d',
      [AC_UPDATE_ACTION, ActionName, GroupName, WindowHandle, LParamID]));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam; pSendMessage: boolean = False; pTimeout: boolean = False): integer;
var
  ha : THandleArray;
  n : integer;
  wnd : hwnd;
  ThreadID : dword;
  ret: Cardinal;

  function EnumThreadWindowsProc(Wnd: hwnd; param: lParam): boolean; export; stdcall;
  var
    ret: Cardinal;
  begin
    // make sure to not send to the main window again
    if messwnd <> wnd then
    begin
      if (bsm) and (bsmTimeout) then
        SendMessageTimeout(wnd, mess, wpara, lpara, SMTO_ABORTIFHUNG, SEND_MESSAGE_TIMEOUT, ret)
      else if bsm then
        SendMessage(wnd, mess, wpara, lpara)
      else
        PostMessage(wnd, mess, wpara, lpara);
    end;      
    inc(i);
    result := true;
  end;
  
begin
  ha := FindAllWindows('TSharpBarMainForm');
  wnd := FindWindow('TSharpCoreMainWnd',nil);
  if wnd <> 0 then
  begin
    setlength(ha,length(ha)+1);
    ha[high(ha)] := wnd;
  end;
  wnd := FindWindow('TSharpDeskMainForm',nil);
  if wnd <> 0 then
  begin
    setlength(ha,length(ha)+1);
    ha[high(ha)] := wnd;
  end;
  wnd := FindWindow('TSharpConsoleWnd',nil);
  if wnd <> 0 then
  begin
    setlength(ha,length(ha)+1);
    ha[high(ha)] := wnd;
  end;
  wnd := FindWindow('TSharpEMenuWnd',nil);
  if wnd <> 0 then
  begin
    setlength(ha,length(ha)+1);
    ha[high(ha)] := wnd;
  end;
  wnd := FindWindow('TSharpCenterWnd',nil);
  if wnd <> 0 then
  begin
    setlength(ha,length(ha)+1);
    ha[high(ha)] := wnd;
  end;

  mess := msg;
  wpara := wpar;
  lpara := lpar;
  bsm := pSendMessage;
  bsmTimeout := pTimeout;
  i := 0;  

  for n := High(ha) downto 0 do
  begin
    messwnd := ha[n];
    // send first to main window
    if (bsm) and (bsmTimeout) then
      SendMessageTimeout(messwnd, mess, wpara, lpara, SMTO_ABORTIFHUNG, SEND_MESSAGE_TIMEOUT, ret)
    else if bsm then
      SendMessage(messwnd, mess, wpara, lpara)
    else
      PostMessage(messwnd, mess, wpara, lpara);
    
    ThreadID := GetWindowThreadProcessId(ha[n],nil);
    if ThreadID <> 0 then
      EnumThreadWindows(ThreadID,@EnumThreadWindowsProc,msg);
  end;
  result := i;
end;

function SendMessageTo(WndName: string; msg: integer; wpar: wparam; lpar:
  lparam): boolean;
var
  Handle: hwnd;
begin
  Handle := FindWindow(nil, PCHar(WndName));
  if Handle <> 0 then
  begin
    SendMessage(handle, msg, wpar, lpar);
    result := True;
  end
  else
    result := False;
end;

function DirCheck(APath: string; var AResult: string): Boolean;
var
  aDirCheck: array[0..6] of string;
  i: Integer;
begin
  Result := False;
  aDirCheck[0] := 'SharpCore.exe';
  aDirCheck[1] := 'SharpBar.exe';
  aDirCheck[2] := 'SharpDesk.exe';
  aDirCheck[3] := 'SharpApi.dll';
  aDirCheck[4] := 'SharpDeskApi.dll';
  aDirCheck[5] := 'SharpThemeApi.dll';
  aDirCheck[6] := 'SharpMenu.exe';

  for i := Low(aDirCheck) to High(aDirCheck) do
    if FileExists(APath + aDirCheck[i]) then
    begin
      AResult := APath + aDirCheck[i];
      Result := True;
      Break;
    end;
end;

function UseAppDataSettingsDir : boolean;
begin
  result := UseAppData;
end;

function GetSharpeDirectory: String;

var
  Path: string;
  tmp: string;
  sCheckResult: string;
begin
  Result := '';

  // Check current dir
  Path := ExtractFilePath(Application_GetExeName);
  if DirCheck(Path, sCheckResult) then
  begin
    tmp := ExtractFilePath(sCheckResult);
    stemp := tmp;
    Result := stemp;
    exit;
  end;

  // check Registry Key
  Path := ReadRegString(HKEY_CURRENT_USER,'Software\SharpE','InstallPath');
  if DirCheck(Path, sCheckResult) then
  begin
    tmp := ExtractFilePath(sCheckResult);
    stemp := tmp;
    Result := stemp;
    exit;
  end;
end;

function GetSharpEAppDataPath : String;
begin
  result := IncludeTrailingBackSlash(JclSysInfo.GetAppdataFolder);
  result := result + AppDataSubDir;
  result := IncludeTrailingBackSlash(result);
end;

function GetSharpECommonAppDataPath : String;
begin
  result := IncludeTrailingBackSlash(JclSysInfo.GetCommonAppdataFolder);
  result := result + AppDataSubDir;
  result := IncludeTrailingBackSlash(result);
end;

function GetSharpeUserSettingsPath: String;
var
  Path: string;
  Fn: String;
  user: string;
  sRes: String;
begin
  if UseAppData then
  begin
    Fn := GetSharpEAppDataPath;
    Path := Fn + 'Settings\User\';

    if not (DirectoryExists(Path)) then
    begin
      // check if the default settings dir exists
      if DirectoryExists(GetSharpeDirectory + 'Settings\'+DEFAULTSETTINGSDIR) then
      begin
        SysUtils.ForceDirectories(Fn + 'Settings\User');
        CopyDir(GetSharpeDirectory + 'Settings\'+DEFAULTSETTINGSDIR + '\*', Fn + 'Settings\User\');
      end else Sysutils.ForceDirectories(Path);
    end;
  end else
  begin
    Fn := GetSharpeDirectory;
    User := GetLocalUserName;
    Path := IncludeTrailingBackslash(Fn + 'Settings\User') + User;

    if not (DirectoryExists(Path)) then
    begin
      // check if the default settings dir exists
      if DirectoryExists(Fn + 'Settings\'+DEFAULTSETTINGSDIR) then
      begin
        SysUtils.ForceDirectories(Fn + 'Settings\User\' + User);
        CopyDir(Fn + 'Settings\' + DEFAULTSETTINGSDIR + '\*',Fn + 'Settings\User\' + User + '\');
      end else
      begin
        DirCheck(Fn,sRes);

        if sRes <> '' then
           Sysutils.ForceDirectories(Path);
      end;
    end;
  end;

  stemp := IncludeTrailingBackslash(Path);
  Result := stemp;
end;

function GetSharpeGlobalSettingsPath: String;
var
  Path: string;
  Fn: String;
  sRes: String;
begin
  if UseAppData then
  begin
    Fn := GetSharpECommonAppDataPath;
    Path := Fn + 'Settings\Global\';

    if not (DirectoryExists(Path)) then
    begin
      // check if the default global settings directory exists in the SharpE Dir
      if DirectoryExists(GetSharpeDirectory + 'Settings\' + DEFAULTSETTINGSDIRGLOBAL) then
      begin
        SysUtils.ForceDirectories(Fn + 'Settings\Global');
        CopyDir(GetSharpeDirectory + 'Settings\' + DEFAULTSETTINGSDIRGLOBAL + '\*', Fn + 'Settings\Global\');
      end else Sysutils.ForceDirectories(Path);
    end;
  end else
  begin
    Fn := GetSharpeDirectory;
    Path := IncludeTrailingBackslash(Fn + 'Settings\Global');

    if not (DirectoryExists(Path)) then
    begin
      // check if the default settings dir exists
      if DirectoryExists(Fn + 'Settings\' + DEFAULTSETTINGSDIRGLOBAL) then
      begin
        SysUtils.ForceDirectories(Fn + 'Settings\Global');
        CopyDir(Fn + 'Settings\' + DEFAULTSETTINGSDIRGLOBAL + '\*',Fn + 'Settings\Global\');
      end else
      begin
        DirCheck(Fn,sRes);

        if sRes <> '' then
          Sysutils.ForceDirectories(Path);
      end;
    end;
  end;

  stemp := IncludeTrailingBackslash(Path);
  Result := stemp;
end;

function FindAllComponents(Component: String): THandleArray;
var
  sname: string;
begin
  sname := Component;
  if CompareText(sname, 'sharpdesk') = 0 then
    result := FindAllWindows('TSharpDeskMainForm')
  else if CompareText(sname, 'sharpcore') = 0 then
    result := FindAllWindows('TSharpCoreMainWnd')
  else if CompareText(sname, 'sharpbar') = 0 then
    result := FindAllWindows('TSharpBarMainForm')
  else if CompareText(sname, 'sharpconsole') = 0 then
    result := FindAllWindows('TSharpConsoleWnd')
  else if CompareText(sname, 'sharpmenu') = 0 then
    result := FindAllWindows('TSharpEMenuWnd')
  else
    result := FindAllWindows(sname);
end;

function FindComponent(Component: String): hwnd;
var
  sname: string;
begin
  sname := Component;
  if CompareText(sname, 'sharpdesk') = 0 then
    result := FindWindow('TSharpDeskMainForm', nil)
  else if CompareText(sname, 'sharpcore') = 0 then
    result := FindWindow('TSharpCoreMainWnd', nil)
  else if CompareText(sname, 'sharpbar') = 0 then
    result := FindWindow('TSharpBarMainForm', nil)
  else if CompareText(sname, 'sharpconsole') = 0 then
    result := FindWindow('TSharpConsoleWnd', nil)
  else if CompareText(sname, 'sharpmenu') = 0 then
    result := FindWindow('TSharpEMenuWnd', nil)
  else
    result := FindWindow(PChar(sname), nil);
end;

function IsComponentRunning(Component: String): boolean;
begin
  if FindComponent(Component) <> 0 then
    result := true
  else
    result := false;
end;

function CloseComponent(Component: String): boolean;
var
  wndlist: THandleArray;
  n: integer;
begin
  wndlist := FindAllComponents(Component);

  for n := 0 to High(wndlist) do
  begin
    SendMessage(wndlist[n], WM_SHARPTERMINATE, 0, 0);
    PostMessage(wndlist[n], WM_CLOSE, 0, 0);
    PostThreadMessage(GetWindowThreadProcessID(wndlist[n], nil), WM_QUIT, 0, 0);
  end;

  setlength(wndlist, 0);

  result := not IsComponentRunning(Component);
end;

procedure TerminateComponent(Component: String);
var
  PID: DWord;
begin
  PID := GetPidFromProcessName(Component + '.exe');
  TerminateApp(PID, 250);
end;

procedure StartComponent(Component: String);
begin
  if ExtractFileExt(Component) = '.exe' then
    SharpExecute(Component)
  else
    SharpExecute(Component + '.exe');
end;

function GetSharpBarCount : integer;
var
  ha : THandleArray;
  i : integer;
begin
  ha := FindAllWindows('TSharpBarMainForm');
  i := length(ha);
  setlength(ha,0);
  result := i;
end;

function GetSharpBarArea(Index : integer) : TBarRect;
var
  ha : THandleArray;
begin
  Index := abs(Index);
  ha := FindAllWindows('TSharpBarMainForm');
  if Index <= High(ha) then
  begin
    GetWindowRect(ha[Index],result.R);
    result.wnd := ha[Index];
  end;
  setlength(ha,0);
end;

function GetShellTaskMgrWindow : hwnd;
var
  swnd : hwnd;
begin
  swnd := FindWindow('Shell_TrayWnd',nil);
  if swnd <> 0 then
  begin
    swnd := FindWindowEx(swnd,0,'ReBarWindow32',nil);
    if swnd <> 0 then
      swnd := FindWindowEx(swnd,0,'MSTaskSwWClass',nil);
  end;
  result := swnd;
end;

function RequestWindowList(Wnd : hwnd) : boolean;
var
  swnd : hwnd;
begin
  swnd := GetShellTaskMgrWindow;
  if swnd <> 0 then  
    PostMessage(swnd,WM_REQUESTWNDLIST,wnd,0);
  result := (swnd <> 0);
end;

function RegisterShellHookReceiver(Wnd : hwnd) : boolean;
var
  swnd : hwnd;
begin
  swnd := GetShellTaskMgrWindow;
  if swnd <> 0 then  
    PostMessage(swnd,WM_REGISTERSHELLHOOK,wnd,0);
  result := (swnd <> 0);
end;

function UnRegisterShellHookReceiver(Wnd : hwnd) : boolean;
var
  swnd : hwnd;
begin
  swnd := GetShellTaskMgrWindow;
  if swnd <> 0 then
    PostMessage(swnd,WM_UNREGISTERSHELLHOOK,wnd,0);
  result := (swnd <> 0);
end;

function GetVersion(strFile: String): String;
var
  n, Len: Cardinal;
  Buf, Value: PChar;
begin
  Result := '';

  // Get current version
  n := GetFileVersionInfoSize(PChar(strFile), n) ;
  if n > 0 then
  begin
    Buf := AllocMem(n);
    try
      GetFileVersionInfo(PChar(strFile), 0, n, Buf) ;

      if VerQueryValue(Buf, PChar('StringFileInfo\040904E4\ProductVersion'), Pointer(Value), Len) then
        Result := Value;
    finally
      FreeMem(Buf, n);
    end;
  end;

  Result := Copy(Result, 1, 3);
end;

function CheckMetaDataVersion(strFile: String): Boolean;
begin
  Result := False;

  if (GetVersion(strFile) = currentVersion) or (GetVersion(strFile) = '0.0') then
    Result := True;
end;

function GetConfigPluginData(dllHandle: Thandle; var PluginData: TPluginData; pluginID : String) : Integer;
type
  TPluginDataFunc = function(pluginID : String): TPluginData;
const
  PluginDataFunc: TPluginDataFunc = nil;
begin
  result := 0;
  if dllHandle <> 0 then
  begin
    @PluginDataFunc := GetProcAddress(dllHandle, 'GetPluginData');
    if Assigned(PluginDataFunc) then
      PluginData := PluginDataFunc(pluginID)
    else
      result := 1; //didn't find GetPluginData function
  end else
    result := 1; //couldn't open file
end;

function GetComponentMetaDataEx(hndFile: THandle; var MetaData: TMetaData; var ExtraMetaData: TExtraMetaData) : Integer;
var
  stlData: TStrings;
  i: Integer;
  s: String;
  pcName: PChar;
  pcDescription: PChar;
  pcAuthor: PChar;
  pcExtraData: PChar;
begin
  result := 0;
  if hndFile <> 0 then
  begin
    stlData := TStringList.Create;

    try
      pcName := StrAlloc(255);
      if LoadString(hndFile, IDS_NAME, pcName, 255) <> 0 then
        MetaData.Name := String(pcName);
      StrDispose(pcName);

      pcDescription := StrAlloc(255);
      if LoadString(hndFile, IDS_DESCRIPTION, pcDescription, 255) <> 0 then
        MetaData.Description := String(pcDescription);
      StrDispose(pcDescription);

      pcAuthor := StrAlloc(255);
      if LoadString(hndFile, IDS_AUTHOR, pcAuthor, 255) <> 0 then
        MetaData.Author := String(pcAuthor);
      StrDispose(pcAuthor);

      pcExtraData := StrAlloc(255);
      if LoadString(hndFile, IDS_EXTRADATA, pcExtraData, 255) <> 0 then
        MetaData.ExtraData := String(pcExtraData);
      StrDispose(pcExtraData);

      MetaData.DataType := tteComponent;

      if MetaData.Name <> '' then
      begin
        StrTokenToStrings(MetaData.ExtraData, '|', stlData);

        for i := 0 to stlData.Count - 1 do
        begin
          if Pos('priority:', LowerCase(stlData[i])) > 0 then
          begin
            s := RightStr(stlData[i], Length(stlData[i]) - Length('priority:'));
            s := Trim(s);
            TryStrToInt(s, ExtraMetaData.Priority);
          end;

          if Pos('delay:', LowerCase(stlData[i])) > 0 then
          begin
            stlData[i] := Trim(stlData[i]);
            s := RightStr(stlData[i], Length(stlData[i]) - Length('delay:'));
            s := Trim(s);
            TryStrToInt(s, ExtraMetaData.Delay);
          end;

          if Pos('runonce:', LowerCase(stlData[i])) > 0 then
          begin
            stlData[i] := Trim(stlData[i]);
            s := RightStr(stlData[i], Length(stlData[i]) - Length('runonce:'));
            s := Trim(s);
            TryStrToBool(s, ExtraMetaData.RunOnce);
          end;

          if Pos('startup:', LowerCase(stlData[i])) > 0 then
          begin
            stlData[i] := Trim(stlData[i]);
            s := RightStr(stlData[i], Length(stlData[i]) - Length('startup:'));
            s := Trim(s);
            TryStrToBool(s, ExtraMetaData.Startup);
          end;
        end;
      end else
        result := 1;
    finally
      stlData.Free;
    end;
  end else
    result := 1; //couldn't open file
end;

function GetModuleMetaDataEx(hndFile: THandle; Preview: TBitmap32; var MetaData: TMetaData; var HasPreview: Boolean) : Integer;
type
  TMetaDataFunc = function(Preview: TBitmap32): TMetaData;
const
  MetaDataFunc: TMetaDataFunc = nil;
var
  stlData: TStrings;
  i: Integer;
  s: String;
begin
  result := 0;
  if hndFile <> 0 then
  begin
    stlData := TStringList.Create;
    try
      @MetaDataFunc := GetProcAddress(hndFile, 'GetMetaData');
      if Assigned(MetaDataFunc) then
      begin
        MetaData := MetaDataFunc(Preview);
        if (MetaData.DataType = tteModule) then
        begin
          StrTokenToStrings(MetaData.ExtraData, '|', stlData);

          for i := 0 to stlData.Count - 1 do
          begin
            stlData[i] := Trim(stlData[i]);
            if Pos('preview:', LowerCase(stlData[i])) > 0 then
            begin
              s := RightStr(stlData[i], Length(stlData[i]) - Length('preview:'));
              s := Trim(s);
              HasPreview := StrToBool(s);
            end;
          end;
        end else
          Result := 1;
      end else
        result := 1; //didn't find GetMetaData function
    finally
      stlData.Free;
    end;
  end else
    result := 1; //couldn't open file
end;

function GetServiceMetaDataEx(hndFile: THandle; var MetaData: TMetaData; var ExtraMetaData: TExtraMetaData) : Integer;
type
  TMetaDataFunc = function(): TMetaData;
const
  MetaDataFunc: TMetaDataFunc = nil;
var
  stlData: TStrings;
  i: Integer;
  s: String;
begin
  result := 0;
  if hndFile <> 0 then
  begin
    stlData := TStringList.Create;
    try
      @MetaDataFunc := GetProcAddress(hndFile, 'GetMetaData');
      if Assigned(MetaDataFunc) then
      begin
        MetaData := MetaDataFunc();
        if (MetaData.DataType = tteService) then
        begin
          StrTokenToStrings(MetaData.ExtraData, '|', stlData);

          for i := 0 to stlData.Count - 1 do
          begin
            if Pos('priority:', LowerCase(stlData[i])) > 0 then
            begin
              s := RightStr(stlData[i], Length(stlData[i]) - Length('priority:'));
              s := Trim(s);
              TryStrToInt(s, ExtraMetaData.Priority);
            end;

            if Pos('delay:', LowerCase(stlData[i])) > 0 then
            begin
              stlData[i] := Trim(stlData[i]);
              s := RightStr(stlData[i], Length(stlData[i]) - Length('delay:'));
              s := Trim(s);
              TryStrToInt(s, ExtraMetaData.Delay);
            end;

            if Pos('runonce:', LowerCase(stlData[i])) > 0 then
            begin
              stlData[i] := Trim(stlData[i]);
              s := RightStr(stlData[i], Length(stlData[i]) - Length('runonce:'));
              s := Trim(s);
              TryStrToBool(s, ExtraMetaData.RunOnce);
            end;

            if Pos('startup:', LowerCase(stlData[i])) > 0 then
            begin
              stlData[i] := Trim(stlData[i]);
              s := RightStr(stlData[i], Length(stlData[i]) - Length('startup:'));
              s := Trim(s);
              TryStrToBool(s, ExtraMetaData.Startup);
            end;
          end;
        end else
          Result := 1;
      end else
        result := 1; //didn't find GetMetaData function
    finally
      stlData.Free;
    end;
  end else
    result := 1; //couldn't open file
end;

function GetConfigMetaDataEx(hndFile: THandle; var MetaData: TMetaData; var ConfigMode: TSC_MODE_ENUM; var ConfigType: TSU_UPDATE_ENUM) : Integer;
type
  TMetaDataFunc = function(): TMetaData;
const
  MetaDataFunc: TMetaDataFunc = nil;
var
  stlData: TStrings;
  i: Integer;
  s: String;
  tmp: integer;
begin
  result := 0;
  if hndFile <> 0 then
  begin
    stlData := TStringList.Create;
    try
      @MetaDataFunc := GetProcAddress(hndFile, 'GetMetaData');
      if Assigned(MetaDataFunc) then
      begin
        MetaData := MetaDataFunc();
        if (MetaData.DataType = tteConfig) then
        begin
          StrTokenToStrings(MetaData.ExtraData, '|', stlData);

          for i := 0 to stlData.Count - 1 do
          begin
            if Pos('configmode:', LowerCase(stlData[i])) > 0 then
            begin
              stlData[i] := Trim(stlData[i]);
              s := RightStr(stlData[i], Length(stlData[i]) - Length('configmode:'));
              s := Trim(s);
              if TryStrToInt(s, tmp) then
                ConfigMode := TSC_MODE_ENUM(tmp);
            end;

            if Pos('configtype:', LowerCase(stlData[i])) > 0 then
            begin
              stlData[i] := Trim(stlData[i]);
              s := RightStr(stlData[i], Length(stlData[i]) - Length('configtype:'));
              s := Trim(s);
              if TryStrToInt(s, tmp) then
                ConfigType := TSU_UPDATE_ENUM(tmp);
            end;
          end;
        end else
          Result := 1;
      end else
        result := 1; //didn't find GetMetaData function
    finally
      stlData.Free;
    end;
  end else
    result := 1; //couldn't open file
end;

function GetComponentMetaData(strFile: String; var MetaData: TMetaData; var ExtraMetaData: TExtraMetaData) : Integer;
var
  hndFile: THandle;
begin
  // Initialize meta-data
  MetaData.Name := '';
  MetaData.Description := '';
  MetaData.Author := '';
  MetaData.ExtraData := '';

  ExtraMetaData.Priority := 0;
  ExtraMetaData.Delay := 0;
  ExtraMetaData.RunOnce := False;
  ExtraMetaData.Startup := False;

  result := 0;
  if (FileExists(strFile)) and (CheckMetaDataVersion(strFile)) then
  begin
    hndFile := LoadLibraryEx(PChar(strFile), 0, LOAD_LIBRARY_AS_DATAFILE);
    try
      Result := GetComponentMetaDataEx(hndFile, MetaData, ExtraMetaData);
    finally
      FreeLibrary(hndFile);
    end;
  end;
end;

function GetModuleMetaData(strFile: String; Preview: TBitmap32; var MetaData: TMetaData; var HasPreview: Boolean) : Integer;
var
  hndFile: THandle;
begin
  // Initialize meta-data
  MetaData.Name := '';
  MetaData.Description := '';
  MetaData.Author := '';
  MetaData.ExtraData := '';
  HasPreview := False;

  result := 0;
  if (FileExists(strFile)) and (CheckMetaDataVersion(strFile)) then
  begin
    hndFile := LoadLibrary(PChar(strFile));
    try
      Result := GetModuleMetaDataEx(hndFile, Preview, Metadata, HasPreview);
    finally
      FreeLibrary(hndFile);
    end;
  end;
end;

function GetServiceMetaData(strFile: String; var MetaData: TMetaData; var ExtraMetaData: TExtraMetaData) : Integer;
var
  hndFile: THandle;
begin
  // Initialize meta-data
  MetaData.Name := '';
  MetaData.Description := '';
  MetaData.Author := '';
  MetaData.ExtraData := '';

  ExtraMetaData.Priority := 0;
  ExtraMetaData.Delay := 0;
  ExtraMetaData.RunOnce := False;
  ExtraMetaData.Startup := False;

  if (FileExists(strFile))  and (CheckMetaDataVersion(strFile)) then
  begin
    hndFile := LoadLibrary(PChar(strFile));
    try
      Result := GetServiceMetaDataEx(hndFile, MetaData, ExtraMetaData);
    finally
      FreeLibrary(hndFile);
    end;
  end
  else
    result := 1; //couldn't open file
end;

function GetConfigMetaData(strFile: String; var MetaData: TMetaData; var ConfigMode: TSC_MODE_ENUM; var ConfigType: TSU_UPDATE_ENUM) : Integer;
var
  hndFile: THandle;
begin
  // Initialize meta-data
  MetaData.Name := '';
  MetaData.Description := '';
  MetaData.Author := '';
  MetaData.ExtraData := '';
  ConfigMode := TSC_MODE_ENUM(0);
  ConfigType := TSU_UPDATE_ENUM(0);

  if (FileExists(strFile))  and (CheckMetaDataVersion(strFile)) then
  begin
    hndFile := LoadLibrary(PChar(strFile));
    try
      Result := GetConfigMetaDataEx(hndFile, MetaData, ConfigMode, ConfigType);
    finally
      FreeLibrary(hndFile);
    end;
  end
  else
    result := 1; //couldn't open file
end;

function RecycleFiles(FileList : TStringList; PermDel : boolean): boolean;
var
  OpFile: TSHFileOpStruct;
begin
  ZeroMemory(@OpFile, SizeOf(OpFile));

  OpFile.wFunc := FO_DELETE;

  // We need to delimit the file list by #0 (file1#0file2#0 etc.)
  FileList.StrictDelimiter := True;
  FileList.Delimiter := #0;
  FileList.QuoteChar := #0;
  opFile.pFrom := PAnsiChar(FileList.DelimitedText);

  if not PermDel then
    OpFile.fFlags := FOF_ALLOWUNDO;

  Result := (SHFileOperation(OpFile) = 0);
end;

function FileCheck(pFileName : String; MustExist : boolean = False) : boolean;
const
  TimeOut = 2500;
  SleepTime = 10;
var
  StartTime : Cardinal;
  handle : hfile;
  EMode : DWord;
  DoSleep : boolean;
begin
  result := False;
  if (MustExist and not FileExists(pFileName)) then
    exit
  else if (not MustExist and not FileExists(pFileName)) then
  begin
    result := True;
    exit;
  end;

  EMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  StartTime := GetTickCount;
  repeat
    DoSleep := True;
    try
      try
        handle := CreateFile(PChar(pFileName), GENERIC_READ, 0, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
        if not (handle = INVALID_HANDLE_VALUE) then
        begin
          DoSleep := False;
          CloseHandle(handle);
          result := True;
        end;
      except
      end;
    finally
      if DoSleep then
        sleep(SleepTime);
    end;
  until (result or (GetTickCount - StartTime > TimeOut));
  SetErrorMode(EMode);
end;

function GetCursorPosSecure(out cursorPos: TPoint):boolean;
begin
  result := true;
  try
    GetCursorPos(cursorPos);
  except
    result := false;
    cursorPos := Point(0,0);
  end;
end;

function BroadcastGlobalUpdateMessage(AUpdateType: TSU_UPDATE_ENUM;
  APluginID: Integer = -1; ASendMessage: boolean = False): boolean;
begin
  Result := True;
  SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(AUpdateType), APluginID, ASendMessage);
end;

procedure InitGlobals;
var
  Reg : TRegistry;
  valid : boolean;
  AppDataDir,CommonAppDataDir : String;
begin
  valid := True;
  // Load Registry Settings
  Reg := TRegistry.Create;
  Reg.Access := KEY_READ; // read only
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(REGPATH,False) then
      valid := Reg.ReadBool('UseAppData')
  except
    valid := True;
  end;
  Reg.Free;

  // Validate AppData Directory
  if valid then
  begin
    AppDataDir       := JclSysInfo.GetAppdataFolder;
    CommonAppDataDir := JclSysInfo.GetCommonAppdataFolder;
    valid := DirectoryExists(AppDataDir) and DirectoryExists(CommonAppDataDir);
  end;

  // Check if SharpE Directory exists and/or create it
  try
    if valid and (not DirectoryExists(GetSharpEAppDataPath)) then
      valid := ForceDirectories(GetSharpEAppDataPath);
    if valid and (not DirectoryExists(GetSharpECommonAppDataPath)) then
      valid := ForceDirectories(GetSharpECommonAppDataPath);
  except
    valid := False;
  end;

  UseAppData := valid;
end;

procedure EntryPointProc(Reason: Integer);
begin
    case reason of
        DLL_PROCESS_ATTACH:
            begin
              InitGlobals;
            end;

        DLL_PROCESS_DETACH:
            begin
            end;
    end;
end;

exports
  ShellInitialized,

  SharpEBroadCast,
  BroadcastGlobalUpdateMessage,
  SendDebugMessage, //Sends Message to SharpConsole
  SendDebugMessageEx,
  SendConsoleMessage, //Sends Message to SharpConsole

  // Service Exports
  ServiceMsg,
  ServiceStop,
  ServiceStart,
  IsServiceStarted,
  IsServiceDone,
  ServiceDone,

  BarMsg,

  // Action Exports
  RegisterAction,
  RegisterActionEx,
  UnRegisterAction,
  UpdateAction,
  UpdateActionEx,

  // Bar Tool Functions
  GetSharpBarCount,
  GetSharpBarArea,

  GetCenterDirectory,
  GetSharpeDirectory,
  GetSharpeUserSettingsPath,
  GetSharpeGlobalSettingsPath,
  UseAppDataSettingsDir,

  GetCenterConfigExt,

  SendMessageTo,

  SharpExecute,

  FindComponent,
  IsComponentRunning,
  CloseComponent,
  TerminateComponent,
  StartComponent,

  GetShellTaskMgrWindow,
  RequestWindowList,
  RegisterShellHookReceiver,
  UnRegisterShellHookReceiver,

  GetVWMCount,
  GetCurrentVWM,
  GetVWMMoveToolWindows,
  SwitchToVWM,

  GetConfigPluginData,

  CheckMetaDataVersion,

  GetComponentMetaData,
  GetServiceMetaData,
  GetConfigMetaData,
  GetModuleMetaData,

  GetComponentMetaDataEx,
  GetServiceMetaDataEx,
  GetConfigMetaDataEx,
  GetModuleMetaDataEx,

  RecycleFiles,
  FileCheck,
  GetCursorPosSecure;

begin
  DllProc := @EntryPointProc;
  EntryPointProc(DLL_PROCESS_ATTACH);

  currentVersion := GetVersion(Application.ExeName);
end.

