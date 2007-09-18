{
Source Name: mlinewnd
Description: multi line caption window
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

unit mlinewnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  Tmlineform = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    btn_ok: TButton;
    btn_cancel: TButton;
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  mlineform: Tmlineform;

implementation

{$R *.dfm}

procedure Tmlineform.btn_cancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Tmlineform.btn_okClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
