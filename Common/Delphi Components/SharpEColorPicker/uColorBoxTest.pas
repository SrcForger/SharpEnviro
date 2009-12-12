unit uColorBoxTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEColorPicker, ExtCtrls, StdCtrls, XPMan,
  SharpThemeApiEx;

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    Panel1: TPanel;
    SharpEColorPicker1: TSharpEColorPicker;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  GetCurrentTheme.LoadTheme;
end;

end.
