{
Source Name: uAlarmClockWnd.pas
Description: RSS Reader Module Settings Window
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

unit uAlarmClockWnd;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, SharpApi, SharpCenterAPI,
  SharpECenterHeader, ISharpCenterHostUnit, SharpEGaugeBoxEdit,
  JvExControls, JvXPCore, JvXPCheckCtrls, SharpEBaseControls, SharpEEdit,
  ExtCtrls;

type
  TfrmAlarmClock = class(TForm)
    SharpECenterHeader1: TSharpECenterHeader;
    SharpECenterHeader2: TSharpECenterHeader;
    pnlBottom: TPanel;
    Panel2: TPanel;
    Panel1: TPanel;
    edtTimeout: TSharpEEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtSnooze: TSharpEEdit;
    cbAutostart: TJvXPCheckbox;
    Label3: TLabel;
    Label4: TLabel;
    edtSound: TSharpEEdit;
    Label5: TLabel;
    sgbTimeYear: TSharpeGaugeBox;
    sgbTimeMonth: TSharpeGaugeBox;
    sgbTimeDay: TSharpeGaugeBox;
    sgbTimeHour: TSharpeGaugeBox;
    sgbTimeMinute: TSharpeGaugeBox;
    sgbTimeSecond: TSharpeGaugeBox;
    btnSoundBrowse: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure UpdateSettingsEvent(Sender: TObject);
    procedure sgbUpdateIntervalChangeValue(Sender: TObject; Value: Integer);
    procedure edtOnChange(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure sgbOnChangeValue(Sender: TObject; Value: Integer);
    procedure cbOnChange(Sender: TObject);
    procedure btnSoundBrowseClick(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;

    procedure UpdateSettings;

  public
    ModuleID: string;
    BarID : string;

    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmAlarmClock: TfrmAlarmClock;

implementation

{$R *.dfm}

procedure TfrmAlarmClock.UpdateSettingsEvent(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmAlarmClock.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
end;

procedure TfrmAlarmClock.btnSoundBrowseClick(Sender: TObject);
var
  dlg : TOpenDialog;
begin
  dlg := TOpenDialog.Create(Self);
  dlg.InitialDir := GetCurrentDir;
  dlg.Options := [ofFileMustExist];

  dlg.Filter := 'Audio Files (*.mp3, *.wav)|*.mp3;*.wav';
  dlg.FilterIndex := 1;

  if dlg.Execute then
    edtSound.Text := dlg.FileName;
    
  dlg.Free;

  UpdateSettings;
end;

procedure TfrmAlarmClock.cbOnChange(Sender: TObject);
begin
  UpdateSettings;
end;

procedure TfrmAlarmClock.edtOnChange(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  UpdateSettings;
end;

procedure TfrmAlarmClock.sgbOnChangeValue(Sender: TObject; Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmAlarmClock.sgbUpdateIntervalChangeValue(Sender: TObject;
  Value: Integer);
begin
  UpdateSettings;
end;

procedure TfrmAlarmClock.UpdateSettings;
begin
  if Visible then
    PluginHost.SetSettingsChanged;
end;


end.

