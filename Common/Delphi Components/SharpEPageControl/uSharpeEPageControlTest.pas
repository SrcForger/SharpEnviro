unit uSharpeEPageControlTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEPageControl, StdCtrls, ExtCtrls, JvExControls, JvPageList,
  ImgList, PngImageList, uVistaFuncs;

type
  TForm4 = class(TForm)
    SharpEPageControl1: TSharpEPageControl;
    Button1: TButton;
    Button2: TButton;
    PngImageList1: TPngImageList;
    Panel1: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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

procedure TForm4.Button2Click(Sender: TObject);
begin
  SharpEPageControl1.TabList.Add('New',0);
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  SharpEPageControl1.DoubleBuffered := True;
  SetVistaFonts(Self);
end;

end.
