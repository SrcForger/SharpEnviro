program ExecTest;

uses
  ShareMem,
  Forms,
  uExecTest in 'uExecTest.pas' {Form1},
  uExecServiceExecute in 'uExecServiceExecute.pas',
  uExecServicePathIncludeList in 'uExecServicePathIncludeList.pas',
  uExecServiceRecentItemList in 'uExecServiceRecentItemList.pas',
  uExecServiceSettings in 'uExecServiceSettings.pas',
  uExecServiceUsedItemList in 'uExecServiceUsedItemList.pas',
  uSharpXMLUtils in '..\..\..\Common\Units\XML\uSharpXMLUtils.pas',
  SharpSharedFileAccess in '..\..\..\Common\Units\SharpFileUtils\SharpSharedFileAccess.pas',
  uAliasList in '..\..\..\Common\Units\AliasList\uAliasList.pas',
  MonitorList in '..\..\..\Common\Units\MonitorList\MonitorList.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
