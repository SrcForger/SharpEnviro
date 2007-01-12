unit uTabListTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32, GR32_Image, uSharpeTabList;

type
  TForm12 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    tmpTabList:TSharpETabList;
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

{$R *.dfm}

procedure TForm12.FormCreate(Sender: TObject);
begin
  tmpTabList := TSharpETabList.Create(self);
  with tmpTabList do begin
    Parent := Self;
    {TabWidth := 80;
    TabColor := clWindow;
    TabSelectedColor := clBtnFace;
    BkgColor := clWindow;
    Align := alTop;
    Height := 24;
    TextBounds := Rect(8,8,8,4);
    TabIndex := 1;
    AutoSizeTabs := True;

    Add('Services','1');
    Add('Addons');
    Add('Components','100');
    Add('Objects','5'); }
  end;
end;

end.
