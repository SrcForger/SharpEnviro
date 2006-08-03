{
Source Name: uSharpDeskTerminalForm.pas
Description: Terminal Mode Settings Form
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

unit uSharpDeskTerminalForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TTerminalWnd = class(TForm)
    Label1: TLabel;
    cb_tmode: TCheckBox;
    GroupBox1: TGroupBox;
    cb_smenu: TCheckBox;
    cb_omenu: TCheckBox;
    Label2: TLabel;
    Label3: TLabel;
    cb_tload: TCheckBox;
    Label4: TLabel;
    Label5: TLabel;
    cb_omove: TCheckBox;
    cb_edesk: TCheckBox;
    Label6: TLabel;
    bottompanel: TPanel;
    btn_Change: TButton;
    btn_Cancel: TButton;
    Button1: TButton;
    Panel2: TPanel;
    procedure cb_tmodeClick(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_ChangeClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  TerminalWnd: TTerminalWnd;

implementation

uses uSharpDeskMainForm,
     uSharpDeskFunctions;

{$R *.dfm}

procedure TTerminalWnd.FormShow(Sender: TObject);
var
  n : integer;
begin
  cb_tmode.Checked := SharpDesk.DeskSettings.TerminalMode;
  cb_smenu.Checked := SharpDesk.DeskSettings.SharpMenu;
  cb_omenu.Checked := SharpDesk.DeskSettings.ObjectMenu;
  cb_omove.Checked := SharpDesk.DeskSettings.ObjectMove;
  cb_tload.Checked := SharpDesk.DeskSettings.ThemeLoading;
  cb_edesk.Checked := SharpDesk.DeskSettings.ExitDesk;
  cb_tmode.OnClick(cb_tmode);

  n := GetCurrentMonitor;
  self.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - self.Width div 2;
  self.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - self.Height div 2;
end;

procedure TTerminalWnd.btn_ChangeClick(Sender: TObject);
begin
  SharpDesk.DeskSettings.TerminalMode := cb_tmode.Checked;
  SharpDesk.DeskSettings.SharpMenu    := cb_smenu.Checked;
  SharpDesk.DeskSettings.ObjectMenu   := cb_omenu.Checked;
  SharpDesk.DeskSettings.ObjectMove   := cb_omove.Checked;
  SharpDesk.DeskSettings.ThemeLoading := cb_tload.Checked;
  SharpDesk.DeskSettings.ExitDesk     := cb_edesk.Checked;
  SharpDesk.DeskSettings.SaveSettings;
  Close;
end;

procedure TTerminalWnd.btn_CancelClick(Sender: TObject);
begin
  Close;
end;

procedure TTerminalWnd.cb_tmodeClick(Sender: TObject);
begin
  GroupBox1.Enabled := cb_tmode.Checked;
  cb_smenu.Enabled := cb_tmode.Checked;
  cb_omenu.Enabled := cb_tmode.Checked;
  cb_omove.Enabled := cb_tmode.Checked;
  cb_tload.Enabled := cb_tmode.Checked;
  cb_edesk.Enabled := cb_tmode.Checked;
  Label2.Enabled := cb_tmode.Checked;
  Label3.Enabled := cb_tmode.Checked;
  Label4.Enabled := cb_tmode.Checked;
  Label5.Enabled := cb_tmode.Checked;
  Label6.Enabled := cb_tmode.Checked;
end;

end.
