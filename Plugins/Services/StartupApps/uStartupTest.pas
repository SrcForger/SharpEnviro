unit uStartupTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  uStartupList,
  uSettingsWnd,
  uStartup;

{$R *.dfm}

procedure TForm1.btn1Click(Sender: TObject);
begin
  tempstartup := TStartup.Create;
  StartupList := TStartupStore.Create;

  tempstartup.UpdateStartupItems;
  tempstartup.CreateIconBitmaps;
  tempstartup.UpdateStartupItemsView(false, stNone);

  FrmSettingsWnd.Show;
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  tempstartup := TStartup.Create;
  TempStartup.LoadStartupApps;
end;

end.

