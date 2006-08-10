{
Source Name: SharpApi.dpr
Description: API commands for SharpE
Copyright (C) Lee Green (Pixol) <pixol@sharpe-shell.org>
              Malx (Malx@techie.com)
              Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe

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

{###########################################################################################
IMPORTANT SHARP-API CHANGES: 13 Feb 2006 by BB
############################################################################################
Due to the complexibility of the xml files and the speed issues when having
to load and parse xml files everytime when loading or saving a setting, I made
the decission to store important and global SharpE settings in the registry.
We can't have API functions which are messing around with xml files everytime
an application wants to get a ColorScheme or the current Skin name.
These settings which are accessed very often are therefore mirrored to the registry.
Mirrored to the registry means that they will be updated everytime a theme is beeing loaded.
This way we can have the most important settings accessable easily and without
having to mess around with xml files. If the registry key gets deleted in any way
(users reinstall windows, etc.) the data will simply be rewritten on startup
when SharpE is reloading the theme.
############################################################################################
CHANGELOG:
 * New consts :
    -> THEMEPATH = 'Theme'
    -> SKINPATH = 'Skin';  // Registry
    -> SKINDIR  = 'Skins'; // Directory containing the xml files
    -> SCHEMEPATH = 'Scheme';
    -> OLD_REGPATH = 'Software\ldi\sharpe\'; for backward compatibility
    -> ICONSDIR = 'Icons'; // Directory to the Icon sets
 * New Exported Functions:
     -> LoadColorSchemeEx
     -> SaveColorSchemeEx
     -> SaveColorScheme
     -> GetSkinName
     -> GetCurrentSkinFile
     -> SetNewSkin
     -> SendPluginMessage
     -> GetThemeName
     -> GetThemeID
     -> SetNewTheme
     -> GetIconSetName
     -> SetNewIconSet
     -> GetCurrentIconSetFile
     -> GetDelimitedIconSetList
     -> GetSkinDirectory
 * New types:
     -> TColorSchemeEx // TColorScheme + ThrobberText + WorkAreaText;
 * New Message types: (everything with 600++ is new)
     -> WM_UPDATEBARWIDTH       = WM_APP + 601; // used by SharpBar
     -> WM_SHARPEPLUGINMESSAGE  = WM_APP + 602; // used by SharpBar
     -> WM_SKINCHANGED          = WM_APP + 603; // global skin change broadcast!
     -> WM_REGISTERWITHTRAY     = WM_APP + 650; // used by SystemTray.Service
     -> WM_UNREGISTERWITHTRAY   = WM_APP + 651;

 * Changed REGPATH constant to 'Software\SharpE-Shell\';
    -> replaced REGPATH with OLD_REGPATH in SaveSetting[A-D] and LoadSetting[A-E] functions
    -> all new functions which are reading anything from the registry will use the new REGPATH
 * All modified registry functions will be moved to the top of the unit to clearly seperate them
 * Added LoadColorFromRegistry (modified version of LoadSettingD using new REGPATH)
 * Added SaveColorToRegistry (modified version of SaveSettingD using new REGPATH
 * Modified LoadColorScheme to use LoadColorFromRegistry and new REGPATH
     -> new registry path for Scheme settings is Software\SharpE-Shell\Scheme
 * Added SaveColorScheme/Ex (saving a TColorScheme/Ex to the registry)
 * Added LoadColorSchemeEx
 * Added GetSkinName (load the current skin name from registry)
 * Added GetCurrentSkinFile (will return the path to the skin.xml file of the current skin)
 * Added SetNewSkin(broadcast : boolean) (will set the skin in registry and broadcast
                                          and broadcast the change if param = true)
 * Added SendPluginMessage(BarID, PluginID : integer; Command : pChar)
 * Added GetThemeName (load theme name from registry)
 * Added GetThemeID
 * Added SetNewTheme (set new theme name)
 * Added IconSet handling functions -> GetIconSetName, SetNewIconSet, GetCurrentIconSetFile
         -> The whole icon set stuff should become more global and not only desk specific
 * Added GetDelimitedIconSetList (Delimited String List with Items: "IconIdetifier=IconFile")
 * Added GetSkinDirectory
 * Possible fix for '0' at the end of some PChar results
############################################################################################

}

library SharpAPI;

{$WARN UNIT_PLATFORM OFF}

uses
  windows,
  messages,
  SysUtils,
  shellAPI,
  Forms,
  classes,
  dialogs,
  FileCtrl,
  registry,
  jclregistry,
  jclfileutils,
  jclsysinfo,
  JvSimpleXML,
  Graphics,

  uExecServiceRecentItemList in '..\..\..\Plugins\Services\Exec\uExecServiceRecentItemList.pas',
  uExecServiceUsedItemList in '..\..\..\Plugins\Services\Exec\uExecServiceUsedItemList.pas';

{$R *.RES}

const
  WM_SHARPTRAYMESSAGE = WM_APP + 500;
  WM_SHARPCONSOLEMESSAGE = WM_APP + 502;
  WM_SHARPBARMESSAGE = WM_APP + 505;
  WM_SHARPEACTIONMESSAGE = WM_APP + 520;
  WM_SHARPEUPDATEACTIONS = WM_APP + 521;

  WM_WEATHERUPDATE = WM_APP + 540;

  WM_SHARPETHEMEUPDATE    = WM_APP + 522;
  WM_DISABLESHARPDESK     = WM_APP + 523;
  WM_ENABLESHARPDESK      = WM_APP + 524;
  WM_EDITCURRENTTHEME     = WM_APP + 525;
  WM_ADDDESKTOPOBJECT     = WM_APP + 526;
  WM_SHOWOBJECTLIST       = WM_APP + 527;
  WM_SHOWDESKTOPSETTINGS  = WM_APP + 528;
  WM_DISPLAYSHARPMENU     = WM_APP + 529;
  WM_CLOSESHARPMENU       = WM_APP + 530;
  WM_CLOSEDESK            = WM_APP + 531;
  WM_DESKEXPORTBACKGROUND = WM_APP + 532;
  WM_FORCEOBJECTRELOAD    = WM_APP + 533;
  WM_TERMINALWND          = WM_APP + 534;

  // SharpBar (new Skin Stuff)
  WM_UPDATEBARWIDTH       = WM_APP + 601;
  WM_SHARPEPLUGINMESSAGE  = WM_APP + 602;
  WM_SKINCHANGED          = WM_APP + 603;

  // System Tray Service
  WM_REGISTERWITHTRAY     = WM_APP + 650;
  WM_UNREGISTERWITHTRAY   = WM_APP + 651;
  
  // SharpCenter
  WM_SETTINGSCHANGED      = WM_APP + 660;
  WM_UPDATESETTINGS       = WM_APP + 661;
  WM_SCGLOBALBTNMSG         = WM_APP + 662;

  SCU_SHARPDESK = 1001;
  SCU_SHARPCORE = 1002;
  SCU_SHARPBAR = 1003;
  SCU_SHARPMENU = 1004;
  SCU_SHARPTHEME = 1005;
  SCU_SERVICE = 1006;
  SCU_OBJECT = 1007;
  SCU_MODULE = 1008;

  SCB_MOVEUP = 2000;
  SCB_MOVEDOWN = 2001;
  SCB_ADD = 2002;
  SCB_DEL = 2003;
  SCB_EDIT = 2004;
  SCB_IMPORT = 2005;
  SCB_EXPORT = 2006;
  SCB_CLEAR = 2007;

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
  SKINDIR  = 'Skins';
  CENTERDIR = 'Center\Root';
  ICONSDIR = 'Icons';

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
    WorkAreaText : Tcolor;
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
    Parameter: string[255]
  end;

  PConfigMsg = ^TConfigMsg;
  TConfigMsg = record
    Command: string[255];
    Parameter: string[255];
    PluginID: Integer;
  end;

  PActionCmd = ^TActionCmd;
  TActionCmd = record
    Command: string[255];
    hwndid: Integer;
    lparam: Integer;
  end;

var
  i: integer;
  wpara: wparam;
  mess: integer;
  lpara: lparam;


function GetSharpeDirectory  : PChar; forward;
function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam): integer; forward;

{ HELPER FUNCTIONS }
function RegLoadStr(Key, Prop, Default : String): string;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(REGPATH);
  try
    result := 'SharpE';
    Reg.RootKey := HKEY_CURRENT_USER;
    result := Reg.ReadString(Key,Prop,Default);
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function RegWriteStr(Key, Prop, Value  : String) : hresult;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(REGPATH);
  try
    result := HR_UNKNOWNERROR;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.WriteString(Key,Prop,Value);
    result := HR_OK;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function LoadColorFromRegistry(key: pChar; value: pChar; default: Tcolor): Tcolor;
var
  Reg: TRegIniFile;
  temp: string;
  i: integer;
  valid: boolean;
begin
  Reg := TRegIniFile.create(REGPATH);
  try
    result := default;
    Reg.RootKey := HKEY_CURRENT_USER;
    temp := Reg.ReadString(key, value, inttostr(default));
    try
      if length(temp) > 0 then
      begin
        valid := true;
        for i := 1 to length(temp) do
        begin
          if ((temp[i] >= '0') and (temp[i] <= '9')) or ((lowercase(temp[i]) >=
            'a') and (lowercase(temp[i]) <= 'f'))
            or ((i = 1) and ((temp[i] = '$') or (temp[i] = '#'))) then
            valid := valid
          else
            valid := false;
        end;
        if valid then
        begin
          if temp[1] = '#' then
          begin //if someone has saved a color in #RGB mode
            temp := '$' + temp[6] + temp[7] + temp[4] + temp[5] + temp[2] +
              temp[3];
          end;
          result := strtoint(temp);
        end
        else
          result := default;
      end;
    except
      result := default;
    end;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function SaveColorToRegistry(key: pChar; value: pChar; data: Tcolor): hresult;
var
  Reg: TRegIniFile;
  temp: string;
begin
  Reg := TRegIniFile.create(REGPATH);
  try
    result := HR_UNKNOWNERROR;
    Reg.RootKey := HKEY_CURRENT_USER;
    try
      temp := '$' + inttohex(data, 8);
    except
      temp := inttostr(data);
    end;
    Reg.WriteString(key, value, temp);
    result := HR_OK;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

{EXPORTED FUNTIONS}

function SaveColorScheme(cs : TColorScheme) : boolean;
begin
 try
   SaveColorToRegistry(SCHEMEPATH,'ThrobberBack',cs.Throbberback);
   SaveColorToRegistry(SCHEMEPATH,'ThrobberDark',cs.ThrobberDark);
   SaveColorToRegistry(SCHEMEPATH,'ThrobberLight',cs.ThrobberLight);
   SaveColorToRegistry(SCHEMEPATH,'WorkAreaBack',cs.WorkareaBack);
   SaveColorToRegistry(SCHEMEPATH,'WorkAreaDark',cs.WorkareaDark);
   SaveColorToRegistry(SCHEMEPATH,'WorkAreaLight',cs.WorkareaLight);
   result := true;
 except
   result := false;
 end;
end;

function LoadColorScheme: TColorScheme;
begin
  try
    result.Throbberback  := LoadColorFromRegistry(SCHEMEPATH, 'ThrobberBack', $00C88200);
    result.Throbberdark  := LoadColorFromRegistry(SCHEMEPATH, 'ThrobberDark', $00996400);
    result.Throbberlight := LoadColorFromRegistry(SCHEMEPATH, 'ThrobberLight', $00F6A710);
    result.WorkAreaback  := LoadColorFromRegistry(SCHEMEPATH, 'WorkAreaBack', $00DEDFDE);
    result.WorkAreadark  := LoadColorFromRegistry(SCHEMEPATH, 'WorkAreaDark', $00999999);
    result.WorkArealight := LoadColorFromRegistry(SCHEMEPATH, 'WorkAreaLight', $00FDFDFD);
  except
    result.Throbberback  := $00C88200;
    result.Throbberdark  := $00996400;
    result.Throbberlight := $00F6A710;
    result.WorkAreaback  := $00DEFDDE;
    result.WorkAreadark  := $00AAAAAA;
    result.WorkArealight := $00FDFDFD;
  end;
end;

function SaveColorSchemeEx(cs : TColorSchemeEx) : boolean;
begin
 try
   SaveColorToRegistry(SCHEMEPATH,'ThrobberBack',cs.Throbberback);
   SaveColorToRegistry(SCHEMEPATH,'ThrobberDark',cs.ThrobberDark);
   SaveColorToRegistry(SCHEMEPATH,'ThrobberLight',cs.ThrobberLight);
   SaveColorToRegistry(SCHEMEPATH,'ThrobberText',cs.ThrobberText);
   SaveColorToRegistry(SCHEMEPATH,'WorkAreaBack',cs.WorkareaBack);
   SaveColorToRegistry(SCHEMEPATH,'WorkAreaDark',cs.WorkareaDark);
   SaveColorToRegistry(SCHEMEPATH,'WorkAreaLight',cs.WorkareaLight);
   SaveColorToRegistry(SCHEMEPATH,'WorkAreaText',cs.WorkAreaText);
   result := true;
 except
   result := false;
 end;
end;

function LoadColorSchemeEx: TColorSchemeEx;
begin
  try
    result.Throbberback  := LoadColorFromRegistry(SCHEMEPATH, 'ThrobberBack', $00C88200);
    result.Throbberdark  := LoadColorFromRegistry(SCHEMEPATH, 'ThrobberDark', $00996400);
    result.Throbberlight := LoadColorFromRegistry(SCHEMEPATH, 'ThrobberLight', $00F6A710);
    result.ThrobberText  := LoadColorFromRegistry(SCHEMEPATH, 'ThrobberText', $00000000);
    result.WorkAreaback  := LoadColorFromRegistry(SCHEMEPATH, 'WorkAreaBack', $00DEDFDE);
    result.WorkAreadark  := LoadColorFromRegistry(SCHEMEPATH, 'WorkAreaDark', $00999999);
    result.WorkArealight := LoadColorFromRegistry(SCHEMEPATH, 'WorkAreaLight', $00FDFDFD);
    result.WorkAreaText  := LoadColorFromRegistry(SCHEMEPATH, 'WorkAreaText', $00000000);
  except
    result.Throbberback  := $00C88200;
    result.Throbberdark  := $00996400;
    result.Throbberlight := $00F6A710;
    result.ThrobberText  := $00000000;
    result.WorkAreaback  := $00DEFDDE;
    result.WorkAreadark  := $00AAAAAA;
    result.WorkArealight := $00FDFDFD;
    result.WorkAreaText  := $00000000;
  end;
end;

function GetIconSetName : PChar;
var
  stemp:String;
begin
  stemp := RegLoadStr(THEMEPATH,'IconSet','Cubeix Black');
  result := PChar(stemp);
end;

function GetThemeName : PChar;
var
  stemp:String;
begin
  stemp := RegLoadStr(THEMEPATH,'Name','SharpE');
  result := PChar(stemp);
end;

function GetThemeID : Integer;
var
  stemp:String;
begin
  stemp := RegLoadStr(THEMEPATH,'ID','0');
  try
    result := StrToInt(stemp)
  except
    result := 0;
  end;
end;

function SetNewIconSet(NewIconSet : String) : hresult;
begin
  result := RegWriteStr(THEMEPATH,'IconSet',NewIconSet);
end;

function GetCurrentIconSetFile : PChar;
var
  SharpEDir : String;
  IconSet   : String;
  stemp     : string;
begin
  SharpEDir := GetSharpEDirectory;
  IconSet   := GetIconSetName;
  stemp     := IncludeTrailingBackslash(SharpEDir) +
               IncludeTrailingBackslash(ICONSDIR) +
               IncludeTrailingBackslash(IconSet) +
               'IconSet.xml';
  result :=  PChar(stemp);
end;

function SetNewTheme(NewTheme : String; NewThemeID : integer; broadcast : boolean) : hresult;
begin
  RegWriteStr(THEMEPATH,'Name',NewTheme);
  result := RegWriteStr(THEMEPATH,'ID',inttostr(NewThemeID));
  if broadcast then
     SharpEBroadCast(WM_SHARPETHEMEUPDATE,NewThemeID,1);
end;

function GetSkinName : PChar;
var
  stemp:String;
begin
  stemp := RegLoadStr(SKINPATH,'Name','SharpE');
  result := PChar(stemp);
end;

function GetCenterDirectory : PChar;
var
  SharpEDir : String;
  stemp:String;
begin
  SharpEDir := GetSharpEDirectory;
  stemp := IncludeTrailingBackslash(SharpEDir)+
           IncludeTrailingBackslash(CenterDir);
  result := PChar(stemp);
end;

function GetSkinDirectory : PChar;
var
  SharpEDir : String;
  stemp:String;
begin
  SharpEDir := GetSharpEDirectory;
  stemp := IncludeTrailingBackslash(SharpEDir)+
           IncludeTrailingBackslash(SkinDir);
  result := PChar(stemp);
end;

function GetCurrentSkinFile : PChar;
var
  SkinDir  : String;
  SkinName : String;
  stemp:String;
begin
  SkinDir := GetSkinDirectory;
  SkinName := GetSkinName;
  stemp := SkinDir +
           IncludeTrailingBackslash(SkinName) +
           'Skin.xml';
  result := PChar(stemp);
end;

function SetNewSkin(NewSkin : String; broadcast : boolean) : hresult;
begin
  result := RegWriteStr(SKINPATH,'Name',NewSkin);
  if broadcast then
     SharpEBroadCast(WM_SKINCHANGED,0,0);
end;

function GetDelimitedIconSetList: WideString;
var
  FileName: string;
  SList: tstringlist;
  XML : TJvSimpleXML;
  n : integer;
begin
  try
    XML := TJvSimpleXML.Create(nil);
    SList := TStringList.Create;
    SList.Clear;
    FileName := GetCurrentIconSetFile;

    if FileExists(FileName) then
    begin
      XML.LoadFromFile(FileName);
      for n:=0 to XML.Root.Items.ItemNamed['Icons'].Items.Count-1 do
          with XML.Root.Items.ItemNamed['Icons'].Items.Item[n].Items do
               SList.Add(Value('name','error')+'='+Value('file','error'));
      Result := SList.CommaText;
      FreeAndNil(SList);
      FreeAndNil(XML);
    end else result := '';

  finally
    if Assigned(SList) then
       FreeAndNil(SList);
    if Assigned(XML) then
       FreeAndNil(XML);
  end;

end;


{FUNCTIONS NOT CHANGED SINCE UPDATE 02 Feb 2005}

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

function CenterMsg(Command, Param : PChar; PluginID : integer): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TConfigMsg;
begin
  try
    //Prepare TCopyDataStruct
    msg.PluginID := Pluginid;
    msg.Command := Command;
    msg.Parameter := Param;
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConfigMsg);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow('TSharpCenterWnd', nil);
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

function SendPluginMessage(BarID, PluginID : integer; Command : pChar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TManagerCmd;
begin
  try
    //Prepare TCopyDataStruct
    msg.Parameters := Command;
    msg.Command := inttostr(PluginID);
    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TManagerCmd);
      lpData := @msg;
    end;
    //Find the window
    wnd := FindWindow(nil,PChar('SharpBar_'+inttostr(BarID)));
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

function SendUpdateMessageToSharpBar(modulewnd: hwnd): hresult;
var
  wnd: hwnd;
begin
  try
    wnd := FindWindow('TSharpBarMainForm', 'SharpBar');
    if wnd <> 0 then
    begin
      PostMessage(wnd, WM_SHARPBARMESSAGE, ARG_MODULEUPDATE, modulewnd);
      result := HR_OK;
    end
    else
      result := HR_NORECIEVERWINDOW;
  except
    result := HR_UNKNOWNERROR;
    ;
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

function ClearKey(Key: pChar): hresult;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.erasesection(Key);
    result := HR_OK;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function SaveSettingA(module: pChar; setting: pChar; data: pChar): hresult;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    result := HR_UNKNOWNERROR;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.WriteString(string(module), string(setting), string(data));
    result := HR_OK;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function SaveSettingB(module: pChar; setting: pChar; data: integer): hresult;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    result := HR_UNKNOWNERROR;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.WriteInteger(module, setting, data);
    result := HR_OK;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function SaveSettingC(module: pChar; setting: pChar; data: boolean): hresult;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    result := HR_UNKNOWNERROR;
    Reg.RootKey := HKEY_CURRENT_USER;
    if data then
      Reg.WriteInteger(module, setting, 1)
    else
      Reg.WriteInteger(module, setting, 0);
    result := HR_OK;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function SaveSettingD(module: pChar; setting: pChar; data: Tcolor): hresult;
var
  Reg: TRegIniFile;
  temp: string;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    result := HR_UNKNOWNERROR;
    Reg.RootKey := HKEY_CURRENT_USER;
    try
      temp := '$' + inttohex(data, 8);
    except
      temp := inttostr(data);
    end;
    Reg.WriteString(module, setting, temp);
    result := HR_OK;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function LoadSettingA(module: pChar; setting: pChar; default: pChar): pChar;
var
  Reg: TRegIniFile;
  stemp:String;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    result := default;
    Reg.RootKey := HKEY_CURRENT_USER;
    sTemp := Reg.ReadString(module, setting, default);
    result := pChar(sTemp);
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function LoadSettingB(module: pChar; setting: pChar; default: integer): integer;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    result := default;
    Reg.RootKey := HKEY_CURRENT_USER;
    result := Reg.ReadInteger(module, setting, default);
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function LoadSettingC(module: pChar; setting: pChar; default: boolean): boolean;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    result := default;
    Reg.RootKey := HKEY_CURRENT_USER;
    result := Reg.ReadBool(module, setting, default);
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

function LoadSettingE(module: pChar): Tstringlist;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create(OLD_REGPATH + module + '\');
  result := Tstringlist.create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.GetValueNames(result);
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end; 

function LoadSettingD(module: pChar; setting: pChar; default: Tcolor): Tcolor;
var
  Reg: TRegIniFile;
  temp: string;
  i: integer;
  valid: boolean;
begin
  Reg := TRegIniFile.create(OLD_REGPATH);
  try
    result := default;
    Reg.RootKey := HKEY_CURRENT_USER;
    temp := Reg.ReadString(module, setting, inttostr(default));
    try
      if length(temp) > 0 then
      begin
        valid := true;
        for i := 1 to length(temp) do
        begin
          if ((temp[i] >= '0') and (temp[i] <= '9')) or ((lowercase(temp[i]) >=
            'a') and (lowercase(temp[i]) <= 'f'))
            or ((i = 1) and ((temp[i] = '$') or (temp[i] = '#'))) then
            valid := valid
          else
            valid := false;
        end;
        if valid then
        begin
          if temp[1] = '#' then
          begin //if someone hase saved a color in #RGB mode
            temp := '$' + temp[6] + temp[7] + temp[4] + temp[5] + temp[2] +
              temp[3];
          end;
          result := strtoint(temp);
        end
        else
          result := default;
      end;
    except
      result := default;
    end;
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;


function SharpExecute(data: pChar): hresult;
var
  wnd:hWnd;
  n:hresult;
  bShellExecute: Boolean;
begin
  Result := HR_OK;
  try

    bShellExecute := True;
    wnd := FindWindow('TSharpCoreMainWnd', nil);
    if wnd <> 0 then
    begin
      if IsServiceStarted('exec') = MR_STARTED then
      begin
        result := ServiceMsg('exec', pchar(data));
        bShellExecute := False;
      end else
      begin
          n := ServiceStart('exec');
          if (n <> HR_NORECIEVERWINDOW) or (n <> HR_UNKNOWNERROR) then begin
            result := ServiceMsg('exec', pchar(data));
            bShellExecute := False;
          end;
      end;
    end;

    // Only try shell execute if service could not be started.
    if bShellExecute then
      result := shellexecute(0, nil, pChar(data), '',
        pchar(ExtractFilePath(data)), SW_SHOW);

  except
    result := HR_UNKNOWNERROR;
  end;
end;

function RegisterAction(ActionName: Pchar; WindowHandle: hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('actions') = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to register the Action
    Result := ServiceMsg('actions', pchar(Format('_registeraction,%s,Undefined,%d,%d',
      [ActionName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function RegisterActionEx(ActionName: Pchar; GroupName: Pchar; WindowHandle: hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('actions') = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to register the Action
    Result := ServiceMsg('actions', pchar(Format('_registeraction,%s,%s,%d,%d',
      [ActionName, GroupName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UnRegisterAction(ActionName: Pchar): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('actions') = MR_STOPPED then
    begin
      Result := MR_ActionSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to unregister the Action
    Result := ServiceMsg('actions', pchar(Format('_unregisteraction,%s',
      [ActionName])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UpdateAction(ActionName: Pchar; WindowHandle: hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('Actions') = MR_STOPPED then
    begin
      Result := MR_ACTIONSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to update the Action
    Result := ServiceMsg('actions', pchar(Format('_updateaction,%s,Undefined,%d,%d',
      [ActionName, WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function UpdateActionEx(ActionName, GroupName: Pchar; WindowHandle: hwnd; LParamID:
  Cardinal): hresult;
begin
  try

    // Check if the Actions service is running
    if IsServiceStarted('Actions') = MR_STOPPED then
    begin
      Result := MR_ACTIONSERVICE_NOT_AVAIL;
      Exit;
    end;

    // Send the message to update the Action
    Result := ServiceMsg('actions', pchar(Format('_updateaction,%s,%s,%d,%d',
      [ActionName, GroupName,WindowHandle, LParamID])));
  except
    result := HR_UNKNOWNERROR;
  end;
end;

function GetDelimitedActionList: WideString;
var
  fn: string;
  strl: tstringlist;
begin
  try
    strl := TStringList.Create;
    fn := ExtractFilePath(application.ExeName) + 'tmp';
    ServiceMsg('actions', pchar('_buildactionlist,' + fn));

    if FileExists(fn) then
    begin
      strl.LoadFromFile(fn);
      Result := strl.CommaText;
      FreeAndNil(strl);

      DeleteFile(fn)
    end;

  finally
    if Assigned(strl) then
      FreeAndNil(strl);
  end;

end;

function SharpEBroadCast(msg: integer; wpar: wparam; lpar: lparam): integer;
  function EnumWindowsProc(Wnd: hwnd; param: lParam): boolean; export; stdcall;
  begin
    PostMessage(wnd, mess, wpara, lpara);
    inc(i);
    result := true;
  end;
begin
  i := 0;
  mess := msg;
  wpara := wpar;
  lpara := lpar;
  EnumWindows(@EnumWindowsProc, msg);
  result := i;
end;

/////////////////////////////////////////////
// Just here for backward compability
/////////////////////////////////////////////

function SendTrayMessage(msg: pChar; timeout: integer; effekt: integer):
  hresult;
begin
  result := HR_UNKNOWNERROR;
end;

function HelpMsg(MsgText: Pchar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: THelpMsg;
  path: string;
  MutexHandle: THandle;
begin
  Result := 0;
  wnd := 0;
  try
    //Prepare TCopyDataStruct

    SendDebugMessageEx('SharpApi', pchar(format('Help Msg Received: %s',
      [MsgText])), 0, DMT_INFO);
    msg.Parameter := MsgText;

    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(THelpMsg);
      lpData := @msg;
    end;

    MuteXHandle := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpDocsMuteX');
    if MuteXHandle <> 0 then
    begin

      //Find the window
      wnd := FindWindow(nil, 'SharpDocsWnd');
      if wnd <> 0 then
      begin
        SendDebugMessageEx('SharpApi',
          pchar(format('SharpDocs Mutex Exists, Sending Msg: %s', [MsgText])),
          0,
          DMT_STATUS);
        result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      end;
      CloseHandle(MuteXHandle);
    end
    else
    begin
      // Start the SharpDocs application
      Path := GetSharpeDirectory;
//      Path := RegReadString(HKEY_CURRENT_USER, 'Software\ldi\sharpe\SharpCore',
//        'SharpEPath');

      if fileexists(Path + 'SharpDocs.exe') then
      begin
        SendDebugMessageEx('SharpApi',
          pchar(format('SharpDocs Mutex not found, Launching file: %s', [Path +
          'SharpDocs.exe'])), 0, DMT_STATUS);
        ShellExecute(wnd, 'open', pchar(Path + 'SharpDocs.exe'), Pchar('-api ' +
          MsgText), pchar(path), WM_SHOWWINDOW);
      end
      else
        SendDebugMessageEx('SharpApi',
          pchar(format('There was an error launching: %s', [Path +
          'SharpDocs.exe'])), 0, DMT_ERROR);
    end;

  except
    result := HR_UNKNOWNERROR;
  end;
end;

function ConfigMsg(ACommand: Pchar; AParameter: PChar; APluginID:Integer): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TConfigMsg;
  path: string;
  MutexHandle: THandle;
begin
  Result := 0;
  wnd := 0;
  try
    //Prepare TCopyDataStruct

    SendDebugMessageEx('SharpApi', pchar(format('Config Msg Received: %s - %s',
      [ACommand,AParameter])), 0, DMT_INFO);
    msg.Parameter := AParameter;
    msg.Command := ACommand;
    msg.PluginID := APluginID;

    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TConfigMsg);
      lpData := @msg;
    end;

    MuteXHandle := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpCenterMutexX');
    if MuteXHandle <> 0 then
    begin

      //Find the window
      wnd := FindWindow('TSharpCenterWnd', nil);
      if wnd <> 0 then
      begin
        SendDebugMessageEx('SharpApi',
          pchar(format('SharpCenter Mutex Exists, Sending Msg: %s - %s', [ACommand,AParameter])),
          0,
          DMT_STATUS);
        result := sendmessage(wnd, WM_COPYDATA, 0, Cardinal(@cds));
      end;
      CloseHandle(MuteXHandle);
    end
    else
    begin
      // Start the SharpCenter application
      Path := GetSharpeDirectory;

      if fileexists(Path + 'SharpCenter.exe') then
      begin
        SendDebugMessageEx('SharpApi',
          pchar(format('SharpCenter Mutex not found, Launching file: %s', [Path +
          'SharpCenter.exe'])), 0, DMT_STATUS);
        ShellExecute(wnd, 'open', pchar(Path + 'SharpCenter.exe'), Pchar('-api ' +
          ACommand + ' ' + AParameter), pchar(path), WM_SHOWWINDOW);
      end
      else
        SendDebugMessageEx('SharpApi',
          pchar(format('There was an error launching: %s', [Path +
          'SharpCenter.exe'])), 0, DMT_ERROR);
    end;

  except
    result := HR_UNKNOWNERROR;
  end;
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

function GetSharpeDirectory: PChar;

  function DirCheck(APath:String; var AResult:String):Boolean;
  var
    DirCheck: array[0..4] of String;
    i: Integer;
  begin
    Result := False;
    DirCheck[0] := 'SharpCore.exe';
    DirCheck[1] := 'SharpBar.exe';
    DirCheck[2] := 'SharpDesk.exe';
    DirCheck[3] := 'SharpApi.dll';
    DirCheck[4] := 'SharpDeskApi.dll';

    for i := Low(DirCheck) to High(DirCheck) do
    if FileExists(APath + DirCheck[i]) then begin
      AResult := APath + DirCheck[i];
      Result := True;
      Break;
    end;

  end;

var
  Path: string;
  tmp: string;
  Reg:TRegistry;
  sCheckResult: String;
begin
  Result := '';

  // Check current dir
  Path := ExtractFilePath(Application.ExeName);
  if DirCheck(Path,sCheckResult) then begin
    tmp := ExtractFilePath(sCheckResult);
    Result := pchar(tmp);
    exit;
  end;

  // check Registry Key
  Reg := TRegistry.Create;
  Try
    Reg.RootKey := HKCU;
    Reg.OpenKey('Software\SharpE',True);

    If Reg.ValueExists('InstallPath') Then Begin

      Path := Reg.ReadString('InstallPath');
      if DirCheck(Path,sCheckResult) then begin
        tmp := ExtractFilePath(sCheckResult);
        Result := pchar(tmp);
        exit;
      end;
    End;
  Finally
    Reg.CloseKey;
    Reg.Free;
  End;
end;

function GetSharpeUserSettingsPath: PChar;
var
  Path: string;
  Fn: pchar;
  user:String;
  stemp:String;
begin

  // Check current directory
  User := GetLocalUserName;
  Fn := GetSharpeDirectory;
  Path := IncludeTrailingBackslash(Fn+'Settings\User') + User;

  if Not(DirectoryExists(Path)) then
    Sysutils.ForceDirectories(Path);

  stemp := IncludeTrailingBackslash(Path);
  Result := pchar(stemp);
  SendDebugMessage('SharpApi',Result,clblack);
end;

function GetSharpeGlobalSettingsPath: PChar;
var
  Path: string;
  Fn: pchar;
  stemp:String;
begin
  // Check current directory
  Fn := GetSharpeDirectory;
  //SendDebugMessage('SharpApi Fn',Fn,clblack);

  Path := IncludeTrailingBackslash(Fn+'Settings\Global');
  //SendDebugMessage('SharpApi Path',pchar(Path),clblack);

  if Not(DirectoryExists(Path)) then
    Sysutils.ForceDirectories(Path);

  stemp := IncludeTrailingBackslash(Path);
  //SendDebugMessage('SharpApi stemp',pchar(stemp),clblack);

  Result := pchar(stemp);
  //SendDebugMessage('SharpApi Result',Result,clblack);
end;

function GetRecentItems(ReturnCount: integer): widestring;
var
  i: integer;
  strl: TStringList;
const
  xmlfile = 'SharpCore\Services\Exec\RiList.xml';
begin

  // Check if greater than recent items capacity
  if ReturnCount > 50 then
  begin
    ShowMessage('Must not exceed recent item count of 50');
    exit;
  end;

  TmpRI := TRecentItemsList.Create(GetSharpeUserSettingsPath + xmlfile);
  strl := TStringList.Create;

  if ReturnCount >= TmpRI.Items.Count - 1 then
    ReturnCount := TmpRI.Items.Count;

  with TmpRI do
  begin
    for i := Items.Count - 1 downto (Items.Count - ReturnCount) do
    begin
      strl.Add(TmpRI[i].Value);
    end;

    Result := strl.CommaText;
  end;

  TmpRI.Free;
  Strl.Free;

end;

function GetMostUsedItems(ReturnCount: integer): widestring;
var
  i: integer;
  strl: tstringlist;
const
  xmlfile = 'SharpCore\Services\Exec\UiList.xml';
begin

  TmpMui := TUsedItemsList.Create(GetSharpeUserSettingsPath + xmlfile);
  strl := TStringList.Create;
  TmpMui.Sort;

  if ReturnCount >= TmpMui.Items.Count then
    ReturnCount := TmpMui.Items.Count;

  with TmpMui do
  begin
    for i := 0 to ReturnCount - 1 do
      strl.Add(TmpMui[i].Value);

    Result := strl.CommaText;
  end;

  TmpMui.Free;
  Strl.Free;

end;

exports
  SharpEBroadCast,
  SendDebugMessage, //Sends Message to SharpConsol
  SendDebugMessageEx,
  SendTrayMessage, //Sends Message to SharpTray
  SendConsoleMessage, //Sends Message to SharpConsol

  // Service Exports
  ServiceMsg,
  ServiceStop,
  ServiceStart,
  IsServiceStarted,

  BarMsg,

  // Action Exports
  RegisterAction,
  RegisterActionEx,
  UnRegisterAction,
  UpdateAction,
  UpdateActionEx,
  GetDelimitedActionList,

  // Help Exports
  HelpMsg,

  // SharpCenter
  ConfigMsg,
  CenterMsg,
  GetCenterDirectory,

  GetSharpeDirectory,
  GetSharpeUserSettingsPath,
  GetSharpeGlobalSettingsPath,
  GetRecentItems,
  GetMostUsedItems,
  GetSkinName,
  GetCurrentSkinFile,
  SetNewSkin,
  GetThemeName,
  SetNewTheme,
  GetIconSetName,
  SetNewIconSet,
  GetCurrentIconSetFile,
  GetDelimitedIconSetList,
  GetThemeID,
  GetSkinDirectory,

  SaveSettingA,
  SaveSettingB,
  SaveSettingC,
  SaveSettingD,
  LoadSettingA,
  LoadSettingB,
  LoadSettingC,
  LoadSettingD,
  LoadSettingE,

  SendUpdateMessageToSharpBar,

  SendMessageTo,

  SharpExecute,
  ClearKey,
  LoadColorScheme,
  LoadColorSchemeEx,
  SaveColorScheme,
  SaveColorSchemeEx;

begin


end.

