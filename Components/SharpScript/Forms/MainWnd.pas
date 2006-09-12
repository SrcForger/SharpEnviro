unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    Script1: TMenuItem;
    Execute1: TMenuItem;
    Edit1: TMenuItem;
    Create1: TMenuItem;
    Generic1: TMenuItem;
    Install1: TMenuItem;
    Skin1: TMenuItem;
    procedure Install1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  MainForm: TMainForm;

implementation

uses CreateInstallScriptWnd;

{$R *.dfm}

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TMainForm.Install1Click(Sender: TObject);
begin
  CreateInstallScriptForm.show;
  self.hide;
end;

end.
