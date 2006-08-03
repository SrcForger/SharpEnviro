unit uSharpDeskAlignSettingsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls;

type
  TAlignSettingsForm = class(TForm)
    Panel2: TPanel;
    bottompanel: TPanel;
    btn_ok: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    tb_y: TTrackBar;
    lb_y: TLabel;
    tb_x: TTrackBar;
    lb_x: TLabel;
    GroupBox2: TGroupBox;
    tb_wrap: TTrackBar;
    lb_wrap: TLabel;
    Label6: TLabel;
    GroupBox3: TGroupBox;
    cb_left: TRadioButton;
    cb_center: TRadioButton;
    cb_right: TRadioButton;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    edit_name: TEdit;
    btn_cancel: TButton;
    procedure btn_cancelClick(Sender: TObject);
    procedure btn_okClick(Sender: TObject);
    procedure tb_xChange(Sender: TObject);
    procedure tb_yChange(Sender: TObject);
    procedure tb_wrapChange(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;


implementation

{$R *.dfm}

procedure TAlignSettingsForm.btn_cancelClick(Sender: TObject);
begin
     self.ModalResult := mrCancel;
end;

procedure TAlignSettingsForm.btn_okClick(Sender: TObject);
begin
     if length(edit_name.Text) = 0 then
     begin
          showmessage('Please enter a name!');
          exit;
     end;
     self.ModalResult := mrOk;
end;

procedure TAlignSettingsForm.tb_xChange(Sender: TObject);
begin
     lb_x.Caption := inttostr(tb_x.Position);
end;

procedure TAlignSettingsForm.tb_yChange(Sender: TObject);
begin
     lb_y.Caption := inttostr(tb_y.Position);
end;

procedure TAlignSettingsForm.tb_wrapChange(Sender: TObject);
begin
     lb_wrap.Caption := inttostr(tb_wrap.Position);
end;

end.
