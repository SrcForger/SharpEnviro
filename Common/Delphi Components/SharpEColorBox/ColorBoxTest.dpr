program ColorBoxTest;

uses
  Forms,
  uColorBoxTest in 'uColorBoxTest.pas' {Form1},
  uSharpeColorBox in 'uSharpeColorBox.pas',
  SharpAPI in '..\..\Libraries\SharpAPI\SharpAPI.pas',
  SharpThemeApi in '..\..\Libraries\SharpThemeApi\SharpThemeApi.pas',
  uSharpEFontSelector in '..\SharpEFontSelector\uSharpEFontSelector.pas',
  uSharpEFontSelectorWnd in '..\SharpEFontSelector\uSharpEFontSelectorWnd.pas' {frmFontSelector},
  uFontList in '..\SharpEFontSelector\uFontList.pas',
  uSchemeList in '..\..\..\Plugins\Configurations\Scheme\uSchemeList.pas',
  uVistaFuncs in '..\..\Units\VistaFuncs\uVistaFuncs.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmFontSelector, frmFontSelector);
  Application.Run;
end.
