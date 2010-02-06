{
Source Name: MenuList.dpr
Description: Menu List Config
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

library MenuList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  JclStrings,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  Graphics,
  uListWnd in 'uListWnd.pas' {frmList},
  uEditWnd in 'uEditWnd.pas' {$E .dll},
  SharpETabList,
  SharpApi,
  SharpCenterApi,
  SharpEListBoxEx,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  JvValidators;

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private

    procedure ValidateMenuName(Sender: TObject;
      ValueToValidate: Variant; var Valid: Boolean);
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;


    function GetPluginDescriptionText: String; override; stdCall;
    function GetPluginName: String; override; stdCall;
    function GetPluginStatusText: String; override; stdCall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
    function OpenEdit: Cardinal; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    procedure SetupValidators; stdcall;


  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmList);
  FreeAndNil(frmEdit);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    frmEdit.Save;

  if Assigned(frmEdit) then
    FreeAndNil(frmEdit);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'Create and manage multiple menu configurations';
end;

function TSharpCenterPlugin.GetPluginStatusText: String;
var
  dir: string;
  slMenus: TStringList;
begin
  dir := SharpApi.GetSharpeUserSettingsPath + 'SharpMenu\';
  slMenus := TStringList.Create;
  try
  AdvBuildFileList(dir + '*.xml', faAnyFile, slMenus, amAny, [flFullNames]);
  finally
    result := IntToStr(slMenus.Count);
    slMenus.Free;
  end;
end;

function TSharpCenterPlugin.GetPluginName: String;
begin
  Result := 'Menus';
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmList = nil then frmList := TfrmList.Create(nil);
  uVistaFuncs.SetVistaFonts(frmList);

  result := PluginHost.Open(frmList);
  frmList.PluginHost := PluginHost;
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if frmEdit = nil then frmEdit := TFrmEdit.Create(nil);
  frmEdit.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(frmEdit);

  result := PluginHost.OpenEdit(frmEdit);
  frmEdit.InitUi;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToForms(frmList,frmEdit,AEditing,Theme);
end;

procedure TSharpCenterPlugin.SetupValidators;
var
  tmp: TJvCustomValidator;
begin
  // Can not leave field name blank
  PluginHost.AddRequiredFieldValidator( frmEdit.edName,'Please enter a menu name','Text');

  // Validator for checking duplicates
  tmp := PluginHost.AddCustomValidator( frmEdit.edName,'There is already a menu with this name','Text');
  tmp.OnValidate := ValidateMenuName;
end;

procedure TSharpCenterPlugin.ValidateMenuName(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  bExistsName: Boolean;
  sName, sMenuDir: string;

  tmpItem: TSharpEListItem;
  tmpMenuItem: TMenuDataObject;
begin
  sName := trim(StrRemoveChars(ValueToValidate,
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
  sMenuDir := GetSharpeUserSettingsPath + 'SharpMenu\';

  bExistsName := FileExists(sMenuDir + sName + '.xml');
  if (PluginHost.EditMode = sceEdit) then begin
    tmpItem := frmList.lbItems.SelectedItem;
    tmpMenuItem := TMenuDataObject(tmpItem.Data);

    if (CompareText(frmEdit.edName.Text, tmpMenuItem.Name) = 0) then
      bExistsName := False;
  end;

  Valid := not (bExistsName);
end;

function InitPluginInterface(APluginHost: ISharpCenterHost) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Menu List';
    Description := 'Menu List Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suCenter)]);
  end;
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.



