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

unit uSharpMenuSettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi,
  JvExComCtrls, JvComCtrls, ExtCtrls, JvPageList, JvExControls, JvComponent,
  SharpEGaugeBoxEdit;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmMenuSettings = class(TForm)
    JvPageList1: TJvPageList;
    JvSettingsPage: TJvStandardPage;
    Panel1: TPanel;
    Panel2: TPanel;
    JvAdvSettingsPage: TJvStandardPage;
    Panel3: TPanel;
    cb_cacheicons: TCheckBox;
    JvStandardPage1: TJvStandardPage;
    cb_wrap: TCheckBox;
    pn_wrap: TPanel;
    lb_gridx1: TLabel;
    sgb_wrapcount: TSharpeGaugeBox;
    Label1: TLabel;
    cobo_wrappos: TComboBox;
    Label2: TLabel;
    procedure cobo_wrapposChange(Sender: TObject);
    procedure sgb_wrapcountChangeValue(Sender: TObject; Value: Integer);
    procedure cb_cacheiconsClick(Sender: TObject);
    procedure cb_wrapClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure UpdateWrapBox;
    procedure SendUpdate;
  public
  end;

var
  frmMenuSettings: TfrmMenuSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmMenuSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
end;

procedure TfrmMenuSettings.UpdateWrapBox;
begin
  pn_wrap.visible := cb_wrap.Checked;
end;

procedure TfrmMenuSettings.FormShow(Sender: TObject);
begin
  UpdateWrapBox;
end;

procedure TfrmMenuSettings.cb_wrapClick(Sender: TObject);
begin
  UpdateWrapBox;
  SendUpdate;
end;

procedure TfrmMenuSettings.SendUpdate;
begin
  if Visible then
     SharpEBroadCast(WM_SHARPCENTERMESSAGE, SCM_SET_SETTINGS_CHANGED, 0);
end;

procedure TfrmMenuSettings.cb_cacheiconsClick(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmMenuSettings.sgb_wrapcountChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

procedure TfrmMenuSettings.cobo_wrapposChange(Sender: TObject);
begin
  SendUpdate;
end;

end.

