{
Source Name: VWM.dpr
Description: VWM Service Config DLL
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

library VWM;
uses
  Controls,
  Classes,
  Windows,
  Forms,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpApi,
  SharpCenterApi,
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog,{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings};

{$E .dll}

{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    procedure Load;
  public
    constructor Create( APluginHost: ISharpCenterHost );

    function Open: Cardinal; override; stdcall;
    procedure Close; override; stdcall;
    procedure Save; override; stdCall;

    procedure Refresh(Theme : TCenterThemeInfo; AEditing: Boolean); override; stdcall;
  end;

{ TSharpCenterPlugin }

procedure TSharpCenterPlugin.Close;
begin
  FreeAndNil(frmSettings);
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;
end;

procedure TSharpCenterPlugin.Load;
begin
  PluginHost.Xml.XmlFilename := GetSharpeUserSettingsPath + 'SharpCore\Services\VWM\VWM.xml';
  if PluginHost.Xml.Load then begin
    with PluginHost.Xml.XmlRoot, frmSettings do begin
      sgbVwmCount.Value := Items.IntValue('VWMCount',4);
      chkFocusTopMost.Checked := Items.BoolValue('FocusTopMost',False);
      chkToolWindows.Checked := Items.BoolValue('MoveToolWindows',True);
      chkFollowFocus.Checked := Items.BoolValue('FollowFocus',False);
      chkNotifications.Checked := Items.BoolValue('ShowOCD',True);
      chkResetOnDisplayChange.Checked := Items.BoolValue('ResetOnDisplayChange', True);      
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

procedure TSharpCenterPlugin.Refresh(Theme : TCenterThemeInfo; AEditing: Boolean);
begin
  AssignThemeToPluginForm(frmSettings,AEditing,Theme);
end;

procedure TSharpCenterPlugin.Save;
begin
  with PluginHost.Xml.XmlRoot, frmSettings do
  begin
    Name := 'VWMServiceSettings';
    Items.Clear;
    Items.Add('VWMCount',sgbVwmCount.Value);
    Items.Add('FocusTopMost',chkFocusTopMost.Checked);
    Items.Add('MoveToolWindows',chkToolWindows.Checked);
    Items.Add('FollowFocus',chkFollowFocus.Checked);
    Items.Add('ShowOCD',chkNotifications.Checked);
    Items.Add('ResetOnDisplayChange',chkResetOnDisplayChange.Checked);

    PluginHost.Xml.Save;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Virtual Destops';
    Description := 'VWM Service Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.7.6.5';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suVWM)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Virtual Destops';
    Description := 'Manage application windows across multiple workspaces.';
    Status := '';
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
