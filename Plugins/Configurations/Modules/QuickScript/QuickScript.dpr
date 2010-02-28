{
Source Name: QuickScript
Description: QuickScript Module Config Dll
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

library QuickScript;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  JvPageList,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uQuickScriptWnd in 'uQuickScriptWnd.pas' {frmQuickScript};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    barID : string;
    moduleID : string;
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdcall;
    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdCall;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
  PluginHost.GetBarModuleIdFromPluginId(barID, moduleID);
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlRoot.Name := 'QuickScriptModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmQuickScript do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    Add('Caption', ((cboDisplay.ItemIndex = 0) or ( cboDisplay.ItemIndex = 2)));
    Add('Icon', ((cboDisplay.ItemIndex = 0) or ( cboDisplay.ItemIndex = 1)));
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
var
  ShowIcon, ShowCaption : boolean;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmQuickScript do
    begin
      ShowIcon := BoolValue('Icon',True);
      ShowCaption := BoolValue('Caption',True);
      if ShowIcon and ShowCaption then
        cboDisplay.ItemIndex := 0
      else if ShowCaption then
        cboDisplay.ItemIndex := 2
      else cboDisplay.ItemIndex := 1;
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmQuickScript = nil then frmQuickScript := TfrmQuickScript.Create(nil);
  frmQuickScript.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmQuickScript);

  Load;
  result := PluginHost.Open(frmQuickScript);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmQuickScript);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Quick Script';
    Description := 'Quick Script Module Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(): TPluginData;
begin
  with Result do
  begin
    Description := 'Configure the Quick Script module';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmQuickScript,AEditing,Theme);
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

