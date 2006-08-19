{
Source Name: SelectFolderWnd
Description: Form for selecting a folder
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

unit LinkObjectFolderWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, ShellCtrls, SharpApi, SharpFX;

type
  TSelectFolderForm = class(TForm)
    TreeView: TShellTreeView;
    cb_shellfolder: TCheckBox;
    cb_folder: TComboBox;
    bottompanel: TPanel;
    btn_ok: TButton;
    btn_cancel: TButton;
    Panel2: TPanel;
    btn_test: TButton;
    procedure cb_shellfolderClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_testClick(Sender: TObject);
  private
  public
    Folder : String;
  end;


implementation

uses LinkObjectSettingsWnd;

{$R *.dfm}



procedure TSelectFolderForm.cb_shellfolderClick(Sender: TObject);
begin
     TreeView.Enabled  := not cb_shellfolder.checked;
     cb_folder.Enabled := cb_shellfolder.checked;
     btn_test.Enabled := cb_shellfolder.checked;
end;

procedure TSelectFolderForm.btn_okClick(Sender: TObject);
begin
     if cb_shellfolder.Checked then self.Folder := cb_folder.Text
        else self.Folder := TreeView.Path;
     self.ModalResult := mrOk;
end;

procedure TSelectFolderForm.btn_cancelClick(Sender: TObject);
begin
     self.ModalResult := mrCancel;
end;

procedure TSelectFolderForm.btn_testClick(Sender: TObject);
begin
     winexec(pchar('explorer.exe "'+cb_folder.Text+'"'),SW_SHOW);
end;

end.
