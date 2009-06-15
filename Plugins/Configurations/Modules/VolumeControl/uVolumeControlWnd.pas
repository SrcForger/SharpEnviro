{
Source Name: uVolumeControlSettingsWnd.pas
Description: Volume Control Module Settings Window
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

unit uVolumeControlWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, SharpApi, SharpCenterApi,
  SharpEGaugeBoxEdit, JvPageList, JvExControls, ExtCtrls,
  ISharpCenterHostUnit, SoundControls, MMSystem, SharpECenterHeader;

type
  TfrmVolumeControl = class(TForm)
    JvPageList1: TJvPageList;
    JvSettingsPage: TJvStandardPage;
    pnlSize: TPanel;
    sgb_width: TSharpeGaugeBox;
    lblMixerNote: TLabel;
    pnlMixer: TPanel;
    cb_mlist: TComboBox;
    schMixer: TSharpECenterHeader;
    schSize: TSharpECenterHeader;
    pnButtonPos: TPanel;
    Label1: TLabel;
    cboButtonPos: TComboBox;
    scmQuickSelect: TSharpECenterHeader;
    procedure FormCreate(Sender: TObject);
    procedure cb_mlistChange(Sender: TObject);
    procedure sgb_widthChangeValue(Sender: TObject; Value: Integer);
    procedure cboButtonPosChange(Sender: TObject);
  private
    FPluginHost: ISharpCenterHost;
    procedure SendUpdate;
  public
    IDList : TStringList;
    procedure BuildMixerList;
    property PluginHost: ISharpCenterHost read FPluginHost write
      FPluginHost;
  end;

var
  frmVolumeControl: TfrmVolumeControl;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmVolumeControl.BuildMixerList;
var
  Line  : TMixerLine;
  Mixer : hMixerObj;
  r     : MMResult;
  n     : integer;
begin
  cb_mlist.Clear;
  IDList.Clear;
  
  if (mixerGetNumDevs() < 1) then
    Exit;

  Mixer := InitMixer;
  for n := 0 to 8000 do
  begin
    ZeroMemory(@Line, SizeOf(Line));
    Line.cbStruct := SizeOf(Line);
    Line.dwComponentType :=  n;
    r := mixerGetLineInfo(Mixer, @Line, MIXER_GETLINEINFOF_COMPONENTTYPE);
    if r = MMSYSERR_NOERROR then
    begin
      IDList.Add(inttostr(n));
      cb_mlist.Items.Add(Line.szName + ' ('+inttostr(Line.dwDestination)+')');
    end;
  end;
   mixerclose(Mixer);
end;

procedure TfrmVolumeControl.cboButtonPosChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmVolumeControl.cb_mlistChange(Sender: TObject);
begin
  SendUpdate;
end;

procedure TfrmVolumeControl.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
  IDList := TStringList.Create;
  IDList.Clear;
end;

procedure TfrmVolumeControl.SendUpdate;
begin
  if Visible then
    PluginHost.Save;
end;

procedure TfrmVolumeControl.sgb_widthChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

end.

