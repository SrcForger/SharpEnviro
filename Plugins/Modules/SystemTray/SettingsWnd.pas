{
Source Name: SettingsWnd
Description: SystemTray Module - Settings Window
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
  Windows, Messages, SysUtils, Classes, Controls, Forms,
  Dialogs, StdCtrls, GR32_RangeBars, ExtCtrls,
  SharpEColorPicker;

type
  TSettingsForm = class(TForm)
    cb_dbg: TCheckBox;
    cb_dbd: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    lb_dbg: TLabel;
    tb_dbg: TGaugeBar;
    Label1: TLabel;
    lb_dbd: TLabel;
    tb_dbd: TGaugeBar;
    Label2: TLabel;
    lb_blend: TLabel;
    cb_blend: TCheckBox;
    tb_blend: TGaugeBar;
    Label3: TLabel;
    lb_alpha: TLabel;
    tb_alpha: TGaugeBar;
    scb_dbg: TSharpEColorPicker;
    scb_dbd: TSharpEColorPicker;
    scb_blend: TSharpEColorPicker;
    procedure tb_alphaChange(Sender: TObject);
    procedure tb_blendChange(Sender: TObject);
    procedure cb_blendClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tb_dbdChange(Sender: TObject);
    procedure cb_dbdClick(Sender: TObject);
    procedure cb_dbgClick(Sender: TObject);
    procedure tb_dbgChange(Sender: TObject);
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

procedure TSettingsForm.tb_dbgChange(Sender: TObject);
begin
  lb_dbg.Caption := inttostr(round((tb_dbg.Position/tb_dbg.Max)*100)) + '%';
end;

procedure TSettingsForm.cb_dbgClick(Sender: TObject);
begin
  lb_dbg.Enabled  := cb_dbg.Checked;
  tb_dbg.Enabled  := cb_dbg.Checked;
  scb_dbg.Enabled := cb_dbg.Checked;
  Label4.Enabled  := cb_dbg.Checked;
end;

procedure TSettingsForm.cb_dbdClick(Sender: TObject);
begin
  lb_dbd.Enabled  := cb_dbd.Checked;
  tb_dbd.Enabled  := cb_dbd.Checked;
  scb_dbd.Enabled := cb_dbd.Checked;
  Label1.Enabled  := cb_dbd.Checked;
end;

procedure TSettingsForm.tb_dbdChange(Sender: TObject);
begin
  lb_dbd.Caption := inttostr(round((tb_dbd.Position/tb_dbd.Max)*100)) + '%';
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  cb_dbdClick(cb_dbd);
  cb_dbgClick(cb_dbg);
  cb_blendClick(cb_blend);
end;

procedure TSettingsForm.cb_blendClick(Sender: TObject);
begin
  lb_blend.Enabled  := cb_blend.Checked;
  tb_blend.Enabled  := cb_blend.Checked;
  scb_blend.Enabled := cb_blend.Checked;
  Label2.Enabled    := cb_blend.Checked;
end;

procedure TSettingsForm.tb_blendChange(Sender: TObject);
begin
  lb_blend.Caption := inttostr(round((tb_blend.Position/tb_blend.Max)*100)) + '%';
end;

procedure TSettingsForm.tb_alphaChange(Sender: TObject);
begin
  lb_alpha.Caption := inttostr(round((tb_alpha.Position/tb_alpha.Max)*100)) + '%';
end;

end.
