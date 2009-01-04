{
Source Name: uMiniScmdWnd.pas
Description: MiniScmd Module Settings Window
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

unit uMiniScmdWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask, ISharpCenterHostUnit,
  SharpECenterHeader, JvXPCore, JvXPCheckCtrls;

type
  TfrmMiniScmd = class(TForm)
    plMain: TJvPageList;
    pagMiniScmd: TJvStandardPage;
    lblQuickSelect: TLabel;
    pnlSize: TPanel;
    sgb_width: TSharpeGaugeBox;
    scmQuickSelect: TSharpECenterHeader;
    scmSize: TSharpECenterHeader;
    cbQuickSelect: TJvXPCheckbox;
    procedure FormCreate(Sender: TObject);
    procedure cbQuickSelectClick(Sender: TObject);
    procedure sgb_widthChangeValue(Sender: TObject; Value: Integer);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateSettings;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write
      FPluginHost;
  end;

var
  frmMiniScmd: TfrmMiniScmd;

implementation

{$R *.dfm}

procedure TfrmMiniScmd.cbQuickSelectClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmMiniScmd.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmMiniScmd.sgb_widthChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings
end;

procedure TfrmMiniScmd.UpdateSettings;
begin
  if Visible then
    PluginHost.Save;
end;

end.

