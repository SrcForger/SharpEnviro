{
Source Name: SettingsWnd.pas
Description: Media Controler Module - Settings Window
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
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, XPMan, Registry;

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
    XPManifest1: TXPManifest;
    lb_foobarpath: TLabel;
    cb_mpc: TRadioButton;
    Label2: TLabel;
    cb_pselect: TCheckBox;
    cb_qcd: TRadioButton;
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
    procedure GetFooPathFromRegistry;
  end;


implementation

{$R *.dfm}

function RegLoadStr(Key, Prop, Default : String): string;
var
  Reg: TRegIniFile;
begin
  Reg := TRegIniFile.create('Software\');
  try
    result := 'C:\Program Files\Foobar2000\';
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    result := Reg.ReadString(Key,Prop,Default);
  finally
    Reg.CloseKey;
    Reg.free;
  end;
end;

procedure TSettingsForm.GetFooPathFromRegistry;
begin
  Edit_FooPath.Text := IncludeTrailingBackSlash(
                          RegLoadStr('FooBar2000','InstallDir','C:\Program Files\Foobar2000\'))
                       + 'FooBar2000.exe';
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
    foocontrols := True;
  end;

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
  if edit_foopath.Text = '-1' then GetFooPathFromRegistry;
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
