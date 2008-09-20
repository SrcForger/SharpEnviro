{
Source Name: BatteryMonitor
Description: BatteryMonitor Module Config Dll
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

library BatteryMonitor;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvSimpleXml,
  GR32,
  GR32_Image,
  PngSpeedButton,
  JvPageList,
  uVistaFuncs,
  SysUtils,
  Graphics,
  StdCtrls,
  SharpECenterHeader,
  JvXPCheckCtrls,
  uBatteryMonitorWnd in 'uBatteryMonitorWnd.pas' {frmBMon},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  SharpThemeApi in '..\..\..\Common\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpDialogs in '..\..\..\Common\Libraries\SharpDialogs\SharpDialogs.pas',
  uSharpBarAPI in '..\..\..\Components\SharpBar\uSharpBarAPI.pas';

{$E .dll}

{$R *.res}

procedure Save;
var
  XML : TJvSimpleXML;
begin
  if frmBMon = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmBMon.sBarID),strtoint(frmBMon.sModuleID)));
  except
    XML.Root.Clear;
  end;

  XML.Root.Name := 'BatteryMonitorModuleSettings';
  with XML.Root.Items, frmBMon do
  begin
    if ItemNamed['showicon'] <> nil then
      ItemNamed['showicon'].BoolValue := cb_icon.Checked
    else Add('showicon',cb_icon.Checked);
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmBMon.sBarID),strtoint(frmBMon.sModuleID)));
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
begin
  if frmBMon = nil then frmBMon := TfrmBMon.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmBMon);
  frmBMon.sBarID := left;
  frmBMon.sModuleID := right;
  frmBMon.ParentWindow := aowner;
  frmBMon.Left := 2;
  frmBMon.Top := 2;
  frmBMon.BorderStyle := bsNone;
  result := frmBMon.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmBMon do
    begin
      cb_icon.Checked := BoolValue('showicon',True);
    end;
  XML.Free;

  frmBMon.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmBMon.Close;
    frmBMon.Free;
    frmBMon := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ADescription: String);
begin
  AName := 'Battery Monitor';
  ADescription := 'The battery monitor module displays laptop status';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Battery Monitor';
    Description := 'Battery Monitor Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.5.2';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure GetCenterTheme(const ATheme: TCenterThemeInfo; const AEdit: Boolean);
var
  i: integer;
begin
  AssignThemeToForm(ATheme,frmBMon);
end;

exports
  Open,
  Close,
  Save,
  SetText,
  GetMetaData,
  GetCenterTheme;

end.

