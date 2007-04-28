{
Source Name: uSharpDeskSettingsForm.pas
Description: SharpDesk settings Form
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

unit uSharpDeskDeskSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpApi, ComCtrls, StdCtrls, ShellApi, JvSimpleXML;

type

  TDeskSettingsForm = class(TForm)
    bottompanel: TPanel;
    btn_Change: TButton;
    btn_Cancel: TButton;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    Label10: TLabel;
    cb_acommand: TCheckBox;
    cb_oposcheck: TCheckBox;
    Label2: TLabel;
    GroupBox2: TGroupBox;
    cb_usegrid: TCheckBox;
    Label8: TLabel;
    edit_gridx: TEdit;
    Label9: TLabel;
    edit_gridy: TEdit;
    cb_singleclick: TCheckBox;
    Label3: TLabel;
    procedure FormShow(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_ChangeClick(Sender: TObject);
    procedure edit_gridxChange(Sender: TObject);
    procedure edit_gridyChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  public
    procedure LoadSettings;
    procedure SaveSettings;
  end;

var
  DeskSettingsForm: TDeskSettingsForm;

implementation

uses uSharpDeskMainForm,
     uSharpDeskFunctions;

{$R *.dfm}


procedure TDeskSettingsForm.LoadSettings();
begin
  cb_acommand.Checked  := SharpDesk.DeskSettings.AdvancedCommands;
  cb_oposcheck.Checked := SharpDesk.DeskSettings.CheckObjectPosition;
  cb_usegrid.Checked   := SharpDesk.DeskSettings.Grid;
  cb_singleclick.Checked := SharpDesk.DeskSettings.SingleClick;
  Edit_GridX.Text      := inttostr(SharpDesk.DeskSettings.GridX);
  Edit_GridY.Text      := inttostr(SharpDesk.DeskSettings.GridY);
end;


procedure TDeskSettingsForm.SaveSettings();
begin
  if (strtoint(edit_gridx.Text)>80) then edit_gridx.Text:='80'
     else if (strtoint(edit_gridx.Text)<2) then edit_gridx.Text:='2';
  if (strtoint(edit_gridy.Text)>80) then edit_gridy.Text:='80'
     else if (strtoint(edit_gridy.Text)<2) then edit_gridy.Text:='2';

  SharpDesk.DeskSettings.AdvancedCommands    := cb_acommand.Checked;
  SharpDesk.DeskSettings.Grid                := cb_usegrid.Checked;
  SharpDesk.DeskSettings.GridX               := strtoint(Edit_GridX.Text);
  SharpDesk.DeskSettings.GridY               := strtoint(Edit_GridY.Text);
  SharpDesk.DeskSettings.CheckObjectPosition := cb_oposcheck.Checked;
  SharpDesk.DeskSettings.SingleClick         := cb_singleclick.checked;

  SharpDesk.DeskSettings.SaveSettings;

  if SharpDesk.Desksettings.DragAndDrop then SharpDesk.DragAndDrop.RegisterDragAndDrop(SharpDesk.Image.Parent.Handle)
     else SharpDesk.DragAndDrop.UnregisterDragAndDrop(SharpDesk.Image.Parent.Handle);
end;


procedure TDeskSettingsForm.FormShow(Sender: TObject);
var
  n : integer;
begin
  SharpDeskMainForm.Enabled := False;
  n := GetCurrentMonitor;
  self.Left:=Screen.Monitors[n].Left + Screen.Monitors[n].Width div 2 - self.Width div 2;
  self.top:=Screen.Monitors[n].Top + Screen.Monitors[n].Height div 2 - self.Height div 2;
end;

procedure TDeskSettingsForm.btn_CancelClick(Sender: TObject);
begin
     DeskSettingsForm.Close;
end;

procedure TDeskSettingsForm.btn_ChangeClick(Sender: TObject);
begin
  SaveSettings;
  DeskSettingsForm.Close;
end;

procedure TDeskSettingsForm.edit_gridxChange(Sender: TObject);
begin
     try
        strtoint(edit_gridx.Text);
     except
           edit_gridx.Undo;
           exit;
     end;
end;

procedure TDeskSettingsForm.edit_gridyChange(Sender: TObject);
begin
     try
        strtoint(edit_gridx.Text);
     except
           edit_gridy.Undo;
           exit;
     end;
end;

procedure TDeskSettingsForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SharpDeskMainForm.Enabled := True;
end;

end.
