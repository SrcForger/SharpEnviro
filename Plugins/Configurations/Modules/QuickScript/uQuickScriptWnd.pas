{
Source Name: uQuickScript.pas
Description: QuickScript Module Settings Window
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

unit uQuickScriptWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, ExtCtrls, Menus, GR32_Image,
  JvPageList, JvExControls, ISharpCenterHostUnit, SharpECenterHeader;

type
  TfrmQuickScript = class(TForm)
    plMain: TJvPageList;
    pagQuickScript: TJvStandardPage;
    Panel1: TPanel;
    cboDisplay: TComboBox;
    schDisplayOptions: TSharpECenterHeader;
    procedure FormCreate(Sender: TObject);
    procedure cb_alwaysontopClick(Sender: TObject);
    procedure cboComboChange(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    procedure UpdateSettings;
  public
    property PluginHost: ISharpCenterHost read FPluginHost write FPluginHost;
  end;

var
  frmQuickScript: TfrmQuickScript;

implementation

uses
  SharpCenterApi;

{$R *.dfm}

procedure TfrmQuickScript.cb_alwaysontopClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmQuickScript.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmQuickScript.cboComboChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmQuickScript.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;

end.

