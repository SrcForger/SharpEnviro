{
Source Name: sFilterWnd
Description: ---
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Website
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

unit sFilterWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tsfilterform = class(TForm)
    list_filters: TListBox;
    btn_new: TButton;
    btn_edit: TButton;
    btn_delete: TButton;
    Button1: TButton;
    procedure btn_newClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  sfilterform: Tsfilterform;

implementation

uses EditFilterWmd;

{$R *.dfm}

procedure Tsfilterform.btn_newClick(Sender: TObject);
begin
  try
    EditFilterForm := TEditFilterForm.Create(nil);
    EditFilterForm.showmodal;
  finally
    FreeAndNil(EditFilterForm);
  end;
end;

end.
