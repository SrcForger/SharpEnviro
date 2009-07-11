{
Source Name: uBatteryMonitor.pas
Description: BatteryMonitor Module Settings Window
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

unit SettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StdCtrls, SharpApi, SharpECenterHeader, DwmApi,
  ExtCtrls, Menus, SharpEGaugeBoxEdit,
  JvExControls, JvXPCore, JvXPCheckCtrls, ISharpCenterHostUnit;

type
  TfrmSettings = class(TForm)
    chkOverlay: TJvXPCheckbox;
    Panel1: TPanel;
    pnlStyleAndSort: TPanel;
    lblStyle: TLabel;
    cbStyle: TComboBox;
    schTaskOptions: TSharpECenterHeader;
    SharpECenterHeader1: TSharpECenterHeader;
    Panel2: TPanel;
    chkVWM: TJvXPCheckbox;
    SharpECenterHeader2: TSharpECenterHeader;
    Panel3: TPanel;
    chkMonitor: TJvXPCheckbox;
    SharpECenterHeader3: TSharpECenterHeader;
    Panel4: TPanel;
    chkTaskPreviews: TJvXPCheckbox;
    Panel5: TPanel;
    Label1: TLabel;
    cbLockKey: TComboBox;
    procedure CheckClick(Sender: TObject);
    procedure cbStyleClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    procedure UpdateSettings;
  public
    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

var
  frmSettings: TfrmSettings;

implementation

uses
  SharpThemeApiEx,
  SharpCenterApi;

{$R *.dfm}

procedure TfrmSettings.cbStyleClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmSettings.CheckClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  chkTaskPreviews.Enabled := DwmApi.DwmCompositionEnabled;
  cbLockKey.Enabled := chkTaskPreviews.Enabled;
  Label1.Enabled := chkTaskPreviews.Enabled;
end;

procedure TfrmSettings.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

end.

