program SharpCenter;

uses
//  VCLFixPack,
  Forms,
  Windows,
  SharpApi,
  SharpCenterApi,
  SharpThemeApiEx,
  JvValidators,
  uThemeConsts,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
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

  enumCommandType: TSCC_COMMAND_ENUM;
  sPluginID: string;
  sCmd: string;
begin
  Application.Initialize;
  {$IFDEF VER185} Application.MainFormOnTaskBar := True; {$ENDIF}

  GetCurrentTheme.LoadTheme(ALL_THEME_PARTS); // Initialize Theme Api

  if CheckMutex then
  begin
    if SharpCenterWnd.GetCommandLineParams(enumCommandType, sCmd, sPluginID) then
      SharpCenterApi.CenterCommand(enumCommandType, PAnsiChar(sCmd), PAnsiChar(sPluginID));

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
