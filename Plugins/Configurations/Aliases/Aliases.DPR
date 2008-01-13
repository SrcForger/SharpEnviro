{
Source Name: <Configuration_Name>
Description: <Configuration_Name> Configuration for SharpE
Copyright (C) <Author_Name> <Author_Email>

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

library Aliases;
uses
  windows,
  registry,
  Classes,
  Messages,
  graphics,
  activex,
  sysutils,
  Jclstrings,
  forms,
  SharpApi,
  SharpCenterApi,
  PngSpeedButton,
  uVistaFuncs,
  ItemsWnd in 'ItemsWnd.pas' {frmItemsWnd},
  EditWnd in 'EditWnd.pas' {frmEditWnd},
  uSharpCenterPluginTabList in '..\..\..\Common\Units\SharpCenterSupporting\uSharpCenterPluginTabList.pas',
  uExecServiceAliasList in '..\..\Services\Exec\uExecServiceAliasList.pas';

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
begin
  frmItemsWnd := TfrmItemsWnd.Create(nil);
  SetVistaFonts(frmItemsWnd);

  frmItemsWnd.ParentWindow := AOwner;
  frmItemsWnd.Left := 0;
  frmItemsWnd.Top := 0;
  frmItemsWnd.BorderStyle := bsNone;
  frmItemsWnd.Show;

  frmItemsWnd.UpdateEditTabs;
  result := frmItemsWnd.Handle;
end;

function Close : boolean;
begin
  Result := False;

  if frmEditWnd <> nil then
    FreeAndNil(frmEditWnd);

  if frmItemsWnd <> nil then begin
    FreeAndNil(frmItemsWnd);
  end;
end;

function OpenEdit(AOwner:Hwnd; AEditMode:TSCE_EDITMODE_ENUM):Hwnd;
begin
  // Create Form
  if Not(Assigned(frmEditWnd)) then
    frmEditWnd := TfrmEditWnd.Create(nil);
  SetVistaFonts(frmEditWnd);

  // Assign form to AOwner handle
  frmEditWnd.ParentWindow := AOwner;
  frmEditWnd.Left := 0;
  frmEditWnd.Top := 0;
  frmEditWnd.BorderStyle := bsNone;
  frmEditWnd.Show;
  frmEditWnd.EditMode := AEditMode;

  // Initialise UI based on the edit mode
  frmEditWnd.InitUI(AEditMode);

  Result := frmEditWnd.Handle;
end;

function CloseEdit(AEditMode:TSCE_EDITMODE_ENUM; AApply:Boolean): boolean;
begin
  Result := True;

  // Validation
  if (AApply) and Not(frmEditWnd.ValidateEdit(AEditMode)) then Begin
    Result := False;
    Exit;
  End;

  // Define whether we add/edit or delete the item
  if frmEditWnd.Save(AApply, AEditMode) then Begin
    SharpApi.ServiceMsg('exec','_refresh');
  end;

  if frmEditWnd <> nil then begin
      frmEditWnd.Close;
      frmEditWnd.Free;
      frmEditWnd := nil;
  end;
end;

procedure SetText(const APluginID: String; var AName: String; var AStatus: String;
  var ATitle: String; var ADescription: String);
var
  srvSettingsPath: string;
  fileName: string;
  tmp: TAliasList;
begin
  AName := 'Aliases';
  ATitle := 'Aliases Configuration';
  ADescription := 'Create Alias commands for commonly used applications.';

  // Status
  srvSettingsPath := GetSharpeUserSettingsPath + 'SharpCore\Services\Exec\';
  fileName := SrvSettingsPath + 'AliasList.xml';
  tmp := TAliasList.Create(fileName);
  Try
    AStatus := IntToStr(tmp.Count);
  Finally
    tmp.Free;
  End;
end;

procedure GetCenterScheme(var ABackground: TColor; var AItemColor: TColor; var AItemSelectedColor: TColor);
begin
  if frmEditWnd <> nil then
    frmEditWnd.Color := ABackground;
  //CenterBGColor := ABackground;

  frmItemsWnd.lbItems.Colors.ItemColor := AItemColor;
  frmItemsWnd.lbItems.Colors.ItemColorSelected := AItemSelectedColor;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Aliases';
    Description := 'Aliases Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.4.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suService)]);
  end;
end;

//Ordinary Dll code, tells delphi what functions to export.
exports
  Open,
  Close,
  OpenEdit,
  CloseEdit,
  SetText,
  GetMetaData,
  GetCenterScheme;
begin

end.

