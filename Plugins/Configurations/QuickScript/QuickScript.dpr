{
Source Name: QuickScript
Description: QuickScript Module Config Dll
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

library QuickScript;
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
  uQuickScriptWnd in 'uQuickScriptWnd.pas' {frmQuickScript},
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
  if frmQuickScript = nil then
    exit;

  XML := TJvSimpleXML.Create(nil);
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmQuickScript.sBarID),strtoint(frmQuickScript.sModuleID)));
  except
    XML.Root.Clear;
  end;

  XML.Root.Name := 'QuickScriptModuleSettings';
  with XML.Root.Items, frmQuickScript do
  begin
    if ItemNamed['Caption'] <> nil then
      ItemNamed['Caption'].BoolValue := (rb_text.Checked or rb_icontext.Checked)
    else Add('Caption',(rb_text.Checked or rb_icontext.Checked));

    if ItemNamed['Icon'] <> nil then
      ItemNamed['Icon'].BoolValue := (rb_icon.Checked or rb_icontext.Checked)
    else Add('Icon',(rb_icon.Checked or rb_icontext.Checked));
  end;
  XML.SaveToFile(uSharpBarApi.GetModuleXMLFile(strtoint(frmQuickScript.sBarID),strtoint(frmQuickScript.sModuleID)));
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
  if frmQuickScript = nil then frmQuickScript := TfrmQuickScript.Create(nil);

  s := APluginID;
  left := copy(s, 0, pos(':',s)-1);
  right := copy(s, pos(':',s)+1, length(s) - pos(':',s));
  uVistaFuncs.SetVistaFonts(frmQuickScript);
  frmQuickScript.sBarID := left;
  frmQuickScript.sModuleID := right;
  frmQuickScript.ParentWindow := aowner;
  frmQuickScript.Left := 2;
  frmQuickScript.Top := 2;
  frmQuickScript.BorderStyle := bsNone;
  result := frmQuickScript.Handle;

  XML := TJvSimpleXML.Create(nil);
  fileloaded := False;
  try
    XML.LoadFromFile(uSharpBarApi.GetModuleXMLFile(strtoint(left),strtoint(right)));
    fileloaded := True;
  except
  end;

  if fileloaded then
    with XML.Root.Items, frmQuickScript do
    begin
      ShowIcon := BoolValue('Icon',True);
      ShowCaption := BoolValue('Caption',True);
      if ShowIcon and ShowCaption then
        rb_icontext.Checked := True
      else if ShowCaption then
        rb_text.Checked := True
      else rb_icon.Checked := True;
    end;
  XML.Free;

  frmQuickScript.Show;
end;

function Close : boolean;
begin
  result := True;
  try
    frmQuickScript.Close;
    frmQuickScript.Free;
    frmQuickScript := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: String; var ADisplayText: String);
begin
  ADisplayText := PChar('QuickScript');
end;

procedure SetStatusText(const APluginID: String; var AStatusText: string);
begin
  AStatusText := '';
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);

begin
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('QuickScript',frmQuickScript.pagNotes,'','');
end;

procedure ClickTab(ATab: TPluginTabItem);
var
  tmpPag: TJvStandardPage;
begin
  if ATab.Data <> nil then begin
    tmpPag := TJvStandardPage(ATab.Data);
    tmpPag.Show;
  end;
end;

procedure ClickBtn(AButtonID: Integer; AButton:TPngSpeedButton; AText:String);
begin
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  result := suModule;
end;


exports
  Open,
  Close,
  Save,
  ClickTab,
  SetDisplayText,
  SetStatusText,
  SetSettingType,
  SetBtnState,
  GetCenterScheme,
  AddTabs,
  ClickBtn;

end.

