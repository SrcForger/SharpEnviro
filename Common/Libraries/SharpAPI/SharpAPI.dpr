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
  windows,
  messages,
  SysUtils,
  shellAPI,
  jclsysinfo,
  jclstrings,
  classes,
  strutils,
  gr32,
  types,
  SimpleForms in '..\..\Units\SimpleUnits\SimpleForms.pas';

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

  WM_SHARPTERMINATE       = WM_APP + 550;

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

  OLD_REGPATH = 'Software\ldi\sharpe\';
  REGPATH = 'Software\SharpE-Shell\';
  SKINPATH = 'Skin';
  THEMEPATH = 'Theme';
  SCHEMEPATH = 'Scheme';
  SKINDIR = 'Skins';
  CENTERDIR = 'Center\Root';
  ICONSDIR = 'Icons';
  DEFAULTSETTINGSDIR = '#Default#';

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

type
  THandleArray = array of HWND;

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

  PConsoleMsg = ^TConsoleMsg;
  TConsoleMsg = record
    module: string[255];
    msg: string[255];
  end;

  PManagerCmd = ^TManagerCmd;
  TManagerCmd = record
    Command: string[255];
    Parameters: string[255];
  end;

  PHelpMsg = ^THelpMsg;
  THelpMsg = record
    Parameter: string[255];
  end;

  PActionCmd = ^TActionCmd;
  TActionCmd = record
    Command: string[255];
    hwndid: Integer;
    lparam: Integer;
  end;

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

  TMetaTypeEnum = (tteComponent, tteService, tteModule, tteConfig);

  TMetaData = record
    Name: String[255];
    Description: String[255];
    Author: String[255];
    Version: String[255];
    DataType: TMetaTypeEnum;
    ExtraData: String[255];
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
  i: integer;
  wpara: wparam;
  mess: integer;
  lpara: lparam;
  stemp: string;
  bsm: boolean;

function GetSharpeDirectory: PChar; forward;
function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam; pSendMessage: boolean = False): integer; forward;

{ HELPER FUNCTIONS }

// function based on http://www.delphipraxis.net/post452421.html
function FindAllWindows(const WindowClass: string): THandleArray;
type
  PParam = ^TParam;
  TParam = record
    ClassName: string;
    Res: THandleArray;
  end;
var
  Rec: TParam;

  function GetWndClass(pHandle: hwnd): string;
  var
    buf: array[0..254] of Char;
  begin
    GetClassName(pHandle, buf, SizeOf(buf));
    result := buf;
  end;

  function _EnumProc(_hWnd: HWND; _LParam: LPARAM): LongBool; stdcall;
  begin
    with PParam(_LParam)^ do
    begin
      if (CompareText(GetWndClass(_hWnd), ClassName) = 0) then
      begin
        SetLength(Res, Length(Res) + 1);
        Res[Length(Res) - 1] := _hWnd;
      end;
      Result := True;
    end;
  end;

begin
  try
    Rec.ClassName := WindowClass;
    SetLength(Rec.Res, 0);
    EnumWindows(@_EnumProc, Integer(@Rec));
  except
    SetLength(Rec.Res, 0);
  end;
  Result := Rec.Res;
end;

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

{EXPORTED FUNTIONS}

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

function SwitchToVWM(Index : integer; ExceptWnd : hwnd = 0) : boolean;
var
  wnd : hwnd;
begin
  wnd := FindWindow('SharpE_VWM',nil);
  if wnd <> 0 then
    result := (SendMessage(wnd,WM_VWMSWITCHDESKTOP,ExceptWnd,Index) <> 0)
  else result := False;
end;

function GetCenterDirectory: PChar;
var
  SharpEDir: string;
begin
  SharpEDir := GetSharpEDirectory;
  stemp := IncludeTrailingBackslash(SharpEDir) +
    IncludeTrailingBackslash(CenterDir);
  result := PChar(stemp);
end;

function ServiceStart(ServiceName: pChar): hresult;
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

function ServiceStop(ServiceName: pChar): hresult;
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

function ServiceMsg(ServiceName, Command: pChar): hresult;
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

function ServiceDone(ServiceName: pChar): hresult;
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

function BarMsg(PluginName, Command: pChar): hresult;
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

function IsServiceStarted(ServiceName: pchar): hresult;
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

//////////////////////////////////////////////////
// Sends a message to SharpConsole
//////////////////////////////////////////////////

function SendConsoleMessage(msg: pChar): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  cmsg: TConsoleMsg;
begin
  try
    cmsg.msg := msg;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConsoleMsg);
      lpData := @cmsg;
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

function SendDebugMessage(module: pChar; msg: pChar; color: integer): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  cmsg: TConsoleMsg;
begin
  try
    if module <> '' then
      module := pchar(module + ': ')
    else
      module := ':';

    msg := pChar('<B><FONT COLOR=$B06C48>' + string(module) + '</FONT></B>' +
      string(msg));

    cmsg.module := module;
    cmsg.msg := msg;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConsoleMsg);
      lpData := @cmsg;
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

function SendDebugMessageEx(module: pChar; msg: pChar; Color: TColor;
  MessageType: integer): hresult;
var
  wnd: hwnd;
  cds: TCopyDataStruct;
  cmsg: TConsoleMsg;
begin
  try
    if module <> '' then
      module := pchar(module + ': ')
    else
      module := ':';

    msg := pChar('' + string(module) + '</FONT></B>' +
      string(msg));

    cmsg.module := module;
    cmsg.msg := msg;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConsoleMsg);
      lpData := @cmsg;
    end;

    wnd := FindWindow('TSharpConsoleWnd', nil);
    if wnd <> 0 then
    begin
      SendMessage(wnd, WM_COPYDATA, MessageType, cardinal(@cds));
      Result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
    ;
  end;
end;

function SharpExecute(data: pChar): hresult;
var
  iElevate: Integer;
  iHistory: Integer;
  sTemp: String;
begin
//  Result := HR_OK;

  try
    if IsServiceStarted('exec') = MR_STARTED then
      result := ServiceMsg('exec', pchar(data))
    else
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

function RegisterAction(ActionName: Pchar; WindowHandle: hwnd; LParamID:
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
    Result := ServiceMsg(AC_SERVICE_NAME,
      pchar(Format('%s,%s,Undefined,%d,%d',
      [AC_REGISTER_ACTION, ActionName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function RegisterActionEx(ActionName: Pchar; GroupName: Pchar; WindowHandle:
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
    Result := ServiceMsg(AC_SERVICE_NAME, pchar(Format('%s,%s,%s,%d,%d',
      [AC_REGISTER_ACTION, ActionName, GroupName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UnRegisterAction(ActionName: Pchar): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted(AC_SERVICE_NAME) = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to unregister the Action
    Result := ServiceMsg(AC_SERVICE_NAME, pchar(Format('%s,%s',
      [AC_UNREGISTER_ACTION, ActionName])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UpdateAction(ActionName: Pchar; WindowHandle: hwnd; LParamID:
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
      pchar(Format('%s,%s,Undefined,%d,%d',
      [AC_UPDATE_ACTION, ActionName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UpdateActionEx(ActionName, GroupName: Pchar; WindowHandle: hwnd;
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
    Result := ServiceMsg(AC_SERVICE_NAME, pchar(Format('%s,%s,%s,%d,%d',
      [AC_UPDATE_ACTION, ActionName, GroupName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam; pSendMessage: boolean = False): integer;
var
  ha : THandleArray;
  n : integer;
  wnd : hwnd;
  ThreadID : dword;

  function EnumThreadWindowsProc(Wnd: hwnd; param: lParam): boolean; export; stdcall;
  begin
    if bsm then
      SendMessage(wnd, mess, wpara, lpara)
    else PostMessage(wnd, mess, wpara, lpara);
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
  i := 0;  

  for n := High(ha) downto 0 do
  begin
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

function GetSharpeDirectory: PChar;

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
    Result := pchar(stemp);
    exit;
  end;

  // check Registry Key
  Path := ReadRegString(HKEY_CURRENT_USER,'Software\SharpE','InstallPath');
  if DirCheck(Path, sCheckResult) then
  begin
    tmp := ExtractFilePath(sCheckResult);
    stemp := tmp;
    Result := pchar(stemp);
    exit;
  end;
end;

function GetSharpeUserSettingsPath: PChar;
var
  Path: string;
  Fn: pchar;
  user: string;
  sRes: String;
begin

  // Check current directory
  User := GetLocalUserName;
  Fn := GetSharpeDirectory;
  Path := IncludeTrailingBackslash(Fn + 'Settings\User') + User;

  if not (DirectoryExists(Path)) then
  begin
    // check if the default settings dir exists
    if DirectoryExists(Fn + 'Settings\'+DEFAULTSETTINGSDIR)
       and not DirectoryExists(Fn + 'Settings\User\'+DEFAULTSETTINGSDIR) then
    begin
      SysUtils.ForceDirectories(Fn + 'Settings\User\');
      CopyDir(Fn + 'Settings\'+DEFAULTSETTINGSDIR,Fn + 'Settings\User');
      RenameDir(Fn + 'Settings\User\'+DEFAULTSETTINGSDIR,Fn + 'Settings\User\'+User);
    end else
    begin
      DirCheck(Fn,sRes);

      if sRes <> '' then
         Sysutils.ForceDirectories(Path);
    end;
  end;

  stemp := IncludeTrailingBackslash(Path);
  Result := pchar(stemp);
  //SendDebugMessage('SharpApi', Result, clblack);
end;

function GetSharpeGlobalSettingsPath: PChar;
var
  Path: string;
  Fn: pchar;
  sRes: String;
begin
  // Check current directory
  Fn := GetSharpeDirectory;
  //SendDebugMessage('SharpApi Fn',Fn,clblack);

  Path := IncludeTrailingBackslash(Fn + 'Settings\Global');
  //SendDebugMessage('SharpApi Path',pchar(Path),clblack);

  if not (DirectoryExists(Path)) then begin
    DirCheck(Fn,sRes);

    if sRes <> '' then
      Sysutils.ForceDirectories(Path);
  end;

  stemp := IncludeTrailingBackslash(Path);
  //SendDebugMessage('SharpApi stemp',pchar(stemp),clblack);

  Result := pchar(stemp);
  //SendDebugMessage('SharpApi Result',Result,clblack);
end;

function FindAllComponents(Component: PChar): THandleArray;
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
    result := FindAllWindows(PChar(sname));
end;

function FindComponent(Component: PChar): hwnd;
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

function IsComponentRunning(Component: PChar): boolean;
begin
  if FindComponent(Component) <> 0 then
    result := true
  else
    result := false;
end;

function CloseComponent(Component: PChar): boolean;
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

procedure TerminateComponent(Component: PChar);
var
  PID: DWord;
begin
  PID := GetPidFromProcessName(Component + '.exe');
  TerminateApp(PID, 250);
end;

procedure StartComponent(Component: PChar);
begin
  if ExtractFileExt(Component) = '.exe' then
    SharpExecute(Component)
  else
    SharpExecute(PChar(Component + '.exe'));
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

function GetComponentMetaData(strFile: String; var MetaData: TMetaData; var Priority: Integer; var Delay: Integer) : Integer;
var
  hndFile: THandle;
  stlData: TStrings;
  i: Integer;
  s: String;
  pcName: PChar;
  pcDescription: PChar;
  pcAuthor: PChar;
  pcVersion: PChar;
  pcExtraData: PChar;
begin
  result := 0;
  if FileExists(strFile) then
  begin
    hndFile := LoadLibrary(PChar(strFile));
    stlData := TStringList.Create;

    pcName := StrAlloc(255);
    LoadString(hndFile, IDS_NAME, pcName, 255);
    MetaData.Name := String(pcName);
    StrDispose(pcName);

    pcDescription := StrAlloc(255);
    LoadString(hndFile, IDS_DESCRIPTION, pcDescription, 255);
    MetaData.Description := String(pcDescription);
    StrDispose(pcDescription);

    pcAuthor := StrAlloc(255);
    LoadString(hndFile, IDS_AUTHOR, pcAuthor, 255);
    MetaData.Author := String(pcAuthor);
    StrDispose(pcAuthor);

    pcVersion := StrAlloc(255);
    LoadString(hndFile, IDS_VERSION, pcVersion, 255);
    MetaData.Version := String(pcVersion);
    StrDispose(pcVersion);

    pcExtraData := StrAlloc(255);
    LoadString(hndFile, IDS_EXTRADATA, pcExtraData, 255);
    MetaData.ExtraData := String(pcExtraData);
    StrDispose(pcExtraData);

    MetaData.DataType := tteComponent;

    if MetaData.Name = '' then
    begin
      result := -1;
      FreeLibrary(hndFile);
      exit;
    end;

    StrTokenToStrings(MetaData.ExtraData, '|', stlData);

    for i := 0 to stlData.Count - 1 do
    begin
      if Pos('priority:', LowerCase(stlData[i])) > 0 then
      begin
        s := RightStr(stlData[i], Length(stlData[i]) - Length('priority:'));
        s := Trim(s);
        Priority := StrToInt(s);
      end;

      if Pos('delay:', LowerCase(stlData[i])) > 0 then
      begin
        stlData[i] := Trim(stlData[i]);
        s := RightStr(stlData[i], Length(stlData[i]) - Length('delay:'));
        s := Trim(s);
        Delay := StrToInt(s);
      end;
    end;
  FreeLibrary(hndFile);
  end
  else
    result := 1; //couldn't open file
end;

function GetServiceMetaData(strFile: String; var MetaData: TMetaData; var Priority: Integer; var Delay: Integer) : Integer;
type
  TMetaDataFunc = function(): TMetaData;
const
  MetaDataFunc: TMetaDataFunc = nil;
var
  hndFile: THandle;
  stlData: TStrings;
  i: Integer;
  s: String;
begin
  result := 0;
  if FileExists(strFile) then
  begin
    hndFile := LoadLibrary(PChar(strFile));
    stlData := TStringList.Create;
    try
      @MetaDataFunc := GetProcAddress(hndFile, 'GetMetaData');
      if Assigned(MetaDataFunc) then
      begin
        MetaData := MetaDataFunc();
        if not (MetaData.DataType = tteService) then
        begin
          result := 1; //wrong data type
          FreeLibrary(hndFile);
          exit;
        end;

        StrTokenToStrings(MetaData.ExtraData, '|', stlData);

        for i := 0 to stlData.Count - 1 do
        begin
          if Pos('priority:', LowerCase(stlData[i])) > 0 then
          begin
            stlData[i] := Trim(stlData[i]);
            s := RightStr(stlData[i], Length(stlData[i]) - Length('priority:'));
            s := Trim(s);
            Priority := StrToInt(s);
          end;

          if Pos('delay:', LowerCase(stlData[i])) > 0 then
          begin
            stlData[i] := Trim(stlData[i]);
            s := RightStr(stlData[i], Length(stlData[i]) - Length('delay:'));
            s := Trim(s);
            Delay := StrToInt(s);
          end;
        end;
      end
      else
        result := 1; //didn't find GetMetaData function
    finally
      stlData.Free;
      FreeLibrary(hndFile);
    end;
  end
  else
    result := 1; //couldn't open file
end;

function GetConfigMetaData(strFile: String; var MetaData: TMetaData; var ConfigMode: TSC_MODE_ENUM; var ConfigType: TSU_UPDATE_ENUM) : Integer;
type
  TMetaDataFunc = function(): TMetaData;
const
  MetaDataFunc: TMetaDataFunc = nil;
var
  hndFile: THandle;
  stlData: TStrings;
  i: Integer;
  s: String;
begin
  result := 0;
  if FileExists(strFile) then
  begin
    hndFile := LoadLibrary(PChar(strFile));
    stlData := TStringList.Create;
    try
      @MetaDataFunc := GetProcAddress(hndFile, 'GetMetaData');
      if Assigned(MetaDataFunc) then
      begin
        MetaData := MetaDataFunc();
        if not (MetaData.DataType = tteConfig) then
        begin
          result := 1; //wrong data type
          FreeLibrary(hndFile);
          exit;
        end;

        StrTokenToStrings(MetaData.ExtraData, '|', stlData);

        for i := 0 to stlData.Count - 1 do
        begin
          if Pos('configmode:', LowerCase(stlData[i])) > 0 then
          begin
            stlData[i] := Trim(stlData[i]);
            s := RightStr(stlData[i], Length(stlData[i]) - Length('configmode:'));
            s := Trim(s);
            ConfigMode := TSC_MODE_ENUM(StrToInt(s));
          end;

          if Pos('configtype:', LowerCase(stlData[i])) > 0 then
          begin
            stlData[i] := Trim(stlData[i]);
            s := RightStr(stlData[i], Length(stlData[i]) - Length('configtype:'));
            s := Trim(s);
            ConfigType := TSU_UPDATE_ENUM(StrToInt(s));
          end;
        end;
      end
      else
        result := 1; //didn't find GetMetaData function
    finally
      stlData.Free;
      FreeLibrary(hndFile);
    end;
  end
  else
    result := 1; //couldn't open file
end;

function GetModuleMetaData(strFile: String; Preview: TBitmap32; var MetaData: TMetaData; var HasPreview: Boolean) : Integer;
type
  TMetaDataFunc = function(Preview: TBitmap32): TMetaData;
const
  MetaDataFunc: TMetaDataFunc = nil;
var
  hndFile: THandle;
  stlData: TStrings;
  i: Integer;
  s: String;
begin
  result := 0;
  if FileExists(strFile) then
  begin
    hndFile := LoadLibrary(PChar(strFile));
    stlData := TStringList.Create;
    try
      @MetaDataFunc := GetProcAddress(hndFile, 'GetMetaData');
      if Assigned(MetaDataFunc) then
      begin
        MetaData := MetaDataFunc(Preview);
        if not (MetaData.DataType = tteModule) then
        begin
          result := 1; //wrong data type
          FreeLibrary(hndFile);
          exit;
        end;

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
      end
      else
        result := 1; //didn't find GetMetaData function
    finally
      stlData.Free;
      FreeLibrary(hndFile);
    end;
  end
  else
    result := 1; //couldn't open file
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

exports
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
  SwitchToVWM,

  GetComponentMetaData,
  GetServiceMetaData,
  GetConfigMetaData,
  GetModuleMetaData,

  FileCheck,
  GetCursorPosSecure;
begin

end.

