{
Source Name: MainWnd.pas
Description: SetShell Main Window
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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uShellSwitcher, uShutdown;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    rg_shell: TRadioGroup;
    Panel2: TPanel;
    btn_cancel: TButton;
    btn_ok: TButton;
    Panel3: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    cb_seb: TCheckBox;
    Label2: TLabel;
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.btn_cancelClick(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.btn_okClick(Sender: TObject);
var
  dir : string;
  Shutdown : TSEShutDown;
begin
  case rg_shell.ItemIndex of
    0: begin
         dir := ExtractFileDir(Application.ExeName);
         dir := IncludeTrailingBackSlash(dir);
         SetNewShell(dir + 'SharpCore.exe');
       end;
    else uShellSwitcher.SetNewShell('explorer.exe');
  end;

  if not uShellSwitcher.IsSeperateExplorerFixApplied then
  begin
    if not uShellSwitcher.ApplySeperateExplorerFix then
       MessageBox(handle,
                  'Unable to apply the seperate explorer fix. Make sure that you have Administrator Priviledges',
                  'Seperate Explorer Fix Failed',
                  MB_OK or MB_ICONEXCLAMATION);
  end;

  if MessageBox(handle,
                PChar('It is necessary to reboot the computer for the changes to take effect' + #10 + #13 +
                'Reboot now?'),'Confirm Reboot', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    Shutdown := TSEShutDown.Create;
    try
      ShutDown.ActionType := sdReboot;
      ShutDown.Force := True;
      ShutDown.Execute;
    finally
      ShutDown.Free;
    end;
  end;
end;

end.
