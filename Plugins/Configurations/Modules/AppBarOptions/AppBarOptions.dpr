{
Source Name: AppBarOptions.dpr
Description: ApplicationBar Module Options Config
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

library AppBarOptions;
uses
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  SharpThemeApiEx,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  SettingsWnd in 'SettingsWnd.pas' {frmSettings};

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
  PluginHost.Xml.XmlRoot.Name := 'AppBarModuleSettings';

  if PluginHost.Xml.Load then // reload in case buttons have changed via drag and drop
  with PluginHost.Xml.XmlRoot.Items, frmSettings do
  begin
    // Do not clear the list as the AppBarModule also saves to this file.

    if ItemNamed['TaskPreview'] <> nil then
      ItemNamed['TaskPreview'].BoolValue := chkTaskPreviews.Checked
    else Add('TaskPreview',chkTaskPreviews.Checked);

    if ItemNamed['TPLockKey'] <> nil then
      ItemNamed['TPLockKey'].IntValue := cbLockKey.ItemIndex
    else Add('TPLockKey',cbLockKey.ItemIndex);

    if ItemNamed['State'] <> nil then
      ItemNamed['State'].IntValue := cbStyle.ItemIndex
    else
      Add('State', cbStyle.ItemIndex);

    if ItemNamed['CountOverlay'] <> nil then
      ItemNamed['CountOverlay'].BoolValue := chkOverlay.Checked
    else
      Add('CountOverlay', chkOverlay.Checked);

    if ItemNamed['VWMOnly'] <> nil then
      ItemNamed['VWMOnly'].BoolValue := chkVWM.Checked
    else
      Add('VWMOnly', chkVWM.Checked);

    if ItemNamed['MonitorOnly'] <> nil then
      ItemNamed['MonitorOnly'].BoolValue := chkMonitor.Checked
    else
      Add('MonitorOnly', chkMonitor.Checked);

    if ItemNamed['LockDragDrop'] <> nil then
      ItemNamed['LockDragDrop'].BoolValue := not chkDragDrop.Checked
    else Add('LockDragDrop', not chkDragDrop.Checked);
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmSettings do
    begin
      chkTaskPreviews.Checked := BoolValue('TaskPreview',True);
      cbLockKey.ItemIndex := IntValue('TPLockKey',1);
      chkOverlay.Checked := BoolValue('CountOverlay', True);
      cbStyle.ItemIndex := IntValue('State', 2);
      chkVWM.Checked := BoolValue('VWMOnly', False);
      chkMonitor.Checked := BoolValue('MonitorOnly',False);
      chkDragDrop.Checked := not BoolValue('LockDragDrop', False);
    end;
  end;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmSettings = nil then frmSettings := TfrmSettings.Create(nil);
  frmSettings.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmSettings);

  Load;
  result := PluginHost.Open(frmSettings);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Application Bar Module Options';
    Description := 'Application Bar Module Options Config';
    Author := 'Lee Green (lee@sharpenviro.com)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmApply),
      Integer(suModule)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with Result do
  begin
    Name := 'Options';
    Description := 'Configure the global options for the Application Bar module';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettings,AEditing,Theme);
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

