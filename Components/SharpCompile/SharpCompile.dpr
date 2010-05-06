program SharpCompile;

uses
  Forms,
  SharpApi,
  {$IFDEF DEBUG}DebugDialog,{$ENDIF}
  fMain in 'fMain.pas' {SharpCompileMainWnd},
  uCompiler in 'uCompiler.pas';

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
