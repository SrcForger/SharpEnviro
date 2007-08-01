{
Source Name: uSharpDeskSettingsWnd.pas
Description: SharpDesk Settings Window
Copyright (C) Martin Krämer (MartinKraemer@gmx.net)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit uSharpDeskSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi, SharpCenterApi,
  JvExComCtrls, JvComCtrls, ExtCtrls, JvPageList, JvExControls, JvComponent,
  SharpEGaugeBoxEdit, ImgList, PngImageList, JvLabel;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmDeskSettings = class(TForm)
    JvPageList1: TJvPageList;
    JvSettingsPage: TJvStandardPage;
    cb_singleclick: TCheckBox;
    JvAdvSettingsPage: TJvStandardPage;
    cb_amm: TCheckBox;
    cb_dd: TCheckBox;
    cb_wpwatch: TCheckBox;
    cb_grid: TCheckBox;
    sgb_gridx: TSharpeGaugeBox;
    sgb_gridy: TSharpeGaugeBox;
    Label1: TJvLabel;
    Label2: TJvLabel;
    Label3: TJvLabel;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    procedure sgb_gridyChangeValue(Sender: TObject; Value: Integer);
    procedure cb_ddClick(Sender: TObject);
    procedure cb_ammClick(Sender: TObject);
    procedure cb_singleclickClick(Sender: TObject);
    procedure cb_gridClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure UpdateGridBox;
    procedure SendUpdate;
  public
  end;

var
  frmDeskSettings: TfrmDeskSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmDeskSettings.FormCreate(Sender: TObject);
var
  i:integer;
begin
  Self.DoubleBuffered := true;
end;

procedure TfrmDeskSettings.UpdateGridBox;
begin
  sgb_gridx.Visible := cb_grid.Checked;
  sgb_gridy.Visible := cb_grid.Checked;
end;

procedure TfrmDeskSettings.FormShow(Sender: TObject);
begin
  UpdateGridBox;
end;

procedure TfrmDeskSettings.cb_gridClick(Sender: TObject);
begin
  UpdateGridBox;
  SendUpdate;
end;

procedure TfrmDeskSettings.SendUpdate;
begin
  if Visible then
     CenterDefineSettingsChanged;
end;

procedure TfrmDeskSettings.cb_singleclickClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDeskSettings.cb_ammClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDeskSettings.cb_ddClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmDeskSettings.sgb_gridyChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

end.

