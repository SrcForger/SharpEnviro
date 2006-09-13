{
Source Name: Not available
Description: Exec Service for SharpCore
Copyright (C) Lee Green (Pixol) pixol@sharpe-shell.org

3rd Party Libraries used: JCL, JVCL, CalcExpress
Common: SharpApi, SharpFX

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

library Exec;
uses
  Forms,
  windows,
  dialogs,
  graphics,
  SysUtils,
  uExecServiceExecute in 'uExecServiceExecute.pas',
  uExecServiceAliasList in 'uExecServiceAliasList.pas',
  uExecServicePathIncludeList in 'uExecServicePathIncludeList.pas',
  uExecServiceSettings in 'uExecServiceSettings.pas',
  uExecServiceRecentItemList in 'uExecServiceRecentItemList.pas',
  uExecServiceUsedItemList in 'uExecServiceUsedItemList.pas',
  CalcExpress in '..\..\..\Common\3rd party\CalcExpress\Source\CalcExpress.pas',
  SharpAPI in '..\..\..\Common\Libraries\SharpAPI\SharpAPI.pas';

{$E service}

{$R *.RES}

// Free all service resources

procedure Stop;
begin
  SharpExec.Free;
end;

//starts the service

function Start(owner: hwnd): hwnd;
begin
  Result := Application.Handle;
  SharpExec := tSharpExec.create;
  Handle := owner;
end;

//when receive message from sharpcore do this

function SCMsg(msg: string): integer;
const
  NoHistoryParam = '_nohist,';
begin
  Result := 0;
  Debug(Format('*** New Command: %s ***', [msg]), DMT_INFO);

  // Check if message sent is in Action command
  if ServiceMsg('actions', pchar('_exists,' + msg)) = 1 then begin
    SendDebugMessageEx('Exec Service', Pchar('Action Exists: ' + msg), 0, DMT_INFO);
    ServiceMsg('actions', pchar('_execute,' + msg));
    Exit;
  end;

  // Else the command is not an Action, so process it as normal
  if pos(NoHistoryParam, msg) <> 0 then
    SharpExec.ProcessString(copy(msg, length(NoHistoryParam) + 1, length(msg) -
      length(NoHistoryParam) + 1), false)
  else
    SharpExec.ProcessString(msg);

  // if the cmd is a calc, return the calc id
  if ShowAns then
    Result := 666;
end;

procedure Reload;
begin
  SharpExec.PathIncludeList.Load;
  SharpExec.AliasList.Load;
  SharpExec.ExecSettings.Load;

  SharpExec.RecentItemList.Items.Clear;
  SharpExec.RecentItemList.Load;

  SharpExec.UsedItemList.Items.Clear;
  SharpExec.UsedItemList.Load;
end;

exports
  Start,
  Reload,
  SCMsg,
  Stop;

end.

