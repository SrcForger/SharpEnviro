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
function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'SharpConsole';
    Description := 'The debugging console';
    Author := 'Malx (Malx@sharpe-shell.org)';
    Version := '0.7.4.0';
    DataType := tteComponent;
    ExtraData := 'priority: 0| delay: 0';
  end;
end;

exports
  GetMetaData;

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
