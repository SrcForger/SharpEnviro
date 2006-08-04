{
Source Name: SettingsWnd.pas
Description: TaskBar Module Settings Form
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
 - OS : Windows XP

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
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, XPMan, ExtCtrls;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    cb_tsfull: TRadioButton;
    XPManifest1: TXPManifest;
    cb_tscompact: TRadioButton;
    cb_tsminimal: TRadioButton;
    cb_filter: TCheckBox;
    cb_maximized: TCheckBox;
    cb_minimized: TCheckBox;
    cb_visible: TCheckBox;
    Panel1: TPanel;
    cb_sort: TCheckBox;
    rb_caption: TRadioButton;
    rb_wndclassname: TRadioButton;
    rb_timeadded: TRadioButton;
    rb_icon: TRadioButton;
    CheckBox1: TCheckBox;
    Button3: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    ActionStr : String;
  end;


implementation

uses sFilterWnd;

{$R *.dfm}

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.Button3Click(Sender: TObject);
begin
  try
    sFilterForm := TsFilterForm.Create(nil);
    sFilterForm.ShowModal;
  finally
    FreeAndNil(sFilterForm);
  end;
end;

end.
