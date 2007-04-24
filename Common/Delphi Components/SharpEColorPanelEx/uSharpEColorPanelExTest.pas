unit uSharpEColorPanelExTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEColorEditorEx, ExtCtrls, StdCtrls, XPMan, comctrls,
  sharpthemeapi, uVistaFuncs, SharpESwatchManager;

type
  TForm1 = class(TForm)
    XPManifest1: TXPManifest;
    Shape1: TShape;
    mmoDebug: TMemo;
    Timer1: TTimer;
    SharpEColorEditorEx1: TSharpEColorEditorEx;
    SharpESwatchManager1: TSharpESwatchManager;
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

  function OutputToMemo(AItem:TSharpEColorEditorExItem):String;
  begin
    Result := (AItem.Title + ': ColorCode: ' + IntToStr(AItem.ColorCode)
    + ' Color: ' + IntToStr(AItem.ColorAsTColor));

    if AItem.Expanded then
      Result := Result + ' (Expanded)';
  end;

begin
  mmoDebug.Clear;

  For i := 0 to SharpEColorEditorEx1.Items.Count-1 do
    mmoDebug.Lines.Add(OutputToMemo(SharpEColorEditorEx1.Items.Item[i]));
end;

procedure TForm1.FormShow(Sender: TObject);
begin

  SharpEColorEditorEx1.Items.Item[0].ColorAsTColor := $000000FF;
  SharpEColorEditorEx1.Items.Item[0].Title := 'Bar';
  SharpEColorEditorEx1.Items.Item[1].ColorAsTColor := $0000FF00;
  SharpEColorEditorEx1.Items.Item[1].Title := 'Bar Shadow';
  SharpEColorEditorEx1.Items.Item[2].ColorAsTColor := $00FF0000;
  SharpEColorEditorEx1.Items.Item[2].Title := 'Bar Glow';
  SharpEColorEditorEx1.Items.Item[3].ColorAsTColor := clLime;
  SharpEColorEditorEx1.Items.Item[3].Title := 'Text Color';
  SharpEColorEditorEx1.Items.Item[4].ColorAsTColor := clOlive;
  SharpEColorEditorEx1.Items.Item[4].Title := 'Text Shadow';
  SharpEColorEditorEx1.Items.Item[5].ColorCode := -1;
  SharpEColorEditorEx1.Items.Item[5].Title := 'Text Hover Glow';

  SharpEColorEditorEx1.Items.Item[5].Expanded := True;
  SharpEColorEditorEx1.Items.Item[2].Expanded := True;
  Timer1Timer(nil);

  SetVistaFonts(Self);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  SharpEColorEditorEx1.Items.Item[0].ColorCode := $00FF0000;
end;

end.
