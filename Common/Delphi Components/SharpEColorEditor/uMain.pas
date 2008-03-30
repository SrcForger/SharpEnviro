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
    SharpESwatchManager1: TSharpESwatchManager;
    Button1: TButton;
    Button2: TButton;
    SharpEColorEditor2: TSharpEColorEditor;
    Button3: TButton;
    Button4: TButton;
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
  
  SharpEColorEditor2.ValueEditorType := vetColor;
  //SharpEColorEditor2.Value := clRed;
end;

procedure TMainWnd.FormCreate(Sender: TObject);
begin
  Self.DoubleBuffered := True;
  Self.ParentBackground := False;
   SetVistaFonts(Self);
end;

procedure TMainWnd.JvLinkLabel1LinkClick(Sender: TObject; LinkNumber: Integer;
  LinkText, LinkParam: string);
begin
  ;
end;

procedure TMainWnd.FormShow(Sender: TObject);
begin
  SharpEColorEditor2.Value := clRed;
end;

procedure TMainWnd.Button2Click(Sender: TObject);
begin
  SharpEColorEditor2.ValueEditorType := vetValue;
  SharpEColorEditor2.Description := 'Please select the alpha value for blah:';
end;

procedure TMainWnd.Button3Click(Sender: TObject);
begin
  SharpEColorEditor2.Visible := Not(SharpEColorEditor2.Visible);
end;

procedure TMainWnd.Button4Click(Sender: TObject);
begin

  SharpEColorEditor2.ValueEditorType := vetBoolean;
  SharpEColorEditor2.Description := 'Do you want the show enabled?';
end;

end.
