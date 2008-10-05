unit MainWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uISharpBarModule, SharpEBaseControls, SharpEButton;

type
  TMainForm = class(TForm)
    Button1: TSharpEButton;
    procedure FormPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    mInterface : ISharpBarModule;
    procedure UpdateComponentSkins;
    procedure RealignComponents;
    procedure LoadSettings;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

{ TMainForm }

procedure TMainForm.Button1Click(Sender: TObject);
begin
  mInterface.MinSize := mInterface.MinSize + 10;
  mInterface.MaxSize := mInterface.MinSize + 256;
  mInterface.BarInterface.UpdateModuleSize;
end;

procedure TMainForm.FormPaint(Sender: TObject);
begin
  mInterface.Background.DrawTo(Canvas.Handle,0,0);
end;

procedure TMainForm.LoadSettings;
begin

end;

procedure TMainForm.RealignComponents;
begin
  
end;

procedure TMainForm.UpdateComponentSkins;
begin
  Button1.SkinManager := mInterface.SkinInterface.SkinManager;
end;

end.
