unit uActionsServiceTestWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SharpApi;

type
  TForm4 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Edit1: TEdit;
    Button5: TButton;
    Button6: TButton;
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  protected
    procedure WMSharpeactionmessage(var Message: TMessage);
      message WM_SHARPEACTIONMESSAGE;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;

implementation

uses
  uActionServiceManager, uActionsServiceTest2Wnd;

{$R *.dfm}

procedure TForm4.Button1Click(Sender: TObject);
begin
  ActionMgr := TActionMgr.Create;
  SharpEBroadCast(WM_SHARPEUPDATEACTIONS, 0, 1);
end;


procedure TForm4.Button2Click(Sender: TObject);
begin
  ActionMgr.Free;
  SharpEBroadCast(WM_SHARPEUPDATEACTIONS, 0, -1);
end;

procedure TForm4.WMSharpeactionmessage(var Message: TMessage);
begin
  case Message.LParam of
    0: ShowMessage('ID 1');
    1: ShowMessage('ID 2');
    2: ShowMessage('ID 3');
  end;
end;

procedure TForm4.Button3Click(Sender: TObject);
begin
  ActionMgr.AddAction('Test0,TestGroup,' + IntToStr(Self.Handle) + ',' +
    '0');
  ActionMgr.AddAction('Test1,TestGroup,' + IntToStr(Self.Handle) + ',' +
    '1');
  ActionMgr.AddAction('Test2,TestGroup,' + IntToStr(Self.Handle) + ',' +
    '2');
end;

procedure TForm4.Button4Click(Sender: TObject);
begin
  ActionMgr.AddAction('Test0,TestGroupMOD,' + IntToStr(Form1.Handle) + ',' +
    '0');
  ActionMgr.AddAction('Test1,TestGroupMOD,' + IntToStr(Form1.Handle) + ',' +
    '1');
  ActionMgr.AddAction('Test2,TestGroupMOD,' + IntToStr(Form1.Handle) + ',' +
    '2');
end;

procedure TForm4.Button5Click(Sender: TObject);
begin
  ActionMgr.ExecAction(Edit1.Text);
end;

procedure TForm4.Button6Click(Sender: TObject);
begin
  ActionMgr.DelAction(Edit1.Text);
end;

end.
