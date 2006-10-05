unit Test;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  uScHotkeyEdit,
  uScHotkeyMgr,
  uHotkeyServiceMain;

type
  TForm1 = class(TForm)
    ScHotkeyEdit1: TScHotkeyEdit;
    Edit1: TEdit;
    Button1: TButton;
    Edit2: TEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    procedure ScHotkeyEdit1Change(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure HotkeyEvent(Sender:TObject;HotkeyID:Integer);
  end;

var
  Form1: TForm1;
  Hkm: TScHotkeyManager;
  hks: THotkeyService;

implementation

{$R *.dfm}

procedure TForm1.ScHotkeyEdit1Change(Sender: TObject);
begin
  Edit1.Text := IntToStr(ScHotkeyEdit1.Keycode);
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Newitem: TScHotkeyItem;
begin
  if not assigned(Hkm) then
    Hkm := TScHotkeyManager.Create;

  NewItem := hkm.Add('Test','notepad',ScHotkeyEdit1.Modifier,ScHotkeyEdit1.Key);
  Hkm.RegisterKey(Newitem.Id);

  Hkm.OnHotkeyEvent := HotkeyEvent;
end;

procedure TForm1.HotkeyEvent(Sender: TObject; HotkeyID: Integer);
begin
  ShowMessage(IntToStr(HotkeyID));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Hks := THotkeyService.Create;
  hks.AddHotkeys;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  hks.UnregisterAllKeys;
end;

end.

