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
  ShareMem,
  Controls,
  Classes,
  Windows,
  Forms,
  uVistaFuncs,
  SysUtils,
  Graphics,
  SharpApi,
  SharpCenterApi,
  uComponentMan in '..\..\..\..\Components\SharpCore\uComponentMan.pas',
  ISharpCenterHostUnit,
  ISharpCenterPluginUnit,
  uSharpCenterPluginScheme,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uSettingsWnd in 'uSettingsWnd.pas' {frmSettings};

{$E .dll}

{$R 'VersionInfo.res'}
{$R *.res}

type
  TSharpCenterPlugin = class( TInterfacedSharpCenterPlugin )
  private
    FComponentList : TComponentList;

    procedure Load;
    procedure UpdateService;
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
  FComponentList.Free;
end;

constructor TSharpCenterPlugin.Create(APluginHost: ISharpCenterHost);
begin
  PluginHost := APluginHost;

  FComponentList := TComponentList.Create;
end;

procedure TSharpCenterPlugin.Load;
var
  i : integer;
begin
  FComponentList.BuildList('.dll', false, true);
  FComponentList.Sort(CustomSort);

  frmSettings.chkEnable.Checked := True;

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

  for i := 0 to FComponentList.Count - 1 do
  begin
    if TComponentData(FComponentList[i]).MetaData.Name = 'VWM' then
    begin
      if (TComponentData(FComponentList[i]).Disabled) then
        frmSettings.chkEnable.Checked := False;
    end;
  end;

  frmSettings.pnlEnabled.Visible := frmSettings.chkEnable.Checked;
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
  PluginHost.Xml.XmlRoot.Name := 'VWMServiceSettings';
  with PluginHost.Xml.XmlRoot.Items, frmSettings do
  begin
    Clear;
    Add('VWMCount',sgbVwmCount.Value);
    Add('FocusTopMost',chkFocusTopMost.Checked);
    Add('MoveToolWindows',chkToolWindows.Checked);
    Add('FollowFocus',chkFollowFocus.Checked);
    Add('ShowOCD',chkNotifications.Checked);
    Add('ResetOnDisplayChange',chkResetOnDisplayChange.Checked);
  end;
  PluginHost.Xml.Save;

  UpdateService;

  frmSettings.pnlEnabled.Visible := frmSettings.chkEnable.Checked;
end;

procedure TSharpCenterPlugin.UpdateService;
var
  i : integer;
  tmp : TComponentData;
begin
  for i := 0 to FComponentList.Count - 1 do
  begin
    tmp := TComponentData(FComponentList[i]);
    if tmp.MetaData.Name = 'VWM' then
    begin
      if (not frmSettings.chkEnable.Checked) then
      begin
        if not tmp.Disabled then
          tmp.Disabled := True;

        ServiceStop(tmp.MetaData.Name);
      end else if (frmSettings.chkEnable.Checked) then
      begin
        if tmp.Disabled then
          tmp.Disabled := False;

        ServiceStart(tmp.MetaData.Name);
      end;
    end;
  end;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Virtual Desktops';
    Description := 'VWM Service Configuration';
    Author := 'Martin Krämer (MartinKraemer@gmx.net)';
    Version := '0.8.0.0';
    DataType := tteConfig;
    ExtraData := format('configmode: %d| configtype: %d',[Integer(scmLive),
      Integer(suVWM)]);
  end;
end;

function GetPluginData(pluginID : String): TPluginData;
begin
  with result do
  begin
    Name := 'Virtual Desktops';
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
