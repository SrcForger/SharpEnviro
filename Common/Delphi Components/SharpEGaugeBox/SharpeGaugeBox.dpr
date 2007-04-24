program SharpeGaugeBox;

uses
  Forms,
  uSharpeGaugeBoxEdit in 'uSharpeGaugeBoxEdit.pas',
  uSharpeGaugeBoxTest in 'uSharpeGaugeBoxTest.pas' {Form1},
  uSharpeGaugeBoxWnd in 'uSharpeGaugeBoxWnd.pas' {FrmSharpeGaugeBox};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
