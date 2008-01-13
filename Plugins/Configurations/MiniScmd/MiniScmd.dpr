{
Source Name: MiniScmd
Description: MiniScmd Module Config Dll
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

library MiniScmd;
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
  uMiniScmdWnd in 'uMiniScmdWnd.pas' {frmMiniScmd},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
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
  if frmMiniScmd = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'MiniScmdModuleSettings';    
  with XML.Root.Items, frmMiniScmd do
  begin
    Add('Width',sgb_width.Value);
    Add('Button',cb_quickselect.Checked);
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmMiniScmd.sBarID),strtoint(frmMiniScmd.sModuleID)));
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
begin
  if frmMiniScmd = nil then frmMiniScmd := TfrmMiniScmd.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmMiniScmd);
  frmMiniScmd.sBarID := left;
  frmMiniScmd.sModuleID := right;
  frmMiniScmd.ParentWindow := aowner;
  frmMiniScmd.Left := 2;
  frmMiniScmd.Top := 2;
  frmMiniScmd.BorderStyle := bsNone;
  result := frmMiniScmd.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmMiniScmd do
    begin
      sgb_width.Value := IntValue('Width',100);
      cb_quickselect.Checked := BoolValue('Button',True);
    end;
  XML.Free;

  frmMiniScmd.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmMiniScmd.Close;
    frmMiniScmd.Free;
    frmMiniScmd := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Mini SCmd';
  ATitle := 'Mini SCmd Module';
  ADescription := 'Configure Mini SCmd module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Mini SCmd';
    Description := 'Mini SCmd Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

exports
  Open,
  Close,
  Save,
  GetMetaData,
  SetText;

end.

