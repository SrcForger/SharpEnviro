program SharpCenter;

uses
  Forms,
  Windows,
  SharpApi,
  JvValidators,
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

function CheckMutex: Boolean;
var
  MutexHandle:THandle;
begin
  Result := False;
  MutexHandle := CreateMutex(nil, TRUE, Pchar('SharpCenterMutexX'));
  if MutexHandle <> 0 then begin
    if GetLastError = ERROR_ALREADY_EXISTS then begin
      CloseHandle(MutexHandle);
      Result := True;
      Exit;
    end;
  end;
end;

var
  CenterWnd : HWND;
begin
  Application.Initialize;
  {$IFDEF VER185} Application.MainFormOnTaskBar := True; {$ENDIF}

  if CheckMutex then
  begin
    CenterWnd := FindWindow('TSharpCenterWnd', 'SharpCenter');
    SetForegroundWindow(CenterWnd);
    Application.Terminate;
  end else
  begin
    Application.CreateForm(TSharpCenterWnd, SharpCenterWnd);
    SharpCenterWnd.Icon := Application.Icon;
    Application.Run;
  end;
 end.
