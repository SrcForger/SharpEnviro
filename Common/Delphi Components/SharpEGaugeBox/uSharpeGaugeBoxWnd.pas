unit uSharpeGaugeBoxWnd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GR32_RangeBars, ExtCtrls, uSharpeGaugeBoxEdit, ComCtrls,
  JvExComCtrls, JvComCtrls, JvExExtCtrls, JvComponent, JvPanel, buttons,
  StdCtrls, JvExControls, JvGradient;

type
  TFrmSharpeGaugeBox = class(TForm)
    BorderPanel: TPanel;
    Shape1: TPanel;
    lblGauge: TLabel;
    GaugeBar: TGaugeBar;
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
    GaugeBoxEdit:TSharpeGaugeBox;
    function GetGaugeBar:TGaugeBar;
    
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
  GaugeBoxEdit.UpdateValue;
  GaugeBoxEdit.SetFocus;
end;

function TFrmSharpeGaugeBox.GetGaugeBar: TGaugeBar;
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
  GaugeBoxEdit.Value := GaugeBar.Position;
  GaugeBoxEdit.UpdateValue;
  GaugeBoxEdit.UpdateEditBox;
end;

end.
