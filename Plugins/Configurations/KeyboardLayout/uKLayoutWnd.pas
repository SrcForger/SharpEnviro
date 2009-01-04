{
Source Name: uKLayoutWnd.pas
Description: Keyboard Layout Module Settings Window
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

unit uKLayoutWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask, ISharpCenterHostUnit,
  SharpECenterHeader, JvXPCore, JvXPCheckCtrls;

type
  TfrmKLayout = class(TForm)
    plMain: TJvPageList;
    pagKLayout: TJvStandardPage;
    lblIcon: TLabel;
    lblTLC: TLabel;
    schDisplayOptions: TSharpECenterHeader;
    chkIcon: TJvXPCheckbox;
    chkTLC: TJvXPCheckbox;
    procedure FormCreate(Sender: TObject);
    procedure cbIconClick(Sender: TObject);
  private
    FPluginHost: TInterfacedSharpCenterHostBase;
    procedure UpdateSettings;
  public
    property PluginHost: TInterfacedSharpCenterHostBase read FPluginHost write FPluginHost;
  end;

var
  frmKLayout: TfrmKLayout;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmKLayout.cbIconClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmKLayout.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmKLayout.UpdateSettings;
begin
  if Visible then
    PluginHost.Save;
end;

end.

