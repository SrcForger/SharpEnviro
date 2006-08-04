unit SettingsWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, GR32_RangeBars, SharpApi, XPMan, Menus;

type
  TSettingsForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Label4: TLabel;
    Label1: TLabel;
    OpenFile: TOpenDialog;
    XPManifest1: TXPManifest;
    edit_format: TEdit;
    Button3: TButton;
    PopupMenu1: TPopupMenu;
    N213046HHMMSS1: TMenuItem;
    N213046HHMMSS3: TMenuItem;
    N213046HHMMSS2: TMenuItem;
    cb_large: TRadioButton;
    cb_medium: TRadioButton;
    cb_small: TRadioButton;
    N21304619062006HHMMSSDDMMYYYY1: TMenuItem;
    procedure N213046HHMMSS3Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    ActionStr : String;
  end;


implementation

{$R *.dfm}

procedure TSettingsForm.Button1Click(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

procedure TSettingsForm.Button2Click(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TSettingsForm.Button3Click(Sender: TObject);
begin
  PopUpMenu1.PopupComponent := Button3;
  PopUpMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;

procedure TSettingsForm.N213046HHMMSS3Click(Sender: TObject);
begin
  edit_format.Text := TMenuItem(SendeR).Hint;
end;

end.
