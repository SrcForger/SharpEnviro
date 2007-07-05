program SharpConsole;

uses
  Forms,
  uVistaFuncs,
  Main in 'Main.pas' {SharpConsoleWnd},
  uDebugging,
  uTDebugging,
  TextConverterUnit in 'TextConverterUnit.pas',
  uDebugList in 'uDebugList.pas',
  uCopyText in 'uCopyText.pas' {frmCopyText};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'SharpConsole';
  Application.CreateForm(TSharpConsoleWnd, SharpConsoleWnd);
  uVistaFuncs.SetVistaFonts(SharpConsoleWnd);
  Application.CreateForm(TfrmCopyText, frmCopyText);
  Debugging.PrintBanners := True;
  Debugging.Comment := 'SharpCore Logging System';
  Debugging.FileNaming := dfnDaily;

  Application.Run;
end.
