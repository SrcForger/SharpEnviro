program ActionsTest;

uses
  Forms,
  uActionsServiceTestWnd in 'uActionsServiceTestWnd.pas' {Form4},
  uActionServiceList in 'uActionServiceList.pas',
  uActionServiceManager in 'uActionServiceManager.pas',
  uActionsServiceTest2Wnd in 'uActionsServiceTest2Wnd.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
