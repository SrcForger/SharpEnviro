program SharpConsole;

uses
  Forms,
  uVistaFuncs,
  Main in 'Main.pas' {SharpConsoleWnd},
  uDebugging,
  uTDebugging,
  TextConverterUnit in 'TextConverterUnit.pas',
  uDebugList in 'uDebugList.pas';

{$R *.RES}

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
