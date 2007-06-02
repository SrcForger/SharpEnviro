{
Source Name: SettingsWnd.pas
Description: SharpE Bar Module - Settings Window
Copyright (C) Ron Nicholson <sylaei@gmail.com>

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
  // Default Units
  Windows, Messages, Types, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  // SharpE Units
  SharpApi, Buttons, JvExStdCtrls, JvListBox, JvDriveCtrls, JvCombobox;

type
  TSettingsForm = class(TForm)
    GroupBox1: TGroupBox;
    cbxClipboard: TCheckBox;
    cbxSaveAs: TCheckBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    DlbFolders: TJvDirectoryListBox;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    tbxFilename: TEdit;
    cbxSaveToFile: TCheckBox;
    tbxNum: TEdit;
    cbxNum: TCheckBox;
    GroupBox5: TGroupBox;
    cbxDateTime: TCheckBox;
    cbxDateTimeFormat: TComboBox;
    cbxActive: TCheckBox;
    Button1: TButton;
    Button2: TButton;
    JvDriveCombo1: TJvDriveCombo;
    procedure cbxDateTimeClick(Sender: TObject);
    procedure cbxNumClick(Sender: TObject);
    procedure cbxSaveToFileClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
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

procedure TSettingsForm.SpeedButton1Click(Sender: TObject);
var
  OpenDlg: TOpenDialog;
begin
  OpenDlg := TOpenDialog.Create(Self);
  if OpenDlg.Execute then
  begin

  end;
  OpenDlg.Free;
end;

procedure TSettingsForm.cbxSaveToFileClick(Sender: TObject);
begin
  cbxNum.Enabled := cbxSaveToFile.Checked;
  tbxFileName.Enabled := cbxSaveToFile.Checked;
end;

procedure TSettingsForm.cbxNumClick(Sender: TObject);
begin
  tbxNum.Enabled := cbxNum.Checked;
end;

procedure TSettingsForm.cbxDateTimeClick(Sender: TObject);
begin
  cbxDateTimeFormat.Enabled := cbxDateTime.Checked;
end;



end.

