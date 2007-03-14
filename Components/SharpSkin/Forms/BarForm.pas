{
Source Name: BarForm.pas
Description: SharpSkin Bar Form
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
http://www.sharpe-shell.org

Recommended Environment
 - Compiler : Delphi 2005 PE
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

unit BarForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEBaseControls, SharpEBar;

type
  TBarWnd = class(TForm)
    procedure FormDeactivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    SharpEBar1: TSharpEBar;
  end;

var
  BarWnd: TBarWnd;

implementation

uses MainForm;

{$R *.dfm}

procedure TBarWnd.FormCreate(Sender: TObject);
begin
  SharpEBar1 := TSharpEBar.CreateRuntime(self,MainForm.SkinManager);
end;

procedure TBarWnd.FormDeactivate(Sender: TObject);
begin
  SharpEBar1.Free;
end;

end.
