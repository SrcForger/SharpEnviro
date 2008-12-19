{
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

library ServiceList;
uses
  Controls,
  Classes,
  ComCtrls,
  Windows,
  Forms,
  Dialogs,
  Contnrs,
  graphics,
  JvSimpleXml,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uComponentMan,
  listWnd in 'listWnd.pas' {frmList};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginTabs )
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;

    procedure ClickPluginTab(ATab: TStringItem); stdCall;
    procedure AddPluginTabs(ATabItems: TStringList); stdCall;
    procedure Refresh; override; stdcall;

    function GetPluginStatusText : string; override; stdcall;
    function GetPluginName : string; override; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.AddPluginTabs(ATabItems: TStringList);
begin
  ATabItems.AddObject('All',TObject(aiAll));
  ATabItems.AddObject('Filter Configurable',TObject(aiEditable));
  ATabItems.AddObject('Filter Disabled',TObject(aiDisabled));
end;

procedure TSharpCenterPlugin.ClickPluginTab(ATab: TStringItem);
var
  tmp: TAddItemsType;
begin
  tmp := TAddItemsType(ATab.FObject);
  frmList.AddItems(tmp);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmList);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginName: string;
begin
  result := 'Services';
end;

function TSharpCenterPlugin.GetPluginStatusText: string;
var
  tmpList: TComponentList;
begin
  tmpList := TComponentList.Create;
  Try
    tmpList.BuildList('.service',false);
    result := IntToStr(tmpList.Count);
  Finally
    tmpList.Free;
  End;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmList = nil then frmList := TfrmList.Create(nil);
  uVistaFuncs.SetVistaFonts(frmList);

  result := PluginHost.Open(frmList);
  frmList.PluginHost := PluginHost;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForm(PluginHost.Theme,frmList);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Service Manager';
    Description := 'Manage and configure the SharpE Service providers';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suService)]);
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

