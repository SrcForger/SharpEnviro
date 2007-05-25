unit VersChangeWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvSpin, XPMan;

type
  TVersChangeForm = class(TForm)
    se_v1: TJvSpinEdit;
    Label1: TLabel;
    se_v2: TJvSpinEdit;
    Label2: TLabel;
    se_v3: TJvSpinEdit;
    Label3: TLabel;
    se_v4: TJvSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    lb_plist: TListBox;
    Button1: TButton;
    Button2: TButton;
    XPManifest1: TXPManifest;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  VersChangeForm: TVersChangeForm;

implementation

{$R *.dfm}

procedure TVersChangeForm.Button2Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TVersChangeForm.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
