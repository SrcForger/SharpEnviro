{
Source Name: Not available
Description: Exec Service for SharpCore
Copyright (C) Lee Green (Pixol) lee@sharpenviro.com

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

library Exec;

uses
//  VCLFixPack,
  Forms,
  windows,
  graphics,
  SysUtils,
  StrUtils,
  sharpapi,
  {$IFDEF DEBUG}DebugDialog in '..\..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  uExecServiceExecute in 'uExecServiceExecute.pas',
  uExecServicePathIncludeList in 'uExecServicePathIncludeList.pas',
  uExecServiceSettings in 'uExecServiceSettings.pas',
  uExecServiceRecentItemList in 'uExecServiceRecentItemList.pas',
  uExecServiceUsedItemList in 'uExecServiceUsedItemList.pas',
  uAliasList in '..\..\..\Common\Units\AliasList\uAliasList.pas';

{$R *.RES}

// Free all service resources

procedure Stop;
begin
  SharpExec.Terminate;
  SharpExec.Free;

  DeleteCriticalSection(CritSect);
end;

//starts the service

function Start(owner: hwnd): hwnd;
begin
  InitializeCriticalSection(CritSect);

  Result := Application.Handle;
  SharpExec := tSharpExec.create;
  Handle := owner;
  ServiceDone('Exec');
  SharpExec.ReloadLists;
end;

//when receive message from sharpcore do this

function SCMsg(msg: string): integer;
var
  tmpAliasName, tmpAliasValue: String;
  bNoHist, bElevate, bProperties: Boolean;
const
  NoHistoryParam = '_nohist,';
  ElevateParam = '_elevate,';
  RefreshParam = '_refresh';
  AddAliasParam = '_addalias';
  PropertiesParam = '_properties,';
begin
	Result := 0;
	msg:=trim(msg);

	Debug(Format('*** New Command: %s ***', [msg]), DMT_INFO);

	EnterCriticalSection(CritSect);

	try
		if pos(RefreshParam,LowerCase(msg)) = 0 then
		begin
			// Check if message sent is in Action command
			if ServiceMsg('actions', pchar('_exists,' + msg)) <> 1 then
			begin
				// Check if message sent is supposed to add an Alias to the AliasList
				if pos(AddAliasParam,lowercase(msg)) <> 0 then begin
					tmpAliasName:= Copy(msg,AnsiPos(' ',msg)+1,
									  (posex(' ',msg,AnsiPos(' ',msg)+1)-(AnsiPos(' ',msg)+1))
								  );
					tmpAliasValue:= Copy(msg,posex(' ',msg,AnsiPos(' ',msg)+1)+1,Length(msg));
					if (Length(trim(tmpAliasName)) <> 0) and (Length(trim(tmpAliasValue)) <> 0) then
					begin
						SharpExec.AliasList.AddItem(tmpAliasName, tmpAliasValue);
						SharpExec.AliasList.Save;
					end;
				end;

				// Else the command is not an Action, so process it as normal
				bNoHist := Pos(NoHistoryParam, msg) <> 0;
				bElevate := Pos(ElevateParam, msg) <> 0;
				bProperties := Pos(PropertiesParam, msg) <> 0;
				if bElevate  then
					msg := Copy(msg, Length(ElevateParam) + 1, Length(msg) - Length(ElevateParam) + 1);
				if bNoHist then
					msg := Copy(msg, Length(NoHistoryParam) + 1, Length(msg) - Length(NoHistoryParam) + 1);
				if bProperties then
					msg := Copy(msg, Length(PropertiesParam) + 1, Length(msg) - Length(NoHistoryParam) + 1);


				SharpExec.AddProcessString(msg, Not(bNoHist), bElevate, bProperties);
      end else begin
				SendDebugMessageEx('Exec Service', Pchar('Action Exists: ' + msg), 0, DMT_INFO);
				ServiceMsg('actions', pchar('_execute,' + msg));
      end;
    end else
      SharpExec.ReloadLists;
	finally
		LeaveCriticalSection(CritSect);
	end;
end;

procedure Reload;
begin
  SharpExec.ReloadLists;
end;

function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'Exec';
    Description := 'Assists with executing strings, including process elevation and actions';
    Author := 'Lee (lee@sharpenviro.com)';
    Version := '0.8.0.0';
    DataType := tteService;
    ExtraData := 'priority: 20| delay: 0';
  end;
end;

exports
  Start,
  Reload,
  SCMsg,
  Stop,
  GetMetaData;

begin   
end.

