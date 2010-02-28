{
Source Name: ThemeList
Description: Theme List Config Dll
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

library ThemeList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  graphics,
  JvSimpleXml,
  PngSpeedButton,
  SysUtils,
  uVistaFuncs,
  SharpCenterApi,
  SharpFileUtils,
  SharpApi,
  JvValidators,
  JclStrings,
  SharpThemeApiEx,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uThemeListWnd in 'uThemeListWnd.pas' {frmList},
  uThemeListEditWnd in 'uThemeListEditWnd.pas' {frmEdit},
  uThemeListManager in 'uThemeListManager.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class(TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
      ISharpCenterPluginValidation)
  private
    procedure ValidateTheme(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
  public
    constructor Create(APluginHost: ISharpCenterHost);

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;

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
  uVistaFuncs.SetVistaFonts(frmEdit);

  frmEdit.PluginHost := PluginHost;
  result := PluginHost.OpenEdit(frmEdit);

  frmEdit.Init;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToForms(frmList, frmEdit, AEditing, Theme);
end;

procedure TSharpCenterPlugin.Save;
var
  tmpTheme: TThemeListItemClass;
begin
  with frmList do begin
    lbThemeList.Enabled := False;
    tmrEnableUi.Enabled := True;

    tmpTheme := TThemeListItemClass(lbThemeList.SelectedItem.Data);

    Loading := True;
    ThemeManager.SetTheme(tmpTheme.Name);
    SharpApi.BroadcastGlobalUpdateMessage(suTheme, -1, True);
  end;
end;

procedure TSharpCenterPlugin.SetupValidators;
var
  tmp: TJvCustomValidator;
begin
  // Required field validators
  PluginHost.AddRequiredFieldValidator(frmEdit.edAuthor, 'Please enter a name for the author', 'Text');
  PluginHost.AddRequiredFieldValidator(frmEdit.edName, 'Please enter a name for the theme', 'Text');

  // Validator for checking duplicates
  tmp := PluginHost.AddCustomValidator(frmEdit.edName, 'There is already a theme with this name', 'Text');
  tmp.OnValidate := ValidateTheme;
end;

procedure TSharpCenterPlugin.ValidateTheme(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  bExists : Boolean;
  sValidName, sThemeDir: string;
  tmpThemeItem: TThemeListItemClass;
begin
  Valid := True;

  sValidName := trim(StrRemoveChars(string(ValueToValidate),
    ['"', '<', '>', '|', '/', '\', '*', '?', '.', ':']));

  sThemeDir := GetSharpeUserSettingsPath + 'Themes\';
  bExists := DirectoryExists(sThemeDir + sValidName);

  tmpThemeItem := TThemeListItemClass(frmList.lbThemeList.SelectedItem.Data);

  if PluginHost.EditMode = sceEdit then
    if (CompareText(ValueToValidate, tmpThemeItem.Name) = 0) then
      // We are in edit mode and the name has not changed.
      bExists := False
    else if not bExists then
      // We are in edit mode and the name has changed and the file does not exist.
      bExists := False;

  Valid := not bExists;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Themes List';
    Description := 'Theme List Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d', [Integer(scmApply),
      Integer(suTheme)]);
  end;
end;

function GetPluginData(): TPluginData;
var
  dir: string;
  files: TStringList;
begin
  with result do
  begin
    Name := 'Themes';
    Description := 'Create and manage themes that customise the appearance of SharpE.';

    files := TStringList.Create;
    try
      dir := SharpApi.GetSharpeUserSettingsPath + 'Themes\';
      SharpFileUtils.FindFiles(files, dir, '*Theme.xml');
      Status := IntToStr(files.Count);
    finally
      files.Free;
    end;
  end;
end;

function InitPluginInterface(APluginHost: ISharpCenterHost): ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetPluginData,
  GetMetaData;

begin
end.

