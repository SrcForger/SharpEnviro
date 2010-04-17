program SharpCompile;

uses
  Forms,
  SharpApi,
  fMain in 'fMain.pas' {SharpCompileMainWnd},
  uCompiler in 'uCompiler.pas',
  DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas';

{$R *.res}
{$R metadata.res}

begin
  Application.Initialize;
  Application.Title := 'SharpCompile';
  Application.MainFormOnTaskBar := True;
  Application.CreateForm(TSharpCompileMainWnd, SharpCompileMainWnd);
  SharpCompileMainWnd.Icon := Application.Icon;
  Application.Run;
end.
