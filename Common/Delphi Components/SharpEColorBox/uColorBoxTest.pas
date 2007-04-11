unit uColorBoxTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uSharpEColorBox, ExtCtrls, StdCtrls, uSharpEFontSelector, XPMan,
  sharpthemeapi;

type
  TForm1 = class(TForm)
    Button1: TButton;
    SharpEFontSelector1: TSharpEFontSelector;
    Edit1: TEdit;
    Panel1: TPanel;
    SharpEColorBox1: TSharpEColorBox;
    SharpEFontSelector2: TSharpEFontSelector;
    XPManifest1: TXPManifest;
    procedure FormCreate(Sender: TObject);
    procedure SharpEColorBox1ColorClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  cb:TSharpEColorBox;
begin
  cb := TSharpEColorBox.Create(self);
  cb.Parent := self;
  cb.Left := 100;
  cb.top := 100;
  cb.OnColorClick := SharpEColorBox1ColorClick;
end;

procedure TForm1.SharpEColorBox1ColorClick(Sender: TObject);
begin
  Panel1.Caption :=  IntToStr(TSharpEColorBox(Sender).ColorCode);
  Panel1.Color := TSharpEColorBox(Sender).Color;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  sharpthemeapi.LoadTheme;
end;

end.
