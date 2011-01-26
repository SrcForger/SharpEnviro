program ExecTest;

uses
  ShareMem,
  Forms,
  uExecTest in 'uExecTest.pas' {Form1},
  uExecServiceAliasList in 'uExecServiceAliasList.pas',
  uExecServiceExecute in 'uExecServiceExecute.pas',
  uExecServicePathIncludeList in 'uExecServicePathIncludeList.pas',
  uExecServiceRecentItemList in 'uExecServiceRecentItemList.pas',
  uExecServiceSettings in 'uExecServiceSettings.pas',
  uExecServiceUsedItemList in 'uExecServiceUsedItemList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
