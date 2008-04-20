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

library SharpCenterAPI;

{$WARN UNIT_PLATFORM OFF}
{$WARN SYMBOL_PLATFORM OFF}

uses
  windows,
  messages,
  SysUtils,
  shellAPI,
  JvSimpleXml,
  JclSysInfo,
  SharpApi;

{$R *.RES}

var
  wpara: wparam;
  lpara: lparam;

{EXPORTED FUNTIONS}

function BroadcastCenterMessage(wpar: wparam; lpar: lparam): boolean;
var
  wnd: hWnd;
  MutexHandle: THandle;
begin
  Result := False;
  wpara := wpar;
  lpara := lpar;

  MuteXHandle := OpenMutex(MUTEX_ALL_ACCESS, False, 'SharpCenterMutexX');
  if MuteXHandle <> 0 then
  begin

      //Find the window
    wnd := FindWindow('TSharpCenterWnd', nil);
    if wnd <> 0 then
    begin
      Result := True;
      PostMessage(wnd, WM_SHARPCENTERMESSAGE, wpara, lpara);
    end else
      Result := False;
    CloseHandle(MuteXHandle);
  end
end;

function CenterCommand(ACommand: TSCC_COMMAND_ENUM; AParam, APluginID: PChar): hresult;
var
  cds: TCopyDataStruct;
  wnd: hWnd;
  msg: TSharpE_DataStruct;
  path: string;
  MutexHandle: THandle;

  sCommand: string;
begin
  Result := 0;
  wnd := 0;

  case ACommand of
    sccLoadSetting: sCommand := SCC_LOAD_SETTING;
    sccChangeFolder: sCommand := SCC_CHANGE_FOLDER;
    sccUnloadDll: sCommand := SCC_UNLOAD_DLL;
    sccLoadDll: sCommand := SCC_LOAD_DLL;
  else
    sCommand := '';
  end;

  // Check valid command
  if sCommand = '' then begin
    SendDebugMessageEx('SharpApi', pchar(format('Config Msg Invalid: %s',
      [sCommand])), 0, DMT_INFO);
    exit;
  end;

  try

    SendDebugMessageEx('SharpApi', pchar(format('Config Msg Received: %s - %s',
      [sCommand, AParam])), 0, DMT_INFO);
    msg.Parameter := AParam;
    msg.Command := sCommand;
    msg.PluginID := APluginID;

    with cds do
    begin
      dwData := 0;
      cbData := SizeOf(TSharpE_DataStruct);
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
          pchar(format('SharpCenter Mutex Exists, Sending Msg: %s - %s',
          [sCommand, AParam])),
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
          pchar(format('SharpCenter Mutex not found, Launching file: %s', [Path
          +
            'SharpCenter.exe'])), 0, DMT_STATUS);
        ShellExecute(wnd, 'open', pchar(Path + 'SharpCenter.exe'), Pchar('-api '
          +
          IntToStr(Integer(ACommand)) + '|' + AParam + '|' + APluginID),
          pchar(path), SW_SHOWNORMAL);

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

function BroadcastGlobalUpdateMessage(AUpdateType: TSU_UPDATE_ENUM;
  APluginID: Integer = -1; ASendMessage: boolean = False): boolean;
begin
  Result := True;
  SharpEBroadCast(WM_SHARPEUPDATESETTINGS, Integer(AUpdateType), APluginID, ASendMessage);
end;

function CenterDefineEditState(AEditing: Boolean): boolean;
begin
  if AEditing then
    Result := BroadcastCenterMessage(SCM_SET_EDIT_STATE, 0) else
    Result := BroadcastCenterMessage(SCM_SET_EDIT_CANCEL_STATE, 0);
end;

function CenterDefineButtonState(AButton: TSCB_BUTTON_ENUM; AEnabled: Boolean): boolean;
begin
  if AEnabled then
    Result := BroadcastCenterMessage(SCM_SET_BUTTON_ENABLED, Integer(AButton)) else
    Result := BroadcastCenterMessage(SCM_SET_BUTTON_DISABLED, Integer(AButton));
end;

function CenterDefineSettingsChanged: boolean;
begin
  Result := BroadcastCenterMessage(SCM_SET_SETTINGS_CHANGED, 0);
end;

function CenterSelectEditTab(AEditTab: TSCB_BUTTON_ENUM): boolean;
begin
  Result := False;
  case AEditTab of
    scbAddTab, scbEditTab, scbDeleteTab:
      Result := BroadcastCenterMessage(SCM_SET_TAB_SELECTED, integer(AEditTab));
  end;
end;

function CenterUpdatePreview: boolean;
begin
  Result := BroadcastCenterMessage(SCM_EVT_UPDATE_PREVIEW, 0);
end;

function CenterUpdateSettings: boolean;
begin
  Result := BroadcastCenterMessage(SCM_EVT_UPDATE_SETTINGS, 0);
end;

function CenterUpdateSize: boolean;
begin
  Result := BroadcastCenterMessage(SCM_EVT_UPDATE_SIZE, 0);
end;

function CenterUpdateTabs: boolean;
begin
  Result := BroadcastCenterMessage(SCM_EVT_UPDATE_TABS, 0);
end;

function CenterUpdateConfigText: boolean;
begin
  Result := BroadcastCenterMessage(SCM_EVT_UPDATE_CONFIG_TEXT, 0);
end;

procedure CenterUpdateConfigFull;
begin
  CenterUpdatePreview;
  CenterUpdateSize;
  CenterUpdateTabs;
  CenterUpdateConfigText;
end;

procedure CenterUpdateEditTabs(AItemCount: Integer; AItemIndex: Integer);

  procedure BC(AEnabled: Boolean; AButton: TSCB_BUTTON_ENUM);
  begin
    if AEnabled then
      CenterDefineButtonState(AButton, True)
    else
      CenterDefineButtonState(AButton, False);
  end;

begin
  if ((AItemCount = 0) or (AItemIndex = -1)) then begin
    BC(False, scbEditTab);

    if (AItemCount = 0) then begin
      BC(False, scbDeleteTab);
      CenterSelectEditTab(scbAddTab);
    end;

    BC(True, scbAddTab);

  end
  else begin
    BC(True, scbAddTab);
    BC(True, scbEditTab);
  end;
end;

function CenterCommandAsText(ACommand: TSCC_COMMAND_ENUM): string;
begin
  if ACommand = sccLoadSetting then result := SCC_LOAD_SETTING else
    if ACommand = sccChangeFolder then result := SCC_CHANGE_FOLDER else
      if ACommand = sccUnloadDll then result := SCC_UNLOAD_DLL else
        if ACommand = sccLoadDll then result := SCC_LOAD_DLL;
end;

function CenterCommandAsEnum(ACommand: string): TSCC_COMMAND_ENUM;
begin
  Result := sccLoadSetting;

  if CompareText(ACommand, SCC_LOAD_SETTING) = 0 then
    result := sccLoadSetting else
    if CompareText(ACommand, SCC_CHANGE_FOLDER) = 0 then
      result := sccChangeFolder else
      if CompareText(ACommand, SCC_UNLOAD_DLL) = 0 then
        result := sccUnloadDll else
        if CompareText(ACommand, SCC_LOAD_DLL) = 0 then
          result := sccLoadDll;
end;

procedure CenterReadDefaults(var AFields: TSC_DEFAULT_FIELDS);
var
  xml: TJvSimpleXml;
  sFile: string;
begin
  AFields.Author := GetLocalUserName;
  AFields.Website := '';

  sFile := GetSharpeUserSettingsPath + 'SharpCenter\defaults.xml';
  if fileExists(sFile) then begin

    xml := TJvSimpleXML.Create(nil);
    try
      xml.LoadFromFile(sFile);
      AFields.Author := xml.Root.Items.Value('Author', '');
      AFields.Website := xml.Root.Items.Value('Website', '');
    finally
      xml.Free;
    end;
  end;
end;

procedure CenterWriteDefaults(var AFields: TSC_DEFAULT_FIELDS);
var
  xml: TJvSimpleXml;
  sFile: string;
begin
  sFile := GetSharpeUserSettingsPath + 'SharpCenter\defaults.xml';
  ForceDirectories(ExtractFilePath(sFile));

  xml := TJvSimpleXML.Create(nil);
  try
    xml.Root.Name := 'Defaults';
    xml.Root.Items.Add('Author', AFields.Author);
    xml.Root.Items.Add('Website', AFields.Website);
  finally
    xml.SaveToFile(sFile);
    xml.Free;
  end;
end;

exports
  BroadcastGlobalUpdateMessage,
  BroadcastCenterMessage,
  CenterCommand,
  CenterDefineEditState,
  CenterDefineButtonState,
  CenterDefineSettingsChanged,
  CenterSelectEditTab,
  CenterUpdatePreview,
  CenterUpdateSettings,
  CenterUpdateSize,
  CenterUpdateTabs,
  CenterUpdateConfigText,
  CenterUpdateConfigFull,
  CenterUpdateEditTabs,
  CenterCommandAsText,
  CenterCommandAsEnum,
  CenterReadDefaults,
  CenterWriteDefaults;
begin

end.

