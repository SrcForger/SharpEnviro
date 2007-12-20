{
Source Name: KeyboardLayout.dpr
Description: Keyboard Layout Module Config Dll
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

library KeyboardLayout;
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
  uKLayoutWnd in 'uKLayoutWnd.pas' {frmKLayout},
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
  if frmKLayout = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'KeyboardLayoutModuleSettings';
  with XML.Root.Items, frmKLayout do
  begin
    Add('ShowIcon',cbIcon.Checked);
    Add('ThreeLetterCode',cbTLC.Checked);
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmKLayout.sBarID),strtoint(frmKLayout.sModuleID)));
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
begin
  if frmKLayout = nil then frmKLayout := TfrmKLayout.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmKLayout);
  frmKLayout.sBarID := left;
  frmKLayout.sModuleID := right;
  frmKLayout.ParentWindow := aowner;
  frmKLayout.Left := 2;
  frmKLayout.Top := 2;
  frmKLayout.BorderStyle := bsNone;
  result := frmKLayout.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmKLayout do
    begin
      cbIcon.Checked := BoolValue('ShowIcon',cbIcon.Checked);
      cbTLC.Checked  := BoolValue('ThreeLetterCode',cbTLC.Checked);
    end;
  XML.Free;

  frmKLayout.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmKLayout.Close;
    frmKLayout.Free;
    frmKLayout := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Keyboard Layout';
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  result := suModule;
end;


exports
  Open,
  Close,
  Save,
  SetText,
  SetSettingType;

begin
end.

