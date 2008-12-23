﻿{
Source Name: SharpBarList
Description: SharpBar Manager Config Dll
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

library BarList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  Contnrs,
  graphics,
  JvSimpleXml,
  JvValidators,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  SharpApi,
  SharpCenterApi,
  SharpThemeApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uListWnd in 'uListWnd.pas' {frmListWnd},
  uEditWnd in 'uEditWnd.pas' {frmEditwnd};

{$E .dll}

{$R *.res}

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
  FreeAndNil(frmListWnd);
  FreeAndNil(frmEditWnd);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    frmEditWnd.Save;

  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'Create and manage toolbar configurations.';
end;

function TSharpCenterPlugin.GetPluginStatusText: String;
var
  items: TStringList;
begin
  result := '';
  items := TStringList.Create;
  try
    items.CommaText := XmlGetBarListAsCommaText();
    result := IntToStr(items.Count);
  finally
    items.Free;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmListWnd = nil then frmListWnd := TfrmListWnd.Create(nil);
  uVistaFuncs.SetVistaFonts(frmListWnd);

  frmListWnd.PluginHost := PluginHost;
  result := PluginHost.Open(frmListWnd);
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
  PluginHost.AssignThemeToForms(frmListWnd,frmEditWnd);
end;

procedure TSharpCenterPlugin.SetupValidators;
var
  tmp: TJvCustomValidator;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( frmEditWnd.edName,'Please enter a toolbar name','Text');
//  PluginHost.AddRequiredFieldValidator( frmEditWnd.edCommand,'Please enter a command name','Text');
//  PluginHost.AddRequiredFieldValidator( frmEditWnd.edHotkey,'Please enter hotkey','Text');
//
//  // Validator for checking duplicates
//  tmp := PluginHost.AddCustomValidator( frmEditWnd.edName,'There is already a hotkey with this name','Text');
//  tmp.OnValidate := ValidateNameExists;
//  tmp := PluginHost.AddCustomValidator( frmEditWnd.edHotkey,'There is already a command with this hotkey','Text');
//  tmp.OnValidate := ValidateHotkeyExists;
end;

procedure TSharpCenterPlugin.ValidateNameExists(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  idx: Integer;
  s: string;
begin
//  Valid := True;
//
//  s := '';
//  if ValueToValidate <> null then
//    s := VarToStr(ValueToValidate);
//
//  if s = '' then begin
//    Valid := False;
//    Exit;
//  end;
//
//  idx := FHotkeyList.IndexOfName(s);
//
//  if (idx <> -1) then begin
//
//    if frmEditWnd.ItemEdit <> nil then
//      if frmEditWnd.ItemEdit.Name = s then
//        exit;
//
//    Valid := False;
//  end;
end;

procedure TSharpCenterPlugin.ValidateHotkeyExists(Sender: TObject;
  ValueToValidate: Variant; var Valid: Boolean);
var
  idx: Integer;
  s: string;
begin
//  Valid := True;
//
//  s := '';
//  if ValueToValidate <> null then
//    s := VarToStr(ValueToValidate);
//
//  if s = '' then begin
//    Valid := False;
//    Exit;
//  end;
//
//  idx := FHotkeyList.IndexOfHotkey(s);
//
//  if (idx <> -1) then begin
//
//    if frmEditWnd.ItemEdit <> nil then
//      if frmEditWnd.ItemEdit.Hotkey = s then
//        exit;
//
//    Valid := False;
//  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Toolbars';
    Description := 'SharpBar List Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suSharpBar)]);
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