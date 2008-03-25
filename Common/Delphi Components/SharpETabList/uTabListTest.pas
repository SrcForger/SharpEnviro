unit uTabListTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32, GR32_Image, SharpeTabList, ExtCtrls, SharpERoundPanel,
  ImgList, PngImageList, JvExControls, JvComponent, JvPageList, StdCtrls,
  SharpEPageControl;

type
  TForm12 = class(TForm)
    PngImageList1: TPngImageList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    SharpEPageControl1: TSharpEPageControl;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SharpEPageControl1BtnClick(ASender: TObject;
      const ABtnIndex: Integer);
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
  SharpEPageControl1.TabList.Clear;
end;

procedure TForm12.Button3Click(Sender: TObject);
var
  n:Integer;
  tmp: TTabItem;
begin
  tmp := SharpEPageControl1.TabList.Add('Notes');
end;

procedure TForm12.Button4Click(Sender: TObject);
var
  n:Integer;
  tmp: TButtonItem;
begin
  tmp := SharpEPageControl1.Buttons.Add;
  tmp.ImageIndex := 0;

end;

procedure TForm12.SharpEPageControl1BtnClick(ASender: TObject;
  const ABtnIndex: Integer);
begin
  ShowMessage(IntToStr(ABtnIndex));
end;

end.
