{
Source Name: uEditSchemeWnd
Description: Edit/Create Scheme Window
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

unit uEditSchemeWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uSharpeColorBox;

type
  TEditSchemeForm = class(TForm)
    Panel1: TPanel;
    b1: TSharpEColorBox;
    l1: TSharpEColorBox;
    d1: TSharpEColorBox;
    f1: TSharpEColorBox;
    Panel2: TPanel;
    b2: TSharpEColorBox;
    l2: TSharpEColorBox;
    d2: TSharpEColorBox;
    f2: TSharpEColorBox;
    Panel3: TPanel;
    b3: TSharpEColorBox;
    l3: TSharpEColorBox;
    d3: TSharpEColorBox;
    f3: TSharpEColorBox;
    edit_name: TEdit;
    Label5: TLabel;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    btn_cancel: TButton;
    btn_ok: TButton;
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;


implementation

uses JclStrings;

{$R *.dfm}

procedure TEditSchemeForm.btn_cancelClick(Sender: TObject);
begin
  modalresult := mrCancel;
end;

procedure TEditSchemeForm.btn_okClick(Sender: TObject);
begin
  if length(trim(StrRemoveChars(edit_name.Text,['"','<','>','|','/','\','*','?','.',':']))) <=0 then
  begin
    Showmessage('Please enter a valid scheme name first');
    exit;
  end;
  modalresult := mrOk;
end;

end.
