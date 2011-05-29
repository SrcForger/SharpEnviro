﻿{
Source Name: uSettingsWnd.pas
Description: VWM Service Settings Window
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
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, SharpApi, SharpCenterApi,
  ExtCtrls, SharpECenterHeader, JvXPCore, JvXPCheckCtrls,
  ISharpCenterHostUnit, JvExControls, SharpEGaugeBoxEdit, SharpESwatchManager,
  SharpEColorEditorEx;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmSettings = class(TForm)
    SharpECenterHeader2: TSharpECenterHeader;
    chkShowOSD: TJvXPCheckbox;
    Panel1: TPanel;
    Label1: TLabel;
    cboVertPos: TComboBox;
    Label2: TLabel;
    cboHorizPos: TComboBox;
    sgbOffsetHor: TSharpeGaugeBox;
    sgbOffsetVert: TSharpeGaugeBox;
    Label3: TLabel;
    sgbFontSize: TSharpeGaugeBox;
    SharpESwatchManager1: TSharpESwatchManager;
    Colors: TSharpEColorEditorEx;
    chkColor: TJvXPCheckbox;
    procedure SettingsChanged(Sender: TObject);
    procedure cboHorizPosChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ColorsChangeColor(ASender: TObject; AValue: Integer);
    procedure sgbOffsetHorChangeValue(Sender: TObject; Value: Integer);
  private
    FPluginHost: ISharpCenterHost;
    procedure SendUpdate;
  public
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
    procedure UpdateUI;
  end;

var
  frmSettings: TfrmSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmSettings.SettingsChanged(Sender: TObject);
begin
  SendUpdate;
  UpdateUI;
end;

procedure TfrmSettings.sgbOffsetHorChangeValue(Sender: TObject; Value: Integer);
begin
  SettingsChanged(nil);
end;

procedure TfrmSettings.UpdateUI;
begin
  cboHorizPos.Enabled := chkShowOSD.Checked;
  cboVertPos.Enabled := chkShowOSD.Checked;
  Label1.Enabled := chkShowOSD.Checked;
  Label2.Enabled := chkShowOSD.Checked;
  Label3.Enabled := chkShowOSD.Checked;
  sgbFontSize.Enabled := chkShowOSD.Checked;
  sgbOffsetHor.Enabled := chkShowOSD.Checked;
  sgbOffsetVert.Enabled := chkShowOSD.Checked;

  Colors.Visible := chkColor.Checked;
end;

procedure TfrmSettings.cboHorizPosChange(Sender: TObject);
begin
  SettingsChanged(nil);
end;

procedure TfrmSettings.ColorsChangeColor(ASender: TObject; AValue: Integer);
begin
  SendUpdate;
end;

procedure TfrmSettings.FormShow(Sender: TObject);
begin
  UpdateUI;
end;

procedure TfrmSettings.SendUpdate;
begin
  if Visible then
    PluginHost.Save;
end;

end.

