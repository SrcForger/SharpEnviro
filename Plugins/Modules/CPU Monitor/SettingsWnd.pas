{
Source Name: SettingsWnd
Description: CPU Monitor module settings window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.Sharpe-Shell.org

Recommended Environment
 - Compiler : Delphi 2005 (Personal Edition)
 - OS : Windows 2000 or higher

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

unit SettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, XPMan, Menus, ExtCtrls,
  uSharpeColorBox, Mask, JvExMask, JvSpin, adCpuUsage;

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
    scb_bg: TSharpEColorBox;
    Label3: TLabel;
    scb_fg: TSharpEColorBox;
    Label5: TLabel;
    scb_border: TSharpEColorBox;
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
  lb_bgalpha.Caption := inttostr(tb_bgalpha.Position);
end;

procedure TSettingsForm.tb_fgalphaChange(Sender: TObject);
begin
  lb_fgalpha.Caption := inttostr(tb_fgalpha.Position);
end;

procedure TSettingsForm.tb_borderalphaChange(Sender: TObject);
begin
  lb_borderalpha.Caption := inttostr(tb_borderalpha.Position);
end;

end.
