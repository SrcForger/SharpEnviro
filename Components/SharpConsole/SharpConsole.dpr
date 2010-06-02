program SharpConsole;

uses
  Forms,
  uVistaFuncs,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
  Main in 'Main.pas' {SharpConsoleWnd},
  uDebugging,
  uTDebugging,
  SharpApi,
  TextConverterUnit in 'TextConverterUnit.pas',
  uDebugList in 'uDebugList.pas',
  FatThings in 'FatThings.pas';

{$R *.RES}
{$R metadata.res}

begin
  Application.Initialize;
  Application.Title := 'SharpConsole';
  Application.CreateForm(TSharpConsoleWnd, SharpConsoleWnd);
  uVistaFuncs.SetVistaFonts(SharpConsoleWnd);
  Debugging.LogDirectory := SharpApi.GetSharpeUserSettingsPath + 'Logs\';
  Debugging.PrintBanners := True;
  Debugging.Comment := 'SharpCore Logging System';
  Debugging.FileNaming := dfnDaily;

  Application.Run;
end.
