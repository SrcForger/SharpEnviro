{
Source Name: uSharpeGaugeBoxEdit
Description: A SharpE Value Edit Box
Copyright (C) Pixol (pixol@sharpe-shell.org)

Source Forge Site
https://sourceforge.net/projects/sharpe/

Sharpe-Shell Team
http://www.sharpe-shell.org

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License, or (at your option) any later version.

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

unit SharpEGaugeBoxEdit;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Buttons,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  ExtCtrls,
  SharpApi,
  JvxSlider,
  GR32_RangeBars,
  ComCtrls,
  JvEdit,
  JvPanel,
  GR32;

  {$R SharpEGaugeBoxBitmaps.res}

type
  TChangeValueEvent = procedure(Sender: TObject; Value: Integer) of object;
  TArrowColor = (acBlue, acCyan, acGray, acGreen, acOrange, acPurple, acRed, acYellow, acDefault);
  TPopPosition = (ppTop, ppBottom, ppLeft, ppRight);
type
  TSharpeGaugeBox = class(TCustomPanel)
  private
    FBtnGauge: TSpeedButton;
    FValueEdit: TEdit;
    FBackPanel: TPanel;
    FEnabled: Boolean;
    FPercentDisplay: Boolean;
    FOnChangeValue: TChangeValueEvent;
    FMax: Integer;
    FMin: Integer;
    FValue: Integer;
    FPrefix: string;
    FSuffix: string;
    FArrowColor: TArrowColor;
    FFlatStyle: Boolean;
    FPopPosition: TPopPosition;
    FDescription: string;

    function CreateInitialControls: Boolean;

    procedure BtnGaugeClick(Sender: TObject);
    procedure BtnGaugeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SetEnabled(const Value: boolean); reintroduce;
    procedure SetMax(const Value: Integer);
    procedure SetMin(const Value: Integer);
    procedure SetPrefix(const Value: string);
    procedure SetSuffix(const Value: string);
    procedure SetValue(const Value: Integer);

    procedure ValueEditKeyPress(Sender: TObject; var Key: Char);
    procedure ValueEditExit(Sender: TObject);
    procedure ValueEditClick(Sender: Tobject);
    procedure ValueEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    procedure PopAnimateWindow(Popper: TControl; PopWindow: TWinControl);

    procedure SetPopPosition(const Value: TPopPosition);
    procedure SetDescription(const Value: string);
    procedure SetPercentDisplay(const Value : boolean);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Paint; override;
    procedure UpdateValue;
    procedure UpdateEditBox;

  protected
  published
    property Owner;
    property Align;
    property Color;
    property Min: Integer read FMin write SetMin;
    property Max: Integer read FMax write SetMax;
    property Value: Integer read FValue write SetValue;

    property Prefix: string read FPrefix write SetPrefix;
    property Suffix: string read FSuffix write SetSuffix;
    property Description: string read FDescription write SetDescription;
    property Enabled;
    property PopPosition: TPopPosition read FPopPosition write SetPopPosition;
    property PercentDisplay: boolean read FPercentDisplay write SetPercentDisplay;

    property OnChangeValue: TChangeValueEvent read FOnChangeValue write FOnChangeValue;
  end;

procedure Register;

implementation

uses
  SharpeGaugeBoxWnd;

procedure Register;
begin
  RegisterComponents('SharpE_Common', [TSharpeGaugeBox]);
end;

{ TSharpeGaugeBox }

constructor TSharpeGaugeBox.Create(AOwner: TComponent);
begin
  inherited;

  Width := 145;
  Height := 21;

  BorderStyle := bsNone;
  BevelInner := bvNone;
  BevelOuter := bvNone;
  BevelKind := bkNone;
  ParentBackground := False;

  FPercentDisplay := False;
  FEnabled := True;
  FValue := 100;
  FMin := -100;
  FMax := 100;
  FFlatStyle := True;
  FPopPosition := ppBottom;
  FDescription := 'Adjust to set the transparency';

  FArrowColor := acGray;

  Ctl3D := False;

  CreateInitialControls;

end;

procedure TSharpeGaugeBox.Paint;
var
  MBmp: TBitmap32;
  R: TRect;

begin
  R := ClientRect;

  mBmp := TBitmap32.Create;
  try
    mBmp.Height := ClientRect.Bottom;
    mBmp.Width := ClientRect.Right;
    MBmp.Clear(Color32(Color));
    FBtnGauge.Enabled := Self.Enabled;
    FValueEdit.Enabled := Self.Enabled;

  finally
    Canvas.CopyRect(ClientRect, mBmp.canvas, ClientRect);
    mBmp.Free;

  end;
end;

procedure TSharpeGaugeBox.SetEnabled(const Value: boolean);
begin
  FBtnGauge.Enabled := Value;
  FValueEdit.Enabled := Value;
end;

function TSharpeGaugeBox.CreateInitialControls: Boolean;
var
  R: TRect;
  ButtonWidth: Integer;
begin
  Result := True;

  // Get Initial Values
  R := Rect(Self.Left, Self.Top, Self.Width, Self.Height);
  ButtonWidth := 15;

  FBackPanel := TPanel.Create(Self);
  with FBackPanel do
  begin
    Parent := Self;
    Align := alClient;

    BorderStyle := bsNone;
    BevelInner := bvNone;
    BevelOuter := bvNone;
    BevelKind := bkNone;
    ParentBackground := False;
    Color := Self.Color;
  end;

  FBtnGauge := TSpeedButton.Create(FBackPanel);
  with FBtnGauge do
  begin
    Parent := FBackPanel;
    Align := alRight;
    Width := ButtonWidth;
    Font.Style := [fsBold];
    Caption := '';
    Flat := True;
    Color := Self.Color;
    OnMouseUp := BtnGaugeMouseUp;
  end;

  FBtnGauge.Glyph.LoadFromResourceName(HInstance,'DROPLEFT_GRAY');

  {FSpacer := TShape.Create(FBackPanel);
  with FSpacer do
  begin
    Parent := FBackPanel;
    Width := 4;
    Align := alLeft;
    ParentBackground := False;
    Pen.Color := Self.Color;
    Brush.Color := Self.Color;
  end;     }

  FValueEdit := TEdit.Create(FBackPanel);
  with FValueEdit do
  begin
    Parent := FBackPanel;
    Align := alClient;
    Text := Format('%s%d%s', [FPrefix, FValue, FSuffix]);
    OnKeyPress := ValueEditKeyPress;
    OnKeyDown := ValueEditKeyDown;
    OnExit := ValueEditExit;
    OnClick := ValueEditClick;
    //Flat := True;
    //Ctl3D := False;
    //BorderStyle := bsNone;
    font.Name := 'Arial';
    font.Size := 8;
    MaxLength := 6;
  end;

end;

destructor TSharpeGaugeBox.Destroy;
begin

  inherited;
end;

procedure TSharpeGaugeBox.BtnGaugeClick(Sender: TObject);
var
  tmpGaugeBar: TGaugeBar;
begin
  UpdateValue;
  UpdateEditBox;

  if not (assigned(FrmSharpeGaugeBox)) then
    FrmSharpeGaugeBox := TFrmSharpeGaugeBox.Create(Application.MainForm);

  FrmSharpeGaugeBox.GaugeBoxEdit := Self;
  tmpGaugeBar := FrmSharpeGaugeBox.GetGaugeBar;
  tmpGaugeBar.Max := FMax;
  tmpGaugeBar.Position := FValue;
  tmpGaugeBar.Min := FMin;
  FrmSharpeGaugeBox.lblGauge.Caption := FDescription;

  PopAnimateWindow(Self, FrmSharpeGaugeBox);
end;

procedure TSharpeGaugeBox.SetMax(const Value: Integer);
begin
  FMax := Value;
end;

procedure TSharpeGaugeBox.SetMin(const Value: Integer);
begin
  FMin := Value;
end;

procedure TSharpeGaugeBox.SetValue(const Value: Integer);
begin
  FValue := Value;
  UpdateEditBox;
end;

procedure TSharpeGaugeBox.SetPrefix(const Value: string);
begin
  FPrefix := Value;
  UpdateEditBox;
end;

procedure TSharpeGaugeBox.SetSuffix(const Value: string);
begin
  FSuffix := Value;
  UpdateEditBox;
end;

procedure TSharpeGaugeBox.SetPercentDisplay(const Value : boolean);
begin
  FPercentDisplay := Value;
  UpdateEditBox;
end;

procedure TSharpeGaugeBox.UpdateEditBox;
var
  temp : integer;
begin
  if FPercentDisplay then
     temp := round(FValue / FMax * 100)
     else temp := FValue;
  FValueEdit.Text := Format('%s%d%s', [FPrefix, temp, FSuffix]);
end;

procedure TSharpeGaugeBox.ValueEditKeyPress(Sender: TObject; var Key: Char);
begin

  if not (key in ['0'..'9', #8, '-']) then
    key := #0; //#8 = BackSpace
end;

procedure TSharpeGaugeBox.ValueEditExit(Sender: TObject);
begin
  UpdateValue;
  UpdateEditBox;
  FValueEdit.SelectAll;
end;

procedure TSharpeGaugeBox.ValueEditClick(Sender: Tobject);
begin
  FValueEdit.SelectAll;
end;

procedure TSharpeGaugeBox.PopAnimateWindow(Popper: TControl;
  PopWindow: TWinControl);
var
  xPos: TPoint;
  h, w: integer;
begin
  h := PopWindow.Height;

  Self.Canvas.Font.Size := 8;
  w := Self.Canvas.TextWidth(FDescription)+15;
  if w < 100 then
    w := 100;

  xPos := Popper.ClientToScreen(Point(0, Popper.ClientHeight));

  case FPopPosition of
    ppTop:
      begin
        xPos.Y := xPos.Y - self.Height - h - 3;
        xPos.X := xpos.X + 1;
      end;
    ppBottom: xPos.X := xpos.X + 1;
    ppLeft:
      begin
        xPos.X := xPos.X - Self.Width + 1;
        xPos.Y := xPos.Y - self.Height + 1;
      end;
    ppRight:
      begin
        xPos.X := xPos.X + self.Width;
        xPos.Y := xPos.Y - self.Height;
      end;
  end;

  PopWindow.Left := xPos.X;
  PopWindow.Top := xPos.Y;
  PopWindow.Width := w;
  PopWindow.Height := h;

  PopWindow.Show;
  PopWindow.SetFocus;
end;

procedure TSharpeGaugeBox.BtnGaugeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  BtnGaugeClick(Sender);
end;

procedure TSharpeGaugeBox.UpdateValue;
var
  s: string;
  iVal: Integer;
begin
  // Search for Prefix
  s := FValueEdit.Text;

  if (FPrefix <> '') and (Pos(fPrefix, s) = 1) then
    delete(s, 1, Length(fPrefix));
  if (fSuffix <> '') and (Pos(Fsuffix, s) > 0) then
    delete(s, Length(s) - Length(fSuffix) + 1, Length(fSuffix));

  if (length(s) <> 0) then
    if TryStrToInt(S, iVal) then
    begin
      if FPercentDisplay then
         iVal := round(iVal * FMax / 100); 

      if iVal > FMax then
      begin
        iVal := FMax;
        FValue := iVal;
        UpdateEditBox;
      end;

      if iVal < FMin then
      begin
        iVal := FMin;
        FValue := iVal;
        UpdateEditBox;
      end;

      FValue := iVal;
    end;

  FValueEdit.SelectAll;

  if assigned(FOnChangeValue) then
    FOnChangeValue(Self, iVal);
end;

procedure TSharpeGaugeBox.ValueEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
  begin
    UpdateValue;
    UpdateEditBox;
    Self.SetFocus;
  end
  else if (key = VK_DOWN) then
    BtnGaugeClick(Sender);
end;

procedure TSharpeGaugeBox.SetPopPosition(const Value: TPopPosition);
begin
  FPopPosition := Value;
end;

procedure TSharpeGaugeBox.SetDescription(const Value: string);
begin
  FDescription := Value;
end;

end.

