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
  SharpCenterApi,
  SharpAPI,
  XPMan,
  uVistaFuncs,
  PngSpeedButton,
  uHotkeyServiceList in 'uHotkeyServiceList.pas',
  uHotkeyServiceItemListWnd in 'uHotkeyServiceItemListWnd.pas' {frmConfig},
  uHotkeyServiceItemEditWnd in 'uHotkeyServiceItemEditWnd.pas' {FrmHotkeyEdit},
  uHotkeyServiceGeneral in 'uHotkeyServiceGeneral.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas';

var
  CenterBGColor : integer;

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  FrmConfig := TFrmConfig.Create(nil);

  uVistaFuncs.SetVistaFonts(FrmConfig);

  FrmConfig.ParentWindow := AOwner;
  FrmConfig.Left := 0;
  FrmConfig.Top := 0;
  FrmConfig.BorderStyle := bsNone;
  FrmConfig.Show;
  FrmConfig.UpdateEditTabs;

  result := FrmConfig.Handle;
end;

function Save : boolean;
begin
  Result := True;
  FHotkeyList.Save;
end;

function Close : boolean;
begin
  Result := False;

  if FrmHotkeyEdit <> nil then
    FreeAndNil(FrmHotkeyEdit);

  if FrmConfig <> nil then begin
    FreeAndNil(FrmConfig);
  end;
end;

function OpenEdit(AOwner:Hwnd; AEditMode:TSCE_EDITMODE_ENUM):Hwnd;
begin
  // Create Form
  if Not(Assigned(FrmHotkeyEdit)) then
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

function CloseEdit(AEditMode:TSCE_EDITMODE_ENUM; AApply:Boolean): boolean;
begin
  Result := True;

  // Validation
  if (AApply) and Not(FrmHotkeyEdit.ValidateEdit(AEditMode)) then Begin
    Result := False;
    Exit;
  End;

  // Define whether we add/edit or delete the item
  if FrmHotkeyEdit.Save(AApply, AEditMode) then Begin
    FrmConfig.UpdateEditTabs;
  end;

  if FrmHotkeyEdit <> nil then begin
      FrmHotkeyEdit.Close;
      FrmHotkeyEdit.Free;
      FrmHotkeyEdit := nil;
  end;
end;

procedure SetDisplayText(const APluginID:Pchar; var ADisplayText:PChar);
begin
  ADisplayText := PChar('Hotkeys');
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

function SetSettingType : TSU_UPDATE_ENUM;
begin
  result := suService;
end;

procedure AddTabs(var ATabs:TPluginTabItemList);
begin
  ATabs.Add('Hotkeys',nil,'',IntToStr(frmConfig.lbHotkeys.Count));
end;


//Ordinary Dll code, tells delphi what functions to export.
exports
  Open,
  Close,
  Save,
  AddTabs,
  OpenEdit,
  CloseEdit,
  SetBtnState,
  SetDisplayText,
  SetSettingType,
  GetCenterScheme;

begin

end.

