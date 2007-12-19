﻿{
Source Name: SharpDesk Configs
Description: SharpDesk Config Dll
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

library SharpDesk;
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
  uSharpDeskSettingsWnd in 'uSharpDeskSettingsWnd.pas' {frmDeskSettings},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpDeskTDeskSettings in '..\..\..\Components\SharpDesk\Units\uSharpDeskTDeskSettings.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas';

{$E .dll}

{$R *.res}

var
  XMLSettings : TDeskSettings;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  if frmDeskSettings = nil then frmDeskSettings := TfrmDeskSettings.Create(nil);
  if XMLSettings = nil then XMLSettings := TDeskSettings.Create(nil);

  uVistaFuncs.SetVistaFonts(frmDeskSettings);
  frmDeskSettings.ParentWindow := aowner;
  frmDeskSettings.Left := 0;
  frmDeskSettings.Top := 0;
  frmDeskSettings.BorderStyle := bsNone;

  frmDeskSettings.cb_grid.Checked := XMLSettings.Grid;
  frmDeskSettings.sgb_gridx.Value := XMLSettings.GridX;
  frmDeskSettings.sgb_gridy.Value := XMLSettings.GridY;
  frmDeskSettings.cb_singleclick.Checked := XMLSettings.SingleClick;
  frmDeskSettings.cb_amm.Checked := XMLSettings.AdvancedMM;
  frmDeskSettings.cb_dd.Checked := XMLSettings.DragAndDrop;
  frmDeskSettings.cb_wpwatch.Checked := XMLSettings.WallpaperWatch;
  frmDeskSettings.cb_autorotate.Checked := XMLSettings.ScreenRotAdjust;
  frmDeskSettings.cb_adjustsize.Checked := XMLSettings.ScreenSizeAdjust;

  frmDeskSettings.Show;
  result := frmDeskSettings.Handle;
end;

procedure Save;
begin
  XMLSettings.Grid  := frmDeskSettings.cb_grid.Checked;
  XMLSettings.GridX := frmDeskSettings.sgb_gridx.Value;
  XMLSettings.GridY := frmDeskSettings.sgb_gridy.Value;
  XMLSettings.SingleClick := frmDeskSettings.cb_singleclick.Checked;
  XMLSettings.AdvancedMM := frmDeskSettings.cb_amm.Checked;
  XMLSettings.DragAndDrop := frmDeskSettings.cb_dd.Checked;
  XMLSettings.WallpaperWatch := frmDeskSettings.cb_wpwatch.Checked;
  XMLSettings.ScreenRotAdjust := frmDeskSettings.cb_autorotate.Checked;
  XMLSettings.ScreenSizeAdjust := frmDeskSettings.cb_adjustsize.Checked;
  XMLSettings.SaveSettings;
end;

function Close : boolean;
begin
  result := True;
  try
    XMLSettings.Free;
    XMLSettings := nil;

    frmDeskSettings.Close;
    frmDeskSettings.Free;
    frmDeskSettings := nil;
  except
    result := False;
  end;
end;


procedure SetDisplayText(const APluginID: String; var ADisplayText: String);
begin
  ADisplayText := PChar('Desktop');
end;

procedure SetStatusText(const APluginID: string; var AStatusText: string);
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
  if frmDeskSettings <> nil then
  begin
    ATabs.Add('Settings',frmDeskSettings.JvSettingsPage,'','');
  end;
end;

function SetSettingType : TSU_UPDATE_ENUM;
begin
  result := suSharpDesk;
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

