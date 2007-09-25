{
Source Name: frmSharpESrvWiz.pas
Description: SharpE Service Wizard Form
Copyright (C) Aleksandar Milanovic (viking) <aleksandar.milanovic@hotmail.com>

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

unit frmSharpESrvWiz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TSharpESrvWizForm = class(TForm)
    edName: TEdit;
    edDescription: TEdit;
    edCopyright: TEdit;
    lblServiceName: TLabel;
    lblDescription: TLabel;
    lblCopyright: TLabel;
    cbMsgHandler: TCheckBox;
    cbActions: TCheckBox;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    lblComment: TLabel;
    procedure cbActionsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edNameKeyPress(Sender: TObject; var Key: Char);
    procedure edNameChange(Sender: TObject);
  private
    { Private declarations }
    MsgHandlerStatus: Boolean;
  public
    { Public declarations }
  end;

var
  SharpESrvWizForm: TSharpESrvWizForm;

implementation

{$R *.dfm}

procedure TSharpESrvWizForm.cbActionsClick(Sender: TObject);
begin
  cbMsgHandler.Enabled := not cbActions.Checked;
  if cbActions.Checked then
  begin
    MsgHandlerStatus := cbMsgHandler.Checked;
    cbMsgHandler.Checked := True;
  end
  else
    cbMsgHandler.Checked := MsgHandlerStatus;
end;

procedure TSharpESrvWizForm.edNameChange(Sender: TObject);
begin
  if Pos(' ', (Sender as TEdit).Text) > 0 then
    (Sender as TEdit).Text := StringReplace((Sender as TEdit).Text, ' ', '', [rfReplaceAll]);
  btnOK.Enabled := (Sender as TEdit).Text <> '';
end;

procedure TSharpESrvWizForm.edNameKeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #32 then
   Key := #0;
end;

procedure TSharpESrvWizForm.FormCreate(Sender: TObject);
begin
  edName.Clear;
  edDescription.Clear;
  edCopyright.Clear;
end;

end.
