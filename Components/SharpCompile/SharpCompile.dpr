program SharpCompile;

uses
  Forms,
  SharpApi,
  fMain in 'fMain.pas' {frmMain},
  uCompiler in 'uCompiler.pas',
  DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas';

{$R *.res}
{$R metadata.res}

begin
  Application.Initialize;
  Application.Title := 'SharpCompile';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
