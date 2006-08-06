{
Source Name: Components
Description: A components service for SharpCore
Copyright (C)
              Zack Cerza - zcerza@coe.neu.edu (original dev)
              Pixol (Pixol@sharpe-shell.org)

3rd Party Libraries used: JCL, JVCL
Common: SharpApi

Source Forge Site
https://sourceforge.net/projects/sharpe/

Main SharpE Site
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

library components;

uses
  Forms,
  windows,
  dialogs,
  sysutils,
  SharpApi,
  uCompServiceAppStore in 'uCompServiceAppStore.pas',
  uCompServiceMain in 'uCompServiceMain.pas',
  uCompServiceAppStatus in 'uCompServiceAppStatus.pas';

{$E service}
{$WARN SYMBOL_DEPRECATED OFF}

{$R *.res}

procedure Stop;
begin
  Freeandnil(CompServ);

  if Assigned(frmComponentStat) then
    FreeAndNil(frmComponentStat);

  DeallocateHWnd(h);
  UnRegisterAction('!ToggleCompStatusWnd');
end;

{$HINTS OFF}

function Start(owner: hwnd): hwnd;
begin
  Result := Application.Handle;

  // Create the comp store
  CompServ := TComponentServ.Create;

  h := AllocateHWnd(CompServ.MessageHandler);

  // Create info wnd
  frmComponentStat := TfrmComponentStat.Create(Application.MainForm);
  frmComponentStat.Visible := False;

  with CompServ do
  begin

    ItemStorage.FileName := GetListFileName;
    if FileExists(ItemStorage.FileName) then
      ItemStorage.Load
    else
      ItemStorage.New;

    // Now load them
    ProcessList;

    // Add Bang
    RegisterAction('!ToggleCompStatusWnd', h, 0);
  end;
end;
{$HINTS ON}

procedure DisplayInfoWnd;
begin
  // Set the Form Position
  CompServ.DisplayInfoWnd;
end;

procedure Reload;
begin
  ItemStorage.Clear;
  ItemStorage.Load();
end;

exports
  Start,
  DisplayInfoWnd,
  Reload,
  Stop;

end.
