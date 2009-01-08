﻿{
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
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask, pngimage, SharpERoundPanel,
  SharpECenterHeader, JvXPCore, JvXPCheckCtrls, ISharpCenterHostUnit;

type
  TfrmSettings = class(TForm)
    plMain: TJvPageList;
    pagNotes: TJvStandardPage;
    Panel7: TPanel;
    sgbWidth: TSharpeGaugeBox;
    SharpECenterHeader3: TSharpECenterHeader;
    SharpECenterHeader4: TSharpECenterHeader;
    SharpECenterHeader6: TSharpECenterHeader;
    chkButtonCaption: TJvXPCheckbox;
    chkButtonIcon: TJvXPCheckbox;
    procedure GaugeBoxChange(Sender: TObject; Value: Integer);
    procedure CheckClick(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateSettings;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
  end;

var
  frmSettings: TfrmSettings;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmSettings.CheckClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmSettings.GaugeBoxChange(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmSettings.UpdateSettings;
begin
  if Visible then
    PluginHost.Save;
end;

end.

