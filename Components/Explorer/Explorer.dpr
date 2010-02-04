program Explorer;

uses
  Windows,
  ActiveX,
  Forms,
  SysUtils,
  uSharpExplorerForm in 'uSharpExplorerForm.pas' {ExplorerForm},
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  uSharpWinDesk in 'uSharpWinDesk.pas';

{$R *.res}
{$R metadata.res}

var
  hMutex: THandle;
  winDir : PAnsiChar;
  cmdToExec : string;
  I : integer;

begin
  CoInitialize(nil);

  // We are creating a mutex because we only want 1 of our Explorer.exe processes.
  // For any subsequent attempts we will assume that the windows explorer.exe was
  // meant to be run and pass along any arguments.
  hMutex := CreateMutex(nil, TRUE, 'SharpExplorer');
  if hMutex <> 0 then
    if GetLastError = ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(hMutex);
      // Get the path to explorer.exe in the windows directory
      // so that we can launch it instead.
      winDir := StrAlloc(MAX_PATH);
      GetWindowsDirectory(winDir, MAX_PATH);
      cmdToExec := IncludeTrailingBackslash(winDir) + 'explorer.exe';
      if ParamCount > 0 then
        cmdToExec := '"' + cmdToExec + '"';

      for I := 1 to ParamCount do
        cmdToExec := cmdToExec + ' ' + ParamStr(i);
  
      SendDebugMessageEx('Explorer', cmdToExec, 0, DMT_TRACE);
      SharpExecute(cmdToExec);
      StrDispose(winDir);
      Exit;
    end;

  Application.Initialize;
  Application.Title := 'SharpExplorer';
  Application.ShowMainForm := False;
  {$IFDEF VER185} Application.MainFormOnTaskBar := True; {$ENDIF}
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
                 GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
  Application.CreateForm(TSharpExplorerForm, SharpExplorerForm);
  ServiceDone('Explorer');

  Application.Run;
end.
