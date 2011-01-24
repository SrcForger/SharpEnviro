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
    procedure FormCreate(Sender: TObject);
    procedure UpdateSettingsEvent(Sender: TObject);

  private
    FPluginHost: ISharpCenterHost;

    procedure UpdateSettings;

  public
    ModuleID: string;
    BarID : string;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmConfig: TfrmConfig;

implementation

{$R *.dfm}

procedure TfrmConfig.UpdateSettingsEvent(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmConfig.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;


end.

