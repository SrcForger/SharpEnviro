unit uColorBoxTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEColorPicker, ExtCtrls, StdCtrls, XPMan,
  sharpthemeapi;

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    SharpEColorPicker1: TSharpEColorPicker;
    procedure FormCreate(Sender: TObject);
    procedure SharpEColorBox1ColorClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.SharpEColorBox1ColorClick(Sender: TObject);
begin
  Panel1.Caption :=  IntToStr(TSharpEColorPicker(Sender).ColorCode);
  Panel1.Color := TSharpEColorPicker(Sender).Color;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  sharpthemeapi.LoadTheme;
end;

end.
