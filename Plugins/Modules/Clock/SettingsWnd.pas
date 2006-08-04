{
Source Name: SettingsWnd
Description: Clock module settings window
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
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, XPMan, Menus;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Label1: TLabel;
    OpenFile: TOpenDialog;
    XPManifest1: TXPManifest;
    edit_format: TEdit;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    N213046HHMMSS1: TMenuItem;
    N213046HHMMSS3: TMenuItem;
    N213046HHMMSS2: TMenuItem;
    cb_large: TRadioButton;
    cb_medium: TRadioButton;
    cb_small: TRadioButton;
    N21304619062006HHMMSSDDMMYYYY1: TMenuItem;
    procedure N213046HHMMSS3Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    ActionStr : String;
  end;


implementation

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
  PopUpMenu1.PopupComponent := Button3;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TSettingsForm.N213046HHMMSS3Click(Sender: TObject);
begin
  edit_format.Text := TMenuItem(SendeR).Hint;
end;

end.
