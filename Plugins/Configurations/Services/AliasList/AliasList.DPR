{
Source Name: Aliases
Description: Alias configuration list for SharpE
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

library AliasList;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  JvSimpleXml,
  ComCtrls,
  PngSpeedButton,
  uVistaFuncs,
  SysUtils,
  JvPageList,
  Graphics,
  SharpETabList,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SharpCenterApi,
  SharpApi,
  ItemsWnd in 'ItemsWnd.pas' {frmItemsWnd},
  EditWnd in 'EditWnd.pas' {frmEditWnd},
  uExecServiceAliasList in '..\..\..\Services\Exec\uExecServiceAliasList.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit )
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    function CloseEdit(AApply: Boolean): Boolean; stdcall;
    function OpenEdit: Cardinal; stdcall;

    function GetPluginDescriptionText: String; override; stdCall;
    procedure Refresh; override; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmItemsWnd);
  FreeAndNil(frmEditWnd);
end;

function TSharpCenterPlugin.CloseEdit(AApply: Boolean): Boolean;
begin
  Result := True;

  if frmEditWnd = nil then exit;

  // First validate
  if AApply then
    if Not(frmEditWnd.ValidateEdit) then begin
      Result := False;
      Exit;
    end;

  // If Validation ok then continue
  frmEditWnd.Save(AApply);

  // Refresh services
  SharpApi.ServiceMsg('exec','_refresh');

  FreeAndNil(frmEditWnd);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'Create command aliases for commonly used applications.';
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
  frmEditWnd.InitUi;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  AssignThemeToForms(PluginHost.Theme,frmItemsWnd,frmEditWnd, PluginHost.Editing);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Aliases';
    Description := 'Aliases Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.5.2';
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
