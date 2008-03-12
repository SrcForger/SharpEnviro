{
Source Name: VWM.dpr
Description: VWM Service Config DLL
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

library VWMService;
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
  uVWMServiceSettingsWnd in 'uVWMServiceSettingsWnd.pas' {frmVWMSettings},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}


function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJclSimpleXML;
  Dir,FName : String;
  fileloaded : boolean;
begin
  if frmVWMSettings = nil then frmVWMSettings := TfrmVWMSettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmVWMSettings);
  frmVWMSettings.ParentWindow := aowner;
  frmVWMSettings.Left := 0;
  frmVWMSettings.Top := 0;
  frmVWMSettings.BorderStyle := bsNone;

  Dir := GetSharpeUserSettingsPath + 'SharpCore\Services\VWM\';
  FName := Dir + 'VWM.xml';
  if FileExists(FName) then
  begin
    XML := TJclSimpleXML.Create;
    try
      XML.LoadFromFile(FName);
      fileloaded := True;
    except
      fileloaded := False;
    end;
    if FileLoaded then
    begin
      frmVWMSettings.sgb_vwmcount.Value := XML.Root.Items.IntValue('VWMCount',4);
      frmVWMSettings.cb_focustopmost.Checked := XML.Root.Items.BoolValue('FocusTopMost',False);
      frmVWMSettings.cb_followfocus.Checked := XML.Root.Items.BoolValue('FollowFocus',False);
      frmVWMSettings.cb_ocd.Checked := XML.Root.Items.BoolValue('ShowOCD',False);      
    end;
    XML.Free;
  end;

  frmVWMSettings.Show;
  result := frmVWMSettings.Handle;
end;

procedure Save;
var
  XML : TJclSimpleXML;
  Dir,FName : String;
begin
  Dir := GetSharpeUserSettingsPath + 'SharpCore\Services\VWM\';
  FName := Dir + 'VWM.xml';
  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);
  XML := TJclSimpleXML.Create;
  XML.Root.Name := 'VWMServiceSettings';
  XML.Root.Items.Add('VWMCount',frmVWMSettings.sgb_vwmcount.Value);
  XML.Root.Items.Add('FocusTopMost',frmVWMSettings.cb_focustopmost.Checked);
  XML.Root.Items.Add('FollowFocus',frmVWMSettings.cb_followfocus.Checked);
  XML.Root.Items.Add('ShowOCD',frmVWMSettings.cb_ocd.Checked);
  XML.SaveToFile(FName);
  XML.Free;
end;

function Close : boolean;
begin
  result := True;
  try
    frmVWMSettings.Close;
    frmVWMSettings.Free;
    frmVWMSettings := nil;
  except
    result := False;
  end;
end;


procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'VWM';
  ATitle := 'Virtual Window Management Configuration';
  ADescription := 'Define how many you require, and advanced configuration options.';

end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'VWM';
    Description := 'VWM Service Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suVWM)]);
  end;
end;

exports
  Open,
  Close,
  Save,
  SetText,
  GetMetaData;

begin
end.

