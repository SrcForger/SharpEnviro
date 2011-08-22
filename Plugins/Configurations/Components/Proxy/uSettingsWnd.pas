{
Source Name: uDeskAreaSettingsWnd.pas
Description: DeskArea Settings Window
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

unit uSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  StdCtrls, Menus, SharpApi, ExtCtrls, Buttons, Math,
  GR32, SharpCenterApi, SharpGraphicsUtils, SharpEGaugeBoxEdit,
  Types, SharpECenterHeader, ISharpCenterHostUnit, graphicsFx, JvExControls,
  JvXPCore, JvXPCheckCtrls,
  uSharpHTTP;

type
  TfrmSettings = class(TForm)
    Panel1: TPanel;
    SharpECenterHeader1: TSharpECenterHeader;
    chkUseProxy: TJvXPCheckbox;
    edAddress: TEdit;
    Label1: TLabel;
    Port: TLabel;
    edPort: TEdit;
    pnlUseProxy: TPanel;

    procedure FormCreate(Sender: TObject);
    procedure chkUseProxyClick(Sender: TObject);
    procedure edAddressChange(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    
  private
    FPluginHost: ISharpCenterHost;
    FHTTP: TSharpHTTP;

    procedure SendUpdate;

  public
    procedure LoadSettings;
    procedure SaveSettings;

    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;

  end;

var
  frmSettings: TfrmSettings;
  DAList : TList;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }
procedure TfrmSettings.chkUseProxyClick(Sender: TObject);
begin
  edAddress.Enabled := chkUseProxy.Checked;
  edPort.Enabled := chkUseProxy.Checked;

  SendUpdate;
end;

procedure TfrmSettings.edAddressChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.edPortChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  FHTTP := TSharpHTTP.Create;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

procedure TfrmSettings.LoadSettings;
begin
  FHTTP.LoadSettings;

  chkUseProxy.Checked := FHTTP.ProxyEnabled;

  edAddress.Enabled := chkUseProxy.Checked;
  edPort.Enabled := chkUseProxy.Checked;

  edAddress.Text := FHTTP.ProxyAddress;
  edPort.Text := FHTTP.ProxyPort;
end;

procedure TfrmSettings.SaveSettings;
begin
  FHTTP.ProxyEnabled := chkUseProxy.Checked;
  FHTTP.ProxyAddress := edAddress.Text;
  FHTTP.ProxyPort := edPort.Text;

  FHTTP.SaveSettings;
end;

end.

