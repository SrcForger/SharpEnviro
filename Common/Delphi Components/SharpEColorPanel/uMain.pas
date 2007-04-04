unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpEColorPanel, StdCtrls, JvPageList, JvExControls,
  JvComponent, ComCtrls, JvExComCtrls, JvComCtrls, XPMan, Mask, JvExMask, JvSpin,
  JvExStdCtrls, JvHtControls;

type
  TMainWnd = class(TForm)
    SharpEColorPanel1: TSharpEColorPanel;
    SharpEColorPanel2: TSharpEColorPanel;
    XPManifest1: TXPManifest;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainWnd: TMainWnd;

implementation

{$R *.dfm}

procedure TMainWnd.Button1Click(Sender: TObject);
begin
  //SharpEColorPanel1.Expanded := Not(SharpEColorPanel1.Expanded);

end;

end.
