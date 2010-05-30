{
Source Name: uHotkeyServiceMain
Description: Hotkey Main Class
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

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

unit uHotkeyServiceMain;

interface

uses
  // General
  Windows,
  SysUtils,
  Controls,
  Forms,
  Messages,
  shellAPI,
  Classes,
  Dialogs,

  // Common
  sharpapi,
  uScHotkeyMgr,

  // Project
  uHotkeyServiceList,
  uHotkeyServiceGeneral;

type
  THotkeyService = class
  private
    FHotkeyManager: TScHotkeyManager;
    FHotkeyList: THotkeyList;
    procedure HotkeyEvent(Sender: TObject; HotkeyID: Integer);
  public
    procedure AddHotkeys(RegisterKey: Boolean = True);
    procedure UnregisterAllKeys;
    procedure RegisterAllKeys;

    property HotkeyManager: TScHotkeyManager read FHotkeyManager write FHotkeyManager;
    property HotkeyList: THotkeyList read FHotkeyList write FHotkeyList;

    constructor Create;
    destructor Destroy; override;
    procedure MessageHandler(var Message: TMessage);
  end;

var
  HKService: THotkeyService;
  h: THandle;
const
  cSettingsLocation = 'SharpCore\Services\Hotkeys\Hotkeys.xml';

implementation

{ THotkeyService }

procedure THotkeyService.AddHotkeys(RegisterKey: Boolean = True);
var
  fn: string;
  i: integer;
  NewKey: string;
  NewModifier: TScModifier;
begin
  // Unregister all keys
  UnregisterAllKeys;

  // Load Hotkey List
  fn := GetSharpeUserSettingsPath + cSettingsLocation;
  If Not(Assigned(FHotkeyList)) Then
    FHotkeyList := THotkeyList.Create;
  FHotkeyList.FileName := fn;
  FHotkeyList.Load;

  // Add Hotkeys to Manager
  Debug(Format('Hotkey data Items: %d',[FHotkeyList.Count]),DMT_STATUS);
  for i := 0 to Pred(FHotkeyList.Count) do begin

    with FHotkeyList.HotkeyItem[i], HotkeyManager do begin

      ConvertToKeyModifier(Hotkey, NewModifier, NewKey);
      Debug(Format('KeyStr: %s >> %s',[Hotkey,GetKeyModifierAsStr(NewModifier,NewKey)]),DMT_STATUS);

      FHotkeyManager.Add(Format('Hotkey%d', [i]), Command, NewModifier, NewKey);
    end;
  end;

  // Register them
  RegisterAllKeys;
end;

constructor THotkeyService.Create;
begin
  inherited Create;

  // Create Hotkey Manager
  FHotkeyManager := TScHotkeyManager.Create;
  FHotkeyManager.OnHotkeyEvent := HotkeyEvent;

end;

destructor THotkeyService.Destroy;
begin
  Debug('THotkeyService Destructor', DMT_INFO);

  // If Hotkey List Assigned then attempt to free
  try
    if Assigned(FHotkeyList) then
      FreeAndNil(FHotkeyList);
  except
    on E: Exception do begin
      Debug('Error Freeing FHotkeyList', DMT_ERROR);
      Debug(E.Message, DMT_ERROR);
    end;
  end;

  // If Hotkey Manager Assigned then attempt to free
  try
    if Assigned(FHotkeyManager) then
      FreeAndNil(FHotkeyManager);
  except
    on E: Exception do begin
      Debug('Error Freeing FHotkeyManager', DMT_ERROR);
      Debug(E.Message, DMT_ERROR);
    end;
  end;
end;

procedure THotkeyService.HotkeyEvent(Sender: TObject; HotkeyID: Integer);
begin
  Debug('Hotkey: ' + HotkeyManager.Info[HotkeyID].Command, DMT_INFO);
  SharpExecute(HotkeyManager.Info[HotkeyID].Command);
end;

procedure THotkeyService.MessageHandler(var Message: TMessage);
begin
  if (message.Msg = WM_SHARPEUPDATESETTINGS) and (message.WParam = Integer(suHotkey)) then begin
    HKService.UnregisterAllKeys;
    FreeAndNil(HKService);
    HKService := THotkeyService.Create;
    HKService.AddHotkeys(True);

    Debug('WM_SHARPEUPDATESETTINGS',DMT_INFO);
  end else message.Result := DefWindowProc(h,message.Msg,message.WParam,message.LParam);
end;

procedure THotkeyService.RegisterAllKeys;
var
  i: integer;
begin
  with FHotkeyManager do begin
    for i := 0 to Count - 1 do begin
      RegisterKey(i);
    end;
  end;
end;

procedure THotkeyService.UnregisterAllKeys;
var
  I: integer;
begin
  // If there are no hotkeys do not attempt to unregister
  If FHotkeyManager.Count = 0 then begin
    Debug('No Hotkeys Managed', DMT_STATUS);
    exit;
  End;

  Debug(Format('Unregister %d Hotkeys', [FHotkeyManager.Count]), DMT_INFO);
  if Assigned(FHotkeyManager) then begin

    with FHotkeyManager do begin

      for I := Count-1 downto 0 do begin
        UnRegisterKey(I);
        Delete(I);
      end;
    end;
  end
  else
    Debug('FHotkeyManager Not Assigned', DMT_STATUS);
end;

end.

