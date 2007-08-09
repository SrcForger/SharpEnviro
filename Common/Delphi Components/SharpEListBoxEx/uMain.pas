unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PngImageList, ComCtrls, Buttons,
  PngSpeedButton, SharpEListBoxEx, ImgList, ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PngSpeedButton1: TPngSpeedButton;
    SharpEListBoxEx1: TSharpEListBoxEx;
    col1: TPngImageList;
    PngImageList1: TPngImageList;
    procedure SharpEListBoxEx1MeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure SharpEListBoxEx1GetCellFont(const ACol: Integer;
      AItem: TSharpEListItem; var AFont: TFont);

    procedure Button1Click(Sender: TObject);
    procedure SharpEListBoxEx1ClickItem(const ACol: Integer;
      AItem: TSharpEListItem);
  private
    { Private declarations }
    lb: TSharpEListBoxEx;
    Procedure GetCellCursor(const ACol:Integer; AItem:TSharpEListItem; var ACursor:TCursor);
    public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  //tmpItem: TSharpEListBoxItem;
  tmpCol: TSharpEListBoxExColumn;
  li: TSharpEListItem;

begin

  SharpEListBoxEx1.OnGetCellCursor := GetCellCursor;
  SharpEListBoxEx1.ItemOffset := Point(4,4);
  SharpEListBoxEx1.itemheight := 54;

  li := SharpEListBoxEx1.AddItem('New Theme',1);
  li.AddSubItem('lcgreen@gmail.com',1);
  li.AddSubItem('',1);
  li.AddSubItem('TRUE',1,2);
  li.Hint := 'Click to set as default';

end;

procedure TForm1.GetCellCursor(const ACol: Integer; AItem: TSharpEListItem;
  var ACursor: TCursor);
begin
   if ACol >= 2 then
    ACursor := crHandPoint;
end;

procedure TForm1.SharpEListBoxEx1ClickItem(const ACol: Integer;
  AItem: TSharpEListItem);
begin
  ShowMessage(inttostr(acol));
end;

procedure TForm1.SharpEListBoxEx1GetCellFont(const ACol: Integer;
  AItem: TSharpEListItem; var AFont: TFont);
begin
  if ACol = 0 then begin
  AFont.Style := [fsBold];
  AFont.Size := 9;
  AFont.Name := 'courier';
  end;
  if ACol = 1 then AFont.Style := [fsItalic];
  if ACol = 2 then AFont.Style := [fsUnderline];
end;

procedure TForm1.SharpEListBoxEx1MeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  if Index = 1 then height := 50;
end;

end.


