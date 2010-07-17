program SharpCompile;

{$R 'metadata.res' 'metadata.rc'}
{$R 'VersionInfo.res' 'VersionInfo.rc'}
{$R *.res}

uses
  Forms,
  SharpApi,
  DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',
  fMain in 'fMain.pas' {SharpCompileMainWnd},
  uCompiler in 'uCompiler.pas';

begin
  Application.Initialize;
  Application.Title := 'SharpCompile';
  Application.MainFormOnTaskBar := True;
  Application.CreateForm(TSharpCompileMainWnd, SharpCompileMainWnd);
  SharpCompileMainWnd.Icon := Application.Icon;
  Application.Run;
end.
