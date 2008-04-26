unit PlayerSelectWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, JvExMask, JvToolEdit;

type
  TPlayerSelectForm = class(TForm)
    Label1: TLabel;
    edit_player: TJvFilenameEdit;
    btn_ok: TButton;
    btn_cancel: TButton;
    procedure btn_okClick(Sender: TObject);
    procedure btn_cancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TPlayerSelectForm.btn_okClick(Sender: TObject);
begin
  if not FileExists(edit_player.Text) then
     showmessage('Please select a valid media player')
     else ModalResult := mrOk;
end;

procedure TPlayerSelectForm.btn_cancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
