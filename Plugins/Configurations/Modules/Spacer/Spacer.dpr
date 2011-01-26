{
Source Name: Spacer
Description: Spacer Module Config Dll
Copyright (C) Mathias Tillman (mathias@sharpenviro.com)

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

library Spacer;
uses
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  Dialogs,
  uVistaFuncs,
  SysUtils,
  DateUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uConfigWnd in 'uConfigWnd.pas' {frmConfig};

{$E .dll}
                      
{$R 'VersionInfo.res'}
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
  with PluginHost.Xml.XmlRoot do
  begin
    Name := 'Spacer';

    // Clear the list so we don't get duplicates.
    Items.Clear;

    Items.Add('Settings');
    with Items.ItemNamed['Settings'].Items do
    begin
      Add('Size', frmConfig.gbSize.Value);
      Add('Percentage', (frmConfig.cbSizePref.ItemIndex = 1));
    end;  

    PluginHost.Xml.Save;
  end;
end;

procedure TSharpCenterPlugin.Load;
begin
  frmConfig.cbSizePref.ItemIndex := 0;
  frmConfig.gbSize.Value := 10;
  frmConfig.UpdateSize;

  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot do
    begin
      if Items.ItemNamed['Settings'] <> nil then
        with Items.ItemNamed['Settings'].Items do
        begin
          frmConfig.gbSize.Value := IntValue('Size', 10);
          if BoolValue('Percentage', False) then
            frmConfig.cbSizePref.ItemIndex := 1
          else
            frmConfig.cbSizePref.ItemIndex := 0;

          frmConfig.UpdateSize;
        end;
    end;
  end else
    Save;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmConfig = nil then
    frmConfig := TfrmConfig.Create(nil);

  frmConfig.barID := barID;
  frmConfig.moduleID := moduleID;
  frmConfig.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmConfig);

  Load;
  result := PluginHost.Open(frmConfig);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmConfig);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Spacer';
    Description := 'Spacer Module Configuration';
    Author := 'Mathias Tillman (mathias@sharpenviro.com)';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
	Name := 'Spacer';
    Description := 'Configure the Spacer';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmConfig,AEditing,Theme);
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

