program SharpCompile;







uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  VistaTheme in 'VistaTheme.pas',
  uCompiler in 'uCompiler.pas',
  DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SharpCompile';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
