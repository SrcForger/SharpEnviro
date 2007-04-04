unit CoreConfigDummyWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TCoreConfigDummyForm = class(TForm)
    bgpanel: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;


implementation

{$R *.dfm}

procedure TCoreConfigDummyForm.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TCoreConfigDummyForm.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
