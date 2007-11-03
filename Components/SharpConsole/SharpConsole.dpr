program SharpConsole;

uses
  Forms,
  uVistaFuncs,
  Main in 'Main.pas' {SharpConsoleWnd},
  uDebugging,
  uTDebugging,
  SharpApi,
  TextConverterUnit in 'TextConverterUnit.pas',
  uDebugList in 'uDebugList.pas';

{$R *.RES}
{$R metadata.res}

begin
  Application.Initialize;
  Application.Title := 'SharpConsole';
  Application.CreateForm(TSharpConsoleWnd, SharpConsoleWnd);
  uVistaFuncs.SetVistaFonts(SharpConsoleWnd);
  Debugging.PrintBanners := True;
  Debugging.Comment := 'SharpCore Logging System';
  Debugging.FileNaming := dfnDaily;

  Application.Run;
end.
