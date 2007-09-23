unit frmSharpESrvWiz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TSharpESrvWizForm = class(TForm)
    edName: TEdit;
    edDescription: TEdit;
    edCopyright: TEdit;
    lblServiceName: TLabel;
    lblDescription: TLabel;
    lblCopyright: TLabel;
    cbMsgHandler: TCheckBox;
    cbActions: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lblComment: TLabel;
    procedure cbActionsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    MsgHandlerStatus: Boolean;
  public
    { Public declarations }
  end;

var
  SharpESrvWizForm: TSharpESrvWizForm;

implementation

{$R *.dfm}

procedure TSharpESrvWizForm.cbActionsClick(Sender: TObject);
begin
  cbMsgHandler.Enabled := not cbActions.Checked;
  if cbActions.Checked then
  begin
    MsgHandlerStatus := cbMsgHandler.Checked;
    cbMsgHandler.Checked := True;
  end
  else
    cbMsgHandler.Checked := MsgHandlerStatus;
end;

procedure TSharpESrvWizForm.FormCreate(Sender: TObject);
begin
  edName.Clear;
  edDescription.Clear;
  edCopyright.Clear;
end;

end.
