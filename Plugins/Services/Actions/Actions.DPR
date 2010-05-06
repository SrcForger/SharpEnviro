{
Source Name: Actions
Description: "Bang Implementation"
Copyright (C) Pixol (Lee Green)

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
  {$IFDEF DEBUG}DebugDialog,{$ENDIF}
  // Project
  uActionServiceList in 'uActionServiceList.pas',
  uActionServiceManager in 'uActionServiceManager.pas';

{$R *.RES}

function Start(owner: hwnd): hwnd;
begin
  Result := Application.Handle;
  ActionMgr := TActionMgr.Create;
  SharpEBroadCast(WM_SHARPEUPDATEACTIONS, 0, 1);
  ServiceDone('Actions');
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

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Actions';
    Description := 'Manages actions, or bang commands';
    Author := 'Lee Green (Pixol@sharpe-shell.org)';
    Version := '0.7.6.5';
    DataType := tteService;
    ExtraData := 'priority: 30| delay: 0';
  end;
end;

exports
  Start,
  SCMsg,
  Stop,
  GetMetaData;

begin

end.

