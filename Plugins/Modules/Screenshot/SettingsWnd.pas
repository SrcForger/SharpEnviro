{
Source Name: SettingsWnd.pas
Description: SharpE Bar Module - Settings Window
Copyright (C) Ron Nicholson <sylaei@gmail.com>

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
  // Default Units
  Windows, Messages, Types, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,
  // SharpE Units
  SharpApi, Buttons, JvExStdCtrls, JvListBox, JvDriveCtrls, JvCombobox, JvgPage,
  Mask, JvExMask, JvSpin, Spin;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    JvgPageControl1: TJvgPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox5: TGroupBox;
    cbxDateTime: TCheckBox;
    cbxDateTimeFormat: TComboBox;
    GroupBox1: TGroupBox;
    cbxClipboard: TCheckBox;
    cbxSaveAs: TCheckBox;
    cbxSaveToFile: TCheckBox;
    cbxActive: TCheckBox;
    GroupBox4: TGroupBox;
    Label2: TLabel;
    tbxFilename: TEdit;
    tbxNum: TEdit;
    cbxNum: TCheckBox;
    cbxFormat: TComboBox;
    Label1: TLabel;
    DlbFolders: TJvDirectoryListBox;
    JvDriveCombo1: TJvDriveCombo;
    TabSheet3: TTabSheet;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    Label3: TLabel;
    chkJpgGrayscale: TCheckBox;
    Label4: TLabel;
    speJpgCompression: TSpinEdit;
    spePngCompression: TSpinEdit;
    GroupBox8: TGroupBox;
    Memo1: TMemo;
    procedure cbxFormatChange(Sender: TObject);
    procedure cbxDateTimeClick(Sender: TObject);
    procedure cbxNumClick(Sender: TObject);
    procedure cbxSaveToFileClick(Sender: TObject);

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

procedure TSettingsForm.cbxFormatChange(Sender: TObject);
begin
   if (cbxFormat.Text <> 'Bmp') or (cbxFormat.Text <> 'Jpg') or (cbxFormat.Text <> 'Png') then
      cbxFormat.Text := 'Bmp';
end;



end.

