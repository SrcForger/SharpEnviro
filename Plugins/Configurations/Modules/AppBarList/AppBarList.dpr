﻿{
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

library AppBarList;
uses
  Windows,
  Messages,
  SysUtils,
  Forms,
  Variants,
  Classes,
  ImgList,
  Controls,
  Graphics,
  uVistaFuncs,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  SharpCenterApi,
  SharpApi,
  jvValidators,
  uListWnd in 'uListWnd.pas' {frmList},
  uEditWnd in 'uEditWnd.pas' {frmEdit},
  uAppBarList in 'uAppBarList.pas';

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin, ISharpCenterPluginEdit,
    ISharpCenterPluginValidation )
  private
  public
    constructor Create( APluginHost: TInterfacedSharpCenterHostBase );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure CloseEdit(AApply: Boolean); stdcall;
    function OpenEdit: Cardinal; stdcall;
    procedure Save; override; stdCall;

    function GetPluginDescriptionText: String; override; stdCall;
    function GetPluginStatusText: String; override; stdCall;
    function GetPluginName: String; override; stdCall;
    procedure Refresh; override; stdcall;
    procedure SetupValidators; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmList);
  FreeAndNil(FrmEdit);
end;

procedure TSharpCenterPlugin.CloseEdit(AApply: Boolean);
begin
  if AApply then
    FrmEdit.Save;

  FreeAndNil(FrmEdit);
end;

constructor TSharpCenterPlugin.Create(APluginHost: TInterfacedSharpCenterHostBase);
begin
  PluginHost := APluginHost;
end;

function TSharpCenterPlugin.GetPluginDescriptionText: String;
begin
  Result := 'Create and manage items for the application bar module';
end;

function TSharpCenterPlugin.GetPluginName: String;
begin
  Result := 'Applications';
end;

function TSharpCenterPlugin.GetPluginStatusText: String;
var
  items:  TAppBarList;
begin
  items := TAppBarList.Create;
  items.Filename := PluginHost.GetModuleXmlFilename;
  try
    items.load;
    Result := inttostr(items.Count);
  finally
    items.free;
  end;
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
  if FrmEdit = nil then FrmEdit := TFrmEdit.Create(nil);
  FrmEdit.PluginHost := Self.PluginHost;
  uVistaFuncs.SetVistaFonts(FrmEdit);

  result := PluginHost.OpenEdit(FrmEdit);
  FrmEdit.Init;
end;

procedure TSharpCenterPlugin.Refresh;
begin
  PluginHost.AssignThemeToForms(frmList,FrmEdit);
  frmList.UpdateImages;
end;

procedure TSharpCenterPlugin.Save;
begin
  frmList.Items.Save;
end;

procedure TSharpCenterPlugin.SetupValidators;
begin
  // Can not leave fields blank
  PluginHost.AddRequiredFieldValidator( FrmEdit.edName,'Please enter a name for the application','Text');
  PluginHost.AddRequiredFieldValidator( FrmEdit.edCommand,'Please enter a file path for the application','Text');
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Application Bar list';
    Description := 'Application Bar List Edit Configuration';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.7.6.0';
    DataType := tteConfig;

    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suModule)]);
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