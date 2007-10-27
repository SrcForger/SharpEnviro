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
  Dialogs, StdCtrls, JvSimpleXml, Menus, ComCtrls, SharpApi, SharpCenterApi,
  SharpEGaugeBoxEdit, ImgList, PngImageList, JvPageList, JvExControls, ExtCtrls;

type
  TStringObject = Class(TObject)
  public
    Str:String;
  end;

type
  TfrmVolumeControl = class(TForm)
    JvPageList1: TJvPageList;
    JvSettingsPage: TJvStandardPage;
    Panel1: TPanel;
    sgb_width: TSharpeGaugeBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel2: TPanel;
    cb_mlist: TComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cb_mlistChange(Sender: TObject);
    procedure sgb_widthChangeValue(Sender: TObject; Value: Integer);
  private
    procedure SendUpdate;
  public
    IDList : TStringList;
    sBarID,sModuleID : String;  
    procedure BuildMixerList;
  end;

var
  frmVolumeControl: TfrmVolumeControl;

implementation

uses
  SoundControls,MMSystem;

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

procedure TfrmVolumeControl.FormShow(Sender: TObject);
begin
  Label4.Font.Color := clGray;
  Label3.Font.Color := clGray;
end;

procedure TfrmVolumeControl.SendUpdate;
begin
  if Visible then
     CenterDefineSettingsChanged;
end;

procedure TfrmVolumeControl.sgb_widthChangeValue(Sender: TObject;
  Value: Integer);
begin
  SendUpdate;
end;

end.

