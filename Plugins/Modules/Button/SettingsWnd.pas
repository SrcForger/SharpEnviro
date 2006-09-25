{
Source Name: SettingsWnd.pas
Description: Button Module - Settings Window
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
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, SharpDialogs, XPMan;

type
  TSettingsForm = class(TForm)
    cb_labels: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    Edit_caption: TEdit;
    Label4: TLabel;
    lb_barsize: TLabel;
    tb_size: TGaugeBar;
    Label1: TLabel;
    edit_action: TEdit;
    btn_open: TButton;
    XPManifest1: TXPManifest;
    cb_specialskin: TCheckBox;
    procedure btn_openClick(Sender: TObject);
    procedure tb_sizeChange(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    ActionStr : String;
  end;


implementation

{$R *.dfm}

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  ActionStr := edit_action.Text;
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

procedure TSettingsForm.btn_openClick(Sender: TObject);
var
  s : string;
begin
  s := SharpDialogs.TargetDialog(STI_ALL_TARGETS,
                                 ClientToScreen(point(btn_open.Left,btn_open.Top)));
  if length(trim(s))>0 then edit_action.Text := s;
end;

end.
