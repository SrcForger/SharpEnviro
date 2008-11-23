program SharpeGaugeBox;

uses
  Forms,
  uSharpeGaugeBoxTest in 'uSharpeGaugeBoxTest.pas' {Form1},
  SharpeGaugeBoxWnd in 'SharpeGaugeBoxWnd.pas' {FrmSharpeGaugeBox},
  SharpEGaugeBoxEdit in 'SharpEGaugeBoxEdit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
