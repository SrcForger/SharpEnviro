unit uSharpeEPageControlTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEPageControl, StdCtrls, ExtCtrls, JvExControls, JvPageList;

type
  TForm4 = class(TForm)
    SharpEPageControl1: TSharpEPageControl;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
  SharpEPageControl1.Minimized := Not(SharpEPageControl1.Minimized);
end;

end.
