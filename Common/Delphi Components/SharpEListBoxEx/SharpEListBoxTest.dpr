program SharpEListBoxTest;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  SharpEListBoxEx in 'SharpEListBoxEx.pas',
  SharpGraphicsUtils in '..\..\Units\SharpGraphicsUtils\SharpGraphicsUtils.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
