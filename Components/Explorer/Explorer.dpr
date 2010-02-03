program Explorer;

uses
  Windows,
  ActiveX,
  Forms,
  uSharpExplorerForm in 'uSharpExplorerForm.pas' {ExplorerForm},
  SharpAPI in '..\..\Common\Libraries\SharpAPI\SharpAPI.pas';

{$R *.res}
{$R metadata.res}

begin
  CoInitialize(nil);

  Application.Initialize;
  Application.Title := 'SharpExplorer';
  Application.ShowMainForm := False;
  {$IFDEF VER185} Application.MainFormOnTaskBar := True; {$ENDIF}
  SetWindowLong(Application.Handle, GWL_EXSTYLE,
                 GetWindowLong(Application.Handle, GWL_EXSTYLE) or
                 WS_EX_TOOLWINDOW and not WS_EX_APPWINDOW);
  Application.CreateForm(TSharpExplorerForm, SharpExplorerForm);
  ServiceDone('Explorer');

  Application.Run;
end.
