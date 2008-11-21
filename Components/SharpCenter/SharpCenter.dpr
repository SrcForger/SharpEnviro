program SharpCenter;

uses
  Forms,
  Windows,
  SharpApi,
  uSharpCenterMainWnd in 'uSharpCenterMainWnd.pas' {SharpCenterWnd},
  uSharpCenterDllMethods in 'uSharpCenterDllMethods.pas',
  uSharpCenterHelperMethods in 'uSharpCenterHelperMethods.pas',
  uSharpCenterHistoryList in 'uSharpCenterHistoryList.pas',
  uSharpCenterFavManager in 'uSharpCenterFavManager.pas',
  uSharpCenterManager in 'uSharpCenterManager.pas',
  uSharpCenterThemeManager in 'uSharpCenterThemeManager.pas',
  ISharpCenterPluginUnit in '..\..\Common\Interfaces\ISharpCenterPluginUnit.pas',
  uSharpCenterPluginManager in 'uSharpCenterPluginManager.pas',
  uSharpCenterHost in 'uSharpCenterHost.pas',
  ISharpCenterHostUnit in '..\..\Common\Interfaces\ISharpCenterHostUnit.pas',
  IXmlBaseUnit in '..\..\Common\Interfaces\IXmlBaseUnit.pas';

{$R *.res}
{$R metadata.res}

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
  {$IFDEF VER185} Application.MainFormOnTaskBar := True; {$ENDIF}

  exit := False;
  CheckMutex(exit);
  if exit then Application.Terminate else begin

  Application.CreateForm(TSharpCenterWnd, SharpCenterWnd);
  Application.Run;
  end;
 end.
