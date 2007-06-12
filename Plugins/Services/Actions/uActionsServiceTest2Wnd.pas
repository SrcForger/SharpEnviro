unit uActionsServiceTest2Wnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, sharpapi;

type
  TForm1 = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  protected
    procedure WMSharpeactionmessage(var Message: TMessage);
      message WM_SHARPEACTIONMESSAGE;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.WMSharpeactionmessage(var Message: TMessage);
begin
  case Message.LParam of
    0: ShowMessage('ID 1 (MOD)');
    1: ShowMessage('ID 2 (MOD)');
    2: ShowMessage('ID 3 (MOD)');
  end;
end;

end.
