program SharpCompile;

uses
//  VCLFixPack,
  Forms,
  SharpApi,
  {$IFDEF DEBUG}DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas',{$ENDIF}
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
