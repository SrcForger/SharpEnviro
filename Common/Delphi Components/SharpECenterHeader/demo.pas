unit demo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SharpECenterHeader, SharpERoundPanel, pngimage;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    SharpERoundPanel1: TSharpERoundPanel;
    Label1: TLabel;
    SharpERoundPanel2: TSharpERoundPanel;
    Label2: TLabel;
    Image1: TImage;
    SharpERoundPanel3: TSharpERoundPanel;
    Label3: TLabel;
    SharpERoundPanel4: TSharpERoundPanel;
    Label4: TLabel;
    Image2: TImage;
    Panel2: TPanel;
    SharpERoundPanel5: TSharpERoundPanel;
    Label5: TLabel;
    SharpERoundPanel6: TSharpERoundPanel;
    Label6: TLabel;
    Image3: TImage;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  header: TSharpECenterHeader;
begin
  header := TSharpECenterHeader.Create(Panel1);
  header.Parent := Panel1;
  header.Title := 'Icon Details';
  header.Description := 'This configures various icon stuff This configures various icon stuff This configures various icon stuff This configures various icon stuff';
  header.Align := alTop;
end;

end.
