{
Source Name: Actions
Description: "Bang Implementation"
Copyright (C) Pixol (Lee Green)

3rd Party Libraries used: JCL, JVCL
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

library Actions;

uses
  // Standard
  windows,
  registry,
  Classes,
  Messages,
  activex,
  sysutils,
  forms,

  // JCL
  Jclstrings,

  // Common
  SharpApi,

  // Project
  uActionServiceList in 'uActionServiceList.pas',
  uActionServiceManager in 'uActionServiceManager.pas';

{$E ser}

{$R *.RES}

function Start(owner: hwnd): hwnd;
begin
  Result := Application.Handle;
  ActionMgr := TActionMgr.Create;
  SharpEBroadCast(WM_SHARPEUPDATEACTIONS, 0, 1);
end;

procedure Stop;
begin

  ActionMgr.Free;
  SharpEBroadCast(WM_SHARPEUPDATEACTIONS, 0, -1);
end;

function SCMsg(msg: string): integer;
var
  CmdList: TStringList;
  Cmd, Val: string;
begin
  Result := 0;

  CmdList := TStringList.Create;
  StrTokenToStrings(msg, ',', CmdList);

  // Get Command and value
  Cmd := CmdList.Strings[0];
  Val := Copy(msg, length(cmd) + 2, length(msg));
  CmdList.Free;

  // Action Commands, _execute, _updateaction, _registeraction, _unregisteraction, _buildactionlist

  if Cmd = AC_ACTION_EXISTS then // _exists
    Result := ActionMgr.ActionExists(Val)
  else if Cmd = AC_REGISTER_ACTION then // _registeraction
    ActionMgr.AddAction(Val)
  else if Cmd = AC_UPDATE_ACTION then // _updateaction
    ActionMgr.AddAction(Val)
  else if Cmd = AC_UNREGISTER_ACTION then // _unregisteraction
    ActionMgr.DelAction(Val)
  else if Cmd = AC_BUILD_ACTION_LIST then // _buildactionlist
    ActionMgr.BuildList(Val)
  else if Cmd = AC_EXECUTE_ACTION then // _execute
    ActionMgr.ExecAction(Val);

end;

exports
  Start,
  SCMsg,
  Stop;

begin

end.

