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
  Dialogs, StdCtrls, JvSimpleXml, JclFileUtils,
  ImgList, PngImageList, GR32, GR32_PNG, SharpApi,
  ExtCtrls, Menus, JclStrings, GR32_Image, SharpEGaugeBoxEdit,
  JvPageList, JvExControls, ComCtrls, Mask;

type
  TStringObject = class(TObject)
  public
    Str: string;
  end;

type
  TfrmBMon = class(TForm)
    plMain: TJvPageList;
    pagNotes: TJvStandardPage;
    Label3: TLabel;
    Label1: TLabel;
    cb_icon: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_alwaysontopClick(Sender: TObject);
    procedure rb_textClick(Sender: TObject);
    procedure cb_iconClick(Sender: TObject);
  private
    procedure UpdateSettings;
  public
    sModuleID: string;
    sBarID : string;
  end;

var
  frmBMon: TfrmBMon;

implementation

uses SharpThemeApi, SharpCenterApi;

{$R *.dfm}

procedure TfrmBMon.cb_alwaysontopClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmBMon.cb_iconClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmBMon.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmBMon.FormShow(Sender: TObject);
begin
  Label1.Font.Color := clGrayText;
end;

procedure TfrmBMon.rb_textClick(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmBMon.UpdateSettings;
begin
  if Visible then
    SharpCenterApi.CenterDefineSettingsChanged;
end;

end.

