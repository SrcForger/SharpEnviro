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
    sdLock, sdHibernate);

  TQueryShutdownEvent = procedure(Sender: TObject;
    var CanShutdown: Boolean) of object;

type
  TSEShutDown = class
  private

    FActionType: TShutdownActionType;
    FForce: Boolean;
    FOnQueryShutdown: TQueryShutdownEvent;
    FVerbose: Boolean;
    FParentHandle: THandle;
    function ShowConfirmation: Boolean;
    function GetParentHandle: THandle;
    function GetShutdownTypeAsString: string;
  protected
    procedure DoQueryShutdown(var CanShutdown: Boolean); virtual;

  public
    constructor Create(AParentHandle: THandle);
    function Execute: Boolean; virtual;

    property ActionType: TShutDownActionType read FActionType
      write FActionType default sdPowerOff;
    property Force: Boolean read FForce write FForce default False;

    property OnQueryShutdown: TQueryShutdownEvent read FOnQueryShutdown
      write FOnQueryShutdown;

    property Verbose: Boolean read FVerbose write FVerbose;
    property ParentHandle: THandle read GetParentHandle;
  end;

implementation

{ TScShutDown }

constructor TSEShutDown.Create(AParentHandle: THandle);
begin
  FActionType := sdPowerOff;
  FForce := False;
  FVerbose := True;
  FParentHandle := AParentHandle;

  inherited Create;
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

  // Show modal confirmation if enabled verbosity
  if not(ShowConfirmation) then
    Exit;

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
    sdLock: Windows.LockWorkStation;
    sdHibernate: Result := SetSystemPowerState(False, FForce);
  end;
end;

function TSEShutDown.GetParentHandle: THandle;
begin
  Result := FParentHandle;
end;

function TSEShutDown.GetShutdownTypeAsString: string;
begin
  case FActionType of
    sdPowerOff: result := 'power off';
    sdShutdown: result := 'shut down' ;
    sdReboot: result := 'reboot';
    sdLogOff: result := 'log off';
    sdLock: result := 'lock' ;
    sdHibernate: result := 'hibernate';
  end;
end;

function TSEShutDown.ShowConfirmation: Boolean;
var
  sTitle, sDescription, shutdownType: string;
begin
  if ( not(FVerbose) or (FActionType = sdLock)) then begin
    Result := true;
    exit;
  end;

  result := false;
  shutdownType := GetShutdownTypeAsString;
  sTitle := format('Do you really want to %s your computer?',[shutdownType]);
  sDescription := format('Confirm %s',[shutdownType]);

  if windows.MessageBox(FParentHandle, PChar(sTitle),
          PChar(sDescription), MB_YESNO or MB_ICONQUESTION or MB_APPLMODAL or MB_TOPMOST) = IDOK then
            result := true;
end;

end.
