{
Source Name: SettingsWnd.pas
Description: Media Controler Module - Settings Window
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
  Windows, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpApi, Registry;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    cb_winamp: TRadioButton;
    cb_foobar: TRadioButton;
    edit_foopath: TEdit;
    btn_openfoo: TButton;
    OpenFile: TOpenDialog;
    lb_foobarpath: TLabel;
    cb_mpc: TRadioButton;
    Label2: TLabel;
    cb_pselect: TCheckBox;
    cb_qcd: TRadioButton;
    cb_wmp: TRadioButton;
    cb_vlc: TRadioButton;
    procedure cb_foobarClick(Sender: TObject);
    procedure cb_winampClick(Sender: TObject);
    procedure btn_openfooClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    ActionStr : String;
    procedure UpdateStatus;
  end;

function GetFooPathFromRegistry : String;


implementation

{$R *.dfm}

function GetFooPathFromRegistry : String;
var
  Reg : TRegistry;
begin
  result := 'C:\Program Files\Foobar2000\foobar2000.exe';
  {$WARNINGS OFF}
  Reg := TRegistry.Create;
  try
    Reg.Access := KEY_READ;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\Software\FooBar2000',False) then
    begin
      result := IncludeTrailingBackSlash(Reg.ReadString('InstallDir')) + 'foobar2000.exe';
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  {$WARNINGS ON}
end;

procedure TSettingsForm.UpdateStatus;
var
  foocontrols : boolean;
begin
  if cb_winamp.checked then
  begin
    foocontrols := False;
  end else
  if cb_mpc.checked then
  begin
    foocontrols := False;
  end else
  if cb_foobar.checked then
  begin
    foocontrols := True;
  end else
  if cb_qcd.checked then
  begin
    foocontrols := False;
  end else
  if cb_wmp.Checked then
  begin
    foocontrols := False;
  end else
  if cb_vlc.Checked then
  begin
    foocontrols := False;
  end else foocontrols := False;

  lb_foobarpath.Enabled := foocontrols;
  edit_foopath.Enabled := foocontrols;
  btn_openfoo.Enabled := foocontrols;
end;

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  UpdateStatus;
  if edit_foopath.Text = '-1' then
     Edit_FooPath.Text := GetFooPathFromRegistry;
end;

procedure TSettingsForm.btn_openfooClick(Sender: TObject);
begin
  if OpenFile.Execute then
     edit_foopath.Text := OpenFile.FileName;
end;

procedure TSettingsForm.cb_winampClick(Sender: TObject);
begin
  UpdateStatus;
end;

procedure TSettingsForm.cb_foobarClick(Sender: TObject);
begin
  UpdateStatus;
end;

end.
