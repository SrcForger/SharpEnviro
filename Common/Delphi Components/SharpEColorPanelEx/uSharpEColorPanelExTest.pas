unit uSharpEColorPanelExTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uSharpEColorPanelEx,SharpEColorPanel, ExtCtrls, StdCtrls, XPMan, comctrls,
  sharpthemeapi, uVistaFuncs;

type
  TForm1 = class(TForm)
    SharpEColorPanelEx1: TSharpEColorPanelEx;
    XPManifest1: TXPManifest;
    Shape1: TShape;
    mmoDebug: TMemo;
    Timer1: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Test(ASender: TObject; AColorCode: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Test(ASender: TObject; AColorCode: Integer);
begin
  Shape1.Brush.Color := AColorCode;
  Self.Caption := IntToStr(AColorCode);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  loadtheme;
  
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  i:Integer;

  function OutputToMemo(AItem:TSharpEColorPanelExItem):String;
  begin
    Result := (AItem.Title + ': ColorCode: ' + IntToStr(AItem.ColorCode)
    + ' Color: ' + IntToStr(AItem.ColorAsTColor));

    if AItem.Expanded then
      Result := Result + ' (Expanded)';
  end;

begin
  mmoDebug.Clear;

  For i := 0 to SharpEColorPanelEx1.Items.Count-1 do
    mmoDebug.Lines.Add(OutputToMemo(SharpEColorPanelEx1.Items.Item[i]));
end;

procedure TForm1.FormShow(Sender: TObject);
begin

  SharpEColorPanelEx1.Items.Item[0].ColorAsTColor := $000000FF;
  SharpEColorPanelEx1.Items.Item[0].Title := 'Red';
  SharpEColorPanelEx1.Items.Item[1].ColorAsTColor := $0000FF00;
  SharpEColorPanelEx1.Items.Item[1].Title := 'Green';
  SharpEColorPanelEx1.Items.Item[2].ColorAsTColor := $00FF0000;
  SharpEColorPanelEx1.Items.Item[2].Title := 'Blue';
  SharpEColorPanelEx1.Items.Item[3].ColorAsTColor := clLime;
  SharpEColorPanelEx1.Items.Item[3].Title := 'Lime';
  SharpEColorPanelEx1.Items.Item[4].ColorAsTColor := clOlive;
  SharpEColorPanelEx1.Items.Item[4].Title := 'Olive';
  SharpEColorPanelEx1.Items.Item[5].ColorCode := -1;
  SharpEColorPanelEx1.Items.Item[5].Title := 'Scheme 1';

  SharpEColorPanelEx1.Items.Item[5].Expanded := True;
  SharpEColorPanelEx1.Items.Item[2].Expanded := True;
  Timer1Timer(nil);

  SetVistaFonts(Self);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SharpEColorPanelEx1.Items.Item[0].ColorCode := $00FF0000;
end;

end.
