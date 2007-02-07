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
    procedure SharpEListBoxEx1GetCellColor(const AItem: Integer;
      var AColor: TColor);
    procedure SharpEListBox1ClickItem(AText: string; AItem, ACol: Integer);
    procedure FormResize(Sender: TObject);
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
  lb := TSharpEListBoxEx.Create(Self);
  lb.Parent := Self;
  lb.Align := alClient;
  lb.Width := 500;
  lb.OnGetCellColor := SharpEListBoxEx1GetCellColor;
  lb.Visible := False;

  lb.OnClickItem := ClickItem;
  lb.OnGetCellTextColor := GetCellText;
  lb.OnGetCellCursor := GetCellCursor;
  lb.ItemOffset := Point(4,4);
  lb.itemheight := 54;

  tmpCol := lb.AddColumn('ItemIcon');
  tmpCol.Width := 50;
  tmpCol.HAlign := taCenter;
  tmpCol.VAlign := taVerticalCenter;
  tmpCol.PngImageList := Col1;

  tmpCol := lb.AddColumn('Main Text');
  tmpCol.Width := lb.Width - 100 - 50;
  tmpCol.HAlign := taLeftJustify;
  tmpCol.VAlign := taAlignTop;
  tmpCol.TextColor := clDkGray;
  tmpCol.SelectedTextColor := clBlack;
  tmpCol.PngImageList := Col1;

  tmpCol := lb.AddColumn('Status');
  tmpCol.Width := 68;
  tmpCol.HAlign := taLeftJustify;
  tmpCol.VAlign := taVerticalCenter;
  tmpCol.TextColor := clDkGray;
  tmpCol.SelectedTextColor := clBlack;

  tmpCol := lb.AddColumn('StatusIcon');
  tmpCol.Width := 25;
  tmpCol.HAlign := taCenter;
  tmpCol.VAlign := taVerticalCenter;
  tmpCol.TextColor := clDkGray;
  tmpCol.SelectedTextColor := clBlack;

  li := SharpEListBoxEx1.AddItem('',2);
  li.AddSubItem('',0);
  li.AddSubItem('Enabled');
  li.AddSubItem('',1);
  li.Hint := 'Click to set as default';

  lb.Invalidate;
end;

procedure TForm1.ClickItem(AText: String; AItem, ACol: Integer);
begin
  //ShowMessage(AText);
  lb.Item[AItem].SubItemImageIndex[ACol] := 0;

  {if lb.Item[AItem].SubItemImageIndex[ACol] <> -1 then
  if lb.Item[AItem].SubItemImageIndex[ACol] = 0 then
  lb.Item[AItem].SubItemImageIndex[ACol] := 1 else
  lb.Item[AItem].SubItemImageIndex[ACol] := 0;   }
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  if assigned(lb) then
  if lb.ColumnCount = 4 then begin
    lb.Column[0].Width := 50;
    lb.Column[1].Width := lb.Width - 100 - 50;
    lb.Column[2].Width := 68;
    lb.Column[3].Width := 25;
    lb.Invalidate;
  end;
end;

procedure TForm1.GetCellCursor(const ACol: Integer; AItem: TSharpEListItem;
  var ACursor: TCursor);
begin
   if ACol = 3 then
    ACursor := crHandPoint;
end;

procedure TForm1.GetCellText(const ACol: Integer; AItem:TSharpEListItem; var AColor: TColor);
begin
  if ACol = 2 then begin
    if lb.ItemIndex = AItem.ID then
    AColor := clBlue else
    AColor := clNavy;
  end;
end;

procedure TForm1.SharpEListBox1ClickItem(AText: string; AItem, ACol: Integer);
begin
  ShowMessage('Test');
end;

procedure TForm1.SharpEListBoxEx1GetCellColor(const AItem: Integer;
  var AColor: TColor);
begin
  if Aitem = lb.ItemIndex then
    AColor := clBlue;
end;

end.


