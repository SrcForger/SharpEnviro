unit uTabListTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32, GR32_Image, uSharpeTabList, ExtCtrls, SharpERoundPanel,
  ImgList, PngImageList, JvExControls, JvComponent, JvPageList;

type
  TForm12 = class(TForm)
    PngImageList1: TPngImageList;
    SharpETabList1: TSharpETabList;
    SharpERoundPanel3: TSharpERoundPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.dfm}

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

end.
