unit InstallWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TInstallForm = class(TForm)
    m_rnotes: TMemo;
    Label1: TLabel;
    Panel1: TPanel;
    Memo1: TMemo;
    Panel2: TPanel;
    Button1: TButton;
    Button2: TButton;
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  InstallForm: TInstallForm;

implementation

{$R *.dfm}

end.
