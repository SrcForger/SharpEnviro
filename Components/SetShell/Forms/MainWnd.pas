{
Source Name: MainWnd.pas
Description: SetShell Main Window
Copyright (C) Martin Krämer <MartinKraemer@gmx.net>

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

unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uShellSwitcher, uShutdown, uSystemFuncs, GR32_Image;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btn_cancel: TButton;
    btn_ok: TButton;
    Panel3: TPanel;
    Label1: TLabel;
    Panel4: TPanel;
    cb_seb: TCheckBox;
    Label2: TLabel;
    gpShells: TGroupBox;
    rbSharpE: TRadioButton;
    rbExplorer: TRadioButton;
    imgSharpE: TImage32;
    imgExplorer: TImage32;
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
  if rbSharpE.Checked then
  begin
    dir := ExtractFileDir(Application.ExeName);
    dir := IncludeTrailingPathDelimiter(dir);
    SetNewShell(PChar(dir + 'SharpCore.exe -startup'));
  end
    else SetNewShell('explorer.exe');

  // Only apply the separate explorer fix if the use wants it and it is not applied.
  if (cb_seb.Checked) and (not IsSeparateExplorerFixApplied) then
  begin
    if not ApplySeparateExplorerFix then
       MessageBox(Handle,
                  'Unable to apply the seperate explorer fix. Make sure that you have Administrator Privileges',
                  'Applying Seperate Explorer Fix Failed',
                  MB_OK or MB_ICONEXCLAMATION);
  end;

  // Only remove the separate explorer fix if the user doesn't want it and it is applied.
  if (not cb_seb.Checked) and (IsSeparateExplorerFixApplied) then
  begin
    if not RemoveSeparateExplorerFix then
      MessageBox(Handle,
        'Unable to remove the separate explorer fix.  Make sure that you have Administrator Privileges',
        'Removing Separate Explorer Fix Failed',
        MB_OK or MB_ICONEXCLAMATION);    
  end;

  // Only apply the IniFileMapping fix if it is not, avoids unnecessarily showing the elevation dialog.
  if not IsIniFileMappingFixApplied then
    ApplyIniFileMappingFix;
  
  if MessageBox(handle,
                PChar('It is necessary to reboot the computer for the changes to take effect' + #10 + #13 +
                'Reboot now?'),'Confirm Reboot', MB_YESNO or MB_ICONQUESTION) = IDYES then
  begin
    ShutDown := TSEShutDown.Create(Self.Handle);
    try
      ShutDown.ActionType := sdReboot;
      ShutDown.Force := True;
      Shutdown.Verbose := False;
      ShutDown.Execute;
    finally
      ShutDown.Free;
    end;
  end else Application.Terminate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  s : String;
begin
  {$WARNINGS OFF} s := IncludeTrailingBackSlash(ExtractFileDir(Application.ExeName))+'Temp.Temp'; {$WARNINGS ON}
  if not HasWriteAccess(s) then
  begin
    ShowMessage('SetShell.exe has detected that it is executed from a directory ' +
                'with limited access rights. Your user account has no access ' +
                'rights to write data into this directory. This can be due to ' +
                'limited access rights on the directory or because of a directory ' +
                'which is protected by the UAC (User Account Control) of Windows Vista or Later. ' +
                'On Windows Vista or later it is not possible to run SharpE from ' +
                'a protected Directory like "Program Files". Please chose another Directory ' +
                'for SharpE. For example "C:\SharpE\"');
    cb_seb.Enabled := False;
    cb_seb.Checked := False;
    Label2.Enabled := False;
  end;
end;

end.
