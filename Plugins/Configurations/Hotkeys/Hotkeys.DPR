{
Source Name: Hotkeys
Description: Hotkeys Service for SharpE
Copyright (C) Pixol (pixol@sharpe-shell.org)

3rd Party Libraries used: JCL, JVCL, PNGImage
Common: SharpApi, SharpFX

Sourceforge Project Site
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

library Hotkeys;
uses
  Forms,
  windows,
  dialogs,
  graphics,
  sysutils,
  SharpAPI,
  XPMan,
  PngSpeedButton,
  uHotkeyServiceList in 'uHotkeyServiceList.pas',
  uHotkeyServiceItemListWnd in 'uHotkeyServiceItemListWnd.pas' {frmConfig},
  uHotkeyServiceItemEditWnd in 'uHotkeyServiceItemEditWnd.pas' {FrmHotkeyEdit},
  uHotkeyServiceGeneral in 'uHotkeyServiceGeneral.pas';

function Open(const APluginID: Integer; owner: hwnd): hwnd;
begin
  FrmConfig := TFrmConfig.Create(nil);

  FrmConfig.ParentWindow := owner;
  FrmConfig.Left := 0;
  FrmConfig.Top := 0;
  FrmConfig.BorderStyle := bsNone;
  FrmConfig.Show;

  result := FrmConfig.Handle;
end;

function Close(owner: hwnd; SaveSettings: Boolean): boolean;
begin

  if SaveSettings then
    FHotkeyList.Save;

  FreeAndNil(FrmHotkeyEdit);
  FreeAndNil(FrmConfig);
  result := True;
end;

function ConfigDllType: Integer;
begin
  Result := SCU_SERVICE;
end;

procedure GetDisplayName(const APluginID:Integer; var ADisplayName:PChar);
begin
  ADisplayName := PChar('Hotkeys');
end;

procedure BtnAdd(var AButton:TPngSpeedButton);
begin
  frmConfig.AddItemClick(nil);
end;

procedure BtnEdit(var AButton:TPngSpeedButton);
begin
  frmConfig.EditItemClick(nil);
end;

procedure BtnDelete(var AButton:TPngSpeedButton);
begin
  frmConfig.DeleteItemClick(nil);
end;

procedure BtnImport(var AButton:TPngSpeedButton);
begin
  frmConfig.ImportHotkeys;
end;

procedure BtnExport(var AButton:TPngSpeedButton);
begin
  frmConfig.ExportHotkeys;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Open,
  Close,
  BtnAdd,
  BtnEdit,
  BtnDelete,
  BtnImport,
  BtnExport,
  ConfigDllType,
  GetDisplayName;
begin

end.

