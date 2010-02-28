{
Source Name: MiniScmd
Description: MiniScmd Module Config Dll
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

library MiniScmd;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  Math,
  Dialogs,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpAPI,
  SharpCenterAPI,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  uMiniScmdWnd in 'uMiniScmdWnd.pas' {frmMiniScmd};

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
  PluginHost.GetBarModuleIdFromPluginId( barID, moduleID);
end;

procedure TSharpCenterPlugin.Save;
begin
  PluginHost.Xml.XmlRoot.Name := 'MiniScmdModuleSettings';

  with PluginHost.Xml.XmlRoot.Items, frmMiniScmd do
  begin
    // Clear the list so we don't get duplicates.
    Clear;

    Add('Width', sgb_width.Value);
    Add('Button', cbQuickSelect.Checked);
    Add('ButtonRight', (cboButtonPos.ItemIndex = 1));
    Add('AutoComplete', cbEnableAutoCom.Checked);
  end;

  PluginHost.Xml.Save;
end;

procedure TSharpCenterPlugin.Load;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpBar\Bars\' + barID + '\' + moduleID + '.xml';
  
  frmMiniScmd.moduleID := StrToInt(moduleID);

  if PluginHost.Xml.Load then
  begin
    with PluginHost.Xml.XmlRoot.Items, frmMiniScmd do
    begin
      sgb_width.Value := IntValue('Width', 100);
      cbQuickSelect.Checked := BoolValue('Button', True);
      if BoolValue('ButtonRight',True) then
        cboButtonPos.ItemIndex := 1
      else cboButtonPos.ItemIndex := 0;

      cbEnableAutoCom.Checked := BoolValue('AutoComplete', True);
    end;
  end;
  frmMiniScmd.UpdateGUI;
end;

function TSharpCenterPlugin.Open: Cardinal;
begin
  if frmMiniScmd = nil then frmMiniScmd := TfrmMiniScmd.Create(nil);
  frmMiniScmd.PluginHost := PluginHost;
  uVistaFuncs.SetVistaFonts(frmMiniScmd);

  Load;
  result := PluginHost.Open(frmMiniScmd);
end;

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmMiniScmd);
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Mini SCmd';
    Description := 'Mini SCmd Module Configuration';
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
	Name := 'Mini SCmd';
    Description := 'Configure the Mini SCmd module';
	Status := '';
  end;
end;

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmMiniScmd,AEditing,Theme);
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

