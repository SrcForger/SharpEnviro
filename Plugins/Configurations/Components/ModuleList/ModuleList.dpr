{
Source Name: ModuleManager
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

library ModuleList;
uses
  Controls,
  Classes,
  Contnrs,
  Windows,
  Forms,
  Dialogs,
  graphics,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  SharpCenterApi,
  SharpApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uListWnd in 'uListWnd.pas' {frmListWnd},
  uEditWnd in 'uEditWnd.pas' {frmEditWnd};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit )
  private
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;

    function GetPluginName: string; override; stdCall;
    function GetPluginDescriptionText: String; override; stdCall;
    function GetPluginStatusText: string; override; stdCall;
    procedure Refresh; override; stdcall;

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

  frmListWnd.BuildModuleList;
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
var
  sBar: String;
begin
  sBar := ExtractBarName(PluginHost.PluginId);
  if sBar = '' then sBar := PluginHost.PluginId;
  result := Format('Module Configuration for "%s"',[sBar]);
end;

function TSharpCenterPlugin.GetPluginName: string;
begin
  result := 'Modules';
end;

function TSharpCenterPlugin.GetPluginStatusText: string;
var
  tmp:TObjectList;
begin
  tmp := TObjectList.Create;
  try
    AddItemsToList(PluginHost.PluginId,tmp);
    result := IntToStr(tmp.Count);
  finally
    tmp.Free;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
var
  sBar: String;
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
  AssignThemeToForms(PluginHost.Theme,frmListWnd,frmEditWnd, PluginHost.Editing);
  PluginHost.SetEditTabVisibility(scbEditTab,false);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Module Manager';
    Description := 'Module Manager Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
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
