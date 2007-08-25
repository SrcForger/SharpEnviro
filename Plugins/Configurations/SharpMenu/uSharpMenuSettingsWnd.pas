﻿{
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
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi, SharpCenterApi,
  JvExComCtrls, JvComCtrls, ExtCtrls, JvPageList, JvExControls, JvComponent,
  SharpEGaugeBoxEdit, JvLabel;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmMenuSettings = class(TForm)
    JvPageList1: TJvPageList;
    JvSettingsPage: TJvStandardPage;
    cb_cacheicons: TCheckBox;
    Label2: TLabel;
    Panel1: TPanel;
    cb_wrap: TCheckBox;
    sgb_wrapcount: TSharpeGaugeBox;
    cobo_wrappos: TComboBox;
    Label1: TLabel;
    Label4: TLabel;
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

end;

procedure TfrmMenuSettings.FormShow(Sender: TObject);
begin
  UpdateWrapBox;
  Label2.Font.Color := clGray;
  Label4.Font.Color := clGray;
end;

procedure TfrmMenuSettings.cb_wrapClick(Sender: TObject);
begin
  UpdateWrapBox;
  SendUpdate;
end;

procedure TfrmMenuSettings.SendUpdate;
begin
  if Visible then
     CenterDefineSettingsChanged;
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

