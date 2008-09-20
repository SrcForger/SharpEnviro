{
Source Name: ButtonBarModuleOptions.dpr
Description: ButtonBar Module Options Config
Copyright (C) Lee Green (lee@sharpenviro.com)

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

library ButtonBarModuleOptions;
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
  SettingsWnd in 'SettingsWnd.pas' {frmSettings},
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
  if frmSettings = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmSettings.sBarID),strtoint(frmSettings.sModuleID)));
  except
    XML.Root.Clear;
  end;

  XML.Root.Name := 'ButtonBarModuleSettings';
  with XML.Root.Items, frmSettings do
  begin
    if ItemNamed['ShowCaption'] <> nil then
      ItemNamed['ShowCaption'].BoolValue := chkButtonCaption.Checked
    else Add('ShowCaption',chkButtonCaption.Checked);

    if ItemNamed['ShowIcon'] <> nil then
      ItemNamed['ShowIcon'].BoolValue := chkButtonIcon.Checked
    else Add('ShowIcon',chkButtonIcon.Checked);

    if ItemNamed['Width'] <> nil then
      ItemNamed['Width'].IntValue := sgbWidth.Value
    else Add('Width',sgbWidth.Value);
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmSettings.sBarID),strtoint(frmSettings.sModuleID)));
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
begin
  if frmSettings = nil then frmSettings := TfrmSettings.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmSettings);
  frmSettings.sBarID := left;
  frmSettings.sModuleID := right;
  frmSettings.ParentWindow := aowner;
  frmSettings.Left := 2;
  frmSettings.Top := 2;
  frmSettings.BorderStyle := bsNone;
  result := frmSettings.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmSettings do
    begin
      chkButtonCaption.Checked := BoolValue('ShowCaption',False);
      chkButtonIcon.Checked := BoolValue('ShowIcon',False);
      sgbWidth.Value := IntValue('Width',25);
    end;
  XML.Free;

  frmSettings.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmSettings.Close;
    frmSettings.Free;
    frmSettings := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ADescription: String);
begin
  AName := 'Module Options';
  ADescription := 'Configure global options for the button bar module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'ButtonBarModuleOptions';
    Description := 'ButtonBar Module Options Config';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.5.2';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

procedure GetCenterTheme(const ATheme: TCenterThemeInfo; const AEdit: Boolean);
begin
  AssignThemeToForm(ATheme,frmSettings);
end;

exports
  Open,
  Close,
  Save,
  SetText,
  GetCenterTheme,
  GetMetaData;

end.

