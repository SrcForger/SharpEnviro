{
Source Name: uOptionsWnd.pas
Description: Options Window
Copyright (C) Lee Green (lee@sharpenviro.com)

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
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Contnrs,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ImgList,
  PngImageList,
  JvSimpleXml,

  SharpEListBoxEx,
  SharpEColorEditorEx,
  SharpEColorEditor,
  SharpEGaugeBoxEdit,
  ExtCtrls,
  JvExStdCtrls,
  JvCheckBox,
  SharpESwatchManager,
  ISharpCenterHostUnit;

type
  TfrmSettingsWnd = class(TForm)
    sceGlassOptions: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
    tmrRefresh: TTimer;
    procedure tmrRefreshTimer(Sender: TObject);
    procedure sceGlassOptionsUiChange(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    FIsUpdating: boolean;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
    property IsUpdating: boolean read FIsUpdating write FIsUpdating;
  end;

var
  frmSettingsWnd: TfrmSettingsWnd;

implementation

uses SharpThemeApi,
  SharpCenterApi, SharpApi;

{$R *.dfm}

procedure TfrmSettingsWnd.sceGlassOptionsUiChange(Sender: TObject);
begin
  tmrRefresh.Enabled := true;
end;

procedure TfrmSettingsWnd.tmrRefreshTimer(Sender: TObject);
begin
  tmrRefresh.Enabled := false;
  if Not(FIsUpdating) then
    FPluginHost.Save;
end;

end.

