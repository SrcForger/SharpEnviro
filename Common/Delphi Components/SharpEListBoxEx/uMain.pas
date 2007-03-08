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
    procedure SharpEListBoxEx1GetCellFont(const ACol: Integer;
      AItem: TSharpEListItem; var AFont: TFont);
    procedure SharpEListBox1ClickItem(AText: string; AItem, ACol: Integer);

    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    lb: TSharpEListBoxEx;
    Procedure ClickItem(AText: String; AItem:Integer; ACol:Integer);
    Procedure GetCellText(const ACol:Integer; AItem:TSharpEListItem; var AColor:TColor);
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

  SharpEListBoxEx1.OnClickItem := ClickItem;
  SharpEListBoxEx1.OnGetCellTextColor := GetCellText;
  SharpEListBoxEx1.OnGetCellCursor := GetCellCursor;
  SharpEListBoxEx1.ItemOffset := Point(4,4);
  SharpEListBoxEx1.itemheight := 54;

  li := SharpEListBoxEx1.AddItem('Column1aaaaaaaaaaaa',2,0);
  li.AddSubItem('Columnaaaaaaaaaaaaaaaaa',1);
  li.AddSubItem('Column3bbbbbbbbbbbbbbbbbbbbb');
  li.Hint := 'Click to set as default';
  li := SharpEListBoxEx1.AddItem('Column1aaaaaaaaaaaa');
  li.AddSubItem('Columnaaaaaaaaaaaaaaaaa');
  li.AddSubItem('Column3bbbbbbbbbbbbbbbbbbbbb');
  li.Hint := 'Click to set as default';

end;

procedure TForm1.ClickItem(AText: String; AItem, ACol: Integer);
begin

end;

procedure TForm1.GetCellCursor(const ACol: Integer; AItem: TSharpEListItem;
  var ACursor: TCursor);
begin
   if ACol = 3 then
    ACursor := crHandPoint;
end;

procedure TForm1.GetCellText(const ACol: Integer; AItem:TSharpEListItem; var AColor: TColor);
begin

end;

procedure TForm1.SharpEListBox1ClickItem(AText: string; AItem, ACol: Integer);
begin
  ShowMessage('Test');
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

end.


