unit InstallWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, XPMan, JvComponentBase, JvInterpreter;

type
  TInstallForm = class(TForm)
    m_rnotes: TMemo;
    Label1: TLabel;
    Panel1: TPanel;
    m_changelog: TMemo;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
    XPManifest1: TXPManifest;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;



implementation

{$R *.dfm}

procedure TInstallForm.Button1Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TInstallForm.Button2Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
