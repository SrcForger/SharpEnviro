{
Source Name: FilterList.dpr
Description: Filter List Config
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

library FilterList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JclSimpleXml,
  JclFileUtils,
  jclStrings,
  GR32,
  GR32_Image,
  PngSpeedButton,
  uVistaFuncs,
  JvValidators,
  SysUtils,
  Graphics,
  TaskFilterList,
  SharpEListboxEx,
  SharpApi,
  SharpCenterApi,
  uSharpCenterPluginScheme,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uListWnd in 'uListWnd.pas' {frmList},
  uEditWnd in 'uEditWnd.pas' {frmEdit};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
    procedure ValidateFilterExists(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;
    procedure Save; override; stdCall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
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

  FreeAndNil(frmEdit);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmList = nil then frmList := TfrmList.Create(nil);
  uVistaFuncs.SetVistaFonts(frmList);

  frmList.PluginHost := PluginHost;
  result := PluginHost.Open(frmList);
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if frmEdit = nil then frmEdit := TfrmEdit.Create(nil);
  frmEdit.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(frmEdit);

  result := PluginHost.OpenEdit(frmEdit);
  frmEdit.Init;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToForms(frmList,frmEdit,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
begin
  inherited;
  frmList.FilterItemList.Save;
  BroadcastGlobalUpdateMessage(suTaskFilter);
end;

procedure TSharpCenterPlugin.SetupValidators;
var
  tmp: TJvCustomValidator;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( frmEdit.edName,'Please enter a name for this filter','Text');

  // Validator for checking duplicates
  tmp := PluginHost.AddCustomValidator( frmEdit.edName,'There is already a filter with this name','Text');
  tmp.OnValidate := ValidateFilterExists;
end;

procedure TSharpCenterPlugin.ValidateFilterExists(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  bExistsName: Boolean;
  sName, sMenuDir: string;

  tmpItem: TSharpEListItem;
  tmpMenuItem: TFilterItem;
begin
  sName := trim(StrRemoveChars(ValueToValidate,
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));
  sMenuDir := GetSharpeUserSettingsPath + 'SharpMenu\';

  bExistsName := FileExists(sMenuDir + sName + '.xml');
  if (PluginHost.EditMode = sceEdit) then begin
    tmpItem := frmList.lbItems.SelectedItem;
    tmpMenuItem := TFilterItem(tmpItem.Data);

    if (CompareText(frmEdit.edName.Text, tmpMenuItem.Name) = 0) then
      bExistsName := False;
  end;

  Valid := not (bExistsName);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Filter List';
    Description := 'Filter List Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suTaskFilter)]);
  end;
end;

function GetPluginData(): TPluginData;
var
  tmp: TFilterItemList;
begin
  with result do
  begin
    Name := 'Task Filters';
    Description := 'Create and manage multiple filter configurations';
	Status := '';

    tmp := TFilterItemList.Create;
    try
      tmp.Load;
      Status := IntTostr(tmp.Count);
    finally
      tmp.Free;
    end;
  end;
end;


function InitPluginInterface( APluginHost: ISharpCenterHost ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.


