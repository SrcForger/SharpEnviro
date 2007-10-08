unit uSwatchManagerTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpESwatchManager, GR32_Image, GR32, StdCtrls, GR32_Layers,
  Types;

type
  TForm3 = class(TForm)
    SharpESwatchManager1: TSharpESwatchManager;
    img: TImage32;
    Button2: TButton;
    procedure imgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
    procedure FormResize(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure SharpESwatchManager1UpdateSwatchBitmap(ASender: TObject;
      const ABitmap32: TBitmap32);
    procedure SharpESwatchManager1GetWidth(ASender: TObject;
      var AWidth: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.SharpESwatchManager1GetWidth(ASender: TObject;
  var AWidth: Integer);
begin
  AWidth := img.Width;
end;

procedure TForm3.SharpESwatchManager1UpdateSwatchBitmap(ASender: TObject;
  const ABitmap32: TBitmap32);
begin
  img.Bitmap.SetSize(ABitmap32.Width,ABitmap32.Height);
  img.Bitmap.Assign(ABitmap32);
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
SharpESwatchManager1.Resize;
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  SharpESwatchManager1.AddSwatch(clRed,'Red');
  SharpESwatchManager1.AddSwatch(clBlue,'Blue');
  SharpESwatchManager1.AddSwatch(clGreen,'Green');
end;

procedure TForm3.Button2Click(Sender: TObject);
var
  i:Integer;
begin
  SharpESwatchManager1.BeginUpdate;
  Try
  for i := 0 to 100 do begin
    Randomize;
    SharpESwatchManager1.AddSwatch(Random(100000),'');
  end;

  Finally
    SharpESwatchManager1.EndUpdate;
  End;
end;

procedure TForm3.FormResize(Sender: TObject);
begin
  SharpESwatchManager1.Resize;
end;

procedure TForm3.imgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer; Layer: TCustomLayer);
begin
  SharpESwatchManager1.SetItemSelected(Point(X,Y));
end;

end.
