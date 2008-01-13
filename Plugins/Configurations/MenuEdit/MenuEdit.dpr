{
Source Name: Menu Editor
Description: SharpMenu Editor Config
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

library MenuEdit;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uSharpEMenuSaver,
  uSharpEMenuItem,
  uListWnd in 'uListWnd.pas' {frmList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uSharpCenterCommon in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterCommon.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  uSharpEMenu in '..\..\..\Components\SharpMenu\Units\uSharpEMenu.pas',
  uEditWnd in 'uEditWnd.pas' {frmEdit};

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  // Create the window
  if frmList = nil then
    frmList := TFrmList.Create(nil);

  // Assign vista fonts
  uVistaFuncs.SetVistaFonts(frmList);

  // Assign the menu file
  frmList.MenuFile := GetSharpeUserSettingsPath + 'SharpMenu\' + APluginID + '.xml';

  // Assign window settings
  frmList.ParentWindow := aowner;
  frmList.Left := 0;
  frmList.Top := 0;
  frmList.BorderStyle := bsNone;
  frmList.Show;

  result := frmList.Handle;
end;

function Close: boolean;
begin
  result := True;

  // Free the window
  frmList.Close;
  frmList.Free;
  frmList := nil;
end;

function OpenEdit(AOwner:Hwnd; AEditMode:TSCE_EditMode_Enum):Hwnd;
begin
  // Create window
  if Not(Assigned(frmEdit)) then
    frmEdit := TfrmEdit.Create(nil);

  // Assign Vista fonts
  uVistaFuncs.SetVistaFonts(frmEdit);

  // Assign window settings
  frmEdit.ParentWindow := AOwner;
  frmEdit.Left := 0;
  frmEdit.Top := 0;
  frmEdit.BorderStyle := bsNone;

  // Assign edit mode, and initialise ui
  frmEdit.EditMode := AEditMode;
  frmEdit.InitUI(AEditMode);

  // Show the window
  frmEdit.Show;

  Result := frmEdit.Handle;
end;

function CloseEdit(AEditMode:TSCE_EditMode_Enum; AApply:Boolean): boolean;
begin
  Result := True;

  // Save settings?
  frmEdit.Save(AEditMode, AApply);

  // Free the window
  FreeAndNil(frmEdit);
end;

procedure SetText(const APluginID: string; var AName: string; var AStatus: string;
  var ATitle: string; var ADescription: string);
begin
  AName := 'Menu Editor';
  ATitle := Format('Menu Configuration for "%s"', [APluginID]);
  ADescription := 'Drag Items to position them, hold down Ctrl to move an item into a submenu';
  AStatus := '';
end;

procedure GetCenterScheme(var ABackground: TColor;
  var AItemColor: TColor; var AItemSelectedColor: TColor);
begin

  // Assign scheme colours
  if frmList <> nil then begin
    frmList.lbItems.Colors.ItemColor := AItemColor;
    frmList.lbItems.Colors.ItemColorSelected := AItemSelectedColor;
    frmList.lbItems.Colors.BorderColor := AItemSelectedColor;
    frmList.lbItems.Colors.BorderColorSelected := AItemSelectedColor;
  end;

  if frmEdit <> nil then
    frmEdit.Color := ABackground;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Menu Editor';
    Description := 'Menu Editor Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suCenter)]);
  end;
end;

exports
  Open,
  Close,
  OpenEdit,
  CloseEdit,
  SetText,
  GetCenterScheme;

end.

