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

unit uBatteryMonitorWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi, SharpCenterAPI,
  ExtCtrls,  SharpEGaugeBoxEdit, SharpECenterHeader, JvPageList, JvExControls,
  JvXPCheckCtrls, JvExStdCtrls, JvXPCore, ISharpCenterHostUnit;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmBMon = class(TForm)
    plMain: TJvPageList;
    pagNotes: TJvStandardPage;
    SharpECenterHeader1: TSharpECenterHeader;
    cb_icon: TJvXPCheckbox;
    procedure FormCreate(Sender: TObject);
    procedure cb_iconClick(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateSettings;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
  end;

var
  frmBMon: TfrmBMon;

implementation

{$R *.dfm}

procedure TfrmBMon.cb_iconClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmBMon.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmBMon.UpdateSettings;
begin
  if Visible then
    PluginHost.Save;
end;

end.

