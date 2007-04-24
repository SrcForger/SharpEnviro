unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpEColorEditor, StdCtrls, JvPageList, JvExControls,
  JvComponent, ComCtrls, JvExComCtrls, JvComCtrls, XPMan, Mask, JvExMask, JvSpin,
  JvExStdCtrls, JvHtControls, sharpthemeapi, uVistaFuncs, JvLinkLabel, JvPanel,
  JvLabel, JvExExtCtrls, SharpESwatchManager;

type
  TMainWnd = class(TForm)
    XPManifest1: TXPManifest;
    SharpEColorEditor1: TSharpEColorEditor;
    SharpESwatchManager1: TSharpESwatchManager;
    procedure FormShow(Sender: TObject);
    procedure JvLinkLabel1LinkClick(Sender: TObject; LinkNumber: Integer;
      LinkText, LinkParam: string);
    procedure FormCreate(Sender: TObject);
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
  SharpEColorEditor1.Expanded := Not(SharpEColorEditor1.Expanded);

end;

procedure TMainWnd.FormCreate(Sender: TObject);
begin
  loadtheme;
  SetVistaFonts(Self);
end;

procedure TMainWnd.JvLinkLabel1LinkClick(Sender: TObject; LinkNumber: Integer;
  LinkText, LinkParam: string);
begin
  ;
end;

procedure TMainWnd.FormShow(Sender: TObject);
begin
  SharpEColorEditor1.Expanded := True;
end;

end.
