{
Source Name: SettingsWnd
Description: CPU Monitor module settings window
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
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, XPMan, Menus, ExtCtrls,
  JvSpin, adCpuUsage, SharpEColorPicker, Mask, JvExMask;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    XPManifest1: TXPManifest;
    Label4: TLabel;
    lb_barsize: TLabel;
    tb_size: TGaugeBar;
    Label1: TLabel;
    rb_bar: TRadioButton;
    rb_line: TRadioButton;
    rb_cu: TRadioButton;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lb_update: TLabel;
    tb_update: TGaugeBar;
    edit_cpu: TJvSpinEdit;
    Label8: TLabel;
    Label9: TLabel;
    lb_bgalpha: TLabel;
    tb_bgalpha: TGaugeBar;
    lb_fgalpha: TLabel;
    tb_fgalpha: TGaugeBar;
    lb_borderalpha: TLabel;
    tb_borderalpha: TGaugeBar;
    scb_bg: TSharpEColorPicker;
    scb_fg: TSharpEColorPicker;
    scb_border: TSharpEColorPicker;
    procedure tb_borderalphaChange(Sender: TObject);
    procedure tb_fgalphaChange(Sender: TObject);
    procedure tb_bgalphaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tb_updateChange(Sender: TObject);
    procedure tb_sizeChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
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
  lb_barsize.Caption := inttostr(tb_size.Position) + 'px';
end;

procedure TSettingsForm.tb_updateChange(Sender: TObject);
begin
  lb_update.Caption := inttostr(tb_update.Position) + 'ms';
end;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  edit_cpu.MaxValue := adCpuUsage.GetCPUCount;
end;

procedure TSettingsForm.tb_bgalphaChange(Sender: TObject);
begin
  lb_bgalpha.Caption := inttostr(round((tb_bgalpha.Position/tb_bgalpha.Max)*100)) + '%';
end;

procedure TSettingsForm.tb_fgalphaChange(Sender: TObject);
begin
  lb_fgalpha.Caption := inttostr(round((tb_fgalpha.Position/tb_fgalpha.Max)*100)) + '%';
end;

procedure TSettingsForm.tb_borderalphaChange(Sender: TObject);
begin
  lb_borderalpha.Caption := inttostr(round((tb_borderalpha.Position/tb_borderalpha.Max)*100)) + '%';
end;

end.
