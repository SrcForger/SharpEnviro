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
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, XPMan;

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
    cb_sea: TRadioButton;
    Label2: TLabel;
    cb_ea: TRadioButton;
    combo_actionlist: TComboBox;
    edit_app: TEdit;
    btn_open: TButton;
    OpenFile: TOpenDialog;
    XPManifest1: TXPManifest;
    cb_specialskin: TCheckBox;
    procedure btn_openClick(Sender: TObject);
    procedure cb_seaClick(Sender: TObject);
    procedure tb_sizeChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cb_labelsClick(Sender: TObject);
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
  self.ModalResult := mrOk;
  if cb_sea.Checked then ActionStr := combo_actionlist.Text
     else ActionStr := Edit_App.Text;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.cb_labelsClick(Sender: TObject);
begin
  edit_caption.Enabled :=  cb_labels.Checked;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
var
  SList : TStringList;
  n     : integer;
begin
  cb_labels.OnClick(cb_labels);
  cb_sea.OnClick(cb_sea);
  SList := TStringList.Create;
  try
    SList.Clear;
    SList.DelimitedText := SharpApi.GetDelimitedActionList;
    SList.Sort;
    combo_actionlist.Clear;
    for n := 0 to SList.Count - 1 do
        combo_actionlist.Items.Add(SList.ValueFromIndex[n]);
  finally
    SList.Free;
    if combo_actionlist.Items.Count >0 then
    begin
      n := combo_actionlist.Items.IndexOf(ActionStr);
      if (n <> - 1) and (cb_sea.Checked) then combo_actionlist.ItemIndex := n
         else combo_actionlist.ItemIndex := 0;
    end;
    if cb_ea.Checked then
       edit_app.Text := ActionStr;
  end;
end;

procedure TSettingsForm.tb_sizeChange(Sender: TObject);
begin
  lb_barsize.Caption := inttostr(tb_size.Position) + 'px';
end;

procedure TSettingsForm.cb_seaClick(Sender: TObject);
begin
  combo_actionlist.Enabled := cb_sea.Checked;
  edit_app.Enabled         := cb_ea.Checked;
  btn_open.Enabled         := cb_ea.Checked;
end;

procedure TSettingsForm.btn_openClick(Sender: TObject);
begin
  if OpenFile.Execute then
     Edit_App.Text := OpenFile.FileName;
end;

end.
