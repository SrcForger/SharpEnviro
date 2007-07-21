{
Source Name: uSharpCoreImplementer
Description: Routines that handle the shell management
Copyright (C) Lee Green

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
unit uSharpCoreImplementer;

interface

uses
  // Standard
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  shellapi,
  ComCtrls,

  // Jedi
  JclSecurity,
  JclRegistry,
  JclStrings;

type
  TShellMgr = class(TObject)
  private
    procedure SetCurrentUserReg;
    procedure WriteShell;
  public
    procedure Check;
    function CurrentUserCheck: Boolean;
    procedure WriteExplorer;
  end;

  TSCImplementer = class(TObject)
  public
    ShellMgr: TShellMgr;
    constructor Create;
    procedure AppInitialise;
    procedure ApplySep;
    procedure CheckMutex(var Terminate: Boolean);
    procedure CheckParams(AParamCount: Integer; var AExitApp: Boolean; var AExtension: string;
      var ADebug: Boolean);
    procedure CreateClasses;
    procedure ShowSplash;
  end;

var
  SCI: TSCImplementer;
  MutexHandle: THandle;

const
  cWinLogonKey = 'Software\Microsoft\Windows NT\CurrentVersion\winlogon';
  cIniFileMap = 'Software\Microsoft\Windows NT\CurrentVersion\IniFileMapping\system.ini\boot';
  cUserWinLogon = 'USR:Software\Microsoft\Windows NT\CurrentVersion\Winlogon';

implementation

uses
  uSharpCoreShutDown,
  uSharpCoreStrings,
  uSharpCoreMainWnd,
  uSharpCoreServiceMan,
  uSharpCoreSettings,
  uSharpCoreHelperMethods;

{ TShellCheck }

{
******************************** TSCImplementer ********************************
}

constructor TSCImplementer.Create;
begin
  inherited;
  ShellMgr := TShellMgr.Create;
end;

procedure TSCImplementer.AppInitialise;
begin
  // Application Initialisation
  with Application do begin
    Initialize;
    ShowMainForm := False;
    Name := rsApplicationName;
  end;

  // Default dll extension
  ServiceManager.ServiceExt := '.service';

  // Hide tray icon
  SharpCoreMainWnd.Trayicon.IconVisible := False;
end;

procedure TSCImplementer.ApplySep;
var
  ShutDown: TScShutDown;
begin
  ShutDown := TScShutDown.Create(nil);
  try
    // Must have administrator account
    if not (IsAdministrator) then begin
      MessageDlg(rsAdminAccountRequired, mtError, mbOKCancel, 0);
    end;

    // Show Seperate Explorer Process dialog
    if MessageDlg(rsSeperateExplorer, mtWarning, mbOKCancel, 0) = mrOk then begin
      if ShellMgr.CurrentUserCheck = True then begin
        if MessageDlg(rsFixApplied, mtWarning, mbOKCancel, 0) = mrOk then begin
          with ShutDown do begin
            ActionType := sdReboot;
            Force := True;
            Execute;
          end;
        end;
      end
      else begin
        MessageDlg(rsFixAlreadyApplied, mtError, mbOKCancel, 0);
      end;
    end;
  finally
    shutdown.free;
  end;
end;

procedure TSCImplementer.CheckMutex(var Terminate: Boolean);
begin
  Terminate := False;
  DStatus(dsCheckMutex);
  MutexHandle := CreateMutex(nil, TRUE, Pchar(rsApplicationName));
  if MutexHandle <> 0 then begin
    if GetLastError = ERROR_ALREADY_EXISTS then begin
      DError(dsMutexFound);
      CloseHandle(MutexHandle);
      Terminate := True;
      Exit;
      //Application.Terminate;
      //Halt;
    end;
  end;
  DStatus(dsMutexNotFound);
end;

procedure TSCImplementer.CheckParams(AParamCount: Integer; var AExitApp: Boolean; var AExtension: string;
  var ADebug: Boolean);
var
  ShutDown: TScShutDown;
  sParam, s: string;
  bBreak: Boolean;
  n: Integer;
begin
  // Shell Check
  AExitApp := false;

  ShutDown := TScShutDown.Create(nil);
  try
    if (AParamCount >= 1) then begin

      // Get parameter
      sParam := GetCommandLine;

      // Passed parameter
      DInfo(Format(dsParamPassed, [sParam]));

      if (StrFind(prmEx,sParam) <> 0) then begin
        if MessageDlg(rsRevertShellExplorer, mtWarning, [mbYes, mbNo], 0) = mrYes then begin
          ShellMgr.WriteExplorer;
          MessageDlg(rsExplorerRestored, mtInformation, [mbok], 0);
          AExitApp := True;
        end
        else
          AExitApp := True;
      end;

      // Command to seperate explorer process
      if (StrFind(prmSeps,sParam,1) <> 0) then begin

        // Must have administrator account
        if not (IsAdministrator) then begin
          MessageDlg(rsAdminAccountRequired, mtError, mbOKCancel, 0);
          AExitApp := True;
        end;

        // Show Seperate Explorer Process dialog
        if MessageDlg(rsSeperateExplorer, mtWarning, mbOKCancel, 0) = mrOk then begin
          if ShellMgr.CurrentUserCheck = True then begin
            if MessageDlg(rsFixApplied, mtWarning, mbOKCancel, 0) = mrOk then begin
              with ShutDown do begin
                ActionType := sdReboot;
                Force := True;
                ShutDown.Execute;
              end;
            end
            else
              AExitApp := True;
          end
          else begin
            MessageDlg(rsFixAlreadyApplied, mtError, mbOKCancel, 0);
            AExitApp := True;
          end;
        end
        else
          AExitApp := True;
      end;

      // Used for console debugging
      if (StrFind(prmDebug,sParam,1)) <> 0 then begin
        ADebug := True;
      end;

      // Used for debugging services
      if (StrFind(prmExt,sParam,1)) <> 0 then begin
        s := '';
        n := StrFind(prmExt,sParam,1)+length(prmExt)+1;
        repeat
          if sParam[n] = ' ' then
            bBreak := True;

          s := s + sParam[n];
          inc(n);

        until (n > Length(sParam)) or (bBreak);
        AExtension := s;
      end;
    end;
  finally
    ShutDown.Free;
  end;
end;

procedure TSCImplementer.CreateClasses;
var
  fn: string;
begin
  with Application do begin
    // Create Forms
    CreateForm(TSharpCoreMainWnd, SharpCoreMainWnd);
  end;

  // Create Service Manager
  ServiceManager := TServiceManager.Create;

  // Create and load component settings
  fn := SharpCoreSettingsFile;
  CompSettings := TCompSettings.Create(fn);
end;

procedure TSCImplementer.ShowSplash;
var
  sspath: string;
begin

  DInfo('Splash file: ' + ExtractFilePath(Application.ExeName) + 'SharpSplash.exe');
  sspath := ExtractFilePath(Application.ExeName) + 'SharpSplash.exe';

  // Try and display splash graphic
  if FileExists(sspath) then begin
    DInfo('Splash tool exists, attempting to launch');
    try
      ShellExecute(0, nil, PChar(sspath), PChar('Splash.png 3000 5000 3000'), '', 0);
    except
      DInfo('Error loading Splash Tool');
    end;
  end;
end;

{
********************************** TShellMgr ***********************************
}

procedure TShellMgr.Check;
var
  SD: TScShutDown;
  CShell: string;
begin
  sd := TScShutDown.Create(nil);

  try
    CShell := ReadRegVal(cWinLogonKey, 'shell', SharpCoreFile, HKEY_CURRENT_USER);

    if (CompSettings.ShellCheck) and (lowercase(CShell) <>
      lowercase(SharpCoreFile)) then begin
      case
        MessageDlg(rsNotDefaultShell, mtInformation, [mbYes, mbNo], 0) of
        mrYes: WriteShell;
      end;
    end;
  finally
    sd.Free;
  end;
end;

function TShellMgr.CurrentUserCheck: Boolean;
begin
  Result := True;

  RegWriteinteger(HKEY_LOCAL_MACHINE,
    'Software\Microsoft\Windows\CurrentVersion\Explorer', 'DesktopProcess', 1);

  if lowercase(ReadRegVal(cIniFileMap, 'shell', cUserWinLogon, hkey_local_machine)) <>
    lowercase(cUserWinLogon) then begin
    SetCurrentUserReg;
    Result := False;
  end;
end;

procedure TShellMgr.SetCurrentUserReg;
begin
  RegWriteString(hkey_local_machine, cIniFileMap, 'shell', cUserWinLogon);
end;

procedure TShellMgr.WriteExplorer;
begin
  WriteRegVal(cWinLogonKey, 'shell', 'explorer.exe', HKEY_CURRENT_USER);
end;

procedure TShellMgr.WriteShell;
begin
  WriteRegVal(cWinLogonKey, 'shell', SharpCoreFile, HKEY_CURRENT_USER);
end;

{ TSCImplementer }

end.

