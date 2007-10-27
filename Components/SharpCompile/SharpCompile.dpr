program SharpCompile;







uses
  Forms,
  SharpApi,
  fMain in 'fMain.pas' {frmMain},
  VistaTheme in 'VistaTheme.pas',
  uCompiler in 'uCompiler.pas',
  DebugDialog in '..\..\Common\Units\DebugDialog\DebugDialog.pas';

{$R *.res}
function GetMetaData(): TMetaData;
begin
  with result do
  begin
    Name := 'SharpCompile';
    Description := 'The fanciest build tool in creation';
    Author := 'Nathan LaFreniere (mc@sharpe-shell.org)';
    Version := '0.7.4.0';
    DataType := tteComponent;
    ExtraData := 'priority: 0| delay: 0';
  end;
end;

exports
  GetMetaData;

begin
  Application.Initialize;
  Application.Title := 'SharpCompile';
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
