{
Source Name: MainWnd
Description: Memory Monitor Module - Settings Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit SettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, ExtCtrls;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    cb_rambar: TCheckBox;
    cb_raminfo: TCheckBox;
    Label1: TLabel;
    cb_swpbar: TCheckBox;
    cb_swpinfo: TCheckBox;
    Label2: TLabel;
    cb_swppc: TCheckBox;
    cb_rampc: TCheckBox;
    rb_halign: TRadioButton;
    Label3: TLabel;
    rb_valign: TRadioButton;
    tb_size: TGaugeBar;
    Label4: TLabel;
    lb_barsize: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    cb_itc_pt: TRadioButton;
    cb_itc_fmb: TRadioButton;
    rb_halign2: TRadioButton;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure tb_sizeChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;


implementation

{$R *.dfm}

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.tb_sizeChange(Sender: TObject);
begin
  lb_barsize.Caption := inttostr(tb_size.Position);
end;

procedure TSettingsForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (not cb_rambar.Checked) and (not cb_rampc.Checked)
     and (not cb_raminfo.Checked) and (not cb_swpbar.Checked)
     and (not cb_swppc.Checked) and (not cb_swpinfo.Checked)
     and (ModalResult <> mrCancel) then
  begin
    ShowMessage('At least one display item has to be selected!');
    CanClose := False;
    exit;
  end;
end;

end.
