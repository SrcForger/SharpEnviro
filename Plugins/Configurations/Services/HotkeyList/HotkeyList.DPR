{
Source Name: HotkeyLsit
Description: HotkeyList configuration
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

library HotkeyList;
uses
  Forms,
  windows,
  dialogs,
  graphics,
  sysutils,
  variants,
  SharpCenterApi,
  SharpAPI,
  jvSimpleXml,
  jvValidators,
  uVistaFuncs,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uHotkeyServiceList in 'uHotkeyServiceList.pas',
  uItemsWnd in 'uItemsWnd.pas' {frmItemsWnd},
  uEditWnd in 'uEditWnd.pas' {frmEditWnd},
  uHotkeyServiceGeneral in 'uHotkeyServiceGeneral.pas';

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
    procedure ValidateHotkeyExists(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
    procedure ValidateNameExists(Sender: TObject; ValueToValidate: Variant;
      var Valid: Boolean);
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;

    function GetPluginDescriptionText: String; override; stdCall;
    function GetPluginStatusText: String; override; stdCall;
    procedure Refresh; override; stdcall;
    procedure SetupValidators; stdcall;

  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmItemsWnd);
  FreeAndNil(frmEditWnd);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    frmEditWnd.Save;

  // Refresh hotkeys
  BroadcastGlobalUpdateMessage(suHotkey);

  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'Create system wide hotkeys using actions, or commonly used applications.';
end;

function TSharpCenterPlugin.GetPluginStatusText: String;
var
  fn: string;
  itemCount: integer;
begin
  result := '';
  fn := GetSharpeUserSettingsPath + cSettingsLocation;
  PluginHost.Xml.XmlFilename := fn;

  if PluginHost.Xml.Load then begin
    itemCount := PluginHost.Xml.XmlRoot.Items.Count;
    result := IntToStr(ItemCount);
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmItemsWnd = nil then frmItemsWnd := TfrmItemsWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmItemsWnd);

  frmItemsWnd.PluginHost := PluginHost;
  result := PluginHost.Open(frmItemsWnd);
end;

function TSharpCenterPlugin.OpenEdit: Cardinal;
begin
  if frmEditWnd = nil then frmEditWnd := TfrmEditWnd.Create(nil);
  frmEditWnd.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(frmEditWnd);

  result := PluginHost.OpenEdit(frmEditWnd);
  frmEditWnd.Init;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForms(PluginHost.Theme,frmItemsWnd,frmEditWnd, PluginHost.Editing);
end;

procedure TSharpCenterPlugin.SetupValidators;
var
  tmp: TJvCustomValidator;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edName,'Please enter a hotkey name','Text');
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edCommand,'Please enter a command name','Text');
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edHotkey,'Please enter hotkey','Text');

  // Validator for checking duplicates
  tmp := PluginHost.AddCustomValidator( frmEditWnd.edName,'There is already a hotkey with this name','Text');
  tmp.OnValidate := ValidateNameExists;
  tmp := PluginHost.AddCustomValidator( frmEditWnd.edHotkey,'There is already a command with this hotkey','Text');
  tmp.OnValidate := ValidateHotkeyExists;
end;

procedure TSharpCenterPlugin.ValidateNameExists(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  idx: Integer;
  s: string;
begin
  Valid := True;

  s := '';
  if ValueToValidate <> null then
    s := VarToStr(ValueToValidate);

  if s = '' then begin
    Valid := False;
    Exit;
  end;

  idx := FHotkeyList.IndexOfName(s);

  if (idx <> -1) then begin

    if frmEditWnd.ItemEdit <> nil then
      if frmEditWnd.ItemEdit.Name = s then
        exit;

    Valid := False;
  end;
end;

procedure TSharpCenterPlugin.ValidateHotkeyExists(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  idx: Integer;
  s: string;
begin
  Valid := True;

  s := '';
  if ValueToValidate <> null then
    s := VarToStr(ValueToValidate);

  if s = '' then begin
    Valid := False;
    Exit;
  end;

  idx := FHotkeyList.IndexOfHotkey(s);

  if (idx <> -1) then begin

    if frmEditWnd.ItemEdit <> nil then
      if frmEditWnd.ItemEdit.Hotkey = s then
        exit;

    Valid := False;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Hotkeys';
    Description := 'Hotkey List Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suHotkey)]);
  end;
end;


function InitPluginInterface( APluginHost: TInterfacedSharpCenterHostBase ) : ISharpCenterPlugin;
begin
  result := TSharpCenterPlugin.Create(APluginHost);
end;

exports
  InitPluginInterface,
  GetMetaData;

begin
end.

