program SharpCompile;





uses
  Forms,
  fMain in 'fMain.pas' {frmMain},
  VistaTheme in 'VistaTheme.pas',
  uCompiler in 'uCompiler.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'SharpCompile';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
