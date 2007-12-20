{
Source Name: Clock
Description: Clock Module Config Dll
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

library Clock;
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
  JvPageList,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uClockWnd in 'uClockWnd.pas' {frmClock},
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
  i : integer;
begin
  if frmClock = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'ClockModuleSettings';
  with XML.Root.Items, frmClock do
  begin
    if rbLarge.Checked then
      i := 2
    else if rbSmall.Checked then
      i := 0
    else i := 1;
    Add('Style',i);
    Add('Format',EditSingleLine.Text);
    if cbTwoLine.Checked then
      Add('BottomFormat',EditTwoLine.Text)
    else Add('BottomFormat','');
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmClock.sBarID),strtoint(frmClock.sModuleID)));
  XML.Free;
end;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  left,right : String;
  s : string;
  fileloaded : boolean;
begin
  if frmClock = nil then frmClock := TfrmClock.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmClock);
  frmClock.sBarID := left;
  frmClock.sModuleID := right;
  frmClock.ParentWindow := aowner;
  frmClock.Left := 2;
  frmClock.Top := 2;
  frmClock.BorderStyle := bsNone;
  result := frmClock.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmClock do
    begin
      case IntValue('Style',1) of
        2: rbLarge.Checked := True;
        0: rbSmall.Checked := True;
        else rbMedium.Checked := True;
      end;
      EditSingleLine.Text := Value('Format','HH:MM:SS');
      EditTwoLine.Text := Value('BottomFormat','DD.MM.YYYY');
      cbTwoLine.Checked := (length(EditTwoLine.Text) > 0)
    end;
  XML.Free;

  frmClock.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmClock.Close;
    frmClock.Free;
    frmClock := nil;
  except
    result := False;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
begin
  AName := 'Clock';
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

