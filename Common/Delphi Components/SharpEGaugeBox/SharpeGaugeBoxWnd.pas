unit SharpeGaugeBoxWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_RangeBars, ExtCtrls, SharpeGaugeBoxEdit, StdCtrls, ComCtrls,
  JvExComCtrls, JvComCtrls, uVistaFuncs, JvExExtCtrls, JvPanel, JvComponent,
  JvExtComponent;

type
  TFrmSharpeGaugeBox = class(TForm)
    BorderPanel: TJvPanel;
    Shape1: TJvPanel;
    lblGauge: TLabel;
    GaugeBar: TJvTrackBar;
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
  private
    { Private declarations }
  public
    { Public declarations }
    NoUpdate: boolean;
    GaugeBoxEdit:TSharpeGaugeBox;
    function GetGaugeBar:TJvTrackBar;
    
  end;

var
  FrmSharpeGaugeBox: TFrmSharpeGaugeBox;

implementation

uses
  SharpAPI;

{$R *.dfm}


procedure TFrmSharpeGaugeBox.FormDeactivate(Sender: TObject);
begin
  Self.Hide;

  if GaugeBoxEdit <> nil then begin
    GaugeBoxEdit.UpdateValue;
  end;
end;

function TFrmSharpeGaugeBox.GetGaugeBar: TJvTrackBar;
begin
  Result := GaugeBar;
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
  BorderPanel.SetFocus;
end;

procedure TFrmSharpeGaugeBox.FormCreate(Sender: TObject);
begin
  NoUpdate := False;

  // remove the window from the task list
  Setwindowlong(handle, GWL_EXSTYLE, WS_EX_TOOLWINDOW);
end;

procedure TFrmSharpeGaugeBox.GaugeBarMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  BorderPanel.SetFocus;
end;

procedure TFrmSharpeGaugeBox.FormShow(Sender: TObject);
begin
  SetVistaFonts(Self);
end;

end.
