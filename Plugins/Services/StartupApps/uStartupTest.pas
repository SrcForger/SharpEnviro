unit uStartupTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, SharpApi;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Label1: TLabel;
    Panel1: TPanel;
    btn1: TButton;
    btn2: TButton;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
  private
    { Private declarations }
    procedure AddRegEvent(key: string; value: string);
    procedure AddDirEvent(fileName : string);
  public
    { Public declarations }

  end;

var
  Form1: TForm1;

implementation

uses
  uStartup;

{$R *.dfm}

procedure TForm1.AddDirEvent(fileName : string);
var
  s: string;
begin
  s := ExtractFileDir(fileName) + ' - ' +  fileName;
  TStartup.DebugMsg('DIR: ' + s, DMT_INFO);
end;

procedure TForm1.AddRegEvent(key, value: string);
var
  s: string;
begin
  s := format('%s - %s',[key,value]);
  TStartup.DebugMsg('REG: ' + s, DMT_INFO);
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  //tempstartup := TStartup.Create;
  //StartupList := TStartupStore.Create;

  //tempstartup.UpdateStartupItems;
 // tempstartup.CreateIconBitmaps;
 // tempstartup.UpdateStartupItemsView(false, stNone);

  //FrmSettingsWnd.Show;
end;

procedure TForm1.btn2Click(Sender: TObject);
var
  tmp:TStartup;
begin
  Memo1.Lines.Clear;
  
  tmp := TStartup.Create;
  tmp.Debug := true;
  tmp.OnAddRegEvent := AddRegEvent;
  tmp.OnAddDirEvent := AddDirEvent;
  
  tmp.LoadStartupApps;
  
end;

end.

