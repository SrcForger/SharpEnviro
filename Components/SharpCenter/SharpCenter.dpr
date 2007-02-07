program SharpCenter;

uses
  Forms,
  Windows,
  uSharpCenterMainWnd in 'uSharpCenterMainWnd.pas' {SharpCenterWnd},
  uSharpCenterManager in 'uSharpCenterManager.pas',
  uSharpCenterDllMethods in 'uSharpCenterDllMethods.pas',
  graphicsFX in '..\..\Common\Units\SharpFX\graphicsFX.pas',
  SharpFX in '..\..\Common\Units\SharpFX\SharpFX.pas',
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas',
  SharpERoundPanel in '..\..\Common\Delphi Components\SharpERoundPanel\SharpERoundPanel.pas';

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
