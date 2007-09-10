﻿{
Source Name: MiniScmd
Description: MiniScmd Module Config Dll
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
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
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  uSharpDeskObjectSettings in '..\..\..\Common\Units\XML\uSharpDeskObjectSettings.pas',
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


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('MiniScmd');
end;

procedure SetStatusText(var AStatusText: PChar);
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
  ATabs.Add('MiniScmd',frmMiniScmd.pagMiniScmd,'','');
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

