{
Source Name: MultiMediaInputList.dpr
Description: AppCommandList configuration
Copyright (C) Martin Krämer(MartinKraemer@gmx.net)

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

library MultimediaInputList;
uses
  Forms,
  windows,
  dialogs,
  graphics,
  sysutils,
  variants,
  SharpCenterApi,
  SharpAPI,
  JclSimpleXml,
  uSharpXMLUtils,
  jvValidators,
  uVistaFuncs,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',
  uItemsWnd in 'uItemsWnd.pas' {frmItemsWnd},
  uEditWnd in 'uEditWnd.pas' {frmEditWnd},
  uAppCommandList in '..\..\..\Services\MultimediaInput\uAppCommandList.pas';

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit)
  private
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
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

  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
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

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToForms(frmItemsWnd,frmEditWnd,AEditing,Theme);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Media Command List';
    Description := 'Assign special actions to commands of multimedia input devices such as keyboards or remote controls.';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),Integer(suMMInput)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
var
  xml : TJclSimpleXml;
  itemCount: integer;
begin
  with result do
  begin
    Name := 'Media Command List';
    Description := 'Assign special actions to commands of multimedia input devices such as keyboards or remote controls.';
    Status := '';

    xml := TJclSimpleXml.Create;
    if LoadXMLFromSharedFile(XML,SharpApi.GetSharpeUserSettingsPath + sAppCommandListSettingsDir + sAppCommandListSettingsFile,True) then
    begin
      itemCount := xml.Root.Items.Count;
      Status := IntToStr(itemCount);
    end;
    xml.Free;
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

