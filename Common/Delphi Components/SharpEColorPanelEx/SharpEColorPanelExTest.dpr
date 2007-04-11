program SharpEColorPanelExTest;

uses
  Forms,
  uSharpEColorPanelEx in 'uSharpEColorPanelEx.pas',
  uSharpeColorBox in '..\SharpEColorBox\uSharpeColorBox.pas',
  uSharpEColorPanelExTest in 'uSharpEColorPanelExTest.pas' {Form1},
  SharpEColorPanel in '..\SharpEColorPanel\SharpEColorPanel.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
