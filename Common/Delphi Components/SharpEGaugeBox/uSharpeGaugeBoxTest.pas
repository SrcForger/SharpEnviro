unit uSharpeGaugeBoxTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, uSharpeGaugeBoxEdit, StdCtrls, Mask,
  JvExMask, JvSpin, JvExStdCtrls, JvEdit, ComCtrls, JvExExtCtrls, JvComponent,
  JvPanel, DBCtrls, ActnMan, ActnColorMaps, XPMan;

type
  TForm1 = class(TForm)
    Button1: TButton;
    XPManifest1: TXPManifest;
    XPColorMap1: TXPColorMap;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Procedure ChangedValue(Sender:TObject; Value:Integer);
  end;

var
  Form1: TForm1;
  SharpeGaugeBox1: TSharpeGaugeBox;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);

begin
  SharpeGaugeBox1 := TSharpeGaugeBox.Create(Self);
  SharpeGaugeBox1.Parent := Self;
  SharpeGaugeBox1.Left := 50;
  SharpeGaugeBox1.Top := 50;
  SharpeGaugeBox1.Height := 19;
  SharpeGaugeBox1.Width := 75;
  SharpeGaugeBox1.Suffix := '%';
  SharpeGaugeBox1.Prefix := '';
  SharpeGaugeBox1.OnChangeValue := ChangedValue;
  SharpeGaugeBox1.Color := clWindow;

  SharpeGaugeBox1 := TSharpeGaugeBox.Create(Self);
  SharpeGaugeBox1.Parent := Self;
  SharpeGaugeBox1.Left := 50;
  SharpeGaugeBox1.Top := 150;
  SharpeGaugeBox1.Width := 175;
  SharpeGaugeBox1.Suffix := 'mm';
  SharpeGaugeBox1.Prefix := 'Line: ';
  SharpeGaugeBox1.PopPosition := ppBottom;
  SharpeGaugeBox1.Enabled := True;
  SharpeGaugeBox1.OnChangeValue := ChangedValue;

end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  Key := #0;
end;

procedure TForm1.ChangedValue(Sender: TObject; Value: Integer);
begin
  //JvSpinEdit1.Value := Value;
end;

end.
