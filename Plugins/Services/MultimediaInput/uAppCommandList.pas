{
Source Name: uAppCommandList.pas
Description: Define actions for each WM_APPCOMMAND message
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

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

unit uAppCommandList;

interface

uses
  Windows,SysUtils,Graphics,Contnrs;

type
  TAppCommandAction = (acaNothing,acaBroadcastMediaCommand,acaSharpExecute,
                       acaVolumeSpeakerUp,acaVolumeSpeakerDown,acaVolumeSpeakerMute,
                       acaVolumeMicUp,acaVolumeMicDown,acaVolumeMicMute,
                       acaExecuteBrowser,acaExecuteMail);

  TAppCommandItem = class
  private                 
    FName : String;
    FMessageID : integer;
    FAction : TAppCommandAction;
    FActionStr : String;
    FDisableWMC : boolean;
  public
    property Name : String read FName write FName;
    property MessageID : integer read FMessageID write FMessageID;
    property Action : TAppCommandAction read FAction write FAction;
    property ActionStr : String read FActionStr write FActionStr;
    property DisableWMC : boolean read FDisableWMC write FDisableWMC;
  end;

  TAppCommandList = class
  private
    FItems : TObjectList;
  public
    constructor Create; reintroduce;
    destructor Destroy; override;

    procedure InitList;
    procedure LoadSettings;
    procedure SaveSettings;
    function FindItem(MessageID : integer) : TAppCommandItem;

    class function ActionToString(Action : TAppCommandAction) : String;

    property Items : TObjectList read FItems;
  end;

const
  sAppCommandListSettingsDir = 'SharpCore\Services\MultimediaInput\';
  sAppCommandListSettingsFile = 'AppCommandList.xml';

implementation

uses
  JclSimpleXML,
  SharpApi,
  uSharpXMlUtils;

{ TAppCommandList }

class function TAppCommandList.ActionToString(Action: TAppCommandAction): String;
begin
  case Action of
    acaNothing: result := 'No Action';
    acaBroadcastMediaCommand: result := 'Broadcast as Media Message';
    acaSharpExecute: result := 'Execute';
    acaVolumeSpeakerUp: result := 'Speaker Volume Up';
    acaVolumeSpeakerDown: result := 'Speaker Volume Down';
    acaVolumeSpeakerMute: result := 'Mute Speaker';
    acaVolumeMicUp: result := 'Microphone Volume Up';
    acaVolumeMicDown: result := 'Microphone Volume Down';
    acaVolumeMicMute: result := 'Mute Microphone';
    acaExecuteBrowser: result := 'Execute Default Browser';
    acaExecuteMail: result := 'Execute Default Mail Application';
  end;
end;

constructor TAppCommandList.Create;
begin
  inherited Create;

  FItems := TObjectList.Create(True);
  InitList;
  LoadSettings;
end;

destructor TAppCommandList.Destroy;
begin
  FItems.Free;

  inherited Destroy;
end;

function TAppCommandList.FindItem(MessageID: integer): TAppCommandItem;
var
  n : integer;
begin
  result := nil;
  for n := 0 to FItems.Count - 1 do
    if TAppCommandItem(FItems.Items[n]).MessageID = MessageID then
    begin
      result := TAppCommandItem(Fitems.Items[n]);
      break;
    end;
end;

procedure TAppCommandList.InitList;

  procedure AddItem(Name : String; ID : integer; Action : TAppCommandAction; ActionStr : String; DisableWMC : boolean); overload;
  var
    item : TAppCommandItem;
  begin
    item := TAppCommandItem.Create;
    item.Name := Name;
    item.MessageID := ID;
    item.Action := Action;
    item.ActionStr := ActionStr;
    item.DisableWMC := DisableWMC;
    FItems.Add(item);
  end;

  procedure AddItem(Name : String; ID : integer); overload;
  begin
    AddItem(Name,ID,acaNothing,'',False);
  end;  

begin
  FItems.Clear;
  AddItem('BASS_BOOST',APPCOMMAND_BASS_BOOST);
  AddItem('BASS_DOWN',APPCOMMAND_BASS_DOWN);
  AddItem('BASS_UP',APPCOMMAND_BASS_UP);
  AddItem('BROWSER_BACKWARD',APPCOMMAND_BROWSER_BACKWARD);
  AddItem('BROWSER_FAVORITES',APPCOMMAND_BROWSER_FAVORITES);
  AddItem('BROWSER_FORWARD',APPCOMMAND_BROWSER_FORWARD);
  AddItem('BROWSER_HOME',APPCOMMAND_BROWSER_HOME,acaExecuteBrowser,'',False);
  AddItem('BROWSER_REFRESH',APPCOMMAND_BROWSER_REFRESH);
  AddItem('BROWSER_STOP',APPCOMMAND_BROWSER_STOP);
  AddItem('BROWSER_SEARCH',APPCOMMAND_BROWSER_SEARCH);
  AddItem('CLOSE',APPCOMMAND_CLOSE);
  AddItem('COPY',APPCOMMAND_COPY);
  AddItem('CORRECTION_LIST',APPCOMMAND_CORRECTION_LIST);  
  AddItem('CUT',APPCOMMAND_CUT);
  AddItem('DELETE',APPCOMMAND_DELETE);
  AddItem('DICTATE_OR_COMMAND_CONTROL_TOGGLE',APPCOMMAND_DICTATE_OR_COMMAND_CONTROL_TOGGLE);
  AddItem('DWM_FLIP3D',APPCOMMAND_DWM_FLIP3D);
  AddItem('FIND',APPCOMMAND_FIND);
  AddItem('HELP',APPCOMMAND_HELP);
  AddItem('LAUNCH_APP1',APPCOMMAND_LAUNCH_APP1);
  AddItem('LAUNCH_APP2',APPCOMMAND_LAUNCH_APP2);
  AddItem('LAUNCH_MAIL',APPCOMMAND_LAUNCH_MAIL,acaExecuteMail,'',False);
  AddItem('LAUNCH_MEDIA_SELECT',APPCOMMAND_LAUNCH_MEDIA_SELECT);
  AddItem('MAIL_REPLY',APPCOMMAND_REPLY_TO_MAIL);
  AddItem('MAIL_FORWARD',APPCOMMAND_FORWARD_MAIL);
  AddItem('MAIL_SEND',APPCOMMAND_SEND_MAIL);
  AddItem('MEDIA_CHANNEL_DOWN',APPCOMMAND_MEDIA_CHANNEL_DOWN);
  AddItem('MEDIA_CHANNEL_UP',APPCOMMAND_MEDIA_CHANNEL_UP);
  AddItem('MEDIA_FAST_FORWARD',APPCOMMAND_MEDIA_FAST_FORWARD);
  AddItem('MEDIA_NEXTTRACK',APPCOMMAND_MEDIA_NEXTTRACK,acaBroadcastMediaCommand,'',True);
  AddItem('MEDIA_PAUSE',APPCOMMAND_MEDIA_PAUSE,acaBroadcastMediaCommand,'',True);
  AddItem('MEDIA_PLAY',APPCOMMAND_MEDIA_PLAY,acaBroadcastMediaCommand,'',True);
  AddItem('MEDIA_PLAY_PAUSE',APPCOMMAND_MEDIA_PLAY_PAUSE,acaBroadcastMediaCommand,'',True);
  AddItem('MEDIA_PREVIOUSTRACK',APPCOMMAND_MEDIA_PREVIOUSTRACK,acaBroadcastMediaCommand,'',True);
  AddItem('MEDIA_RECORD',APPCOMMAND_MEDIA_RECORD);
  AddItem('MEDIA_REWIND',APPCOMMAND_MEDIA_REWIND);
  AddItem('MEDIA_STOP',APPCOMMAND_MEDIA_STOP,acaBroadcastMediaCommand,'',True);
  AddItem('MICROPHONE_ON_OFF_TOGGLE',APPCOMMAND_MIC_ON_OFF_TOGGLE,acaVolumeMicMute,'',False);
  AddItem('MICROPHONE_VOLUME_DOWN',APPCOMMAND_MICROPHONE_VOLUME_DOWN,acaVolumeMicDown,'',False);
  AddItem('MICROPHONE_VOLUME_MUTE',APPCOMMAND_MICROPHONE_VOLUME_MUTE,acaVolumeMicMute,'',False);
  AddItem('MICROPHONE_VOLUME_UP',APPCOMMAND_MICROPHONE_VOLUME_UP,acaVolumeMicUp,'',False);
  AddItem('NEW',APPCOMMAND_NEW);
  AddItem('OPEN',APPCOMMAND_OPEN);
  AddItem('PASTE',APPCOMMAND_PASTE);
  AddItem('PRINT',APPCOMMAND_PRINT);
  AddItem('REDO',APPCOMMAND_REDO);
  AddItem('SAVE',APPCOMMAND_SAVE);
  AddItem('SPELL_CHECK',APPCOMMAND_SPELL_CHECK);
  AddItem('TREBLE_DOWN',APPCOMMAND_TREBLE_DOWN);
  AddItem('TREBLE_UP',APPCOMMAND_TREBLE_UP);
  AddItem('UNDO',APPCOMMAND_UNDO);
  AddItem('VOLUME_DOWN',APPCOMMAND_VOLUME_DOWN,acaVolumeSpeakerDown,'',True);
  AddItem('VOLUME_MUTE',APPCOMMAND_VOLUME_MUTE,acaVolumeSpeakerMute,'',True);
  AddItem('VOLUME_UP',APPCOMMAND_VOLUME_UP,acaVolumeSpeakerUp,'',True);
end;

procedure TAppCommandList.LoadSettings;
var
  XML : TJclSimpleXML;
  item : TAppCommandItem;
  n : integer;
begin
  XML := TJclSimpleXML.Create;

  if LoadXMLFromSharedFile(XML,
                           SharpApi.GetSharpeUserSettingsPath + sAppCommandListSettingsDir + sAppCommandListSettingsFile,
                           True) then
  begin
    for n := 0 to XML.Root.Items.Count - 1 do
    with XML.Root.Items.Item[n] do
    begin
      item := FindItem(Properties.IntValue('ID',-1));
      if item <> nil then
      begin
        item.Action := TAppCommandAction(Properties.IntValue('Action',Integer(acaNothing)));
        item.ActionStr := Properties.Value('ActionStr','');
        item.DisableWMC := Properties.BoolValue('DisableWMC',False);
      end;
    end
  end else SendDebugMessageEx('MultimediaInput',
                              PChar('Failed to load settings from File: ' + SharpApi.GetSharpeUserSettingsPath + sAppCommandListSettingsDir + sAppCommandListSettingsFile),
                              clred,
                              DMT_ERROR);
  XMl.Free;
end;

procedure TAppCommandList.SaveSettings;
var
  XML : TJclSimpleXML;
  n: Integer;
  item : TAppCommandItem;
begin
  XML := TJclSimpleXML.Create;
  XML.Root.Name := 'AppCommandList';
  for n := 0 to FItems.Count - 1 do
  begin
    item := TAppCommandItem(FItems.Items[n]);
    if (item.Action <> acaNothing) then
      with XML.Root.Items.Add('AppCommand') do
      begin
        Properties.Add('ID',item.MessageID);
        Properties.Add('Action',Integer(item.Action));
        Properties.Add('ActionStr',item.ActionStr);
        Properties.Add('DisableWMC',item.DisableWMC);
      end;
  end;
  ForceDirectories(SharpApi.GetSharpeUserSettingsPath + sAppCommandListSettingsDir);
  if not SaveXMLToSharedFile(XML,
                             SharpApi.GetSharpeUserSettingsPath + sAppCommandListSettingsDir + sAppCommandListSettingsFile,
                             True) then
    SendDebugMessageEx('MultimediaInput',
                       PChar('Failed to save settings to File: ' + SharpApi.GetSharpeUserSettingsPath + sAppCommandListSettingsDir + sAppCommandListSettingsFile),
                       clred,
                       DMT_ERROR);
  XML.Free;
end;

end.
