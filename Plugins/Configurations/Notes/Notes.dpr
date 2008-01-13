﻿{
Source Name: Notes
Description: Notes Module Config Dll
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

library Notes;
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
  uNotesWnd in 'uNotesWnd.pas' {frmNotes},
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
  if frmNotes = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmNotes.sBarID),strtoint(frmNotes.sModuleID)));
  except
    XML.Root.Clear;
  end;

  XML.Root.Name := 'NotesModuleSettings';
  with XML.Root.Items, frmNotes do
  begin
    if ItemNamed['AlwaysOnTop'] <> nil then
      ItemNamed['AlwaysOnTop'].BoolValue := cb_alwaysontop.Checked
    else Add('AlwaysOnTop',cb_alwaysontop.Checked);

    if ItemNamed['Caption'] <> nil then
      ItemNamed['Caption'].BoolValue := (rb_text.Checked or rb_icontext.Checked)
    else Add('Caption',(rb_text.Checked or rb_icontext.Checked));

    if ItemNamed['Icon'] <> nil then
      ItemNamed['Icon'].BoolValue := (rb_icon.Checked or rb_icontext.Checked)
    else Add('Icon',(rb_icon.Checked or rb_icontext.Checked));
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmNotes.sBarID),strtoint(frmNotes.sModuleID)));
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
  ShowIcon,ShowCaption : boolean;
begin
  if frmNotes = nil then frmNotes := TfrmNotes.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmNotes);
  frmNotes.sBarID := left;
  frmNotes.sModuleID := right;
  frmNotes.ParentWindow := aowner;
  frmNotes.Left := 2;
  frmNotes.Top := 2;
  frmNotes.BorderStyle := bsNone;
  result := frmNotes.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmNotes do
    begin
      cb_alwaysontop.Checked := BoolValue('AlwaysOnTop',True);
      ShowIcon := BoolValue('Icon',True);
      ShowCaption := BoolValue('Caption',True);
      if ShowIcon and ShowCaption then
        rb_icontext.Checked := True
      else if ShowCaption then
        rb_text.Checked := True
      else rb_icon.Checked := True;
    end;
  XML.Free;

  frmNotes.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmNotes.Close;
    frmNotes.Free;
    frmNotes := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Notes';
  ATitle := 'Notes Module';
  ADescription := 'Configure notes module';
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Notes';
    Description := 'Notes Module Configuration';
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

