unit NotesNewTabWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TNotesNewTabForm = class(TForm)
    edit_name: TEdit;
    btn_ok: TButton;
    btn_cancel: TButton;
    procedure edit_nameKeyPress(Sender: TObject; var Key: Char);
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;


implementation

uses JclStrings,
     NotesWnd;

{$R *.dfm}

procedure TNotesNewTabForm.btn_okClick(Sender: TObject);
var
  Dir : String;
  s : String;
begin
  s := StrRemoveChars(edit_name.Text,['"','<','>','|','/','\','*','?','.',':']);
  if length(s) <> length(edit_name.Text) then
  begin
    if MessageBox(Handle,'The chosen tab name contains invalid characters (" < > | / \ * ? . :)!' + #10#13 +
                         'Continue to automatically remove them.','Name Contains Invalid Charaters',MB_OKCANCEL) = ID_OK then
      edit_name.Text := trim(s)
    else exit;
  end else edit_name.Text := trim(s);
  if length(trim(edit_name.Text)) <=0 then
  begin
    MessageBox(Handle,'Please enter a valid name first','Name Invalid',MB_OK);
    exit;
  end;
  Dir := TNotesForm(Owner).GetNotesDir;
  if FileExists(Dir + edit_name.Text + NOTES_EXTENSION) then
  begin
    MessageBox(Handle,'Another Notes tab with the same name already exists','Name Invalid',MB_OK);
    exit;
  end;
  modalresult := mrOk;
end;

procedure TNotesNewTabForm.btn_cancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TNotesNewTabForm.edit_nameKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    btn_ok.Click;
  end;
end;

end.
