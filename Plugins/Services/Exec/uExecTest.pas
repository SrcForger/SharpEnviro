unit uExecTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExecServiceExecute, StdCtrls, JclShell,ShellApi;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  TmpExec:TSharpExec;

implementation

{$R *.dfm}



procedure TForm1.FormCreate(Sender: TObject);
begin
  TmpExec := TSharpExec.Create;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  TmpExec.UseDebug := False;
  TmpExec.ProcessString(Edit1.Text, True, False);
  Memo1.Lines.Text := TmpExec.DebugText;
end;

end.
