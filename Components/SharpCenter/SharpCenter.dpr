program SharpCenter;

uses
  Forms,
  Windows,
  uSharpCenterMainWnd in 'uSharpCenterMainWnd.pas' {SharpCenterWnd},
  uSharpCenterDllMethods in 'uSharpCenterDllMethods.pas',
  uSharpCenterHelperMethods in 'uSharpCenterHelperMethods.pas',
  uSharpCenterHistoryManager in 'uSharpCenterHistoryManager.pas',
  uSharpCenterFavManager in 'uSharpCenterFavManager.pas',
  uSharpCenterManager in 'uSharpCenterManager.pas';

{$R *.res}

procedure CheckMutex(var Terminate: Boolean);
var
  MutexHandle:THandle;
begin
  Terminate := False;
  MutexHandle := CreateMutex(nil, TRUE, Pchar('SharpCenterMutexX'));
  if MutexHandle <> 0 then begin
    if GetLastError = ERROR_ALREADY_EXISTS then begin
      CloseHandle(MutexHandle);
      Terminate := True;
      Exit;
    end;
  end;
end;

var
  exit:Boolean;
begin
  Application.Initialize;

  exit := False;
  CheckMutex(exit);
  if exit then Application.Terminate else begin

  Application.CreateForm(TSharpCenterWnd, SharpCenterWnd);
  Application.Run;
  end;
 end.
