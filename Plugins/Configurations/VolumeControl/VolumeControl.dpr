{
Source Name: VolumeControl.dpr
Description: VolumeControl Module Config DLL
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

library VolumeControl;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  JvPageList,
  Graphics,
  MMSystem,
  uVolumeControlWnd in 'uVolumeControlWnd.pas' {frmVolumeControl},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SoundControls in '..\..\Modules\VolumeControl\SoundControls.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas';

{$E .dll}

{$R *.res}


function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJclSimpleXML;
  fileloaded : boolean;
  left,right : String;
  s : string;
  n,i : integer;
begin
  if frmVolumeControl = nil then frmVolumeControl := TfrmVolumeControl.Create(nil);

  uVistaFuncs.SetVistaFonts(frmVolumeControl);
  frmVolumeControl.ParentWindow := aowner;
  frmVolumeControl.Left := 0;
  frmVolumeControl.Top := 0;
  frmVolumeControl.BorderStyle := bsNone;

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));

  frmVolumeControl.sBarID := left;
  frmVolumeControl.sModuleID := right;

  XML := TJclSimpleXML.Create;
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  frmVolumeControl.BuildMixerList;
  if fileloaded then
    with XML.Root.Items, frmVolumeControl do
    begin
      sgb_Width.Value := IntValue('Width',75);
      i := IntValue('Mixer',MIXERLINE_COMPONENTTYPE_DST_SPEAKERS);
      for n := 0 to IDList.Count -1 do
      if strtoint(IDList[n]) = i then
      begin
        cb_mlist.ItemIndex := n;
        break;
      end;
    end;

  XML.Free;
  frmVolumeControl.Show;
  result := frmVolumeControl.Handle;
end;

procedure Save;
var
  XML : TJclSimpleXML;
begin
  if frmVolumeControl = nil then
    exit;

  XML := TJclSimpleXML.Create;
  XML.Root.Clear;

  XML.Root.Name := 'VolumeControlModuleSettings';
  with XML.Root.Items, frmVolumeControl do
  begin
    if IDList.Count = 0 then Add('Mixer',0)
      else Add('Mixer',IDList[cb_mlist.ItemIndex]);
    Add('Width',sgb_Width.Value);
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmVolumeControl.sBarID),strtoint(frmVolumeControl.sModuleID)));
  XML.Free;
end;

function Close : boolean;
begin
  result := True;
  try
    frmVolumeControl.Close;
    frmVolumeControl.Free;
    frmVolumeControl := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: String; var ADisplayText: String);
begin
  ADisplayText := PChar('Volume Control');
end;

procedure SetStatusText(const APluginID: String; var AStatusText: string);
begin
  AStatusText := '';
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure ClickTab(ATab: TPluginTabItem);
begin
  TJvStandardPage(ATab.Data).Show;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  if frmVolumeControl <> nil then
  begin
    ATabs.Add('Volume Control',frmVolumeControl.JvSettingsPage,'','');
  end;
end;

function SetSettingType : TSU_UPDATE_ENUM;
begin
  result := suModule;
end;


exports
  Open,
  Close,
  Save,
  SetDisplayText,
  SetStatusText,
  SetBtnState,
  SetSettingType,
  GetCenterScheme,
  AddTabs,
  ClickTab;

begin
end.

