unit uTabListTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32, GR32_Image, SharpeTabList, ExtCtrls, SharpERoundPanel,
  ImgList, PngImageList, JvExControls, JvComponent, JvPageList, StdCtrls,
  SharpEPageControl, uvistafuncs;

type
  TForm12 = class(TForm)
    PngImageList1: TPngImageList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    SharpEPageControl1: TSharpEPageControl;
    Button4: TButton;
    btnToggleVisibility: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure SharpEPageControl1BtnClick(ASender: TObject;
      const ABtnIndex: Integer);
    procedure FormShow(Sender: TObject);
    procedure btnToggleVisibilityClick(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.dfm}

procedure TForm12.btnToggleVisibilityClick(Sender: TObject);
var
  i: Integer;
begin
  with SharpEPageControl1.TabList do
  begin
    for i := 0 to Count - 1 do
      TabItem[i].Visible := not TabItem[i].Visible;
  end;
  SharpEPageControl1.Invalidate;
  Self.Repaint;
end;

procedure TForm12.Button2Click(Sender: TObject);
begin
  SharpEPageControl1.TabList.Clear;
end;

procedure TForm12.Button3Click(Sender: TObject);
var
  tmp: TTabItem;
begin
  SharpEPageControl1.TabList.Add('Long Notes!!!!!!');
  SharpEPageControl1.TabList.Add('Longish Notes');
  tmp := SharpEPageControl1.TabList.Add('Notes');
  tmp.ImageIndex := 0;
end;

procedure TForm12.Button4Click(Sender: TObject);
var
  tmp: TButtonItem;
begin
  tmp := SharpEPageControl1.Buttons.Add;
  tmp.ImageIndex := 0;

end;

procedure TForm12.FormShow(Sender: TObject);
begin
  SetVistaFonts(Self);
end;

procedure TForm12.SharpEPageControl1BtnClick(ASender: TObject;
  const ABtnIndex: Integer);
begin
  ShowMessage(IntToStr(ABtnIndex));
end;

end.
