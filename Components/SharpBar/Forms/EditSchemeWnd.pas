unit EditSchemeWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SharpThemeApi, SharpApi, JvSimpleXML, uSharpEColorBox;

type
  TEditSchemeForm = class(TForm)
    ColorPanel: TPanel;
    Panel2: TPanel;
    btn_ok: TButton;
    btn_cancel: TButton;
    Panel1: TPanel;
    edit_name: TEdit;
    Label1: TLabel;
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    procedure InitForm(SchemeName : String);
  end;


implementation

uses JclStrings;

{$R *.dfm}

procedure TEditSchemeForm.InitForm(SchemeName : String);
var
  n : integer;
  cc : TSharpESkinColor;
  lb : TLabel;
  scb : TSharpEColorBox;
begin
  for n := ColorPanel.ComponentCount - 1 downto 0 do
      ColorPanel.Components[n].Free;

  for n := 0 to SharpThemeApi.GetSchemeColorCount - 1 do
  begin
    cc := SharpThemeApi.GetSchemeColorByIndex(n);

    lb := TLabel.Create(ColorPanel);
    lb.ShowHint := True;
    lb.Parent := ColorPanel;
    lb.Top := 12 + n * 24;
    lb.Left := 12;
    lb.Caption := cc.Name;
    lb.Hint := cc.Tag;

    scb := TSharpEColorBox.Create(ColorPanel);
    scb.Parent := ColorPanel;
    scb.Top := 12 + n * 24;
    scb.Left := 225;
    scb.Color := cc.Color;
  end;

  n := Height - ColorPanel.Height - Panel1.Height - Panel2.Height;
  Height := Panel1.Height + Panel2.Height + SharpThemeApi.GetSchemeColorCount * 24 + 12 + 12 + n;
end;

procedure TEditSchemeForm.FormDestroy(Sender: TObject);
var
  n : integer;
begin
  for n := ColorPanel.ComponentCount - 1 downto 0 do
      ColorPanel.Components[n].Free;
end;

procedure TEditSchemeForm.btn_okClick(Sender: TObject);
begin
  edit_name.Text := StrRemoveChars(edit_name.Text,['"','<','>','|','/','\','*','?','.',':']);
  if length(trim(edit_name.Text)) <=0 then
  begin
    Showmessage('Please enter a valid name first');
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TEditSchemeForm.btn_cancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
