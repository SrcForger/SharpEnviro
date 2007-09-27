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

    procedure Button1Click(Sender: TObject);
    procedure SharpEListBoxEx1GetCellText(const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure SharpEListBoxEx1GetCellImageIndex(const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
  private
    { Private declarations }
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
  li: TSharpEListItem;

begin

  SharpEListBoxEx1.OnGetCellCursor := GetCellCursor;
  SharpEListBoxEx1.ItemOffset := Point(4,4);
  SharpEListBoxEx1.itemheight := 54;

  li := SharpEListBoxEx1.AddItem('<b>New Theme </b>By Lee <br>Created with creative juices',1);
  li.AddSubItem('<u>Copy</u>',0);
  li.AddSubItem('<u>Delete</u>',1);
  li.Hint := 'Click to set as default';

end;

procedure TForm1.GetCellCursor(const ACol: Integer; AItem: TSharpEListItem;
  var ACursor: TCursor);
begin
   if ACol >= 2 then
    ACursor := crHandPoint;
end;

procedure TForm1.SharpEListBoxEx1GetCellImageIndex(const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
begin
  if ACol = 0 then begin
    if ASelected then AImageIndex := 0 else
    AImageIndex := 10;
  end;
end;

procedure TForm1.SharpEListBoxEx1GetCellText(const ACol: Integer;
  AItem: TSharpEListItem; var AColText: string);
begin
  if ACol = 0 then AColText := '<b>Red Theme</b> By Lee Green<br><u>http://www.sharpenviro.com</u>';
end;

procedure TForm1.SharpEListBoxEx1MeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  if Index = 1 then height := 50;
end;

end.


