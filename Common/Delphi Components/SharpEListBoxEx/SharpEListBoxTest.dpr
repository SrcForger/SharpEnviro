program SharpEListBoxTest;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  SharpEListBox in 'SharpEListBox.pas',
  SharpEListBoxReg in 'SharpEListBoxReg.pas' {frmEditColumn};
  
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TfrmEditColumn, frmEditColumn);
  Application.Run;
end.
