unit uTabListTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32, GR32_Image, SharpeTabList, ExtCtrls, SharpERoundPanel,
  ImgList, PngImageList, JvExControls, JvComponent, JvPageList, StdCtrls;

type
  TForm12 = class(TForm)
    PngImageList1: TPngImageList;
    SharpETabList1: TSharpETabList;
    SharpERoundPanel3: TSharpERoundPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.dfm}

procedure TForm12.Button2Click(Sender: TObject);
begin
  SharpETabList1.Clear;
end;

procedure TForm12.Button3Click(Sender: TObject);
var
  n:Integer;
  tmp: TSharpETabListItem;
begin
  tmp := SharpETabList1.Add('Item1');
  tmp.Status := IntToStr(tmp.Index);
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
  with SharpETabList1 do begin
    TabWidth := 62;
    TabColor := $00EFEFEF;
    TabSelectedColor := clWindow;
    CaptionUnSelectedColor := clBlack;
    StatusUnSelectedColor := clGreen;
    StatusSelectedColor := clGreen;

    BkgColor := clWindow;
    Align := alTop;
    Height := 25;
    TextBounds := Rect(8,8,8,4);
    IconBounds := Rect(4,4,8,4);
    TabIndex := 1;
    AutoSizeTabs := False;

    Add('Edit',0);
    Add('Add',1);
    Add('Delete',2);
  end;
end;

procedure TForm12.Button1Click(Sender: TObject);
begin
  SharpETabList1.ClickTab(SharpETabList1.TabList.Item[1]);
end;

end.
