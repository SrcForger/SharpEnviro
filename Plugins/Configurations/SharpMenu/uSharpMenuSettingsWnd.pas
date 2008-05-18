{
Source Name: uSharpDeskSettingsWnd.pas
Description: SharpDesk Settings Window
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
    cb_useicons: TCheckBox;
    Label2: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    cb_wrap: TCheckBox;
    sgb_wrapcount: TSharpeGaugeBox;
    cobo_wrappos: TComboBox;
    Label3: TLabel;
    cb_cacheicons: TCheckBox;
    procedure cobo_wrapposChange(Sender: TObject);
    procedure sgb_wrapcountChangeValue(Sender: TObject; Value: Integer);
    procedure cb_useiconsClick(Sender: TObject);
    procedure cb_wrapClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FUpdating: Boolean;
    procedure UpdateWrapBox;
    procedure SendUpdate;
  public
    property Updating: Boolean read FUpdating write FUpdating;
  end;

var
  frmMenuSettings: TfrmMenuSettings;

implementation

{$R *.dfm}

{ TfrmConfigListWnd }

procedure TfrmMenuSettings.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := true;
  Panel1.DoubleBuffered := true;
end;

procedure TfrmMenuSettings.UpdateWrapBox;
begin

end;

procedure TfrmMenuSettings.FormShow(Sender: TObject);
begin
  UpdateWrapBox;
  Label2.Font.Color := clGray;
  Label3.Font.Color := clGray;
  Label4.Font.Color := clGray;
  cb_useiconsClick(self);
end;

procedure TfrmMenuSettings.cb_wrapClick(Sender: TObject);
begin
  UpdateWrapBox;
  SendUpdate;
end;

procedure TfrmMenuSettings.SendUpdate;
begin
  if ( Not(Updating) and ( Visible ) ) then
     CenterDefineSettingsChanged;
end;

procedure TfrmMenuSettings.cb_useiconsClick(Sender: TObject);
begin
  SendUpdate;
  cb_cacheicons.Enabled := cb_useicons.Checked;
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

