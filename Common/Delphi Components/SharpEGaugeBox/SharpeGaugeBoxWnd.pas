unit SharpeGaugeBoxWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, SharpeGaugeBoxEdit, StdCtrls, ComCtrls,
  JvExComCtrls, JvComCtrls, uVistaFuncs, JvExExtCtrls, JvPanel, JvComponent,
  JvExtComponent, SharpApi, ImgList, PngImageList, Buttons, PngSpeedButton;

type
  TFrmSharpeGaugeBox = class(TForm)
    BorderPanel: TJvPanel;
    Shape1: TJvPanel;
    GaugeBar: TJvTrackBar;
    Panel1: TPanel;
    PngSpeedButton1: TPngSpeedButton;
    PngImageList1: TPngImageList;
    PngSpeedButton2: TPngSpeedButton;
    procedure FormShow(Sender: TObject);
    procedure GaugeBarMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure GaugeBarChange(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PngSpeedButton2Click(Sender: TObject);
    procedure PngSpeedButton1Click(Sender: TObject);
  protected
    procedure WMShellMessage(var msg : TMessagE); message WM_SHARPSHELLMESSAGE;
  private
    { Private declarations }
  public
    { Public declarations }
    NoUpdate: boolean;
    GaugeBoxEdit:TSharpeGaugeBox;
    function GetGaugeBar:TJvTrackBar;
    
  end;

implementation

{$R *.dfm}


procedure TFrmSharpeGaugeBox.FormDeactivate(Sender: TObject);
begin
  if GaugeBoxEdit <> nil then begin
    GaugeBoxEdit.UpdateValue;
  end;

  Self.Close;
end;

function TFrmSharpeGaugeBox.GetGaugeBar: TJvTrackBar;
begin
  Result := GaugeBar;
end;

procedure TFrmSharpeGaugeBox.PngSpeedButton1Click(Sender: TObject);
begin
  GaugeBar.Position := GaugeBar.Position + 1;
end;

procedure TFrmSharpeGaugeBox.PngSpeedButton2Click(Sender: TObject);
begin
  GaugeBar.Position := GaugeBar.Position - 1;
end;

procedure TFrmSharpeGaugeBox.WMShellMessage(var msg: TMessagE);
begin
  if (msg.lParam = Integer(Handle)) or (msg.lparam = Integer(Application.Handle)) then
    exit;

  case msg.WParam of
    HSHELL_WINDOWACTIVATED : FormDeactivate(self);
    HSHELL_WINDOWACTIVATED + 32768 : FormDeactivate(self);
  end;
end;

procedure TFrmSharpeGaugeBox.FormMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  GaugeBar.Position := GaugeBar.Position + 1;
end;

procedure TFrmSharpeGaugeBox.FormMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  GaugeBar.Position := GaugeBar.Position - 1;
end;

procedure TFrmSharpeGaugeBox.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_LEFT then
    GaugeBar.Position := GaugeBar.Position -1
  else if key = VK_RIGHT then
    GaugeBar.Position := GaugeBar.Position +1
  else if Key = VK_RETURN then
    FormDeactivate(Sender);
end;

procedure TFrmSharpeGaugeBox.GaugeBarChange(Sender: TObject);
begin
  if NoUpdate then exit;

  if GaugeBoxEdit <> nil then begin
    GaugeBoxEdit.Value := GaugeBar.Position;
    GaugeBoxEdit.UpdateValue;
    GaugeBoxEdit.UpdateEditBox;
  end;
  //BorderPanel.SetFocus;
end;

procedure TFrmSharpeGaugeBox.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //SharpApi.UnRegisterShellHookReceiver(Handle);
end;

procedure TFrmSharpeGaugeBox.FormCreate(Sender: TObject);
begin
  NoUpdate := False;

  // remove the window from the task list
  Setwindowlong(handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);

  // register shell hook (for close notification)
end;

procedure TFrmSharpeGaugeBox.GaugeBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  BorderPanel.SetFocus;
end;

procedure TFrmSharpeGaugeBox.FormShow(Sender: TObject);
begin
  SetVistaFonts(Self);
  //SharpApi.RegisterShellHookReceiver(Handle);
end;

end.
