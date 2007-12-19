{
Source Name: Hotkeys
Description: Hotkeys Service for SharpE
Copyright (C) Pixol (pixol@sharpe-shell.org)

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

library Hotkeys;
uses
  Forms,
  windows,
  dialogs,
  graphics,
  sysutils,
  SharpCenterApi,
  SharpAPI,
  jvSimpleXml,
  XPMan,
  uVistaFuncs,
  PngSpeedButton,
  uHotkeyServiceList in 'uHotkeyServiceList.pas',
  uHotkeyServiceItemListWnd in 'uHotkeyServiceItemListWnd.pas' {frmConfig},
  uHotkeyServiceItemEditWnd in 'uHotkeyServiceItemEditWnd.pas' {FrmHotkeyEdit},
  uHotkeyServiceGeneral in 'uHotkeyServiceGeneral.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas';

var
  CenterBGColor: integer;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  FrmConfig := TFrmConfig.Create(nil);
  uVistaFuncs.SetVistaFonts(FrmConfig);

  CenterDefineConfigurationMode(scmLive);

  FrmConfig.ParentWindow := AOwner;
  FrmConfig.Left := 0;
  FrmConfig.Top := 0;
  FrmConfig.BorderStyle := bsNone;
  FrmConfig.Show;
  FrmConfig.UpdateEditTabs;

  result := FrmConfig.Handle;
end;

function Close: boolean;
begin
  Result := False;

  if FrmHotkeyEdit <> nil then
    FreeAndNil(FrmHotkeyEdit);

  if FrmConfig <> nil then begin
    FreeAndNil(FrmConfig);
  end;
end;

function OpenEdit(AOwner: Hwnd; AEditMode: TSCE_EDITMODE_ENUM): Hwnd;
begin
  // Create Form
  if not (Assigned(FrmHotkeyEdit)) then
    FrmHotkeyEdit := TFrmHotkeyEdit.Create(nil);

  uVistaFuncs.SetVistaFonts(FrmHotkeyEdit);

  // Assign form to AOwner handle
  FrmHotkeyEdit.ParentWindow := AOwner;
  FrmHotkeyEdit.Left := 0;
  FrmHotkeyEdit.Top := 0;
  FrmHotkeyEdit.BorderStyle := bsNone;
  FrmHotkeyEdit.Show;
  FrmHotkeyEdit.Color := CenterBGColor;
  frmConfig.EditMode := AEditMode;

  // Initialise UI based on the edit mode
  FrmHotkeyEdit.InitUI(AEditMode, True);

  Result := FrmHotkeyEdit.Handle;

end;

function CloseEdit(AEditMode: TSCE_EDITMODE_ENUM; AApply: Boolean): boolean;
begin
  Result := True;

  // Validation
  if (AApply) and not (FrmHotkeyEdit.ValidateEdit(AEditMode)) then begin
    Result := False;
    Exit;
  end;

  // Define whether we add/edit or delete the item
  if FrmHotkeyEdit.Save(AApply, AEditMode) then begin
    FrmConfig.UpdateEditTabs;
  end;

  if FrmHotkeyEdit <> nil then begin
    FrmHotkeyEdit.Close;
    FrmHotkeyEdit.Free;
    FrmHotkeyEdit := nil;
  end;
end;

procedure SetDisplayText(const APluginID: string; var ADisplayText: string);
begin
  ADisplayText := 'Hotkeys';
end;

procedure SetStatusText(const APluginID: string; var AStatusText: string);
var
  ItemCount, Loop: Integer;
  fn: string;
  xml: TjvSimpleXml;
  prop: string;

begin
  fn := GetSharpeUserSettingsPath + cSettingsLocation;
  Xml := TJvSimpleXml.Create(nil);
  try
    xml.LoadFromFile(fn);

    Itemcount := xml.Root.Properties.Item[0].IntValue;
    AStatusText := IntToStr(ItemCount);
  finally
    xml.Free;
  end;
end;

procedure GetCenterScheme(var ABackground: TColor; var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  if FrmHotkeyEdit <> nil then
    FrmHotkeyEdit.Color := ABackground;
  CenterBGColor := ABackground;

  frmConfig.lbHotkeys.Colors.ItemColor := AItemColor;
  frmConfig.lbHotkeys.Colors.ItemColorSelected := AItemSelectedColor;
end;

function SetBtnState(AButtonID: Integer): Boolean;
begin
  Result := False;
end;

function SetSettingType: TSU_UPDATE_ENUM;
begin
  result := suService;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Open,
  Close,
  OpenEdit,
  CloseEdit,
  SetBtnState,
  SetDisplayText,
  SetStatusText,
  SetSettingType,
  GetCenterScheme;

begin

end.

