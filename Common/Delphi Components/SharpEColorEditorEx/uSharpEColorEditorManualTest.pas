unit uSharpEColorEditorManualTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SharpEColorEditorEx, ExtCtrls, StdCtrls, XPMan, comctrls,
  sharpthemeapi, uVistaFuncs, SharpESwatchManager, SharpEColorEditor;

type
  TForm2 = class(TForm)
    SharpESwatchManager1: TSharpESwatchManager;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
var
  tmp: TSharpEColorEditorEx;
  tmpItem: TSharpEColorEditorExItem;
begin

  try
    LockWindowUpdate(Self.Handle);
    tmp := TSharpEColorEditorEx.Create(Self);
    tmp.Parent := Self;

    tmp.BeginUpdate;

    tmp.SwatchManager := SharpESwatchManager1;
    tmp.Align := alClient;
    tmp.Height := 200;
    tmp.Color := clWindow;

    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);
    tmpItem := TSharpEColorEditorExItem.Create(tmp.Items);

    tmp.Items.Item[0].Title := 'New';
    tmp.Items.Item[0].ColorCode := clRed;

    tmp.Items.Item[1].Title := 'New2';
    tmp.Items.Item[1].ColorCode := clRed;

    tmp.Items.Item[1].Title := 'New3';

    // tmp.Items.Item[1].Expanded;
  finally
    lockwindowupdate(0);
    tmp.EndUpdate;

    tmp.Items.Item[1].ColorEditor.ValueEditorType := vetValue;
    tmp.Items.Item[1].ColorEditor.Description := 'Please select the value:';
  end;

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  loadtheme;
end;

end.

