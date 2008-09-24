{
Source Name: ButtonBarModule.dpr
Description: ButtonBarModule List Config
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

library ButtonBarModule;
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
  uListWnd in 'uListWnd.pas' {frmList},
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpFX in '..\..\..\Common\Units\SharpFX\SharpFX.pas',
  GR32_PNG in '..\..\..\Common\3rd party\GR32 Addons\GR32_PNG.pas',
  graphicsFX in '..\..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpIconUtils in '..\..\..\Common\Units\SharpIconUtils\SharpIconUtils.pas',
  SharpCenterAPI in '..\..\..\Common\Libraries\SharpCenterApi\SharpCenterAPI.pas',
  uEditWnd in 'uEditWnd.pas',
  ButtonBarList in 'ButtonBarList.pas';

{$E .dll}

{$R *.res}

function Open(const APluginID: Pchar; AOwner: hwnd): hwnd;
var
  pluginId: string;
  barId: string;
  moduleId: string;
begin
  {$REGION 'Form Creation'}
    if frmList = nil then
        frmList := TfrmList.Create(nil);
      frmList.ParentWindow := aowner;
      frmList.Left := 0;
      frmList.Top := 0;
      frmList.BorderStyle := bsNone;
      frmList.Show;
      uVistaFuncs.SetVistaFonts(frmList);
  {$ENDREGION}

  {$REGION 'Get plugin and module id'}
      pluginId := APluginID;
      barId := copy(pluginId, 0, pos(':',pluginId)-1);
      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));

      barId := copy(pluginId, 0, pos(':',pluginId)-1);
      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
      //barId := '11823732';
      //moduleId := '4619264';

      frmList.BarId := StrToInt( barId );
      frmList.ModuleId := StrToInt( moduleId );
  {$ENDREGION}

  frmList.RenderItems;
  result := frmList.Handle;
end;

function Close: boolean;
begin
  result := True;
  try
    frmList.Close;
    frmList.Free;
    frmList := nil;
  except
    result := False;
  end;
end;

function OpenEdit(AOwner: hwnd; AEditMode:TSCE_EDITMODE_ENUM): hwnd;
begin
  if frmEdit = nil then frmEdit := TFrmEdit.Create(nil);
  uVistaFuncs.SetVistaFonts(frmEdit);

  frmEdit.ParentWindow := AOwner;
  frmEdit.Left := 0;
  frmEdit.Top := 0;
  frmEdit.BorderStyle := bsNone;
  frmEdit.Show;
  frmEdit.EditMode := AEditMode;
  Result := frmEdit.Handle;

  frmEdit.InitUi(AEditMode);

end;

function CloseEdit(AEditMode:TSCE_EDITMODE_ENUM; AApply: Boolean): boolean;
begin
  Result := True;

  // First validate
  if AApply then
    if Not(frmEdit.ValidateEdit(AEditMode)) then begin
      Result := False;
      Exit;
    end;

  // If Validation ok then continue
  frmEdit.Save(AApply,AEditMode);

  if Assigned(frmEdit) then
    FreeAndNil(frmEdit);
end;

procedure SetText(const APluginID: string; var AName: string; var AStatus: string;
  var ADescription: string);
var
  items: TButtonBarList;
  pluginId: string;
  barId: string;
  moduleId: string;
begin
  AName := 'Buttons';
  ADescription := 'Create and manage items for the button bar module';

  {$REGION 'Get plugin and module id'}
      pluginId := APluginID;
      barId := copy(pluginId, 0, pos(':',pluginId)-1);
      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));

      barId := copy(pluginId, 0, pos(':',pluginId)-1);
      moduleId := copy(pluginId, pos(':',pluginId)+1, length(pluginId) - pos(':',pluginId));
  {$ENDREGION}

  items := TButtonBarList.Create;
  items.BarId := strToInt(barId);
  items.ModuleId := strToInt(moduleId);
  try
    items.load;
    AStatus := inttostr(items.Count);
  finally
    items.free;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Button Bar list';
    Description := 'Button Bar List Edit Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.5.2';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suModule)]);
  end;
end;

procedure GetCenterScheme(var ABackground: TColor;
      var AItemColor: TColor; var AItemSelectedColor: TColor);
begin

  if frmList <> nil then begin
    frmList.lbItems.Colors.ItemColor := AItemColor;
    frmList.lbItems.Colors.CheckColor := AItemColor;
    frmList.lbItems.Colors.ItemColorSelected := AItemSelectedColor;
    frmList.lbItems.Colors.CheckColorSelected := AItemSelectedColor;
    frmList.UpdateImages;
  end;

  if frmEdit <> nil then
      frmEdit.Color := ABackground;
end;

procedure GetCenterTheme(const ATheme: TCenterThemeInfo; const AEdit: Boolean);
begin
  AssignThemeToForms(ATheme,frmList,frmEdit,AEdit);
  frmList.Theme := ATheme;

  frmList.UpdateImages;
end;


exports
  Open,
  Close,
  SetText,
  GetMetaData,
  OpenEdit,
  CloseEdit,
  GetCenterTheme,
  GetCenterScheme;

begin
end.

