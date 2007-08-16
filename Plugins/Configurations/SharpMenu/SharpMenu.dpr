﻿{
Source Name: SharpDesk Configs
Description: SharpDesk Config Dll
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

library SharpMenu;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  JvPageList,
  Graphics,
  Math,
  uSharpMenuSettingsWnd in 'uSharpMenuSettingsWnd.pas' {frmMenuSettings},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpDeskTDeskSettings in '..\..\..\Components\SharpDesk\Units\uSharpDeskTDeskSettings.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}


function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  XML : TJvSimpleXML;
  Dir : String;
  FName : String;
  i : integer;
begin
  if frmMenuSettings = nil then frmMenuSettings := TfrmMenuSettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmMenuSettings);
  frmMenuSettings.ParentWindow := aowner;
  frmMenuSettings.Left := 2;
  frmMenuSettings.Top := 2;
  frmMenuSettings.BorderStyle := bsNone;

  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Settings\';
  FName := Dir + 'SharpMenu.xml';

  XML := TJvSimpleXML.Create(nil);
  try
    if FileExists(FName) then
    begin
      XML.LoadFromFile(FName);
      if XML.Root.Items.ItemNamed['Settings'] <> nil then
         with XML.Root.Items.ItemNamed['Settings'].Items do
         begin
           frmMenuSettings.cb_wrap.Checked := BoolValue('WrapMenu',True);
           frmMenuSettings.sgb_wrapcount.Value := IntValue('WrapCount',25);
           i := Max(0,Min(1,IntValue('WrapPosition',0)));
           frmMenuSettings.cobo_wrappos.ItemIndex := i;
           frmMenuSettings.cb_cacheicons.Checked := BoolValue('CacheIcons',True);
         end;
    end;
  finally
    XML.Free;
  end;

  frmMenuSettings.Show;
  result := frmMenuSettings.Handle;
end;

procedure Save;
var
  XML : TJvSimpleXML;
  Dir : String;
  FName : String;
begin
  Dir := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\Settings\';
  if not DirectoryExists(Dir) then
     ForceDirectories(Dir);
  FName := Dir + 'SharpMenu.xml';

  XML := TJvSimpleXML.Create(nil);
  XML.Root.Name := 'SharpEMenuSettings';
  with XML.Root.Items.Add('Settings').Items do
  begin
   Add('WrapMenu',frmMenuSettings.cb_wrap.Checked);
   AdD('WrapCount',frmMenuSettings.sgb_wrapcount.Value);
   Add('WrapPosition',frmMenuSettings.cobo_wrappos.ItemIndex);
   Add('CacheIcons',frmMenuSettings.cb_cacheicons.Checked);
  end;
  XML.SaveToFile(FName + '~');
  if FileExists(FName) then
     DeleteFile(FName);
  RenameFile(FName + '~',
             FName);
  XML.Free;
end;

function Close : boolean;
begin
  result := True;
  try
    frmMenuSettings.Close;
    frmMenuSettings.Free;
    frmMenuSettings := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: Pchar; var ADisplayText: PChar);
begin
  ADisplayText := PChar('Menu');
end;

procedure SetStatusText(var AStatusText: PChar);
begin
  AStatusText := '';
end;

procedure ClickBtn(AButtonID: Integer; AButton:TPngSpeedButton; AText:String);
begin
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
  if frmMenuSettings <> nil then
  begin
    ATabs.Add('Settings',frmMenuSettings.JvSettingsPage,'','');
  end;
end;

function SetSettingType : TSU_UPDATE_ENUM;
begin
  result := suSharpMenu;
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
  ClickTab,
  ClickBtn;

end.

