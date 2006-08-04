{
Source Name: uInfoDialog
Description: ---
Copyright (C) Malx (Malx@sharpe-shell.org)

Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

SharpE Site
http://www.sharpe-shell.org

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

unit uInfoDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEBaseControls, SharpEButton, StdCtrls, SharpELabel, SharpEForm,
  SharpESkinManager;

type
  TInfoDlg = class(TForm)
    SharpEForm1: TSharpEForm;
    SharpELabel1: TSharpELabel;
    SharpELabel2: TSharpELabel;
    lSkinFile: TSharpELabel;
    lnr: TSharpELabel;
    bClose: TSharpEButton;
    SharpESkinManager1: TSharpESkinManager;
    SharpELabel3: TSharpELabel;
    lNrReq: TSharpELabel;
    SharpELabel4: TSharpELabel;
    lLastHwnd: TSharpELabel;
    procedure bCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InfoDlg: TInfoDlg;

implementation

{$R *.dfm}

procedure TInfoDlg.bCloseClick(Sender: TObject);
begin
  close;
end;

end.
