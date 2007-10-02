{
Source Name: uShutdown
Description: Class to handle Shutdown
Copyright (C) Lee Green

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

unit uShutdown;

interface

uses
  Windows,
  Messages,
  SysUtils;

type
  TShutdownActionType = (sdPowerOff, sdShutdown, sdReboot, sdLogOff,
    sdSuspend, sdHibernate);

  TQueryShutdownEvent = procedure(Sender: TObject;
    var CanShutdown: Boolean) of object;

type
  TSEShutDown = class(TObject)
  private

    FActionType: TShutdownActionType;
    FForce: Boolean;
    FOnQueryShutdown: TQueryShutdownEvent;

  protected
    procedure DoQueryShutdown(var CanShutdown: Boolean); virtual;

  public
    constructor Create; reintroduce;
    function Execute: Boolean; virtual;

    property ActionType: TShutDownActionType read FActionType
      write FActionType default sdPowerOff;
    property Force: Boolean read FForce write FForce default False;

    property OnQueryShutdown: TQueryShutdownEvent read FOnQueryShutdown
      write FOnQueryShutdown;
  end;

implementation

{ TScShutDown }

constructor TSEShutDown.Create;
begin
  FActionType := sdPowerOff;
  FForce := False;
  inherited;
end;

procedure TSEShutDown.DoQueryShutdown(var CanShutdown: Boolean);
begin
  if Assigned(FOnQueryShutdown) then
    FOnQueryShutdown(Self, CanShutdown);
end;

function TSEShutDown.Execute: Boolean;
var
  hToken, hProcess: THandle;
  tp, prev_tp: TTokenPrivileges;
  Len, Flags: DWORD;
  CanShutdown: Boolean;
begin
  Result := False;
  if Win32Platform = VER_PLATFORM_WIN32_NT then begin
    hProcess := OpenProcess(PROCESS_ALL_ACCESS, True, GetCurrentProcessID);
    try
      if not OpenProcessToken(hProcess, TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
        hToken) then
        Exit;
    finally
      CloseHandle(hProcess);
    end;
    try
      if not LookupPrivilegeValue('', 'SeShutdownPrivilege',
        tp.Privileges[0].Luid) then
        Exit;
      tp.PrivilegeCount := 1;
      tp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      if not AdjustTokenPrivileges(hToken, False, tp, SizeOf(prev_tp),
        prev_tp, Len) then
        Exit;
    finally
      CloseHandle(hToken);
    end;
  end;
  CanShutdown := True;
  DoQueryShutdown(CanShutdown);
  if not CanShutdown then
    Exit;
  if FForce then
    Flags := EWX_FORCE
  else
    Flags := 0;
  case FActionType of
    sdPowerOff: Result := ExitWindowsEx(Flags or EWX_POWEROFF, 0);
    sdShutdown: Result := ExitWindowsEx(Flags or EWX_SHUTDOWN, 0);
    sdReboot: Result := ExitWindowsEx(Flags or EWX_REBOOT, 0);
    sdLogoff: Result := ExitWindowsEx(Flags or EWX_LOGOFF, 0);
    sdSuspend: Result := SetSystemPowerState(True, FForce);
    sdHibernate: Result := SetSystemPowerState(False, FForce);
  end;
end;

end.
