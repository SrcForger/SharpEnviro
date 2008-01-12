unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, PngImageList, ComCtrls, Buttons,
  PngSpeedButton, SharpEListBoxEx, ImgList, ExtCtrls, JvExStdCtrls, JvListBox,
  JvComboListBox;

type
  TForm1 = class(TForm)
    Button1: TButton;
    PngSpeedButton1: TPngSpeedButton;
    SharpEListBoxEx1: TSharpEListBoxEx;
    col1: TPngImageList;
    PngImageList1: TPngImageList;
    Button2: TButton;
    procedure SharpEListBoxEx1MeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);

    procedure Button1Click(Sender: TObject);
    procedure SharpEListBoxEx1GetCellText(Sender: Tobject; const ACol: Integer;
      AItem: TSharpEListItem; var AColText: string);
    procedure SharpEListBoxEx1GetCellImageIndex(Sender: Tobject; const ACol: Integer;
      AItem: TSharpEListItem; var AImageIndex: Integer;
      const ASelected: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure SharpEListBoxEx1GetCellClickable(Sender: Tobject; const ACol: Integer;
      AItem: TSharpEListItem; var AClickable: Boolean);
    procedure SharpEListBoxEx1DblClickItem(Sender: TObject; const ACol: Integer;
      AItem: TSharpEListItem);
    procedure SharpEListBoxEx1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure SharpEListBoxEx1GetCellColor(Sender: TObject;
      const AItem: TSharpEListItem; var AColor: TColor);
    procedure SharpEListBoxEx1GetCellCursor(Sender: TObject;
      const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);

  private
    { Private declarations }
    Procedure GetCellCursor(Sender: Tobject; const ACol:Integer; AItem:TSharpEListItem; var ACursor:TCursor);
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
  li.AddSubItem(IntToStr(SharpEListBoxEx1.Count),0);
  li.AddSubItem('<u>Delete</u>',1);
  li.AddSubItem('',false);
  li.Level := SharpEListBoxEx1.Count-1;
  li.Hint := 'Click to set as default';

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SharpEListBoxEx1.Columns.Add(Self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //SharpEListBoxEx1.DoubleBuffered := True;
  Self.DoubleBuffered := True;
end;

procedure TForm1.GetCellCursor(Sender: Tobject; const ACol: Integer; AItem: TSharpEListItem;
  var ACursor: TCursor);
begin
   if ACol >= 2 then
    ACursor := crHandPoint;
end;

procedure TForm1.SharpEListBoxEx1DblClickItem(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem);
begin
  ShowMessage('dbl');
end;

procedure TForm1.SharpEListBoxEx1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var
  n: Integer;
begin
  n := SharpEListBoxEx1.ItemAtPos(point(x,y),True);
  if ((n <> -1) and (SharpEListBoxEx1.ItemIndex <> -1) and (n <> SharpEListBoxEx1.ItemIndex)) then begin
    Accept := True;
    SharpEListBoxEx1.Items.Exchange(n,SharpEListBoxEx1.ItemIndex);
  end;
end;

procedure TForm1.SharpEListBoxEx1GetCellClickable(Sender: Tobject; const ACol: Integer;
  AItem: TSharpEListItem; var AClickable: Boolean);
begin
  if AItem.ID = 1 then
    AClickable := False;
end;

procedure TForm1.SharpEListBoxEx1GetCellColor(Sender: TObject;
  const AItem: TSharpEListItem; var AColor: TColor);
begin
  if AItem.ID = 1 then
    AColor := clRed;
end;

procedure TForm1.SharpEListBoxEx1GetCellCursor(Sender: TObject;
  const ACol: Integer; AItem: TSharpEListItem; var ACursor: TCursor);
begin
  ACursor := crHandPoint;
end;

procedure TForm1.SharpEListBoxEx1GetCellImageIndex(Sender: Tobject; const ACol: Integer;
  AItem: TSharpEListItem; var AImageIndex: Integer; const ASelected: Boolean);
begin
  if ACol = 0 then begin
    if ASelected then AImageIndex := 2 else
    AImageIndex := 10;
  end;
end;

procedure TForm1.SharpEListBoxEx1GetCellText(Sender: Tobject; const ACol: Integer;
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


