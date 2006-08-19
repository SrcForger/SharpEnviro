{
Source Name: mlinewnd.pas
Description: multi line captain edit window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005
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
