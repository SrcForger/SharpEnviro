{
Source Name: uConfigWnd.pas
Description: RSS Reader Module Settings Window
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

unit uConfigWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, SharpApi, SharpCenterAPI,
  SharpECenterHeader, ISharpCenterHostUnit, SharpEGaugeBoxEdit,
  JvExControls, JvXPCore, JvXPCheckCtrls, SharpEBaseControls, SharpEEdit,
  ExtCtrls;

type
  TfrmConfig = class(TForm)
    SharpECenterHeader1: TSharpECenterHeader;
    Panel2: TPanel;
    Label1: TLabel;
    cbSizePref: TComboBox;
    gbSize: TSharpeGaugeBox;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure UpdateSettingsEvent(Sender: TObject);
    procedure gbSizeChangeValue(Sender: TObject; Value: Integer);
    procedure cbSizePrefChange(Sender: TObject);

  private
    FPluginHost: ISharpCenterHost;

    procedure UpdateSettings;

  public
    barID, moduleID: String;
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;

    procedure UpdateSize;
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

procedure TfrmConfig.UpdateSettingsEvent(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmConfig.UpdateSize;
var
  rc: TRect;
  wnd: HWND;
begin
  if cbSizePref.ItemIndex = 1 then
  begin
    frmConfig.gbSize.Max := 100;
    frmConfig.gbSize.Min := 0;

    if frmConfig.gbSize.Value > 100 then
      frmConfig.gbSize.Value := 100;
  end else
  begin
    rc := Rect(0, 0, 100, 0);

    wnd := FindWindow('TSharpBarMainForm', PChar('SharpBar_' + barID));
    if wnd <> 0 then
      Windows.GetClientRect(wnd, rc);

    frmConfig.gbSize.Max := rc.Right;
    frmConfig.gbSize.Min := rc.Left;

    if frmConfig.gbSize.Value > rc.Right then
      frmConfig.gbSize.Value := rc.Right;
  end;
end;

procedure TfrmConfig.cbSizePrefChange(Sender: TObject);
begin
  UpdateSize;

  UpdateSettings;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmConfig.gbSizeChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmConfig.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;


end.

